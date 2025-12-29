# 🚨 ALARMSTUFE ROT - Security Alert

## ⚠️ KRITISCHE BEFUNDE

### Verdächtige Prozesse gefunden:

1. **PID 51297** - `dartvm` - **98.8% CPU** 🔴
   - Prozess: `/opt/homebrew/share/flutter/bin/cache/dart-sdk/bin/dartvm`
   - Läuft seit: Dienstag 11PM
   - CPU-Zeit: 1341 Minuten
   - **VERDACHT**: Extrem hohe CPU-Nutzung, möglicher Angriff

2. **PID 48591** - `dartvm` - **98.8% CPU** 🔴
   - Prozess: `/opt/homebrew/share/flutter/bin/cache/dart-sdk/bin/dartvm`
   - Läuft seit: Dienstag 11PM
   - CPU-Zeit: 1347 Minuten
   - **VERDACHT**: Extrem hohe CPU-Nutzung, möglicher Angriff

### System-Ressourcen:
- **Load Average**: 6.98, 8.30, 7.21 (SEHR HOCH)
- **CPU**: 15.70% user, 27.48% sys, 56.81% idle
- **RAM**: 17GB verwendet von 18GB

### Netzwerkverbindungen:
- **Viele aktive Verbindungen** zu verschiedenen IPs
- AWS IPs (3.165.136.13, 52.45.158.157, etc.)
- Google IPs (74.125.133.188)
- GitHub (140.82.113.25)

### Offene Ports:
- **Ollama**: Port 11434 (localhost)
- **Node.js**: Port 3000
- **PostgreSQL**: Port 5433 (localhost)
- **ControlCenter**: Port 5000, 7000

---

## 🛡️ SOFORTMASSNAHMEN

### 1. Verdächtige Prozesse beenden:
```bash
chmod +x kill_suspicious_processes.sh
./kill_suspicious_processes.sh
```

### 2. Security Monitor starten:
```bash
python3 security_monitor.py
```

### 3. Firewall aktivieren:
```bash
chmod +x security_firewall.sh
sudo ./security_firewall.sh
```

### 4. System scannen:
```bash
# Mit Kaspersky (bereits installiert)
# Oder mit ClamAV
brew install clamav
freshclam
clamscan -r ~/
```

---

## 📊 Monitoring

### Echtzeit-Überwachung:
```bash
# Security Monitor (läuft kontinuierlich)
python3 security_monitor.py

# In separatem Terminal: Prozess-Überwachung
watch -n 2 'ps aux | sort -rk 3,3 | head -10'
```

### Netzwerk-Monitoring:
```bash
# Aktive Verbindungen
watch -n 2 'netstat -an | grep ESTABLISHED | wc -l'

# Verdächtige IPs
netstat -an | grep ESTABLISHED | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -rn
```

---

## 🔒 Firewall-Regeln

### Blockiere verdächtige IPs:
```bash
# Beispiel: Blockiere IP
sudo pfctl -t blocklist -T add 1.2.3.4
```

### Erlaube nur notwendige Ports:
- Port 3000 (Node.js Backend) - nur localhost
- Port 11434 (Ollama) - nur localhost
- Port 5433 (PostgreSQL) - nur localhost

---

## 📝 Logs prüfen

```bash
# System-Logs
log show --predicate 'eventMessage contains "dartvm"' --last 1h

# Netzwerk-Logs
log show --predicate 'subsystem == "com.apple.network"' --last 1h

# Firewall-Logs
log show --predicate 'process == "socketfilterfw"' --last 1h
```

---

## ✅ Checkliste

- [ ] Verdächtige Prozesse beendet
- [ ] Firewall aktiviert
- [ ] Security Monitor läuft
- [ ] System gescannt
- [ ] Netzwerk-Verbindungen überprüft
- [ ] Logs analysiert
- [ ] Backup erstellt

---

**Status**: 🔴 KRITISCH  
**Zeit**: $(date)  
**Nächste Prüfung**: In 5 Minuten

