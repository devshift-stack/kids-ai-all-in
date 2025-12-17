# Prompts für andere Agenten

Kopiere diese Prompts in neue Chat-Sessions mit den jeweiligen Agenten.

---

## 1. ALANKO-AGENT

```
AUFGABE: Unit Test Prompts erstellen

SCHRITT 1: Lies das Briefing
cat /Users/dsselmanovic/devshift-stack/Kids-AI-Train-Lianko/UNIT_TEST_BRIEFING.md

SCHRITT 2: Analysiere den Alanko-Code
Lies alle Dateien in:
- lib/models/
- lib/services/
- lib/providers/

SCHRITT 3: Erstelle TEST_PROMPTS.md
Erstelle eine Datei TEST_PROMPTS.md im Root von Kids-AI-Train-Alanko.

Format für jeden Modul-Prompt:

## [MODUL-NAME]

**Datei:** `lib/path/to/file.dart`
**Speichern in:** `test/path/to/file_test.dart`
**Beschreibung:** Was macht dieses Modul?

### Klassen zu testen:
1. `ClassName`
   - `method1()` - Beschreibung
   - `method2()` - Beschreibung

### Edge Cases:
- Edge Case 1
- Edge Case 2

### Beispiel-Test:
```dart
test('beschreibender Name', () {
  expect(result, equals(expected));
});
```

### Abhängigkeiten:
- Mock für X oder "Keine"

---

SCHRITT 4: Push
git add TEST_PROMPTS.md
git commit -m "docs: Add Unit Test Prompts for Alanko"
git push origin main

WICHTIG:
- Erstelle Prompts für ALLE Models und Services
- Nutze deutschsprachige Test-Beschreibungen
- Denke an Edge Cases (leere Werte, Null, Extreme)
```

---

## 2. PARENTSDASH-AGENT

```
AUFGABE: Unit Test Prompts erstellen

SCHRITT 1: Lies das Briefing
cat /Users/dsselmanovic/devshift-stack/Kids-AI-Train-Lianko/UNIT_TEST_BRIEFING.md

SCHRITT 2: Analysiere den ParentsDash-Code
Lies alle Dateien in:
- lib/models/
- lib/services/
- lib/providers/

Besonders wichtig für ParentsDash:
- Child-Sync Services
- Settings-Verwaltung
- Notification-Handling
- Audiogramm-Upload UI Logik

SCHRITT 3: Erstelle TEST_PROMPTS.md
Erstelle eine Datei TEST_PROMPTS.md im Root von Kids-AI-Train-Parent.

Format für jeden Modul-Prompt:

## [MODUL-NAME]

**Datei:** `lib/path/to/file.dart`
**Speichern in:** `test/path/to/file_test.dart`
**Beschreibung:** Was macht dieses Modul?

### Klassen zu testen:
1. `ClassName`
   - `method1()` - Beschreibung
   - `method2()` - Beschreibung

### Edge Cases:
- Edge Case 1
- Edge Case 2

### Beispiel-Test:
```dart
test('beschreibender Name', () {
  expect(result, equals(expected));
});
```

### Abhängigkeiten:
- Mock für Firestore, etc.

---

SCHRITT 4: Push
git add TEST_PROMPTS.md
git commit -m "docs: Add Unit Test Prompts for ParentsDash"
git push origin main

WICHTIG:
- Erstelle Prompts für ALLE Models und Services
- ParentsDash hat viel Firestore-Interaktion → Mock-Hinweise wichtig
- Sync-Logik gründlich dokumentieren
```

---

## 3. SHARED-AGENT

```
AUFGABE: Unit Test Prompts erstellen

SCHRITT 1: Lies das Briefing
cat /Users/dsselmanovic/devshift-stack/Kids-AI-Train-Lianko/UNIT_TEST_BRIEFING.md

SCHRITT 2: Analysiere den Shared-Code
Lies alle Dateien in:
- lib/src/theme/ (Colors, Typography, Spacing)
- lib/src/widgets/ (Shared Widgets)
- lib/src/utils/ (Hilfsfunktionen)
- lib/src/models/ (Gemeinsame Models)

SCHRITT 3: Erstelle TEST_PROMPTS.md
Erstelle eine Datei TEST_PROMPTS.md im Root von Kids-AI-Shared.

Format für jeden Modul-Prompt:

## [MODUL-NAME]

**Datei:** `lib/src/path/to/file.dart`
**Speichern in:** `test/src/path/to/file_test.dart`
**Beschreibung:** Was macht dieses Modul?

### Klassen zu testen:
1. `ClassName`
   - `property1` - Beschreibung
   - `method1()` - Beschreibung

### Edge Cases:
- Edge Case 1
- Edge Case 2

### Beispiel-Test:
```dart
test('beschreibender Name', () {
  expect(KidsColors.primary, isA<Color>());
});
```

### Abhängigkeiten:
- Keine (meistens pure Dart)

---

SCHRITT 4: Push
git add TEST_PROMPTS.md
git commit -m "docs: Add Unit Test Prompts for Shared Package"
git push origin main

WICHTIG:
- Shared ist ein Package → meist keine externen Abhängigkeiten
- Design System testen (Colors, Spacing, Typography)
- Alle öffentlichen APIs dokumentieren
```

---

## Nachdem alle fertig sind

Komm zurück zu mir (Lianko-Agent) mit:

```
Alle Agenten haben ihre TEST_PROMPTS.md erstellt.
Generiere jetzt die Unit Tests für alle Repos:
- Kids-AI-Train-Lianko
- Kids-AI-Train-Alanko
- Kids-AI-Train-Parent
- Kids-AI-Shared
```

Ich werde dann:
1. Alle TEST_PROMPTS.md lesen
2. Unit Tests generieren
3. In test/ Ordner speichern
4. Pushen

---

## Quick Reference

| Agent | Repo | Befehl zum Starten |
|-------|------|-------------------|
| Alanko | Kids-AI-Train-Alanko | Prompt #1 oben |
| ParentsDash | Kids-AI-Train-Parent | Prompt #2 oben |
| Shared | Kids-AI-Shared | Prompt #3 oben |
