# Therapy AI - AI-Powered Speech Therapy App

**Status:** 🚧 In Entwicklung (60% abgeschlossen)  
**Repository:** devshift-stack/Li-KI-Trainig

---

## 📋 Schnellzugriff

- **[📊 Projekt Status & Fortschritt](PROJEKT_STATUS.md)** - Detaillierte Übersicht
- **[✅ TODO Übersicht](TODO_ÜBERSICHT.md)** - Alle Aufgaben im Überblick
- **[🎨 Design Feedback](DESIGN_FEEDBACK.md)** - UI/UX Optimierungen
- **[📱 Präsentation](PRESENTACIJA.md)** - Projekt-Präsentation (Bosnisch)

---

## 🎯 Aktueller Status

```
████████████░░░░░░░░░░ 60% Abgeschlossen
```

### ✅ Abgeschlossen
- App-Struktur & Setup
- Datenmodelle (ChildProfile, Exercise, etc.)
- Design-System für 4-jährige Kinder
- UI-Komponenten (5 Widgets)
- Dokumentation

### 🚧 In Arbeit
- Whisper Integration für Speech Recognition

### 📋 Ausstehend
- ElevenLabs Voice Cloning
- Adaptive Exercise Service
- Audio Analysis Service
- Setup & Therapy Screens
- Progress Tracking
- Firebase Integration
- Testing & Optimization

---

## 🚀 Nächste Schritte

1. **Whisper Integration** abschließen
2. **ElevenLabs Integration** starten
3. **Adaptive Service** implementieren

---

## 📁 Projekt-Struktur

```
apps/therapy-ai/
├── lib/
│   ├── core/
│   │   ├── design_system.dart      ✅ Design-System
│   │   ├── theme/app_theme.dart     ✅ App Theme
│   │   └── constants/               ✅ Constants
│   ├── models/                      ✅ Alle Models
│   ├── widgets/                     ✅ 5 UI-Komponenten
│   ├── services/                    ⏳ In Arbeit
│   └── screens/                     ⏸️ Ausstehend
├── PROJEKT_STATUS.md                📊 Detaillierter Status
├── TODO_ÜBERSICHT.md                ✅ TODO-Liste
└── DESIGN_FEEDBACK.md               🎨 Design-Dokumentation
```

---

## 🛠️ Technologie-Stack

- **Framework:** Flutter
- **Speech Recognition:** OpenAI Whisper (on-device)
- **Voice Cloning:** ElevenLabs API
- **Backend:** Firebase (Firestore)
- **State Management:** Riverpod
- **Charts:** fl_chart

---

## 📖 Dokumentation

Alle wichtigen Dokumente findest du in diesem Verzeichnis:
- `PROJEKT_STATUS.md` - Vollständiger Projekt-Status
- `TODO_ÜBERSICHT.md` - Alle TODOs im Überblick
- `DESIGN_FEEDBACK.md` - UI/UX Design-Feedback
- `PRESENTACIJA.md` - Projekt-Präsentation

---

**Letzte Aktualisierung:** Automatisch generiert

