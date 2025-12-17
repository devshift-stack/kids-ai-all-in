import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show Rect;
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;

/// Ergebnis der Hörgeräte-Erkennung
enum HearingAidResult {
  detected,       // Hörgeräte erkannt
  notDetected,    // Keine Hörgeräte erkannt
  noFaceFound,    // Kein Gesicht im Bild
  analyzing,      // Wird gerade analysiert
  error,          // Fehler bei der Erkennung
}

/// Detailliertes Ergebnis
class HearingAidDetectionResult {
  final HearingAidResult result;
  final double confidence;  // 0.0 - 1.0
  final String? message;
  final bool leftEarDetected;
  final bool rightEarDetected;

  const HearingAidDetectionResult({
    required this.result,
    this.confidence = 0.0,
    this.message,
    this.leftEarDetected = false,
    this.rightEarDetected = false,
  });

  bool get isDetected => result == HearingAidResult.detected;
  bool get bothEarsDetected => leftEarDetected && rightEarDetected;
}

/// Service zur Erkennung von Hörgeräten mittels Kamera
///
/// Verwendet Google ML Kit für Gesichtserkennung und
/// Custom Farb-/Form-Analyse für Hörgeräte-Erkennung
class HearingAidDetectionService {
  FaceDetector? _faceDetector;
  CameraController? _cameraController;
  bool _isProcessing = false;

  // Typische Hörgeräte-Farben (HSV Bereiche)
  // Beige/Hautfarben
  static const _skinToneHueMin = 0;
  static const _skinToneHueMax = 50;
  static const _skinToneSatMin = 20;
  static const _skinToneSatMax = 80;

  // Bunte Kinder-Hörgeräte (Rot, Blau, Pink, Grün)
  static const List<_ColorRange> _brightColors = [
    _ColorRange(hueMin: 0, hueMax: 20, name: 'Rot'),      // Rot
    _ColorRange(hueMin: 200, hueMax: 260, name: 'Blau'),  // Blau
    _ColorRange(hueMin: 280, hueMax: 340, name: 'Pink'),  // Pink/Lila
    _ColorRange(hueMin: 80, hueMax: 150, name: 'Grün'),   // Grün
  ];

  /// Initialisiert den Service
  Future<void> initialize() async {
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: false,
        enableTracking: false,
        performanceMode: FaceDetectorMode.accurate,
      ),
    );
  }

  /// Initialisiert die Kamera
  Future<CameraController?> initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return null;

      // Frontkamera bevorzugen
      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();
      return _cameraController;
    } catch (e) {
      if (kDebugMode) {
        print('Kamera-Initialisierung fehlgeschlagen: $e');
      }
      return null;
    }
  }

  /// Analysiert ein Bild auf Hörgeräte
  Future<HearingAidDetectionResult> analyzeImage(XFile imageFile) async {
    if (_isProcessing) {
      return const HearingAidDetectionResult(
        result: HearingAidResult.analyzing,
        message: 'Analyse läuft bereits...',
      );
    }

    _isProcessing = true;

    try {
      // 1. Bild für ML Kit vorbereiten
      final inputImage = InputImage.fromFilePath(imageFile.path);

      // 2. Gesichtserkennung durchführen
      final faces = await _faceDetector?.processImage(inputImage);

      if (faces == null || faces.isEmpty) {
        return const HearingAidDetectionResult(
          result: HearingAidResult.noFaceFound,
          message: 'Kein Gesicht erkannt. Bitte schau in die Kamera!',
        );
      }

      // 3. Erstes Gesicht analysieren
      final face = faces.first;

      // 4. Ohr-Regionen extrahieren
      final leftEarContour = face.contours[FaceContourType.leftEye];
      final rightEarContour = face.contours[FaceContourType.rightEye];

      // 5. Bild laden für Pixel-Analyse
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        return const HearingAidDetectionResult(
          result: HearingAidResult.error,
          message: 'Bild konnte nicht geladen werden',
        );
      }

      // 6. Ohr-Bereiche analysieren (links und rechts vom Gesicht)
      final boundingBox = face.boundingBox;

      // Bereich links vom Gesicht (linkes Ohr)
      final leftEarRegion = _getEarRegion(image, boundingBox, isLeft: true);
      final leftResult = _analyzeEarRegion(leftEarRegion);

      // Bereich rechts vom Gesicht (rechtes Ohr)
      final rightEarRegion = _getEarRegion(image, boundingBox, isLeft: false);
      final rightResult = _analyzeEarRegion(rightEarRegion);

      // 7. Ergebnis berechnen
      final leftDetected = leftResult > 0.4;
      final rightDetected = rightResult > 0.4;
      final avgConfidence = (leftResult + rightResult) / 2;

      if (leftDetected || rightDetected) {
        return HearingAidDetectionResult(
          result: HearingAidResult.detected,
          confidence: avgConfidence,
          message: 'Super! Hörgeräte erkannt!',
          leftEarDetected: leftDetected,
          rightEarDetected: rightDetected,
        );
      } else {
        return HearingAidDetectionResult(
          result: HearingAidResult.notDetected,
          confidence: 1 - avgConfidence,
          message: 'Bitte setze deine Hörgeräte auf!',
          leftEarDetected: false,
          rightEarDetected: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Hörgeräte-Erkennung Fehler: $e');
      }
      return HearingAidDetectionResult(
        result: HearingAidResult.error,
        message: 'Fehler bei der Erkennung: $e',
      );
    } finally {
      _isProcessing = false;
    }
  }

  /// Extrahiert den Ohr-Bereich aus dem Bild
  img.Image? _getEarRegion(img.Image image, Rect boundingBox, {required bool isLeft}) {
    try {
      // Ohr-Bereich ist seitlich vom Gesicht
      final earWidth = (boundingBox.width * 0.3).toInt();
      final earHeight = (boundingBox.height * 0.4).toInt();

      int x;
      if (isLeft) {
        // Linkes Ohr: links vom Gesicht
        x = (boundingBox.left - earWidth).toInt().clamp(0, image.width - earWidth);
      } else {
        // Rechtes Ohr: rechts vom Gesicht
        x = boundingBox.right.toInt().clamp(0, image.width - earWidth);
      }

      // Ohr ist etwa auf Augenhöhe
      final y = (boundingBox.top + boundingBox.height * 0.2).toInt().clamp(0, image.height - earHeight);

      return img.copyCrop(
        image,
        x: x,
        y: y,
        width: earWidth.clamp(1, image.width - x),
        height: earHeight.clamp(1, image.height - y),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Ohr-Region konnte nicht extrahiert werden: $e');
      }
      return null;
    }
  }

  /// Analysiert einen Ohr-Bereich auf Hörgeräte
  /// Gibt Confidence 0.0 - 1.0 zurück
  double _analyzeEarRegion(img.Image? region) {
    if (region == null) return 0.0;

    int hearingAidPixels = 0;
    int totalPixels = 0;

    // Pixel durchgehen
    for (int y = 0; y < region.height; y++) {
      for (int x = 0; x < region.width; x++) {
        final pixel = region.getPixel(x, y);

        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        // In HSV umwandeln
        final hsv = _rgbToHsv(r, g, b);
        final hue = hsv[0];
        final saturation = hsv[1];
        final value = hsv[2];

        totalPixels++;

        // Prüfen ob Pixel zu Hörgeräte-Farbe passt
        if (_isHearingAidColor(hue, saturation, value)) {
          hearingAidPixels++;
        }
      }
    }

    if (totalPixels == 0) return 0.0;

    // Anteil der Hörgeräte-Pixel
    final ratio = hearingAidPixels / totalPixels;

    // Wenn mehr als 10% der Pixel "Hörgeräte-Farben" haben
    // ist die Wahrscheinlichkeit hoch
    if (ratio > 0.15) return 0.9;
    if (ratio > 0.10) return 0.7;
    if (ratio > 0.05) return 0.5;
    return ratio * 3; // Linear für niedrige Werte
  }

  /// Prüft ob eine Farbe zu typischen Hörgeräte-Farben passt
  bool _isHearingAidColor(double hue, double saturation, double value) {
    // Zu dunkel oder zu hell = wahrscheinlich kein Hörgerät
    if (value < 20 || value > 95) return false;

    // 1. Beige/Hautfarbene Hörgeräte
    if (hue >= _skinToneHueMin && hue <= _skinToneHueMax) {
      if (saturation >= _skinToneSatMin && saturation <= _skinToneSatMax) {
        // Etwas mehr Sättigung als normale Haut = Hörgerät
        if (saturation > 35) return true;
      }
    }

    // 2. Bunte Kinder-Hörgeräte
    for (final colorRange in _brightColors) {
      if (hue >= colorRange.hueMin && hue <= colorRange.hueMax) {
        // Bunte Farben haben hohe Sättigung
        if (saturation > 50) return true;
      }
    }

    return false;
  }

  /// Konvertiert RGB zu HSV
  List<double> _rgbToHsv(int r, int g, int b) {
    final rf = r / 255.0;
    final gf = g / 255.0;
    final bf = b / 255.0;

    final maxVal = math.max(rf, math.max(gf, bf));
    final minVal = math.min(rf, math.min(gf, bf));
    final delta = maxVal - minVal;

    // Hue berechnen
    double hue = 0;
    if (delta != 0) {
      if (maxVal == rf) {
        hue = 60 * (((gf - bf) / delta) % 6);
      } else if (maxVal == gf) {
        hue = 60 * (((bf - rf) / delta) + 2);
      } else {
        hue = 60 * (((rf - gf) / delta) + 4);
      }
    }
    if (hue < 0) hue += 360;

    // Saturation berechnen
    final saturation = maxVal == 0 ? 0.0 : (delta / maxVal) * 100;

    // Value berechnen
    final value = maxVal * 100;

    return [hue, saturation, value];
  }

  /// Macht ein Foto und analysiert es
  Future<HearingAidDetectionResult> captureAndAnalyze() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return const HearingAidDetectionResult(
        result: HearingAidResult.error,
        message: 'Kamera nicht initialisiert',
      );
    }

    try {
      final image = await _cameraController!.takePicture();
      return analyzeImage(image);
    } catch (e) {
      return HearingAidDetectionResult(
        result: HearingAidResult.error,
        message: 'Foto konnte nicht gemacht werden: $e',
      );
    }
  }

  /// Gibt Kamera-Controller zurück
  CameraController? get cameraController => _cameraController;

  /// Räumt Ressourcen auf
  Future<void> dispose() async {
    await _faceDetector?.close();
    await _cameraController?.dispose();
    _faceDetector = null;
    _cameraController = null;
  }
}

/// Hilfsklasse für Farbbereiche
class _ColorRange {
  final double hueMin;
  final double hueMax;
  final String name;

  const _ColorRange({
    required this.hueMin,
    required this.hueMax,
    required this.name,
  });
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// Service Provider
final hearingAidDetectionServiceProvider = Provider<HearingAidDetectionService>((ref) {
  final service = HearingAidDetectionService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Aktuelles Erkennungsergebnis
final hearingAidResultProvider = StateProvider<HearingAidDetectionResult?>((ref) => null);

/// Ob Hörgeräte-Check aktiviert ist (Eltern-Einstellung)
final hearingAidCheckEnabledProvider = StateProvider<bool>((ref) => true);
