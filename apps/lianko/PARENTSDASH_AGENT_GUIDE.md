# ParentsDash Agent Guide - Lianko Features

## Übersicht

Dieses Dokument beschreibt alle neuen Lianko-Features, die im ParentsDash implementiert werden müssen.

Lianko = App für Kinder mit Hörbeeinträchtigung (Hörgeräte, Sprachtraining)

---

## 1. Hörgeräte-Monitoring

### Was Lianko macht:
- Vor YouTube/Videos: Kamera prüft ob Kind Hörgeräte trägt
- Ergebnis wird in Firestore geloggt
- Bei "nicht getragen" → Push an Eltern (wenn aktiviert)

### Firestore-Struktur:

```
/children/{childId}/hearingAidLogs/
  {logId}:
    wasWearing: true/false
    context: "Video/YouTube Zugriff"
    timestamp: Timestamp
```

### ParentsDash muss bauen:

#### A) Statistik-Anzeige
```
┌─────────────────────────────────────────────────────────────────┐
│  🦻 Hörgeräte-Statistik                                         │
│                                                                 │
│  Heute:     ████████░░ 80% getragen (8/10 Checks)              │
│  Diese Woche: ███████░░░ 72% getragen                          │
│                                                                 │
│  Letzte Checks:                                                 │
│  ✅ 14:32 - Video geschaut (getragen)                          │
│  ✅ 12:15 - YouTube (getragen)                                  │
│  ❌ 10:45 - YouTube-Versuch (NICHT getragen)                   │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

#### B) Einstellungen
```dart
// In LiankoSettings (bereits in Lianko vorhanden)
bool hearingAidCheckEnabled;        // Check vor Videos aktivieren
bool requireBothEars;               // Beide Ohren müssen Hörgeräte haben
bool notifyParentOnNoHearingAid;    // Push wenn nicht getragen
```

#### UI im ParentsDash:
```
┌─────────────────────────────────────────────────────────────────┐
│  Hörgeräte-Einstellungen                                        │
│                                                                 │
│  [✓] Hörgeräte-Check vor Videos aktivieren                     │
│  [ ] Beide Ohren erforderlich                                   │
│  [✓] Benachrichtigung wenn nicht getragen                      │
└─────────────────────────────────────────────────────────────────┘
```

---

## 2. Eltern-Benachrichtigungen

### Firestore-Struktur:

```
/children/{childId}/parentNotifications/
  {notificationId}:
    id: "1702834567890"
    type: "hearingAidNotWorn" | "learningDifficulty" | "dailyReport" | "achievementUnlocked"
    title: "🦻 Hörgeräte-Erinnerung"
    body: "Dein Kind wollte YouTube starten, trägt aber keine Hörgeräte."
    data: { activity: "YouTube", attemptCount: 1 }
    timestamp: Timestamp
    isRead: false
```

### Notification Types:

| Type | Wann | Beispiel |
|------|------|----------|
| `hearingAidNotWorn` | Kind ohne Hörgeräte bei Video | "Dein Kind trägt keine Hörgeräte" |
| `learningDifficulty` | 3+ Fehler bei Wörtern | "Schwierigkeiten bei: Schule, Fisch" |
| `dailyReport` | Täglich (wenn aktiviert) | "Heute: 80% Hörgeräte, keine Probleme" |
| `achievementUnlocked` | Meilenstein erreicht | "10 Wörter perfekt gelernt!" |

### ParentsDash muss bauen:

#### A) Notification-Liste
```
┌─────────────────────────────────────────────────────────────────┐
│  🔔 Benachrichtigungen                                          │
│                                                                 │
│  Heute                                                          │
│  ├─ 🦻 14:32 - Hörgeräte-Erinnerung                            │
│  │     "Dein Kind wollte YouTube ohne Hörgeräte..."            │
│  │                                                              │
│  ├─ 📚 12:15 - Lern-Hinweis                                    │
│  │     "Schwierigkeiten bei: Schule, Fisch, Tasche"            │
│  │                                                              │
│  Gestern                                                        │
│  ├─ 📊 20:00 - Tagesbericht                                    │
│       "Hörgeräte 85%, keine Schwierigkeiten"                   │
└─────────────────────────────────────────────────────────────────┘
```

#### B) Einstellungen
```
┌─────────────────────────────────────────────────────────────────┐
│  Benachrichtigungs-Einstellungen                                │
│                                                                 │
│  [✓] Push bei fehlenden Hörgeräten                             │
│  [✓] Push bei Lern-Schwierigkeiten                             │
│  [ ] Tägliche Zusammenfassung (20:00 Uhr)                      │
└─────────────────────────────────────────────────────────────────┘
```

### Firestore-Update für Einstellungen:

```dart
// Pfad: /children/{childId}
// Feld: liankoSettings

{
  "liankoSettings": {
    // ... bestehende Felder ...
    "notifyParentOnNoHearingAid": true,
    "notifyParentOnDifficulty": true,
    "dailySummaryEnabled": false
  }
}
```

---

## 3. AI Audiogramm Reader (NEU - WICHTIG!)

### Konzept:
1. Eltern fotografieren Audiogramm vom HNO-Arzt
2. Gemini AI analysiert das Bild und extrahiert dB-Werte
3. Eltern bestätigen/korrigieren die Werte
4. Lianko passt sich automatisch an (Sprechgeschwindigkeit, Pitch, etc.)

### Firestore-Struktur:

```
/children/{childId}/audiogram/
  current:
    leftEar: { "250": 40, "500": 45, "1000": 50, "2000": 60, "4000": 75, "8000": 85 }
    rightEar: { "250": 35, "500": 40, "1000": 45, "2000": 55, "4000": 70, "8000": 80 }
    measuredAt: Timestamp
    geminiConfidence: 0.85
    notes: "Hochton-Abfall erkennbar"
    confirmedByParent: true
```

### ParentsDash muss bauen:

#### A) AI Audiogramm Reader - Upload Screen
```
┌─────────────────────────────────────────────────────────────────┐
│  📊 Audiogramm hochladen                                        │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │                                                         │   │
│  │              [Foto vom Audiogramm]                      │   │
│  │                   📷 oder 📁                            │   │
│  │                                                         │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  [📷 Foto aufnehmen]        [📁 Aus Galerie wählen]            │
│                                                                 │
│  ───────────── ODER ─────────────                              │
│                                                                 │
│  [✏️ Werte manuell eingeben]                                   │
└─────────────────────────────────────────────────────────────────┘
```

#### B) Gemini-Analyse + Bestätigung
```
┌─────────────────────────────────────────────────────────────────┐
│  🤖 KI-Analyse abgeschlossen                                    │
│                                                                 │
│  Erkannte Werte (bitte prüfen):                                 │
│                                                                 │
│         Linkes Ohr (O)         Rechtes Ohr (X)                 │
│  250 Hz:   [40] dB               [35] dB                       │
│  500 Hz:   [45] dB               [40] dB                       │
│  1000 Hz:  [50] dB               [45] dB                       │
│  2000 Hz:  [60] dB               [55] dB                       │
│  4000 Hz:  [75] dB               [70] dB                       │
│  8000 Hz:  [85] dB               [80] dB                       │
│                                                                 │
│  Konfidenz: 85% ████████░░                                     │
│                                                                 │
│  ⚠️ Bitte überprüfe die Werte anhand des Original-Audiogramms │
│                                                                 │
│  [✓ Werte bestätigen]        [✏️ Korrigieren]                  │
└─────────────────────────────────────────────────────────────────┘
```

#### C) Analyse-Ergebnis + Empfehlungen
```
┌─────────────────────────────────────────────────────────────────┐
│  📊 Audiogramm-Analyse                                          │
│                                                                 │
│  Durchschnittlicher Hörverlust: 59 dB                          │
│  Kategorie: Mittelgradig (WHO-Klassifikation)                  │
│  Hochton-Verlust: Ja                                            │
│                                                                 │
│  ─────────────────────────────────────────────                  │
│                                                                 │
│  💡 Empfohlene App-Einstellungen:                               │
│                                                                 │
│  Sprechgeschwindigkeit   [====○-----] 0.4                      │
│  Stimmhöhe               [===○------] 0.85                     │
│  Untertitel              [✓] Immer an                          │
│  Größere Animationen     [✓] Aktiviert                         │
│  Textgröße               [====○-----] 1.1x                     │
│                                                                 │
│  ⚠️ Dies sind Richtwerte. Besprich optimale Einstellungen     │
│     mit eurem Audiologen oder Logopäden.                       │
│                                                                 │
│  [Empfehlungen übernehmen]  [Manuell anpassen]                 │
└─────────────────────────────────────────────────────────────────┘
```

### Gemini API Code (für ParentsDash):

```dart
import 'package:google_generative_ai/google_generative_ai.dart';

class AudiogramAnalyzerService {
  final GenerativeModel _model;

  AudiogramAnalyzerService(String apiKey)
    : _model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: apiKey,
      );

  Future<Map<String, dynamic>?> analyzeAudiogram(Uint8List imageBytes) async {
    final prompt = '''
Analysiere dieses Audiogramm-Bild.

Extrahiere die Hörschwellenwerte (in dB) für beide Ohren bei diesen Frequenzen:
- 250 Hz
- 500 Hz
- 1000 Hz
- 2000 Hz
- 4000 Hz
- 8000 Hz

Linkes Ohr ist meist mit O markiert, rechtes Ohr mit X.
Die Y-Achse zeigt dB (0 oben = gut, 120 unten = taub).

Antworte NUR im JSON-Format:
{
  "leftEar": {"250": 40, "500": 45, "1000": 50, "2000": 60, "4000": 75, "8000": 85},
  "rightEar": {"250": 35, "500": 40, "1000": 45, "2000": 55, "4000": 70, "8000": 80},
  "confidence": 0.85,
  "notes": "Hochton-Abfall erkennbar"
}

Falls kein Audiogramm erkennbar: {"error": "Kein Audiogramm erkannt"}
''';

    try {
      final response = await _model.generateContent([
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);

      final jsonText = response.text;
      // JSON parsen und zurückgeben
      return jsonDecode(jsonText!);
    } catch (e) {
      print('Gemini Fehler: $e');
      return null;
    }
  }
}
```

### Manuelle Eingabe-UI:
```
┌─────────────────────────────────────────────────────────────────┐
│  ✏️ Audiogramm manuell eingeben                                 │
│                                                                 │
│  Trage die dB-Werte vom Audiogramm ein:                        │
│                                                                 │
│  Frequenz      Linkes Ohr    Rechtes Ohr                       │
│  ─────────────────────────────────────────                      │
│  250 Hz        [____] dB     [____] dB                         │
│  500 Hz        [____] dB     [____] dB                         │
│  1000 Hz       [____] dB     [____] dB                         │
│  2000 Hz       [____] dB     [____] dB                         │
│  4000 Hz       [____] dB     [____] dB                         │
│  8000 Hz       [____] dB     [____] dB                         │
│                                                                 │
│  💡 Tipp: Die Werte findest du auf dem Audiogramm              │
│     vom HNO-Arzt. 0 = perfekt, 120 = taub                      │
│                                                                 │
│  [Speichern]                                                    │
└─────────────────────────────────────────────────────────────────┘
```

---

## 4. Logopädie-Modus (Übungen zuweisen)

### Konzept:
- Eltern geben Empfehlungen vom Logopäden ein
- Kind sieht Übungen in Lianko
- Fortschritt wird getrackt

### Firestore-Struktur:

```
/children/{childId}/exercises/
  current:
    activeExercises: [
      {
        id: "exercise_1",
        sound: "s",
        displayEmoji: "🐍",
        words: ["Schlange", "Sonne", "Haus", "Maus", "Glas"],
        targetPerDay: 10,
        completedToday: 0,
        enabled: true,
        difficulty: "easy" | "medium" | "hard"
      },
      {
        id: "exercise_2",
        sound: "sch",
        displayEmoji: "🐠",
        words: ["Schule", "Fisch", "Tasche", "Dusche", "Tisch"],
        targetPerDay: 5,
        completedToday: 0,
        enabled: true,
        difficulty: "medium"
      }
    ],
    therapistNotes: "Fokus auf /s/ am Wortanfang. Bei /sch/ auf Lippenrundung achten.",
    lastUpdated: Timestamp

/children/{childId}/exerciseHistory/
  {date_YYYY-MM-DD}:
    exercises: [
      { sound: "s", completed: 8, target: 10, successRate: 0.75 },
      { sound: "sch", completed: 5, target: 5, successRate: 0.80 }
    ]
```

### ParentsDash muss bauen:

#### A) Übungs-Verwaltung
```
┌─────────────────────────────────────────────────────────────────┐
│  📋 Logopädie-Übungen                                           │
│                                                                 │
│  Aktive Übungen:                                                │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ [✓] 🐍 /s/ - Schlange, Sonne, Haus...                   │   │
│  │     Ziel: [10] pro Tag    Schwierigkeit: [Leicht ▾]     │   │
│  │     [Wörter bearbeiten]                    [🗑️ Löschen] │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ [✓] 🐠 /sch/ - Schule, Fisch, Tasche...                 │   │
│  │     Ziel: [5] pro Tag     Schwierigkeit: [Mittel ▾]     │   │
│  │     [Wörter bearbeiten]                    [🗑️ Löschen] │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  [+ Neue Übung hinzufügen]                                      │
│                                                                 │
│  ─────────────────────────────────────────────                  │
│                                                                 │
│  Notizen vom Logopäden:                                         │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Fokus auf /s/ am Wortanfang. Bei /sch/ auf              │   │
│  │ Lippenrundung achten.                                    │   │
│  └─────────────────────────────────────────────────────────┘   │
│  [Speichern]                                                    │
└─────────────────────────────────────────────────────────────────┘
```

#### B) Neue Übung hinzufügen
```
┌─────────────────────────────────────────────────────────────────┐
│  ➕ Neue Übung                                                   │
│                                                                 │
│  Laut/Sound:     [/s/        ▾]                                │
│                  /s/, /sch/, /r/, /l/, /ch/, /k/, /t/, /p/     │
│                                                                 │
│  Emoji:          [🐍]  [andere wählen]                          │
│                                                                 │
│  Übungswörter:                                                  │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │ Schlange                                            [x] │   │
│  │ Sonne                                               [x] │   │
│  │ Haus                                                [x] │   │
│  │ [+ Wort hinzufügen]                                     │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                 │
│  Ziel pro Tag:   [10] Wiederholungen                           │
│  Schwierigkeit:  [○ Leicht  ● Mittel  ○ Schwer]               │
│                                                                 │
│  [Abbrechen]                          [Übung speichern]        │
└─────────────────────────────────────────────────────────────────┘
```

#### C) Fortschritts-Anzeige
```
┌─────────────────────────────────────────────────────────────────┐
│  📈 Übungs-Fortschritt                                          │
│                                                                 │
│  Diese Woche:                                                   │
│                                                                 │
│  /s/   ████████░░ 80% (Erfolgsrate)                            │
│        Mo: 10/10 ✓  Di: 8/10  Mi: 10/10 ✓  Do: 7/10           │
│                                                                 │
│  /sch/ ██████░░░░ 60% (Erfolgsrate)                            │
│        Mo: 5/5 ✓   Di: 3/5   Mi: 4/5     Do: 5/5 ✓            │
│                                                                 │
│  Schwierige Wörter:                                             │
│  ⚠️ "Schlange" - 3x falsch diese Woche                         │
│  ⚠️ "Tasche" - 2x falsch                                       │
└─────────────────────────────────────────────────────────────────┘
```

### Vordefinierte Laute mit Wortvorschlägen:

```dart
const Map<String, List<String>> soundWordSuggestions = {
  's': ['Sonne', 'Schlange', 'Haus', 'Maus', 'Glas', 'Bus', 'Nase', 'Hase'],
  'sch': ['Schule', 'Fisch', 'Tasche', 'Dusche', 'Tisch', 'Schaf', 'Schuh'],
  'r': ['Roller', 'Birne', 'Tür', 'Uhr', 'Rad', 'Rose', 'Regen'],
  'l': ['Lampe', 'Löwe', 'Ball', 'Stuhl', 'Blume', 'Wolke', 'Spiegel'],
  'ch': ['Buch', 'Dach', 'Koch', 'Milch', 'Kirche', 'Kuchen'],
  'k': ['Katze', 'Kuh', 'Kuchen', 'Jacke', 'Decke', 'Paket'],
  'f': ['Fisch', 'Vogel', 'Telefon', 'Affe', 'Schaf', 'Brief'],
  'w': ['Wasser', 'Wolke', 'Wurst', 'Löwe', 'Schwein'],
};

const Map<String, String> soundEmojis = {
  's': '🐍',   // Schlange macht ssss
  'sch': '🐠', // Fisch
  'r': '🦁',   // Löwe brüllt
  'l': '🦁',   // Löwe
  'ch': '📖',  // Buch
  'k': '🐱',   // Katze
  'f': '🐦',   // Vogel
  'w': '💧',   // Wasser
};
```

---

## 5. Lern-Schwierigkeiten Tracking

### Firestore-Struktur (Lianko schreibt, ParentsDash liest):

```
/children/{childId}/learningDifficulties/
  {logId}:
    word: "Schlange"
    category: "s-Laut"
    attempts: 5
    succeeded: false
    timestamp: Timestamp
```

### ParentsDash muss bauen:

```
┌─────────────────────────────────────────────────────────────────┐
│  📚 Lern-Analyse                                                │
│                                                                 │
│  Schwierige Wörter diese Woche:                                 │
│                                                                 │
│  ⚠️ "Schlange" - 5 Versuche, nicht geschafft                   │
│  ⚠️ "Tasche" - 4 Versuche, dann geschafft                      │
│  ⚠️ "Fisch" - 3 Versuche, dann geschafft                       │
│                                                                 │
│  Empfehlung: Diese Wörter mehr üben!                           │
│                                                                 │
│  [Als Übung hinzufügen]                                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 6. Zusammenfassung: Firestore-Pfade

| Pfad | Wer schreibt | Wer liest |
|------|--------------|-----------|
| `/children/{id}/liankoSettings` | ParentsDash | Lianko |
| `/children/{id}/hearingAidLogs/*` | Lianko | ParentsDash |
| `/children/{id}/parentNotifications/*` | Lianko | ParentsDash |
| `/children/{id}/audiogram/current` | ParentsDash | Lianko |
| `/children/{id}/exercises/current` | ParentsDash | Lianko |
| `/children/{id}/exerciseHistory/*` | Lianko | ParentsDash |
| `/children/{id}/learningDifficulties/*` | Lianko | ParentsDash |

---

## 7. LiankoSettings - Vollständige Struktur

```dart
// Firestore: /children/{childId} -> liankoSettings

{
  "liankoSettings": {
    // Zeig-Sprech-Modul
    "zeigSprechEnabled": false,
    "useChildRecordings": true,
    "allowReRecording": false,

    // Sprache
    "speechRate": 0.4,
    "language": "bs",
    "autoRepeat": true,
    "maxAttempts": 3,

    // Eltern-Aufnahmen
    "parentRecordingEnabled": false,

    // Hörgeräte-Check
    "hearingAidCheckEnabled": true,
    "requireBothEars": false,

    // Eltern-Benachrichtigungen
    "notifyParentOnNoHearingAid": true,
    "notifyParentOnDifficulty": true,
    "dailySummaryEnabled": false
  }
}
```

---

## 8. Prioritäten für ParentsDash

### HOCH (Jetzt bauen):
1. ✅ Benachrichtigungs-Einstellungen (3 Toggles)
2. ✅ Hörgeräte-Statistik anzeigen
3. 🔨 Audiogramm-Upload + Gemini-Analyse
4. 🔨 Logopädie-Übungen zuweisen

### MITTEL (Als nächstes):
5. Notification-Liste (Push-Historie)
6. Lern-Schwierigkeiten Anzeige
7. Übungs-Fortschritt Grafiken

### NIEDRIG (Später):
8. PDF-Export für Ärzte
9. Batterie-Erinnerung Einstellung

---

## 9. Benötigte Pakete für ParentsDash

```yaml
dependencies:
  # Bereits vorhanden
  firebase_core:
  cloud_firestore:
  firebase_storage:  # Für Audiogramm-Bilder

  # NEU für Audiogramm
  google_generative_ai: ^0.4.6
  image_picker: ^1.0.7

  # Optional für Charts
  fl_chart: ^0.66.0
```

---

## 10. API Keys

Gemini API Key muss in ParentsDash konfiguriert werden:
- Gleicher Key wie in Lianko
- Speicherort: Environment Variable oder Firebase Remote Config
- NICHT im Code hardcoden!

---

Bei Fragen: Lianko-Codebase prüfen unter:
- `lib/models/audiogram/audiogram_model.dart` - Audiogramm-Datenmodell
- `lib/models/settings/child_settings_model.dart` - Kind-Einstellungen
- `lib/services/ai_audiogram_reader_service.dart` - **AI Audiogramm Reader (Gemini)**
- `lib/services/audiogram_adaptive_tts_service.dart` - TTS mit Audiogramm-Anpassung
- `lib/services/parent_notification_service.dart` - Eltern-Benachrichtigungen
- `lib/services/hearing_aid_detection_service.dart` - Hörgeräte-Erkennung

## Neue Dateien (AI Audiogramm Reader)

```
lib/
├── models/
│   └── audiogram/
│       └── audiogram_model.dart          # AudiogramData, EarAudiogram, Recommendations
├── services/
│   ├── ai_audiogram_reader_service.dart  # Gemini Vision Analyse
│   └── audiogram_adaptive_tts_service.dart # TTS passt sich an Audiogramm an
```

### Wichtige Klassen:

```dart
// AudiogramData - Speichert die Audiogramm-Werte
class AudiogramData {
  final EarAudiogram leftEar;
  final EarAudiogram rightEar;
  final DateTime measuredAt;
  final double? geminiConfidence;
  final bool confirmedByParent;

  HearingLossLevel get hearingLossLevel; // normal, mild, moderate, severe, profound
  bool get hasHighFrequencyLoss;
}

// AudiogramRecommendations - Berechnete Empfehlungen
class AudiogramRecommendations {
  final double speechRate;      // 0.3 - 0.5
  final double pitch;           // 0.7 - 1.0
  final bool subtitlesAlwaysOn;
  final bool enlargedAnimations;
  final double textScale;       // 1.0 - 1.3

  factory AudiogramRecommendations.fromAudiogram(AudiogramData audiogram);
}

// AIAudiogramReaderService - Gemini Vision Analyse
class AIAudiogramReaderService {
  Future<AudiogramReadResult> analyzeImage(Uint8List imageBytes);
}
```
