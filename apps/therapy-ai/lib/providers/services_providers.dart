import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/whisper_speech_service.dart';
import '../services/elevenlabs_voice_service.dart';
import '../services/audio_analysis_service.dart';
import '../services/adaptive_exercise_service.dart';
import '../services/progress_tracking_service.dart';

/// Whisper Speech Service Provider
final whisperSpeechServiceProvider = Provider<WhisperSpeechService>((ref) {
  return WhisperSpeechService();
});

/// ElevenLabs Voice Service Provider
final elevenLabsVoiceServiceProvider = Provider<ElevenLabsVoiceService>((ref) {
  return ElevenLabsVoiceService();
});

/// Audio Analysis Service Provider
final audioAnalysisServiceProvider = Provider<AudioAnalysisService>((ref) {
  return AudioAnalysisService();
});

/// Adaptive Exercise Service Provider
final adaptiveExerciseServiceProvider = Provider<AdaptiveExerciseService>((ref) {
  return AdaptiveExerciseService();
});

/// Progress Tracking Service Provider
final progressTrackingServiceProvider = Provider<ProgressTrackingService>((ref) {
  return ProgressTrackingService();
});

