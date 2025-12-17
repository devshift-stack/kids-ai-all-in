#!/bin/bash
# Alanko iOS Build Script
# Baut eine Release-IPA mit API-Keys

set -e

# Farben für Output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${GREEN}📦 Baue Alanko iOS IPA...${NC}"

# Wechsel ins App-Verzeichnis
cd "$(dirname "$0")/.."

# Prüfe ob wir auf macOS sind
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}❌ iOS Builds funktionieren nur auf macOS!${NC}"
    exit 1
fi

# Lade .env wenn vorhanden
if [ -f .env ]; then
    echo -e "${GREEN}✓ Lade .env Datei${NC}"
    export $(cat .env | grep -v '^#' | xargs)
fi

# Prüfe ob GEMINI_API_KEY gesetzt ist
if [ -z "$GEMINI_API_KEY" ]; then
    echo -e "${RED}❌ GEMINI_API_KEY nicht gesetzt!${NC}"
    echo -e "${YELLOW}  Option 1: export GEMINI_API_KEY=your_key${NC}"
    echo -e "${YELLOW}  Option 2: Erstelle .env Datei${NC}"
    exit 1
fi

echo -e "${GREEN}✓ API-Key gefunden${NC}"

# Clean build
echo -e "${GREEN}🧹 Räume alte Builds auf...${NC}"
flutter clean

# Get dependencies
echo -e "${GREEN}📥 Hole Dependencies...${NC}"
flutter pub get

# Build IPA
echo -e "${GREEN}🔨 Baue Release IPA...${NC}"
flutter build ipa \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release

# Output Info
echo ""
echo -e "${GREEN}✅ Build erfolgreich!${NC}"
echo ""
echo -e "${GREEN}📱 IPA Datei:${NC}"
ls -lh build/ios/ipa/*.ipa 2>/dev/null || echo "IPA im build/ios/ipa/ Verzeichnis"
echo ""
echo -e "${GREEN}📍 Pfad: $(pwd)/build/ios/ipa/${NC}"
