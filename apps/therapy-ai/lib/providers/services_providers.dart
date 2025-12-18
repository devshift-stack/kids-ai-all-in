import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

// ============================================================
// ADDITIONAL PROVIDERS (für main.dart)
// ============================================================

/// Shared Preferences Provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Theme Mode Provider
final themeModeProvider = StateProvider<ThemeMode>((ref) {
  return ThemeMode.system;
});

/// Firebase Service Provider (Placeholder - muss implementiert werden)
final firebaseServiceProvider = Provider<dynamic>((ref) {
  // TODO: Implementiere Firebase Service
  return null;
});

