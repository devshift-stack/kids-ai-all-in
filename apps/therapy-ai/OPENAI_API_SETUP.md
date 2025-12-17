# 🔑 OpenAI API Setup für Whisper

## 📝 OpenAI API Key benötigt

Für die Whisper API Integration brauchst du einen OpenAI API Key.

### Wo bekommst du den Key?

1. **Gehe zu:** https://platform.openai.com/api-keys
2. **Account erstellen** (falls noch nicht vorhanden)
3. **API Key generieren**
4. **Key kopieren** und sicher aufbewahren

### Kosten

- **Whisper API:** ~$0.006 pro Minute Audio
- **Beispiel:**
  - 10 Minuten/Tag = ~$1.80/Monat
  - 100 Minuten/Tag = ~$18/Monat

---

## 🔐 API Key speichern

### Option 1: In .env Datei (Empfohlen)

Füge zu deiner `.env` Datei hinzu:

```env
OPENAI_API_KEY=dein_api_key_hier
OPENAI_API_BASE_URL=https://api.openai.com/v1
```

### Option 2: Als Development Fallback

Der Key kann auch direkt in `EnvConfig` als Fallback gespeichert werden (nur für Development).

---

## ✅ Status

- ✅ WhisperSpeechService implementiert
- ✅ API-Integration fertig
- ⏸️ API Key benötigt

---

**Nächster Schritt:** OpenAI API Key besorgen und in `.env` speichern

