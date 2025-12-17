# Anleitung für Parent Dashboard Agent

## Lianko Einstellungen im Parent Dashboard

**Letzte Aktualisierung:** 2025-12-16

---

## Übersicht

Das Parent Dashboard steuert folgende Lianko-Einstellungen für jedes Kind:

### Basis-Einstellungen

| Einstellung | Typ | Default | Beschreibung |
|-------------|-----|---------|--------------|
| `subtitlesEnabled` | bool | `false` | Untertitel an/aus |
| `language` | string | `"bs"` | Sprache (bs, en, de, hr, sr, tr) |
| `speechRate` | double | `0.4` | Sprechgeschwindigkeit (0.3-0.6) |
| `autoRepeat` | bool | `true` | Bei Fehler automatisch wiederholen |
| `maxAttempts` | int | `3` | Max. Versuche pro Wort |

### Zeig-Sprech-Modul Einstellungen (NEU)

| Einstellung | Typ | Default | Beschreibung |
|-------------|-----|---------|--------------|
| `zeigSprechEnabled` | bool | `false` | Zeig-Sprech-Modul aktiviert |
| `useChildRecordings` | bool | `true` | Kind-Aufnahmen nutzen statt TTS |
| `allowReRecording` | bool | `false` | Kind darf Aufnahmen neu aufnehmen |

### Eltern-Aufnahme Einstellungen

| Einstellung | Typ | Default | Beschreibung |
|-------------|-----|---------|--------------|
| `parentRecordingEnabled` | bool | `false` | Eltern-Aufnahme aktiviert |
| `parentRecordingUrl` | string | `null` | URL zur Eltern-Aufnahme (Firebase Storage) |

---

## Feature: Zeig-Sprech-Modul (NEU)

### Was ist das?

Ein AAC-ähnliches Kommunikationsmodul für Kinder, die sich verbal noch nicht ausdrücken können. Das Kind tippt auf Bilder um zu kommunizieren.

### Kategorien im Zeig-Sprech-Modul

| Kategorie | Symbole | Push an Eltern |
|-----------|---------|----------------|
| Schmerzen | Kopf, Bauch, Hals, Ohr, Zahn, Bein, Arm | ✅ JA |
| Essen | Frühstück, Mittagessen, Snack, Abendessen | ❌ |
| Trinken | Wasser, Saft, Milch, Kakao, Tee | ❌ |
| Gefühle | Glücklich, Traurig, Wütend, Müde, Ängstlich | ❌ |
| Aktivitäten | Spielen, Fernsehen, Draußen, Schlafen, Kuscheln | ❌ |
| Toilette | Toilette, Hände waschen, Baden, Zähne putzen | ❌ |
| Hilfe | Hilfe brauchen, Nicht verstanden, Nochmal zeigen | ✅ JA |
| Ja/Nein | Ja, Nein, Vielleicht | ❌ |
| Menschen | Mama, Papa, Oma, Opa, Geschwister | ✅ JA |
| Orte | Nach Hause, Rausgehen, Spielplatz, Arzt | ❌ |

### Eltern-Kontrollen für Zeig-Sprech

```
┌─────────────────────────────────────────────────────────────┐
│  PARENT DASHBOARD - Kind: Lian                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  Zeig-Sprech-Modul                                          │
│  ─────────────────                                          │
│                                                              │
│  Modul aktivieren:     [ ] Aus  [x] An                      │
│                                                              │
│  ─────────────────────────────────────────────────────────  │
│                                                              │
│  Aufnahmen                                                   │
│                                                              │
│  Kind-Stimme nutzen:   [ ] Aus  [x] An                      │
│  (Wenn An: Kind hört eigene Aufnahmen)                      │
│  (Wenn Aus: App-Stimme/TTS wird genutzt)                    │
│                                                              │
│  Neu aufnehmen erlauben: [ ] Aus  [x] An                    │
│  (Kind kann Wörter selbst neu aufnehmen)                    │
│                                                              │
│  ─────────────────────────────────────────────────────────  │
│                                                              │
│  Push-Benachrichtigungen                                    │
│                                                              │
│  Bei "Schmerzen":      [x] An                               │
│  Bei "Hilfe":          [x] An                               │
│  Bei "Menschen rufen": [x] An                               │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Feature: Kind-Aufnahmen

### Wie funktioniert es?

1. Kind öffnet Zeig-Sprech-Modul zum ersten Mal
2. Setup-Prompt erscheint: "Deine Stimme aufnehmen?"
3. Kind kann "Aufnehmen" oder "Später" wählen
4. Bei Aufnahme: Kind spricht jedes Wort, App speichert
5. Danach hört Kind seine EIGENE Stimme beim Tippen

### Eltern-Kontrolle

- **`useChildRecordings = true`**: Kind hört eigene Stimme
- **`useChildRecordings = false`**: Kind hört App-Stimme (TTS)
- **`allowReRecording = true`**: Kind kann selbst neu aufnehmen
- **`allowReRecording = false`**: Nur Eltern können Aufnahmen ändern

---

## Feature: Rätsel-Spiel

### Was ist das?

Quiz-Spiel basierend auf den Zeig-Sprech-Symbolen:
- 3-4 Bilder werden angezeigt
- Ein Wort wird abgespielt (Kind-Aufnahme oder TTS)
- Kind tippt auf das richtige Bild

### Wichtig für Parent Dashboard

Das Rätsel-Spiel nutzt automatisch:
- Kind-Aufnahmen (wenn `useChildRecordings = true`)
- TTS Fallback (wenn keine Aufnahme vorhanden)

---

## Feature: Eltern-Aufnahme (Optional)

### Was ist das?

Eltern können **eigene Sprachaufnahmen** erstellen, die statt der TTS-Stimme abgespielt werden. Das Kind hört dann die vertraute Stimme der Eltern.

### Ablauf im Parent Dashboard

```
┌─────────────────────────────────────────────────────────────┐
│  PARENT DASHBOARD - Kind: Lian                              │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  🎤 Eltern-Aufnahme                                         │
│                                                              │
│  [ ] Aus  [x] An                                            │
│                                                              │
│  Wortliste für Aufnahme:                                    │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Hund     [🎤 Aufnehmen] [▶ Abspielen] [✓ Fertig]   │   │
│  │ Katze    [🎤 Aufnehmen] [▶ Abspielen] [ ]          │   │
│  │ Maus     [🎤 Aufnehmen] [ ]           [ ]          │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                              │
│  Fortschritt: 1/4 Wörter aufgenommen                        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Technische Umsetzung für Parent Agent

### 1. Datenstruktur in Firebase

```
/users/{parentId}/children/{childId}/liankoSettings/
├── subtitlesEnabled: false
├── language: "de"
├── speechRate: 0.4
├── autoRepeat: true
├── maxAttempts: 3
├── zeigSprechEnabled: true
├── useChildRecordings: true
├── allowReRecording: false
├── parentRecordingEnabled: false
└── parentRecordings/
    ├── hund: "gs://bucket/recordings/hund_123.mp3"
    └── ...
```

### 2. API Endpunkte

```dart
// Einstellungen speichern
Future<void> saveLiankoSettings(String childId, Map<String, dynamic> settings);

// Einstellung einzeln ändern
Future<void> updateLiankoSetting(String childId, String key, dynamic value);

// Aufnahme hochladen (Eltern)
Future<String> uploadParentRecording(String childId, String word, File audioFile);

// Aufnahme löschen
Future<void> deleteParentRecording(String childId, String word);

// Alle Einstellungen laden
Future<LiankoSettings> getLiankoSettings(String childId);
```

### 3. UI-Komponenten für Parent Dashboard

#### 3.1 Lianko-Einstellungs-Screen

```dart
class LiankoSettingsScreen extends ConsumerWidget {
  final String childId;

  // Sections:
  // 1. Basis-Einstellungen (Sprache, Untertitel, Geschwindigkeit)
  // 2. Zeig-Sprech-Modul (Toggle, useChildRecordings, allowReRecording)
  // 3. Eltern-Aufnahme (Toggle, Aufnahme-Liste)
  // 4. Push-Benachrichtigungen
}
```

#### 3.2 Zeig-Sprech-Einstellungen Widget

```dart
class ZeigSprechSettingsWidget extends StatelessWidget {
  // - Toggle: Modul aktivieren
  // - Toggle: Kind-Stimme nutzen
  // - Toggle: Neu aufnehmen erlauben
  // - Info: Anzahl aufgenommene Wörter (readonly, von Lianko App)
}
```

#### 3.3 Aufnahme-Widget (für Eltern-Aufnahmen)

```dart
class ParentRecordingWidget extends StatefulWidget {
  final String word;
  final String? existingRecordingUrl;
  final Function(File) onRecorded;

  // [🎤] Button → Aufnahme starten
  // [⏹️] Button → Aufnahme stoppen
  // [▶️] Button → Abspielen
  // [🗑️] Button → Löschen
}
```

### 4. Synchronisation

```
┌─────────────────┐                    ┌─────────────────┐
│ Parent Dashboard │                    │   Lianko App    │
│                  │                    │                  │
│  Einstellungen   │───── Firebase ────►│  Lädt Settings  │
│  speichern       │      Firestore     │  beim Start     │
│                  │                    │                  │
│  Kind wählt      │◄──── Firebase ─────│  Symbol getippt │
│  "Schmerzen"     │      (Push)        │  → Push senden  │
└─────────────────┘                    └─────────────────┘
```

---

## Wortlisten (Kategorien)

### Zeig-Sprech Kategorien

```yaml
schmerzen:
  - Kopf tut weh
  - Bauch tut weh
  - Hals tut weh
  - Ohr tut weh
  - Zahn tut weh
  - Bein tut weh
  - Arm tut weh

essen:
  - Frühstück (→ Müsli, Brot, Ei)
  - Mittagessen
  - Snack (→ Obst, Kekse, Süßigkeiten)
  - Abendessen

trinken:
  - Wasser
  - Saft
  - Milch
  - Kakao
  - Tee

gefuehle:
  - Glücklich
  - Traurig
  - Wütend
  - Müde
  - Ängstlich
  - Langweilig

aktivitaeten:
  - Spielen
  - Fernsehen
  - Draußen
  - Schlafen
  - Kuscheln
  - Vorlesen

toilette:
  - Toilette
  - Hände waschen
  - Baden
  - Zähne putzen

hilfe:
  - Ich brauche Hilfe
  - Ich verstehe nicht
  - Nochmal zeigen

janein:
  - Ja
  - Nein
  - Vielleicht

menschen:
  - Mama
  - Papa
  - Oma
  - Opa
  - Geschwister

orte:
  - Nach Hause
  - Rausgehen
  - Spielplatz
  - Arzt
```

---

## Zusammenfassung für Parent Agent

**Du musst implementieren:**

### Pflicht:
1. ✅ UI für Basis-Einstellungen (Sprache, Untertitel, Geschwindigkeit)
2. ✅ Toggle für Zeig-Sprech-Modul aktivieren (`zeigSprechEnabled`)
3. ✅ Toggle für Kind-Stimme nutzen (`useChildRecordings`)
4. ✅ Toggle für Neu aufnehmen erlauben (`allowReRecording`)
5. ✅ Sync der Settings zu Firestore

### Optional:
6. ⭕ Eltern-Aufnahme Feature (Toggle, Aufnahme-Widget, Upload)
7. ⭕ Push-Benachrichtigungen konfigurieren
8. ⭕ Statistik: Wie viele Wörter hat Kind aufgenommen

---

## Code-Referenz

Die Lianko-App erwartet diese Settings-Struktur:

```dart
class ChildSettings {
  final bool subtitlesEnabled;      // default: false
  final String language;            // default: "bs"
  final double speechRate;          // default: 0.4
  final bool autoRepeat;            // default: true
  final int maxAttempts;            // default: 3
  final bool zeigSprechEnabled;     // default: false
  final bool useChildRecordings;    // default: true
  final bool allowReRecording;      // default: false
}
```

Siehe: `Kids-AI-Train-Lianko/lib/services/child_settings_service.dart`
