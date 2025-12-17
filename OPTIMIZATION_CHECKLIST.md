# Kids AI - Optimierungs-Checkliste

Diese Checkliste enthält konkrete Aufgaben zur Umsetzung der Empfehlungen aus `CODE_ANALYSIS_REPORT.md`.

---

## 🚨 PHASE 1: Kritische Sicherheitsfixes (SOFORT)

### API-Key Sicherheit

- [ ] **API-Key aus `apps/alanko/lib/services/gemini_service.dart` entfernen**
  ```dart
  // Zeile 8 ersetzen:
  // ALT: static const String _apiKey = 'AIzaSyD5jBRl-Ti0r_uSyx5JW24H3CySQ8RWrS8';
  // NEU:
  static const String _apiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  ```

- [ ] **Google Cloud Console: API-Key rotieren**
  - URL: https://console.cloud.google.com/apis/credentials
  - Alten Key löschen oder deaktivieren
  - Neuen Key erstellen mit Beschränkungen

- [ ] **Build-Konfiguration dokumentieren**
  ```bash
  # In README.md hinzufügen:
  flutter run --dart-define=GEMINI_API_KEY=your_key
  flutter build apk --dart-define=GEMINI_API_KEY=your_key
  ```

- [ ] **CI/CD Pipeline anpassen** (falls vorhanden)
  - Secrets in GitHub/GitLab speichern
  - Build-Skript mit `--dart-define` erweitern

### Input-Validierung

- [ ] **`FirebaseService.saveChildProfile()` validieren** (beide Apps)
  ```dart
  Future<void> saveChildProfile({...}) async {
    // Validierung hinzufügen
    assert(name.isNotEmpty && name.length <= 50, 'Name ungültig');
    assert(age >= 3 && age <= 12, 'Alter ungültig');
    assert(['bs', 'hr', 'sr', 'de', 'en', 'tr'].contains(preferredLanguage));
    // ... Rest
  }
  ```

---

## 📦 PHASE 2: Shared Package erweitern

### 2.1 CategoryCard verschieben

- [ ] **Neue Datei erstellen:** `packages/shared/lib/src/widgets/category_card.dart`
  - Code von Alanko kopieren (modernere Syntax mit `withValues`)
  - Import von `AppTheme` durch Parameter ersetzen

- [ ] **Export hinzufügen:** `packages/shared/lib/kids_ai_shared.dart`
  ```dart
  export 'src/widgets/category_card.dart';
  ```

- [ ] **Imports in Apps aktualisieren:**
  - `apps/lianko/lib/screens/home/home_screen.dart`
  - `apps/alanko/lib/screens/home/home_screen.dart`

- [ ] **Alte Dateien löschen:**
  - `apps/lianko/lib/widgets/common/category_card.dart`
  - `apps/alanko/lib/widgets/common/category_card.dart`

### 2.2 GeminiService zentralisieren

- [ ] **Neue Datei:** `packages/shared/lib/src/services/gemini_service.dart`
  ```dart
  class GeminiService {
    final String _apiKey;
    
    GeminiService({String? apiKey}) 
      : _apiKey = apiKey ?? const String.fromEnvironment('GEMINI_API_KEY');
    
    // ... gemeinsame Logik
  }
  ```

- [ ] **Export hinzufügen**

- [ ] **In Apps: Import ändern & lokale Dateien löschen**

### 2.3 AnimatedBuilder zentralisieren

- [ ] **Neue Datei:** `packages/shared/lib/src/widgets/animated_builder.dart`

- [ ] **Export hinzufügen**

- [ ] **Alle Vorkommen ersetzen:**
  - `apps/lianko/lib/main.dart` (Zeilen 297-312)
  - `apps/alanko/lib/main.dart` (Zeilen 274-289)
  - `apps/lianko/lib/screens/games/numbers/numbers_game_screen.dart` (Zeilen 582-595)
  - `apps/lianko/lib/screens/games/letters/letters_game_screen.dart` (Zeilen 420-433)

### 2.4 Score Widgets

- [ ] **Neue Datei:** `packages/shared/lib/src/widgets/score_display.dart`
  ```dart
  class ScoreItem extends StatelessWidget { ... }
  class ScoreBar extends StatelessWidget { ... }
  ```

---

## ⚡ PHASE 3: Performance-Optimierungen

### 3.1 Phrase-Lookup optimieren

- [ ] **Datei:** `packages/shared/lib/src/audio/fluent_tts_service.dart`
  ```dart
  // Feld hinzufügen
  late final Map<String, String> _keywordToType;
  
  // In init() aufrufen
  void _buildKeywordMap() {
    _keywordToType = {};
    final typeMap = {
      'correct': ['bravo', 'super', ...],
      // ...
    };
    for (final entry in typeMap.entries) {
      for (final keyword in entry.value) {
        _keywordToType[keyword] = entry.key;
      }
    }
  }
  ```

### 3.2 Cache-Index implementieren

- [ ] **Datei:** `packages/shared/lib/src/audio/tts_cache_manager.dart`
  - JSON-Index statt Dateisystem-Iteration
  - Siehe `CODE_ANALYSIS_REPORT.md` Abschnitt 3.2

### 3.3 Options-Generierung

- [ ] **Datei:** `apps/lianko/lib/screens/games/numbers/numbers_game_screen.dart`
  - While-Loop durch deterministische Methode ersetzen
  - Zeilen 138-145

### 3.4 Random-Generierung

- [ ] **Datei:** `apps/lianko/lib/services/alan_voice_service.dart`
  - `DateTime.now().millisecond` durch `Random().nextInt()` ersetzen

---

## 🧪 PHASE 4: Testing hinzufügen

### Unit Tests

- [ ] **GeminiService Tests**
  - `packages/shared/test/services/gemini_service_test.dart`

- [ ] **FluentTtsService Tests**
  - `packages/shared/test/audio/fluent_tts_service_test.dart`

- [ ] **AdaptiveLearningService Tests**
  - `apps/lianko/test/services/adaptive_learning_service_test.dart`

### Widget Tests

- [ ] **CategoryCard Tests**
  - `packages/shared/test/widgets/category_card_test.dart`

- [ ] **ScoreDisplay Tests**
  - `packages/shared/test/widgets/score_display_test.dart`

### Integration Tests

- [ ] **Game Flow Tests**
  - `apps/lianko/integration_test/numbers_game_test.dart`
  - `apps/lianko/integration_test/letters_game_test.dart`

---

## 📋 Fortschritts-Tracker

| Phase | Aufgaben | Erledigt | Status |
|-------|----------|----------|--------|
| Phase 1 | 4 | 0 | ⏳ Ausstehend |
| Phase 2 | 12 | 0 | ⏳ Ausstehend |
| Phase 3 | 4 | 0 | ⏳ Ausstehend |
| Phase 4 | 8 | 0 | ⏳ Ausstehend |

---

## Git Workflow

Für jede Phase:

```bash
# 1. Branch erstellen
git checkout -b fix/security-api-key  # Phase 1
git checkout -b refactor/shared-widgets  # Phase 2
git checkout -b perf/cache-optimization  # Phase 3
git checkout -b test/add-unit-tests  # Phase 4

# 2. Änderungen committen
git add -A
git commit -m "fix: Remove hardcoded API key from source code"

# 3. Pull Request erstellen
gh pr create --title "fix: Security - Remove hardcoded API keys" --body "..."
```

---

**Geschätzte Gesamtdauer:** 2-3 Wochen bei konsequenter Umsetzung

**Erstellt:** 2025-12-17
