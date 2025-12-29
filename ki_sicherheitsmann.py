#!/usr/bin/env python3
"""
🛡️ KI-SICHERHEITSMANN - Kontinuierlicher Security Monitor
Läuft 24/7 im Hintergrund und überwacht dein System
"""

import subprocess
import json
import time
import os
import sys
from datetime import datetime
from pathlib import Path
from collections import defaultdict
import signal

class KISicherheitsmann:
    def __init__(self):
        self.running = True
        self.alerts = []
        self.process_history = defaultdict(list)
        self.network_history = defaultdict(int)
        self.scan_interval = 30  # Sekunden
        self.log_file = Path.home() / ".ki_sicherheitsmann" / "security.log"
        self.report_dir = Path.home() / ".ki_sicherheitsmann" / "reports"
        self.config_file = Path.home() / ".ki_sicherheitsmann" / "config.json"
        
        # Erstelle Verzeichnisse
        self.log_file.parent.mkdir(parents=True, exist_ok=True)
        self.report_dir.mkdir(parents=True, exist_ok=True)
        
        # Lade Konfiguration
        self.config = self.load_config()
        
        # Signal Handler für sauberes Beenden
        signal.signal(signal.SIGINT, self.signal_handler)
        signal.signal(signal.SIGTERM, self.signal_handler)
        
    def load_config(self):
        """Lade Konfiguration oder erstelle Standard"""
        default_config = {
            "scan_interval": 30,
            "cpu_threshold": 80.0,
            "memory_threshold": 90.0,
            "load_threshold": 5.0,
            "alert_email": None,
            "suspicious_keywords": ["dartvm", "miner", "crypto", "backdoor", "trojan"],
            "monitor_network": True,
            "monitor_processes": True,
            "monitor_system": True
        }
        
        if self.config_file.exists():
            try:
                with open(self.config_file, 'r') as f:
                    user_config = json.load(f)
                    default_config.update(user_config)
            except:
                pass
        
        # Speichere Config
        with open(self.config_file, 'w') as f:
            json.dump(default_config, f, indent=2)
        
        return default_config
    
    def signal_handler(self, signum, frame):
        """Sauberes Beenden"""
        self.log("🛑 Beende KI-Sicherheitsmann...")
        self.running = False
    
    def log(self, message, level="INFO"):
        """Logge Nachricht"""
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"[{timestamp}] [{level}] {message}\n"
        
        # Console Output
        if level == "ALERT":
            print(f"🚨 {message}")
        elif level == "WARNING":
            print(f"⚠️  {message}")
        elif level == "INFO":
            print(f"ℹ️  {message}")
        
        # File Log
        try:
            with open(self.log_file, 'a') as f:
                f.write(log_entry)
        except:
            pass
    
    def run_command(self, cmd, timeout=5):
        """Führe System-Befehl aus"""
        try:
            result = subprocess.run(
                cmd, shell=True, 
                capture_output=True, 
                text=True, 
                timeout=timeout
            )
            return result.stdout.strip()
        except:
            return ""
    
    def check_system_resources(self):
        """Prüfe System-Ressourcen"""
        if not self.config.get("monitor_system", True):
            return []
        
        alerts = []
        
        # CPU
        cpu_info = self.run_command("top -l 1 | grep 'CPU usage'")
        if cpu_info:
            try:
                cpu_user = float(cpu_info.split()[2].replace('%', ''))
                if cpu_user > self.config.get("cpu_threshold", 80.0):
                    alerts.append({
                        "type": "HIGH_CPU",
                        "severity": "WARNING",
                        "message": f"Hohe CPU-Nutzung: {cpu_user}%",
                        "value": cpu_user
                    })
            except:
                pass
        
        # Memory
        mem_info = self.run_command("top -l 1 | grep 'PhysMem'")
        if mem_info:
            try:
                # Extrahiere Memory-Info
                if "used" in mem_info:
                    mem_parts = mem_info.split()
                    for i, part in enumerate(mem_parts):
                        if part == "used" and i + 1 < len(mem_parts):
                            mem_used = mem_parts[i + 1].replace('G', '').replace('M', '')
                            try:
                                mem_used_num = float(mem_used)
                                if mem_used_num > self.config.get("memory_threshold", 90.0):
                                    alerts.append({
                                        "type": "HIGH_MEMORY",
                                        "severity": "WARNING",
                                        "message": f"Hohe RAM-Nutzung: {mem_used_num}GB",
                                        "value": mem_used_num
                                    })
                            except:
                                pass
            except:
                pass
        
        # Load Average
        load_info = self.run_command("uptime")
        if load_info:
            try:
                load_avg = load_info.split("load averages:")[1].split()[0].replace(',', '')
                load_avg_num = float(load_avg)
                if load_avg_num > self.config.get("load_threshold", 5.0):
                    alerts.append({
                        "type": "HIGH_LOAD",
                        "severity": "WARNING",
                        "message": f"Hohe Load Average: {load_avg_num}",
                        "value": load_avg_num
                    })
            except:
                pass
        
        return alerts
    
    def check_processes(self):
        """Prüfe verdächtige Prozesse"""
        if not self.config.get("monitor_processes", True):
            return []
        
        alerts = []
        suspicious_keywords = self.config.get("suspicious_keywords", [])
        
        # Hole alle Prozesse
        processes = self.run_command("ps aux")
        
        for line in processes.split('\n')[1:]:  # Skip header
            if not line.strip():
                continue
            
            parts = line.split()
            if len(parts) >= 11:
                try:
                    pid = parts[1]
                    cpu = float(parts[2])
                    mem = float(parts[3])
                    cmd = ' '.join(parts[10:])
                    
                    # Prüfe auf hohe CPU
                    if cpu > self.config.get("cpu_threshold", 80.0):
                        # Prüfe auf verdächtige Keywords
                        cmd_lower = cmd.lower()
                        is_suspicious = any(kw in cmd_lower for kw in suspicious_keywords)
                        
                        if is_suspicious or cpu > 90.0:
                            alerts.append({
                                "type": "SUSPICIOUS_PROCESS",
                                "severity": "ALERT",
                                "pid": pid,
                                "cpu": cpu,
                                "mem": mem,
                                "cmd": cmd[:100],
                                "message": f"Verdächtiger Prozess: PID {pid} ({cpu}% CPU) - {cmd[:50]}"
                            })
                except:
                    pass
        
        return alerts
    
    def check_network(self):
        """Prüfe Netzwerkverbindungen"""
        if not self.config.get("monitor_network", True):
            return []
        
        alerts = []
        
        # Aktive Verbindungen
        connections = self.run_command("netstat -an | grep ESTABLISHED")
        connection_count = len([l for l in connections.split('\n') if l.strip()])
        
        # Prüfe auf ungewöhnlich viele Verbindungen
        if connection_count > 100:
            alerts.append({
                "type": "HIGH_NETWORK_ACTIVITY",
                "severity": "WARNING",
                "message": f"Viele aktive Netzwerkverbindungen: {connection_count}",
                "value": connection_count
            })
        
        return alerts
    
    def generate_report(self, alerts):
        """Generiere Security Report"""
        if not alerts:
            return
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        report_file = self.report_dir / f"security_report_{timestamp}.md"
        
        with open(report_file, 'w') as f:
            f.write(f"# 🛡️ Security Report\n\n")
            f.write(f"**Datum:** {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}\n\n")
            f.write(f"**Gefundene Alerts:** {len(alerts)}\n\n")
            f.write("---\n\n")
            
            # Gruppiere nach Severity
            critical = [a for a in alerts if a.get("severity") == "ALERT"]
            warnings = [a for a in alerts if a.get("severity") == "WARNING"]
            
            if critical:
                f.write("## 🚨 KRITISCHE ALERTS\n\n")
                for alert in critical:
                    f.write(f"- **{alert.get('type', 'UNKNOWN')}:** {alert.get('message', '')}\n")
                f.write("\n")
            
            if warnings:
                f.write("## ⚠️ WARNINGS\n\n")
                for alert in warnings:
                    f.write(f"- **{alert.get('type', 'UNKNOWN')}:** {alert.get('message', '')}\n")
                f.write("\n")
        
        self.log(f"Report generiert: {report_file}")
    
    def run_scan(self):
        """Führe einen vollständigen Scan durch"""
        self.log("🔍 Starte Security-Scan...")
        
        all_alerts = []
        
        # System-Ressourcen
        system_alerts = self.check_system_resources()
        all_alerts.extend(system_alerts)
        
        # Prozesse
        process_alerts = self.check_processes()
        all_alerts.extend(process_alerts)
        
        # Netzwerk
        network_alerts = self.check_network()
        all_alerts.extend(network_alerts)
        
        # Alerts loggen
        for alert in all_alerts:
            self.log(alert.get("message", "Unbekannter Alert"), alert.get("severity", "INFO"))
        
        # Report generieren (nur bei Alerts)
        if all_alerts:
            self.generate_report(all_alerts)
        
        return len(all_alerts)
    
    def run(self):
        """Haupt-Loop"""
        self.log("🛡️ KI-Sicherheitsmann gestartet", "INFO")
        self.log(f"Scan-Intervall: {self.scan_interval} Sekunden", "INFO")
        self.log(f"Log-Datei: {self.log_file}", "INFO")
        self.log(f"Report-Verzeichnis: {self.report_dir}", "INFO")
        
        scan_count = 0
        
        while self.running:
            try:
                alert_count = self.run_scan()
                scan_count += 1
                
                if alert_count > 0:
                    self.log(f"Scan #{scan_count}: {alert_count} Alerts gefunden", "WARNING")
                else:
                    self.log(f"Scan #{scan_count}: System sauber", "INFO")
                
                # Warte bis zum nächsten Scan
                time.sleep(self.scan_interval)
                
            except KeyboardInterrupt:
                self.running = False
                break
            except Exception as e:
                self.log(f"Fehler im Scan: {e}", "WARNING")
                time.sleep(self.scan_interval)
        
        self.log("🛑 KI-Sicherheitsmann beendet", "INFO")

def main():
    """Main Entry Point"""
    # Prüfe ob bereits läuft
    pid_file = Path.home() / ".ki_sicherheitsmann" / "ki_sicherheitsmann.pid"
    
    if pid_file.exists():
        try:
            with open(pid_file, 'r') as f:
                old_pid = int(f.read().strip())
            
            # Prüfe ob Prozess noch läuft
            result = subprocess.run(
                f"ps -p {old_pid}",
                shell=True,
                capture_output=True
            )
            
            if result.returncode == 0:
                print(f"⚠️  KI-Sicherheitsmann läuft bereits (PID: {old_pid})")
                print("   Beende zuerst mit: kill {old_pid}")
                sys.exit(1)
        except:
            pass
    
    # Starte neuen Prozess
    sicherheitsmann = KISicherheitsmann()
    
    # Speichere PID
    with open(pid_file, 'w') as f:
        f.write(str(os.getpid()))
    
    try:
        sicherheitsmann.run()
    finally:
        # Lösche PID-File beim Beenden
        if pid_file.exists():
            pid_file.unlink()

if __name__ == "__main__":
    main()

