#!/usr/bin/env python3
"""
Agent-Kommunikationsschnittstelle
3 Agenten teilen Wissen und denken zusammen
"""

import os
import json
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
import threading
import time

KNOWLEDGE_BASE_FILE = Path.home() / 'agent_knowledge_base.json'
AGENT_COMMUNICATION_FILE = Path.home() / 'agent_communication.json'

class AgentCommunication:
    """Kommunikationssystem zwischen mehreren Agenten"""
    
    def __init__(self):
        self.knowledge_base = self._load_knowledge_base()
        self.communication_log = self._load_communication_log()
        self.lock = threading.Lock()
    
    def _load_knowledge_base(self) -> Dict:
        """Lädt die gemeinsame Wissensbasis"""
        if KNOWLEDGE_BASE_FILE.exists():
            try:
                with open(KNOWLEDGE_BASE_FILE, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                pass
        return {
            'shared_knowledge': {},
            'agent_expertise': {},
            'context_history': [],
            'decisions': [],
            'last_update': datetime.now().isoformat()
        }
    
    def _load_communication_log(self) -> Dict:
        """Lädt Kommunikationslog"""
        if AGENT_COMMUNICATION_FILE.exists():
            try:
                with open(AGENT_COMMUNICATION_FILE, 'r', encoding='utf-8') as f:
                    return json.load(f)
            except:
                pass
        return {
            'messages': [],
            'collaborations': [],
            'last_update': datetime.now().isoformat()
        }
    
    def _save_knowledge_base(self):
        """Speichert Wissensbasis"""
        self.knowledge_base['last_update'] = datetime.now().isoformat()
        try:
            with open(KNOWLEDGE_BASE_FILE, 'w', encoding='utf-8') as f:
                json.dump(self.knowledge_base, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"⚠️ Fehler beim Speichern: {e}")
    
    def _save_communication_log(self):
        """Speichert Kommunikationslog"""
        self.communication_log['last_update'] = datetime.now().isoformat()
        try:
            with open(AGENT_COMMUNICATION_FILE, 'w', encoding='utf-8') as f:
                json.dump(self.communication_log, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"⚠️ Fehler beim Speichern: {e}")
    
    def share_knowledge(self, agent_name: str, key: str, value: any, metadata: Optional[Dict] = None):
        """
        Agent teilt Wissen mit anderen Agenten
        
        Args:
            agent_name: Name des teilenden Agents
            key: Schlüssel des Wissens
            value: Wert/Information
            metadata: Zusätzliche Metadaten (Quelle, Vertrauenswürdigkeit, etc.)
        """
        with self.lock:
            self.knowledge_base['shared_knowledge'][key] = {
                'value': value,
                'agent': agent_name,
                'timestamp': datetime.now().isoformat(),
                'metadata': metadata or {}
            }
            
            # In Kontext-Historie aufnehmen
            self.knowledge_base['context_history'].append({
                'type': 'knowledge_share',
                'agent': agent_name,
                'key': key,
                'timestamp': datetime.now().isoformat()
            })
            
            # Nur letzte 1000 Einträge behalten
            if len(self.knowledge_base['context_history']) > 1000:
                self.knowledge_base['context_history'] = self.knowledge_base['context_history'][-1000:]
            
            self._save_knowledge_base()
    
    def get_knowledge(self, key: str) -> Optional[any]:
        """Holt geteiltes Wissen"""
        knowledge = self.knowledge_base['shared_knowledge'].get(key)
        if knowledge:
            return knowledge.get('value')
        return None
    
    def get_all_knowledge(self) -> Dict:
        """Holt alle geteilten Wissensdaten"""
        return self.knowledge_base['shared_knowledge']
    
    def register_agent_expertise(self, agent_name: str, expertise: List[str], capabilities: Dict):
        """
        Registriert Agent-Expertise
        
        Args:
            agent_name: Name des Agents
            expertise: Liste von Expertisen (z.B. ['sales', 'solar'])
            capabilities: Fähigkeiten des Agents
        """
        with self.lock:
            self.knowledge_base['agent_expertise'][agent_name] = {
                'expertise': expertise,
                'capabilities': capabilities,
                'registered_at': datetime.now().isoformat(),
                'last_activity': datetime.now().isoformat()
            }
            self._save_knowledge_base()
    
    def find_expert_agent(self, topic: str) -> Optional[str]:
        """Findet Agent mit Expertise für ein Thema"""
        topic_lower = topic.lower()
        for agent_name, data in self.knowledge_base['agent_expertise'].items():
            expertise = data.get('expertise', [])
            if any(topic_lower in exp.lower() or exp.lower() in topic_lower for exp in expertise):
                return agent_name
        return None
    
    def send_message(self, from_agent: str, to_agent: str, message: str, context: Optional[Dict] = None):
        """
        Sendet Nachricht zwischen Agenten
        
        Args:
            from_agent: Sender-Agent
            to_agent: Empfänger-Agent
            message: Nachricht
            context: Zusätzlicher Kontext
        """
        with self.lock:
            comm_entry = {
                'from': from_agent,
                'to': to_agent,
                'message': message,
                'context': context or {},
                'timestamp': datetime.now().isoformat(),
                'read': False
            }
            
            self.communication_log['messages'].append(comm_entry)
            
            # Nur letzte 500 Nachrichten behalten
            if len(self.communication_log['messages']) > 500:
                self.communication_log['messages'] = self.communication_log['messages'][-500:]
            
            self._save_communication_log()
    
    def get_messages(self, agent_name: str, unread_only: bool = True) -> List[Dict]:
        """Holt Nachrichten für einen Agenten"""
        messages = [
            msg for msg in self.communication_log['messages']
            if msg['to'] == agent_name and (not unread_only or not msg.get('read', False))
        ]
        return messages
    
    def mark_message_read(self, message_id: int):
        """Markiert Nachricht als gelesen"""
        with self.lock:
            if 0 <= message_id < len(self.communication_log['messages']):
                self.communication_log['messages'][message_id]['read'] = True
                self._save_communication_log()
    
    def collaborative_decision(self, agents: List[str], topic: str, options: List[str], weights: Optional[Dict] = None) -> Dict:
        """
        Ermöglicht gemeinsame Entscheidung mehrerer Agenten
        
        Args:
            agents: Liste der beteiligten Agenten
            topic: Entscheidungsthema
            options: Verfügbare Optionen
            weights: Gewichtungen pro Agent (optional)
        
        Returns:
            Entscheidung mit Begründung
        """
        with self.lock:
            decision = {
                'topic': topic,
                'agents': agents,
                'options': options,
                'timestamp': datetime.now().isoformat(),
                'votes': {},
                'final_decision': None,
                'reasoning': {}
            }
            
            # Simuliere Abstimmung (in echter Implementierung würden Agenten antworten)
            # Hier: Beispiel-Implementierung
            for agent in agents:
                # In echter Implementierung: Agent wird gefragt
                decision['votes'][agent] = options[0] if options else None
                decision['reasoning'][agent] = f"Agent {agent} empfiehlt basierend auf Expertise"
            
            # Mehrheitsentscheidung
            vote_counts = {}
            for vote in decision['votes'].values():
                vote_counts[vote] = vote_counts.get(vote, 0) + 1
            
            if vote_counts:
                decision['final_decision'] = max(vote_counts, key=vote_counts.get)
            
            self.knowledge_base['decisions'].append(decision)
            
            # Nur letzte 100 Entscheidungen behalten
            if len(self.knowledge_base['decisions']) > 100:
                self.knowledge_base['decisions'] = self.knowledge_base['decisions'][-100:]
            
            self._save_knowledge_base()
            
            return decision
    
    def get_agent_context(self, agent_name: str) -> Dict:
        """Holt vollständigen Kontext für einen Agenten"""
        return {
            'expertise': self.knowledge_base['agent_expertise'].get(agent_name, {}),
            'messages': self.get_messages(agent_name, unread_only=False),
            'shared_knowledge': {
                k: v for k, v in self.knowledge_base['shared_knowledge'].items()
                if agent_name in str(v.get('agent', ''))
            },
            'recent_decisions': [
                d for d in self.knowledge_base['decisions']
                if agent_name in d.get('agents', [])
            ][-10:]  # Letzte 10
        }
    
    def summarize_for_agent(self, agent_name: str) -> str:
        """Erstellt Zusammenfassung für einen Agenten"""
        context = self.get_agent_context(agent_name)
        
        summary = f"📊 Kontext-Zusammenfassung für {agent_name}\n\n"
        
        if context['expertise']:
            summary += f"**Expertise:** {', '.join(context['expertise'].get('expertise', []))}\n\n"
        
        if context['messages']:
            summary += f"**Ungelesene Nachrichten:** {len([m for m in context['messages'] if not m.get('read')])}\n\n"
        
        if context['shared_knowledge']:
            summary += f"**Geteiltes Wissen:** {len(context['shared_knowledge'])} Einträge\n\n"
        
        if context['recent_decisions']:
            summary += f"**Beteiligt an:** {len(context['recent_decisions'])} Entscheidungen\n"
        
        return summary


# Globale Instanz
_agent_comm = None

def get_agent_communication() -> AgentCommunication:
    """Singleton-Instanz"""
    global _agent_comm
    if _agent_comm is None:
        _agent_comm = AgentCommunication()
    return _agent_comm


if __name__ == '__main__':
    comm = get_agent_communication()
    
    if len(sys.argv) < 2:
        print("Verwendung:")
        print("  python agent_communication.py share <agent> <key> <value>")
        print("  python agent_communication.py get <key>")
        print("  python agent_communication.py register <agent> <expertise1,expertise2>")
        print("  python agent_communication.py find <topic>")
        print("  python agent_communication.py message <from> <to> <message>")
        print("  python agent_communication.py context <agent>")
        sys.exit(1)
    
    command = sys.argv[1]
    
    if command == 'share':
        agent = sys.argv[2]
        key = sys.argv[3]
        value = sys.argv[4] if len(sys.argv) > 4 else 'test_value'
        comm.share_knowledge(agent, key, value)
        print(f"✅ Wissen geteilt: {key} = {value}")
    
    elif command == 'get':
        key = sys.argv[2] if len(sys.argv) > 2 else 'test'
        value = comm.get_knowledge(key)
        print(f"Wert für '{key}': {value}")
    
    elif command == 'register':
        agent = sys.argv[2]
        expertise_str = sys.argv[3] if len(sys.argv) > 3 else 'general'
        expertise = expertise_str.split(',')
        comm.register_agent_expertise(agent, expertise, {})
        print(f"✅ Agent {agent} registriert mit Expertise: {expertise}")
    
    elif command == 'find':
        topic = sys.argv[2] if len(sys.argv) > 2 else 'sales'
        expert = comm.find_expert_agent(topic)
        print(f"Experte für '{topic}': {expert}")
    
    elif command == 'message':
        from_agent = sys.argv[2]
        to_agent = sys.argv[3]
        message = ' '.join(sys.argv[4:]) if len(sys.argv) > 4 else 'Test-Nachricht'
        comm.send_message(from_agent, to_agent, message)
        print(f"✅ Nachricht von {from_agent} an {to_agent} gesendet")
    
    elif command == 'context':
        agent = sys.argv[2] if len(sys.argv) > 2 else 'Agent1'
        summary = comm.summarize_for_agent(agent)
        print(summary)
    
    else:
        print(f"Unbekannter Befehl: {command}")

