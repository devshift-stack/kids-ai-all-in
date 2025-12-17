import 'package:flutter/material.dart';
import '../core/design_system.dart';

/// Verbesserte Loading Animation
/// Zeigt eine kinderfreundliche Lade-Animation
class LoadingAnimationWidget extends StatefulWidget {
  final String? message;
  final Color? color;

  const LoadingAnimationWidget({
    super.key,
    this.message,
    this.color,
  });

  @override
  State<LoadingAnimationWidget> createState() => _LoadingAnimationWidgetState();
}

class _LoadingAnimationWidgetState extends State<LoadingAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ),
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? TherapyDesignSystem.statusActive;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotationAnimation.value * 2 * 3.14159,
                child: Container(
                  width: TherapyDesignSystem.touchTargetPrimary,
                  height: TherapyDesignSystem.touchTargetPrimary,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        color,
                        color.withOpacity(0.3),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.mic,
                      size: TherapyDesignSystem.touchTargetIcon,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        if (widget.message != null) ...[
          SizedBox(height: TherapyDesignSystem.spacingXL),
          Text(
            widget.message!,
            style: TherapyDesignSystem.bodyLargeStyle.copyWith(
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}

/// Simple Loading Spinner
class SimpleLoadingSpinner extends StatelessWidget {
  final Color? color;
  final double size;

  const SimpleLoadingSpinner({
    super.key,
    this.color,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? TherapyDesignSystem.statusActive;

    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 4,
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
    );
  }
}

