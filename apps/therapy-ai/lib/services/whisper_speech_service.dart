import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import '../core/env_config.dart';
import '../core/config.dart';
import '../core/error_handler.dart';
import '../models/speech_analysis_result.dart';
import '../core/constants/app_constants.dart';

/// Whisper Speech Recognition Service
/// Verwendet OpenAI Whisper API für Speech-to-Text und Analyse
class WhisperSpeechService {
  final Dio _dio = Dio();
  String? _openAiApiKey;

  WhisperSpeechService() {
    _initialize();
  }

  Future<void> _initialize() async {
    _openAiApiKey = EnvConfig.openAiApiKey;
    
    _dio.options.baseUrl = EnvConfig.openAiApiBaseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_openAiApiKey',
      'Content-Type': 'multipart/form-data',
    };
    
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  /// Prüft ob Service konfiguriert ist
  bool get isConfigured => _openAiApiKey != null && _openAiApiKey!.isNotEmpty;

  /// Transkribiert Audio-Datei zu Text
  /// 
  /// [audioPath] - Pfad zur Audio-Datei (WAV, MP3, M4A, etc.)
  /// [language] - Sprach-Code (optional, z.B. 'de', 'bs', 'en')
  /// 
  /// Returns: Transkribierter Text
  Future<String> transcribeAudio({
    required String audioPath,
    String? language,
  }) async {
    if (!isConfigured) {
      throw Exception('OpenAI API Key nicht konfiguriert');
    }

    try {
      final audioFile = File(audioPath);
      if (!await audioFile.exists()) {
        throw Exception('Audio-Datei nicht gefunden: $audioPath');
      }

      // Erstelle FormData für Multipart Upload
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          audioPath,
          filename: audioPath.split('/').last,
        ),
        'model': 'whisper-1',
        if (language != null) 'language': language,
        'response_format': 'json',
      });

      // API Request mit Retry-Logik
      final response = await ErrorHandler.executeWithRetry(
        function: () async {
          return await _dio.post(
            '/audio/transcriptions',
            data: formData,
          );
        },
        onRetry: (attempt, delay) {
          debugPrint('Whisper API Retry $attempt nach ${delay.inSeconds}s...');
        },
      );

      if (response.statusCode == 200) {
        final text = response.data['text'] as String?;
        return text ?? '';
      } else {
        throw Exception('API Fehler: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleError(e);
    } catch (e) {
      throw Exception('Transkription fehlgeschlagen: ${ErrorHandler.handleError(e)}');
    }
  }

  /// Analysiert Audio mit detaillierten Metriken
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// [targetWord] - Zielwort für Vergleich
  /// [language] - Sprach-Code
  /// 
  /// Returns: Detailliertes SpeechAnalysisResult
  Future<SpeechAnalysisResult> analyzeSpeech({
    required String audioPath,
    required String targetWord,
    String? language,
  }) async {
    try {
      // 1. Transkription
      final transcription = await transcribeAudio(
        audioPath: audioPath,
        language: language,
      );

      // 2. Basis-Analyse
      final similarity = _calculateSimilarity(targetWord.toLowerCase(), transcription.toLowerCase());
      final pronunciationScore = similarity * 100;

      // 3. Audio-Features analysieren (Volume, etc.)
      final audioFeatures = await _analyzeAudioFeatures(audioPath);

      // 4. Phoneme-Analyse (vereinfacht)
      final phonemeBreakdown = _analyzePhonemes(targetWord, transcription);

      // 5. Feedback generieren
      final feedback = _generateFeedback(pronunciationScore, similarity);
      final recommendations = _generateRecommendations(pronunciationScore, audioFeatures);

      return SpeechAnalysisResult(
        transcription: transcription,
        targetWord: targetWord,
        pronunciationScore: pronunciationScore,
        volumeLevel: audioFeatures['volume'] ?? 70.0,
        articulationScore: pronunciationScore * 0.9, // Vereinfacht
        similarityScore: similarity,
        phonemeBreakdown: phonemeBreakdown,
        averageVolume: audioFeatures['volume'] ?? 70.0,
        peakVolume: audioFeatures['peakVolume'] ?? 80.0,
        volumeConsistency: audioFeatures['consistency'] ?? 0.8,
        speechDuration: audioFeatures['duration'],
        feedbackMessage: feedback,
        recommendations: recommendations,
        isSuccessful: pronunciationScore >= 70.0,
        needsRepetition: pronunciationScore < 60.0,
        analyzedAt: DateTime.now(),
        audioFilePath: audioPath,
      );
    } catch (e) {
      // Bei Fehler: Fallback mit Basis-Analyse
      debugPrint('Fehler bei Speech-Analyse: $e');
      return SpeechAnalysisResult(
        transcription: '',
        targetWord: targetWord,
        pronunciationScore: 0.0,
        volumeLevel: 0.0,
        articulationScore: 0.0,
        similarityScore: 0.0,
        feedbackMessage: 'Fehler bei der Analyse. Bitte versuche es erneut.',
        recommendations: ['Überprüfe deine Internetverbindung', 'Versuche es nochmal'],
        isSuccessful: false,
        needsRepetition: true,
        analyzedAt: DateTime.now(),
        audioFilePath: audioPath,
      );
    }
  }

  /// Berechnet Ähnlichkeit zwischen zwei Strings
  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0.0;
    if (s1 == s2) return 1.0;

    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    final distance = _levenshteinDistance(s1, s2);
    return 1.0 - (distance / maxLen);
  }

  /// Levenshtein-Distanz für String-Vergleich
  int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (int i = 0; i <= m; i++) dp[i][0] = i;
    for (int j = 0; j <= n; j++) dp[0][j] = j;

    for (int i = 1; i <= m; i++) {
      for (int j = 1; j <= n; j++) {
        if (s1[i - 1] == s2[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [
            dp[i - 1][j],
            dp[i][j - 1],
            dp[i - 1][j - 1],
          ].reduce((a, b) => a < b ? a : b);
        }
      }
    }

    return dp[m][n];
  }

  /// Analysiert Audio-Features (Volume, Duration, etc.)
  Future<Map<String, dynamic>> _analyzeAudioFeatures(String audioPath) async {
    // Vereinfachte Implementierung
    // In Production: Audio-Library für detaillierte Analyse verwenden
    
    final file = File(audioPath);
    final exists = await file.exists();
    final size = exists ? await file.length() : 0;
    
    // Geschätzte Dauer basierend auf Dateigröße (vereinfacht)
    // In Production: Audio-Library für echte Dauer verwenden
    final estimatedDuration = Duration(
      milliseconds: (size / 16000 * 1000).round(), // Geschätzt
    );

    return {
      'volume': 70.0, // Placeholder - in Production: echte Analyse
      'peakVolume': 80.0,
      'consistency': 0.8,
      'duration': estimatedDuration,
    };
  }

  /// Analysiert Phoneme (vereinfacht)
  List<PhonemeAccuracy> _analyzePhonemes(String target, String spoken) {
    final targetPhonemes = target.split('');
    final spokenPhonemes = spoken.split('');
    final results = <PhonemeAccuracy>[];

    final maxLen = targetPhonemes.length > spokenPhonemes.length
        ? targetPhonemes.length
        : spokenPhonemes.length;

    for (int i = 0; i < maxLen; i++) {
      final targetPhoneme = i < targetPhonemes.length ? targetPhonemes[i] : '';
      final spokenPhoneme = i < spokenPhonemes.length ? spokenPhonemes[i] : '';

      final isCorrect = targetPhoneme.toLowerCase() == spokenPhoneme.toLowerCase();
      final accuracy = isCorrect ? 1.0 : 0.5;

      results.add(PhonemeAccuracy(
        phoneme: targetPhoneme.isNotEmpty ? targetPhoneme : spokenPhoneme,
        accuracy: accuracy,
        isCorrect: isCorrect,
        errorType: isCorrect ? null : 'substitution',
      ));
    }

    return results;
  }

  /// Generiert Feedback-Nachricht
  String _generateFeedback(double pronunciationScore, double similarity) {
    if (pronunciationScore >= 90) {
      return 'Ausgezeichnet! Perfekte Aussprache! 🎉';
    } else if (pronunciationScore >= 80) {
      return 'Sehr gut gemacht! Fast perfekt! 👍';
    } else if (pronunciationScore >= 70) {
      return 'Gut gemacht! Weiter so! 😊';
    } else if (pronunciationScore >= 60) {
      return 'Gut versucht! Noch ein bisschen üben. 💪';
    } else {
      return 'Versuch es nochmal! Du schaffst das! 🌟';
    }
  }

  /// Generiert Empfehlungen
  List<String> _generateRecommendations(
    double pronunciationScore,
    Map<String, dynamic> audioFeatures,
  ) {
    final recommendations = <String>[];

    if (pronunciationScore < 70) {
      recommendations.add('Sprich langsamer und deutlicher');
    }

    final volume = audioFeatures['volume'] as double? ?? 70.0;
    if (volume < 60) {
      recommendations.add('Sprich etwas lauter');
    } else if (volume > 85) {
      recommendations.add('Sprich etwas leiser');
    }

    if (pronunciationScore < 60) {
      recommendations.add('Höre dir das Wort nochmal an');
    }

    return recommendations;
  }

  /// Berechnet Volume-Level aus Audio
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// 
  /// Returns: Volume in dB (0-100)
  Future<double> calculateVolumeLevel(String audioPath) async {
    // Placeholder - in Production: echte Audio-Analyse
    // Könnte mit just_audio oder ähnlicher Library implementiert werden
    return 70.0;
  }

  /// Prüft ob Audio-Datei gültig ist
  Future<bool> validateAudioFile(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) return false;

      final size = await file.length();
      if (size < 1000) return false; // Mindestens 1KB

      // Prüfe Datei-Endung
      final extension = audioPath.split('.').last.toLowerCase();
      final supportedFormats = ['wav', 'mp3', 'm4a', 'ogg', 'flac'];
      return supportedFormats.contains(extension);
    } catch (e) {
      return false;
    }
  }
}

