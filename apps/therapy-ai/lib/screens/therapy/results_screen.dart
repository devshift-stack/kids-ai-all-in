import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../models/exercise.dart';
import '../../models/speech_analysis_result.dart';
import '../../widgets/pronunciation_feedback_widget.dart';
import '../../core/theme/app_theme.dart';

class ResultsScreen extends ConsumerWidget {
  final Exercise exercise;
  final SpeechAnalysisResult result;

  const ResultsScreen({
    super.key,
    required this.exercise,
    required this.result,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Ergebnis'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success/Failure Header
              _buildResultHeader(),
              const SizedBox(height: 32),

              // Pronunciation Feedback Widget
              PronunciationFeedbackWidget(
                result: result,
                targetWord: exercise.targetWord,
              ),
              const SizedBox(height: 32),

              // Detailed Metrics
              _buildDetailedMetrics(),
              const SizedBox(height: 32),

              // Recommendations
              if (result.recommendations.isNotEmpty) _buildRecommendations(),
              const SizedBox(height: 32),

              // Action Buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    final isSuccess = result.isSuccessful;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isSuccess
            ? KidsGradients.successGradient
            : KidsGradients.warningGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: (isSuccess ? KidsColors.success : KidsColors.warning)
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isSuccess ? '🎉 Sehr gut!' : '👍 Weiter so!',
            style: KidsTypography.h1.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            result.feedbackMessage,
            style: KidsTypography.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detaillierte Analyse',
            style: KidsTypography.h3,
          ),
          const SizedBox(height: 16),
          _buildMetricRow(
            'Aussprache',
            '${result.pronunciationScore.toInt()}%',
            result.pronunciationScore,
          ),
          const Divider(),
          _buildMetricRow(
            'Lautstärke',
            '${result.volumeLevel.toInt()} dB',
            result.volumeLevel / 100,
          ),
          const Divider(),
          _buildMetricRow(
            'Artikulation',
            '${result.articulationScore.toInt()}%',
            result.articulationScore / 100,
          ),
          const Divider(),
          _buildMetricRow(
            'Ähnlichkeit',
            '${(result.similarityScore * 100).toInt()}%',
            result.similarityScore,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: KidsTypography.bodyMedium,
              ),
              Text(
                value,
                style: KidsTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: KidsColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: KidsColors.gray200,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.7 ? KidsColors.success : KidsColors.warning,
            ),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KidsColors.infoLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KidsColors.info),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: KidsColors.info),
              const SizedBox(width: 8),
              Text(
                'Empfehlungen',
                style: KidsTypography.h3.copyWith(
                  color: KidsColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...result.recommendations.map((rec) => Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: KidsColors.info,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        rec,
                        style: KidsTypography.bodyMedium,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: KidsColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              result.needsRepetition ? 'Nochmal versuchen' : 'Nächste Übung',
              style: KidsTypography.button.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (result.needsRepetition) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Zurück zur Übungs-Liste
            },
            child: Text(
              'Überspringen',
              style: KidsTypography.bodyLarge.copyWith(
                color: KidsColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

