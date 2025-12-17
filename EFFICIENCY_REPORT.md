# Efficiency Report: kids-ai-all-in

This report identifies several areas in the codebase where efficiency improvements could be made through code deduplication, optimization, and better architectural patterns.

## 1. Duplicate Code Across Apps

### 1.1 CategoryCard Widget Duplication
**Location:** 
- `apps/lianko/lib/widgets/common/category_card.dart`
- `apps/alanko/lib/widgets/common/category_card.dart`

**Issue:** These two files are nearly identical (119 lines each). The only difference is that alanko uses `withValues(alpha: 0.15)` while lianko uses `withOpacity(0.15)`.

**Recommendation:** Move `CategoryCard` to the shared package (`packages/shared/lib/src/widgets/`) to eliminate duplication.

### 1.2 GeminiService Duplication
**Location:**
- `apps/lianko/lib/services/gemini_service.dart`
- `apps/alanko/lib/services/gemini_service.dart`

**Issue:** Both files contain nearly identical implementations of the Gemini AI service. The alanko version also has a hardcoded API key which is a security concern.

**Recommendation:** Create a shared `GeminiService` in the shared package with configurable API key injection.

### 1.3 FirebaseService Duplication
**Location:**
- `apps/lianko/lib/services/firebase_service.dart`
- `apps/alanko/lib/services/firebase_service.dart`

**Issue:** Both services have overlapping functionality for authentication, profile management, and analytics.

**Recommendation:** Extract common Firebase functionality to the shared package.

## 2. Repeated Helper Methods in Game Screens

### 2.1 Difficulty Helper Methods
**Location:**
- `apps/lianko/lib/screens/games/letters/letters_game_screen.dart` (lines 255-267)
- `apps/lianko/lib/screens/games/numbers/numbers_game_screen.dart` (lines 358-370)

**Issue:** Both files contain identical `_getDifficultyColor` and `_getDifficultyText` methods:

```dart
Color _getDifficultyColor(double difficulty) {
  if (difficulty < 0.8) return Colors.green;
  if (difficulty < 1.2) return Colors.blue;
  if (difficulty < 1.5) return Colors.orange;
  return Colors.red;
}

String _getDifficultyText(double difficulty) {
  if (difficulty < 0.8) return 'Lako';
  if (difficulty < 1.2) return 'Normal';
  if (difficulty < 1.5) return 'Teze';
  return 'Tesko';
}
```

**Recommendation:** Extract these to a shared utility class or extension.

### 2.2 Score Item Widget
**Location:**
- `apps/lianko/lib/screens/games/letters/letters_game_screen.dart` (lines 291-326)
- `apps/lianko/lib/screens/games/numbers/numbers_game_screen.dart` (lines 394-416)

**Issue:** Both files have identical `_buildScoreItem` methods for displaying score, streak, and accuracy.

**Recommendation:** Extract to a shared `ScoreItem` widget.

## 3. Algorithmic Inefficiencies

### 3.1 Phrase Type Lookup
**Location:** `packages/shared/lib/src/audio/fluent_tts_service.dart` (lines 336-359)

**Issue:** The `_getPhraseType` method iterates through all phrase types and keywords for every text lookup. This is O(n*m) where n is the number of phrase types and m is the average number of keywords.

```dart
String? _getPhraseType(String text) {
  final normalized = text.toLowerCase().trim();
  for (final entry in typeMap.entries) {
    for (final keyword in entry.value) {
      if (normalized.contains(keyword)) {
        return entry.key;
      }
    }
  }
  return null;
}
```

**Recommendation:** Pre-compute a reverse lookup map from keywords to phrase types for O(1) lookup.

### 3.2 Random Phrase Selection
**Location:** `apps/lianko/lib/services/alan_voice_service.dart` (line 331)

**Issue:** Using `DateTime.now().millisecond % phrases.length` for "random" selection is not truly random and can produce predictable patterns.

```dart
return phrases[(DateTime.now().millisecond % phrases.length)];
```

**Recommendation:** Use `Random().nextInt(phrases.length)` for better randomness.

### 3.3 Option Generation Loop
**Location:** `apps/lianko/lib/screens/games/numbers/numbers_game_screen.dart` (lines 138-144)

**Issue:** The while loop for generating wrong answer options could potentially run many iterations if the random numbers keep hitting invalid values.

```dart
while (optionSet.length < optionCount) {
  int wrong = _correctAnswer + random.nextInt(5) - 2;
  if (wrong >= 0 && wrong < _numbers.length && wrong != _correctAnswer) {
    optionSet.add(wrong);
  }
}
```

**Recommendation:** Use a more deterministic approach by pre-computing valid wrong answers.

## 4. Memory and Performance

### 4.1 Cache File Iteration
**Location:** `packages/shared/lib/src/audio/tts_cache_manager.dart` (lines 35-49)

**Issue:** The `_loadExistingCache` method iterates through all files and performs string operations for each file path.

**Recommendation:** Consider using a metadata file to track cached entries instead of parsing filenames.

### 4.2 Repeated Category Definitions
**Location:** `apps/lianko/lib/screens/home/home_screen.dart` (lines 263-383)

**Issue:** The `_getCategoriesForAge` method has three separate lists with similar category structures. Some categories like 'letters', 'numbers', 'colors', and 'stories' appear in multiple age groups with slight variations.

**Recommendation:** Use a data-driven approach with a single category definition that includes age-group visibility flags.

## Summary

| Issue | Severity | Effort | Impact |
|-------|----------|--------|--------|
| CategoryCard duplication | Medium | Low | Reduces maintenance burden |
| GeminiService duplication | High | Medium | Security + maintenance |
| FirebaseService duplication | Medium | Medium | Reduces maintenance burden |
| Difficulty helper methods | Low | Low | Code cleanliness |
| Score item widget | Low | Low | Code cleanliness |
| Phrase type lookup | Low | Low | Minor performance gain |
| Random phrase selection | Low | Low | Better randomness |
| Option generation loop | Low | Low | Prevents edge cases |
| Cache file iteration | Low | Medium | Minor performance gain |
| Category definitions | Low | Medium | Code cleanliness |

## Recommended Priority

1. **High Priority:** GeminiService duplication (security concern with hardcoded API key)
2. **Medium Priority:** CategoryCard and FirebaseService duplication
3. **Low Priority:** Helper method extraction and algorithmic optimizations
