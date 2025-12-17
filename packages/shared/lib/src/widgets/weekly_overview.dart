import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Weekly Overview Widget (v0-kids-ai-ui Design)
/// 7-Tage-Grid für Parent Dashboard
class WeeklyOverview extends StatelessWidget {
  const WeeklyOverview({
    super.key,
    required this.dayData,
    this.onDayTap,
  });

  /// Map of day abbreviations to time strings
  /// Example: {"Pon": "30m", "Uto": "35m", ...}
  final Map<String, String> dayData;

  /// Callback when a day is tapped
  final void Function(String day)? onDayTap;

  static const List<String> _days = [
    'Pon',
    'Uto',
    'Sri',
    'Čet',
    'Pet',
    'Sub',
    'Ned',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: _days.length,
      itemBuilder: (context, index) {
        final day = _days[index];
        final time = dayData[day] ?? '-';
        final hasData = time != '-';

        return GestureDetector(
          onTap: onDayTap != null ? () => onDayTap!(day) : null,
          child: Column(
            children: [
              // Day Name
              Text(
                day,
                style: const TextStyle(
                  fontSize: 12,
                  color: KidsColors.textSecondary,
                ),
              ),
              const SizedBox(height: 8),
              // Day Box
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: hasData
                        ? KidsColors.primary.withValues(alpha: 0.1)
                        : KidsColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(KidsSpacing.radiusSm),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: hasData
                            ? KidsColors.textPrimary
                            : KidsColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

