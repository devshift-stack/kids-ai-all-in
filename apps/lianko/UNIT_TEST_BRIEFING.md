# Unit Test Briefing für alle Agenten

## Übersicht

Dieses Dokument erklärt, wie jeder Agent (Alanko, ParentsDash, Shared) Test-Prompts für seine Module schreiben soll.

---

## Was ist ein Test-Prompt?

Ein Test-Prompt ist eine strukturierte Anweisung für Claude, um Unit Tests zu generieren.

**Beispiel:**
```
MODUL: AudiogramModel
DATEI: lib/models/audiogram/audiogram_model.dart
BESCHREIBUNG: Berechnet Hörverlust-Werte aus Audiogramm-Daten

FUNKTIONEN ZU TESTEN:
1. pta (Pure Tone Average Berechnung)
2. hearingLossLevel (WHO-Klassifikation)
3. hasHighFrequencyLoss (Hochton-Abfall erkennen)

EDGE CASES:
- Leere Werte
- Nur ein Ohr hat Daten
- Extreme Werte (0 dB, 120 dB)

ERWARTETE TESTS:
- PTA berechnet Durchschnitt von 500, 1000, 2000, 4000 Hz
- PTA gibt 0 zurück bei leeren Daten
- hearingLossLevel klassifiziert korrekt nach WHO
- hasHighFrequencyLoss erkennt >15dB Differenz
```

---

## Format für Test-Prompts

Jeder Agent soll Test-Prompts in diesem Format erstellen:

```markdown
## [MODUL-NAME]

**Datei:** `lib/path/to/file.dart`
**Beschreibung:** [Was macht dieses Modul?]

### Klassen/Funktionen:
1. `ClassName` - [Beschreibung]
   - `method1()` - [Was macht es?]
   - `method2(param)` - [Was macht es?]

### Zu testende Szenarien:
- [ ] Szenario 1: [Beschreibung]
- [ ] Szenario 2: [Beschreibung]
- [ ] Edge Case: [Beschreibung]

### Abhängigkeiten:
- Braucht Mock für: [Firebase, API, etc.] oder "Keine"

### Beispiel-Assertion:
```dart
expect(result.value, equals(42));
expect(result.isValid, isTrue);
```
```

---

## Anleitung für jeden Agenten

### ALANKO Agent

Erstelle Test-Prompts für:
1. **Models** - Alle Datenmodelle in `lib/models/`
2. **Services** - Business-Logik in `lib/services/`
3. **Providers** - Riverpod Provider in `lib/providers/`

**Ignorieren:**
- Screens (UI-Tests sind aufwendiger)
- Widgets (später)

**Beispiel für Alanko:**
```markdown
## VocabularyModel

**Datei:** `lib/models/vocabulary/vocabulary_model.dart`
**Beschreibung:** Vokabel-Daten für Lernspiele

### Klassen:
1. `VocabularyItem`
   - `fromJson()` - Parsed JSON zu Objekt
   - `toJson()` - Konvertiert zu JSON

### Szenarien:
- [ ] fromJson parsed alle Felder korrekt
- [ ] fromJson mit fehlenden Feldern gibt Defaults
- [ ] toJson/fromJson Roundtrip funktioniert

### Abhängigkeiten: Keine
```

---

### PARENTSDASH Agent

Erstelle Test-Prompts für:
1. **Models** - Kind-Einstellungen, Benachrichtigungen
2. **Services** - Sync-Service, Notification-Service
3. **Utils** - Hilfsfunktionen

**Beispiel für ParentsDash:**
```markdown
## ChildSyncService

**Datei:** `lib/services/child_sync_service.dart`
**Beschreibung:** Synchronisiert Kind-Einstellungen mit Firestore

### Klassen:
1. `ChildSyncService`
   - `syncSettings()` - Lädt Settings von Firestore
   - `updateSetting()` - Speichert einzelnes Setting

### Szenarien:
- [ ] syncSettings lädt korrekt bei Verbindung
- [ ] syncSettings gibt Cache zurück bei Offline
- [ ] updateSetting wirft Error bei ungültigen Daten

### Abhängigkeiten:
- Mock für: FirebaseFirestore
```

---

### SHARED Agent

Erstelle Test-Prompts für:
1. **Design System** - Colors, Typography, Spacing
2. **Utils** - Shared Hilfsfunktionen
3. **Models** - Gemeinsame Datenmodelle

**Beispiel für Shared:**
```markdown
## KidsColors

**Datei:** `lib/src/theme/colors.dart`
**Beschreibung:** Definiert App-Farbpalette

### Klassen:
1. `KidsColors`
   - `primary` - Hauptfarbe
   - `fromAge()` - Altersbasierte Farbanpassung

### Szenarien:
- [ ] Alle Farben sind gültige Color-Objekte
- [ ] fromAge(4) gibt kindgerechte Palette
- [ ] fromAge(12) gibt reifere Palette

### Abhängigkeiten: Keine
```

---

## Ausgabe-Format

Jeder Agent soll eine Datei erstellen:

```
ALANKO:      /Kids-AI-Train-Alanko/TEST_PROMPTS.md
PARENTSDASH: /Kids-AI-Train-Parent/TEST_PROMPTS.md
SHARED:      /Kids-AI-Shared/TEST_PROMPTS.md
```

---

## Zusammenfassung

1. **Analysiere** alle Dateien in `lib/models/` und `lib/services/`
2. **Erstelle** Test-Prompts im oben beschriebenen Format
3. **Speichere** in `TEST_PROMPTS.md` im Root des Repos
4. **Melde** wenn fertig

Der Lianko-Agent wird dann alle Test-Prompts sammeln und die Unit Tests generieren.

---

## Beispiel: Vollständige TEST_PROMPTS.md

```markdown
# Test Prompts für [APP-NAME]

## 1. Models

### 1.1 UserModel
**Datei:** `lib/models/user_model.dart`
...

### 1.2 SettingsModel
**Datei:** `lib/models/settings_model.dart`
...

## 2. Services

### 2.1 AuthService
**Datei:** `lib/services/auth_service.dart`
...

## 3. Utils

### 3.1 DateUtils
**Datei:** `lib/utils/date_utils.dart`
...
```
