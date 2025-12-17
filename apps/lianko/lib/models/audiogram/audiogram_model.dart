import 'package:cloud_firestore/cloud_firestore.dart';

/// Hörverlust-Klassifikation nach WHO-Standard
enum HearingLossLevel {
  normal,    // ≤25 dB - Normales Hören
  mild,      // 26-40 dB - Leichter Hörverlust
  moderate,  // 41-60 dB - Mittelgradiger Hörverlust
  severe,    // 61-80 dB - Schwerer Hörverlust
  profound,  // >80 dB - An Taubheit grenzend
}

extension HearingLossLevelExtension on HearingLossLevel {
  String get displayName {
    switch (this) {
      case HearingLossLevel.normal:
        return 'Normal';
      case HearingLossLevel.mild:
        return 'Leicht';
      case HearingLossLevel.moderate:
        return 'Mittelgradig';
      case HearingLossLevel.severe:
        return 'Schwer';
      case HearingLossLevel.profound:
        return 'Hochgradig';
    }
  }

  String get description {
    switch (this) {
      case HearingLossLevel.normal:
        return 'Keine Anpassungen nötig';
      case HearingLossLevel.mild:
        return 'Leichte Anpassungen empfohlen';
      case HearingLossLevel.moderate:
        return 'Untertitel und langsamere Sprache empfohlen';
      case HearingLossLevel.severe:
        return 'Untertitel erforderlich, sehr langsame Sprache';
      case HearingLossLevel.profound:
        return 'Maximale visuelle Unterstützung erforderlich';
    }
  }
}

/// Audiogramm-Daten für ein Ohr
class EarAudiogram {
  /// dB-Werte pro Frequenz (Hz -> dB)
  /// Frequenzen: 250, 500, 1000, 2000, 4000, 8000
  final Map<int, int> values;

  const EarAudiogram({required this.values});

  factory EarAudiogram.fromMap(Map<String, dynamic> map) {
    final values = <int, int>{};
    map.forEach((key, value) {
      final freq = int.tryParse(key);
      if (freq != null && value is int) {
        values[freq] = value;
      }
    });
    return EarAudiogram(values: values);
  }

  Map<String, dynamic> toMap() {
    return values.map((key, value) => MapEntry(key.toString(), value));
  }

  /// Wert für eine bestimmte Frequenz
  int? valueAt(int frequencyHz) => values[frequencyHz];

  /// PTA (Pure Tone Average) - Medizinischer Standard
  /// Durchschnitt von 500, 1000, 2000, 4000 Hz
  double get pta {
    final frequencies = [500, 1000, 2000, 4000];
    double sum = 0;
    int count = 0;

    for (final freq in frequencies) {
      if (values.containsKey(freq)) {
        sum += values[freq]!;
        count++;
      }
    }

    return count > 0 ? sum / count : 0;
  }

  /// Hochfrequenz-Durchschnitt (4000 + 8000 Hz)
  double get highFrequencyAverage {
    final v4000 = values[4000] ?? 0;
    final v8000 = values[8000] ?? 0;
    return (v4000 + v8000) / 2;
  }

  /// Tieffrequenz-Durchschnitt (250 + 500 Hz)
  double get lowFrequencyAverage {
    final v250 = values[250] ?? 0;
    final v500 = values[500] ?? 0;
    return (v250 + v500) / 2;
  }

  /// Hat Hochton-Abfall?
  bool get hasHighFrequencyLoss {
    return highFrequencyAverage > lowFrequencyAverage + 15;
  }

  /// Leeres Audiogramm
  factory EarAudiogram.empty() => const EarAudiogram(values: {});

  /// Standard-Frequenzen
  static const List<int> standardFrequencies = [250, 500, 1000, 2000, 4000, 8000];
}

/// Komplettes Audiogramm mit beiden Ohren
class AudiogramData {
  final EarAudiogram leftEar;
  final EarAudiogram rightEar;
  final DateTime measuredAt;
  final double? geminiConfidence; // Wie sicher war Gemini bei der Erkennung
  final String? notes;
  final bool confirmedByParent;

  const AudiogramData({
    required this.leftEar,
    required this.rightEar,
    required this.measuredAt,
    this.geminiConfidence,
    this.notes,
    this.confirmedByParent = false,
  });

  factory AudiogramData.fromMap(Map<String, dynamic> map) {
    return AudiogramData(
      leftEar: EarAudiogram.fromMap(map['leftEar'] ?? {}),
      rightEar: EarAudiogram.fromMap(map['rightEar'] ?? {}),
      measuredAt: (map['measuredAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      geminiConfidence: (map['geminiConfidence'] as num?)?.toDouble(),
      notes: map['notes'],
      confirmedByParent: map['confirmedByParent'] ?? false,
    );
  }

  factory AudiogramData.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return AudiogramData.fromMap(data);
  }

  Map<String, dynamic> toMap() => {
        'leftEar': leftEar.toMap(),
        'rightEar': rightEar.toMap(),
        'measuredAt': Timestamp.fromDate(measuredAt),
        'geminiConfidence': geminiConfidence,
        'notes': notes,
        'confirmedByParent': confirmedByParent,
      };

  /// Besseres Ohr (niedrigerer PTA = besser)
  EarAudiogram get betterEar {
    return leftEar.pta <= rightEar.pta ? leftEar : rightEar;
  }

  /// Schlechteres Ohr
  EarAudiogram get worseEar {
    return leftEar.pta > rightEar.pta ? leftEar : rightEar;
  }

  /// Durchschnittlicher PTA beider Ohren
  double get averagePta => (leftEar.pta + rightEar.pta) / 2;

  /// Klassifikation nach WHO-Standard
  HearingLossLevel get hearingLossLevel {
    final avgPta = averagePta;
    if (avgPta <= 25) return HearingLossLevel.normal;
    if (avgPta <= 40) return HearingLossLevel.mild;
    if (avgPta <= 60) return HearingLossLevel.moderate;
    if (avgPta <= 80) return HearingLossLevel.severe;
    return HearingLossLevel.profound;
  }

  /// Hat mindestens ein Ohr Hochton-Abfall?
  bool get hasHighFrequencyLoss {
    return leftEar.hasHighFrequencyLoss || rightEar.hasHighFrequencyLoss;
  }

  /// Leeres Audiogramm
  factory AudiogramData.empty() => AudiogramData(
        leftEar: EarAudiogram.empty(),
        rightEar: EarAudiogram.empty(),
        measuredAt: DateTime.now(),
      );

  /// Kopie mit Änderungen
  AudiogramData copyWith({
    EarAudiogram? leftEar,
    EarAudiogram? rightEar,
    DateTime? measuredAt,
    double? geminiConfidence,
    String? notes,
    bool? confirmedByParent,
  }) {
    return AudiogramData(
      leftEar: leftEar ?? this.leftEar,
      rightEar: rightEar ?? this.rightEar,
      measuredAt: measuredAt ?? this.measuredAt,
      geminiConfidence: geminiConfidence ?? this.geminiConfidence,
      notes: notes ?? this.notes,
      confirmedByParent: confirmedByParent ?? this.confirmedByParent,
    );
  }
}

/// Empfohlene App-Einstellungen basierend auf Audiogramm
class AudiogramRecommendations {
  final double speechRate;
  final double pitch;
  final bool subtitlesAlwaysOn;
  final bool enlargedAnimations;
  final double textScale;
  final String explanation;

  const AudiogramRecommendations({
    required this.speechRate,
    required this.pitch,
    required this.subtitlesAlwaysOn,
    required this.enlargedAnimations,
    required this.textScale,
    required this.explanation,
  });

  /// Berechnet Empfehlungen aus Audiogramm-Daten
  factory AudiogramRecommendations.fromAudiogram(AudiogramData audiogram) {
    final level = audiogram.hearingLossLevel;
    final hasHighFreqLoss = audiogram.hasHighFrequencyLoss;

    switch (level) {
      case HearingLossLevel.normal:
        return const AudiogramRecommendations(
          speechRate: 0.5,
          pitch: 1.0,
          subtitlesAlwaysOn: false,
          enlargedAnimations: false,
          textScale: 1.0,
          explanation: 'Normales Hören - Standardeinstellungen',
        );

      case HearingLossLevel.mild:
        return AudiogramRecommendations(
          speechRate: 0.45,
          pitch: hasHighFreqLoss ? 0.9 : 1.0,
          subtitlesAlwaysOn: false,
          enlargedAnimations: false,
          textScale: 1.0,
          explanation: 'Leichter Hörverlust - etwas langsamere Sprache',
        );

      case HearingLossLevel.moderate:
        return AudiogramRecommendations(
          speechRate: 0.4,
          pitch: hasHighFreqLoss ? 0.85 : 0.95,
          subtitlesAlwaysOn: true,
          enlargedAnimations: true,
          textScale: 1.1,
          explanation: 'Mittelgradiger Hörverlust - Untertitel empfohlen',
        );

      case HearingLossLevel.severe:
        return AudiogramRecommendations(
          speechRate: 0.35,
          pitch: hasHighFreqLoss ? 0.75 : 0.85,
          subtitlesAlwaysOn: true,
          enlargedAnimations: true,
          textScale: 1.2,
          explanation: 'Schwerer Hörverlust - maximale Unterstützung',
        );

      case HearingLossLevel.profound:
        return const AudiogramRecommendations(
          speechRate: 0.3,
          pitch: 0.7,
          subtitlesAlwaysOn: true,
          enlargedAnimations: true,
          textScale: 1.3,
          explanation: 'Hochgradiger Hörverlust - visuelle Kommunikation priorisiert',
        );
    }
  }

  Map<String, dynamic> toMap() => {
        'speechRate': speechRate,
        'pitch': pitch,
        'subtitlesAlwaysOn': subtitlesAlwaysOn,
        'enlargedAnimations': enlargedAnimations,
        'textScale': textScale,
        'explanation': explanation,
      };
}
