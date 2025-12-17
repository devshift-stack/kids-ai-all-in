import 'dart:io';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// Audiogramm-Import Service
///
/// Ermöglicht Eltern:
/// - Audiogramm-Bild hochladen (Foto vom HNO-Arzt)
/// - Manuelle Eingabe der Hörschwellen
/// - Automatische Frequenz-Anpassung der App
class AudiogramService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;
  final ImagePicker _imagePicker = ImagePicker();

  AudiogramService(this._ref);

  // ============================================================
  // AUDIOGRAMM SPEICHERN/LADEN
  // ============================================================

  /// Speichert Audiogramm-Daten
  Future<void> saveAudiogram(AudiogramData audiogram) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return;

    try {
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('audiograms')
          .add({
        ...audiogram.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Aktuelles Audiogramm in settings speichern
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('audiogram')
          .set(audiogram.toMap());

      if (kDebugMode) print('Audiogramm gespeichert');
    } catch (e) {
      if (kDebugMode) print('Audiogramm speichern Fehler: $e');
      rethrow;
    }
  }

  /// Lädt aktuelles Audiogramm
  Future<AudiogramData?> loadCurrentAudiogram() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return null;

    try {
      final doc = await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('audiogram')
          .get();

      if (doc.exists && doc.data() != null) {
        return AudiogramData.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Audiogramm laden Fehler: $e');
      return null;
    }
  }

  /// Holt Audiogramm-Historie
  Future<List<AudiogramData>> getAudiogramHistory() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('audiograms')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => AudiogramData.fromMap(doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // BILD-UPLOAD
  // ============================================================

  /// Öffnet Kamera/Galerie zum Audiogramm-Foto
  Future<File?> pickAudiogramImage({bool fromCamera = false}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );

      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Bild auswählen Fehler: $e');
      return null;
    }
  }

  // ============================================================
  // FREQUENZ-ANPASSUNG
  // ============================================================

  /// Berechnet Frequenz-Anpassungen basierend auf Audiogramm
  FrequencyAdjustments calculateAdjustments(AudiogramData audiogram) {
    // Durchschnittlicher Hörverlust berechnen
    final leftAvg = _calculatePTA(audiogram.leftEar);
    final rightAvg = _calculatePTA(audiogram.rightEar);

    // Frequenz-spezifische Boost-Werte
    final Map<int, double> frequencyBoosts = {};

    // Für jede Frequenz den Boost basierend auf Hörverlust berechnen
    for (final freq in AudiogramData.standardFrequencies) {
      final leftLoss = audiogram.leftEar[freq] ?? 0;
      final rightLoss = audiogram.rightEar[freq] ?? 0;
      final avgLoss = (leftLoss + rightLoss) / 2;

      // Boost-Faktor (0-100% basierend auf Hörverlust)
      // Leichter Verlust (20-40dB): 10-30% Boost
      // Mittlerer Verlust (40-60dB): 30-50% Boost
      // Schwerer Verlust (60-90dB): 50-80% Boost
      double boost = 0;
      if (avgLoss >= 20 && avgLoss < 40) {
        boost = (avgLoss - 20) / 20 * 0.2 + 0.1; // 10-30%
      } else if (avgLoss >= 40 && avgLoss < 60) {
        boost = (avgLoss - 40) / 20 * 0.2 + 0.3; // 30-50%
      } else if (avgLoss >= 60) {
        boost = (avgLoss - 60) / 30 * 0.3 + 0.5; // 50-80%
        boost = boost.clamp(0.5, 0.8);
      }

      frequencyBoosts[freq] = boost;
    }

    // Empfohlene TTS-Einstellungen
    double recommendedPitch = 1.0;
    double recommendedRate = 0.9;

    // Bei Hochton-Schwerhörigkeit: tiefere Stimme empfohlen
    final highFreqLoss = (audiogram.leftEar[2000] ?? 0) +
        (audiogram.leftEar[4000] ?? 0) +
        (audiogram.rightEar[2000] ?? 0) +
        (audiogram.rightEar[4000] ?? 0);
    if (highFreqLoss / 4 > 50) {
      recommendedPitch = 0.85; // Tiefere Stimme
    }

    // Bei schwerem Hörverlust: langsamere Sprache
    if ((leftAvg + rightAvg) / 2 > 60) {
      recommendedRate = 0.75;
    }

    return FrequencyAdjustments(
      frequencyBoosts: frequencyBoosts,
      leftEarPTA: leftAvg,
      rightEarPTA: rightAvg,
      recommendedPitch: recommendedPitch,
      recommendedRate: recommendedRate,
      hearingLossCategory: _categorizeHearingLoss((leftAvg + rightAvg) / 2),
    );
  }

  /// Berechnet Pure Tone Average (PTA) - Durchschnitt bei 500, 1000, 2000 Hz
  double _calculatePTA(Map<int, int> earData) {
    final pta500 = earData[500] ?? 0;
    final pta1000 = earData[1000] ?? 0;
    final pta2000 = earData[2000] ?? 0;
    return (pta500 + pta1000 + pta2000) / 3;
  }

  /// Kategorisiert Hörverlust
  HearingLossCategory _categorizeHearingLoss(double ptaAvg) {
    if (ptaAvg < 20) return HearingLossCategory.normal;
    if (ptaAvg < 40) return HearingLossCategory.mild;
    if (ptaAvg < 60) return HearingLossCategory.moderate;
    if (ptaAvg < 80) return HearingLossCategory.severe;
    return HearingLossCategory.profound;
  }
}

// ============================================================
// MODELS
// ============================================================

/// Audiogramm-Daten
class AudiogramData {
  /// Standard-Frequenzen im Audiogramm (Hz)
  static const List<int> standardFrequencies = [
    125, 250, 500, 1000, 2000, 4000, 8000
  ];

  /// Hörschwellen linkes Ohr (Frequenz Hz -> Dezibel)
  final Map<int, int> leftEar;

  /// Hörschwellen rechtes Ohr (Frequenz Hz -> Dezibel)
  final Map<int, int> rightEar;

  /// Hörgeräte-Typ
  final HearingAidType hearingAidType;

  /// Cochlea-Implantat? (links/rechts/beide/keins)
  final CochleaImplantStatus cochleaImplant;

  /// Datum des Audiogramms
  final DateTime? testDate;

  /// Name des Audiologen/HNO
  final String? audiologistName;

  /// Notizen
  final String? notes;

  /// Bild-Pfad (lokal oder Firebase Storage URL)
  final String? imagePath;

  AudiogramData({
    required this.leftEar,
    required this.rightEar,
    this.hearingAidType = HearingAidType.behindTheEar,
    this.cochleaImplant = CochleaImplantStatus.none,
    this.testDate,
    this.audiologistName,
    this.notes,
    this.imagePath,
  });

  Map<String, dynamic> toMap() => {
    'leftEar': leftEar.map((k, v) => MapEntry(k.toString(), v)),
    'rightEar': rightEar.map((k, v) => MapEntry(k.toString(), v)),
    'hearingAidType': hearingAidType.name,
    'cochleaImplant': cochleaImplant.name,
    'testDate': testDate != null ? Timestamp.fromDate(testDate!) : null,
    'audiologistName': audiologistName,
    'notes': notes,
    'imagePath': imagePath,
  };

  factory AudiogramData.fromMap(Map<String, dynamic> map) {
    return AudiogramData(
      leftEar: (map['leftEar'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
      rightEar: (map['rightEar'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? {},
      hearingAidType: HearingAidType.values.firstWhere(
        (e) => e.name == map['hearingAidType'],
        orElse: () => HearingAidType.behindTheEar,
      ),
      cochleaImplant: CochleaImplantStatus.values.firstWhere(
        (e) => e.name == map['cochleaImplant'],
        orElse: () => CochleaImplantStatus.none,
      ),
      testDate: map['testDate'] != null
          ? (map['testDate'] as Timestamp).toDate()
          : null,
      audiologistName: map['audiologistName'],
      notes: map['notes'],
      imagePath: map['imagePath'],
    );
  }

  /// Leeres Audiogramm erstellen
  factory AudiogramData.empty() {
    return AudiogramData(
      leftEar: {},
      rightEar: {},
    );
  }
}

/// Hörgeräte-Typ
enum HearingAidType {
  behindTheEar,    // HdO - Hinter dem Ohr
  inTheEar,        // IdO - Im Ohr
  receiver,        // RIC - Receiver in Canal
  cochleaImplant,  // CI - Cochlea-Implantat
  boneAnchored,    // BAHA - Knochenverankertes Hörgerät
}

/// Cochlea-Implantat Status
enum CochleaImplantStatus {
  none,       // Kein CI
  left,       // CI links
  right,      // CI rechts
  bilateral,  // CI beidseitig
}

/// Hörverlust-Kategorie
enum HearingLossCategory {
  normal,     // < 20 dB
  mild,       // 20-40 dB
  moderate,   // 40-60 dB
  severe,     // 60-80 dB
  profound,   // > 80 dB
}

/// Frequenz-Anpassungen basierend auf Audiogramm
class FrequencyAdjustments {
  final Map<int, double> frequencyBoosts;
  final double leftEarPTA;
  final double rightEarPTA;
  final double recommendedPitch;
  final double recommendedRate;
  final HearingLossCategory hearingLossCategory;

  FrequencyAdjustments({
    required this.frequencyBoosts,
    required this.leftEarPTA,
    required this.rightEarPTA,
    required this.recommendedPitch,
    required this.recommendedRate,
    required this.hearingLossCategory,
  });

  String get categoryDisplayName {
    switch (hearingLossCategory) {
      case HearingLossCategory.normal:
        return 'Normal';
      case HearingLossCategory.mild:
        return 'Leicht';
      case HearingLossCategory.moderate:
        return 'Mittelgradig';
      case HearingLossCategory.severe:
        return 'Hochgradig';
      case HearingLossCategory.profound:
        return 'An Taubheit grenzend';
    }
  }
}

// ============================================================
// PROVIDERS
// ============================================================

/// Placeholder für Child ID
final currentChildIdProvider = Provider<String?>((ref) => null);

/// Audiogram Service Provider
final audiogramServiceProvider = Provider<AudiogramService>((ref) {
  return AudiogramService(ref);
});

/// Aktuelles Audiogramm
final currentAudiogramProvider = FutureProvider<AudiogramData?>((ref) async {
  final service = ref.watch(audiogramServiceProvider);
  return service.loadCurrentAudiogram();
});

/// Frequenz-Anpassungen basierend auf aktuellem Audiogramm
final frequencyAdjustmentsProvider = FutureProvider<FrequencyAdjustments?>((ref) async {
  final audiogram = await ref.watch(currentAudiogramProvider.future);
  if (audiogram == null) return null;

  final service = ref.watch(audiogramServiceProvider);
  return service.calculateAdjustments(audiogram);
});
