import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Badge Variants
enum BadgeVariant {
  default_,
  secondary,
  destructive,
  outline,
  success,
}

/// Modern Badge Widget (v0-kids-ai-ui Design)
class ModernBadge extends StatelessWidget {
  const ModernBadge({
    super.key,
    required this.text,
    this.variant = BadgeVariant.default_,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  final String text;
  final BadgeVariant variant;
  final Color? backgroundColor;
  final Color? textColor;
  final Widget? icon;

  Color get _backgroundColor {
    if (backgroundColor != null) return backgroundColor!;

    switch (variant) {
      case BadgeVariant.default_:
        return KidsColors.primary;
      case BadgeVariant.secondary:
        return KidsColors.secondary;
      case BadgeVariant.destructive:
        return KidsColors.error;
      case BadgeVariant.outline:
        return Colors.transparent;
      case BadgeVariant.success:
        return KidsColors.success;
    }
  }

  Color get _textColor {
    if (textColor != null) return textColor!;

    switch (variant) {
      case BadgeVariant.default_:
      case BadgeVariant.secondary:
      case BadgeVariant.destructive:
      case BadgeVariant.success:
        return Colors.white;
      case BadgeVariant.outline:
        return KidsColors.textPrimary;
    }
  }

  Border? get _border {
    if (variant == BadgeVariant.outline) {
      return Border.all(color: KidsColors.border, width: 1);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: KidsSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        border: _border,
        borderRadius: BorderRadius.circular(KidsSpacing.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            icon!,
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _textColor,
            ),
          ),
        ],
      ),
    );
  }
}

