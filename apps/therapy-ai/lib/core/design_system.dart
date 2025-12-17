import 'package:flutter/material.dart';

/// Design System für Therapy AI App
/// Optimiert für 4-jährige Kinder mit Hörverlust
class TherapyDesignSystem {
  TherapyDesignSystem._();

  // ========== Colors ==========
  
  /// Primärfarbe - Vertrauen und Ruhe
  static const Color primaryBlue = Color(0xFF4A90E2);
  
  /// Sekundärfarbe - Energie und Motivation
  static const Color secondaryOrange = Color(0xFFFF6B35);
  
  /// Erfolg - Positive Verstärkung
  static const Color successGreen = Color(0xFF52C41A);
  
  /// Warnung - Aufmerksamkeit
  static const Color warningYellow = Color(0xFFFFA502);
  
  /// Fehler - Vorsichtig verwenden
  static const Color errorRed = Color(0xFFFF4757);
  
  /// Hintergrund - Reduziert Ermüdung
  static const Color backgroundLight = Color(0xFFF8F9FA);
  
  /// Text - Hoher Kontrast
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textMedium = Color(0xFF7F8C8D);
  static const Color textLight = Color(0xFFBDC3C7);
  
  /// Surface
  static const Color surfaceWhite = Color(0xFFFFFFFF);
  static const Color surfaceGray = Color(0xFFECF0F1);

  // ========== Typography ==========
  
  /// Hauptüberschriften (Titel)
  static const TextStyle headingLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textDark,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textDark,
    letterSpacing: -0.5,
  );
  
  static const TextStyle headingSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textDark,
  );
  
  /// Anweisungen
  static const TextStyle instruction = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textDark,
  );
  
  /// Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textDark,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textDark,
  );
  
  /// Button Text
  static const TextStyle buttonText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  // ========== Spacing ==========
  
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // ========== Border Radius ==========
  
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;
  static const double radiusRound = 999.0;

  // ========== Touch Targets ==========
  
  /// Minimum Touch-Target Größe für Kinder (WCAG AAA)
  static const double minTouchTarget = 48.0;
  
  /// Große Touch-Targets für wichtige Aktionen
  static const double largeTouchTarget = 80.0;
  
  /// Extra große Touch-Targets für primäre Aktionen
  static const double extraLargeTouchTarget = 100.0;

  // ========== Button Styles ==========
  
  /// Großer primärer Button
  static ButtonStyle get primaryButtonLarge => ElevatedButton.styleFrom(
    backgroundColor: primaryBlue,
    foregroundColor: Colors.white,
    minimumSize: const Size(largeTouchTarget, largeTouchTarget),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingXL,
      vertical: spacingLG,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    elevation: 4,
    textStyle: buttonText,
  );
  
  /// Großer sekundärer Button
  static ButtonStyle get secondaryButtonLarge => ElevatedButton.styleFrom(
    backgroundColor: secondaryOrange,
    foregroundColor: Colors.white,
    minimumSize: const Size(largeTouchTarget, largeTouchTarget),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingXL,
      vertical: spacingLG,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    elevation: 4,
    textStyle: buttonText,
  );
  
  /// Erfolgs-Button
  static ButtonStyle get successButton => ElevatedButton.styleFrom(
    backgroundColor: successGreen,
    foregroundColor: Colors.white,
    minimumSize: const Size(minTouchTarget, minTouchTarget),
    padding: const EdgeInsets.all(spacingMD),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusMedium),
    ),
    elevation: 2,
    textStyle: buttonText.copyWith(fontSize: 20),
  );

  // ========== Card Styles ==========
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: surfaceWhite,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // ========== Progress Bar Styles ==========
  
  static BoxDecoration get progressBarBackground => BoxDecoration(
    color: surfaceGray,
    borderRadius: BorderRadius.circular(radiusRound),
  );
  
  static BoxDecoration progressBarFill(Color color) => BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(radiusRound),
  );

  // ========== Feedback Colors ==========
  
  static Color getFeedbackColor(double score) {
    if (score >= 80) return successGreen;
    if (score >= 60) return warningYellow;
    return errorRed;
  }
  
  static Color getStatusColor(FeedbackStatus status) {
    switch (status) {
      case FeedbackStatus.success:
        return successGreen;
      case FeedbackStatus.warning:
        return warningYellow;
      case FeedbackStatus.error:
        return errorRed;
      case FeedbackStatus.info:
        return primaryBlue;
    }
  }
}

/// Feedback Status für visuelle Indikatoren
enum FeedbackStatus {
  success,
  warning,
  error,
  info,
}

/// Button Größen
enum ButtonSize {
  small,   // 48x48px
  medium,  // 64x64px
  large,   // 80x80px
  extraLarge, // 100x100px
}

extension ButtonSizeExtension on ButtonSize {
  double get size {
    switch (this) {
      case ButtonSize.small:
        return TherapyDesignSystem.minTouchTarget;
      case ButtonSize.medium:
        return 64.0;
      case ButtonSize.large:
        return TherapyDesignSystem.largeTouchTarget;
      case ButtonSize.extraLarge:
        return TherapyDesignSystem.extraLargeTouchTarget;
    }
  }
}

