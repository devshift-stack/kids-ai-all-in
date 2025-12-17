import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/hearing_aid/hearing_aid_check_screen.dart';
import 'hearing_aid_detection_service.dart';

/// Service zur Verwaltung des Medien-Zugriffs
///
/// Integriert Hörgeräte-Check vor YouTube/Video-Zugriff
class MediaAccessService {
  final Ref _ref;

  MediaAccessService(this._ref);

  /// Öffnet YouTube mit Hörgeräte-Check
  ///
  /// [context] - BuildContext für Navigation
  /// [videoUrl] - Optional: Direkter Video-Link
  /// [onAccessGranted] - Callback wenn Zugriff gewährt
  Future<void> openYouTube(
    BuildContext context, {
    String? videoUrl,
    VoidCallback? onAccessGranted,
  }) async {
    final checkEnabled = _ref.read(hearingAidCheckEnabledProvider);

    if (!checkEnabled) {
      // Check deaktiviert → direkt öffnen
      await _launchYouTube(videoUrl);
      onAccessGranted?.call();
      return;
    }

    // Hörgeräte-Check anzeigen
    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HearingAidCheckScreen(
            onSuccess: () async {
              Navigator.pop(context);
              await _launchYouTube(videoUrl);
              onAccessGranted?.call();
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      );
    }
  }

  /// Öffnet ein Video mit Hörgeräte-Check
  Future<void> openVideo(
    BuildContext context, {
    required String videoUrl,
    VoidCallback? onAccessGranted,
  }) async {
    await openYouTube(context, videoUrl: videoUrl, onAccessGranted: onAccessGranted);
  }

  /// Prüft ob Medien-Zugriff erlaubt ist (für internes Video)
  ///
  /// Gibt true zurück wenn:
  /// - Hörgeräte-Check deaktiviert ist, ODER
  /// - Hörgeräte erkannt wurden
  Future<bool> checkMediaAccess(BuildContext context) async {
    final checkEnabled = _ref.read(hearingAidCheckEnabledProvider);

    if (!checkEnabled) return true;

    bool accessGranted = false;

    if (context.mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HearingAidCheckScreen(
            onSuccess: () {
              accessGranted = true;
              Navigator.pop(context);
            },
            onCancel: () => Navigator.pop(context),
          ),
        ),
      );
    }

    return accessGranted;
  }

  /// Öffnet YouTube App oder Website
  Future<void> _launchYouTube(String? videoUrl) async {
    final url = videoUrl ?? 'https://www.youtube.com/kids';

    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('YouTube konnte nicht geöffnet werden: $e');
    }
  }
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// Media Access Service Provider
final mediaAccessServiceProvider = Provider<MediaAccessService>((ref) {
  return MediaAccessService(ref);
});

/// Ob YouTube-Zugriff gerade erlaubt ist
final youtubeAccessGrantedProvider = StateProvider<bool>((ref) => false);
