import 'package:flutter/material.dart';

/// Game utility functions shared across Kids AI apps
/// Provides common helpers for game screens to reduce code duplication
class GameUtils {
  GameUtils._();

  // ============================================================
  // DIFFICULTY HELPERS
  // ============================================================

  /// Returns a color representing the difficulty level
  /// Used in game headers to visually indicate current difficulty
  ///
  /// - Green: Easy (difficulty < 0.8)
  /// - Blue: Normal (0.8 <= difficulty < 1.2)
  /// - Orange: Hard (1.2 <= difficulty < 1.5)
  /// - Red: Very Hard (difficulty >= 1.5)
  static Color getDifficultyColor(double difficulty) {
    if (difficulty < 0.8) return Colors.green;
    if (difficulty < 1.2) return Colors.blue;
    if (difficulty < 1.5) return Colors.orange;
    return Colors.red;
  }

  /// Returns a localized text label for the difficulty level
  /// Currently returns Bosnian/Croatian/Serbian text
  ///
  /// - 'Lako' (Easy): difficulty < 0.8
  /// - 'Normal': 0.8 <= difficulty < 1.2
  /// - 'Teze' (Harder): 1.2 <= difficulty < 1.5
  /// - 'Tesko' (Hard): difficulty >= 1.5
  static String getDifficultyText(double difficulty) {
    if (difficulty < 0.8) return 'Lako';
    if (difficulty < 1.2) return 'Normal';
    if (difficulty < 1.5) return 'Teze';
    return 'Tesko';
  }

  /// Returns both color and text for a difficulty level
  /// Convenience method to get both values at once
  static ({Color color, String text}) getDifficultyInfo(double difficulty) {
    return (
      color: getDifficultyColor(difficulty),
      text: getDifficultyText(difficulty),
    );
  }

  // ============================================================
  // SCORE HELPERS
  // ============================================================

  /// Returns a color based on accuracy percentage
  /// Used to color accuracy indicators in score displays
  ///
  /// - Green: accuracy >= 70%
  /// - Orange: accuracy < 70%
  static Color getAccuracyColor(int accuracy) {
    return accuracy >= 70 ? Colors.green : Colors.orange;
  }

  /// Calculates accuracy percentage from correct and total counts
  static int calculateAccuracy(int correct, int total) {
    if (total == 0) return 0;
    return ((correct / total) * 100).round();
  }
}
