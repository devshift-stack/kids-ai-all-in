# TODOs und Platzhalter - Vollständiger Report

**Erstellt:** 2025-01-27  
**Repository:** kids-ai-all-in  
**Gesamtanzahl:** 53 Einträge

---

## 🔴 Sicherheitsprobleme behoben

### Hardcodierte API-Keys entfernt:

1. ✅ **apps/callcenter-ai/BACKEND_SETUP.md**
   - Hardcodierter API-Key entfernt
   - Ersetzt durch: `YOUR_SECRET_API_KEY` mit Warnung

2. ✅ **apps/callcenter-ai/backend/SETUP.md**
   - Hardcodierter API-Key entfernt
   - Ersetzt durch: `YOUR_SECRET_API_KEY` mit Warnung

---

## 📋 TODOs nach App kategorisiert

### apps/therapy-ai (15 TODOs)

**Kritische TODOs:**
- `lib/main.dart:145` - Firebase Service implementieren
- `lib/providers/services_providers.dart:51` - Firebase Service implementieren
- `lib/screens/settings/settings_screen.dart:244` - Notification Settings
- `lib/screens/settings/settings_screen.dart:253` - Dark Mode Toggle
- `lib/screens/settings/settings_screen.dart:262` - Help Screen

**Dokumentation:**
- `TODO_ÜBERSICHT.md` - Vollständige TODO-Liste
- `OFFENE_TODOS.md` - Detaillierte Auflistung

### apps/therapy-parent (12 TODOs)

**Settings Screen:**
- `lib/screens/settings/settings_screen.dart:21` - Navigate to Notifications Settings
- `lib/screens/settings/settings_screen.dart:29` - Navigate to Voice Management
- `lib/screens/settings/settings_screen.dart:37` - Navigate to Language Settings
- `lib/screens/settings/settings_screen.dart:46` - Show About Dialog

**Children Screens:**
- `lib/screens/children/child_list_screen.dart:12` - Lade Kinder aus Firebase
- `lib/screens/children/child_list_screen.dart:58` - Navigate to Add Child Screen
- `lib/screens/children/child_detail_screen.dart:15` - Lade Kind-Daten aus Firebase
- `lib/screens/children/child_detail_screen.dart:54` - Zeige Statistiken
- `lib/screens/children/child_detail_screen.dart:64` - Zeige Sessions

**Export Screen:**
- `lib/screens/export/export_screen.dart:26` - Generate PDF Report
- `lib/screens/export/export_screen.dart:43` - Generate CSV Export

### apps/therapy-web (5 TODOs)

- `lib/screens/settings/settings_screen.dart:85` - Navigate to Therapy Settings
- `lib/screens/language/language_settings_screen.dart:150` - Speichere Einstellungen in Firebase
- `lib/screens/phoneme/phoneme_settings_screen.dart:135` - Speichere Einstellungen in Firebase
- `lib/screens/avatar/avatar_upload_screen.dart:220` - Implementiere Avatar-Generierung
- `lib/services/avatar_service.dart:20` - Rufe Avatar-Generierungs-API auf

### apps/lianko (8 TODOs)

**Screens:**
- `lib/screens/stories/stories_screen.dart:97` - Filter implementieren
- `lib/screens/stories/stories_screen.dart:135` - Belohnung geben
- `lib/screens/communication/communication_screen.dart:462` - Push an Eltern wenn aktiviert
- `lib/screens/games/quiz_game_screen.dart:121` - Erfolgs-Sound
- `lib/screens/games/quiz_game_screen.dart:123` - Fehler-Sound
- `lib/screens/premium/premium_features_screen.dart:678` - Implementiere Bild-Aufnahme und AI-Analyse

**Services:**
- `lib/services/child_recording_service.dart:49` - Echte Aufnahme starten
- `lib/services/child_recording_service.dart:76` - Echte Aufnahme stoppen
- `lib/services/child_recording_service.dart:123` - Echte Wiedergabe
- `lib/services/child_recording_service.dart:135` - TTS Fallback
- `lib/services/child_recording_service.dart:253` - Echten Stream implementieren

### apps/alanko (1 TODO)

- `lib/config/api_config.dart:140` - Lade Konfiguration aus Firebase Remote Config

### apps/parent (2 TODOs)

- `lib/services/notification_service.dart:144` - Implement navigation logic based on notification type
- `lib/services/notification_service.dart:151` - Handle navigation from local notification

---

## 🎯 Prioritäten

### 🔴 HOCH (Sofort beheben)
1. **Hardcodierte API-Keys** - ✅ BEHOBEN
2. **Firebase Service Implementation** (therapy-ai)
3. **Settings Screens Navigation** (mehrere Apps)

### 🟡 MITTEL (Nächste Woche)
1. **Export-Funktionen** (PDF/CSV)
2. **Avatar-Generierung** (therapy-web)
3. **Recording Service** (lianko)

### 🟢 NIEDRIG (Backlog)
1. **Sound-Effekte** (quiz_game_screen)
2. **Filter-Funktionen** (stories_screen)
3. **Firebase Remote Config** (alanko)

---

## 📊 Statistiken

- **Gesamt:** 53 TODOs/Platzhalter
- **Kritisch:** 5
- **Mittel:** 15
- **Niedrig:** 33

**Nach App:**
- therapy-ai: 15
- therapy-parent: 12
- lianko: 8
- therapy-web: 5
- parent: 2
- alanko: 1

---

## ✅ Nächste Schritte

1. ✅ Hardcodierte API-Keys entfernt
2. ⏭️ Firebase Service in therapy-ai implementieren
3. ⏭️ Settings Navigation vervollständigen
4. ⏭️ Export-Funktionen implementieren
5. ⏭️ Recording Service vervollständigen

---

## 📝 Hinweise

- Alle TODOs sind im Code dokumentiert
- Einige TODOs sind in separaten Markdown-Dateien dokumentiert
- Prioritäten sollten regelmäßig überprüft werden
- Security-relevante TODOs haben höchste Priorität
