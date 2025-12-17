import 'package:flutter/material.dart';
import '../core/design_system.dart';

/// Speech Recording Widget für Kinder
/// Große, visuelle Aufnahme-Komponente mit Wellenform
class SpeechRecordingWidget extends StatefulWidget {
  const SpeechRecordingWidget({
    super.key,
    required this.isRecording,
    required this.volumeLevel, // 0.0 - 1.0
    this.onStartRecording,
    this.onStopRecording,
    this.duration,
  });

  final bool isRecording;
  final double volumeLevel; // 0.0 - 1.0
  final VoidCallback? onStartRecording;
  final VoidCallback? onStopRecording;
  final Duration? duration;

  @override
  State<SpeechRecordingWidget> createState() => _SpeechRecordingWidgetState();
}

class _SpeechRecordingWidgetState extends State<SpeechRecordingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse Animation für Aufnahme-Button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Wave Animation für Wellenform
    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(SpeechRecordingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !oldWidget.isRecording) {
      _pulseController.repeat(reverse: true);
      _waveController.repeat();
    } else if (!widget.isRecording && oldWidget.isRecording) {
      _pulseController.stop();
      _waveController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Große Mikrofon-Animation
        GestureDetector(
          onTap: widget.isRecording
              ? widget.onStopRecording
              : widget.onStartRecording,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isRecording ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: TherapyDesignSystem.extraLargeTouchTarget,
                  height: TherapyDesignSystem.extraLargeTouchTarget,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.isRecording
                        ? TherapyDesignSystem.errorRed
                        : TherapyDesignSystem.primaryBlue,
                    boxShadow: [
                      BoxShadow(
                        color: (widget.isRecording
                                ? TherapyDesignSystem.errorRed
                                : TherapyDesignSystem.primaryBlue)
                            .withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.isRecording ? Icons.stop : Icons.mic,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: TherapyDesignSystem.spacingXL),

        // Wellenform-Visualisierung
        if (widget.isRecording) ...[
          _buildWaveform(),
          const SizedBox(height: TherapyDesignSystem.spacingLG),
          // Dauer-Anzeige
          if (widget.duration != null)
            Text(
              _formatDuration(widget.duration!),
              style: TherapyDesignSystem.headingMedium.copyWith(
                color: TherapyDesignSystem.textDark,
              ),
            ),
        ] else ...[
          // Anweisung
          Text(
            'Drücke den Button zum Sprechen',
            style: TherapyDesignSystem.instruction.copyWith(
              color: TherapyDesignSystem.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildWaveform() {
    return Container(
      height: 100,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: AnimatedBuilder(
        animation: _waveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: WaveformPainter(
              volumeLevel: widget.volumeLevel,
              animationValue: _waveController.value,
            ),
            child: Container(),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Custom Painter für Wellenform
class WaveformPainter extends CustomPainter {
  final double volumeLevel;
  final double animationValue;

  WaveformPainter({
    required this.volumeLevel,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = TherapyDesignSystem.primaryBlue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final centerY = size.height / 2;
    final barCount = 20;
    final barWidth = size.width / barCount;
    final maxHeight = size.height * 0.8;

    for (int i = 0; i < barCount; i++) {
      final x = i * barWidth + barWidth / 2;
      final phase = (i / barCount + animationValue) * 2 * 3.14159;
      final amplitude = (0.3 + volumeLevel * 0.7) * (0.5 + 0.5 * (1 + (phase.sin)) / 2);
      final barHeight = maxHeight * amplitude;

      canvas.drawLine(
        Offset(x, centerY - barHeight / 2),
        Offset(x, centerY + barHeight / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(WaveformPainter oldDelegate) {
    return oldDelegate.volumeLevel != volumeLevel ||
        oldDelegate.animationValue != animationValue;
  }
}

extension on double {
  double sin() => (this * 3.14159 * 2).sin();
}

