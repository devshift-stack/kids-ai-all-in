import 'package:flutter/material.dart';
import 'colors.dart';

/// Kids AI Gradienten und Schatten
/// Für lebendige, spielerische Oberflächen
class KidsGradients {
  KidsGradients._();

  // ============================================================
  // PRIMARY GRADIENTS
  // ============================================================

  /// Haupt-Gradient (Violett)
  static const LinearGradient primary = LinearGradient(
    colors: [KidsColors.primary, KidsColors.primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sekundär-Gradient (Türkis)
  static const LinearGradient secondary = LinearGradient(
    colors: [KidsColors.secondary, KidsColors.secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Akzent-Gradient (Orange)
  static const LinearGradient accent = LinearGradient(
    colors: [KidsColors.accent, KidsColors.accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Character-Gradient (für Alanko/Lianko)
  static const LinearGradient character = LinearGradient(
    colors: [KidsColors.primary, KidsColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================
  // SPECIAL GRADIENTS
  // ============================================================

  /// Erfolgs-Gradient
  static const LinearGradient success = LinearGradient(
    colors: [KidsColors.success, Color(0xFF55E6C1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sonnenuntergang (warm)
  static const LinearGradient sunset = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFDAA4C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Ozean (kühl)
  static const LinearGradient ocean = LinearGradient(
    colors: [Color(0xFF6C5CE7), Color(0xFF00CEC9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Regenbogen (fröhlich)
  static const LinearGradient rainbow = LinearGradient(
    colors: [
      Color(0xFFFF6B6B),
      Color(0xFFFDAA4C),
      Color(0xFFFFC312),
      Color(0xFF00B894),
      Color(0xFF00CEC9),
      Color(0xFF6C5CE7),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gold (für Belohnungen)
  static const LinearGradient gold = LinearGradient(
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================================
  // BACKGROUND GRADIENTS (v0-kids-ai-ui Design)
  // ============================================================

  /// Haupt-Hintergrund-Gradient (from-primary via-accent to-secondary)
  /// Entspricht dem v0-kids-ai-ui Design
  static const LinearGradient mainBackground = LinearGradient(
    colors: [
      Color(0xFF7B68EE), // primary
      Color(0xFF00D4AA), // accent
      Color(0xFFFF6B9D), // secondary
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Hintergrund-Gradient (subtil)
  static const LinearGradient background = LinearGradient(
    colors: [Color(0xFFFAF9FC), Color(0xFFF5F4F8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Header-Gradient
  static const LinearGradient header = LinearGradient(
    colors: [KidsColors.primary, KidsColors.primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark Header (Parent Dashboard)
  static const LinearGradient darkHeader = LinearGradient(
    colors: [KidsColors.darkBackground, KidsColors.darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================================
  // RADIAL GRADIENTS
  // ============================================================

  /// Spotlight-Effekt
  static RadialGradient spotlight(Color color) {
    return RadialGradient(
      colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0)],
      radius: 0.8,
    );
  }

  /// Glow-Effekt
  static RadialGradient glow(Color color) {
    return RadialGradient(
      colors: [color, color.withValues(alpha: 0)],
      stops: const [0.0, 1.0],
      radius: 0.5,
    );
  }
}
