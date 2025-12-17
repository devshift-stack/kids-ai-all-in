import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/hearing_aid_detection_service.dart';
import '../../services/parent_notification_service.dart';
import '../../core/theme/app_theme.dart';

/// Screen zur Hörgeräte-Überprüfung
///
/// Wird angezeigt bevor YouTube/Videos gestartet werden.
/// Kind muss Hörgeräte tragen um fortzufahren.
class HearingAidCheckScreen extends ConsumerStatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback? onCancel;

  const HearingAidCheckScreen({
    super.key,
    required this.onSuccess,
    this.onCancel,
  });

  @override
  ConsumerState<HearingAidCheckScreen> createState() => _HearingAidCheckScreenState();
}

class _HearingAidCheckScreenState extends ConsumerState<HearingAidCheckScreen> {
  CameraController? _cameraController;
  bool _isInitializing = true;
  bool _isAnalyzing = false;
  HearingAidDetectionResult? _result;
  String _statusMessage = 'Kamera wird gestartet...';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final service = ref.read(hearingAidDetectionServiceProvider);
    await service.initialize();
    _cameraController = await service.initializeCamera();

    if (mounted) {
      setState(() {
        _isInitializing = false;
        _statusMessage = 'Schau in die Kamera!';
      });
    }
  }

  Future<void> _checkHearingAids() async {
    if (_isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _statusMessage = 'Prüfe Hörgeräte...';
    });

    final service = ref.read(hearingAidDetectionServiceProvider);
    final notificationService = ref.read(parentNotificationServiceProvider);
    final result = await service.captureAndAnalyze();

    if (mounted) {
      setState(() {
        _result = result;
        _isAnalyzing = false;
      });

      // Log result for parent tracking
      await notificationService.logHearingAidCheck(
        wasWearing: result.isDetected,
        context: 'Video/YouTube Zugriff',
      );

      if (result.isDetected) {
        // Erfolg! Kurz warten und dann weiter
        setState(() => _statusMessage = 'Super! Hörgeräte erkannt! 🎉');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          widget.onSuccess();
        }
      } else {
        setState(() {
          _statusMessage = result.message ?? 'Bitte setze deine Hörgeräte auf!';
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),

            // Kamera-Bereich
            Expanded(
              child: _buildCameraSection(),
            ),

            // Buttons
            _buildButtons(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Hörgeräte-Symbol
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _result?.isDetected == true
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '🦻',
                style: const TextStyle(fontSize: 40),
              ).animate(
                onPlay: (controller) => controller.repeat(),
              ).shimmer(
                duration: const Duration(seconds: 2),
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Titel
          Text(
            'Hörgeräte-Check',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
          ),
          const SizedBox(height: 8),

          // Status-Nachricht
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              _statusMessage,
              key: ValueKey(_statusMessage),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[700],
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraSection() {
    if (_isInitializing) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Kamera wird gestartet...',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Kamera nicht verfügbar',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            // Fallback: Manuelle Bestätigung
            _buildManualConfirmButton(),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Kamera-Preview
            AspectRatio(
              aspectRatio: 3 / 4,
              child: CameraPreview(_cameraController!),
            ),

            // Overlay mit Ohr-Markierungen
            Positioned.fill(
              child: CustomPaint(
                painter: _EarOverlayPainter(),
              ),
            ),

            // Ergebnis-Overlay
            if (_result != null)
              Positioned.fill(
                child: _buildResultOverlay(),
              ),

            // Analyzing Overlay
            if (_isAnalyzing)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        const Text(
                          'Analysiere...',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultOverlay() {
    final isDetected = _result?.isDetected == true;

    if (isDetected) {
      // Erfolg: Grünes Overlay mit Checkmark
      return Container(
        color: Colors.green.withValues(alpha: 0.4),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                size: 100,
                color: Colors.white,
              ).animate().scale(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 20),
              const Text(
                'Super! 🎉',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hörgeräte erkannt!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Nicht erkannt: Großes Hörgeräte-Symbol anzeigen
    return Container(
      color: Colors.orange.withValues(alpha: 0.9),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Großes Hörgeräte-Symbol
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🦻',
                  style: TextStyle(fontSize: 80),
                ),
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .scale(
                  begin: const Offset(1.0, 1.0),
                  end: const Offset(1.1, 1.1),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 30),

            // Text
            const Text(
              'Bitte Hörgeräte\naufsetzen!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Pfeil nach oben zu den Ohren
            const Icon(
              Icons.arrow_upward,
              size: 40,
              color: Colors.white,
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .moveY(
                  begin: 0,
                  end: -10,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                )
                .then()
                .moveY(
                  begin: -10,
                  end: 0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                ),
            const SizedBox(height: 20),

            // Nochmal prüfen Button
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _result = null;
                });
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Nochmal prüfen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Prüfen-Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: _isAnalyzing ? null : _checkHearingAids,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    _isAnalyzing ? 'Prüfe...' : 'Hörgeräte prüfen',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Abbrechen-Button
          if (widget.onCancel != null)
            TextButton(
              onPressed: widget.onCancel,
              child: Text(
                'Abbrechen',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildManualConfirmButton() {
    return ElevatedButton.icon(
      onPressed: () {
        // Bei Kamera-Fehler: Manuelle Bestätigung erlauben
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Trägst du deine Hörgeräte?'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('🦻', style: TextStyle(fontSize: 60)),
                SizedBox(height: 16),
                Text('Bitte bestätige, dass du deine Hörgeräte aufgesetzt hast.'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Nein'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onSuccess();
                },
                child: const Text('Ja, ich trage sie!'),
              ),
            ],
          ),
        );
      },
      icon: const Icon(Icons.check),
      label: const Text('Manuell bestätigen'),
    );
  }
}

/// Overlay-Painter für Ohr-Markierungen
class _EarOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Linkes Ohr-Bereich
    final leftEarRect = Rect.fromLTWH(
      size.width * 0.05,
      size.height * 0.25,
      size.width * 0.2,
      size.height * 0.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(leftEarRect, const Radius.circular(10)),
      paint,
    );

    // Rechtes Ohr-Bereich
    final rightEarRect = Rect.fromLTWH(
      size.width * 0.75,
      size.height * 0.25,
      size.width * 0.2,
      size.height * 0.3,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(rightEarRect, const Radius.circular(10)),
      paint,
    );

    // Text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Ohren hier',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Links
    textPainter.paint(
      canvas,
      Offset(leftEarRect.center.dx - textPainter.width / 2, leftEarRect.bottom + 5),
    );

    // Rechts
    textPainter.paint(
      canvas,
      Offset(rightEarRect.center.dx - textPainter.width / 2, rightEarRect.bottom + 5),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
