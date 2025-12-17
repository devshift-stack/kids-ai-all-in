#!/bin/bash
# Alanko AI - Play Store Build Script
# Erstellt Android App Bundle (AAB) für Play Store Upload

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   📦 Alanko AI - Play Store Build                        ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# Wechsel ins App-Verzeichnis
cd "$(dirname "$0")/.."

# API-Key prüfen
if [ -z "$GEMINI_API_KEY" ]; then
    if [ -f .env ]; then
        echo -e "${YELLOW}⚠ Lade GEMINI_API_KEY aus .env${NC}"
        export $(cat .env | grep -v '^#' | xargs)
    else
        echo -e "${RED}❌ GEMINI_API_KEY nicht gesetzt!${NC}"
        echo -e "${YELLOW}   Option 1: export GEMINI_API_KEY=your_key${NC}"
        echo -e "${YELLOW}   Option 2: Erstelle .env Datei${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ API-Key: ${GEMINI_API_KEY:0:20}...${NC}"
echo ""

# Version prüfen
VERSION=$(grep "^version:" pubspec.yaml | awk '{print $2}')
echo -e "${BLUE}📋 Version: $VERSION${NC}"
echo -e "${YELLOW}   Bitte prüfe, ob Version erhöht wurde!${NC}"
read -p "   Fortfahren? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${RED}❌ Abgebrochen${NC}"
    exit 1
fi

# Clean
echo -e "${YELLOW}🧹 Cleanup...${NC}"
flutter clean

# Dependencies
echo -e "${YELLOW}📥 Dependencies...${NC}"
flutter pub get

# Build AAB
echo -e "${YELLOW}🔨 Baue Release AAB...${NC}"
echo -e "${YELLOW}   • Mit Obfuscation${NC}"
echo -e "${YELLOW}   • Mit API-Key${NC}"
echo -e "${YELLOW}   • Release-Mode${NC}"
echo ""

flutter build appbundle \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release \
    --obfuscate \
    --split-debug-info=debug-info

# Output
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"
AAB_SIZE=$(du -h "$AAB_PATH" | awk '{print $1}')

echo ""
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✅ BUILD ERFOLGREICH!                                  ${NC}"
echo -e "${GREEN}════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}📦 AAB:${NC}     $AAB_PATH"
echo -e "${GREEN}📊 Größe:${NC}   $AAB_SIZE"
echo -e "${GREEN}🔢 Version:${NC} $VERSION"
echo ""
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   🚀 NÄCHSTE SCHRITTE                                    ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "1. ${GREEN}Play Console öffnen:${NC}"
echo -e "   → https://play.google.com/console"
echo ""
echo -e "2. ${GREEN}Alanko AI auswählen${NC}"
echo ""
echo -e "3. ${GREEN}Neues Release:${NC}"
echo -e "   → Produktion → Neues Release erstellen"
echo ""
echo -e "4. ${GREEN}AAB hochladen:${NC}"
echo -e "   → $AAB_PATH"
echo ""
echo -e "5. ${GREEN}Release Notes eingeben${NC}"
echo ""
echo -e "6. ${GREEN}Zur Prüfung senden${NC}"
echo ""
echo -e "${YELLOW}⚠ WICHTIG:${NC}"
echo -e "   • Screenshots aktuell?"
echo -e "   • Privacy Policy aktuell?"
echo -e "   • Signing Key korrekt?"
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
