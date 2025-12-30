import 'package:flutter/material.dart';

/// Kids AI Farbpalette
/// Fröhliche, kindgerechte Farben für beide Apps (Alanko & Lianko)
class KidsColors {
  KidsColors._();

  // ============================================================
  // PRIMARY COLORS (OKLCH-basiert aus v0-kids-ai-ui)
  // ============================================================

  /// Hauptfarbe - OKLCH(0.58 0.2 260) - Violett/Blau
  static const Color primary = Color(0xFF7B68EE); // ~oklch(0.58 0.2 260)
  static const Color primaryLight = Color(0xFF9B8FF2);
  static const Color primaryDark = Color(0xFF5B4FC4);

  /// Sekundärfarbe - OKLCH(0.72 0.18 340) - Pink
  static const Color secondary = Color(0xFFFF6B9D); // ~oklch(0.72 0.18 340)
  static const Color secondaryLight = Color(0xFFFF8FB3);
  static const Color secondaryDark = Color(0xFFE84A7A);

  /// Akzentfarbe - OKLCH(0.65 0.22 200) - Cyan
  static const Color accent = Color(0xFF00D4AA); // ~oklch(0.65 0.22 200)
  static const Color accentLight = Color(0xFF55E6C1);
  static const Color accentDark = Color(0xFF00B894);

  // ============================================================
  // FEEDBACK COLORS
  // ============================================================

  /// Erfolg - Grün
  static const Color success = Color(0xFF00B894);
  static const Color successLight = Color(0xFF55D4B8);
  static const Color successBg = Color(0xFFE8F8F5);

  /// Fehler - Sanftes Rot (nicht aggressiv für Kinder)
  static const Color error = Color(0xFFFF6B6B);
  static const Color errorLight = Color(0xFFFF9999);
  static const Color errorBg = Color(0xFFFEECEC);

  /// Warnung - Gelb
  static const Color warning = Color(0xFFFFC312);
  static const Color warningLight = Color(0xFFFFD54F);
  static const Color warningBg = Color(0xFFFFF9E6);

  /// Info - Blau
  static const Color info = Color(0xFF74B9FF);
  static const Color infoLight = Color(0xFFA4CFFF);
  static const Color infoBg = Color(0xFFEBF5FF);

  // ============================================================
  // NEUTRAL COLORS
  // ============================================================

  /// Hintergrund - OKLCH(0.98 0.01 280) - Sehr helles Lila-Weiß
  static const Color background = Color(0xFFFAF9FC); // ~oklch(0.98 0.01 280)
  static const Color backgroundLight = Color(0xFFFAF9FC); // Alias für background
  static const Color backgroundAlt = Color(0xFFFFFFFF);
  
  /// Grau-Töne (für Kompatibilität)
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);

  /// Oberflächen - Weiß mit Transparenz für Backdrop Blur
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F4F8);
  static const Color surfaceTransparent = Color(0xF2FFFFFF); // 95% Opacity für backdrop blur

  /// Text
  static const Color textPrimary = Color(0xFF2D3436);
  static const Color textSecondary = Color(0xFF636E72);
  static const Color textMuted = Color(0xFFB2BEC3);
  static const Color textDisabled = Color(0xFFB2BEC3);
  static const Color textLight = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnSecondary = Color(0xFFFFFFFF);

  /// Borders & Dividers
  static const Color border = Color(0xFFE0E6ED);
  static const Color borderLight = Color(0xFFF0F2F8);
  static const Color divider = Color(0xFFEEF2F6);

  // ============================================================
  // SPECIAL COLORS (für Gamification)
  // ============================================================

  /// Sterne & Belohnungen
  static const Color star = Color(0xFFFFD700);
  static const Color starOutline = Color(0xFFDAA520);

  /// Level & Fortschritt
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color diamond = Color(0xFFB9F2FF);

  /// Avatar-Hintergründe
  static const List<Color> avatarColors = [
    Color(0xFF6C5CE7), // Violett
    Color(0xFF00CEC9), // Türkis
    Color(0xFFFDAA4C), // Orange
    Color(0xFFFF6B6B), // Koralle
    Color(0xFF74B9FF), // Hellblau
    Color(0xFF55E6C1), // Mint
    Color(0xFFFF85A2), // Rosa
    Color(0xFFA29BFE), // Lavendel
  ];

  // ============================================================
  // AGE GROUP COLORS
  // ============================================================

  /// Vorschule (3-5)
  static const Color preschool = Color(0xFFFF6B9D); // Pink
  /// Frühe Schulzeit (6-8)
  static const Color earlySchool = Color(0xFF7B68EE); // Violett
  /// Späte Schulzeit (9-12)
  static const Color lateSchool = Color(0xFF00D4AA); // Cyan

  /// Gibt Farbe basierend auf Alter zurück
  static Color getAgeColor(int age) {
    if (age <= 5) return preschool;
    if (age <= 8) return earlySchool;
    return lateSchool;
  }

  // ============================================================
  // DARK THEME COLORS (für Parent Dashboard)
  // ============================================================

  static const Color darkBackground = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF252542);
  static const Color darkSurfaceVariant = Color(0xFF2D2D4A);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0C0);
  static const Color darkTextMuted = Color(0xFF6E6E80);

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Gibt eine zufällige Avatar-Farbe zurück
  static Color randomAvatarColor() {
    return avatarColors[DateTime.now().millisecond % avatarColors.length];
  }

  /// Gibt Avatar-Farbe basierend auf Index zurück
  static Color avatarColorAt(int index) {
    return avatarColors[index % avatarColors.length];
  }

  /// Erzeugt MaterialColor aus einer Farbe
  static MaterialColor createMaterialColor(Color color) {
    final strengths = <double>[.05, .1, .2, .3, .4, .5, .6, .7, .8, .9];
    final swatch = <int, Color>{};
    final r = (color.r * 255).round();
    final g = (color.g * 255).round();
    final b = (color.b * 255).round();

    for (final strength in strengths) {
      final ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }
}
