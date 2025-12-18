# Premium Callcenter-AI Setup Guide

## 🎯 Übersicht

Diese Anleitung zeigt, wie Sie die Premium-Funktionen des Callcenter-AI Systems aktivieren:
- **Premium TTS**: Google Cloud Text-to-Speech Neural2 (menschliche Stimmen)
- **Mehrsprachigkeit**: Deutsch, Bosnisch, Serbisch
- **Dashboard**: Einstellungen und Monitoring

## 💰 Kostenübersicht

### Google Cloud TTS (Premium)
- **Neural2 Voices**: $4-16 pro 1 Million Zeichen
- **Standard Voices**: $4 pro 1 Million Zeichen
- **Kostenbeispiel**: 
  - 10.000 Gespräche à 500 Zeichen = 5M Zeichen
  - Kosten: ~$20-80/Monat (je nach Nutzung)

### Alternative: Flutter TTS (Kostenlos)
- Funktioniert ohne API-Keys
- Qualität: Gut, aber nicht Premium
- Unterstützt alle 3 Sprachen

## 🔧 Setup

### 1. Google Cloud TTS API Key (Optional - für Premium)

```bash
# 1. Google Cloud Console öffnen
# https://console.cloud.google.com/

# 2. Projekt erstellen oder auswählen

# 3. Cloud Text-to-Speech API aktivieren
# APIs & Services > Library > "Cloud Text-to-Speech API" > Enable

# 4. Service Account erstellen
# IAM & Admin > Service Accounts > Create Service Account

# 5. API Key erstellen
# APIs & Services > Credentials > Create Credentials > API Key

# 6. API Key kopieren
```

### 2. App mit Premium TTS starten

```bash
cd apps/callcenter-ai

# Mit Premium TTS
flutter run --dart-define=GEMINI_API_KEY=your_gemini_key \
            --dart-define=GOOGLE_CLOUD_TTS_API_KEY=your_google_cloud_key

# Ohne Premium TTS (verwendet Flutter TTS)
flutter run --dart-define=GEMINI_API_KEY=your_gemini_key
```

### 3. Backend starten

```bash
cd apps/callcenter-ai/backend

# .env Datei erstellen
echo "GEMINI_API_KEY=your_gemini_key" > .env

# Dependencies installieren
npm install

# Server starten
npm start
```

## 🌍 Sprachunterstützung

### Unterstützte Sprachen

| Sprache | TTS Code | STT Code | Status |
|---------|----------|----------|--------|
| Deutsch | de-DE | de_DE | ✅ Vollständig |
| Bosnisch | bs-BA | bs_BA | ✅ Vollständig |
| Serbisch | sr-RS | sr_RS | ✅ Vollständig |

### Sprachauswahl im Dashboard

1. Öffnen Sie die App
2. Klicken Sie auf das Einstellungs-Icon (⚙️)
3. Wählen Sie die gewünschte Sprache
4. Die App passt sich automatisch an

## 📊 Dashboard Features

### Verfügbare Einstellungen:
- **Sprachauswahl**: Deutsch, Bosnisch, Serbisch
- **TTS Status**: Premium oder Standard
- **Monitoring**: Aktive Sessions, Nachrichten, Statistiken

### Monitoring API

```bash
# Statistiken abrufen
curl http://localhost:3000/api/v1/stats

# Antwort:
{
  "activeSessions": 5,
  "totalMessages": 1234,
  "messagesToday": 56,
  "languageDistribution": {
    "german": 3,
    "bosnian": 1,
    "serbian": 1
  },
  "timestamp": "2025-01-27T..."
}
```

## 🎤 Premium TTS Stimmen

### Google Cloud Neural2 Voices

- **Deutsch**: `de-DE-Neural2-F` (Weiblich, Premium)
- **Bosnisch**: `bs-BA-Standard-A` (Standard)
- **Serbisch**: `sr-RS-Standard-A` (Standard)

### Qualität

- **Neural2**: Nicht von menschlichen Stimmen zu unterscheiden
- **Standard**: Sehr gut, aber erkennbar als KI

## 🔒 Sicherheit

### API Keys schützen

```bash
# Nie in Git committen!
# Verwenden Sie .env Dateien oder --dart-define

# .gitignore sollte enthalten:
.env
*.key
```

## 🚀 Production Setup

### Empfohlene Konfiguration

1. **Backend**: Node.js auf Server (z.B. Heroku, Railway, Render)
2. **API Keys**: Als Environment Variables setzen
3. **Monitoring**: Backend Stats API für Analytics
4. **Caching**: TTS-Audio cachen für wiederholte Texte

### Beispiel Production Start

```bash
# Backend
export GEMINI_API_KEY=your_key
npm start

# Flutter App
flutter build apk --dart-define=GEMINI_API_KEY=your_key \
                  --dart-define=GOOGLE_CLOUD_TTS_API_KEY=your_key
```

## 📝 System-Prompts

Die System-Prompts sind sprachspezifisch optimiert:
- `backend/language_prompts.js` - Alle Sprach-Prompts
- Automatische Auswahl basierend auf gewählter Sprache

## 🐛 Troubleshooting

### TTS funktioniert nicht
- Prüfen Sie API Key: `GOOGLE_CLOUD_TTS_API_KEY`
- Fallback zu Flutter TTS wird automatisch verwendet

### Sprache wird nicht erkannt
- Prüfen Sie STT Locale: `currentLanguage.sttCode`
- Sprachauswahl im Dashboard prüfen

### Backend nicht erreichbar
- Prüfen Sie Port: Standard 3000
- Health Check: `curl http://localhost:3000/api/v1/health`

## 📚 Weitere Ressourcen

- [Google Cloud TTS Dokumentation](https://cloud.google.com/text-to-speech/docs)
- [Gemini API Dokumentation](https://ai.google.dev/docs)
- [Flutter TTS Package](https://pub.dev/packages/flutter_tts)

---

**Agent Eton - Mission Complete** ✅
Premium Callcenter-AI System ist einsatzbereit!

