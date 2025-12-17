import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import 'modern_card.dart';
import 'modern_badge.dart';

/// Badge Card Widget (v0-kids-ai-ui Design)
/// Für Achievements Grid in Child Progress Page
class BadgeCard extends StatelessWidget {
  const BadgeCard({
    super.key,
    required this.emoji,
    required this.title,
    this.unlocked = false,
    this.onTap,
  });

  /// Emoji icon (z.B. "🌟")
  final String emoji;

  /// Badge title
  final String title;

  /// Whether the badge is unlocked
  final bool unlocked;

  /// Tap callback
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: unlocked ? 1.0 : 0.5,
      child: ModernCard(
        onTap: onTap,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji
            Text(
              emoji,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: unlocked
                    ? KidsColors.textPrimary
                    : KidsColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            // Status Badge
            if (unlocked) ...[
              const SizedBox(height: 8),
              const ModernBadge(
                text: 'Otključano',
                variant: BadgeVariant.success,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

