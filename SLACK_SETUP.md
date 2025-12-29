# Slack-Benachrichtigungen Setup

Automatische tägliche Berichte und Benachrichtigungen für Callcenter AI.

## Setup

### 1. Slack Webhook erstellen

1. Gehe zu https://api.slack.com/apps
2. Erstelle eine neue App oder wähle eine bestehende
3. Gehe zu "Incoming Webhooks"
4. Aktiviere "Activate Incoming Webhooks"
5. Klicke auf "Add New Webhook to Workspace"
6. Wähle den Channel (z.B. #callcenter-ai-updates)
7. Kopiere die Webhook URL

### 2. Environment Variable setzen

```bash
export SLACK_WEBHOOK_URL='https://hooks.slack.com/services/YOUR/WEBHOOK/URL'
```

Oder permanent in `~/.zshrc` oder `~/.bashrc`:

```bash
echo "export SLACK_WEBHOOK_URL='YOUR_URL'" >> ~/.zshrc
source ~/.zshrc
```

### 3. Automatisches Setup ausführen

```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
chmod +x scripts/setup_slack_cron.sh
./scripts/setup_slack_cron.sh
```

Das Script:
- Prüft ob Python3 verfügbar ist
- Installiert `requests` falls nötig
- Erstellt einen Cron-Job für tägliche Berichte (9:00 Uhr)

## Verwendung

### Täglicher Bericht (automatisch)

Der Cron-Job sendet täglich um 9:00 Uhr einen Status-Bericht.

### Manuelle Berichte

```bash
# Täglicher Bericht manuell senden
python3 scripts/slack_notifier.py daily

# Dringende Benachrichtigung
python3 scripts/slack_notifier.py urgent "Backend ist offline!"
```

### Dringende Benachrichtigungen

Wenn du den Benutzer erreichen musst:

```bash
python3 scripts/slack_notifier.py urgent "Nachricht hier" "Grund hier"
```

## Cron-Job verwalten

```bash
# Aktuelle Cron-Jobs anzeigen
crontab -l

# Cron-Job bearbeiten
crontab -e

# Cron-Job entfernen
crontab -l | grep -v "slack_notifier.py" | crontab -
```

## Anpassungen

### Berichtszeit ändern

In `setup_slack_cron.sh` die Zeit ändern:
```bash
# Aktuell: 9:00 Uhr (0 9 * * *)
# Für 18:00 Uhr: 0 18 * * *
```

### Berichtsinhalt anpassen

Bearbeite `scripts/slack_notifier.py`:
- `daily_report()` Funktion für Berichtsinhalt
- Status-Checks hinzufügen (Backend, API-Quota, etc.)

## Troubleshooting

### Webhook URL nicht gesetzt
```bash
echo $SLACK_WEBHOOK_URL  # Sollte URL zeigen
```

### Python requests nicht installiert
```bash
pip3 install requests
```

### Cron-Job läuft nicht
```bash
# Prüfe Logs
tail -f /tmp/slack_notifier.log

# Teste manuell
python3 scripts/slack_notifier.py daily
```

## Beispiel-Nachrichten

### Täglicher Bericht
```
📊 Täglicher Callcenter AI Bericht

📊 **Täglicher Status-Bericht**

✅ Callcenter AI System läuft
📅 Datum: 17.12.2024
⏰ Zeit: 09:00:00

**System-Status:**
• Backend: Verfügbar
• Flutter App: Bereit
• Gemini API: Konfiguriert
```

### Dringende Benachrichtigung
```
🚨 Dringende Benachrichtigung

🚨 **WICHTIG: Benutzer muss erreicht werden**

**Nachricht:**
Backend ist offline!

**Grund:**
Server nicht erreichbar
```

