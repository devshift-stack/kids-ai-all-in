import 'package:flutter/material.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import 'package:kids_ai_shared/src/theme/shadows.dart';
import 'package:kids_ai_shared/src/theme/theme.dart';

/// Therapy AI App Theme
/// Uses the shared design system from kids_ai_shared
class AppTheme {
  AppTheme._();

  // Re-export colors from shared
  static const Color primaryColor = KidsColors.primary;
  static const Color secondaryColor = KidsColors.secondary;
  static const Color accentColor = KidsColors.accent;
  static const Color backgroundColor = KidsColors.background;
  static const Color surfaceColor = KidsColors.surface;
  static const Color errorColor = KidsColors.error;
  static const Color successColor = KidsColors.success;
  static const Color warningColor = KidsColors.warning;

  // Text Colors
  static const Color textPrimary = KidsColors.textPrimary;
  static const Color textSecondary = KidsColors.textSecondary;
  static const Color textLight = KidsColors.textLight;

  // Gradients
  static const LinearGradient primaryGradient = KidsGradients.primary;
  static const LinearGradient characterGradient = KidsGradients.character;

  // Border Radius
  static const double radiusSmall = KidsSpacing.radiusSm;
  static const double radiusMedium = KidsSpacing.radiusMd;
  static const double radiusLarge = KidsSpacing.radiusLg;
  static const double radiusXLarge = KidsSpacing.radiusXl;

  // Spacing
  static const double spacingXs = KidsSpacing.xs;
  static const double spacingSm = KidsSpacing.sm;
  static const double spacingMd = KidsSpacing.md;
  static const double spacingLg = KidsSpacing.lg;
  static const double spacingXl = KidsSpacing.xl;
  static const double spacingXxl = KidsSpacing.xxl;

  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimary),
        displayMedium: TextStyle(color: textPrimary),
        displaySmall: TextStyle(color: textPrimary),
        headlineLarge: TextStyle(color: textPrimary),
        headlineMedium: TextStyle(color: textPrimary),
        headlineSmall: TextStyle(color: textPrimary),
        titleLarge: TextStyle(color: textPrimary),
        titleMedium: TextStyle(color: textPrimary),
        titleSmall: TextStyle(color: textPrimary),
        bodyLarge: TextStyle(color: textPrimary),
        bodyMedium: TextStyle(color: textPrimary),
        bodySmall: TextStyle(color: textSecondary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: spacingMd,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
      ),
    );
  }

  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        color: surfaceColor,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: textPrimary),
        titleTextStyle: const TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

