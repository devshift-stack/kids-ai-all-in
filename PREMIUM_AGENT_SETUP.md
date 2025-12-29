# 🚀 Premium Agent-System - Komplett-Setup

**Erstellt:** $(date)  
**Status:** ✅ Vollständig implementiert

---

## 📋 Übersicht

Dieses System umfasst:

1. ✅ **Slack/Teams Multi-User Chat** - 3 Personen im Chat
2. ✅ **Dashboard-System** - Übersicht über alle Repos, Fortschritte, Sicherheit, Entwickler
3. ✅ **Premium Agent-System** - Sales, Vertrieb, Kundendienst, Innendienst
4. ✅ **Repo-Analyse** - Optimierungen, Verbesserungen, Entwickler-Zuordnung
5. ✅ **Agent-Kommunikation** - 3 Agenten teilen Wissen und denken zusammen

---

## 🔧 Setup

### 1. Slack/Teams Multi-User Chat

#### Slack Webhooks einrichten:

```bash
# Webhook URLs setzen (für 3 User)
export SLACK_WEBHOOK_URL='https://hooks.slack.com/services/YOUR/WEBHOOK/URL1'
export SLACK_WEBHOOK_URL_2='https://hooks.slack.com/services/YOUR/WEBHOOK/URL2'
export SLACK_WEBHOOK_URL_3='https://hooks.slack.com/services/YOUR/WEBHOOK/URL3'

# Optional: Teams Webhook
export TEAMS_WEBHOOK_URL='https://outlook.office.com/webhook/...'

# Permanent speichern
echo "export SLACK_WEBHOOK_URL='...'" >> ~/.zshrc
echo "export SLACK_WEBHOOK_URL_2='...'" >> ~/.zshrc
echo "export SLACK_WEBHOOK_URL_3='...'" >> ~/.zshrc
source ~/.zshrc
```

#### Testen:

```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
python3 scripts/slack_multi_user.py message "Test-Nachricht" "System" "normal"
```

---

### 2. Dashboard-System

#### Dashboard generieren:

```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
python3 scripts/dashboard_system.py
```

#### Dashboard an Slack senden:

```bash
python3 scripts/dashboard_system.py --slack
```

#### Automatisch täglich:

```bash
# Cron-Job einrichten (täglich um 9:00 Uhr)
crontab -e

# Hinzufügen:
0 9 * * * cd "/Users/dsselmanovic/cursor project/kids-ai-all-in" && python3 scripts/dashboard_system.py --slack
```

---

### 3. Premium Agent-System

#### Backend starten:

```bash
cd apps/callcenter-ai/backend
npm install
npm start
```

#### Agenten verwenden:

```javascript
import { AgentFactory, PRODUCT_CATEGORIES } from './premium_agents.js';

// Sales-Agent für Solar
const salesAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.SOLAR, 'german');
await salesAgent.startChat();
const response = await salesAgent.sendMessage("Hallo, ich interessiere mich für Solar");

// Sales-Agent für Strom
const stromAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.STROM, 'german');

// Sales-Agent für Handy
const handyAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.HANDY, 'german');

// Vertriebs-Agent
const vertriebAgent = AgentFactory.createVertriebAgent(PRODUCT_CATEGORIES.SOLAR, 'german');

// Kundendienst-Agent
const kundendienstAgent = AgentFactory.createKundendienstAgent(PRODUCT_CATEGORIES.SOLAR, 'german');

// Innendienst-Agent
const innendienstAgent = AgentFactory.createInnendienstAgent(PRODUCT_CATEGORIES.SOLAR, 'german');
```

#### Integration in Backend:

Die Premium Agents sind bereits in `backend/premium_agents.js` implementiert.  
Integration in `backend/server.js`:

```javascript
import { AgentFactory, PRODUCT_CATEGORIES } from './premium_agents.js';

// In Route verwenden:
app.post('/api/v1/sessions', (req, res) => {
  const { agentType = 'sales', productCategory = 'solar', language = 'german' } = req.body;
  
  let agent;
  if (agentType === 'sales') {
    agent = AgentFactory.createSalesAgent(productCategory, language);
  } else if (agentType === 'vertrieb') {
    agent = AgentFactory.createVertriebAgent(productCategory, language);
  }
  // ... etc
});
```

---

### 4. Repo-Analyse

#### Alle Repos analysieren:

```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
python3 scripts/repo_analyzer.py
```

#### Output:

- Terminal-Report mit allen Ergebnissen
- `repo_analysis_complete.json` mit vollständigen Daten

---

### 5. Agent-Kommunikation

#### Wissen teilen:

```bash
python3 scripts/agent_communication.py share "Agent1" "customer_123" "Interessiert an Solar, Budget 5000€"
```

#### Wissen abrufen:

```bash
python3 scripts/agent_communication.py get "customer_123"
```

#### Agent registrieren:

```bash
python3 scripts/agent_communication.py register "SalesAgent" "sales,solar,strom"
```

#### Experte finden:

```bash
python3 scripts/agent_communication.py find "solar"
```

#### Nachricht senden:

```bash
python3 scripts/agent_communication.py message "SalesAgent" "KundendienstAgent" "Kunde hat Frage zu Installation"
```

#### Kontext abrufen:

```bash
python3 scripts/agent_communication.py context "SalesAgent"
```

---

## 🔗 Integration aller Komponenten

### Automatisches Dashboard + Slack:

```bash
# Script erstellen: scripts/daily_update.sh
#!/bin/bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"

# Dashboard generieren und an Slack senden
python3 scripts/dashboard_system.py --slack

# Repo-Analyse durchführen
python3 scripts/repo_analyzer.py

# Agent-Kommunikation Status
python3 scripts/agent_communication.py context "System"
```

### Agent-Kollaboration Beispiel:

```python
from agent_communication import get_agent_communication

comm = get_agent_communication()

# Sales-Agent teilt Wissen
comm.share_knowledge("SalesAgent", "customer_123", {
    "product": "solar",
    "budget": 5000,
    "status": "interested"
})

# Kundendienst-Agent holt Wissen
customer_info = comm.get_knowledge("customer_123")
print(f"Kunde Info: {customer_info}")
```

---

## 📊 Agent-Typen und Produkte

### Agent-Typen:

- **SALES** - Verkaufsagent (Telefonverkauf)
- **VERTRIEB** - Vertriebsprofi (B2B, Großprojekte)
- **KUNDENDIENST** - Support und Hilfe
- **INNENDIENST** - Interne Koordination

### Produktkategorien:

- **SOLAR** - Solarmodule
- **STROM** - Stromverträge
- **HANDY** - Handyverträge und Smartphones

### Sprachen:

- **german** - Deutsch (Standard)
- Weitere Sprachen können hinzugefügt werden

---

## 🎯 Verwendung für Deutschland: Solar, Strom, Handy

### Solar-Verkauf:

```javascript
const solarAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.SOLAR, 'german');
// Agent ist spezialisiert auf:
// - EEG-Vergütung
// - Steuerliche Absetzbarkeit
// - Amortisation 8-12 Jahre
// - Umweltschutz
```

### Strom-Verkauf:

```javascript
const stromAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.STROM, 'german');
// Agent ist spezialisiert auf:
// - Stromanbieter-Wechsel
// - Einsparpotenzial 200-500€/Jahr
// - Ökostrom-Optionen
// - Flexible Vertragslaufzeiten
```

### Handy-Verkauf:

```javascript
const handyAgent = AgentFactory.createSalesAgent(PRODUCT_CATEGORIES.HANDY, 'german');
// Agent ist spezialisiert auf:
// - Handyverträge (Prepaid, Vertrag, Business)
// - Smartphone-Empfehlungen
// - Datenvolumen und Minuten
// - 5G-Verfügbarkeit
```

---

## 🔄 Agent-Kommunikation Workflow

1. **Sales-Agent** spricht mit Kunde
2. **Sales-Agent** teilt Wissen: `comm.share_knowledge("SalesAgent", "customer_123", {...})`
3. **Kundendienst-Agent** sieht geteiltes Wissen: `comm.get_knowledge("customer_123")`
4. **Innendienst-Agent** koordiniert Follow-up
5. Alle Agenten sehen Kontext: `comm.get_agent_context("AgentName")`

---

## 📈 Dashboard-Features

- ✅ Repository-Status (alle Apps)
- ✅ Git-Statistiken (Commits, Branches, Files)
- ✅ Sicherheitsstatus (API Keys, Passwörter)
- ✅ Entwickler-Statistiken (Commits, Files changed)
- ✅ Automatische Slack-Benachrichtigungen

---

## 🚨 Troubleshooting

### Slack Webhook funktioniert nicht:

```bash
# Prüfe Environment Variable
echo $SLACK_WEBHOOK_URL

# Teste manuell
python3 scripts/slack_multi_user.py message "Test" "System" "normal"
```

### Dashboard zeigt keine Daten:

```bash
# Prüfe ob Git-Repos vorhanden
cd apps && ls -la

# Prüfe Git-Status
cd apps/lianko && git status
```

### Agent-Kommunikation speichert nicht:

```bash
# Prüfe Dateiberechtigungen
ls -la ~/agent_knowledge_base.json
ls -la ~/agent_communication.json

# Erstelle manuell falls nötig
touch ~/agent_knowledge_base.json
touch ~/agent_communication.json
```

---

## ✅ Checkliste

- [ ] Slack Webhooks konfiguriert (3 URLs)
- [ ] Dashboard-System getestet
- [ ] Premium Agents im Backend integriert
- [ ] Repo-Analyse durchgeführt
- [ ] Agent-Kommunikation getestet
- [ ] Automatische Updates eingerichtet (Cron)

---

**Status:** ✅ Alle 4 Punkte implementiert und dokumentiert!

