# Offene TODOs - Therapy AI App

**Stand:** 17. Dezember 2024

---

## 🔴 Kritische TODOs (im Code)

### 1. **Volume-Level Integration** ⚠️
**Dateien:**
- `lib/screens/therapy/exercise_screen.dart` (Zeile 316, 333)

**Problem:**
```dart
volumeLevel: 0.7, // TODO: Echte Volume-Level aus AudioService
```

**Lösung:**
- Echte Volume-Level aus `AudioAnalysisService` holen
- Live-Volume während Aufnahme tracken
- In `WaveformWidget` integrieren

**Priorität:** Hoch

---

### 2. **Profil-Speicherung** ⚠️
**Dateien:**
- `lib/screens/setup/child_profile_screen.dart` (Zeile 72)
- `lib/screens/setup/voice_cloning_screen.dart` (Zeile 113)

**Problem:**
```dart
// TODO: Speichere Profil in Firebase/Hive
// TODO: Speichere voiceId im ChildProfile
```

**Lösung:**
- `ChildProfileProvider.saveProfile()` aufrufen
- `ChildProfileProvider.updateVoiceId()` aufrufen
- Integration testen

**Priorität:** Hoch

---

### 3. **Firebase-Laden** ⚠️
**Dateien:**
- `lib/providers/child_profile_provider.dart` (Zeile 59)

**Problem:**
```dart
// TODO: Implementiere Firebase-Laden wenn nötig
```

**Lösung:**
- Firebase-Laden implementieren wenn kein lokales Profil
- Fallback-Strategie

**Priorität:** Mittel

---

### 4. **Settings Screen** 📱
**Dateien:**
- `lib/screens/home/dashboard_screen.dart` (Zeile 123)

**Problem:**
```dart
// TODO: Settings Screen
```

**Lösung:**
- Settings Screen erstellen
- Einstellungen: Sprache, Volume, Notifications, etc.

**Priorität:** Niedrig

---

## 🟡 Feature-TODOs (aus Dokumentation)

### 5. **Whisper On-Device Integration** 🔧
**Status:** API-Integration vorhanden, On-Device fehlt

**Offen:**
- [ ] whisper.cpp vollständig integrieren (Platform Channels)
- [ ] Model-Download-Mechanismus
- [ ] On-Device Transkription testen
- [ ] Performance-Optimierung

**Priorität:** Hoch (für Offline-Funktionalität)

---

### 6. **Firebase Integration vollständig** 🔥
**Status:** Services vorhanden, aber nicht vollständig getestet

**Offen:**
- [ ] Firestore Collections testen
- [ ] Offline-Support testen
- [ ] Sync-Mechanismus testen
- [ ] Error-Handling verbessern

**Priorität:** Hoch

---

### 7. **Achievement-System** 🏆
**Status:** Nicht implementiert

**Offen:**
- [ ] Badge-Model erstellen
- [ ] Achievement-Logik implementieren
- [ ] Badge-Collection Screen
- [ ] Animationen bei Badge-Erhalt

**Priorität:** Mittel

---

### 8. **Parent Dashboard App** 👨‍👩‍👧
**Status:** Dokumentiert, aber nicht implementiert

**Offen:**
- [ ] Separate App erstellen (`apps/therapy-parent/`)
- [ ] Fortschritts-Dashboard
- [ ] Kind-Profile verwalten
- [ ] Export-Funktionen (PDF, CSV)

**Priorität:** Mittel (wurde explizit gewünscht)

---

### 9. **Web UI** 🌐
**Status:** Dokumentiert, aber nicht implementiert

**Offen:**
- [ ] Flutter Web App oder React/Vue
- [ ] Detaillierte Einstellungen
- [ ] Multi-Language Management
- [ ] Phonem-Einstellungen
- [ ] Avatar-Upload-Interface

**Priorität:** Mittel (wurde explizit gewünscht)

---

### 10. **Avatar-System** 🎭
**Status:** Dokumentiert, aber nicht implementiert

**Offen:**
- [ ] Bild-Upload (6-10 Bilder)
- [ ] Avatar-Generierung (Ready Player Me oder Custom)
- [ ] Avatar-Speicherung
- [ ] Lip-Sync Integration
- [ ] Animationen (Emotionen, Bewegungen)
- [ ] Integration in Therapy-App

**Priorität:** Hoch (wurde explizit gewünscht)

---

### 11. **Testing** 🧪
**Status:** Keine Tests vorhanden

**Offen:**
- [ ] Unit Tests für Services
- [ ] Integration Tests für APIs
- [ ] Widget Tests
- [ ] Performance-Tests
- [ ] Testing mit echten Kindersprach-Samples

**Priorität:** Hoch (für Production)

---

### 12. **Error Handling & Retry-Logik** ⚠️
**Status:** Basis vorhanden, aber nicht vollständig

**Offen:**
- [ ] Retry-Mechanismus für API-Calls
- [ ] Exponential Backoff
- [ ] Graceful Degradation
- [ ] User-freundliche Fehlermeldungen
- [ ] Offline-Fallback

**Priorität:** Hoch

---

### 13. **Audio-Qualität & Preprocessing** 🎵
**Status:** Basis vorhanden, aber nicht optimiert

**Offen:**
- [ ] Noise Reduction
- [ ] Audio-Normalisierung
- [ ] Echo-Cancellation
- [ ] Bessere Volume-Analyse

**Priorität:** Mittel

---

### 14. **Onboarding-Tutorial** 📚
**Status:** Nicht implementiert

**Offen:**
- [ ] Interaktive Tutorial für erste Nutzung
- [ ] Schritt-für-Schritt Anleitung
- [ ] Beispiel-Übung zum Testen

**Priorität:** Niedrig

---

### 15. **Dark Mode vollständig** 🌙
**Status:** Teilweise vorhanden

**Offen:**
- [ ] Alle Screens Dark Mode unterstützen
- [ ] Automatischer Wechsel basierend auf Tageszeit
- [ ] Anpassbare Helligkeit

**Priorität:** Niedrig

---

## 📊 Prioritäten-Übersicht

### 🔴 Sofort (diese Woche)
1. ✅ Volume-Level Integration
2. ✅ Profil-Speicherung vervollständigen
3. ✅ Firebase Integration testen
4. ✅ Error Handling verbessern

### 🟡 Kurzfristig (nächste 2 Wochen)
5. ✅ Whisper On-Device Integration
6. ✅ Achievement-System
7. ✅ Testing (Basis)

### 🟢 Mittelfristig (nächste 4 Wochen)
8. ✅ Parent Dashboard App
9. ✅ Web UI
10. ✅ Avatar-System

### ⚪ Langfristig (später)
11. ✅ Audio-Preprocessing
12. ✅ Onboarding-Tutorial
13. ✅ Dark Mode vollständig

---

## 📝 Code-TODOs (Quick Wins)

### Sofort behebbar:
1. **Volume-Level:** Echte Werte aus AudioService holen
2. **Profil-Speicherung:** Provider-Methoden aufrufen
3. **Settings Screen:** Einfacher Screen erstellen

**Geschätzter Aufwand:** 2-3 Stunden

---

## 🎯 Empfohlene Reihenfolge

1. **Code-TODOs beheben** (2-3 Stunden)
   - Volume-Level Integration
   - Profil-Speicherung
   - Settings Screen

2. **Firebase testen** (1-2 Stunden)
   - Integration testen
   - Error-Handling verbessern

3. **Whisper On-Device** (1-2 Tage)
   - Platform Channels
   - Model-Integration

4. **Achievement-System** (1 Tag)
   - Badges implementieren

5. **Parent Dashboard** (1-2 Wochen)
   - Separate App
   - Features implementieren

---

**Soll ich mit den Code-TODOs beginnen?** 🚀

