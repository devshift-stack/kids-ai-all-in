import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';
import '../theme/shadows.dart';
import 'modern_progress.dart';

/// Modern Card mit Backdrop Blur (v0-kids-ai-ui Design)
class ModernCard extends StatelessWidget {
  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = 2,
    this.withBackdropBlur = true,
  });

  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final int elevation;
  final bool withBackdropBlur;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? KidsColors.surfaceTransparent,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        boxShadow: _getShadow(),
      ),
      child: withBackdropBlur
          ? ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: child,
              ),
            )
          : child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: card,
      );
    }

    return card;
  }

  List<BoxShadow> _getShadow() {
    switch (elevation) {
      case 0:
        return KidsShadows.none;
      case 1:
        return KidsShadows.card;
      case 2:
        return KidsShadows.elevated; // shadow-xl für modernes Design
      case 3:
        return [
          ...KidsShadows.elevated,
          BoxShadow(
            color: KidsColors.primary.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];
      default:
        return KidsShadows.elevated;
    }
  }
}

/// Activity Card - Für Lernaktivitäten (v0-kids-ai-ui Design)
class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.icon,
    required this.title,
    required this.progress,
    required this.color,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final double progress; // 0.0 - 1.0
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon Container
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: icon),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          // Progress Bar
          ModernProgress(
            value: progress,
            height: 8,
            color: color,
            animated: true,
          ),
          const SizedBox(height: 8),
          // Progress Text
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(
              fontSize: 14,
              color: KidsColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Challenge Card - Für tägliche Herausforderungen (v0-kids-ai-ui Design)
class ChallengeCard extends StatelessWidget {
  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    required this.reward,
    required this.completed,
    required this.total,
    this.onTap,
  });

  final String title;
  final String description;
  final int reward;
  final int completed;
  final int total;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final progress = total > 0 ? completed / total : 0.0;

    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: KidsColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: KidsColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              // Reward
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: KidsColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.star,
                      size: 16,
                      color: KidsColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+$reward',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: KidsColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress
          Row(
            children: [
              Expanded(
                child: ModernProgress(
                  value: progress,
                  height: 8,
                  color: KidsColors.primary,
                  animated: true,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$completed/$total',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: KidsColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Stat Card - Für Statistiken (v0-kids-ai-ui Design)
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
    this.iconColor,
  });

  final Widget icon;
  final String title;
  final String value;
  final String? subtitle;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              IconTheme(
                data: IconThemeData(
                  color: iconColor ?? KidsColors.textSecondary,
                  size: 20,
                ),
                child: icon,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: KidsColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Value
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          // Subtitle
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 14,
                color: KidsColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

