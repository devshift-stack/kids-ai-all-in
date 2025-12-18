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

  final String status; // 'success', 'warning', 'error', 'info'
  final String message;
  final bool animation;

  @override
  Widget build(BuildContext context) {
    final statusColor = TherapyDesignSystem.getStatusColorByString(status);
    
    return Container(
      padding: const EdgeInsets.all(TherapyDesignSystem.spacingXL),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        border: Border.all(
          color: statusColor,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildIcon(statusColor),
          const SizedBox(height: TherapyDesignSystem.spacingMD),
          Text(
            message,
            style: TherapyDesignSystem.headingSmall.copyWith(
              color: statusColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(Color statusColor) {
    IconData iconData;
    String emoji;

    switch (status.toLowerCase()) {
      case 'success':
        iconData = Icons.check_circle;
        emoji = '🎉';
        break;
      case 'warning':
        iconData = Icons.info;
        emoji = '👍';
        break;
      case 'error':
        iconData = Icons.error;
        emoji = '💪';
        break;
      case 'info':
      default:
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
          color: statusColor,
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
    this.size = 100.0,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double size;
  final ButtonVariant variant;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final buttonSize = size;
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
                    style: TherapyDesignSystem.buttonStyle,
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
