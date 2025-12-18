#!/bin/bash
# 🚨 Beende verdächtige Prozesse

echo "🚨 ALARMSTUFE ROT - Verdächtige Prozesse beenden"

# Finde Prozesse mit hoher CPU (>50%)
echo "🔍 Suche nach verdächtigen Prozessen..."

# Flutter/Dart Prozesse mit hoher CPU
PIDS=$(ps aux | awk '$3 > 50.0 && /dartvm|flutterfire/ {print $2}')

if [ -z "$PIDS" ]; then
    echo "✅ Keine verdächtigen Prozesse gefunden"
else
    echo "🔴 Gefundene verdächtige Prozesse:"
    ps aux | awk '$3 > 50.0 && /dartvm|flutterfire/ {print "PID:", $2, "CPU:", $3"%", "CMD:", $11}'
    
    echo ""
    read -p "⚠️  Diese Prozesse beenden? (j/n): " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Jj]$ ]]; then
        for PID in $PIDS; do
            echo "🛑 Beende Prozess $PID..."
            kill -9 $PID 2>/dev/null && echo "✅ Prozess $PID beendet" || echo "❌ Fehler beim Beenden von $PID"
        done
        echo "✅ Alle verdächtigen Prozesse beendet"
    else
        echo "❌ Abgebrochen"
    fi
fi

