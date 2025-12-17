import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/therapy_session.dart';
import '../models/exercise.dart';
import '../models/speech_analysis_result.dart';
import '../services/progress_tracking_service.dart';
import 'services_providers.dart';

/// Therapy Session State
class TherapySessionState {
  final TherapySession? currentSession;
  final Exercise? currentExercise;
  final bool isRecording;
  final bool isAnalyzing;
  final SpeechAnalysisResult? lastResult;
  final String? error;

  const TherapySessionState({
    this.currentSession,
    this.currentExercise,
    this.isRecording = false,
    this.isAnalyzing = false,
    this.lastResult,
    this.error,
  });

  TherapySessionState copyWith({
    TherapySession? currentSession,
    Exercise? currentExercise,
    bool? isRecording,
    bool? isAnalyzing,
    SpeechAnalysisResult? lastResult,
    String? error,
  }) {
    return TherapySessionState(
      currentSession: currentSession ?? this.currentSession,
      currentExercise: currentExercise ?? this.currentExercise,
      isRecording: isRecording ?? this.isRecording,
      isAnalyzing: isAnalyzing ?? this.isAnalyzing,
      lastResult: lastResult ?? this.lastResult,
      error: error ?? this.error,
    );
  }
}

/// Therapy Session Notifier
class TherapySessionNotifier extends StateNotifier<TherapySessionState> {
  final ProgressTrackingService _progressService;
  final AdaptiveExerciseService _adaptiveService;

  TherapySessionNotifier(this._progressService, this._adaptiveService)
      : super(const TherapySessionState());

  /// Startet eine neue Therapie-Session
  Future<void> startSession(String childProfileId) async {
    try {
      final session = TherapySession(
        id: const Uuid().v4(),
        childProfileId: childProfileId,
        startTime: DateTime.now(),
        status: SessionStatus.inProgress,
      );

      state = state.copyWith(
        currentSession: session,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Fehler beim Starten der Session: $e',
      );
    }
  }

  /// Beendet die aktuelle Session
  Future<void> endSession() async {
    if (state.currentSession == null) return;

    try {
      final session = state.currentSession!.copyWith(
        endTime: DateTime.now(),
        status: SessionStatus.completed,
      );

      // Speichere Session
      await _progressService.saveSession(session);

      state = state.copyWith(
        currentSession: null,
        currentExercise: null,
        lastResult: null,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Fehler beim Beenden der Session: $e',
      );
    }
  }

  /// Setzt die aktuelle Übung
  void setCurrentExercise(Exercise exercise) {
    state = state.copyWith(currentExercise: exercise);
  }

  /// Speichert Übungs-Ergebnis
  Future<void> recordExerciseResult({
    required String childId,
    required SpeechAnalysisResult result,
  }) async {
    if (state.currentExercise == null || state.currentSession == null) return;

    try {
      // Speichere Ergebnis
      await _progressService.saveExerciseResult(
        childId: childId,
        exerciseId: state.currentExercise!.id,
        result: result,
      );

      // Aktualisiere Session
      final session = state.currentSession!;
      final updatedAttempts = [
        ...session.exerciseAttempts,
        ExerciseAttempt(
          id: const Uuid().v4(),
          exercise: state.currentExercise!,
          attemptTime: DateTime.now(),
          result: result,
          status: result.isSuccessful
              ? AttemptStatus.completed
              : AttemptStatus.failed,
          duration: result.speechDuration,
        ),
      ];

      final completedCount = updatedAttempts
          .where((a) => a.status == AttemptStatus.completed)
          .length;

      final successfulCount = updatedAttempts
          .where((a) => a.result?.isSuccessful == true)
          .length;

      final avgPronunciation = updatedAttempts
          .where((a) => a.result != null)
          .map((a) => a.result!.pronunciationScore)
          .fold(0.0, (a, b) => a + b) /
          (updatedAttempts.where((a) => a.result != null).length);

      final avgVolume = updatedAttempts
          .where((a) => a.result != null)
          .map((a) => a.result!.volumeLevel)
          .fold(0.0, (a, b) => a + b) /
          (updatedAttempts.where((a) => a.result != null).length);

      final avgArticulation = updatedAttempts
          .where((a) => a.result != null)
          .map((a) => a.result!.articulationScore)
          .fold(0.0, (a, b) => a + b) /
          (updatedAttempts.where((a) => a.result != null).length);

      final updatedSession = session.copyWith(
        exerciseAttempts: updatedAttempts,
        completedExercises: completedCount,
        successfulExercises: successfulCount,
        averagePronunciationScore: avgPronunciation,
        averageVolumeLevel: avgVolume,
        averageArticulationScore: avgArticulation,
        totalExercises: updatedAttempts.length,
      );

      state = state.copyWith(
        currentSession: updatedSession,
        lastResult: result,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Fehler beim Speichern: $e',
      );
    }
  }

  /// Setzt Recording-Status
  void setRecording(bool isRecording) {
    state = state.copyWith(isRecording: isRecording);
  }

  /// Setzt Analyzing-Status
  void setAnalyzing(bool isAnalyzing) {
    state = state.copyWith(isAnalyzing: isAnalyzing);
  }
}

/// Therapy Session Provider
final therapySessionProvider =
    StateNotifierProvider<TherapySessionNotifier, TherapySessionState>((ref) {
  final progressService = ref.watch(progressTrackingServiceProvider);
  final adaptiveService = ref.watch(adaptiveExerciseServiceProvider);
  return TherapySessionNotifier(progressService, adaptiveService);
});

