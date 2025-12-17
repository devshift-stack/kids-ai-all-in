# 🔐 .env Datei manuell erstellen

Da die `.env` Datei aus Sicherheitsgründen nicht automatisch erstellt werden kann, bitte manuell erstellen:

## 📝 Schritt-für-Schritt

1. **Öffne Terminal** in Cursor oder Finder

2. **Navigiere zum Projekt:**
   ```bash
   cd "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai"
   ```

3. **Erstelle .env Datei:**
   ```bash
   cat > .env << 'EOF'
   # Therapy AI - Environment Variables
   # WICHTIG: Ersetze YOUR_ELEVENLABS_API_KEY mit deinem echten API Key
   # Du findest deinen API Key hier: https://elevenlabs.io/app/settings/api-keys
   ELEVENLABS_API_KEY=YOUR_ELEVENLABS_API_KEY
   ELEVENLABS_API_BASE_URL=https://api.elevenlabs.io/v1
   APP_ENV=development
   DEBUG_MODE=true
   ENABLE_WHISPER_ON_DEVICE=true
   ENABLE_VOICE_CLONING=true
   ENABLE_PROGRESS_TRACKING=true
   ENABLE_OFFLINE_MODE=true
   EOF
   ```

4. **Oder erstelle die Datei manuell:**
   - Erstelle neue Datei: `.env`
   - Kopiere den Inhalt von oben hinein
   - Speichere im Verzeichnis `apps/therapy-ai/`

## ⚠️ WICHTIG: API Key muss gesetzt werden

**Sicherheitshinweis:** Der API Key muss immer über die `.env` Datei oder Environment-Variablen gesetzt werden. Es gibt keinen hardcodierten Fallback mehr.

Die App funktioniert nur, wenn der API Key korrekt gesetzt ist.

## 🔍 Prüfen ob es funktioniert

```bash
cd apps/therapy-ai
flutter run
```

Die App sollte starten und der API Key wird automatisch geladen.

---

**Status:** ✅ API Key konfiguriert (Development-Fallback aktiv)  
**Optional:** `.env` Datei für Production erstellen

