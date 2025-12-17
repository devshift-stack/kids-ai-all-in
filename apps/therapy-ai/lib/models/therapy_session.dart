import 'package:freezed_annotation/freezed_annotation.dart';
import 'speech_analysis_result.dart';
import 'exercise.dart';
import 'child_profile.dart';

part 'therapy_session.freezed.dart';
part 'therapy_session.g.dart';

/// Therapy session model
@freezed
class TherapySession with _$TherapySession {
  const factory TherapySession({
    required String id,
    required String childProfileId,
    
    // Session info
    required DateTime startTime,
    DateTime? endTime,
    @Default(SessionStatus.inProgress) SessionStatus status,
    
    // Exercises in this session
    @Default([]) List<ExerciseAttempt> exerciseAttempts,
    
    // Session statistics
    @Default(0) int totalExercises,
    @Default(0) int completedExercises,
    @Default(0) int successfulExercises,
    
    // Performance metrics
    @Default(0.0) double averagePronunciationScore,
    @Default(0.0) double averageVolumeLevel,
    @Default(0.0) double averageArticulationScore,
    
    // Notes
    String? notes,
  }) = _TherapySession;

  factory TherapySession.fromJson(Map<String, dynamic> json) =>
      _$TherapySessionFromJson(json);
}

/// Exercise attempt within a session
@freezed
class ExerciseAttempt with _$ExerciseAttempt {
  const factory ExerciseAttempt({
    required String id,
    required Exercise exercise,
    required DateTime attemptTime,
    
    // Result
    SpeechAnalysisResult? result,
    
    // Attempt status
    @Default(AttemptStatus.pending) AttemptStatus status,
    
    // Number of tries
    @Default(1) int attemptNumber,
    
    // Duration
    Duration? duration,
  }) = _ExerciseAttempt;

  factory ExerciseAttempt.fromJson(Map<String, dynamic> json) =>
      _$ExerciseAttemptFromJson(json);
}

/// Session status
enum SessionStatus {
  inProgress,
  completed,
  paused,
  cancelled,
}

/// Attempt status
enum AttemptStatus {
  pending,
  inProgress,
  completed,
  failed,
  skipped,
}

/// Extension methods for TherapySession
extension TherapySessionExtensions on TherapySession {
  /// Calculate session duration
  Duration? get duration {
    if (endTime == null) return null;
    return endTime!.difference(startTime);
  }

  /// Calculate success rate
  double get successRate {
    if (completedExercises == 0) return 0.0;
    return (successfulExercises / completedExercises) * 100;
  }

  /// Check if session is complete
  bool get isComplete => status == SessionStatus.completed;

  /// Get progress percentage
  double get progressPercent {
    if (totalExercises == 0) return 0.0;
    return (completedExercises / totalExercises) * 100;
  }
}

