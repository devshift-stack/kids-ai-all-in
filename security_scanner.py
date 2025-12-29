#!/usr/bin/env python3
"""
🚨 ULTIMATIVER SECURITY SCANNER
Vollständiger System-Scan mit Fehler-Erkennung und Log-Analyse
"""

import subprocess
import json
import os
import re
import time
from datetime import datetime
from pathlib import Path
from collections import defaultdict, Counter
import hashlib

class SecurityScanner:
    def __init__(self):
        self.scan_results = {
            'timestamp': datetime.now().isoformat(),
            'system_info': {},
            'suspicious_processes': [],
            'malware_indicators': [],
            'errors_found': [],
            'network_threats': [],
            'log_anomalies': [],
            'file_integrity': [],
            'security_score': 100,
            'recommendations': []
        }
        self.report_file = f"SECURITY_SCAN_{datetime.now().strftime('%Y%m%d_%H%M%S')}.md"
        
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
    
    def scan_system_resources(self):
        """Scan System-Ressourcen"""
        print("📊 Scanne System-Ressourcen...")
        
        # CPU & RAM
        stdout, _, _ = self.run_command("top -l 1 | head -20")
        self.scan_results['system_info']['top_output'] = stdout
        
        # Load Average
        stdout, _, _ = self.run_command("uptime")
        if stdout:
            load_match = re.search(r'load averages?: ([\d.]+)', stdout)
            if load_match:
                load = float(load_match.group(1))
                self.scan_results['system_info']['load_average'] = load
                if load > 4.0:
                    self.scan_results['errors_found'].append({
                        'type': 'HIGH_LOAD',
                        'severity': 'CRITICAL',
                        'message': f'Load Average extrem hoch: {load}',
                        'recommendation': 'Prozesse mit hoher CPU beenden'
                    })
                    self.scan_results['security_score'] -= 20
        
        # Disk Space
        stdout, _, _ = self.run_command("df -h /")
        self.scan_results['system_info']['disk_space'] = stdout
        
        # Memory
        stdout, _, _ = self.run_command("vm_stat")
        self.scan_results['system_info']['memory'] = stdout
    
    def scan_processes(self):
        """Scan alle Prozesse auf verdächtige Aktivitäten"""
        print("🔍 Scanne Prozesse...")
        
        stdout, _, _ = self.run_command("ps aux")
        processes = []
        
        for line in stdout.split('\n')[1:]:
            if not line.strip():
                continue
            parts = line.split()
            if len(parts) >= 11:
                try:
                    pid = parts[1]
                    cpu = float(parts[2])
                    mem = float(parts[3])
                    cmd = ' '.join(parts[10:])
                    
                    process_info = {
                        'pid': pid,
                        'cpu': cpu,
                        'mem': mem,
                        'cmd': cmd
                    }
                    processes.append(process_info)
                    
                    # ALARM: Extrem hohe CPU
                    if cpu > 80:
                        self.scan_results['suspicious_processes'].append({
                            'pid': pid,
                            'cpu': cpu,
                            'mem': mem,
                            'cmd': cmd[:200],
                            'reason': f'EXTREM hohe CPU: {cpu}%',
                            'severity': 'CRITICAL'
                        })
                        self.scan_results['security_score'] -= 15
                    
                    # ALARM: Verdächtige Prozess-Namen
                    suspicious_keywords = [
                        'dartvm', 'miner', 'crypto', 'bitcoin', 
                        'backdoor', 'trojan', 'virus', 'malware',
                        'keylogger', 'spyware', 'rootkit'
                    ]
                    cmd_lower = cmd.lower()
                    for keyword in suspicious_keywords:
                        if keyword in cmd_lower and cpu > 10:
                            self.scan_results['suspicious_processes'].append({
                                'pid': pid,
                                'cpu': cpu,
                                'mem': mem,
                                'cmd': cmd[:200],
                                'reason': f'Verdächtiges Keyword: {keyword}',
                                'severity': 'HIGH'
                            })
                            self.scan_results['security_score'] -= 10
                    
                    # ALARM: Unbekannte/verdächtige Pfade
                    if cmd.startswith('/') and not any(allowed in cmd for allowed in [
                        '/System', '/Library', '/usr', '/opt/homebrew',
                        '/Applications', '/Users', '/private'
                    ]):
                        if cpu > 20:
                            self.scan_results['suspicious_processes'].append({
                                'pid': pid,
                                'cpu': cpu,
                                'mem': mem,
                                'cmd': cmd[:200],
                                'reason': 'Unbekannter/verdächtiger Pfad',
                                'severity': 'MEDIUM'
                            })
                            self.scan_results['security_score'] -= 5
                            
                except (ValueError, IndexError):
                    continue
        
        self.scan_results['system_info']['total_processes'] = len(processes)
    
    def scan_network(self):
        """Scan Netzwerkverbindungen"""
        print("🌐 Scanne Netzwerkverbindungen...")
        
        # Aktive Verbindungen
        stdout, _, _ = self.run_command("netstat -an | grep ESTABLISHED")
        connections = stdout.split('\n')
        
        # Verdächtige IP-Ranges
        suspicious_ranges = [
            '192.168.', '10.', '172.16.',  # Lokale IPs (normal, aber prüfen)
        ]
        
        # Bekannte bösartige IP-Patterns
        malicious_patterns = []
        
        unique_ips = Counter()
        for conn in connections:
            if 'ESTABLISHED' in conn:
                parts = conn.split()
                if len(parts) >= 4:
                    remote = parts[4]
                    if remote and remote != '0.0.0.0':
                        ip = remote.split(':')[0]
                        unique_ips[ip] += 1
        
        # Viele Verbindungen zu einer IP = verdächtig
        for ip, count in unique_ips.most_common(20):
            if count > 10:
                self.scan_results['network_threats'].append({
                    'ip': ip,
                    'connections': count,
                    'reason': f'Viele Verbindungen zu einer IP: {count}',
                    'severity': 'MEDIUM'
                })
                self.scan_results['security_score'] -= 3
        
        # Offene Ports
        stdout, _, _ = self.run_command("lsof -i -P | grep LISTEN")
        listening_ports = stdout.split('\n')
        
        # Verdächtige Ports
        suspicious_ports = [4444, 5555, 6666, 7777, 8888, 9999, 12345, 31337]
        for line in listening_ports:
            if 'LISTEN' in line:
                port_match = re.search(r':(\d+)', line)
                if port_match:
                    port = int(port_match.group(1))
                    if port in suspicious_ports:
                        self.scan_results['network_threats'].append({
                            'port': port,
                            'reason': f'Verdächtiger Port offen: {port}',
                            'severity': 'HIGH'
                        })
                        self.scan_results['security_score'] -= 10
        
        self.scan_results['system_info']['active_connections'] = len(connections)
        self.scan_results['system_info']['unique_ips'] = len(unique_ips)
    
    def scan_logs(self):
        """Analysiere System-Logs auf Fehler und Anomalien"""
        print("📋 Analysiere System-Logs...")
        
        # System-Logs (letzte 2 Stunden)
        log_queries = [
            {
                'name': 'System Errors',
                'query': 'log show --predicate "eventMessage contains \\"error\\" OR eventMessage contains \\"Error\\" OR eventMessage contains \\"ERROR\\"" --last 2h --style compact',
                'severity': 'HIGH'
            },
            {
                'name': 'Security Events',
                'query': 'log show --predicate "subsystem == \\"com.apple.security\\" OR subsystem == \\"com.apple.network\\"" --last 2h --style compact',
                'severity': 'MEDIUM'
            },
            {
                'name': 'Firewall Events',
                'query': 'log show --predicate "process == \\"socketfilterfw\\"" --last 2h --style compact',
                'severity': 'MEDIUM'
            },
            {
                'name': 'Kernel Panics',
                'query': 'log show --predicate "eventMessage contains \\"panic\\" OR eventMessage contains \\"Panic\\"" --last 24h --style compact',
                'severity': 'CRITICAL'
            }
        ]
        
        for log_query in log_queries:
            stdout, stderr, code = self.run_command(log_query['query'], timeout=15)
            if stdout:
                lines = stdout.split('\n')
                error_count = len([l for l in lines if 'error' in l.lower() or 'fail' in l.lower()])
                
                if error_count > 0:
                    self.scan_results['log_anomalies'].append({
                        'type': log_query['name'],
                        'errors': error_count,
                        'severity': log_query['severity'],
                        'sample': lines[:5]  # Erste 5 Zeilen als Beispiel
                    })
                    if log_query['severity'] == 'CRITICAL':
                        self.scan_results['security_score'] -= 25
                    elif log_query['severity'] == 'HIGH':
                        self.scan_results['security_score'] -= 10
                    else:
                        self.scan_results['security_score'] -= 5
        
        # Spezifische Log-Dateien prüfen
        log_files = [
            '/var/log/system.log',
            '/var/log/install.log',
            '~/Library/Logs/CrashReporter/'
        ]
        
        for log_path in log_files:
            expanded_path = os.path.expanduser(log_path)
            if os.path.exists(expanded_path):
                try:
                    if os.path.isfile(expanded_path):
                        # Letzte 100 Zeilen
                        stdout, _, _ = self.run_command(f"tail -100 '{expanded_path}'")
                        if stdout:
                            error_lines = [l for l in stdout.split('\n') if 'error' in l.lower() or 'fail' in l.lower()]
                            if error_lines:
                                self.scan_results['log_anomalies'].append({
                                    'type': f'Log File: {log_path}',
                                    'errors': len(error_lines),
                                    'severity': 'MEDIUM',
                                    'sample': error_lines[:3]
                                })
                                self.scan_results['security_score'] -= 3
                except:
                    pass
    
    def scan_file_integrity(self):
        """Prüfe kritische System-Dateien auf Modifikationen"""
        print("🔒 Prüfe Datei-Integrität...")
        
        critical_files = [
            '/etc/hosts',
            '/etc/passwd',
            '/etc/sudoers',
            '~/.ssh/authorized_keys',
            '~/.bashrc',
            '~/.zshrc'
        ]
        
        for file_path in critical_files:
            expanded = os.path.expanduser(file_path)
            if os.path.exists(expanded):
                try:
                    # Prüfe Änderungszeit (letzte 7 Tage = verdächtig)
                    mtime = os.path.getmtime(expanded)
                    days_ago = (time.time() - mtime) / 86400
                    
                    if days_ago < 7:
                        self.scan_results['file_integrity'].append({
                            'file': file_path,
                            'modified_days_ago': round(days_ago, 2),
                            'severity': 'MEDIUM',
                            'reason': 'Kritische Datei kürzlich modifiziert'
                        })
                        self.scan_results['security_score'] -= 5
                except:
                    pass
    
    def scan_malware_indicators(self):
        """Suche nach Malware-Indikatoren"""
        print("🦠 Suche nach Malware-Indikatoren...")
        
        # Verdächtige Dateien in typischen Verstecken
        suspicious_locations = [
            '~/Library/LaunchAgents/',
            '~/Library/LaunchDaemons/',
            '/Library/LaunchAgents/',
            '/Library/LaunchDaemons/',
            '~/Library/Application Support/',
            '/tmp/',
            '/var/tmp/'
        ]
        
        suspicious_extensions = ['.sh', '.py', '.pl', '.rb', '.js', '.exe', '.dmg']
        suspicious_names = ['miner', 'crypto', 'backdoor', 'trojan', 'keylog', 'spy']
        
        for location in suspicious_locations:
            expanded = os.path.expanduser(location)
            if os.path.exists(expanded):
                try:
                    for root, dirs, files in os.walk(expanded):
                        for file in files:
                            file_path = os.path.join(root, file)
                            file_lower = file.lower()
                            
                            # Prüfe auf verdächtige Namen
                            if any(sus in file_lower for sus in suspicious_names):
                                self.scan_results['malware_indicators'].append({
                                    'file': file_path,
                                    'reason': 'Verdächtiger Dateiname',
                                    'severity': 'HIGH'
                                })
                                self.scan_results['security_score'] -= 15
                except PermissionError:
                    pass
                except Exception as e:
                    pass
    
    def generate_recommendations(self):
        """Generiere Sicherheits-Empfehlungen"""
        recommendations = []
        
        if self.scan_results['suspicious_processes']:
            recommendations.append({
                'priority': 'CRITICAL',
                'action': 'Verdächtige Prozesse sofort beenden',
                'command': './kill_suspicious_processes.sh'
            })
        
        if self.scan_results['security_score'] < 50:
            recommendations.append({
                'priority': 'CRITICAL',
                'action': 'Firewall sofort aktivieren',
                'command': 'sudo ./security_firewall.sh'
            })
        
        if self.scan_results['log_anomalies']:
            recommendations.append({
                'priority': 'HIGH',
                'action': 'System-Logs detailliert analysieren',
                'command': 'log show --last 24h | grep -i error'
            })
        
        if self.scan_results['network_threats']:
            recommendations.append({
                'priority': 'HIGH',
                'action': 'Netzwerk-Verbindungen überprüfen',
                'command': 'netstat -an | grep ESTABLISHED'
            })
        
        if self.scan_results['malware_indicators']:
            recommendations.append({
                'priority': 'CRITICAL',
                'action': 'Vollständiger Malware-Scan durchführen',
                'command': 'brew install clamav && freshclam && clamscan -r ~/'
            })
        
        self.scan_results['recommendations'] = recommendations
    
    def generate_report(self):
        """Generiere vollständigen Security-Report"""
        print("\n" + "="*80)
        print("🚨 ULTIMATIVER SECURITY SCAN - REPORT")
        print("="*80)
        print(f"📅 Scan-Zeitpunkt: {self.scan_results['timestamp']}")
        print(f"🔒 Security Score: {max(0, self.scan_results['security_score'])}/100")
        
        # Security Score Interpretation
        score = self.scan_results['security_score']
        if score >= 80:
            status = "✅ GUT"
        elif score >= 60:
            status = "⚠️  WARNUNG"
        elif score >= 40:
            status = "🔴 KRITISCH"
        else:
            status = "🚨 ALARMSTUFE ROT"
        
        print(f"📊 Status: {status}\n")
        
        # Verdächtige Prozesse
        if self.scan_results['suspicious_processes']:
            print(f"\n🔴 VERDÄCHTIGE PROZESSE ({len(self.scan_results['suspicious_processes'])}):")
            for proc in self.scan_results['suspicious_processes']:
                print(f"  ⚠️  PID {proc['pid']}: {proc['reason']}")
                print(f"     CPU: {proc['cpu']}% | RAM: {proc['mem']}%")
                print(f"     CMD: {proc['cmd'][:150]}")
                print()
        
        # Malware-Indikatoren
        if self.scan_results['malware_indicators']:
            print(f"\n🦠 MALWARE-INDIKATOREN ({len(self.scan_results['malware_indicators'])}):")
            for indicator in self.scan_results['malware_indicators']:
                print(f"  🔴 {indicator['file']}")
                print(f"     Grund: {indicator['reason']}")
                print()
        
        # Netzwerk-Bedrohungen
        if self.scan_results['network_threats']:
            print(f"\n🌐 NETZWERK-BEDROHUNGEN ({len(self.scan_results['network_threats'])}):")
            for threat in self.scan_results['network_threats']:
                print(f"  ⚠️  {threat.get('ip', threat.get('port', 'Unknown'))}")
                print(f"     Grund: {threat['reason']}")
                print()
        
        # Log-Anomalien
        if self.scan_results['log_anomalies']:
            print(f"\n📋 LOG-ANOMALIEN ({len(self.scan_results['log_anomalies'])}):")
            for anomaly in self.scan_results['log_anomalies']:
                print(f"  ⚠️  {anomaly['type']}: {anomaly['errors']} Fehler gefunden")
                if anomaly.get('sample'):
                    print(f"     Beispiel: {anomaly['sample'][0][:100]}")
                print()
        
        # Datei-Integrität
        if self.scan_results['file_integrity']:
            print(f"\n🔒 DATEI-INTEGRITÄT ({len(self.scan_results['file_integrity'])}):")
            for file_info in self.scan_results['file_integrity']:
                print(f"  ⚠️  {file_info['file']}")
                print(f"     Vor {file_info['modified_days_ago']} Tagen modifiziert")
                print()
        
        # Empfehlungen
        if self.scan_results['recommendations']:
            print(f"\n🛡️  SOFORTMASSNAHMEN ({len(self.scan_results['recommendations'])}):")
            for i, rec in enumerate(self.scan_results['recommendations'], 1):
                print(f"  {i}. [{rec['priority']}] {rec['action']}")
                print(f"     → {rec['command']}")
                print()
        
        print("="*80)
        
        # Speichere Report als Markdown
        self.save_markdown_report()
    
    def save_markdown_report(self):
        """Speichere Report als Markdown-Datei"""
        md_content = f"""# 🚨 ULTIMATIVER SECURITY SCAN REPORT

**Scan-Zeitpunkt:** {self.scan_results['timestamp']}  
**Security Score:** {max(0, self.scan_results['security_score'])}/100

## 📊 Status

"""
        
        score = self.scan_results['security_score']
        if score >= 80:
            md_content += "✅ **GUT** - System scheint sicher zu sein\n\n"
        elif score >= 60:
            md_content += "⚠️  **WARNUNG** - Einige Probleme gefunden\n\n"
        elif score >= 40:
            md_content += "🔴 **KRITISCH** - Sofortmaßnahmen erforderlich\n\n"
        else:
            md_content += "🚨 **ALARMSTUFE ROT** - System kompromittiert?\n\n"
        
        # Verdächtige Prozesse
        if self.scan_results['suspicious_processes']:
            md_content += f"## 🔴 Verdächtige Prozesse ({len(self.scan_results['suspicious_processes'])})\n\n"
            for proc in self.scan_results['suspicious_processes']:
                md_content += f"### PID {proc['pid']}\n"
                md_content += f"- **Grund:** {proc['reason']}\n"
                md_content += f"- **CPU:** {proc['cpu']}%\n"
                md_content += f"- **RAM:** {proc['mem']}%\n"
                md_content += f"- **Befehl:** `{proc['cmd'][:200]}`\n"
                md_content += f"- **Schweregrad:** {proc['severity']}\n\n"
        
        # Malware-Indikatoren
        if self.scan_results['malware_indicators']:
            md_content += f"## 🦠 Malware-Indikatoren ({len(self.scan_results['malware_indicators'])})\n\n"
            for indicator in self.scan_results['malware_indicators']:
                md_content += f"- **Datei:** `{indicator['file']}`\n"
                md_content += f"- **Grund:** {indicator['reason']}\n"
                md_content += f"- **Schweregrad:** {indicator['severity']}\n\n"
        
        # Netzwerk-Bedrohungen
        if self.scan_results['network_threats']:
            md_content += f"## 🌐 Netzwerk-Bedrohungen ({len(self.scan_results['network_threats'])})\n\n"
            for threat in self.scan_results['network_threats']:
                md_content += f"- **{threat.get('ip', threat.get('port', 'Unknown'))}**\n"
                md_content += f"  - Grund: {threat['reason']}\n"
                md_content += f"  - Schweregrad: {threat['severity']}\n\n"
        
        # Log-Anomalien
        if self.scan_results['log_anomalies']:
            md_content += f"## 📋 Log-Anomalien ({len(self.scan_results['log_anomalies'])})\n\n"
            for anomaly in self.scan_results['log_anomalies']:
                md_content += f"### {anomaly['type']}\n"
                md_content += f"- **Fehler gefunden:** {anomaly['errors']}\n"
                md_content += f"- **Schweregrad:** {anomaly['severity']}\n"
                if anomaly.get('sample'):
                    md_content += f"- **Beispiel:**\n```\n{chr(10).join(anomaly['sample'][:3])}\n```\n\n"
        
        # Empfehlungen
        if self.scan_results['recommendations']:
            md_content += f"## 🛡️ Sofortmaßnahmen ({len(self.scan_results['recommendations'])})\n\n"
            for i, rec in enumerate(self.scan_results['recommendations'], 1):
                md_content += f"### {i}. [{rec['priority']}] {rec['action']}\n\n"
                md_content += f"```bash\n{rec['command']}\n```\n\n"
        
        # JSON Export
        json_file = self.report_file.replace('.md', '.json')
        with open(json_file, 'w') as f:
            json.dump(self.scan_results, f, indent=2, ensure_ascii=False)
        
        # Markdown speichern
        with open(self.report_file, 'w') as f:
            f.write(md_content)
        
        print(f"\n💾 Report gespeichert:")
        print(f"   📄 {self.report_file}")
        print(f"   📄 {json_file}")
    
    def run_full_scan(self):
        """Führe vollständigen Security-Scan durch"""
        print("🚨 STARTE ULTIMATIVEN SECURITY SCAN...\n")
        
        self.scan_system_resources()
        self.scan_processes()
        self.scan_network()
        self.scan_logs()
        self.scan_file_integrity()
        self.scan_malware_indicators()
        self.generate_recommendations()
        self.generate_report()
        
        print("\n✅ SCAN ABGESCHLOSSEN\n")

if __name__ == "__main__":
    scanner = SecurityScanner()
    scanner.run_full_scan()

