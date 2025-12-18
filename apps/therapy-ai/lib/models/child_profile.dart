import 'package:freezed_annotation/freezed_annotation.dart';

part 'child_profile.freezed.dart';
part 'child_profile.g.dart';

/// Child profile model with hearing loss information
@freezed
class ChildProfile with _$ChildProfile {
  const factory ChildProfile({
    required String id,
    required String name,
    required int age,
    @Default('bs') String language,
    
    // Hearing loss profile
    required double leftEarLossPercent, // 0-100
    required double rightEarLossPercent, // 0-100
    
    // Skill level
    @Default(1) int currentSkillLevel, // 1-10
    
    // Voice settings
    String? clonedVoiceId, // ElevenLabs voice ID
    @Default(1.0) double preferredVolume,
    @Default(0.5) double preferredSpeechRate,
    
    // Therapy goals
    @Default([]) List<String> therapyGoals,
    
    // Timestamps
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ChildProfile;

  factory ChildProfile.fromJson(Map<String, dynamic> json) =>
      _$ChildProfileFromJson(json);
}

/// Extension methods for ChildProfile
extension ChildProfileExtensions on ChildProfile {
  /// Calculate average hearing loss
  double get averageHearingLoss =>
      (leftEarLossPercent + rightEarLossPercent) / 2;

  /// Determine hearing loss severity
  HearingLossSeverity get hearingLossSeverity {
    final avg = averageHearingLoss;
    if (avg < 25) return HearingLossSeverity.normal;
    if (avg < 40) return HearingLossSeverity.mild;
    if (avg < 70) return HearingLossSeverity.moderate;
    if (avg < 90) return HearingLossSeverity.severe;
    return HearingLossSeverity.profound;
  }

  /// Check if hearing loss is asymmetric
  bool get isAsymmetric {
    final difference = (leftEarLossPercent - rightEarLossPercent).abs();
    return difference > 10; // More than 10% difference
  }

  /// Get the better hearing ear
  HearingEar get betterEar {
    return leftEarLossPercent < rightEarLossPercent
        ? HearingEar.left
        : HearingEar.right;
  }
}

/// Hearing loss severity levels
enum HearingLossSeverity {
  normal,
  mild,
  moderate,
  severe,
  profound,
}

/// Hearing ear side
enum HearingEar {
  left,
  right,
}

