#!/bin/bash
# Alanko Setup Script für neue Entwickler
# Einmaliges Setup für lokale Entwicklung

set -e

# Farben für Output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}   🚀 Alanko AI - Development Setup   ${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Wechsel ins App-Verzeichnis
cd "$(dirname "$0")/.."

# Schritt 1: .env Datei
echo -e "${GREEN}[1/5] Prüfe .env Konfiguration...${NC}"
if [ -f .env ]; then
    echo -e "${GREEN}  ✓ .env Datei existiert${NC}"
else
    echo -e "${YELLOW}  ⚠ Erstelle .env aus .env.example${NC}"
    cp .env.example .env
    echo -e "${YELLOW}  ⚠ Bitte füge deinen GEMINI_API_KEY in .env ein!${NC}"
    echo -e "${YELLOW}    Hole einen Key: https://aistudio.google.com/apikey${NC}"
    echo ""
fi

# Schritt 2: Flutter Dependencies
echo -e "${GREEN}[2/5] Installiere Flutter Dependencies...${NC}"
flutter pub get

# Schritt 3: Code Generation (falls benötigt)
echo -e "${GREEN}[3/5] Prüfe Code Generation...${NC}"
if grep -q "build_runner" pubspec.yaml; then
    echo -e "${GREEN}  ⚠ Führe build_runner aus...${NC}"
    flutter pub run build_runner build --delete-conflicting-outputs
fi

# Schritt 4: Scripts ausführbar machen
echo -e "${GREEN}[4/5] Mache Scripts ausführbar...${NC}"
chmod +x scripts/*.sh

# Schritt 5: Prüfe API Key
echo -e "${GREEN}[5/5] Prüfe API-Key Konfiguration...${NC}"
if [ -f .env ]; then
    if grep -q "your_gemini_api_key_here" .env; then
        echo -e "${RED}  ❌ API-Key noch nicht konfiguriert!${NC}"
        echo -e "${YELLOW}  Bitte bearbeite .env und füge deinen Key ein${NC}"
    else
        echo -e "${GREEN}  ✓ API-Key konfiguriert${NC}"
    fi
fi

# Fertig!
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ Setup abgeschlossen!${NC}"
echo ""
echo -e "${BLUE}Nächste Schritte:${NC}"
echo -e "  1. Füge deinen API-Key in .env ein (falls noch nicht geschehen)"
echo -e "  2. Starte die App: ${GREEN}./scripts/run-dev.sh${NC}"
echo -e "  3. Oder drücke ${GREEN}F5${NC} in VS Code"
echo ""
echo -e "${BLUE}Weitere Infos:${NC}"
echo -e "  📖 README_API_SETUP.md - Detaillierte Dokumentation"
echo -e "  🌐 https://aistudio.google.com/apikey - API Key holen"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
