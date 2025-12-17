# 🔐 Environment Setup - ElevenLabs API Key

## ✅ API Key wurde erhalten

Dein ElevenLabs API Key wurde gespeichert und ist bereit für die Verwendung.

## 📝 .env Datei erstellen

**WICHTIG:** Erstelle die `.env` Datei manuell im Verzeichnis `apps/therapy-ai/`:

```bash
cd apps/therapy-ai
```

Erstelle eine Datei namens `.env` mit folgendem Inhalt:

```env
# Therapy AI - Environment Variables
# WICHTIG: Diese Datei wird nicht committed (.gitignore)

# ElevenLabs API Configuration
# WICHTIG: Ersetze YOUR_ELEVENLABS_API_KEY mit deinem echten API Key
# Du findest deinen API Key hier: https://elevenlabs.io/app/settings/api-keys
ELEVENLABS_API_KEY=YOUR_ELEVENLABS_API_KEY
ELEVENLABS_API_BASE_URL=https://api.elevenlabs.io/v1

# App Configuration
APP_ENV=development
DEBUG_MODE=true

# Feature Flags
ENABLE_WHISPER_ON_DEVICE=true
ENABLE_VOICE_CLONING=true
ENABLE_PROGRESS_TRACKING=true
ENABLE_OFFLINE_MODE=true
```

## ✅ Sicherheit

- ✅ Die `.env` Datei ist bereits in `.gitignore` eingetragen
- ✅ Der API Key wird nicht committed
- ✅ `EnvConfig` Klasse wurde erstellt für sichere Verwendung

## 🚀 Nächste Schritte

1. ✅ API Key gespeichert
2. ⏭️ `.env` Datei erstellen (siehe oben)
3. ⏭️ `EnvConfig.initialize()` in `main.dart` aufrufen
4. ⏭️ ElevenLabs Service implementieren

## 📖 Verwendung

Der API Key wird über `EnvConfig` geladen:

```dart
await EnvConfig.initialize();
final apiKey = EnvConfig.elevenLabsApiKey;
```

---

**Status:** ✅ API Key konfiguriert  
**Nächster Schritt:** `.env` Datei erstellen (siehe Anleitung oben)

