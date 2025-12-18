import 'package:flutter/material.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../core/design_system.dart';
import '../models/exercise.dart';

/// Exercise Card Widget
/// Zeigt eine Übung in einer großen, kindgerechten Karte
class ExerciseCardWidget extends StatelessWidget {
  const ExerciseCardWidget({
    super.key,
    required this.exercise,
    this.onTap,
    this.isActive = false,
    this.isCompleted = false,
  });

  final Exercise exercise;
  final VoidCallback? onTap;
  final bool isActive;
  final bool isCompleted;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: TherapyDesignSystem.spacingMD),
        padding: const EdgeInsets.all(TherapyDesignSystem.spacingLG),
        decoration: BoxDecoration(
          color: isActive
              ? KidsColors.primary.withValues(alpha: 0.1)
              : KidsColors.surface,
          borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
          border: Border.all(
            color: isActive
                ? KidsColors.primary
                : KidsColors.gray300,
            width: isActive ? 3 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: isActive ? 15 : 5,
              offset: Offset(0, isActive ? 8 : 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header mit Icon und Status
            Row(
              children: [
                _buildExerciseIcon(),
                const SizedBox(width: TherapyDesignSystem.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getExerciseTypeLabel(),
                        style: TherapyDesignSystem.bodyMediumStyle.copyWith(
                          color: KidsColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: TherapyDesignSystem.spacingXS),
                      Text(
                        exercise.targetWord,
                        style: TherapyDesignSystem.h2Style,
                      ),
                    ],
                  ),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(TherapyDesignSystem.spacingSM),
                    decoration: BoxDecoration(
                      color: KidsColors.success,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
              ],
            ),

            if (exercise.targetPhrase != null) ...[
              const SizedBox(height: TherapyDesignSystem.spacingMD),
              Container(
                padding: const EdgeInsets.all(TherapyDesignSystem.spacingMD),
                decoration: BoxDecoration(
                  color: TherapyDesignSystem.primaryBlue.withValues(alpha: 0.1),
                  borderRadius:
                      BorderRadius.circular(TherapyDesignSystem.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline,
                      color: TherapyDesignSystem.primaryBlue,
                    ),
                    const SizedBox(width: TherapyDesignSystem.spacingSM),
                    Expanded(
                      child: Text(
                        exercise.targetPhrase!,
                        style: TherapyDesignSystem.bodyLarge.copyWith(
                          color: TherapyDesignSystem.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: TherapyDesignSystem.spacingMD),

            // Schwierigkeit und Dauer
            Row(
              children: [
                _buildDifficultyBadge(),
                const SizedBox(width: TherapyDesignSystem.spacingMD),
                _buildDurationBadge(),
              ],
            ),

            if (exercise.instructions != null) ...[
              const SizedBox(height: TherapyDesignSystem.spacingMD),
              Text(
                exercise.instructions!,
                style: TherapyDesignSystem.bodyMedium.copyWith(
                  color: TherapyDesignSystem.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseIcon() {
    IconData iconData;
    Color iconColor;

    switch (exercise.type) {
      case ExerciseType.wordRepetition:
        iconData = Icons.mic;
        iconColor = TherapyDesignSystem.primaryBlue;
        break;
      case ExerciseType.sentencePractice:
        iconData = Icons.chat;
        iconColor = TherapyDesignSystem.secondaryOrange;
        break;
      case ExerciseType.phonemeFocus:
        iconData = Icons.record_voice_over;
        iconColor = TherapyDesignSystem.successGreen;
        break;
      case ExerciseType.volumeControl:
        iconData = Icons.volume_up;
        iconColor = TherapyDesignSystem.warningYellow;
        break;
      case ExerciseType.articulation:
        iconData = Icons.speaker;
        iconColor = TherapyDesignSystem.primaryBlue;
        break;
      case ExerciseType.conversation:
        iconData = Icons.forum;
        iconColor = TherapyDesignSystem.secondaryOrange;
        break;
    }

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusMedium),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 32,
      ),
    );
  }

  String _getExerciseTypeLabel() {
    switch (exercise.type) {
      case ExerciseType.wordRepetition:
        return 'Wort-Wiederholung';
      case ExerciseType.sentencePractice:
        return 'Satz-Übung';
      case ExerciseType.phonemeFocus:
        return 'Fonem-Fokus';
      case ExerciseType.volumeControl:
        return 'Glasnoća';
      case ExerciseType.articulation:
        return 'Artikulacija';
      case ExerciseType.conversation:
        return 'Konverzacija';
    }
  }

  Widget _buildDifficultyBadge() {
    final difficultyColors = [
      TherapyDesignSystem.successGreen, // 1-2
      TherapyDesignSystem.warningYellow, // 3-5
      TherapyDesignSystem.secondaryOrange, // 6-8
      TherapyDesignSystem.errorRed, // 9-10
    ];

    final colorIndex = (exercise.difficultyLevel / 3).floor().clamp(0, 3);
    final color = difficultyColors[colorIndex];

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TherapyDesignSystem.spacingMD,
        vertical: TherapyDesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusSmall),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            'Nivo ${exercise.difficultyLevel}',
            style: TherapyDesignSystem.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge() {
    final minutes = exercise.expectedDuration.inMinutes;
    final seconds = exercise.expectedDuration.inSeconds % 60;
    final durationText = minutes > 0
        ? '${minutes}m ${seconds}s'
        : '${seconds}s';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: TherapyDesignSystem.spacingMD,
        vertical: TherapyDesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        color: TherapyDesignSystem.surfaceGray,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer, size: 16, color: TherapyDesignSystem.textSecondary),
          const SizedBox(width: 4),
          Text(
            durationText,
            style: TherapyDesignSystem.bodyMedium.copyWith(
              color: TherapyDesignSystem.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

