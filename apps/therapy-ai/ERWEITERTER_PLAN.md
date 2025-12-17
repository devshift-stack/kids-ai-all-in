# 📋 Erweiterter Plan - Therapy AI

Übersicht aller Features inklusive Parent Dashboard, Web UI und Avatar-System.

---

## 🎯 Komplette Feature-Liste

### ✅ Basis-App (Therapy AI)
1. ✅ App-Struktur & Setup
2. ✅ Datenmodelle
3. ✅ Design-System
4. ✅ UI-Komponenten
5. ⏳ Whisper Integration
6. ⏸️ ElevenLabs Integration
7. ⏸️ Adaptive Exercise Service
8. ⏸️ Audio Analysis Service
9. ⏸️ Setup Screens
10. ⏸️ Therapy Screens
11. ⏸️ Progress Tracking
12. ⏸️ Firebase Integration
13. ⏸️ Testing & Optimization

### 🆕 Erweiterte Features
14. ⏸️ **Parent Dashboard App**
15. ⏸️ **Web UI** (Detaillierte Einstellungen)
16. ⏸️ **Avatar-System** (Bild-Upload & Animationen)

---

## 📱 Parent Dashboard App

### Struktur
```
apps/therapy-parent/
├── lib/
│   ├── screens/
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   ├── progress_overview_screen.dart
│   │   │   └── analytics_screen.dart
│   │   ├── children/
│   │   │   ├── child_list_screen.dart
│   │   │   ├── child_detail_screen.dart
│   │   │   └── add_child_screen.dart
│   │   ├── settings/
│   │   │   ├── therapy_settings_screen.dart
│   │   │   ├── voice_management_screen.dart
│   │   │   └── notifications_screen.dart
│   │   └── export/
│   │       └── export_screen.dart
│   ├── services/
│   │   ├── parent_dashboard_service.dart
│   │   ├── progress_aggregation_service.dart
│   │   └── export_service.dart
│   └── widgets/
│       ├── progress_charts/
│       ├── child_cards/
│       └── analytics_widgets/
```

### Features
- Fortschritts-Dashboard
- Kind-Profile verwalten
- Detaillierte Analysen
- Export (PDF, CSV)
- Benachrichtigungen
- Voice-Cloning verwalten

---

## 🌐 Web UI

### Struktur
```
apps/therapy-web/ (oder web/ Verzeichnis)
├── lib/
│   ├── screens/
│   │   ├── settings/
│   │   │   ├── language_settings_screen.dart
│   │   │   ├── phoneme_settings_screen.dart
│   │   │   └── therapy_config_screen.dart
│   │   ├── avatar/
│   │   │   ├── avatar_upload_screen.dart
│   │   │   ├── avatar_config_screen.dart
│   │   │   └── avatar_test_screen.dart
│   │   └── admin/
│   │       └── advanced_settings_screen.dart
```

### Features
- Multi-Language Management
- Phonem-Einstellungen
- Avatar-Upload & Konfiguration
- Erweiterte Therapie-Einstellungen
- Hörverlust-Profil (detailliert)

---

## 🎭 Avatar-System

### Workflow
1. **Bild-Upload** (6-10 Bilder)
   - Verschiedene Posen/Winkel
   - Qualitäts-Prüfung
   - Upload zu Firebase Storage

2. **Avatar-Generierung**
   - Ready Player Me API oder Custom
   - 3D-Modell erstellen
   - Texturen generieren

3. **Animationen**
   - Lip-Sync für Sprache
   - Emotionen (Freude, Ermutigung)
   - Körper-Bewegungen

4. **Integration**
   - Avatar in Therapy-App
   - Reaktive Animationen
   - Feedback-Animationen

---

## 📊 Prioritäten

### MVP (Minimum Viable Product)
1. ✅ Basis-App mit Whisper
2. ⏸️ Parent Dashboard - Basis
3. ⏸️ Avatar - Basis (Upload & Anzeige)

### Phase 2
4. ⏸️ Web UI - Sprach-Einstellungen
5. ⏸️ Avatar - Animationen
6. ⏸️ Parent Dashboard - Export

### Phase 3
7. ⏸️ Web UI - Vollständig
8. ⏸️ Avatar - Erweiterte Features
9. ⏸️ Alle Integrationen

---

## 🔗 Dokumentation

- **Erweiterte Features:** `ERWEITERTE_FEATURES.md`
- **Avatar-System:** `AVATAR_SYSTEM.md`
- **Projekt Status:** `PROJEKT_STATUS.md` (aktualisiert)

---

**Status:** 📋 Plan erweitert  
**Nächster Schritt:** Parent Dashboard App-Struktur erstellen

