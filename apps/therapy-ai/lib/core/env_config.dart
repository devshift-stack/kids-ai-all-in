import 'dart:io';
import 'package:flutter/foundation.dart';

/// Environment Configuration
/// Lädt API Keys und Konfigurationen aus .env Datei oder Environment Variables
class EnvConfig {
  EnvConfig._();

  static String? _elevenLabsApiKey;
  static String? _elevenLabsApiBaseUrl;
  static String? _openAiApiKey;
  static String? _openAiApiBaseUrl;

  /// Initialisiert die Environment-Konfiguration
  static Future<void> initialize() async {
    // Versuche .env Datei zu laden
    try {
      final envFile = File('.env');
      if (await envFile.exists()) {
        final content = await envFile.readAsString();
        final lines = content.split('\n');
        
        for (final line in lines) {
          if (line.trim().isEmpty || line.startsWith('#')) continue;
          
          final parts = line.split('=');
          if (parts.length == 2) {
            final key = parts[0].trim();
            final value = parts[1].trim();
            
            switch (key) {
              case 'ELEVENLABS_API_KEY':
                _elevenLabsApiKey = value;
                break;
              case 'ELEVENLABS_API_BASE_URL':
                _elevenLabsApiBaseUrl = value;
                break;
              case 'OPENAI_API_KEY':
                _openAiApiKey = value;
                break;
              case 'OPENAI_API_BASE_URL':
                _openAiApiBaseUrl = value;
                break;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Warning: Could not load .env file: $e');
      }
    }

    // Fallback zu Environment Variables (für Production)
    _elevenLabsApiKey ??= const String.fromEnvironment('ELEVENLABS_API_KEY');
    _elevenLabsApiBaseUrl ??= const String.fromEnvironment(
      'ELEVENLABS_API_BASE_URL',
      defaultValue: 'https://api.elevenlabs.io/v1',
    );
    _openAiApiKey ??= const String.fromEnvironment('OPENAI_API_KEY');
    _openAiApiBaseUrl ??= const String.fromEnvironment(
      'OPENAI_API_BASE_URL',
      defaultValue: 'https://api.openai.com/v1',
    );
  }

  /// ElevenLabs API Key
  static String? get elevenLabsApiKey {
    // KEIN Fallback - API Key muss immer aus .env oder Environment Variable kommen
    // Sicherheit: API Keys dürfen niemals hardcodiert werden!
    if (_elevenLabsApiKey == null || _elevenLabsApiKey!.isEmpty) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ ElevenLabs API Key nicht gefunden. '
          'Bitte .env Datei erstellen oder ELEVENLABS_API_KEY Environment Variable setzen.',
        );
        debugPrint(
          '📝 Anleitung: Erstelle apps/therapy-ai/.env mit: ELEVENLABS_API_KEY=dein_api_key',
        );
        return null;
      }
      throw Exception(
        'ElevenLabs API Key nicht gefunden. '
        'Bitte .env Datei erstellen oder ELEVENLABS_API_KEY setzen.',
      );
    }
    return _elevenLabsApiKey;
  }

  /// ElevenLabs API Base URL
  static String get elevenLabsApiBaseUrl {
    return _elevenLabsApiBaseUrl ?? 'https://api.elevenlabs.io/v1';
  }

  /// OpenAI API Key (für Whisper)
  static String? get openAiApiKey {
    // Fallback für Development (wenn .env nicht vorhanden)
    if (_openAiApiKey == null || _openAiApiKey!.isEmpty) {
      if (kDebugMode) {
        // Development Fallback - Set via .env file
        return null;
      }
      throw Exception(
        'OpenAI API Key nicht gefunden. '
        'Bitte .env Datei erstellen oder OPENAI_API_KEY setzen.',
      );
    }
    return _openAiApiKey;
  }

  /// OpenAI API Base URL
  static String get openAiApiBaseUrl {
    return _openAiApiBaseUrl ?? 'https://api.openai.com/v1';
  }

  /// Prüft ob alle benötigten Konfigurationen vorhanden sind
  static bool get isConfigured {
    return _elevenLabsApiKey != null && _elevenLabsApiKey!.isNotEmpty;
  }

  /// Prüft ob OpenAI API Key vorhanden ist
  static bool get isOpenAiConfigured {
    return _openAiApiKey != null && _openAiApiKey!.isNotEmpty;
  }

  /// Debug-Info (ohne API Keys)
  static Map<String, dynamic> get debugInfo {
    return {
      'elevenLabsApiKeySet': _elevenLabsApiKey != null && _elevenLabsApiKey!.isNotEmpty,
      'elevenLabsApiBaseUrl': _elevenLabsApiBaseUrl,
      'openAiApiKeySet': _openAiApiKey != null && _openAiApiKey!.isNotEmpty,
      'openAiApiBaseUrl': _openAiApiBaseUrl,
      'isConfigured': isConfigured,
      'isOpenAiConfigured': isOpenAiConfigured,
    };
  }
}

