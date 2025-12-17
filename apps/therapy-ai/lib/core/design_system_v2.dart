import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Modern Design System v2 - Basierend auf v0.app Design
/// Optimiert für 4-jährige Kinder mit Hörverlust
class TherapyDesignSystemV2 {
  TherapyDesignSystemV2._();

  // ============================================================
  // MODERNE FARBPALETTE (v0.app inspiriert)
  // ============================================================

  /// Primärfarbe - Sanftes, vertrauenswürdiges Blau
  static const Color primaryBlue = Color(0xFF5B8DEF);
  static const Color primaryBlueLight = Color(0xFF7BA3F5);
  static const Color primaryBlueDark = Color(0xFF4A7CE8);

  /// Sekundärfarbe - Warmes, motivierendes Orange
  static const Color secondaryOrange = Color(0xFFFF7B47);
  static const Color secondaryOrangeLight = Color(0xFFFF9A6B);
  static const Color secondaryOrangeDark = Color(0xFFE85A2A);

  /// Erfolg - Positives Grün
  static const Color successGreen = Color(0xFF4ADE80);
  static const Color successGreenLight = Color(0xFF6EE7A3);
  static const Color successGreenDark = Color(0xFF22C55E);

  /// Warnung - Aufmerksamkeit
  static const Color warningYellow = Color(0xFFFBBF24);
  static const Color warningYellowLight = Color(0xFFFCD34D);
  static const Color warningYellowDark = Color(0xFFF59E0B);

  /// Fehler - Vorsichtig verwenden
  static const Color errorRed = Color(0xFFEF4444);
  static const Color errorRedLight = Color(0xFFF87171);
  static const Color errorRedDark = Color(0xFFDC2626);

  /// Hintergrund - Weich und beruhigend
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color backgroundGray = Color(0xFFF1F5F9);

  /// Text - Hoher Kontrast
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textTertiary = Color(0xFF94A3B8);
  static const Color textInverse = Color(0xFFFFFFFF);

  /// Surface - Karten und Container
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFF8FAFC);
  static const Color surfaceBlue = Color(0xFFEFF6FF);

  // ============================================================
  // GRADIENTE (Modern & Friendly)
  // ============================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlue, primaryBlueLight],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [successGreen, successGreenLight],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundLight, backgroundWhite],
  );

  // ============================================================
  // TYPOGRAPHY (Groß & Lesbar)
  // ============================================================

  /// Display Large - Für große Titel
  static const TextStyle displayLarge = TextStyle(
    fontSize: 56.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -1.0,
    color: textPrimary,
  );

  /// Display Medium
  static const TextStyle displayMedium = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: -0.5,
    color: textPrimary,
  );

  /// Heading Large - Hauptüberschriften
  static const TextStyle headingLarge = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    height: 1.3,
    letterSpacing: -0.5,
    color: textPrimary,
  );

  /// Heading Medium
  static const TextStyle headingMedium = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: textPrimary,
  );

  /// Heading Small
  static const TextStyle headingSmall = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  /// Target Word Style - Sehr groß für Übungen
  static const TextStyle targetWord = TextStyle(
    fontSize: 72.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: 4.0,
    color: primaryBlue,
  );

  /// Instruction Style - Anweisungen
  static const TextStyle instruction = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  /// Body Large
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.normal,
    height: 1.6,
    color: textPrimary,
  );

  /// Body Medium
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textPrimary,
  );

  /// Body Small
  static const TextStyle bodySmall = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: textSecondary,
  );

  /// Button Text
  static const TextStyle buttonText = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: textInverse,
    letterSpacing: 0.5,
  );

  // ============================================================
  // SPACING SYSTEM
  // ============================================================

  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  static const double spacingXXXL = 64.0;

  // ============================================================
  // BORDER RADIUS (Modern & Rounded)
  // ============================================================

  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusRound = 999.0;

  // ============================================================
  // TOUCH TARGETS (WCAG AAA)
  // ============================================================

  static const double touchTargetSmall = 48.0;
  static const double touchTargetMedium = 64.0;
  static const double touchTargetLarge = 80.0;
  static const double touchTargetXLarge = 100.0;

  // ============================================================
  // SHADOWS (Modern Depth)
  // ============================================================

  static List<BoxShadow> get shadowSmall => [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  static List<BoxShadow> get shadowMedium => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  static List<BoxShadow> get shadowLarge => [
        BoxShadow(
          color: Colors.black.withOpacity(0.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];

  static List<BoxShadow> get shadowXLarge => [
        BoxShadow(
          color: Colors.black.withOpacity(0.16),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];

  // ============================================================
  // BUTTON STYLES
  // ============================================================

  /// Primary Button - Groß & Prominent
  static ButtonStyle get primaryButtonLarge => ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: textInverse,
        minimumSize: const Size(touchTargetLarge, touchTargetLarge),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingXL,
          vertical: spacingLG,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
        ),
        elevation: 4,
        shadowColor: primaryBlue.withOpacity(0.3),
        textStyle: buttonText,
      );

  /// Secondary Button
  static ButtonStyle get secondaryButtonLarge => ElevatedButton.styleFrom(
        backgroundColor: secondaryOrange,
        foregroundColor: textInverse,
        minimumSize: const Size(touchTargetLarge, touchTargetLarge),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingXL,
          vertical: spacingLG,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXL),
        ),
        elevation: 4,
        shadowColor: secondaryOrange.withOpacity(0.3),
        textStyle: buttonText,
      );

  /// Success Button
  static ButtonStyle get successButton => ElevatedButton.styleFrom(
        backgroundColor: successGreen,
        foregroundColor: textInverse,
        minimumSize: const Size(touchTargetMedium, touchTargetMedium),
        padding: const EdgeInsets.all(spacingMD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
        ),
        elevation: 2,
        textStyle: buttonText.copyWith(fontSize: 20),
      );

  // ============================================================
  // CARD STYLES
  // ============================================================

  static BoxDecoration get cardDecoration => BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(radiusXL),
        boxShadow: shadowMedium,
      );

  static BoxDecoration get cardElevated => BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(radiusXL),
        boxShadow: shadowLarge,
      );

  // ============================================================
  // ANIMATION DURATIONS
  // ============================================================

  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ============================================================
  // HAPTIC FEEDBACK
  // ============================================================

  static void hapticLight() {
    HapticFeedback.lightImpact();
  }

  static void hapticMedium() {
    HapticFeedback.mediumImpact();
  }

  static void hapticHeavy() {
    HapticFeedback.heavyImpact();
  }

  static void hapticSelection() {
    HapticFeedback.selectionClick();
  }

  // ============================================================
  // HELPER METHODS
  // ============================================================

  /// Get Status Color
  static Color getStatusColor(double score) {
    if (score >= 80) return successGreen;
    if (score >= 60) return warningYellow;
    return errorRed;
  }

  /// Get Status Background Color
  static Color getStatusBackgroundColor(double score) {
    if (score >= 80) return successGreenLight.withOpacity(0.2);
    if (score >= 60) return warningYellowLight.withOpacity(0.2);
    return errorRedLight.withOpacity(0.2);
  }
}

