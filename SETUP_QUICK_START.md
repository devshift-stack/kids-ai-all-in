# ⚡ QUICK START - Premium Agent System

## 🚀 In 3 Minuten startklar

### 1. Slack Webhooks einrichten (2 Min)

```bash
# Webhook URLs setzen
export SLACK_WEBHOOK_URL='https://hooks.slack.com/services/YOUR/WEBHOOK/URL1'
export SLACK_WEBHOOK_URL_2='https://hooks.slack.com/services/YOUR/WEBHOOK/URL2'
export SLACK_WEBHOOK_URL_3='https://hooks.slack.com/services/YOUR/WEBHOOK/URL3'

# Testen
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
python3 scripts/slack_multi_user.py message "Test" "System" "normal"
```

### 2. Dashboard starten (30 Sek)

```bash
python3 scripts/dashboard_system.py --slack
```

### 3. Premium Agents testen (30 Sek)

```bash
cd apps/callcenter-ai/backend
npm install
npm start
```

**API Test:**
```bash
# Premium Sales Agent für Solar
curl -X POST http://localhost:3000/api/v1/premium/sessions \
  -H "Content-Type: application/json" \
  -d '{"agentType":"sales","productCategory":"solar","language":"german"}'

# Chat mit Agent
curl -X POST http://localhost:3000/api/v1/premium/sessions/SESSION_ID/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Hallo, ich interessiere mich für Solar"}'
```

### 4. Repo-Analyse (1 Min)

```bash
python3 scripts/repo_analyzer.py
```

---

## ✅ Fertig!

Alle 4 Punkte sind implementiert:
1. ✅ Slack/Teams Multi-User Chat
2. ✅ Dashboard-System
3. ✅ Premium Agent-System (Sales, Vertrieb, Kundendienst, Innendienst)
4. ✅ Repo-Analyse + Agent-Kommunikation

**Detaillierte Dokumentation:** Siehe `PREMIUM_AGENT_SETUP.md`

