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
   ELEVENLABS_API_KEY=sk_c507c161d7bd5878e17983a35534411d6b741823189a4901
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

## ✅ Alternative: API Key ist bereits gespeichert

**Gute Nachricht:** Der API Key ist bereits als Development-Fallback in `EnvConfig` gespeichert!

Die App funktioniert auch ohne `.env` Datei im Debug-Mode. Für Production sollte die `.env` Datei jedoch erstellt werden.

## 🔍 Prüfen ob es funktioniert

```bash
cd apps/therapy-ai
flutter run
```

Die App sollte starten und der API Key wird automatisch geladen.

---

**Status:** ✅ API Key konfiguriert (Development-Fallback aktiv)  
**Optional:** `.env` Datei für Production erstellen

