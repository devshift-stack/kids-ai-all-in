#!/bin/bash

# Setup Script für tägliche Slack-Berichte

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PYTHON_SCRIPT="$SCRIPT_DIR/slack_notifier.py"

echo "🔧 Setup für Slack-Benachrichtigungen"
echo ""

# Prüfe ob Slack Webhook URL gesetzt ist
if [ -z "$SLACK_WEBHOOK_URL" ]; then
    echo "⚠️  SLACK_WEBHOOK_URL nicht gesetzt!"
    echo ""
    echo "Bitte setze die Environment Variable:"
    echo "  export SLACK_WEBHOOK_URL='https://hooks.slack.com/services/YOUR/WEBHOOK/URL'"
    echo ""
    echo "Oder füge sie zu deiner ~/.zshrc oder ~/.bashrc hinzu:"
    echo "  echo \"export SLACK_WEBHOOK_URL='YOUR_URL'\" >> ~/.zshrc"
    echo ""
    read -p "Möchtest du die URL jetzt eingeben? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Slack Webhook URL: " webhook_url
        echo "export SLACK_WEBHOOK_URL='$webhook_url'" >> ~/.zshrc
        export SLACK_WEBHOOK_URL="$webhook_url"
        echo "✅ URL gesetzt (in ~/.zshrc gespeichert)"
    else
        echo "❌ Setup abgebrochen"
        exit 1
    fi
fi

# Prüfe ob Python verfügbar ist
if ! command -v python3 &> /dev/null; then
    echo "❌ Python3 nicht gefunden!"
    exit 1
fi

# Prüfe ob requests installiert ist
if ! python3 -c "import requests" 2>/dev/null; then
    echo "📦 Installiere requests..."
    pip3 install requests
fi

# Mache Script ausführbar
chmod +x "$PYTHON_SCRIPT"

# Erstelle Cron-Job für tägliche Berichte (um 9:00 Uhr)
CRON_JOB="0 9 * * * cd $PROJECT_ROOT && export SLACK_WEBHOOK_URL='$SLACK_WEBHOOK_URL' && python3 $PYTHON_SCRIPT daily >> /tmp/slack_notifier.log 2>&1"

# Prüfe ob Cron-Job bereits existiert
if crontab -l 2>/dev/null | grep -q "slack_notifier.py daily"; then
    echo "⚠️  Cron-Job existiert bereits"
    read -p "Möchtest du ihn aktualisieren? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Entferne alten Cron-Job
        crontab -l 2>/dev/null | grep -v "slack_notifier.py daily" | crontab -
        # Füge neuen hinzu
        (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
        echo "✅ Cron-Job aktualisiert"
    fi
else
    # Füge neuen Cron-Job hinzu
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "✅ Cron-Job hinzugefügt (täglich um 9:00 Uhr)"
fi

echo ""
echo "📋 Aktuelle Cron-Jobs:"
crontab -l | grep slack_notifier || echo "Keine gefunden"

echo ""
echo "✅ Setup abgeschlossen!"
echo ""
echo "Manuelle Tests:"
echo "  python3 $PYTHON_SCRIPT daily          # Täglicher Bericht"
echo "  python3 $PYTHON_SCRIPT urgent <msg>   # Dringende Nachricht"

