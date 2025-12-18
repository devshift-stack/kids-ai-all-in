#!/bin/bash
# 🛡️ PREMIUM FIREWALL SETUP - Nur Firewall-Konfiguration
# Benötigt: sudo

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

if [[ $EUID -ne 0 ]]; then
    error "Dieses Skript benötigt Root-Rechte. Bitte mit sudo ausführen."
    exit 1
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║  🛡️  PREMIUM FIREWALL SETUP                                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

log "Prüfe aktuellen Firewall-Status..."
CURRENT_FW_STATE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || echo "unknown")
log "Aktueller Status: $CURRENT_FW_STATE"
echo ""

log "🔒 Aktiviere Firewall..."
if /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on 2>/dev/null; then
    success "Firewall aktiviert"
else
    error "Fehler beim Aktivieren der Firewall"
    exit 1
fi

log "🥷 Aktiviere Stealth Mode..."
if /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on 2>/dev/null; then
    success "Stealth Mode aktiviert"
else
    warning "Fehler beim Aktivieren von Stealth Mode"
fi

log "🚫 Konfiguriere Firewall-Regeln..."
# Block All: OFF (erlaubt legitime Verbindungen, blockiert nur verdächtige)
if /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall off 2>/dev/null; then
    success "Firewall-Regeln konfiguriert (Block All: OFF)"
else
    warning "Fehler beim Konfigurieren der Firewall-Regeln"
fi

log "📋 Zeige Firewall-Status..."
NEW_FW_STATE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate 2>/dev/null || echo "unknown")
log "Neuer Status: $NEW_FW_STATE"

STEALTH_STATE=$(/usr/libexec/ApplicationFirewall/socketfilterfw --getstealthmode 2>/dev/null | grep -i "enabled\|disabled" || echo "unknown")
log "Stealth Mode: $STEALTH_STATE"

echo ""
success "Firewall-Konfiguration abgeschlossen!"
log "Firewall-Logs: log show --predicate 'process == \"socketfilterfw\"' --last 5m"

