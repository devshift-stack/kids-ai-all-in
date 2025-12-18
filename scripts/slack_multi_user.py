#!/usr/bin/env python3
"""
Erweiterte Slack/Teams Multi-User Chat Integration
Unterstützt 3+ Personen im Chat mit erweiterten Features
"""

import os
import json
import sys
import requests
from datetime import datetime
from typing import Optional, List, Dict
import threading
import time

# Slack Webhook URLs für verschiedene Channels/User
SLACK_WEBHOOK_URL = os.getenv('SLACK_WEBHOOK_URL', '')
SLACK_WEBHOOK_URL_2 = os.getenv('SLACK_WEBHOOK_URL_2', '')  # Zweiter User
SLACK_WEBHOOK_URL_3 = os.getenv('SLACK_WEBHOOK_URL_3', '')  # Dritter User

# Teams Webhook (Alternative)
TEAMS_WEBHOOK_URL = os.getenv('TEAMS_WEBHOOK_URL', '')

# Shared Knowledge Base für Agent-Kommunikation
KNOWLEDGE_BASE_FILE = os.path.expanduser('~/agent_knowledge_base.json')

class MultiUserChat:
    """Multi-User Chat System für Slack/Teams"""
    
    def __init__(self):
        self.webhooks = [
            url for url in [SLACK_WEBHOOK_URL, SLACK_WEBHOOK_URL_2, SLACK_WEBHOOK_URL_3, TEAMS_WEBHOOK_URL]
            if url
        ]
        self.knowledge_base = self._load_knowledge_base()
        
    def _load_knowledge_base(self) -> Dict:
        """Lädt die gemeinsame Wissensbasis"""
        if os.path.exists(KNOWLEDGE_BASE_FILE):
            try:
                with open(KNOWLEDGE_BASE_FILE, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                pass
        return {
            'messages': [],
            'shared_context': {},
            'agent_activities': {},
            'last_update': datetime.now().isoformat()
        }
    
    def _save_knowledge_base(self):
        """Speichert die Wissensbasis"""
        self.knowledge_base['last_update'] = datetime.now().isoformat()
        try:
            with open(KNOWLEDGE_BASE_FILE, 'w', encoding='utf-8') as f:
                json.dump(self.knowledge_base, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"⚠️ Fehler beim Speichern der Wissensbasis: {e}")
    
    def send_to_all(self, 
                   message: str, 
                   title: Optional[str] = None,
                   color: str = 'good',
                   agent_name: str = 'System',
                   priority: str = 'normal'):
        """
        Sendet Nachricht an alle konfigurierten Webhooks (3 User)
        
        Args:
            message: Nachrichtentext
            title: Optionaler Titel
            color: Farbe (good/warning/danger)
            agent_name: Name des sendenden Agents
            priority: normal/urgent/critical
        """
        if not self.webhooks:
            print("⚠️ Keine Webhook URLs konfiguriert!")
            print(f"Nachricht wäre: {message}")
            return False
        
        # Nachricht in Wissensbasis speichern
        self.knowledge_base['messages'].append({
            'agent': agent_name,
            'message': message,
            'title': title,
            'timestamp': datetime.now().isoformat(),
            'priority': priority
        })
        # Nur letzte 1000 Nachrichten behalten
        if len(self.knowledge_base['messages']) > 1000:
            self.knowledge_base['messages'] = self.knowledge_base['messages'][-1000:]
        
        self._save_knowledge_base()
        
        # Slack Format
        slack_payload = {
            'text': title or f'{agent_name} - Update',
            'attachments': [{
                'color': color,
                'text': message,
                'footer': f'{agent_name} | {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
                'ts': int(datetime.now().timestamp()),
                'fields': [
                    {
                        'title': 'Priorität',
                        'value': priority.upper(),
                        'short': True
                    },
                    {
                        'title': 'Agent',
                        'value': agent_name,
                        'short': True
                    }
                ]
            }]
        }
        
        # Teams Format (falls Teams Webhook vorhanden)
        teams_payload = {
            '@type': 'MessageCard',
            '@context': 'https://schema.org/extensions',
            'summary': title or f'{agent_name} - Update',
            'themeColor': '0078D4' if color == 'good' else 'FF0000' if color == 'danger' else 'FFAA00',
            'sections': [{
                'activityTitle': title or f'{agent_name} - Update',
                'activitySubtitle': agent_name,
                'text': message,
                'facts': [
                    {'name': 'Priorität', 'value': priority.upper()},
                    {'name': 'Zeit', 'value': datetime.now().strftime("%Y-%m-%d %H:%M:%S")}
                ]
            }]
        }
        
        success_count = 0
        for i, webhook_url in enumerate(self.webhooks):
            try:
                # Prüfe ob Teams oder Slack
                if 'office.com' in webhook_url or 'office365' in webhook_url:
                    payload = teams_payload
                else:
                    payload = slack_payload
                
                response = requests.post(
                    webhook_url,
                    json=payload,
                    timeout=10
                )
                response.raise_for_status()
                success_count += 1
            except Exception as e:
                print(f"❌ Fehler beim Senden an Webhook {i+1}: {e}")
        
        if success_count > 0:
            print(f"✅ Nachricht an {success_count}/{len(self.webhooks)} Empfänger gesendet")
            return True
        return False
    
    def share_context(self, key: str, value: any, agent_name: str):
        """Teilt Kontext zwischen Agenten"""
        self.knowledge_base['shared_context'][key] = {
            'value': value,
            'agent': agent_name,
            'timestamp': datetime.now().isoformat()
        }
        self._save_knowledge_base()
        self.send_to_all(
            f"🔗 Neuer geteilter Kontext: **{key}** = {value}",
            title="Kontext-Update",
            agent_name=agent_name,
            color='good'
        )
    
    def get_shared_context(self, key: str) -> Optional[any]:
        """Holt geteilten Kontext"""
        return self.knowledge_base['shared_context'].get(key, {}).get('value')
    
    def update_agent_activity(self, agent_name: str, activity: str, status: str = 'active'):
        """Aktualisiert Agent-Aktivität"""
        self.knowledge_base['agent_activities'][agent_name] = {
            'activity': activity,
            'status': status,
            'timestamp': datetime.now().isoformat()
        }
        self._save_knowledge_base()
    
    def get_agent_activities(self) -> Dict:
        """Holt alle Agent-Aktivitäten"""
        return self.knowledge_base.get('agent_activities', {})


def send_dashboard_update(repo_stats: Dict, security_status: Dict, dev_stats: Dict):
    """Sendet Dashboard-Update an alle User"""
    chat = MultiUserChat()
    
    message = f"""
📊 **Dashboard Update - {datetime.now().strftime("%d.%m.%Y %H:%M")}**

**Repository Status:**
"""
    
    for repo, stats in repo_stats.items():
        message += f"• **{repo}**: {stats.get('status', 'unknown')} - {stats.get('last_commit', 'N/A')}\n"
    
    message += f"""
**Sicherheitsstatus:**
• Gesamt: {security_status.get('overall', 'unknown')}
• Kritische Issues: {security_status.get('critical', 0)}
• Warnungen: {security_status.get('warnings', 0)}

**Entwickler-Statistiken:**
"""
    
    for dev, stats in dev_stats.items():
        message += f"• **{dev}**: {stats.get('commits', 0)} Commits, {stats.get('files_changed', 0)} Dateien\n"
    
    chat.send_to_all(
        message,
        title="📊 Dashboard Update",
        agent_name="Dashboard",
        color='good'
    )


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Verwendung:")
        print("  python slack_multi_user.py message 'Nachricht' [agent_name] [priority]")
        print("  python slack_multi_user.py dashboard")
        print("  python slack_multi_user.py context <key> <value> [agent_name]")
        sys.exit(1)
    
    chat = MultiUserChat()
    command = sys.argv[1]
    
    if command == 'message':
        message = sys.argv[2] if len(sys.argv) > 2 else 'Test-Nachricht'
        agent = sys.argv[3] if len(sys.argv) > 3 else 'System'
        priority = sys.argv[4] if len(sys.argv) > 4 else 'normal'
        chat.send_to_all(message, agent_name=agent, priority=priority)
    
    elif command == 'dashboard':
        # Beispiel-Daten (sollte aus Repo-Analyse kommen)
        repo_stats = {
            'lianko': {'status': '✅ OK', 'last_commit': '2h ago'},
            'alanko': {'status': '✅ OK', 'last_commit': '5h ago'},
            'callcenter-ai': {'status': '⚠️ Warnings', 'last_commit': '1d ago'}
        }
        security_status = {'overall': '✅ Gut', 'critical': 0, 'warnings': 2}
        dev_stats = {'Dev1': {'commits': 15, 'files_changed': 42}}
        send_dashboard_update(repo_stats, security_status, dev_stats)
    
    elif command == 'context':
        key = sys.argv[2] if len(sys.argv) > 2 else 'test'
        value = sys.argv[3] if len(sys.argv) > 3 else 'test_value'
        agent = sys.argv[4] if len(sys.argv) > 4 else 'System'
        chat.share_context(key, value, agent)
    
    else:
        print(f"Unbekannter Befehl: {command}")

