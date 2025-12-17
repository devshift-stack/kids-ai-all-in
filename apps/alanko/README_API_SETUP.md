# Alanko AI - API Setup Guide

**🔒 Wichtig:** API-Keys gehören NICHT in den Code! Diese Anleitung zeigt dir, wie du sie sicher verwendest.

---

## 📋 Schnellstart

### Für neue Entwickler (2 Minuten):

```bash
# 1. Setup-Script ausführen
./scripts/setup.sh

# 2. API-Key in .env einfügen
nano .env  # oder mit deinem Editor öffnen

# 3. App starten
./scripts/run-dev.sh
# ODER: Drücke F5 in VS Code
```

**Das war's!** ✅

---

## 🔑 Gemini API Key holen

### Schritt 1: Google AI Studio öffnen
👉 https://aistudio.google.com/apikey

### Schritt 2: "Create API Key" klicken

### Schritt 3: Key kopieren
```
Beispiel: AIzaSyD5jBRl-Ti0r_uSyx5JW24H3CySQ8RWrS8
```

### Schritt 4: Key in `.env` einfügen
```bash
# .env
GEMINI_API_KEY=AIzaSy...dein_echter_key
```

---

## 🚀 App starten (4 Methoden)

### Methode 1: Shell Script (Empfohlen)
```bash
cd apps/alanko
./scripts/run-dev.sh
```

**Vorteile:**
- ✅ Lädt automatisch .env
- ✅ Prüft API-Key
- ✅ Zeigt hilfreiche Fehlermeldungen

---

### Methode 2: VS Code (F5)
```
1. Öffne VS Code
2. Wähle "Alanko Development" in der Debug-Leiste
3. Drücke F5
```

**Vorteile:**
- ✅ Debugger integriert
- ✅ Hot Reload
- ✅ Automatische Key-Injection

---

### Methode 3: Terminal (Manuell)
```bash
flutter run --dart-define=GEMINI_API_KEY=AIzaSy...dein_key
```

**Für CI/CD:**
```bash
flutter run --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY
```

---

### Methode 4: Android Studio
```
Run → Edit Configurations
→ Additional run args:
  --dart-define=GEMINI_API_KEY=AIzaSy...dein_key
```

---

## 🏗️ Production Builds

### Android APK bauen
```bash
./scripts/build-android.sh
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

---

### iOS IPA bauen (nur macOS)
```bash
./scripts/build-ios.sh
```

Output: `build/ios/ipa/alanko_ai.ipa`

---

## 🔄 CI/CD Setup (GitHub Actions)

### Schritt 1: Secret hinzufügen
```
GitHub Repo → Settings → Secrets → New repository secret
Name: GEMINI_API_KEY
Value: AIzaSy...dein_key
```

### Schritt 2: In Workflow verwenden
```yaml
# .github/workflows/build.yml
- name: Build APK
  env:
    GEMINI_API_KEY: ${{ secrets.GEMINI_API_KEY }}
  run: |
    flutter build apk \
      --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY
```

---

## 🎯 API-Key Verwaltung

### Verschiedene Keys für verschiedene Umgebungen

#### Development
```bash
# .env
GEMINI_API_KEY=AIzaSy...dev_key
```

#### Staging
```bash
# .env.staging
GEMINI_API_KEY=AIzaSy...staging_key
```

#### Production
```bash
# In CI/CD als Secret
GEMINI_API_KEY=AIzaSy...prod_key
```

---

### Team-Mitglieder mit eigenen Keys

**Developer 1:**
```bash
# .env
GEMINI_API_KEY=AIzaSy...dev1_key
```

**Developer 2:**
```bash
# .env
GEMINI_API_KEY=AIzaSy...dev2_key
```

**Vorteil:** Jeder hat sein eigenes Quota!

---

## 🔒 Sicherheits-Checkliste

### ✅ DO:
- ✅ API-Keys in `.env` Datei speichern
- ✅ `.env` zu `.gitignore` hinzufügen
- ✅ Keys über `--dart-define` übergeben
- ✅ In CI/CD: Keys als Secrets
- ✅ Verschiedene Keys für Dev/Prod
- ✅ Team-Mitglieder haben eigene Keys

### ❌ DON'T:
- ❌ Keys NIEMALS im Code hardcoden
- ❌ Keys NIEMALS committen
- ❌ Keys NIEMALS in Screenshots zeigen
- ❌ Keys NIEMALS öffentlich teilen
- ❌ Produktions-Keys für Development nutzen

---

## 🛠️ Troubleshooting

### Problem: "API Key nicht gesetzt"

**Lösung 1: .env Datei prüfen**
```bash
cat .env
# Sollte zeigen: GEMINI_API_KEY=AIzaSy...
```

**Lösung 2: Setup-Script ausführen**
```bash
./scripts/setup.sh
```

**Lösung 3: Manuell starten**
```bash
flutter run --dart-define=GEMINI_API_KEY=dein_key
```

---

### Problem: "Quota exceeded"

**Ursache:** Free Tier Limits erreicht
- 15 Anfragen pro Minute
- 1500 Anfragen pro Tag

**Lösung:**
```bash
# Option 1: Warte 1 Minute
# Option 2: Neuen API-Key erstellen
# Option 3: Upgrade auf bezahltes Tier
```

---

### Problem: "Invalid API Key"

**Prüfe:**
1. Key korrekt kopiert? (Keine Leerzeichen)
2. Key aktiviert in Google AI Studio?
3. Richtiger Key für Umgebung?

**Test:**
```bash
# API-Key testen
curl https://generativelanguage.googleapis.com/v1beta/models?key=dein_key
```

---

### Problem: F5 in VS Code funktioniert nicht

**Lösung:**
```bash
# 1. launch.json prüfen
cat .vscode/launch.json

# 2. VS Code neu laden
Cmd/Ctrl + Shift + P → "Reload Window"

# 3. Manuell starten
./scripts/run-dev.sh
```

---

## 📂 Datei-Struktur

```
apps/alanko/
├── .env                    # Deine API-Keys (nicht in Git!)
├── .env.example            # Template für Team
├── .gitignore              # Schützt .env
├── .vscode/
│   └── launch.json        # VS Code Debug Config
├── lib/
│   ├── config/
│   │   └── api_config.dart  # Zentrale API-Verwaltung
│   └── services/
│       └── gemini_service.dart  # Nutzt ApiConfig
├── scripts/
│   ├── setup.sh           # Einmaliges Setup
│   ├── run-dev.sh         # Development starten
│   ├── build-android.sh   # Android bauen
│   └── build-ios.sh       # iOS bauen
└── README_API_SETUP.md    # Diese Datei
```

---

## 🎓 Erweiterte Nutzung

### Runtime API-Key Änderung (Admin Feature)

```dart
import 'package:alanko_ai/config/api_config.dart';

// In Admin-Screen
void changeApiKey(String newKey) {
  apiConfig.setGeminiKey(newKey);
  await apiConfig.saveToPreferences();
}

// Status anzeigen
String status = apiConfig.getStatusMessage();
print(status); // "✓ API-Key aktiv"
```

---

### Debug-Informationen

```dart
// lib/main.dart
void main() async {
  // ... initialisierung ...
  
  if (kDebugMode) {
    apiConfig.printDebugInfo();
  }
  
  runApp(MyApp());
}
```

**Output:**
```
═══════════════════════════════════════════════════════
API Configuration Status:
───────────────────────────────────────────────────────
Gemini API Key:
  • Compile-Time: ✓ Gesetzt
  • Runtime:      ✗ Kein Override
  • Aktuell:      ✓ Verfügbar
═══════════════════════════════════════════════════════
```

---

## 🔗 Weiterführende Links

- 🌐 **Google AI Studio:** https://aistudio.google.com/apikey
- 📖 **Gemini API Docs:** https://ai.google.dev/docs
- 💰 **Pricing:** https://ai.google.dev/pricing
- 🔒 **Security Best Practices:** https://cloud.google.com/docs/authentication/api-keys

---

## 💬 Support

### Problem nicht gelöst?

1. **Setup-Script ausführen:**
   ```bash
   ./scripts/setup.sh
   ```

2. **Pull Request mit Frage erstellen**

3. **Issue auf GitHub öffnen**

4. **Team fragen im devshift-stack Slack**

---

## 🎯 Checkliste für neue Entwickler

- [ ] Repository geklont
- [ ] `./scripts/setup.sh` ausgeführt
- [ ] Gemini API Key geholt
- [ ] `.env` Datei erstellt und Key eingefügt
- [ ] `./scripts/run-dev.sh` erfolgreich
- [ ] App läuft und AI funktioniert
- [ ] F5 in VS Code funktioniert
- [ ] README_API_SETUP.md gelesen

---

**🎉 Fertig! Viel Spaß beim Entwickeln!**

Bei Fragen: Siehe Support-Sektion oben ⬆️
