import 'package:flutter/material.dart';
import '../core/design_system.dart';
import '../models/speech_analysis_result.dart';

/// Pronunciation Feedback Widget
/// Zeigt detailliertes Feedback zur Aussprache mit visuellen Indikatoren
class PronunciationFeedbackWidget extends StatelessWidget {
  const PronunciationFeedbackWidget({
    super.key,
    required this.result,
    this.onRetry,
    this.onContinue,
  });

  final SpeechAnalysisResult result;
  final VoidCallback? onRetry;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Erfolgs-Animation
        _buildSuccessAnimation(),

        const SizedBox(height: TherapyDesignSystem.spacingXL),

        // Haupt-Feedback
        _buildMainFeedback(),

        const SizedBox(height: TherapyDesignSystem.spacingLG),

        // Detaillierte Metriken
        _buildMetrics(),

        const SizedBox(height: TherapyDesignSystem.spacingXL),

        // Action Buttons
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildSuccessAnimation() {
    final isSuccess = result.isSuccessful;
    final emoji = isSuccess ? '🎉' : '👍';
    final message = isSuccess
        ? 'Gut gemacht!'
        : 'Gut versucht! Weiter so!';

    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 80),
        ),
        const SizedBox(height: TherapyDesignSystem.spacingMD),
        Text(
          message,
          style: TherapyDesignSystem.headingMedium.copyWith(
            color: isSuccess
                ? TherapyDesignSystem.successGreen
                : TherapyDesignSystem.warningYellow,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainFeedback() {
    return Container(
      padding: const EdgeInsets.all(TherapyDesignSystem.spacingLG),
      decoration: BoxDecoration(
        color: TherapyDesignSystem.surfaceWhite,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Zielwort vs. Gesprochenes
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildWordComparison(
                'Zielwort',
                result.targetWord,
                Colors.blue,
              ),
              const Icon(Icons.arrow_forward, size: 32),
              _buildWordComparison(
                'Du hast gesagt',
                result.transcription,
                result.isSuccessful
                    ? TherapyDesignSystem.successGreen
                    : TherapyDesignSystem.warningYellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWordComparison(String label, String word, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TherapyDesignSystem.bodyMedium.copyWith(
            color: TherapyDesignSystem.textSecondary,
          ),
        ),
        const SizedBox(height: TherapyDesignSystem.spacingSM),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: TherapyDesignSystem.spacingLG,
            vertical: TherapyDesignSystem.spacingMD,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusMedium),
            border: Border.all(color: color, width: 2),
          ),
          child: Text(
            word,
            style: TherapyDesignSystem.headingSmall.copyWith(
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMetrics() {
    return Column(
      children: [
        _buildMetricBar(
          'Aussprache',
          result.pronunciationScore,
          TherapyDesignSystem.getFeedbackColor(result.pronunciationScore),
        ),
        const SizedBox(height: TherapyDesignSystem.spacingMD),
        _buildMetricBar(
          'Glasnoća',
          result.volumeLevel,
          result.isVolumeAppropriate
              ? TherapyDesignSystem.successGreen
              : TherapyDesignSystem.warningYellow,
        ),
        const SizedBox(height: TherapyDesignSystem.spacingMD),
        _buildMetricBar(
          'Artikulacija',
          result.articulationScore,
          TherapyDesignSystem.getFeedbackColor(result.articulationScore),
        ),
      ],
    );
  }

  Widget _buildMetricBar(String label, double value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TherapyDesignSystem.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: TherapyDesignSystem.bodyLarge.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: TherapyDesignSystem.spacingSM),
        ClipRRect(
          borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusRound),
          child: LinearProgressIndicator(
            value: value / 100,
            minHeight: 16,
            backgroundColor: TherapyDesignSystem.surfaceGray,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Weiter-Button
        SizedBox(
          width: double.infinity,
          height: TherapyDesignSystem.largeTouchTarget,
          child: ElevatedButton(
            onPressed: onContinue,
            style: TherapyDesignSystem.primaryButtonLarge.copyWith(
              minimumSize: MaterialStateProperty.all(
                const Size(double.infinity, TherapyDesignSystem.largeTouchTarget),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Weiter'),
                const SizedBox(width: TherapyDesignSystem.spacingSM),
                const Icon(Icons.arrow_forward),
              ],
            ),
          ),
        ),
        const SizedBox(height: TherapyDesignSystem.spacingMD),
        // Wiederholen-Button
        SizedBox(
          width: double.infinity,
          height: TherapyDesignSystem.minTouchTarget,
          child: OutlinedButton(
            onPressed: onRetry,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: TherapyDesignSystem.primaryBlue,
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
              ),
              padding: const EdgeInsets.all(TherapyDesignSystem.spacingMD),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh),
                const SizedBox(width: TherapyDesignSystem.spacingSM),
                const Text('Nochmal versuchen'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

