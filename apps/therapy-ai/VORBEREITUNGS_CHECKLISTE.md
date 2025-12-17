# 📋 Vorbereitungs-Checkliste für Therapy AI

Diese Checkliste hilft dir, alles vorzubereiten, was für die weitere Entwicklung benötigt wird.

---

## 🔑 1. API Keys & Credentials

### ✅ ElevenLabs API Key
- [x] **ElevenLabs Account erstellen** ✅
- [x] **API Key generieren** ✅
- [x] **API Key gespeichert** ✅ (in `.env` Datei)

**Wo wird es verwendet:**
- Voice Cloning Service
- TTS Generation

---

## 📦 2. Packages & Dependencies

### ✅ Whisper Package
- [ ] **Entscheidung treffen:** Welches Whisper-Package?
  - Option A: `whisper_dart` (Dart-native)
  - Option B: `whisper_flutter` (Flutter-wrapper)
  - Option C: `whisper.cpp` via Platform Channels (beste Performance)
- [ ] **Package-Info recherchieren:**
  - Verfügbarkeit auf pub.dev
  - Kompatibilität mit Flutter 3.10+
  - On-device Support
  - Model-Größen (base ~150MB, small ~500MB)

**Empfehlung:** Starte mit `whisper_dart` oder `whisper_flutter` für einfachere Integration

---

## 🎤 3. Audio-Samples & Test-Daten

### ✅ Therapist Voice Sample
- [ ] **Audio-Aufnahme vorbereiten** (für Voice Cloning)
  - Dauer: 1-5 Minuten (mindestens 1 Minute)
  - Format: WAV oder MP3
  - Qualität: 16kHz, Mono oder Stereo
  - Inhalt: Klare, natürliche Sprache
  - Sprache: Bosnisch/Deutsch (je nach Bedarf)
- [ ] **Datei speichern:**
  - Pfad: `apps/therapy-ai/assets/audio/therapist_sample.wav`
  - Oder: Bereit zum Upload in App

**Tipp:** Lass den Therapeuten/Audiologen einen kurzen Text vorlesen (z.B. Kinderbuch-Ausschnitt)

### ✅ Test-Audio-Samples (Kinderstimmen)
- [ ] **Test-Aufnahmen sammeln** (optional, für späteres Testing)
  - Verschiedene Altersgruppen (4-12 Jahre)
  - Verschiedene Schwierigkeitsgrade
  - Verschiedene Hörverlust-Muster
- [ ] **Speichern für Tests:**
  - `apps/therapy-ai/assets/audio/test_samples/`

---

## 📱 4. Flutter & Development Setup

### ✅ Flutter Environment
- [ ] **Flutter Version prüfen:**
  ```bash
  flutter --version
  ```
  - Sollte: Flutter 3.10.1+ sein
- [ ] **Flutter Doctor prüfen:**
  ```bash
  flutter doctor
  ```
  - Alle Checks sollten grün sein

### ✅ Dependencies installieren
- [ ] **In therapy-ai Verzeichnis:**
  ```bash
  cd apps/therapy-ai
  flutter pub get
  ```
- [ ] **Prüfen ob alle Packages verfügbar sind**

### ✅ Platform-Setup
- [ ] **Android Studio / Xcode prüfen**
  - Android: SDK installiert
  - iOS: Xcode installiert (für macOS)
- [ ] **Emulator/Simulator vorbereiten**
  - Android Emulator oder iOS Simulator
  - Oder: Physisches Gerät verbinden

---

## 🔧 5. Konfigurationen

### ✅ Environment Variables
- [ ] **`.env.example` Datei erstellen** (wird automatisch erstellt)
  - Template für API Keys
- [ ] **`.env` Datei erstellen** (lokal, nicht committen!)
  - ElevenLabs API Key eintragen
  - Andere Secrets

### ✅ Firebase Setup (optional, für später)
- [ ] **Firebase Project erstellen** (falls noch nicht vorhanden)
  - https://console.firebase.google.com
- [ ] **Firebase CLI installieren:**
  ```bash
  npm install -g firebase-tools
  ```
- [ ] **FlutterFire CLI installieren:**
  ```bash
  dart pub global activate flutterfire_cli
  ```
- [ ] **Firebase konfigurieren:**
  ```bash
  cd apps/therapy-ai
  flutterfire configure
  ```

---

## 📚 6. Dokumentation & Ressourcen

### ✅ Whisper Dokumentation
- [ ] **Whisper Docs lesen:**
  - https://github.com/openai/whisper
  - Model-Größen verstehen
  - On-device Deployment

### ✅ ElevenLabs Dokumentation
- [ ] **API Docs durchsehen:**
  - https://elevenlabs.io/docs
  - Voice Cloning API
  - TTS API
  - Rate Limits verstehen

### ✅ Design-Referenzen
- [ ] **v0.app Design nochmal anschauen:**
  - https://v0.app/chat/therapy-app-design-n211CTZOznL
  - Design-Feedback durchlesen

---

## 🧪 7. Test-Vorbereitungen

### ✅ Test-Szenarien überlegen
- [ ] **Test-Cases definieren:**
  - Einfache Wörter (Mama, Papa)
  - Komplexere Sätze
  - Verschiedene Lautstärken
  - Verschiedene Aussprachen

### ✅ Test-Device vorbereiten
- [ ] **Test-Gerät auswählen:**
  - Android oder iOS
  - Mindestens Android 8+ / iOS 12+
  - Ausreichend Speicherplatz (für Whisper-Model)

---

## 📝 8. Projekt-Struktur prüfen

### ✅ Verzeichnisse prüfen
- [ ] **Alle Ordner vorhanden:**
  ```
  apps/therapy-ai/
  ├── lib/
  │   ├── services/     ✅ Vorhanden
  │   ├── screens/      ✅ Vorhanden
  │   ├── widgets/      ✅ Vorhanden
  │   └── models/       ✅ Vorhanden
  ├── assets/
  │   └── audio/        ⚠️ Erstellen falls nicht vorhanden
  └── test/             ✅ Vorhanden
  ```

### ✅ Assets-Ordner erstellen
- [ ] **Audio-Ordner erstellen:**
  ```bash
  mkdir -p apps/therapy-ai/assets/audio
  mkdir -p apps/therapy-ai/assets/audio/test_samples
  ```

---

## ✅ 9. Quick-Check: Bereit für Entwicklung?

### Mindest-Anforderungen (kritisch):
- [ ] Flutter 3.10.1+ installiert
- [ ] `flutter pub get` erfolgreich
- [ ] Android Studio / Xcode funktioniert
- [ ] Emulator/Simulator startet

### Empfohlen (für vollständige Entwicklung):
- [ ] ElevenLabs API Key vorhanden
- [ ] Therapist Voice Sample vorbereitet
- [ ] Whisper-Package-Entscheidung getroffen
- [ ] Firebase konfiguriert (optional)

---

## 🚀 Nach der Vorbereitung

Sobald du die Checkliste abgearbeitet hast, kann ich:

1. **Whisper Integration** implementieren
2. **ElevenLabs Service** erstellen
3. **Services** vollständig implementieren
4. **Screens** bauen

---

## 📞 Hilfe & Fragen

Falls du bei einem Punkt Hilfe brauchst:
- **API Keys:** Ich kann dir zeigen, wie man sie sicher speichert
- **Packages:** Ich kann die beste Option empfehlen
- **Setup:** Ich kann Schritt-für-Schritt-Anleitungen geben

---

## ⏱️ Geschätzter Zeitaufwand

| Aufgabe | Zeit |
|---------|------|
| API Keys besorgen | 10-15 Min |
| Packages recherchieren | 15-20 Min |
| Audio-Sample aufnehmen | 5-10 Min |
| Flutter Setup prüfen | 5 Min |
| Firebase Setup (optional) | 10-15 Min |
| **Gesamt** | **45-65 Min** |

---

**Status:** ⬜ Noch nicht begonnen  
**Nächster Schritt:** Beginne mit Punkt 1 (API Keys)

---

*Diese Checkliste wird aktualisiert, sobald neue Anforderungen hinzukommen.*

