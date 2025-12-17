import 'package:flutter/material.dart';
import '../core/design_system.dart';

/// Pulse Animation Widget
/// Erstellt eine pulsierende Animation für aktive Elemente
class AnimatedPulseWidget extends StatefulWidget {
  final Widget child;
  final Color? pulseColor;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool isActive;

  const AnimatedPulseWidget({
    super.key,
    required this.child,
    this.pulseColor,
    this.duration = TherapyDesignSystem.pulseDuration,
    this.minScale = 1.0,
    this.maxScale = 1.2,
    this.isActive = true,
  });

  @override
  State<AnimatedPulseWidget> createState() => _AnimatedPulseWidgetState();
}

class _AnimatedPulseWidgetState extends State<AnimatedPulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isActive) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(AnimatedPulseWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isActive) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

/// Pulse Ring Widget
/// Erstellt einen pulsierenden Ring um ein Element
class AnimatedPulseRing extends StatefulWidget {
  final Widget child;
  final Color ringColor;
  final double ringWidth;
  final Duration duration;
  final bool isActive;

  const AnimatedPulseRing({
    super.key,
    required this.child,
    this.ringColor = TherapyDesignSystem.statusActive,
    this.ringWidth = 4.0,
    this.duration = TherapyDesignSystem.pulseDuration,
    this.isActive = true,
  });

  @override
  State<AnimatedPulseRing> createState() => _AnimatedPulseRingState();
}

class _AnimatedPulseRingState extends State<AnimatedPulseRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _opacityAnimation = Tween<double>(
      begin: 0.8,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(AnimatedPulseRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.isActive)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                width: TherapyDesignSystem.touchTargetPrimary * _scaleAnimation.value, // 100px * scale
                height: TherapyDesignSystem.touchTargetPrimary * _scaleAnimation.value, // 100px * scale
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.ringColor.withOpacity(_opacityAnimation.value),
                    width: widget.ringWidth,
                  ),
                ),
              );
            },
          ),
        widget.child,
      ],
    );
  }
}

