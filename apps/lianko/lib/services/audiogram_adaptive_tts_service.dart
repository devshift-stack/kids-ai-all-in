import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../models/audiogram/audiogram_model.dart';
import '../providers/child_settings_provider.dart';

/// TTS-Service der sich an Audiogramm-Daten anpasst
///
/// Passt automatisch an:
/// - Sprechgeschwindigkeit (langsamer bei starkem Hörverlust)
/// - Stimmhöhe/Pitch (tiefer bei Hochton-Verlust)
/// - Pausen zwischen Wörtern
class AudiogramAdaptiveTTSService {
  final FlutterTts _tts = FlutterTts();
  final Ref _ref;

  bool _isInitialized = false;
  AudiogramRecommendations? _currentRecommendations;

  AudiogramAdaptiveTTSService(this._ref);

  /// Initialisiert TTS mit Audiogramm-Anpassungen
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      await _tts.setLanguage('de-DE');
      await _tts.setSpeechRate(0.4); // Standard für Kinder
      await _tts.setPitch(1.0);
      await _tts.setVolume(1.0);

      // Audiogramm-basierte Anpassungen laden
      await _applyAudiogramSettings();

      _isInitialized = true;

      if (kDebugMode) {
        print('Audiogram Adaptive TTS initialisiert');
      }
    } catch (e) {
      if (kDebugMode) {
        print('TTS Initialisierung Fehler: $e');
      }
    }
  }

  /// Wendet Audiogramm-Einstellungen an
  Future<void> _applyAudiogramSettings() async {
    final settings = _ref.read(childSettingsProvider);
    final audiogram = settings.audiogram;

    if (audiogram != null && audiogram.confirmedByParent) {
      // Empfehlungen aus Audiogramm berechnen
      _currentRecommendations = AudiogramRecommendations.fromAudiogram(audiogram);

      await _tts.setSpeechRate(_currentRecommendations!.speechRate);
      await _tts.setPitch(_currentRecommendations!.pitch);

      if (kDebugMode) {
        print('TTS angepasst an Audiogramm:');
        print('  - Rate: ${_currentRecommendations!.speechRate}');
        print('  - Pitch: ${_currentRecommendations!.pitch}');
        print('  - Level: ${audiogram.hearingLossLevel.displayName}');
      }
    } else {
      // Fallback: Lianko-Settings verwenden
      final liankoSettings = settings.liankoSettings;
      await _tts.setSpeechRate(liankoSettings.speechRate);

      if (kDebugMode) {
        print('TTS mit Standard-Settings (kein Audiogramm)');
      }
    }
  }

  /// Spricht Text mit Audiogramm-optimierten Einstellungen
  Future<void> speak(String text) async {
    if (!_isInitialized) await initialize();

    // Settings aktualisieren falls sich Audiogramm geändert hat
    await _applyAudiogramSettings();

    await _tts.speak(text);
  }

  /// Spricht Text mit extra Pausen zwischen Wörtern
  /// Gut für schweren Hörverlust
  Future<void> speakWithPauses(String text, {int pauseMs = 300}) async {
    if (!_isInitialized) await initialize();

    final words = text.split(' ');

    for (int i = 0; i < words.length; i++) {
      await _tts.speak(words[i]);

      // Warten bis gesprochen + Pause
      await Future.delayed(Duration(milliseconds: pauseMs));
      await _tts.awaitSpeakCompletion(true);
    }
  }

  /// Spricht ein einzelnes Wort betont
  /// Gut für Vokabel-Training
  Future<void> speakWord(String word, {bool emphasized = false}) async {
    if (!_isInitialized) await initialize();

    if (emphasized) {
      // Langsamer + tiefer für Betonung
      final currentRate = _currentRecommendations?.speechRate ?? 0.4;
      final currentPitch = _currentRecommendations?.pitch ?? 1.0;

      await _tts.setSpeechRate(currentRate * 0.8); // 20% langsamer
      await _tts.setPitch(currentPitch * 0.9);     // Etwas tiefer
      await _tts.speak(word);

      // Zurücksetzen
      await _tts.setSpeechRate(currentRate);
      await _tts.setPitch(currentPitch);
    } else {
      await _tts.speak(word);
    }
  }

  /// Wiederholt Text X mal mit Pausen
  Future<void> repeatText(String text, {int times = 3, int pauseMs = 1000}) async {
    for (int i = 0; i < times; i++) {
      await speak(text);
      await _tts.awaitSpeakCompletion(true);

      if (i < times - 1) {
        await Future.delayed(Duration(milliseconds: pauseMs));
      }
    }
  }

  /// Stoppt aktuelle Sprachausgabe
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Aktuelle Empfehlungen basierend auf Audiogramm
  AudiogramRecommendations? get recommendations => _currentRecommendations;

  /// Ob Untertitel empfohlen werden
  bool get shouldShowSubtitles {
    return _currentRecommendations?.subtitlesAlwaysOn ?? false;
  }

  /// Ob größere Animationen empfohlen werden
  bool get shouldEnlargeAnimations {
    return _currentRecommendations?.enlargedAnimations ?? false;
  }

  /// Empfohlene Textgröße
  double get recommendedTextScale {
    return _currentRecommendations?.textScale ?? 1.0;
  }

  /// Erklärungs-Text für aktuelle Einstellungen
  String get settingsExplanation {
    return _currentRecommendations?.explanation ??
        'Standard-Einstellungen (kein Audiogramm hinterlegt)';
  }

  /// Räumt auf
  Future<void> dispose() async {
    await _tts.stop();
  }
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// Audiogram Adaptive TTS Provider
final audiogramAdaptiveTTSProvider = Provider<AudiogramAdaptiveTTSService>((ref) {
  final service = AudiogramAdaptiveTTSService(ref);
  ref.onDispose(() => service.dispose());
  return service;
});

/// Ob Untertitel basierend auf Audiogramm angezeigt werden sollen
final shouldShowSubtitlesProvider = Provider<bool>((ref) {
  final settings = ref.watch(childSettingsProvider);

  // Explizit aktiviert
  if (settings.accessibility.subtitlesEnabled) return true;

  // Audiogramm-Empfehlung
  final audiogram = settings.audiogram;
  if (audiogram != null && audiogram.confirmedByParent) {
    final recommendations = AudiogramRecommendations.fromAudiogram(audiogram);
    return recommendations.subtitlesAlwaysOn;
  }

  return false;
});

/// Empfohlene Textgröße basierend auf Audiogramm
final recommendedTextScaleProvider = Provider<double>((ref) {
  final settings = ref.watch(childSettingsProvider);

  // Accessibility-Einstellung priorisieren
  if (settings.accessibility.textScale != 1.0) {
    return settings.accessibility.textScale;
  }

  // Audiogramm-Empfehlung
  final audiogram = settings.audiogram;
  if (audiogram != null && audiogram.confirmedByParent) {
    final recommendations = AudiogramRecommendations.fromAudiogram(audiogram);
    return recommendations.textScale;
  }

  return 1.0;
});

/// Ob größere Animationen empfohlen werden
final shouldEnlargeAnimationsProvider = Provider<bool>((ref) {
  final settings = ref.watch(childSettingsProvider);
  final audiogram = settings.audiogram;

  if (audiogram != null && audiogram.confirmedByParent) {
    final recommendations = AudiogramRecommendations.fromAudiogram(audiogram);
    return recommendations.enlargedAnimations;
  }

  return false;
});

/// Hörverlust-Level des Kindes
final hearingLossLevelProvider = Provider<HearingLossLevel?>((ref) {
  final settings = ref.watch(childSettingsProvider);
  return settings.audiogram?.hearingLossLevel;
});
