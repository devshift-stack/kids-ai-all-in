# Therapy Web UI

**Web UI für Therapy AI**  
Detaillierte Einstellungen, Multi-Language Management, Phonem-Einstellungen und Avatar-Upload

---

## 🎯 Features

### 🌐 Sprach-Einstellungen
- Multi-Language Support
- Primärsprache setzen
- Sekundärsprachen aktivieren
- Dialekt-Einstellungen (Bosnisch, Kroatisch, Serbisch)

### 🔤 Phonem-Einstellungen
- Problem-Phoneme markieren
- Phonem-Prioritäten setzen
- Phonem-spezifische Übungen aktivieren

### 🎭 Avatar-Konfiguration
- 6-10 Bilder hochladen
- Avatar generieren
- Avatar testen und anpassen

### ⚙️ Erweiterte Therapie-Einstellungen
- Hörverlust-Profil (Audiogramm)
- Übungs-Konfiguration
- AI-Anpassungen

---

## 🚀 Setup

```bash
cd apps/therapy-web
flutter pub get
flutter run -d chrome
```

---

## 📁 Struktur

```
lib/
├── core/
│   ├── theme/          # Web Theme
│   ├── config/         # Konfiguration
│   └── routes/          # Navigation
├── models/             # Datenmodelle
├── screens/
│   ├── settings/       # Einstellungen
│   ├── avatar/         # Avatar-Upload
│   ├── language/       # Sprach-Einstellungen
│   └── phoneme/        # Phonem-Einstellungen
├── services/           # Business Logic
├── widgets/            # UI-Komponenten
└── providers/          # State Management
```

---

## 🌐 Web-spezifische Features

- Responsive Design
- Drag & Drop für Datei-Upload
- Multi-Tab Support
- Browser-basierte Authentifizierung

---

**Status:** 🚧 In Entwicklung

