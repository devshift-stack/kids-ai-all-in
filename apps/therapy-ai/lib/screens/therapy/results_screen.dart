import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../models/exercise.dart';
import '../../models/speech_analysis_result.dart';
import '../../widgets/pronunciation_feedback_widget.dart';
import '../../widgets/success_animation_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../core/design_system.dart';

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
          padding: EdgeInsets.all(TherapyDesignSystem.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Success Animation (wenn erfolgreich)
              if (result.isSuccessful)
                SizedBox(
                  height: 200,
                  child: SuccessAnimationWidget(),
                ),
              
              // Success/Failure Header
              _buildResultHeader(),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // Pronunciation Feedback Widget
              PronunciationFeedbackWidget(
                result: result,
                targetWord: exercise.targetWord,
              ),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // Detailed Metrics
              _buildDetailedMetrics(),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // Recommendations
              if (result.recommendations.isNotEmpty) _buildRecommendations(),
              SizedBox(height: TherapyDesignSystem.spacingXL),

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
    final statusColor = isSuccess
        ? TherapyDesignSystem.statusSuccess
        : TherapyDesignSystem.statusWarning;
    
    // Haptic Feedback bei Erfolg
    if (isSuccess) {
      TherapyDesignSystem.hapticSuccess();
    }
    
    return Container(
      padding: EdgeInsets.all(TherapyDesignSystem.spacingXXL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isSuccess
              ? [
                  TherapyDesignSystem.statusSuccess,
                  TherapyDesignSystem.statusSuccessLight,
                ]
              : [
                  TherapyDesignSystem.statusWarning,
                  TherapyDesignSystem.statusWarningLight,
                ],
        ),
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: statusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            isSuccess ? '🎉 Sehr gut!' : '👍 Weiter so!',
            style: TherapyDesignSystem.h1Style.copyWith(
              color: Colors.white,
              fontSize: 56,
            ),
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          Text(
            result.feedbackMessage,
            style: TherapyDesignSystem.bodyLargeStyle.copyWith(
              color: Colors.white.withOpacity(0.95),
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedMetrics() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detaillierte Analyse',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingXL),
          _buildMetricRow(
            'Aussprache',
            '${result.pronunciationScore.toInt()}%',
            result.pronunciationScore / 100,
          ),
          Divider(height: TherapyDesignSystem.spacingXL),
          _buildMetricRow(
            'Lautstärke',
            '${result.volumeLevel.toInt()} dB',
            result.volumeLevel / 100,
          ),
          Divider(height: TherapyDesignSystem.spacingXL),
          _buildMetricRow(
            'Artikulation',
            '${result.articulationScore.toInt()}%',
            result.articulationScore / 100,
          ),
          Divider(height: TherapyDesignSystem.spacingXL),
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
    final progressColor = progress >= 0.8
        ? TherapyDesignSystem.statusSuccess
        : progress >= 0.6
            ? TherapyDesignSystem.statusWarning
            : TherapyDesignSystem.statusError;
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: TherapyDesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TherapyDesignSystem.bodyLargeStyle,
              ),
              Text(
                value,
                style: TherapyDesignSystem.bodyLargeStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: TherapyDesignSystem.statusActive,
                  fontSize: 28,
                ),
              ),
            ],
          ),
          SizedBox(height: TherapyDesignSystem.spacingMD),
          Container(
            height: TherapyDesignSystem.progressBarHeightLarge,
            decoration: TherapyDesignSystem.progressBarDecoration,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                decoration: TherapyDesignSystem.progressBarFillDecoration(progressColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: BoxDecoration(
        color: TherapyDesignSystem.statusActiveBg,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        border: Border.all(
          color: TherapyDesignSystem.statusActive,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: TherapyDesignSystem.statusActive,
                size: TherapyDesignSystem.touchTargetIcon * 0.7,
              ),
              SizedBox(width: TherapyDesignSystem.spacingMD),
              Text(
                'Empfehlungen',
                style: TherapyDesignSystem.h3Style.copyWith(
                  color: TherapyDesignSystem.statusActive,
                ),
              ),
            ],
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          ...result.recommendations.map((rec) => Padding(
                padding: EdgeInsets.only(top: TherapyDesignSystem.spacingMD),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: TherapyDesignSystem.touchTargetIcon * 0.4,
                      color: TherapyDesignSystem.statusActive,
                    ),
                    SizedBox(width: TherapyDesignSystem.spacingMD),
                    Expanded(
                      child: Text(
                        rec,
                        style: TherapyDesignSystem.bodyLargeStyle,
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
              TherapyDesignSystem.hapticSelection();
              Navigator.of(context).pop();
            },
            style: TherapyDesignSystem.primaryButtonLarge.copyWith(
              minimumSize: MaterialStateProperty.all(
                Size(double.infinity, TherapyDesignSystem.touchTargetPrimary),
              ),
            ),
            child: Text(
              result.needsRepetition ? 'Nochmal versuchen' : 'Nächste Übung',
              style: TherapyDesignSystem.buttonStyle,
            ),
          ),
        ),
        if (result.needsRepetition) ...[
          SizedBox(height: TherapyDesignSystem.spacingLG),
          SizedBox(
            width: double.infinity,
            height: TherapyDesignSystem.touchTargetSecondary,
            child: TextButton(
              onPressed: () {
                TherapyDesignSystem.hapticSelection();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Zurück zur Übungs-Liste
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
                ),
              ),
              child: Text(
                'Überspringen',
                style: TherapyDesignSystem.bodyLargeStyle.copyWith(
                  color: KidsColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

