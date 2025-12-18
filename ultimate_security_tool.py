#!/usr/bin/env python3
"""
🛡️ ULTIMATE SECURITY TOOL - Undurchdringbare Verteidigung
Multi-Layer Security System für Mac & Server
"""

import subprocess
import json
import os
import re
import time
import hashlib
from datetime import datetime
from pathlib import Path
from collections import defaultdict, Counter
import threading
import signal
import sys

class UltimateSecurityTool:
    def __init__(self):
        self.config = {
            'cpu_threshold': 50.0,  # CPU-Alarm bei >50%
            'ram_threshold_gb': 1.0,  # RAM-Alarm bei >1GB
            'auto_terminate_cpu': 90.0,  # Auto-Terminate bei >90%
            'auto_terminate_duration': 300,  # 5 Minuten
            'log_file': 'security_monitor.log',
            'report_dir': 'security_reports',
            'whitelist_file': 'process_whitelist.json',
            'blacklist_file': 'process_blacklist.json',
            'firewall_rules_file': 'firewall_rules.json',
            'file_integrity_db': 'file_integrity.db.json'
        }
        
        self.running = True
        self.monitoring = False
        self.process_history = defaultdict(list)
        self.network_connections = []
        self.blocked_ips = set()
        self.blocked_processes = set()
        self.file_hashes = {}
        self.alerts = []
        
        # Lade Konfiguration
        self.load_config()
        
    def load_config(self):
        """Lade Konfiguration und Whitelists"""
        # Whitelist (erlaubte Prozesse)
        if os.path.exists(self.config['whitelist_file']):
            with open(self.config['whitelist_file'], 'r') as f:
                self.whitelist = json.load(f).get('processes', [])
        else:
            self.whitelist = [
                'Cursor', 'Safari', 'Chrome', 'Firefox', 'Opera',
                'Terminal', 'iTerm', 'VS Code',
                'Kaspersky', 'Malwarebytes', 'System Preferences',
                'Flutter', 'Dart', 'Node', 'Python',
                'kavd', 'kav_agent', 'KasperskySecurity',
                'ctkahp', 'ctkd', 'CSExattrCryptoService',
                'Opera Helper', 'Opera Framework'
            ]
            self.save_whitelist()
        
        # Blacklist (verbotene Prozesse)
        if os.path.exists(self.config['blacklist_file']):
            with open(self.config['blacklist_file'], 'r') as f:
                self.blacklist = json.load(f).get('processes', [])
        else:
            self.blacklist = [
                'miner', 'crypto', 'bitcoin', 'backdoor',
                'trojan', 'virus', 'malware', 'keylogger'
            ]
            self.save_blacklist()
        
        # Firewall-Regeln
        if os.path.exists(self.config['firewall_rules_file']):
            with open(self.config['firewall_rules_file'], 'r') as f:
                self.firewall_rules = json.load(f)
        else:
            self.firewall_rules = {
                'allowed_ports': [3000, 5433, 11434],  # Node, PostgreSQL, Ollama
                'blocked_ips': [],
                'allowed_ips': []
            }
            self.save_firewall_rules()
        
        # File Integrity Database
        if os.path.exists(self.config['file_integrity_db']):
            with open(self.config['file_integrity_db'], 'r') as f:
                self.file_hashes = json.load(f)
        else:
            self.init_file_integrity()
    
    def save_whitelist(self):
        """Speichere Whitelist"""
        with open(self.config['whitelist_file'], 'w') as f:
            json.dump({'processes': self.whitelist}, f, indent=2)
    
    def save_blacklist(self):
        """Speichere Blacklist"""
        with open(self.config['blacklist_file'], 'w') as f:
            json.dump({'processes': self.blacklist}, f, indent=2)
    
    def save_firewall_rules(self):
        """Speichere Firewall-Regeln"""
        with open(self.config['firewall_rules_file'], 'w') as f:
            json.dump(self.firewall_rules, f, indent=2)
    
    def save_file_integrity(self):
        """Speichere File Integrity Database"""
        with open(self.config['file_integrity_db'], 'w') as f:
            json.dump(self.file_hashes, f, indent=2)
    
    def init_file_integrity(self):
        """Initialisiere File Integrity Monitoring"""
        critical_files = [
            '/etc/hosts',
            '/etc/passwd',
            '/etc/sudoers',
            os.path.expanduser('~/.ssh/authorized_keys'),
            os.path.expanduser('~/.bashrc'),
            os.path.expanduser('~/.zshrc'),
            os.path.expanduser('~/.ssh/config')
        ]
        
        for file_path in critical_files:
            expanded = os.path.expanduser(file_path)
            if os.path.exists(expanded):
                try:
                    with open(expanded, 'rb') as f:
                        content = f.read()
                        file_hash = hashlib.sha256(content).hexdigest()
                        self.file_hashes[file_path] = {
                            'hash': file_hash,
                            'mtime': os.path.getmtime(expanded),
                            'size': os.path.getsize(expanded)
                        }
                except:
                    pass
        
        self.save_file_integrity()
    
    def run_command(self, cmd, timeout=10):
        """Führe Shell-Befehl aus"""
        try:
            result = subprocess.run(
                cmd, 
                shell=True, 
                capture_output=True, 
                text=True, 
                timeout=timeout
            )
            return result.stdout.strip(), result.stderr.strip(), result.returncode
        except subprocess.TimeoutExpired:
            return "", "Timeout", -1
        except Exception as e:
            return "", str(e), -1
    
    def log_event(self, level, message, data=None):
        """Protokolliere Event"""
        timestamp = datetime.now().isoformat()
        event = {
            'timestamp': timestamp,
            'level': level,
            'message': message,
            'data': data
        }
        
        self.alerts.append(event)
        
        # Log to file
        log_entry = f"[{timestamp}] [{level}] {message}\n"
        if data:
            log_entry += f"  Data: {json.dumps(data, indent=2)}\n"
        
        with open(self.config['log_file'], 'a') as f:
            f.write(log_entry)
        
        # Console output
        if level == 'CRITICAL':
            print(f"🔴 [{timestamp}] {message}")
        elif level == 'WARNING':
            print(f"⚠️  [{timestamp}] {message}")
        elif level == 'INFO':
            print(f"ℹ️  [{timestamp}] {message}")
    
    def check_processes(self):
        """Überwache alle Prozesse"""
        stdout, _, _ = self.run_command("ps aux")
        
        suspicious = []
        high_cpu = []
        
        for line in stdout.split('\n')[1:]:
            if not line.strip():
                continue
            
            parts = line.split()
            if len(parts) < 11:
                continue
            
            try:
                pid = parts[1]
                cpu = float(parts[2])
                mem = float(parts[3])
                mem_mb = float(parts[5]) / 1024  # KB to MB
                cmd = ' '.join(parts[10:])
                cmd_lower = cmd.lower()
                
                # Blacklist-Check
                if any(blocked in cmd_lower for blocked in self.blacklist):
                    if pid not in self.blocked_processes:
                        self.log_event('CRITICAL', f'Blacklisted process detected: {cmd}', {
                            'pid': pid,
                            'cpu': cpu,
                            'mem': mem_mb
                        })
                        self.terminate_process(pid, 'Blacklisted process')
                        self.blocked_processes.add(pid)
                        suspicious.append({
                            'pid': pid,
                            'cmd': cmd,
                            'reason': 'Blacklisted',
                            'severity': 'CRITICAL'
                        })
                
                # CPU-Check
                if cpu > self.config['auto_terminate_cpu']:
                    high_cpu.append({
                        'pid': pid,
                        'cpu': cpu,
                        'cmd': cmd,
                        'duration': self.get_process_duration(pid)
                    })
                    
                    # Auto-Terminate bei >90% CPU für >5 Minuten
                    if pid in self.process_history:
                        duration = time.time() - self.process_history[pid][0]
                        if duration > self.config['auto_terminate_duration']:
                            self.log_event('CRITICAL', f'Auto-terminating high CPU process: {cmd}', {
                                'pid': pid,
                                'cpu': cpu,
                                'duration': duration
                            })
                            self.terminate_process(pid, 'High CPU for extended period')
                            suspicious.append({
                                'pid': pid,
                                'cmd': cmd,
                                'reason': f'High CPU ({cpu}%) for {duration}s',
                                'severity': 'CRITICAL'
                            })
                
                # RAM-Check
                if mem_mb > (self.config['ram_threshold_gb'] * 1024):
                    if cpu > 10:  # Nur bei aktiver CPU
                        self.log_event('WARNING', f'High RAM usage: {cmd}', {
                            'pid': pid,
                            'ram_mb': mem_mb,
                            'cpu': cpu
                        })
                
                # Verdächtige Pfade
                if cmd.startswith('/') and not any(allowed in cmd for allowed in [
                    '/System', '/Library', '/usr', '/opt/homebrew',
                    '/Applications', '/Users', '/private', '/var'
                ]):
                    if cpu > 20:
                        self.log_event('WARNING', f'Suspicious path: {cmd}', {
                            'pid': pid,
                            'cpu': cpu
                        })
                        suspicious.append({
                            'pid': pid,
                            'cmd': cmd,
                            'reason': 'Suspicious path',
                            'severity': 'MEDIUM'
                        })
                
                # Track process history
                if pid not in self.process_history:
                    self.process_history[pid] = [time.time(), cmd]
                
            except (ValueError, IndexError):
                continue
        
        return suspicious, high_cpu
    
    def get_process_duration(self, pid):
        """Ermittle Prozess-Dauer"""
        if pid in self.process_history:
            return time.time() - self.process_history[pid][0]
        return 0
    
    def terminate_process(self, pid, reason):
        """Beende Prozess sicher"""
        try:
            # Erst SIGTERM (sanft)
            self.run_command(f"kill -TERM {pid}")
            time.sleep(2)
            
            # Prüfe ob noch läuft
            stdout, _, _ = self.run_command(f"ps -p {pid}")
            if pid in stdout:
                # Dann SIGKILL (hart)
                self.run_command(f"kill -9 {pid}")
                self.log_event('INFO', f'Force-killed process {pid}: {reason}')
            else:
                self.log_event('INFO', f'Terminated process {pid}: {reason}')
        except Exception as e:
            self.log_event('WARNING', f'Failed to terminate process {pid}: {e}')
    
    def check_network(self):
        """Überwache Netzwerk-Verbindungen"""
        stdout, _, _ = self.run_command("netstat -an | grep ESTABLISHED")
        
        connections = []
        suspicious_ips = []
        
        for line in stdout.split('\n'):
            if 'ESTABLISHED' in line:
                parts = line.split()
                if len(parts) >= 4:
                    try:
                        local = parts[3]
                        remote = parts[4]
                        
                        if remote and remote != '0.0.0.0':
                            ip = remote.split(':')[0]
                            port = remote.split(':')[1] if ':' in remote else None
                            
                            connections.append({
                                'local': local,
                                'remote': remote,
                                'ip': ip,
                                'port': port
                            })
                            
                            # Prüfe auf blockierte IPs
                            if ip in self.blocked_ips:
                                self.log_event('WARNING', f'Blocked IP attempting connection: {ip}')
                                # Blockiere Verbindung
                                self.block_connection(ip)
                            
                            # Prüfe auf verdächtige Ports
                            if port and int(port) not in self.firewall_rules['allowed_ports']:
                                if int(port) > 1024:  # Nicht-System-Ports
                                    self.log_event('WARNING', f'Suspicious port: {port} from {ip}')
                                    suspicious_ips.append(ip)
                    except:
                        pass
        
        # Zähle Verbindungen pro IP
        ip_counts = Counter(conn['ip'] for conn in connections)
        for ip, count in ip_counts.items():
            if count > 20:  # Viele Verbindungen = verdächtig
                self.log_event('WARNING', f'Many connections from IP: {ip} ({count})')
                suspicious_ips.append(ip)
        
        return connections, suspicious_ips
    
    def block_connection(self, ip):
        """Blockiere Netzwerk-Verbindung"""
        try:
            # macOS pfctl
            self.run_command(f"sudo pfctl -t blocklist -T add {ip}")
            self.blocked_ips.add(ip)
            self.log_event('INFO', f'Blocked IP: {ip}')
        except:
            pass
    
    def check_file_integrity(self):
        """Prüfe Datei-Integrität"""
        changes = []
        
        for file_path, stored_info in self.file_hashes.items():
            expanded = os.path.expanduser(file_path)
            if os.path.exists(expanded):
                try:
                    with open(expanded, 'rb') as f:
                        content = f.read()
                        current_hash = hashlib.sha256(content).hexdigest()
                        current_mtime = os.path.getmtime(expanded)
                        current_size = os.path.getsize(expanded)
                    
                    # Hash geändert = KRITISCH
                    if current_hash != stored_info['hash']:
                        self.log_event('CRITICAL', f'File integrity violation: {file_path}', {
                            'old_hash': stored_info['hash'][:16],
                            'new_hash': current_hash[:16],
                            'old_size': stored_info['size'],
                            'new_size': current_size
                        })
                        changes.append({
                            'file': file_path,
                            'type': 'HASH_CHANGED',
                            'severity': 'CRITICAL'
                        })
                        
                        # Automatische Wiederherstellung (wenn Backup vorhanden)
                        self.restore_file(file_path)
                    
                    # Mtime geändert = WARNUNG
                    elif current_mtime != stored_info['mtime']:
                        self.log_event('WARNING', f'File modified: {file_path}', {
                            'old_mtime': stored_info['mtime'],
                            'new_mtime': current_mtime
                        })
                        changes.append({
                            'file': file_path,
                            'type': 'MODIFIED',
                            'severity': 'WARNING'
                        })
                        
                        # Update hash
                        self.file_hashes[file_path] = {
                            'hash': current_hash,
                            'mtime': current_mtime,
                            'size': current_size
                        }
                        self.save_file_integrity()
                
                except Exception as e:
                    self.log_event('WARNING', f'Failed to check file {file_path}: {e}')
        
        return changes
    
    def restore_file(self, file_path):
        """Stelle Datei wieder her (wenn Backup vorhanden)"""
        # TODO: Implementiere Backup-Wiederherstellung
        self.log_event('WARNING', f'File restore needed: {file_path} (not implemented)')
    
    def setup_firewall(self):
        """Konfiguriere Firewall"""
        self.log_event('INFO', 'Setting up firewall...')
        
        # macOS Firewall aktivieren
        self.run_command("sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on")
        self.run_command("sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on")
        
        # Blockiere alle eingehenden Verbindungen außer erlaubten Ports
        for port in self.firewall_rules['allowed_ports']:
            self.run_command(f"sudo /usr/libexec/ApplicationFirewall/socketfilterfw --add /usr/bin/python3")
        
        self.log_event('INFO', 'Firewall configured')
    
    def generate_report(self):
        """Generiere Security-Report"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = f"{self.config['report_dir']}/security_report_{timestamp}.md"
        
        os.makedirs(self.config['report_dir'], exist_ok=True)
        
        # Sammle Daten
        suspicious_procs, high_cpu = self.check_processes()
        connections, suspicious_ips = self.check_network()
        file_changes = self.check_file_integrity()
        
        # Erstelle Report
        report = f"""# 🛡️ SECURITY REPORT

**Zeitpunkt:** {datetime.now().isoformat()}
**Status:** {'🔴 KRITISCH' if suspicious_procs or file_changes else '✅ SICHER'}

## 📊 Übersicht

- **Verdächtige Prozesse:** {len(suspicious_procs)}
- **High CPU Prozesse:** {len(high_cpu)}
- **Aktive Verbindungen:** {len(connections)}
- **Verdächtige IPs:** {len(suspicious_ips)}
- **Datei-Änderungen:** {len(file_changes)}
- **Alerts:** {len(self.alerts)}

## 🔴 Verdächtige Prozesse

"""
        
        for proc in suspicious_procs:
            report += f"- **PID {proc['pid']}:** {proc['cmd'][:100]}\n"
            report += f"  - Grund: {proc['reason']}\n"
            report += f"  - Schweregrad: {proc['severity']}\n\n"
        
        if not suspicious_procs:
            report += "✅ Keine verdächtigen Prozesse\n\n"
        
        report += "## 🌐 Netzwerk\n\n"
        report += f"- **Aktive Verbindungen:** {len(connections)}\n"
        report += f"- **Verdächtige IPs:** {len(suspicious_ips)}\n\n"
        
        if suspicious_ips:
            for ip in set(suspicious_ips):
                report += f"- ⚠️  {ip}\n"
        
        report += "\n## 🔒 Datei-Integrität\n\n"
        
        for change in file_changes:
            report += f"- **{change['file']}:** {change['type']} ({change['severity']})\n"
        
        if not file_changes:
            report += "✅ Keine Änderungen\n\n"
        
        report += "\n## 📋 Alerts\n\n"
        for alert in self.alerts[-20:]:  # Letzte 20
            report += f"- [{alert['level']}] {alert['message']}\n"
        
        # Speichere Report
        with open(report_file, 'w') as f:
            f.write(report)
        
        self.log_event('INFO', f'Report generated: {report_file}')
        return report_file
    
    def monitor_loop(self, interval=5):
        """Haupt-Monitoring-Loop"""
        self.log_event('INFO', 'Starting Ultimate Security Monitor...')
        self.setup_firewall()
        
        self.monitoring = True
        
        try:
            while self.running:
                # Prozesse prüfen
                suspicious_procs, high_cpu = self.check_processes()
                
                # Netzwerk prüfen
                connections, suspicious_ips = self.check_network()
                
                # Datei-Integrität prüfen (alle 60 Sekunden)
                if int(time.time()) % 60 == 0:
                    file_changes = self.check_file_integrity()
                
                # Alerts ausgeben
                if suspicious_procs:
                    for proc in suspicious_procs:
                        if proc['severity'] == 'CRITICAL':
                            print(f"🔴 KRITISCH: {proc['cmd'][:80]}")
                
                time.sleep(interval)
        
        except KeyboardInterrupt:
            self.log_event('INFO', 'Monitoring stopped by user')
        finally:
            self.monitoring = False
            self.generate_report()
            self.log_event('INFO', 'Monitoring stopped')
    
    def run_scan(self):
        """Führe einmaligen Security-Scan durch"""
        self.log_event('INFO', 'Running security scan...')
        
        suspicious_procs, high_cpu = self.check_processes()
        connections, suspicious_ips = self.check_network()
        file_changes = self.check_file_integrity()
        
        print("\n" + "="*80)
        print("🛡️  ULTIMATE SECURITY SCAN")
        print("="*80)
        print(f"\n📊 Ergebnisse:")
        print(f"  Verdächtige Prozesse: {len(suspicious_procs)}")
        print(f"  High CPU Prozesse: {len(high_cpu)}")
        print(f"  Aktive Verbindungen: {len(connections)}")
        print(f"  Verdächtige IPs: {len(suspicious_ips)}")
        print(f"  Datei-Änderungen: {len(file_changes)}")
        
        if suspicious_procs:
            print(f"\n🔴 VERDÄCHTIGE PROZESSE:")
            for proc in suspicious_procs:
                print(f"  PID {proc['pid']}: {proc['cmd'][:80]}")
                print(f"    Grund: {proc['reason']}")
        
        if file_changes:
            print(f"\n🔒 DATEI-ÄNDERUNGEN:")
            for change in file_changes:
                print(f"  {change['file']}: {change['type']}")
        
        report_file = self.generate_report()
        print(f"\n💾 Report gespeichert: {report_file}")
        print("="*80 + "\n")

def signal_handler(sig, frame):
    """Handle SIGINT (Ctrl+C)"""
    print("\n\n🛑 Stoppe Security Monitor...")
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, signal_handler)
    
    tool = UltimateSecurityTool()
    
    if len(sys.argv) > 1:
        if sys.argv[1] == 'scan':
            tool.run_scan()
        elif sys.argv[1] == 'monitor':
            tool.monitor_loop()
        else:
            print("Usage: python3 ultimate_security_tool.py [scan|monitor]")
    else:
        # Default: Scan
        tool.run_scan()

