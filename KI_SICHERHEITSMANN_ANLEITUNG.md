# 🛡️ KI-SICHERHEITSMANN - Vollständige Anleitung

**Erstellt:** 2025-12-18  
**Status:** ✅ Installiert und aktiv

---

## 📋 ÜBERSICHT

Der **KI-Sicherheitsmann** ist ein kontinuierlicher Security Monitor, der 24/7 im Hintergrund läuft und dein System überwacht.

**Features:**
- ✅ Kontinuierliche System-Überwachung (CPU, RAM, Load Average)
- ✅ Verdächtige Prozess-Erkennung
- ✅ Netzwerk-Monitoring
- ✅ Automatische Alert-Generierung
- ✅ Detaillierte Security-Reports
- ✅ Läuft automatisch beim Systemstart

---

## 🚀 INSTALLATION

### Schnellstart:

```bash
# 1. Installation ausführen
./install_ki_sicherheitsmann.sh

# 2. Status prüfen
launchctl list | grep ki-sicherheitsmann
```

### Was wird installiert:

1. **KI-Sicherheitsmann Script** (`ki_sicherheitsmann.py`)
   - Haupt-Script für die Überwachung
   - Läuft kontinuierlich im Hintergrund

2. **LaunchAgent** (`com.ki-sicherheitsmann.plist`)
   - Startet automatisch beim Systemstart
   - Läuft als Daemon im Hintergrund
   - Automatischer Neustart bei Absturz

3. **Verzeichnisse:**
   - `~/.ki_sicherheitsmann/` - Hauptverzeichnis
   - `~/.ki_sicherheitsmann/config.json` - Konfiguration
   - `~/.ki_sicherheitsmann/security.log` - Logs
   - `~/.ki_sicherheitsmann/reports/` - Security-Reports

---

## ⚙️ KONFIGURATION

**Config-Datei:** `~/.ki_sicherheitsmann/config.json`

**Standard-Konfiguration:**
```json
{
  "scan_interval": 30,
  "cpu_threshold": 80.0,
  "memory_threshold": 90.0,
  "load_threshold": 5.0,
  "alert_email": null,
  "suspicious_keywords": [
    "dartvm",
    "miner",
    "crypto",
    "backdoor",
    "trojan"
  ],
  "monitor_network": true,
  "monitor_processes": true,
  "monitor_system": true
}
```

**Anpassen:**
```bash
# Öffne Config
nano ~/.ki_sicherheitsmann/config.json

# Oder mit Editor
open ~/.ki_sicherheitsmann/config.json
```

---

## 📊 ÜBERWACHUNG

### Was wird überwacht:

1. **System-Ressourcen:**
   - CPU-Nutzung (Alert bei >80%)
   - RAM-Nutzung (Alert bei >90%)
   - Load Average (Alert bei >5.0)

2. **Prozesse:**
   - Verdächtige Prozesse (Keywords: dartvm, miner, crypto, etc.)
   - Hohe CPU-Nutzung (>80%)
   - Ungewöhnliche Prozess-Aktivitäten

3. **Netzwerk:**
   - Anzahl aktiver Verbindungen
   - Ungewöhnliche Netzwerk-Aktivitäten

### Scan-Intervall:

- **Standard:** 30 Sekunden
- **Anpassbar:** In `config.json` → `scan_interval`

---

## 📝 LOGS & REPORTS

### Logs ansehen:

```bash
# Live-Logs
tail -f ~/.ki_sicherheitsmann/security.log

# Letzte 50 Zeilen
tail -n 50 ~/.ki_sicherheitsmann/security.log

# LaunchAgent Logs
tail -f ~/.ki_sicherheitsmann/launchd.log
```

### Reports:

**Verzeichnis:** `~/.ki_sicherheitsmann/reports/`

**Format:** `security_report_YYYYMMDD_HHMMSS.md`

**Inhalt:**
- Datum und Zeit
- Anzahl gefundener Alerts
- Detaillierte Alert-Informationen
- Gruppiert nach Severity (ALERT, WARNING)

**Reports ansehen:**
```bash
# Neuesten Report anzeigen
ls -t ~/.ki_sicherheitsmann/reports/ | head -1 | xargs cat

# Alle Reports auflisten
ls -lh ~/.ki_sicherheitsmann/reports/
```

---

## 🎮 STEUERUNG

### Status prüfen:

```bash
# Prüfe ob läuft
launchctl list | grep ki-sicherheitsmann

# Oder
ps aux | grep ki_sicherheitsmann
```

### Manuell starten:

```bash
launchctl start com.ki-sicherheitsmann
```

### Stoppen:

```bash
launchctl stop com.ki-sicherheitsmann
```

### Neustart:

```bash
launchctl stop com.ki-sicherheitsmann
launchctl start com.ki-sicherheitsmann
```

### Entladen (deinstallieren):

```bash
launchctl unload ~/Library/LaunchAgents/com.ki-sicherheitsmann.plist
```

---

## 🔧 TROUBLESHOOTING

### Problem: KI-Sicherheitsmann läuft nicht

**Lösung:**
```bash
# 1. Prüfe Status
launchctl list | grep ki-sicherheitsmann

# 2. Prüfe Logs
tail -n 50 ~/.ki_sicherheitsmann/launchd.error.log

# 3. Manuell starten
launchctl start com.ki-sicherheitsmann

# 4. Prüfe ob Python funktioniert
python3 --version
```

### Problem: Zu viele Alerts

**Lösung:**
- Passe Thresholds in `config.json` an
- Erhöhe `cpu_threshold`, `memory_threshold`, `load_threshold`
- Entferne Keywords aus `suspicious_keywords`

### Problem: Zu hohe CPU-Nutzung

**Lösung:**
- Erhöhe `scan_interval` in `config.json` (z.B. auf 60 Sekunden)
- Deaktiviere einzelne Monitoring-Features

### Problem: Logs werden zu groß

**Lösung:**
```bash
# Logs rotieren
mv ~/.ki_sicherheitsmann/security.log ~/.ki_sicherheitsmann/security.log.old
touch ~/.ki_sicherheitsmann/security.log
```

---

## 📈 INTEGRATION MIT PREMIUM SECURITY FIX

Der KI-Sicherheitsmann arbeitet zusammen mit den Premium Security Fix Tools:

1. **KI-Sicherheitsmann:** Kontinuierliche Überwachung
2. **Premium Security Fix:** Einmalige Fixes und Scans
3. **Security Monitor:** Echtzeit-Monitoring (optional)

**Workflow:**
```
KI-Sicherheitsmann (24/7)
    ↓ (erkennt Probleme)
Premium Security Fix (manuell)
    ↓ (behebt Probleme)
KI-Sicherheitsmann (überwacht weiter)
```

---

## 🎯 BEST PRACTICES

1. **Regelmäßig prüfen:**
   - Logs täglich prüfen
   - Reports wöchentlich durchsehen
   - Config monatlich anpassen

2. **Thresholds anpassen:**
   - Basierend auf deinem System
   - Basierend auf normaler Nutzung
   - Nicht zu aggressiv (zu viele False Positives)

3. **Backup:**
   - Config regelmäßig sichern
   - Wichtige Reports aufbewahren

---

## 📞 SUPPORT

**Logs prüfen:**
```bash
tail -f ~/.ki_sicherheitsmann/security.log
```

**Status prüfen:**
```bash
launchctl list | grep ki-sicherheitsmann
```

**Config anpassen:**
```bash
nano ~/.ki_sicherheitsmann/config.json
```

---

**Erstellt von:** KI-Sicherheitsmann System  
**Datum:** 2025-12-18  
**Status:** ✅ Installiert und aktiv

