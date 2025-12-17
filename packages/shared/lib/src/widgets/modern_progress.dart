import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/spacing.dart';

/// Modern Progress Widget (v0-kids-ai-ui Design)
/// Animierter Progress Bar mit Farbvarianten
class ModernProgress extends StatefulWidget {
  const ModernProgress({
    super.key,
    required this.value,
    this.height = 8.0,
    this.color,
    this.backgroundColor,
    this.animated = true,
    this.borderRadius,
  });

  /// Progress value (0.0 - 1.0)
  final double value;

  /// Height of the progress bar
  final double height;

  /// Progress color (defaults to primary)
  final Color? color;

  /// Background color (defaults to primary/20)
  final Color? backgroundColor;

  /// Whether to animate the progress
  final bool animated;

  /// Border radius
  final BorderRadius? borderRadius;

  @override
  State<ModernProgress> createState() => _ModernProgressState();
}

class _ModernProgressState extends State<ModernProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    if (widget.animated) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ModernProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value && widget.animated) {
      _animation = Tween<double>(begin: oldWidget.value, end: widget.value)
          .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final progressValue = widget.animated ? _animation.value : widget.value;
    final progressColor = widget.color ?? KidsColors.primary;
    final bgColor = widget.backgroundColor ??
        KidsColors.primary.withValues(alpha: 0.2);
    final borderRadius = widget.borderRadius ??
        BorderRadius.circular(widget.height / 2);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: progressValue.clamp(0.0, 1.0),
          child: Container(
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: borderRadius,
            ),
          ),
        ),
      ),
    );
  }
}

