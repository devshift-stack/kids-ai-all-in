import 'package:flutter/material.dart';
import '../core/design_system.dart';

/// Feedback Indicator Widget
/// Große, visuelle Status-Anzeige für Kinder
class FeedbackIndicatorWidget extends StatelessWidget {
  const FeedbackIndicatorWidget({
    super.key,
    required this.status,
    required this.message,
    this.animation = true,
  });

  final FeedbackStatus status;
  final String message;
  final bool animation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(TherapyDesignSystem.spacingXL),
      decoration: BoxDecoration(
        color: TherapyDesignSystem.getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        border: Border.all(
          color: TherapyDesignSystem.getStatusColor(status),
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(),
          const SizedBox(height: TherapyDesignSystem.spacingMD),
          Text(
            message,
            style: TherapyDesignSystem.headingSmall.copyWith(
              color: TherapyDesignSystem.getStatusColor(status),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    IconData iconData;
    String emoji;

    switch (status) {
      case FeedbackStatus.success:
        iconData = Icons.check_circle;
        emoji = '🎉';
        break;
      case FeedbackStatus.warning:
        iconData = Icons.info;
        emoji = '👍';
        break;
      case FeedbackStatus.error:
        iconData = Icons.error;
        emoji = '💪';
        break;
      case FeedbackStatus.info:
        iconData = Icons.info_outline;
        emoji = 'ℹ️';
        break;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(width: TherapyDesignSystem.spacingMD),
        Icon(
          iconData,
          size: 64,
          color: TherapyDesignSystem.getStatusColor(status),
        ),
      ],
    );
  }
}

/// Großer Button für Kinder
class LargeTherapyButton extends StatelessWidget {
  const LargeTherapyButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.size = ButtonSize.large,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ButtonSize size;
  final ButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size.size;
    final isPrimary = variant == ButtonVariant.primary;

    return SizedBox(
      width: double.infinity,
      height: buttonSize,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: isPrimary
            ? TherapyDesignSystem.primaryButtonLarge
            : TherapyDesignSystem.secondaryButtonLarge,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 28),
                    const SizedBox(width: TherapyDesignSystem.spacingSM),
                  ],
                  Text(
                    text,
                    style: TherapyDesignSystem.buttonText,
                  ),
                ],
              ),
      ),
    );
  }
}

enum ButtonVariant {
  primary,
  secondary,
}

