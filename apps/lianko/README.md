# Lianko AI

**Sprachtraining-App für schwerhörige Kinder mit Hörgeräten (3-12 Jahre)**

## Zielgruppe

Kinder mit Hörgeräten, die:
- Sprechen lernen
- Ihre Aussprache verbessern
- Mit visueller Unterstützung hören und nachsprechen

## Features

### 1. Optimierte Sprachausgabe
- **Langsamere Sprechgeschwindigkeit** (altersabhängig)
- **Deutliche Aussprache** für Hörgeräteträger
- **Volle Lautstärke** für bessere Hörbarkeit

### 2. Synchrone Untertitel
- Wort wird **hervorgehoben während es gesprochen wird**
- Große, gut lesbare Schrift
- Farbcodiert nach Aktivität (Hören/Sprechen)

### 3. Nachsprech-Übungen
- Lianko spricht vor → Kind spricht nach
- **Spracherkennung** wertet Aussprache aus
- Ähnlichkeitsvergleich (toleriert kleine Fehler)

### 4. Positives Feedback
- Ermutigendes Feedback auch bei Fehlern
- "Nochmal"-Option zum Wiederholen
- "Nur hören"-Option zum nochmaligen Anhören

### 5. Altersanpassung
| Alter | Sprechgeschwindigkeit | Hörzeit |
|-------|----------------------|---------|
| 3-4   | Sehr langsam (0.3)   | 8 Sek   |
| 5-6   | Langsam (0.35)       | 8 Sek   |
| 7-8   | Moderat (0.4)        | 5 Sek   |
| 9-10  | Leicht langsam (0.45)| 5 Sek   |
| 11-12 | Normal-langsam (0.5) | 5 Sek   |

## Technische Struktur

```
lib/
├── services/
│   └── speech_training_service.dart  ← Kern-Service
├── widgets/
│   └── speech_training/
│       ├── sync_subtitle.dart        ← Untertitel mit Wort-Highlight
│       └── speech_exercise.dart      ← Übungs-Komponente
├── screens/
│   └── games/                        ← Lernspiele
└── main.dart
```

## Unterschied zu Alanko

| Feature | Alanko (normal hörend) | Lianko (schwerhörig) |
|---------|------------------------|----------------------|
| Sprechgeschwindigkeit | Normal | Langsamer |
| Untertitel | Optional | Immer sichtbar + synchron |
| Fokus | Spielen & Lernen | **Sprechen lernen** |
| Aufnahme | Keine | Kind spricht nach |
| Feedback | Audio | Audio + visuell groß |

## Getting Started

```bash
flutter pub get
flutter run
```

## Part of Kids-AI-Train

- [Kids-AI-Shared](https://github.com/devshift-stack/Kids-AI-Shared) - Shared components
- [Kids-AI-Train-Alanko](https://github.com/devshift-stack/Kids-AI-Train-Alanko) - Alanko App (normal hörend)
- [Kids-AI-Train-Parent](https://github.com/devshift-stack/Kids-AI-Train-Parent) - Parent Dashboard

## Sprachen

- Bosnisch (bs)
- Englisch (en)
- Deutsch (de)
- Kroatisch (hr)
- Serbisch (sr)
- Türkisch (tr)
