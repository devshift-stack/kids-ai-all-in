import 'package:freezed_annotation/freezed_annotation.dart';

part 'exercise.freezed.dart';
part 'exercise.g.dart';

/// Exercise model for therapy sessions
@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String id,
    required ExerciseType type,
    required String targetWord,
    String? targetPhrase, // For sentence exercises
    required int difficultyLevel, // 1-10
    required Duration expectedDuration,
    
    // Success criteria
    @Default(70.0) double minPronunciationScore, // 0-100
    @Default(60.0) double minVolumeLevel, // dB
    @Default(0.8) double minSimilarityScore, // 0-1
    
    // Phoneme focus (optional)
    @Default([]) List<String> focusPhonemes,
    
    // Instructions
    String? instructions,
    
    // Metadata
    @Default([]) List<String> tags,
    DateTime? createdAt,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
}

/// Exercise types
enum ExerciseType {
  wordRepetition, // Simple word repetition
  sentencePractice, // Full sentence practice
  phonemeFocus, // Focus on specific phonemes
  volumeControl, // Volume training
  articulation, // Articulation practice
  conversation, // Conversation practice
}

/// Exercise difficulty levels
class ExerciseDifficulty {
  static const int beginner = 1;
  static const int easy = 2;
  static const int medium = 5;
  static const int hard = 8;
  static const int expert = 10;
}

/// Predefined exercises for different skill levels
class ExerciseLibrary {
  static List<Exercise> getBeginnerExercises() {
    return [
      const Exercise(
        id: 'ex_001',
        type: ExerciseType.wordRepetition,
        targetWord: 'Mama',
        difficultyLevel: 1,
        expectedDuration: Duration(seconds: 30),
        focusPhonemes: ['m', 'a'],
      ),
      const Exercise(
        id: 'ex_002',
        type: ExerciseType.wordRepetition,
        targetWord: 'Papa',
        difficultyLevel: 1,
        expectedDuration: Duration(seconds: 30),
        focusPhonemes: ['p', 'a'],
      ),
      const Exercise(
        id: 'ex_003',
        type: ExerciseType.wordRepetition,
        targetWord: 'Hallo',
        difficultyLevel: 1,
        expectedDuration: Duration(seconds: 30),
        focusPhonemes: ['h', 'a', 'l', 'o'],
      ),
    ];
  }

  static List<Exercise> getIntermediateExercises() {
    return [
      const Exercise(
        id: 'ex_101',
        type: ExerciseType.sentencePractice,
        targetWord: 'Ich',
        targetPhrase: 'Ich heiße Max',
        difficultyLevel: 5,
        expectedDuration: Duration(seconds: 45),
      ),
      const Exercise(
        id: 'ex_102',
        type: ExerciseType.phonemeFocus,
        targetWord: 'Schule',
        difficultyLevel: 5,
        expectedDuration: Duration(seconds: 40),
        focusPhonemes: ['sch', 'u', 'l', 'e'],
      ),
    ];
  }

  static List<Exercise> getAdvancedExercises() {
    return [
      const Exercise(
        id: 'ex_201',
        type: ExerciseType.conversation,
        targetWord: 'Guten',
        targetPhrase: 'Guten Morgen, wie geht es dir?',
        difficultyLevel: 8,
        expectedDuration: Duration(seconds: 60),
      ),
    ];
  }
}

