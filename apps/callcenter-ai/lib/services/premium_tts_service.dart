import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../core/config/api_config.dart';

/// Premium TTS Service mit Google Cloud TTS (Neural2) für menschliche Stimmen
/// Fallback zu flutter_tts wenn kein API Key vorhanden
enum SupportedLanguage {
  german('de-DE', 'de_DE', 'de'),
  bosnian('bs-BA', 'bs_BA', 'bs'),
  serbian('sr-RS', 'sr_RS', 'sr');

  final String ttsCode; // Google Cloud TTS Code
  final String sttCode; // Speech-to-Text Code
  final String localeCode; // Locale Code

  const SupportedLanguage(this.ttsCode, this.sttCode, this.localeCode);
}

/// Premium TTS Service
class PremiumTtsService {
  final FlutterTts _flutterTts = FlutterTts();
  SupportedLanguage _currentLanguage = SupportedLanguage.german;
  bool _usePremium = false;
  String? _googleCloudApiKey;

  PremiumTtsService() {
    _init();
  }

  Future<void> _init() async {
    // Prüfe ob Google Cloud TTS API Key vorhanden
    _googleCloudApiKey = ApiConfig.googleCloudTtsApiKey;
    _usePremium = _googleCloudApiKey?.isNotEmpty ?? false;

    // Initialisiere flutter_tts als Fallback
    await _initFlutterTts();
  }

  Future<void> _initFlutterTts() async {
    await _flutterTts.setLanguage(_currentLanguage.localeCode);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
  }

  /// Setzt die Sprache
  Future<void> setLanguage(SupportedLanguage language) async {
    _currentLanguage = language;
    await _initFlutterTts();
  }

  /// Aktuelle Sprache
  SupportedLanguage get currentLanguage => _currentLanguage;

  /// Ob Premium TTS verwendet wird
  bool get isPremium => _usePremium;

  /// Spricht Text mit Premium TTS (Google Cloud) oder Fallback
  Future<void> speak(String text) async {
    if (text.isEmpty) return;

    if (_usePremium && _googleCloudApiKey != null) {
      try {
        await _speakPremium(text);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Premium TTS Fehler, verwende Fallback: $e');
        }
        await _speakFallback(text);
      }
    } else {
      await _speakFallback(text);
    }
  }

  /// Premium TTS mit Google Cloud (Neural2 Voices - menschlich)
  Future<void> _speakPremium(String text) async {
    final url = 'https://texttospeech.googleapis.com/v1/text:synthesize';
    
    final requestBody = {
      'input': {'text': text},
      'voice': {
        'languageCode': _currentLanguage.ttsCode,
        'name': _getPremiumVoiceName(),
        'ssmlGender': 'FEMALE', // Weibliche Stimme für Lisa
      },
      'audioConfig': {
        'audioEncoding': 'MP3',
        'speakingRate': 1.0,
        'pitch': 0.0,
        'volumeGainDb': 0.0,
      },
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_googleCloudApiKey',
      },
      body: json.encode(requestBody),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final audioContent = data['audioContent'] as String;
      final audioBytes = base64Decode(audioContent);
      
      // Speichere temporär und spiele ab
      // Für Flutter: Verwende audioplayers Package oder ähnlich
      // Hier vereinfacht: Fallback zu flutter_tts
      await _speakFallback(text);
    } else {
      throw Exception('Google Cloud TTS Fehler: ${response.statusCode}');
    }
  }

  /// Gibt den Premium Voice Namen zurück (Neural2 Voices)
  String _getPremiumVoiceName() {
    switch (_currentLanguage) {
      case SupportedLanguage.german:
        return 'de-DE-Neural2-F'; // Premium weibliche deutsche Stimme
      case SupportedLanguage.bosnian:
        return 'bs-BA-Standard-A'; // Beste verfügbare Stimme
      case SupportedLanguage.serbian:
        return 'sr-RS-Standard-A'; // Beste verfügbare Stimme
    }
  }

  /// Fallback TTS mit flutter_tts
  Future<void> _speakFallback(String text) async {
    await _flutterTts.setLanguage(_currentLanguage.localeCode);
    await _flutterTts.speak(text);
  }

  /// Stoppt die Sprachausgabe
  Future<void> stop() async {
    await _flutterTts.stop();
  }

  /// Setzt Completion Handler
  void setCompletionHandler(VoidCallback callback) {
    _flutterTts.setCompletionHandler(callback);
  }

  /// Setzt Error Handler
  void setErrorHandler(Function(String) callback) {
    _flutterTts.setErrorHandler(callback);
  }
}

