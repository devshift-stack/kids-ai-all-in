# Therapy Parent Dashboard

**Parent Dashboard App für Therapy AI**  
Verwaltung und Monitoring für Eltern/Therapeuten

---

## 🎯 Features

### 📊 Dashboard & Monitoring
- Fortschritts-Übersicht
- Detaillierte Statistiken
- Übungs-Historie
- Erfolgs-Rate Tracking

### 👨‍👩‍👧 Kind-Profile
- Mehrere Kinder verwalten
- Profile hinzufügen/löschen
- Detaillierte Profile-Ansicht

### ⚙️ Einstellungen
- Therapie-Einstellungen anpassen
- Voice-Cloning verwalten
- Benachrichtigungen konfigurieren

### 📤 Export & Berichte
- PDF-Reports generieren
- CSV-Export für Analysen
- Daten für Therapeuten exportieren

---

## 🚀 Setup

```bash
cd apps/therapy-parent
flutter pub get
flutter run
```

---

## 📁 Struktur

```
lib/
├── core/
│   ├── theme/          # App Theme
│   ├── config/         # Konfiguration
│   └── routes/         # Navigation
├── models/             # Datenmodelle
├── screens/
│   ├── dashboard/      # Dashboard Screens
│   ├── children/       # Kind-Profile Screens
│   ├── settings/       # Einstellungen
│   └── export/         # Export Screens
├── services/           # Business Logic
├── widgets/            # UI-Komponenten
└── providers/          # State Management
```

---

## 🔗 Integration

- **Firebase:** Für Daten-Synchronisation
- **Shared Package:** Gemeinsame Komponenten
- **Therapy AI App:** Daten-Quelle

---

**Status:** 🚧 In Entwicklung

