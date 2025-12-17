import 'dart:io';
import 'dart:typed_data';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';

/// Audio Analysis Service
/// Handles audio recording, analysis, and feature extraction
class AudioAnalysisService {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  String? _currentRecordingPath;

  /// Startet Audio-Aufnahme
  /// 
  /// [duration] - Maximale Aufnahme-Dauer (optional)
  /// 
  /// Returns: Pfad zur aufgenommenen Audio-Datei
  Future<String> startRecording({
    Duration? duration,
  }) async {
    if (_isRecording) {
      throw Exception('Aufnahme läuft bereits');
    }

    try {
      // Prüfe Mikrofon-Berechtigung
      if (!await _recorder.hasPermission()) {
        throw Exception('Mikrofon-Berechtigung nicht erteilt');
      }

      // Erstelle Aufnahme-Pfad
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final recordingPath = '${directory.path}/recording_$timestamp.m4a';

      // Starte Aufnahme
      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: AppConstants.audioSampleRate,
          numChannels: AppConstants.audioChannels,
        ),
        path: recordingPath,
      );

      _isRecording = true;
      _currentRecordingPath = recordingPath;

      // Stoppe nach maximaler Dauer (falls angegeben)
      if (duration != null) {
        Future.delayed(duration, () {
          if (_isRecording) {
            stopRecording();
          }
        });
      }

      return recordingPath;
    } catch (e) {
      throw Exception('Fehler beim Starten der Aufnahme: $e');
    }
  }

  /// Stoppt Audio-Aufnahme
  /// 
  /// Returns: Pfad zur aufgenommenen Audio-Datei
  Future<String?> stopRecording() async {
    if (!_isRecording) {
      return null;
    }

    try {
      final path = await _recorder.stop();
      _isRecording = false;
      _currentRecordingPath = null;
      return path;
    } catch (e) {
      _isRecording = false;
      _currentRecordingPath = null;
      throw Exception('Fehler beim Stoppen der Aufnahme: $e');
    }
  }

  /// Prüft ob gerade aufgenommen wird
  bool get isRecording => _isRecording;

  /// Gibt den aktuellen Aufnahme-Pfad zurück
  String? get currentRecordingPath => _currentRecordingPath;

  /// Analysiert Audio-Features
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// 
  /// Returns: Map mit Audio-Features
  Future<Map<String, dynamic>> analyzeAudioFeatures(String audioPath) async {
    try {
      final file = File(audioPath);
      if (!await file.exists()) {
        throw Exception('Audio-Datei nicht gefunden: $audioPath');
      }

      // Lade Audio mit just_audio für Analyse
      await _audioPlayer.setFilePath(audioPath);
      final duration = _audioPlayer.duration ?? Duration.zero;

      // Basis-Features
      final fileSize = await file.length();
      final fileSizeMB = fileSize / (1024 * 1024);

      // Geschätzte Features (vereinfacht)
      // In Production: Detaillierte Audio-Analyse mit speziellen Libraries
      final estimatedVolume = _estimateVolume(fileSize, duration);
      final estimatedPeak = estimatedVolume * 1.2; // Geschätzt
      final estimatedConsistency = 0.8; // Placeholder

      return {
        'duration': duration,
        'fileSize': fileSize,
        'fileSizeMB': fileSizeMB,
        'volume': estimatedVolume,
        'peakVolume': estimatedPeak,
        'consistency': estimatedConsistency,
        'sampleRate': AppConstants.audioSampleRate,
        'channels': AppConstants.audioChannels,
      };
    } catch (e) {
      throw Exception('Fehler bei Audio-Analyse: $e');
    } finally {
      await _audioPlayer.stop();
    }
  }

  /// Schätzt Volume-Level (vereinfacht)
  /// In Production: Echte Audio-Analyse mit FFT
  double _estimateVolume(int fileSize, Duration duration) {
    // Vereinfachte Schätzung basierend auf Dateigröße und Dauer
    final seconds = duration.inSeconds;
    if (seconds == 0) return 0.0;

    final bytesPerSecond = fileSize / seconds;
    // Normalisiere zu 0-100 dB Skala (vereinfacht)
    final normalized = (bytesPerSecond / 1000).clamp(0.0, 100.0);
    return normalized;
  }

  /// Berechnet Volume-Level in dB
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// 
  /// Returns: Volume in dB (0-100)
  Future<double> calculateVolumeLevel(String audioPath) async {
    final features = await analyzeAudioFeatures(audioPath);
    return features['volume'] as double? ?? 70.0;
  }

  /// Extrahiert Phoneme aus Audio (vereinfacht)
  /// 
  /// In Production: Spezielle Phoneme-Detection-Library verwenden
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// [targetPhonemes] - Erwartete Phoneme
  /// 
  /// Returns: Liste von erkannten Phonemen
  Future<List<String>> extractPhonemes(
    String audioPath,
    List<String> targetPhonemes,
  ) async {
    // Placeholder - in Production: Echte Phoneme-Extraktion
    // Könnte mit speziellen ML-Modellen oder Libraries implementiert werden
    
    // Für jetzt: Vereinfachte Implementierung
    // Die eigentliche Phoneme-Analyse wird in WhisperSpeechService gemacht
    return targetPhonemes;
  }

  /// Vergleicht Phoneme
  /// 
  /// [targetPhonemes] - Ziel-Phoneme
  /// [spokenPhonemes] - Gesprochene Phoneme
  /// 
  /// Returns: Map mit Vergleichs-Ergebnissen
  Map<String, dynamic> comparePhonemes(
    List<String> targetPhonemes,
    List<String> spokenPhonemes,
  ) {
    final matches = <String, bool>{};
    final accuracy = <String, double>{};

    final maxLen = targetPhonemes.length > spokenPhonemes.length
        ? targetPhonemes.length
        : spokenPhonemes.length;

    for (int i = 0; i < maxLen; i++) {
      final target = i < targetPhonemes.length ? targetPhonemes[i] : '';
      final spoken = i < spokenPhonemes.length ? spokenPhonemes[i] : '';

      final isMatch = target.toLowerCase() == spoken.toLowerCase();
      matches[target.isNotEmpty ? target : 'missing'] = isMatch;
      accuracy[target.isNotEmpty ? target : 'missing'] = isMatch ? 1.0 : 0.0;
    }

    final correctCount = matches.values.where((v) => v).length;
    final totalCount = matches.length;
    final overallAccuracy = totalCount > 0 ? (correctCount / totalCount) : 0.0;

    return {
      'matches': matches,
      'accuracy': accuracy,
      'overallAccuracy': overallAccuracy,
      'correctCount': correctCount,
      'totalCount': totalCount,
    };
  }

  /// Erkennt Hörverlust-Muster in Audio
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  /// 
  /// Returns: Map mit erkannten Mustern
  Future<Map<String, dynamic>> detectHearingLossPatterns(
    String audioPath,
  ) async {
    // Placeholder - in Production: Spezielle Analyse für Hörverlust-Muster
    // Könnte Frequenz-Analyse, Lautstärke-Variationen, etc. umfassen

    final features = await analyzeAudioFeatures(audioPath);
    final volume = features['volume'] as double? ?? 70.0;

    // Vereinfachte Muster-Erkennung
    final patterns = <String, dynamic>{
      'lowVolume': volume < 60,
      'inconsistentVolume': (features['consistency'] as double? ?? 0.8) < 0.7,
      'estimatedSeverity': _estimateSeverity(volume),
    };

    return patterns;
  }

  /// Schätzt Hörverlust-Schweregrad basierend auf Audio-Features
  String _estimateSeverity(double volume) {
    if (volume < 40) return 'severe';
    if (volume < 60) return 'moderate';
    if (volume < 75) return 'mild';
    return 'normal';
  }

  /// Spielt Audio ab
  /// 
  /// [audioPath] - Pfad zur Audio-Datei
  Future<void> playAudio(String audioPath) async {
    try {
      await _audioPlayer.setFilePath(audioPath);
      await _audioPlayer.play();
    } catch (e) {
      throw Exception('Fehler beim Abspielen: $e');
    }
  }

  /// Stoppt Audio-Wiedergabe
  Future<void> stopPlayback() async {
    await _audioPlayer.stop();
  }

  /// Prüft ob Audio abgespielt wird
  bool get isPlaying => _audioPlayer.playing;

  /// Gibt aktuelle Wiedergabe-Position zurück
  Duration get playbackPosition => _audioPlayer.position;

  /// Gibt Audio-Dauer zurück
  Duration? get audioDuration => _audioPlayer.duration;

  /// Bereinigt Ressourcen
  Future<void> dispose() async {
    if (_isRecording) {
      await stopRecording();
    }
    await _recorder.dispose();
    await _audioPlayer.dispose();
  }
}

