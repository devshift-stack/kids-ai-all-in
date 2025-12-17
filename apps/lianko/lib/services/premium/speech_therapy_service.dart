import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logopädie-Modus Service
///
/// Ermöglicht Logopäden:
/// - Spezifische Übungen für das Kind zuweisen
/// - Fokus auf bestimmte Laute/Phoneme setzen
/// - Schwierigkeitsgrad anpassen
/// - Fortschritt verfolgen
class SpeechTherapyService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  SpeechTherapyService(this._ref);

  // ============================================================
  // THERAPEUT VERKNÜPFEN
  // ============================================================

  /// Verknüpft Kind mit Logopäden via Code
  Future<TherapistLinkResult> linkTherapist(String therapistCode) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) {
      return TherapistLinkResult(
        success: false,
        message: 'Kein Kind-Profil gefunden',
      );
    }

    try {
      // Therapeuten-Code suchen
      final therapistQuery = await _firestore
          .collection('therapists')
          .where('linkCode', isEqualTo: therapistCode.toUpperCase())
          .limit(1)
          .get();

      if (therapistQuery.docs.isEmpty) {
        return TherapistLinkResult(
          success: false,
          message: 'Ungültiger Code. Bitte beim Logopäden nachfragen.',
        );
      }

      final therapistDoc = therapistQuery.docs.first;
      final therapistId = therapistDoc.id;
      final therapistName = therapistDoc.data()['name'] ?? 'Logopäde';

      // Verknüpfung speichern
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('therapy')
          .set({
        'therapistId': therapistId,
        'therapistName': therapistName,
        'linkedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      // Kind bei Therapeut registrieren
      await _firestore
          .collection('therapists')
          .doc(therapistId)
          .collection('patients')
          .doc(childId)
          .set({
        'linkedAt': FieldValue.serverTimestamp(),
        'isActive': true,
      });

      return TherapistLinkResult(
        success: true,
        message: 'Erfolgreich mit $therapistName verknüpft!',
        therapistName: therapistName,
      );
    } catch (e) {
      return TherapistLinkResult(
        success: false,
        message: 'Fehler: $e',
      );
    }
  }

  /// Entfernt Therapeuten-Verknüpfung
  Future<void> unlinkTherapist() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return;

    await _firestore
        .collection('children')
        .doc(childId)
        .collection('settings')
        .doc('therapy')
        .update({'isActive': false});
  }

  /// Holt aktuelle Therapeuten-Info
  Future<TherapistInfo?> getLinkedTherapist() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return null;

    try {
      final doc = await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('therapy')
          .get();

      if (!doc.exists || doc.data()?['isActive'] != true) {
        return null;
      }

      return TherapistInfo(
        id: doc.data()!['therapistId'],
        name: doc.data()!['therapistName'],
        linkedAt: (doc.data()!['linkedAt'] as Timestamp).toDate(),
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // ÜBUNGEN VERWALTEN
  // ============================================================

  /// Holt zugewiesene Übungen vom Therapeuten
  Future<List<TherapyExercise>> getAssignedExercises() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('therapyExercises')
          .where('isActive', isEqualTo: true)
          .orderBy('priority', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TherapyExercise.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      if (kDebugMode) print('Übungen laden Fehler: $e');
      return [];
    }
  }

  /// Holt Übungen für bestimmte Kategorie/Laut
  Future<List<TherapyExercise>> getExercisesForPhoneme(String phoneme) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('therapyExercises')
          .where('targetPhonemes', arrayContains: phoneme)
          .where('isActive', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => TherapyExercise.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // FORTSCHRITT TRACKEN
  // ============================================================

  /// Speichert Übungs-Ergebnis
  Future<void> logExerciseResult(ExerciseResult result) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return;

    try {
      // Ergebnis speichern
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('exerciseResults')
          .add(result.toMap());

      // Übungs-Statistik aktualisieren
      await _updateExerciseStats(result.exerciseId, result.wasSuccessful);

      if (kDebugMode) print('Übungs-Ergebnis gespeichert');
    } catch (e) {
      if (kDebugMode) print('Ergebnis speichern Fehler: $e');
    }
  }

  /// Aktualisiert Statistik für eine Übung
  Future<void> _updateExerciseStats(String exerciseId, bool success) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return;

    final statsRef = _firestore
        .collection('children')
        .doc(childId)
        .collection('therapyExercises')
        .doc(exerciseId);

    await _firestore.runTransaction((transaction) async {
      final doc = await transaction.get(statsRef);
      if (!doc.exists) return;

      final data = doc.data()!;
      final attempts = (data['totalAttempts'] ?? 0) + 1;
      final successes = (data['successfulAttempts'] ?? 0) + (success ? 1 : 0);

      transaction.update(statsRef, {
        'totalAttempts': attempts,
        'successfulAttempts': successes,
        'lastAttemptAt': FieldValue.serverTimestamp(),
        'successRate': successes / attempts,
      });
    });
  }

  /// Holt Fortschritt für einen Laut/Phonem
  Future<PhonemeProgress> getPhonemeProgress(String phoneme) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) {
      return PhonemeProgress(
        phoneme: phoneme,
        totalAttempts: 0,
        successfulAttempts: 0,
        exercises: [],
      );
    }

    try {
      // Alle Ergebnisse für dieses Phonem
      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('exerciseResults')
          .where('targetPhonemes', arrayContains: phoneme)
          .orderBy('timestamp', descending: true)
          .limit(100)
          .get();

      int total = 0;
      int successful = 0;
      final exerciseIds = <String>{};

      for (final doc in snapshot.docs) {
        total++;
        if (doc.data()['wasSuccessful'] == true) successful++;
        exerciseIds.add(doc.data()['exerciseId']);
      }

      return PhonemeProgress(
        phoneme: phoneme,
        totalAttempts: total,
        successfulAttempts: successful,
        exercises: exerciseIds.toList(),
      );
    } catch (e) {
      return PhonemeProgress(
        phoneme: phoneme,
        totalAttempts: 0,
        successfulAttempts: 0,
        exercises: [],
      );
    }
  }

  /// Holt Gesamt-Fortschritt für alle Phoneme
  Future<Map<String, PhonemeProgress>> getAllPhonemeProgress() async {
    final progress = <String, PhonemeProgress>{};

    for (final phoneme in GermanPhonemes.all) {
      progress[phoneme] = await getPhonemeProgress(phoneme);
    }

    return progress;
  }

  // ============================================================
  // FOCUS-LAUTE
  // ============================================================

  /// Holt aktuell fokussierte Laute (vom Therapeuten gesetzt)
  Future<List<String>> getFocusPhonemes() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return [];

    try {
      final doc = await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('therapy')
          .get();

      if (!doc.exists) return [];

      final focusPhonemes = doc.data()?['focusPhonemes'];
      if (focusPhonemes is List) {
        return focusPhonemes.cast<String>();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// ============================================================
// MODELS
// ============================================================

/// Deutsche Phoneme/Laute
class GermanPhonemes {
  static const List<String> all = [
    // Plosive
    'p', 'b', 't', 'd', 'k', 'g',
    // Frikative
    'f', 'v', 's', 'z', 'ʃ', 'ç', 'x', 'h',
    // Affrikaten
    'pf', 'ts', 'tʃ',
    // Nasale
    'm', 'n', 'ŋ',
    // Liquide
    'l', 'r',
    // Vokale
    'a', 'e', 'i', 'o', 'u', 'ä', 'ö', 'ü',
    // Diphthonge
    'ai', 'au', 'eu',
    // Konsonantencluster
    'sch', 'ch', 'st', 'sp', 'str', 'schr',
  ];

  /// Schwierige Laute für Kinder mit Hörverlust
  static const List<String> difficultForHearingLoss = [
    's', 'z', 'ʃ', 'sch', 'f', 'ch', 'h',
  ];

  /// Häufige Ersetzungen
  static const Map<String, List<String>> commonSubstitutions = {
    's': ['t', 'ʃ'],
    'sch': ['s', 'ch'],
    'r': ['l', 'w'],
    'k': ['t'],
    'g': ['d'],
  };
}

/// Therapeuten-Verknüpfungs-Ergebnis
class TherapistLinkResult {
  final bool success;
  final String message;
  final String? therapistName;

  TherapistLinkResult({
    required this.success,
    required this.message,
    this.therapistName,
  });
}

/// Therapeuten-Info
class TherapistInfo {
  final String id;
  final String name;
  final DateTime linkedAt;

  TherapistInfo({
    required this.id,
    required this.name,
    required this.linkedAt,
  });
}

/// Therapie-Übung
class TherapyExercise {
  final String id;
  final String title;
  final String description;
  final ExerciseType type;
  final List<String> targetPhonemes;
  final int difficulty; // 1-5
  final int priority;   // Höher = wichtiger
  final List<String> words;
  final int totalAttempts;
  final int successfulAttempts;
  final DateTime? lastAttemptAt;

  TherapyExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.targetPhonemes,
    this.difficulty = 1,
    this.priority = 0,
    this.words = const [],
    this.totalAttempts = 0,
    this.successfulAttempts = 0,
    this.lastAttemptAt,
  });

  double get successRate =>
      totalAttempts > 0 ? successfulAttempts / totalAttempts : 0;

  factory TherapyExercise.fromMap(String id, Map<String, dynamic> map) {
    return TherapyExercise(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: ExerciseType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ExerciseType.wordRepetition,
      ),
      targetPhonemes: List<String>.from(map['targetPhonemes'] ?? []),
      difficulty: map['difficulty'] ?? 1,
      priority: map['priority'] ?? 0,
      words: List<String>.from(map['words'] ?? []),
      totalAttempts: map['totalAttempts'] ?? 0,
      successfulAttempts: map['successfulAttempts'] ?? 0,
      lastAttemptAt: map['lastAttemptAt'] != null
          ? (map['lastAttemptAt'] as Timestamp).toDate()
          : null,
    );
  }
}

/// Übungstyp
enum ExerciseType {
  wordRepetition,    // Wort nachsprechen
  sentenceRepetition, // Satz nachsprechen
  minimalPairs,      // Minimalpaare unterscheiden
  soundDiscrimination, // Laute erkennen
  syllableClapping,  // Silben klatschen
  rhyming,           // Reime finden
  soundPosition,     // Laut am Anfang/Mitte/Ende
}

/// Übungs-Ergebnis
class ExerciseResult {
  final String exerciseId;
  final List<String> targetPhonemes;
  final bool wasSuccessful;
  final int attempts;
  final String? wordAttempted;
  final String? recordingPath;
  final DateTime timestamp;

  ExerciseResult({
    required this.exerciseId,
    required this.targetPhonemes,
    required this.wasSuccessful,
    this.attempts = 1,
    this.wordAttempted,
    this.recordingPath,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'exerciseId': exerciseId,
    'targetPhonemes': targetPhonemes,
    'wasSuccessful': wasSuccessful,
    'attempts': attempts,
    'wordAttempted': wordAttempted,
    'recordingPath': recordingPath,
    'timestamp': Timestamp.fromDate(timestamp),
  };
}

/// Phonem-Fortschritt
class PhonemeProgress {
  final String phoneme;
  final int totalAttempts;
  final int successfulAttempts;
  final List<String> exercises;

  PhonemeProgress({
    required this.phoneme,
    required this.totalAttempts,
    required this.successfulAttempts,
    required this.exercises,
  });

  double get successRate =>
      totalAttempts > 0 ? successfulAttempts / totalAttempts : 0;

  String get progressLevel {
    if (totalAttempts < 5) return 'Neu';
    if (successRate >= 0.9) return 'Gemeistert';
    if (successRate >= 0.7) return 'Gut';
    if (successRate >= 0.5) return 'In Arbeit';
    return 'Übung nötig';
  }
}

// ============================================================
// PROVIDERS
// ============================================================

final currentChildIdProvider = Provider<String?>((ref) => null);

final speechTherapyServiceProvider = Provider<SpeechTherapyService>((ref) {
  return SpeechTherapyService(ref);
});

final linkedTherapistProvider = FutureProvider<TherapistInfo?>((ref) async {
  final service = ref.watch(speechTherapyServiceProvider);
  return service.getLinkedTherapist();
});

final assignedExercisesProvider = FutureProvider<List<TherapyExercise>>((ref) async {
  final service = ref.watch(speechTherapyServiceProvider);
  return service.getAssignedExercises();
});

final focusPhonemesProvider = FutureProvider<List<String>>((ref) async {
  final service = ref.watch(speechTherapyServiceProvider);
  return service.getFocusPhonemes();
});
