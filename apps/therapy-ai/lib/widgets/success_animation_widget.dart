import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/design_system.dart';

/// Success Animation Widget
/// Zeigt Konfetti und Erfolgs-Animationen
class SuccessAnimationWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final Duration duration;

  const SuccessAnimationWidget({
    super.key,
    this.onComplete,
    this.duration = TherapyDesignSystem.successAnimationDuration,
  });

  @override
  State<SuccessAnimationWidget> createState() => _SuccessAnimationWidgetState();
}

class _SuccessAnimationWidgetState extends State<SuccessAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late List<AnimationController> _confettiControllers;
  late List<Animation<double>> _confettiAnimations;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Konfetti-Animationen
    _confettiControllers = List.generate(
      20,
      (index) => AnimationController(
        duration: Duration(milliseconds: 1500 + (index * 50)),
        vsync: this,
      ),
    );

    _confettiAnimations = _confettiControllers.map((controller) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOut,
        ),
      );
    }).toList();

    _startAnimation();
  }

  void _startAnimation() async {
    // Haptic Feedback
    TherapyDesignSystem.hapticSuccess();

    // Scale Animation
    await _scaleController.forward();

    // Rotation Animation
    _rotationController.repeat();

    // Konfetti starten
    for (var controller in _confettiControllers) {
      controller.forward();
    }

    // Main Animation
    await _mainController.forward();

    if (widget.onComplete != null) {
      widget.onComplete!();
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    for (var controller in _confettiControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Konfetti
        ...List.generate(20, (index) {
          return AnimatedBuilder(
            animation: _confettiAnimations[index],
            builder: (context, child) {
              final angle = (index * 18.0) * math.pi / 180;
              final distance = 200.0 * _confettiAnimations[index].value;
              final x = math.cos(angle) * distance;
              final y = math.sin(angle) * distance;
              final opacity = 1.0 - _confettiAnimations[index].value;

              return Positioned(
                left: MediaQuery.of(context).size.width / 2 + x,
                top: MediaQuery.of(context).size.height / 2 + y,
                child: Opacity(
                  opacity: opacity,
                  child: Transform.rotate(
                    angle: _confettiAnimations[index].value * 2 * math.pi,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: [
                          TherapyDesignSystem.statusSuccess,
                          TherapyDesignSystem.statusActive,
                          TherapyDesignSystem.statusWarning,
                          Colors.purple,
                          Colors.pink,
                        ][index % 5],
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),

        // Haupt-Emoji/Icon
        AnimatedBuilder(
          animation: _scaleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleController.value * 0.5 + 0.5,
              child: AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * math.pi * 0.1,
                    child: Text(
                      '🎉',
                      style: TextStyle(
                        fontSize: 120 * _scaleController.value,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Simple Success Animation (leichte Version)
class SimpleSuccessAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback? onComplete;

  const SimpleSuccessAnimation({
    super.key,
    required this.child,
    this.onComplete,
  });

  @override
  State<SimpleSuccessAnimation> createState() => _SimpleSuccessAnimationState();
}

class _SimpleSuccessAnimationState extends State<SimpleSuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceOut,
      ),
    );

    TherapyDesignSystem.hapticSuccess();
    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _bounceAnimation.value,
            child: widget.child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

