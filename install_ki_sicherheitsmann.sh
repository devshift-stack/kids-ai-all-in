#!/bin/bash
# 🛡️ INSTALLATION: KI-Sicherheitsmann
# Installiert den KI-Sicherheitsmann als LaunchAgent (läuft automatisch)

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🛡️  KI-SICHERHEITSMANN INSTALLATION                       ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

# Prüfe Python
log "Prüfe Python-Installation..."
if ! command -v python3 &> /dev/null; then
    error "Python3 nicht gefunden. Bitte installieren: brew install python3"
    exit 1
fi

PYTHON_VERSION=$(python3 --version)
success "Python gefunden: $PYTHON_VERSION"

# Prüfe ob Script existiert
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_FILE="$SCRIPT_DIR/ki_sicherheitsmann.py"

if [[ ! -f "$SCRIPT_FILE" ]]; then
    error "ki_sicherheitsmann.py nicht gefunden: $SCRIPT_FILE"
    exit 1
fi

success "Script gefunden: $SCRIPT_FILE"

# Mache Script ausführbar
log "Mache Script ausführbar..."
chmod +x "$SCRIPT_FILE"
success "Script ist ausführbar"

# Erstelle LaunchAgent
log "Erstelle LaunchAgent..."
LAUNCH_AGENTS_DIR="$HOME/Library/LaunchAgents"
LAUNCH_AGENT_FILE="$LAUNCH_AGENTS_DIR/com.ki-sicherheitsmann.plist"

mkdir -p "$LAUNCH_AGENTS_DIR"

cat > "$LAUNCH_AGENT_FILE" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.ki-sicherheitsmann</string>
    <key>ProgramArguments</key>
    <array>
        <string>$(which python3)</string>
        <string>$SCRIPT_FILE</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>StandardOutPath</key>
    <string>$HOME/.ki_sicherheitsmann/launchd.log</string>
    <key>StandardErrorPath</key>
    <string>$HOME/.ki_sicherheitsmann/launchd.error.log</string>
    <key>WorkingDirectory</key>
    <string>$SCRIPT_DIR</string>
</dict>
</plist>
EOF

success "LaunchAgent erstellt: $LAUNCH_AGENT_FILE"

# Lade LaunchAgent
log "Lade LaunchAgent..."
if launchctl load "$LAUNCH_AGENT_FILE" 2>/dev/null; then
    success "LaunchAgent geladen"
elif launchctl load -w "$LAUNCH_AGENT_FILE" 2>/dev/null; then
    success "LaunchAgent geladen (mit -w Flag)"
else
    warning "LaunchAgent konnte nicht automatisch geladen werden"
    warning "Bitte manuell laden mit: launchctl load $LAUNCH_AGENT_FILE"
fi

# Prüfe Status
log "Prüfe Status..."
sleep 2
if launchctl list | grep -q "com.ki-sicherheitsmann"; then
    success "KI-Sicherheitsmann läuft!"
else
    warning "KI-Sicherheitsmann scheint nicht zu laufen"
    warning "Starte manuell mit: launchctl start com.ki-sicherheitsmann"
fi

echo ""
success "Installation abgeschlossen!"
echo ""
log "Verzeichnisse:"
log "  Config: $HOME/.ki_sicherheitsmann/config.json"
log "  Logs: $HOME/.ki_sicherheitsmann/security.log"
log "  Reports: $HOME/.ki_sicherheitsmann/reports/"
echo ""
log "Befehle:"
log "  Status prüfen: launchctl list | grep ki-sicherheitsmann"
log "  Manuell starten: launchctl start com.ki-sicherheitsmann"
log "  Stoppen: launchctl stop com.ki-sicherheitsmann"
log "  Entladen: launchctl unload $LAUNCH_AGENT_FILE"
log "  Logs ansehen: tail -f $HOME/.ki_sicherheitsmann/security.log"
echo ""

