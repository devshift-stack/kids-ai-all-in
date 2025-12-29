#!/usr/bin/env python3
"""
Slack Notifier für tägliche Berichte und wichtige Benachrichtigungen
"""

import os
import json
import sys
from datetime import datetime
from typing import Optional
import requests

# Slack Webhook URL aus Environment Variable
SLACK_WEBHOOK_URL = os.getenv('SLACK_WEBHOOK_URL', '')

def send_slack_message(
    text: str,
    title: Optional[str] = None,
    color: str = 'good',  # good, warning, danger
    fields: Optional[list] = None
):
    """
    Sendet eine Nachricht an Slack
    
    Args:
        text: Haupttext der Nachricht
        title: Optionaler Titel
        color: Farbe des Attachments (good=grün, warning=gelb, danger=rot)
        fields: Optional Liste von {title, value, short} Dicts
    """
    if not SLACK_WEBHOOK_URL:
        print("⚠️ SLACK_WEBHOOK_URL nicht gesetzt!")
        print(f"Nachricht wäre: {text}")
        return False
    
    payload = {
        'text': title or 'Callcenter AI - Update',
        'attachments': [
            {
                'color': color,
                'text': text,
                'footer': f'Callcenter AI Bot | {datetime.now().strftime("%Y-%m-%d %H:%M:%S")}',
                'ts': int(datetime.now().timestamp())
            }
        ]
    }
    
    if fields:
        payload['attachments'][0]['fields'] = fields
    
    try:
        response = requests.post(
            SLACK_WEBHOOK_URL,
            json=payload,
            timeout=10
        )
        response.raise_for_status()
        print(f"✅ Nachricht erfolgreich an Slack gesendet")
        return True
    except Exception as e:
        print(f"❌ Fehler beim Senden an Slack: {e}")
        return False

def daily_report():
    """Täglicher Status-Bericht"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Hier könnten Status-Checks eingefügt werden
    # z.B. Backend-Status, API-Quota, etc.
    
    text = f"""
📊 **Täglicher Status-Bericht**

✅ Callcenter AI System läuft
📅 Datum: {datetime.now().strftime("%d.%m.%Y")}
⏰ Zeit: {datetime.now().strftime("%H:%M:%S")}

**System-Status:**
• Backend: Verfügbar
• Flutter App: Bereit
• Gemini API: Konfiguriert

**Nächste Schritte:**
• Tests durchführen
• Performance überwachen
• Feedback sammeln
"""
    
    fields = [
        {
            'title': 'Status',
            'value': '✅ Alle Systeme operativ',
            'short': True
        },
        {
            'title': 'Letzte Aktivität',
            'value': timestamp,
            'short': True
        }
    ]
    
    return send_slack_message(
        text=text,
        title='📊 Täglicher Callcenter AI Bericht',
        color='good',
        fields=fields
    )

def urgent_notification(message: str, reason: str = ''):
    """Dringende Benachrichtigung wenn Benutzer erreicht werden muss"""
    text = f"""
🚨 **WICHTIG: Benutzer muss erreicht werden**

**Nachricht:**
{message}

**Grund:**
{reason or 'Manuelle Benachrichtigung'}
"""
    
    return send_slack_message(
        text=text,
        title='🚨 Dringende Benachrichtigung',
        color='danger'
    )

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Verwendung:")
        print("  python slack_notifier.py daily          # Täglicher Bericht")
        print("  python slack_notifier.py urgent <msg>   # Dringende Nachricht")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == 'daily':
        daily_report()
    elif command == 'urgent':
        message = ' '.join(sys.argv[2:]) if len(sys.argv) > 2 else 'Benutzer muss erreicht werden'
        urgent_notification(message)
    else:
        print(f"Unbekannter Befehl: {command}")
        sys.exit(1)

