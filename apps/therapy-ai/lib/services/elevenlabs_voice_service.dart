import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../core/env_config.dart';
import '../core/constants/app_constants.dart';

/// ElevenLabs Voice Service
/// Handles voice cloning and TTS generation with cloned voices
class ElevenLabsVoiceService {
  final Dio _dio = Dio();
  String? _apiKey;
  final Map<String, String> _audioCache = {}; // text -> filePath

  ElevenLabsVoiceService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _apiKey = EnvConfig.elevenLabsApiKey;
    
    _dio.options.baseUrl = EnvConfig.elevenLabsApiBaseUrl;
    _dio.options.headers = {
      'xi-api-key': _apiKey ?? '',
      'Content-Type': 'application/json',
    };
    
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  /// Prüft ob Service konfiguriert ist
  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;

  /// Klont eine Stimme aus Audio-Sample
  /// 
  /// [audioPath] - Pfad zur Audio-Datei (1-5 Minuten)
  /// [voiceName] - Name für die geklonte Stimme
  /// [description] - Beschreibung (optional)
  /// 
  /// Returns: Voice ID der geklonten Stimme
  Future<String> cloneVoice({
    required String audioPath,
    required String voiceName,
    String? description,
  }) async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    try {
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        throw Exception('Audio-Datei nicht gefunden: $audioPath');
      }

      // Prüfe Dateigröße und Dauer
      final fileSize = await audioFile.length();
      final fileSizeMB = fileSize / (1024 * 1024);
      
      if (fileSizeMB > 25) {
        throw Exception('Audio-Datei zu groß (max. 25MB)');
      }

      // Erstelle FormData für Multipart Upload
      final formData = FormData.fromMap({
        'name': voiceName,
        if (description != null) 'description': description,
        'files': await MultipartFile.fromFile(
          audioPath,
          filename: audioPath.split('/').last,
        ),
      });

      // API Request
      final response = await _dio.post(
        '/voices/add',
        data: formData,
      );

      if (response.statusCode == 200) {
        final voiceId = response.data['voice_id'] as String?;
        if (voiceId == null) {
          throw Exception('Voice ID nicht in Response gefunden');
        }
        return voiceId;
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        throw Exception(
          'API Fehler: ${e.response?.statusCode} - ${errorData is Map ? errorData['detail']?.toString() ?? errorData.toString() : errorData}',
        );
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('Voice Cloning fehlgeschlagen: $e');
    }
  }

  /// Generiert TTS mit geklonter Stimme
  /// 
  /// [text] - Text zum Sprechen
  /// [voiceId] - ID der geklonten Stimme
  /// [modelId] - Model ID (optional, default: 'eleven_multilingual_v2')
  /// [voiceSettings] - Voice-Einstellungen (optional)
  /// 
  /// Returns: Pfad zur generierten Audio-Datei
  Future<String> speakWithClonedVoice({
    required String text,
    required String voiceId,
    String? modelId,
    Map<String, dynamic>? voiceSettings,
  }) async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    // Prüfe Cache
    final cacheKey = '$voiceId:$text';
    if (_audioCache.containsKey(cacheKey)) {
      final cachedPath = _audioCache[cacheKey]!;
      if (await File(cachedPath).exists()) {
        return cachedPath;
      }
    }

    try {
      // API Request
      final response = await _dio.post(
        '/text-to-speech/$voiceId',
        data: {
          'text': text,
          'model_id': modelId ?? 'eleven_multilingual_v2',
          'voice_settings': voiceSettings ?? {
            'stability': 0.5,
            'similarity_boost': 0.75,
            'style': 0.0,
            'use_speaker_boost': true,
          },
        },
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Accept': 'audio/mpeg',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Speichere Audio-Datei
        final audioBytes = response.data as List<int>;
        final cacheDir = await getTemporaryDirectory();
        final audioFile = File(
          '${cacheDir.path}/elevenlabs_${DateTime.now().millisecondsSinceEpoch}.mp3',
        );
        
        await audioFile.writeAsBytes(audioBytes);
        
        // Cache speichern
        _audioCache[cacheKey] = audioFile.path;
        
        return audioFile.path;
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorData = e.response?.data;
        throw Exception(
          'API Fehler: ${e.response?.statusCode} - ${errorData is Map ? errorData['detail']?.toString() ?? errorData.toString() : errorData}',
        );
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('TTS Generation fehlgeschlagen: $e');
    }
  }

  /// Ruft alle verfügbaren Stimmen ab
  /// 
  /// Returns: Liste von Voice-Informationen
  Future<List<Map<String, dynamic>>> getVoices() async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    try {
      final response = await _dio.get('/voices');

      if (response.statusCode == 200) {
        final voices = response.data['voices'] as List<dynamic>?;
        return voices?.map((v) => v as Map<String, dynamic>).toList() ?? [];
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Fehler: ${e.response?.statusCode}');
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Stimmen: $e');
    }
  }

  /// Löscht eine geklonte Stimme
  /// 
  /// [voiceId] - ID der zu löschenden Stimme
  Future<void> deleteVoice(String voiceId) async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    try {
      final response = await _dio.delete('/voices/$voiceId');

      if (response.statusCode != 200) {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Fehler: ${e.response?.statusCode}');
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Löschen der Stimme: $e');
    }
  }

  /// Ruft Voice-Einstellungen ab
  /// 
  /// [voiceId] - ID der Stimme
  /// 
  /// Returns: Voice-Einstellungen
  Future<Map<String, dynamic>> getVoiceSettings(String voiceId) async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    try {
      final response = await _dio.get('/voices/$voiceId/settings');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Fehler: ${e.response?.statusCode}');
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Voice-Einstellungen: $e');
    }
  }

  /// Aktualisiert Voice-Einstellungen
  /// 
  /// [voiceId] - ID der Stimme
  /// [settings] - Neue Einstellungen
  Future<void> updateVoiceSettings({
    required String voiceId,
    required Map<String, dynamic> settings,
  }) async {
    if (!isConfigured) {
      throw Exception('ElevenLabs API Key nicht konfiguriert');
    }

    try {
      final response = await _dio.post(
        '/voices/$voiceId/settings',
        data: settings,
      );

      if (response.statusCode != 200) {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('API Fehler: ${e.response?.statusCode}');
      } else {
        throw Exception('Netzwerk-Fehler: ${e.message}');
      }
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren der Voice-Einstellungen: $e');
    }
  }

  /// Prüft ob Audio-Sample für Voice Cloning geeignet ist
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// 
  /// Returns: Map mit Validierungs-Ergebnissen
  Future<Map<String, dynamic>> validateAudioSample(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        return {
          'valid': false,
          'error': 'Datei existiert nicht',
        };
      }

      final size = await file.length();
      final sizeMB = size / (1024 * 1024);

      // Prüfe Größe
      if (sizeMB > 25) {
        return {
          'valid': false,
          'error': 'Datei zu groß (max. 25MB)',
          'sizeMB': sizeMB,
        };
      }

      // Prüfe Format
      final extension = audioPath.split('.').last.toLowerCase();
      final supportedFormats = ['mp3', 'wav', 'm4a', 'ogg'];
      if (!supportedFormats.contains(extension)) {
        return {
          'valid': false,
          'error': 'Format nicht unterstützt (nur: ${supportedFormats.join(", ")})',
        };
      }

      // Geschätzte Dauer (vereinfacht)
      // In Production: echte Audio-Analyse
      final estimatedDuration = (sizeMB * 60).round(); // Geschätzt

      return {
        'valid': true,
        'sizeMB': sizeMB,
        'estimatedDurationSeconds': estimatedDuration,
        'format': extension,
      };
    } catch (e) {
      return {
        'valid': false,
        'error': 'Fehler bei Validierung: $e',
      };
    }
  }

  /// Löscht Cache
  void clearCache() {
    _audioCache.clear();
  }

  /// Löscht eine spezifische Cache-Entry
  void clearCacheEntry(String text, String voiceId) {
    final cacheKey = '$voiceId:$text';
    _audioCache.remove(cacheKey);
  }
}

