# Slack-Benachrichtigungen - Quick Start

## Was wird gemacht?

Automatische tägliche Berichte auf Slack um 9:00 Uhr + Möglichkeit für dringende Nachrichten.

## Setup (3 Schritte)

### 1. Slack Webhook erstellen (2 Minuten)
- https://api.slack.com/apps → Neue App erstellen
- "Incoming Webhooks" aktivieren
- Webhook zu Workspace hinzufügen → Channel wählen
- **Webhook URL kopieren** (beginnt mit `https://hooks.slack.com/services/...`)

### 2. URL setzen
```bash
export SLACK_WEBHOOK_URL='DEINE_WEBHOOK_URL_HIER'
echo "export SLACK_WEBHOOK_URL='DEINE_WEBHOOK_URL_HIER'" >> ~/.zshrc
```

### 3. Automatisches Setup
```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
./scripts/setup_slack_cron.sh
```

**Fertig!** Täglich um 9:00 Uhr kommt automatisch ein Bericht.

## Manuelle Nutzung

```bash
# Täglicher Bericht jetzt senden
python3 scripts/slack_notifier.py daily

# Dringende Nachricht (wenn ich dich erreichen muss)
python3 scripts/slack_notifier.py urgent "Nachricht hier"
```

## Was kommt im täglichen Bericht?

- ✅ System-Status (Backend, App, API)
- 📅 Datum/Zeit
- 📊 Aktuelle Aktivitäten
- 🔄 Nächste Schritte

## Beispiel-Nachricht

```
📊 Täglicher Callcenter AI Bericht

✅ Callcenter AI System läuft
📅 Datum: 17.12.2024
⏰ Zeit: 09:00:00

System-Status:
• Backend: Verfügbar
• Flutter App: Bereit  
• Gemini API: Konfiguriert
```

---

**Detaillierte Dokumentation:** Siehe `SLACK_SETUP.md` (falls nötig)

