import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Activity Item Widget (v0-kids-ai-ui Design)
/// Für Recent Activity Section im Parent Dashboard
class ActivityItem extends StatelessWidget {
  const ActivityItem({
    super.key,
    required this.activity,
    required this.time,
    required this.points,
  });

  /// Activity description
  final String activity;

  /// Time text (z.B. "Prije 2 sata")
  final String time;

  /// Points earned
  final int points;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Activity and Time
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                activity,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: KidsColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  color: KidsColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Points Badge
        Text(
          '+$points',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: KidsColors.primary,
          ),
        ),
      ],
    );
  }
}

