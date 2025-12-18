#!/usr/bin/env python3
"""
🚨 ALARMSTUFE ROT - Security Monitor
Echtzeit-Überwachung für System-Sicherheit
"""

import subprocess
import json
import time
import os
from datetime import datetime
from collections import defaultdict

class SecurityMonitor:
    def __init__(self):
        self.alerts = []
        self.process_history = defaultdict(list)
        self.network_connections = []
        self.suspicious_processes = []
        
    def run_command(self, cmd):
        try:
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=5)
            return result.stdout.strip()
        except:
            return ""
    
    def get_top_processes(self):
        """Top CPU/RAM Prozesse"""
        cmd = "ps aux | sort -rk 3,3 | head -15"
        return self.run_command(cmd)
    
    def get_network_connections(self):
        """Aktive Netzwerkverbindungen"""
        cmd = "netstat -an | grep ESTABLISHED"
        return self.run_command(cmd)
    
    def get_listening_ports(self):
        """Offene Ports"""
        cmd = "lsof -i -P | grep LISTEN"
        return self.run_command(cmd)
    
    def analyze_processes(self):
        """Analysiere Prozesse auf verdächtige Aktivitäten"""
        processes = self.get_top_processes()
        suspicious = []
        
        lines = processes.split('\n')[1:]  # Skip header
        for line in lines:
            if not line.strip():
                continue
            parts = line.split()
            if len(parts) >= 11:
                try:
                    cpu = float(parts[2])
                    mem = float(parts[3])
                    pid = parts[1]
                    cmd = ' '.join(parts[10:])
                    
                    # ALARM: Hohe CPU-Nutzung
                    if cpu > 50:
                        suspicious.append({
                            'pid': pid,
                            'cpu': cpu,
                            'mem': mem,
                            'cmd': cmd[:100],
                            'reason': f'Hohe CPU-Nutzung: {cpu}%'
                        })
                    
                    # ALARM: Verdächtige Prozesse
                    suspicious_keywords = ['dartvm', 'flutterfire', 'curl', 'wget', 'nc', 'netcat']
                    if any(kw in cmd.lower() for kw in suspicious_keywords) and cpu > 10:
                        suspicious.append({
                            'pid': pid,
                            'cpu': cpu,
                            'mem': mem,
                            'cmd': cmd[:100],
                            'reason': 'Verdächtiger Prozess mit hoher CPU'
                        })
                except:
                    pass
        
        return suspicious
    
    def analyze_network(self):
        """Analysiere Netzwerkverbindungen"""
        connections = self.get_network_connections()
        suspicious = []
        
        # Bekannte verdächtige IP-Ranges
        suspicious_ranges = []
        
        lines = connections.split('\n')
        for line in lines:
            if 'ESTABLISHED' in line:
                parts = line.split()
                if len(parts) >= 4:
                    # Extrahiere IP
                    try:
                        local = parts[3]
                        remote = parts[4]
                        if remote and remote != '0.0.0.0':
                            suspicious.append({
                                'local': local,
                                'remote': remote,
                                'status': 'ESTABLISHED'
                            })
                    except:
                        pass
        
        return suspicious
    
    def get_system_resources(self):
        """System-Ressourcen"""
        cmd = "top -l 1 | grep -E 'CPU usage|PhysMem|Load Avg'"
        return self.run_command(cmd)
    
    def generate_report(self):
        """Generiere Security Report"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        
        print("\n" + "="*80)
        print(f"🚨 SECURITY MONITOR - {timestamp}")
        print("="*80)
        
        # System-Ressourcen
        print("\n📊 SYSTEM-RESSOURCEN:")
        resources = self.get_system_resources()
        print(resources)
        
        # Verdächtige Prozesse
        print("\n⚠️  VERDÄCHTIGE PROZESSE:")
        suspicious_procs = self.analyze_processes()
        if suspicious_procs:
            for proc in suspicious_procs:
                print(f"  🔴 PID {proc['pid']}: {proc['reason']}")
                print(f"     CPU: {proc['cpu']}% | RAM: {proc['mem']}%")
                print(f"     CMD: {proc['cmd']}")
                print()
        else:
            print("  ✅ Keine verdächtigen Prozesse gefunden")
        
        # Netzwerkverbindungen
        print("\n🌐 NETZWERKVERBINDUNGEN:")
        network = self.analyze_network()
        unique_ips = set()
        for conn in network[:20]:  # Top 20
            if conn['remote']:
                ip = conn['remote'].split(':')[0]
                unique_ips.add(ip)
        
        print(f"  Aktive Verbindungen: {len(network)}")
        print(f"  Eindeutige IPs: {len(unique_ips)}")
        print("  Top IPs:")
        for ip in list(unique_ips)[:10]:
            print(f"    - {ip}")
        
        # Offene Ports
        print("\n🔌 OFFENE PORTS:")
        ports = self.get_listening_ports()
        port_lines = ports.split('\n')[:15]
        for line in port_lines:
            if line.strip():
                print(f"  {line}")
        
        # Empfehlungen
        print("\n🛡️  SICHERHEITS-EMPFEHLUNGEN:")
        if suspicious_procs:
            print("  🔴 KRITISCH: Verdächtige Prozesse gefunden!")
            print("     → Prozesse beenden: kill -9 <PID>")
            print("     → Firewall aktivieren")
            print("     → System scannen")
        
        print("\n" + "="*80)
    
    def monitor_loop(self, interval=5):
        """Kontinuierliche Überwachung"""
        print("🚨 Security Monitor gestartet - Drücke Ctrl+C zum Beenden\n")
        try:
            while True:
                self.generate_report()
                time.sleep(interval)
        except KeyboardInterrupt:
            print("\n\n✅ Monitoring beendet")

if __name__ == "__main__":
    monitor = SecurityMonitor()
    monitor.monitor_loop(interval=5)

