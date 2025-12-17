import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';

/// Enhanced Design System für Therapy AI
/// Optimiert für 4-jährige Kinder mit Hörverlust
class TherapyDesignSystem {
  TherapyDesignSystem._();

  // ============================================================
  // TOUCH TARGETS (WCAG AAA für Kinder)
  // ============================================================
  
  /// Minimale Touch-Target-Größe für primäre Buttons (für 4-Jährige optimiert)
  static const double touchTargetPrimary = 100.0; // 100x100px (erhöht von 80px)
  
  /// Minimale Touch-Target-Größe für sekundäre Buttons
  static const double touchTargetSecondary = 80.0; // 80x80px (erhöht von 64px)
  
  /// Minimale Touch-Target-Größe für Icons
  static const double touchTargetIcon = 64.0; // 64x64px (erhöht von 56px)
  
  /// Minimale Touch-Target-Größe für kleine Buttons
  static const double touchTargetSmall = 56.0; // 56x56px (erhöht von 48px)
  
  /// Abstand zwischen Touch-Targets
  static const double touchTargetSpacing = 32.0; // 32px (erhöht von 24px)

  // ============================================================
  // TYPOGRAPHY (Optimiert für 4-Jährige)
  // ============================================================
  
  /// Target Words (z.B. "MAMA") - Sehr groß (für 4-Jährige optimiert)
  static const TextStyle targetWordStyle = TextStyle(
    fontSize: 72.0, // Erhöht von 64px
    fontWeight: FontWeight.bold,
    height: 1.2,
    letterSpacing: 3.0, // Erhöht für bessere Lesbarkeit
    color: KidsColors.textPrimary,
  );
  
  /// Hauptüberschriften (H1)
  static const TextStyle h1Style = TextStyle(
    fontSize: 48.0,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: KidsColors.textPrimary,
  );
  
  /// Sekundäre Überschriften (H2)
  static const TextStyle h2Style = TextStyle(
    fontSize: 40.0,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: KidsColors.textPrimary,
  );
  
  /// Tertiäre Überschriften (H3)
  static const TextStyle h3Style = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: KidsColors.textPrimary,
  );
  
  /// Anweisungen (z.B. "Sag nach:")
  static const TextStyle instructionStyle = TextStyle(
    fontSize: 32.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: KidsColors.textPrimary,
  );
  
  /// Body Large
  static const TextStyle bodyLargeStyle = TextStyle(
    fontSize: 26.0, // Erhöht von 24px
    fontWeight: FontWeight.normal,
    height: 1.6,
    color: KidsColors.textPrimary,
  );
  
  /// Body Medium
  static const TextStyle bodyMediumStyle = TextStyle(
    fontSize: 24.0, // Erhöht von 20px
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: KidsColors.textPrimary,
  );
  
  /// Body Small
  static const TextStyle bodySmallStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: KidsColors.textSecondary,
  );
  
  /// Button Text
  static const TextStyle buttonStyle = TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: Colors.white,
  );
  
  /// Caption
  static const TextStyle captionStyle = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: KidsColors.textSecondary,
  );

  // ============================================================
  // SPACING SYSTEM (Generous für Klarheit)
  // ============================================================
  
  static const double spacingXS = 4.0;
  static const double spacingSM = 8.0;
  static const double spacingMD = 16.0;
  static const double spacingLG = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0; // Für große Abstände zwischen Elementen
  static const double spacingXXXL = 64.0; // Für sehr große Abstände
  static const double spacingHuge = 80.0; // Für maximale Abstände

  // ============================================================
  // BORDER RADIUS
  // ============================================================
  
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // ============================================================
  // STATUS COLORS (Farbcodierung)
  // ============================================================
  
  /// Erfolg / Bereit - 🟢 Grün
  static const Color statusSuccess = Color(0xFF52C41A);
  static const Color statusSuccessLight = Color(0xFFB7EB8F);
  static const Color statusSuccessBg = Color(0xFFF6FFED);
  
  /// Warte / In Bearbeitung - 🟡 Gelb
  static const Color statusWarning = Color(0xFFFFA502);
  static const Color statusWarningLight = Color(0xFFFFE58F);
  static const Color statusWarningBg = Color(0xFFFFFBE6);
  
  /// Aktiv / Aufnahme läuft - 🔵 Blau
  static const Color statusActive = Color(0xFF4A90E2);
  static const Color statusActiveLight = Color(0xFF91D5FF);
  static const Color statusActiveBg = Color(0xFFE6F7FF);
  
  /// Inaktiv / Pausiert - ⚪ Grau
  static const Color statusInactive = Color(0xFFBFBFBF);
  static const Color statusInactiveLight = Color(0xFFE8E8E8);
  static const Color statusInactiveBg = Color(0xFFF5F5F5);
  
  /// Fehler (sparsam verwenden!) - 🔴 Rot
  static const Color statusError = Color(0xFFFF4757);
  static const Color statusErrorLight = Color(0xFFFF9999);
  static const Color statusErrorBg = Color(0xFFFFECEC);

  /// Helper: Get Status Color by Status String
  static Color getStatusColorByString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'erfolg':
      case 'bereit':
        return statusSuccess;
      case 'warning':
      case 'warte':
      case 'in_bearbeitung':
        return statusWarning;
      case 'active':
      case 'aktiv':
      case 'aufnahme':
        return statusActive;
      case 'inactive':
      case 'inaktiv':
      case 'pausiert':
        return statusInactive;
      case 'error':
      case 'fehler':
        return statusError;
      default:
        return statusInactive;
    }
  }

  /// Helper: Get Status Background Color by Status String
  static Color getStatusBackgroundColorByString(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'erfolg':
      case 'bereit':
        return statusSuccessBg;
      case 'warning':
      case 'warte':
      case 'in_bearbeitung':
        return statusWarningBg;
      case 'active':
      case 'aktiv':
      case 'aufnahme':
        return statusActiveBg;
      case 'inactive':
      case 'inaktiv':
      case 'pausiert':
        return statusInactiveBg;
      case 'error':
      case 'fehler':
        return statusErrorBg;
      default:
        return statusInactiveBg;
    }
  }

  // ============================================================
  // BUTTON STYLES
  // ============================================================
  
  /// Großer primärer Button (80x80px minimum)
  static ButtonStyle get primaryButtonLarge => ElevatedButton.styleFrom(
    minimumSize: const Size(touchTargetPrimary, touchTargetPrimary),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingXL,
      vertical: spacingLG,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    backgroundColor: KidsColors.primary,
    elevation: 4,
    textStyle: buttonStyle,
  );
  
  /// Großer sekundärer Button (64x64px minimum)
  static ButtonStyle get secondaryButtonLarge => OutlinedButton.styleFrom(
    minimumSize: const Size(touchTargetSecondary, touchTargetSecondary),
    padding: const EdgeInsets.symmetric(
      horizontal: spacingXL,
      vertical: spacingLG,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
    side: const BorderSide(color: KidsColors.primary, width: 3),
    textStyle: buttonStyle.copyWith(color: KidsColors.primary),
  );
  
  /// Großer Icon-Button (80x80px)
  static ButtonStyle get iconButtonLarge => IconButton.styleFrom(
    minimumSize: const Size(touchTargetPrimary, touchTargetPrimary),
    padding: const EdgeInsets.all(spacingLG),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radiusLarge),
    ),
  );

  // ============================================================
  // PROGRESS BAR STYLES
  // ============================================================
  
  /// Großer Fortschrittsbalken
  static const double progressBarHeight = 16.0;
  static const double progressBarHeightLarge = 24.0;
  
  static BoxDecoration get progressBarDecoration => BoxDecoration(
    borderRadius: BorderRadius.circular(radiusMedium),
    color: statusInactiveBg,
  );
  
  static BoxDecoration progressBarFillDecoration(Color color) => BoxDecoration(
    borderRadius: BorderRadius.circular(radiusMedium),
    color: color,
  );

  // ============================================================
  // CARD STYLES
  // ============================================================
  
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.08),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
  
  static EdgeInsets get cardPadding => const EdgeInsets.all(spacingXL);

  // ============================================================
  // HAPTIC FEEDBACK
  // ============================================================
  
  /// Leichte Vibration für Erfolg
  static Future<void> hapticSuccess() async {
    await HapticFeedback.lightImpact();
  }
  
  /// Mittlere Vibration für wichtige Aktionen
  static Future<void> hapticMedium() async {
    await HapticFeedback.mediumImpact();
  }
  
  /// Starke Vibration für Fehler (sparsam!)
  static Future<void> hapticError() async {
    await HapticFeedback.heavyImpact();
  }
  
  /// Selektion Feedback
  static Future<void> hapticSelection() async {
    await HapticFeedback.selectionClick();
  }

  // ============================================================
  // ANIMATION DURATIONS
  // ============================================================
  
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 400);
  static const Duration animationVerySlow = Duration(milliseconds: 600);
  
  /// Pulse Animation für aktive Elemente
  static const Duration pulseDuration = Duration(milliseconds: 1000);
  
  /// Success Animation
  static const Duration successAnimationDuration = Duration(milliseconds: 1500);
}
