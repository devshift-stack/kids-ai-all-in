#!/bin/bash
# Build Script für alle 3 Kids AI Apps
# Erstellt Android App Bundles (AAB) für Play Store Upload

set -e

# Farben
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   📦 Kids AI - Build Alle Apps für Play Store          ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

# API Key prüfen
if [ -z "$GEMINI_API_KEY" ]; then
    if [ -f "apps/alanko/.env" ]; then
        echo -e "${YELLOW}⚠ GEMINI_API_KEY nicht gesetzt, lade aus .env${NC}"
        export $(cat apps/alanko/.env | grep -v '^#' | xargs)
    else
        echo -e "${RED}❌ GEMINI_API_KEY nicht gesetzt!${NC}"
        echo -e "${YELLOW}   export GEMINI_API_KEY=your_key${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ API-Key gefunden${NC}"
echo ""

# Build-Verzeichnis erstellen
BUILD_DIR="builds/$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BUILD_DIR"

echo -e "${BLUE}📁 Build-Verzeichnis: $BUILD_DIR${NC}"
echo ""

# ============================================================
# 1. ALANKO APP
# ============================================================
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   1️⃣  Baue Alanko AI                                     ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

cd apps/alanko

echo -e "${YELLOW}🧹 Cleanup...${NC}"
flutter clean

echo -e "${YELLOW}📥 Dependencies...${NC}"
flutter pub get

echo -e "${YELLOW}🔨 Baue Release AAB...${NC}"
flutter build appbundle \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release \
    --obfuscate \
    --split-debug-info=../../$BUILD_DIR/alanko-debug-info

# Kopiere AAB
cp build/app/outputs/bundle/release/app-release.aab "../../$BUILD_DIR/alanko-release.aab"

echo -e "${GREEN}✅ Alanko AAB erstellt!${NC}"
echo ""

cd ../..

# ============================================================
# 2. LIANKO APP
# ============================================================
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   2️⃣  Baue Lianko AI                                     ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

cd apps/lianko

echo -e "${YELLOW}🧹 Cleanup...${NC}"
flutter clean

echo -e "${YELLOW}📥 Dependencies...${NC}"
flutter pub get

echo -e "${YELLOW}🔨 Baue Release AAB...${NC}"
flutter build appbundle \
    --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY \
    --release \
    --obfuscate \
    --split-debug-info=../../$BUILD_DIR/lianko-debug-info

# Kopiere AAB
cp build/app/outputs/bundle/release/app-release.aab "../../$BUILD_DIR/lianko-release.aab"

echo -e "${GREEN}✅ Lianko AAB erstellt!${NC}"
echo ""

cd ../..

# ============================================================
# 3. PARENT APP
# ============================================================
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   3️⃣  Baue Parent Dashboard                              ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

cd apps/parent

echo -e "${YELLOW}🧹 Cleanup...${NC}"
flutter clean

echo -e "${YELLOW}📥 Dependencies...${NC}"
flutter pub get

echo -e "${YELLOW}🔨 Baue Release AAB...${NC}"
flutter build appbundle \
    --release \
    --obfuscate \
    --split-debug-info=../../$BUILD_DIR/parent-debug-info

# Kopiere AAB
cp build/app/outputs/bundle/release/app-release.aab "../../$BUILD_DIR/parent-release.aab"

echo -e "${GREEN}✅ Parent AAB erstellt!${NC}"
echo ""

cd ../..

# ============================================================
# ZUSAMMENFASSUNG
# ============================================================
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}   ✅ ALLE BUILDS ERFOLGREICH!                           ${NC}"
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${GREEN}📦 Android App Bundles (AAB):${NC}"
echo ""
ls -lh "$BUILD_DIR"/*.aab | awk '{print "   " $9 " (" $5 ")"}'
echo ""

echo -e "${BLUE}📍 Pfad:${NC} $(pwd)/$BUILD_DIR"
echo ""

echo -e "${YELLOW}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║  🚀 NÄCHSTE SCHRITTE - PLAY STORE UPLOAD               ║${NC}"
echo -e "${YELLOW}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}1. Alanko AI:${NC}"
echo -e "   → https://play.google.com/console"
echo -e "   → Alanko App auswählen"
echo -e "   → Produktion → Neues Release erstellen"
echo -e "   → Upload: ${BUILD_DIR}/alanko-release.aab"
echo ""
echo -e "${GREEN}2. Lianko AI:${NC}"
echo -e "   → https://play.google.com/console"
echo -e "   → Lianko App auswählen"
echo -e "   → Produktion → Neues Release erstellen"
echo -e "   → Upload: ${BUILD_DIR}/lianko-release.aab"
echo ""
echo -e "${GREEN}3. Parent Dashboard:${NC}"
echo -e "   → https://play.google.com/console"
echo -e "   → Parent App auswählen"
echo -e "   → Produktion → Neues Release erstellen"
echo -e "   → Upload: ${BUILD_DIR}/parent-release.aab"
echo ""
echo -e "${YELLOW}⚠ WICHTIG:${NC}"
echo -e "   • Versionsnummer in pubspec.yaml erhöhen!"
echo -e "   • Release Notes schreiben"
echo -e "   • Screenshots aktualisieren (falls geändert)"
echo ""
echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"
