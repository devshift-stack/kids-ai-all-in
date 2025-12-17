import 'package:freezed_annotation/freezed_annotation.dart';

part 'speech_analysis_result.freezed.dart';
part 'speech_analysis_result.g.dart';

/// Speech analysis result from Whisper and audio analysis
@freezed
class SpeechAnalysisResult with _$SpeechAnalysisResult {
  const factory SpeechAnalysisResult({
    // Transcription
    required String transcription,
    required String targetWord,
    
    // Scores (0-100)
    required double pronunciationScore,
    required double volumeLevel, // dB
    required double articulationScore,
    required double similarityScore, // 0-1
    
    // Phoneme analysis
    @Default([]) List<PhonemeAccuracy> phonemeBreakdown,
    
    // Volume analysis
    @Default(0.0) double averageVolume,
    @Default(0.0) double peakVolume,
    @Default(0.0) double volumeConsistency,
    
    // Timing analysis
    Duration? speechDuration,
    Duration? pauseDuration,
    
    // Feedback
    required String feedbackMessage,
    @Default([]) List<String> recommendations,
    
    // Overall assessment
    required bool isSuccessful,
    required bool needsRepetition,
    
    // Metadata
    required DateTime analyzedAt,
    String? audioFilePath,
  }) = _SpeechAnalysisResult;

  factory SpeechAnalysisResult.fromJson(Map<String, dynamic> json) =>
      _$SpeechAnalysisResultFromJson(json);
}

/// Phoneme accuracy breakdown
@freezed
class PhonemeAccuracy with _$PhonemeAccuracy {
  const factory PhonemeAccuracy({
    required String phoneme,
    required double accuracy, // 0-1
    required bool isCorrect,
    String? errorType, // e.g., "substitution", "omission", "distortion"
  }) = _PhonemeAccuracy;

  factory PhonemeAccuracy.fromJson(Map<String, dynamic> json) =>
      _$PhonemeAccuracyFromJson(json);
}

/// Extension methods for SpeechAnalysisResult
extension SpeechAnalysisResultExtensions on SpeechAnalysisResult {
  /// Get overall quality score (weighted average)
  double get overallQualityScore {
    return (pronunciationScore * 0.4 +
            articulationScore * 0.3 +
            similarityScore * 100 * 0.2 +
            (volumeLevel / 100) * 100 * 0.1);
  }

  /// Get phoneme accuracy percentage
  double get phonemeAccuracyPercent {
    if (phonemeBreakdown.isEmpty) return 0.0;
    final correctCount = phonemeBreakdown.where((p) => p.isCorrect).length;
    return (correctCount / phonemeBreakdown.length) * 100;
  }

  /// Check if volume is appropriate
  bool get isVolumeAppropriate {
    return volumeLevel >= 60 && volumeLevel <= 85; // dB range
  }

  /// Get primary issue if any
  String? get primaryIssue {
    if (pronunciationScore < 60) return 'pronunciation';
    if (volumeLevel < 60) return 'volume_too_low';
    if (volumeLevel > 85) return 'volume_too_high';
    if (articulationScore < 60) return 'articulation';
    return null;
  }
}

