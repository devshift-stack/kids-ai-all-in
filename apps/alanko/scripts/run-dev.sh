#!/bin/bash
# Alanko Development Run Script
# Startet die App im Development-Modus mit API-Keys

set -e

# Farben für Output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Starte Alanko Development...${NC}"

# Wechsel ins App-Verzeichnis
cd "$(dirname "$0")/.."

# Lade .env wenn vorhanden
if [ -f .env ]; then
    echo -e "${GREEN}✓ Lade .env Datei${NC}"
    export $(cat .env | grep -v '^#' | xargs)
else
    echo -e "${YELLOW}⚠ Keine .env Datei gefunden!${NC}"
    echo -e "${YELLOW}  Erstelle eine aus .env.example: cp .env.example .env${NC}"
fi

# Prüfe ob GEMINI_API_KEY gesetzt ist
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${RED}❌ GEMINI_API_KEY nicht gesetzt!${NC}"
    echo -e "${YELLOW}  1. Kopiere .env.example zu .env${NC}"
    echo -e "${YELLOW}  2. Füge deinen API-Key ein${NC}"
    echo -e "${YELLOW}  3. Siehe README_API_SETUP.md für Details${NC}"
    exit 1
fi

echo -e "${GREEN}✓ API-Key gefunden${NC}"
echo -e "${GREEN}✓ Starte Flutter...${NC}"

# Starte die App
flutter run \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    "$@"
