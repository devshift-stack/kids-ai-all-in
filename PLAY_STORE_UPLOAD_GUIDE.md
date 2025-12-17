# 📱 Play Store Upload Guide - Kids AI Apps

**Datum:** 2025-12-17  
**Apps:** Alanko AI, Lianko AI, Parent Dashboard

---

## 🚀 SCHNELLSTART (Auf deinem lokalen System)

### 1. Alle AABs bauen
```bash
cd /pfad/zu/kids-ai-all-in

# API-Key setzen
export GEMINI_API_KEY=AIzaSyCfI7eOCgmCrw1If0CZvHeDnFGhyrWenCI

# Alle Apps bauen
./build-all-apps.sh
```

**Ausgabe:**
```
builds/20251217_123456/
├── alanko-release.aab
├── lianko-release.aab
└── parent-release.aab
```

---

## 📋 VORBEREITUNG

### ✅ Checkliste vor dem Upload

**Für JEDE App:**

#### 1. Version erhöhen
```yaml
# apps/alanko/pubspec.yaml
version: 1.0.1+2  # War: 1.0.0+1
#        ↑    ↑
#        |    └─ Build Number (immer erhöhen!)
#        └────── Version Name (bei Features erhöhen)
```

#### 2. Release Notes vorbereiten
```
Was ist neu in Version 1.0.1:
• Neue API-Key Verwaltung (sicherer!)
• Firebase Performance optimiert
• Code-Verbesserungen
• Bug-Fixes
```

#### 3. Screenshots prüfen
- Mindestens 2 Screenshots pro App
- 1080x1920 oder 1920x1080
- Aktuelle UI zeigen

#### 4. Signing-Key bereit haben
- Keystore-Datei
- Keystore-Passwort
- Key-Alias
- Key-Passwort

---

## 🏗️ EINZELN BAUEN (Optional)

Falls du nur eine App bauen möchtest:

### Alanko AI
```bash
cd apps/alanko

# Mit API-Key
flutter build appbundle \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release \
    --obfuscate \
    --split-debug-info=debug-info

# AAB:
# build/app/outputs/bundle/release/app-release.aab
```

### Lianko AI
```bash
cd apps/lianko

flutter build appbundle \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release \
    --obfuscate \
    --split-debug-info=debug-info

# AAB:
# build/app/outputs/bundle/release/app-release.aab
```

### Parent Dashboard
```bash
cd apps/parent

flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info=debug-info

# AAB:
# build/app/outputs/bundle/release/app-release.aab
```

---

## 📤 PLAY STORE UPLOAD

### Schritt-für-Schritt für jede App

#### 1. Google Play Console öffnen
```
→ https://play.google.com/console
→ Login mit Google Account
```

#### 2. App auswählen
```
→ Alle Apps
→ [Alanko AI / Lianko AI / Parent Dashboard] auswählen
```

#### 3. Neues Release erstellen
```
→ Sidebar: Produktion
→ Releases → Neues Release erstellen
```

#### 4. AAB hochladen
```
→ "App-Bundles und APKs hochladen"
→ Datei auswählen: alanko-release.aab
→ Hochladen warten
→ ✅ Bundle wird verarbeitet
```

#### 5. Release Notes eingeben
```
Deutsch (de-DE):
─────────────────
Version 1.0.1

Neu:
• Verbesserte Sicherheit für API-Keys
• Firebase Performance Optimierungen
• Code-Qualität verbessert
• Diverse Bug-Fixes

Englisch (en-US):
─────────────────
Version 1.0.1

What's new:
• Improved API key security
• Firebase performance optimizations
• Code quality improvements
• Various bug fixes
```

#### 6. Release prüfen
```
→ Scroll nach unten
→ Prüfe: Versionscode, Größe, Target SDK
→ Warnungen beachten (falls vorhanden)
```

#### 7. Review starten
```
→ "Zur Prüfung senden"
→ Bestätigen
```

#### 8. Warten auf Freigabe
```
⏳ Review dauert: 1-3 Tage
📧 Email-Benachrichtigung bei Freigabe/Ablehnung
```

---

## 🔐 SIGNING KONFIGURATION

### key.properties erstellen

Falls noch nicht vorhanden:

```bash
# apps/alanko/android/key.properties
storePassword=dein_store_password
keyPassword=dein_key_password
keyAlias=upload
storeFile=/pfad/zu/keystore.jks
```

**WICHTIG:** Nicht in Git committen!

### Keystore erstellen (falls neu)

```bash
keytool -genkey -v \
  -keystore ~/upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

# Passwörter gut aufbewahren!
# Am besten in 1Password/LastPass
```

---

## 📊 BUILD-VARIANTEN

### Release (Standard)
```bash
flutter build appbundle --release
```
- Optimiert
- Keine Debug-Info
- Klein (~25 MB)

### Release mit Obfuscation (Empfohlen!)
```bash
flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info=debug-info
```
- Code verschleiert
- Schwerer zu dekompilieren
- Debug-Symbole separat gespeichert

### Profile
```bash
flutter build appbundle --profile
```
- Für Performance-Tests
- Mit Profiling-Tools
- Nicht für Production!

---

## 🧪 AAB TESTEN (Vor Upload)

### Mit bundletool
```bash
# AAB → APK Set erstellen
bundletool build-apks \
  --bundle=app-release.aab \
  --output=app-release.apks \
  --ks=upload-keystore.jks \
  --ks-key-alias=upload

# Auf Gerät installieren
bundletool install-apks --apks=app-release.apks
```

### Mit Internal Testing Track
```
Play Console → Internal Testing
→ Release erstellen
→ AAB hochladen
→ Tester hinzufügen
→ Testen vor Production-Release
```

---

## 📈 VERSION-MANAGEMENT

### Version Schema
```
version: MAJOR.MINOR.PATCH+BUILD

Beispiele:
1.0.0+1   ← Initial Release
1.0.1+2   ← Bug Fix
1.1.0+3   ← New Feature
2.0.0+4   ← Breaking Changes
```

### Wann was erhöhen?

| Änderung | Version | Build | Beispiel |
|----------|---------|-------|----------|
| Bug Fix | Patch +1 | +1 | 1.0.0+1 → 1.0.1+2 |
| Feature | Minor +1 | +1 | 1.0.1+2 → 1.1.0+3 |
| Breaking | Major +1 | +1 | 1.1.0+3 → 2.0.0+4 |

**WICHTIG:** Build Number IMMER erhöhen!

---

## 🎯 TRACK STRATEGIE

### Internal Testing
```
→ Kleine Gruppe (< 100)
→ Schnelle Updates
→ Für Team-Tests
→ Keine Review nötig
```

### Closed Testing (Beta)
```
→ Größere Gruppe (< 1000)
→ Opt-in für User
→ Feedback sammeln
→ Kurze Review (< 1 Tag)
```

### Open Testing (Beta)
```
→ Jeder kann teilnehmen
→ Öffentlich sichtbar
→ Vor Production-Release
→ Review erforderlich
```

### Production
```
→ Alle User
→ Standard-Track
→ Längere Review (1-3 Tage)
→ Gestaffter Rollout empfohlen
```

---

## 🚀 ROLLOUT-STRATEGIE

### Gestaffelter Rollout (Empfohlen!)

```
Tag 1:   1% der User   → Fehler-Monitoring
Tag 2:  10% der User   → Feedback prüfen
Tag 3:  50% der User   → Metriken checken
Tag 4: 100% der User   → Full Rollout
```

**In Play Console:**
```
→ Release erstellen
→ "Gestaffelte Freigabe" wählen
→ Startprozentsatz: 1%
→ Nach Prüfung: Prozentsatz erhöhen
```

---

## 📋 CHECKLISTE FÜR UPLOAD

### Vor dem Build
- [ ] Version in pubspec.yaml erhöht
- [ ] Release Notes geschrieben
- [ ] API-Keys korrekt gesetzt
- [ ] Alle Tests bestanden
- [ ] Code committed

### Build-Prozess
- [ ] `flutter clean` ausgeführt
- [ ] `flutter pub get` erfolgreich
- [ ] AAB gebaut (mit Obfuscation)
- [ ] AAB-Größe geprüft (< 150 MB)
- [ ] Lokal getestet (bundletool)

### Play Console
- [ ] Keystore vorhanden & valide
- [ ] Screenshots aktuell
- [ ] Store Listing aktuell
- [ ] Privacy Policy Link funktioniert
- [ ] App-Kategorie korrekt

### Nach Upload
- [ ] Release Notes korrekt
- [ ] Target Devices geprüft
- [ ] Warnungen behoben
- [ ] "Zur Prüfung senden" geklickt
- [ ] Team informiert

---

## 🔍 HÄUFIGE PROBLEME

### Problem: "Duplicate Version Code"
```
Ursache: Build Number nicht erhöht
Lösung:  version: 1.0.0+2  (statt +1)
```

### Problem: "Signing Key mismatch"
```
Ursache: Anderer Keystore verwendet
Lösung:  Gleichen Keystore wie bei erstem Upload nutzen
         ODER: Google Support kontaktieren
```

### Problem: "Target SDK too old"
```
Ursache: targetSdk < 33 (Android 13)
Lösung:  In android/app/build.gradle:
         targetSdk = 34
```

### Problem: "Bundle zu groß"
```
Ursache: AAB > 150 MB
Lösung:  
  • Bilder komprimieren
  • Nicht genutzte Assets entfernen
  • --split-per-abi nutzen
  • Asset Packs verwenden
```

---

## 📞 SUPPORT

### Google Play Console Support
```
→ Play Console → Hilfe (?) rechts oben
→ Kontakt zum Support-Team
→ Response: 1-2 Werktage
```

### Firebase Support
```
→ Firebase Console → Support
→ Billing-Probleme: Schneller Response
```

### Community
```
→ Stack Overflow: #flutter #google-play
→ Flutter Discord: #help-android
→ r/FlutterDev
```

---

## 🎉 NACH ERFOLGREICHER FREIGABE

### 1. Team informieren
```
✅ Alanko AI v1.0.1 ist live!
✅ Lianko AI v1.0.1 ist live!
✅ Parent Dashboard v1.0.1 ist live!
```

### 2. Monitoring aktivieren
```
→ Firebase Crashlytics: Crashes prüfen
→ Play Console: Metriken beobachten
→ User Reviews: Feedback lesen
```

### 3. Rollout überwachen
```
Tag 1-3: 
  • Crash Rate < 0.5%
  • ANR Rate < 0.1%
  • 1-Star Reviews prüfen
```

### 4. Bei Problemen
```
Falls kritischer Bug:
  → Rollout pausieren
  → Hot-Fix erstellen
  → Neues Release hochladen
```

---

## 📚 WEITERFÜHRENDE LINKS

- **Play Console:** https://play.google.com/console
- **Flutter Build Docs:** https://docs.flutter.dev/deployment/android
- **AAB Format:** https://developer.android.com/guide/app-bundle
- **Signing:** https://docs.flutter.dev/deployment/android#signing-the-app
- **bundletool:** https://github.com/google/bundletool

---

**Viel Erfolg beim Upload! 🚀📱**
