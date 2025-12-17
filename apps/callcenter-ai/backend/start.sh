#!/bin/bash

# Backend Start Script für Callcenter AI

echo "🚀 Starte Callcenter AI Backend..."

# Prüfe ob .env existiert
if [ ! -f .env ]; then
    echo "⚠️  .env Datei nicht gefunden!"
    echo "📝 Erstelle .env aus .env.example..."
    cp .env.example .env
    echo "✏️  Bitte GEMINI_API_KEY in .env eintragen!"
    exit 1
fi

# Lade .env
export $(cat .env | grep -v '^#' | xargs)

# Prüfe ob API Key gesetzt ist
if [ -z "$GEMINI_API_KEY" ]; then
    echo "❌ GEMINI_API_KEY nicht in .env gesetzt!"
    exit 1
fi

# Installiere Dependencies falls nötig
if [ ! -d "node_modules" ]; then
    echo "📦 Installiere Dependencies..."
    npm install
fi

# Starte Server
echo "✅ Starte Server auf Port ${PORT:-3000}..."
npm start

