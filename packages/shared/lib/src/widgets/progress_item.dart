import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'modern_progress.dart';

/// Progress Item Widget (v0-kids-ai-ui Design)
/// Für Learning Progress Section im Parent Dashboard
class ProgressItem extends StatelessWidget {
  const ProgressItem({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  /// Label text (z.B. "Čitanje i pisanje")
  final String label;

  /// Progress value (0-100)
  final double value;

  /// Progress color (defaults to primary)
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final progressColor = color ?? KidsColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label and Percentage
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: KidsColors.textPrimary,
              ),
            ),
            Text(
              '${value.toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                color: KidsColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Progress Bar
        ModernProgress(
          value: value / 100,
          height: 8,
          color: progressColor,
          animated: true,
        ),
      ],
    );
  }
}

