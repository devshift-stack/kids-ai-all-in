import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/design_system.dart';

/// Waveform Widget
/// Zeigt eine animierte Wellenform während der Audio-Aufnahme
class WaveformWidget extends StatefulWidget {
  final bool isActive;
  final double volumeLevel; // 0.0 - 1.0
  final Color? color;
  final int barCount;
  final double barWidth;
  final double maxBarHeight;

  const WaveformWidget({
    super.key,
    required this.isActive,
    this.volumeLevel = 0.5,
    this.color,
    this.barCount = 20,
    this.barWidth = 4.0,
    this.maxBarHeight = 100.0,
  });

  @override
  State<WaveformWidget> createState() => _WaveformWidgetState();
}

class _WaveformWidgetState extends State<WaveformWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<double> _barHeights;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Initialisiere Bar-Höhen mit zufälligen Werten
    _barHeights = List.generate(
      widget.barCount,
      (index) => math.Random().nextDouble() * 0.3,
    );

    if (widget.isActive) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(WaveformWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getBarHeight(int index) {
    if (!widget.isActive) return 0.0;

    // Sinus-Welle für natürliche Wellenform
    final baseHeight = (math.sin(
          (index / widget.barCount * 2 * math.pi) +
              (_controller.value * 2 * math.pi),
        ) +
        1) /
        2;

    // Kombiniere mit Volume-Level
    final height = baseHeight * widget.volumeLevel;

    // Zufällige Variation für natürlicheren Look
    final variation = math.Random(index).nextDouble() * 0.2;

    return (height + variation).clamp(0.1, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? TherapyDesignSystem.statusActive;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            final height = _getBarHeight(index) * widget.maxBarHeight;
            final opacity = widget.isActive ? 1.0 : 0.3;

            return Container(
              margin: EdgeInsets.symmetric(
                horizontal: widget.barWidth / 2,
              ),
              width: widget.barWidth,
              height: height,
              decoration: BoxDecoration(
                color: color.withOpacity(opacity),
                borderRadius: BorderRadius.circular(widget.barWidth / 2),
              ),
            );
          }),
        );
      },
    );
  }
}

/// Simple Waveform (vereinfachte Version)
class SimpleWaveform extends StatelessWidget {
  final bool isActive;
  final double volumeLevel;
  final Color? color;

  const SimpleWaveform({
    super.key,
    required this.isActive,
    this.volumeLevel = 0.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? TherapyDesignSystem.statusActive;
    final barCount = 10;
    final barWidth = 6.0;
    final maxHeight = 60.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: List.generate(barCount, (index) {
        // Sinus-basierte Höhe
        final baseHeight = (math.sin(index / barCount * math.pi) + 1) / 2;
        final height = baseHeight * volumeLevel * maxHeight;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: barWidth,
          height: height.clamp(8.0, maxHeight),
          decoration: BoxDecoration(
            color: color.withOpacity(isActive ? 1.0 : 0.3),
            borderRadius: BorderRadius.circular(barWidth / 2),
          ),
        );
      }),
    );
  }
}

