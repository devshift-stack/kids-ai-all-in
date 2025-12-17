import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/audiogram/audiogram_model.dart';

/// AI Audiogramm Reader - Analysiert Audiogramm-Bilder mit Gemini Vision
///
/// Funktionsweise:
/// 1. Eltern fotografieren/laden Audiogramm hoch
/// 2. Gemini Vision analysiert das Bild
/// 3. dB-Werte werden extrahiert (250Hz - 8000Hz)
/// 4. Eltern bestätigen/korrigieren die Werte
/// 5. App passt sich automatisch an
class AIAudiogramReaderService {
  GenerativeModel? _model;
  bool _isInitialized = false;

  /// Initialisiert den Service mit API-Key
  Future<void> initialize(String apiKey) async {
    if (_isInitialized) return;

    try {
      _model = GenerativeModel(
        model: 'gemini-1.5-flash', // Schnell + günstig für Bildanalyse
        apiKey: apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.1, // Niedrig für präzise Zahlen
          topK: 1,
          topP: 0.8,
          maxOutputTokens: 1024,
        ),
      );
      _isInitialized = true;

      if (kDebugMode) {
        print('AI Audiogramm Reader initialisiert');
      }
    } catch (e) {
      if (kDebugMode) {
        print('AI Audiogramm Reader Fehler: $e');
      }
      rethrow;
    }
  }

  /// Analysiert ein Audiogramm-Bild und extrahiert dB-Werte
  ///
  /// Returns: AudiogramReadResult mit erkannten Werten oder Fehler
  Future<AudiogramReadResult> analyzeImage(Uint8List imageBytes) async {
    if (!_isInitialized || _model == null) {
      return AudiogramReadResult.error(
        'AI Audiogramm Reader nicht initialisiert',
      );
    }

    try {
      final prompt = _buildAnalysisPrompt();

      final response = await _model!.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      final responseText = response.text;
      if (responseText == null || responseText.isEmpty) {
        return AudiogramReadResult.error('Keine Antwort von Gemini erhalten');
      }

      // JSON aus Antwort extrahieren
      return _parseResponse(responseText);
    } catch (e) {
      if (kDebugMode) {
        print('Audiogramm-Analyse Fehler: $e');
      }
      return AudiogramReadResult.error('Analyse fehlgeschlagen: $e');
    }
  }

  /// Baut den Analyse-Prompt für Gemini
  String _buildAnalysisPrompt() {
    return '''
Analysiere dieses Audiogramm-Bild sorgfältig.

AUFGABE:
Extrahiere die Hörschwellenwerte (in dB HL) für BEIDE Ohren bei diesen Frequenzen:
- 250 Hz
- 500 Hz
- 1000 Hz (1 kHz)
- 2000 Hz (2 kHz)
- 4000 Hz (4 kHz)
- 8000 Hz (8 kHz)

AUDIOGRAMM-KONVENTIONEN:
- Linkes Ohr: X oder □ (oft blau)
- Rechtes Ohr: O oder △ (oft rot)
- Y-Achse: dB HL (0 oben = normal, nach unten = schlechter)
- X-Achse: Frequenz in Hz (links niedrig, rechts hoch)
- Werte typischerweise zwischen 0 und 120 dB

ANTWORT-FORMAT:
Antworte NUR mit validem JSON, keine anderen Texte:

{
  "success": true,
  "leftEar": {
    "250": <dB-Wert>,
    "500": <dB-Wert>,
    "1000": <dB-Wert>,
    "2000": <dB-Wert>,
    "4000": <dB-Wert>,
    "8000": <dB-Wert>
  },
  "rightEar": {
    "250": <dB-Wert>,
    "500": <dB-Wert>,
    "1000": <dB-Wert>,
    "2000": <dB-Wert>,
    "4000": <dB-Wert>,
    "8000": <dB-Wert>
  },
  "confidence": <0.0-1.0>,
  "notes": "<Beobachtungen, z.B. Hochton-Abfall>"
}

Falls kein Audiogramm erkennbar oder Werte nicht lesbar:
{
  "success": false,
  "error": "<Grund warum nicht lesbar>"
}

WICHTIG:
- Alle dB-Werte als INTEGER (ganze Zahlen)
- Wenn ein Wert nicht lesbar ist, schätze basierend auf der Kurve
- confidence = wie sicher du bei der Erkennung bist
''';
  }

  /// Parsed die Gemini-Antwort zu AudiogramReadResult
  AudiogramReadResult _parseResponse(String responseText) {
    try {
      // JSON-Block extrahieren (falls von Text umgeben)
      String jsonStr = responseText;

      // Suche nach JSON-Block
      final jsonStart = responseText.indexOf('{');
      final jsonEnd = responseText.lastIndexOf('}');

      if (jsonStart != -1 && jsonEnd != -1 && jsonEnd > jsonStart) {
        jsonStr = responseText.substring(jsonStart, jsonEnd + 1);
      }

      final json = jsonDecode(jsonStr) as Map<String, dynamic>;

      // Fehler-Fall
      if (json['success'] == false) {
        return AudiogramReadResult.error(
          json['error'] ?? 'Audiogramm konnte nicht gelesen werden',
        );
      }

      // Erfolg-Fall
      final leftEarData = _parseEarData(json['leftEar']);
      final rightEarData = _parseEarData(json['rightEar']);
      final confidence = (json['confidence'] as num?)?.toDouble() ?? 0.5;
      final notes = json['notes'] as String?;

      return AudiogramReadResult.success(
        leftEar: EarAudiogram(values: leftEarData),
        rightEar: EarAudiogram(values: rightEarData),
        confidence: confidence,
        notes: notes,
      );
    } catch (e) {
      if (kDebugMode) {
        print('JSON-Parse Fehler: $e');
        print('Response war: $responseText');
      }
      return AudiogramReadResult.error(
        'Antwort konnte nicht verarbeitet werden',
      );
    }
  }

  /// Konvertiert Ear-Daten von JSON zu Map<int, int>
  Map<int, int> _parseEarData(dynamic data) {
    if (data == null) return {};

    final result = <int, int>{};
    final map = data as Map<String, dynamic>;

    map.forEach((key, value) {
      final freq = int.tryParse(key);
      final db = (value as num?)?.toInt();

      if (freq != null && db != null) {
        result[freq] = db;
      }
    });

    return result;
  }

  /// Ob der Service bereit ist
  bool get isReady => _isInitialized && _model != null;
}

/// Ergebnis der Audiogramm-Analyse
class AudiogramReadResult {
  final bool success;
  final EarAudiogram? leftEar;
  final EarAudiogram? rightEar;
  final double confidence;
  final String? notes;
  final String? error;

  const AudiogramReadResult._({
    required this.success,
    this.leftEar,
    this.rightEar,
    this.confidence = 0.0,
    this.notes,
    this.error,
  });

  factory AudiogramReadResult.success({
    required EarAudiogram leftEar,
    required EarAudiogram rightEar,
    required double confidence,
    String? notes,
  }) {
    return AudiogramReadResult._(
      success: true,
      leftEar: leftEar,
      rightEar: rightEar,
      confidence: confidence,
      notes: notes,
    );
  }

  factory AudiogramReadResult.error(String message) {
    return AudiogramReadResult._(
      success: false,
      error: message,
    );
  }

  /// Konvertiert zu AudiogramData (für Firestore)
  AudiogramData? toAudiogramData() {
    if (!success || leftEar == null || rightEar == null) return null;

    return AudiogramData(
      leftEar: leftEar!,
      rightEar: rightEar!,
      measuredAt: DateTime.now(),
      geminiConfidence: confidence,
      notes: notes,
      confirmedByParent: false,
    );
  }

  /// Konfidenz als Prozent-String
  String get confidencePercent => '${(confidence * 100).round()}%';

  /// Ist die Konfidenz hoch genug?
  bool get isHighConfidence => confidence >= 0.7;
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// AI Audiogramm Reader Service Provider
final aiAudiogramReaderProvider = Provider<AIAudiogramReaderService>((ref) {
  return AIAudiogramReaderService();
});

/// Aktuelles Analyse-Ergebnis
final audiogramReadResultProvider = StateProvider<AudiogramReadResult?>((ref) => null);

/// Ob gerade analysiert wird
final isAnalyzingAudiogramProvider = StateProvider<bool>((ref) => false);
