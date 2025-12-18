#!/bin/bash
# 🛡️ Firewall & Security Setup für macOS

echo "🚨 ALARMSTUFE ROT - Firewall aktivieren"

# Firewall Status prüfen
echo "📊 Aktueller Firewall-Status:"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate

# Firewall aktivieren
echo "🔒 Aktiviere Firewall..."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Stealth Mode aktivieren (versteckt den Mac im Netzwerk)
echo "🥷 Aktiviere Stealth Mode..."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Block all incoming connections
echo "🚫 Blockiere alle eingehenden Verbindungen..."
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setblockall on

# Zeige Firewall-Logs
echo "📋 Firewall-Logs (letzte 20 Einträge):"
log show --predicate 'process == "socketfilterfw"' --last 5m --style compact | tail -20

echo "✅ Firewall-Konfiguration abgeschlossen"

