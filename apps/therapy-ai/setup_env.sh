#!/bin/bash

# Setup .env Datei für Therapy AI
# Führt dieses Skript aus: bash setup_env.sh

ENV_FILE="apps/therapy-ai/.env"

# Prüfe ob .env bereits existiert
if [ -f "$ENV_FILE" ]; then
    echo "⚠️  .env Datei existiert bereits!"
    read -p "Überschreiben? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Abgebrochen."
        exit 1
    fi
fi

# Erstelle .env Datei
cat > "$ENV_FILE" << 'EOF'
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
EOF

echo "✅ .env Datei erfolgreich erstellt in: $ENV_FILE"
echo "⚠️  WICHTIG: Bitte öffne die .env Datei und setze deinen ElevenLabs API Key!"
echo "   Du findest deinen API Key hier: https://elevenlabs.io/app/settings/api-keys"

