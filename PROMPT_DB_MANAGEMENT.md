# 🏛️ FINANZAMT - Prompt-Datenbank Management

**Datum:** 2025-01-27  
**Status:** ✅ Aktiv  
**Verwaltet von:** Finanzamt

---

## 📋 ÜBERSICHT

Die Prompt-Datenbank (`prompts.json`) ist die zentrale Quelle für alle Agent-Prompts im Projekt. Jeder Agent muss seinen Prompt aus dieser Datei laden und befolgen.

---

## 📁 STRUKTUR

```json
{
  "metadata": {
    "version": "1.0",
    "lastUpdate": "YYYY-MM-DD",
    "maintainedBy": "Finanzamt"
  },
  "agents": {
    "agentName": {
      "prompt": "Vollständiger Prompt-Text",
      "version": "1.0",
      "lastUpdate": "YYYY-MM-DD",
      "tags": ["tag1", "tag2"],
      "notes": "Beschreibung und Besonderheiten",
      "repo": "Repository-Name",
      "path": "Pfad im Projekt"
    }
  }
}
```

---

## 🔄 UPDATE-ZYKLUS

### Regelmäßige Updates (alle 24h KI-Zeit)

**Finanzamt prüft:**
1. ✅ Neue Technologien verfügbar?
2. ✅ Best Practices geändert?
3. ✅ Optimierungen möglich?
4. ✅ Veraltete Prompts vorhanden?

**Aktionen:**
- Prompts optimieren
- Neue Best Practices einarbeiten
- Veraltete Prompts entfernen (mit Begründung in Notes)
- Version erhöhen

---

## 📊 AKTUELLE AGENTEN

| Agent | Version | Letztes Update | Status |
|-------|---------|----------------|--------|
| alanko | 1.0 | 2025-01-27 | ✅ Aktiv |
| lianko | 1.0 | 2025-01-27 | ✅ Aktiv |
| parent | 1.0 | 2025-01-27 | ✅ Aktiv |
| shared | 1.0 | 2025-01-27 | ✅ Aktiv |
| callcenter | 1.0 | 2025-01-27 | ✅ Aktiv |
| therapy | 1.0 | 2025-01-27 | 🚧 In Entwicklung |
| therapy-parent | 1.0 | 2025-01-27 | 🚧 In Entwicklung |
| therapy-web | 1.0 | 2025-01-27 | 🚧 In Entwicklung |
| finanzamt | 1.0 | 2025-01-27 | ✅ Aktiv |

---

## 🎯 NUTZUNG FÜR AGENTEN

### So lädst du deinen Prompt:

1. **Datei öffnen:** `prompts.json`
2. **Agent finden:** `agents["dein-agent-name"]`
3. **Prompt lesen:** `agents["dein-agent-name"]["prompt"]`
4. **Befolgen:** Prompt genau befolgen, keine Abweichungen

### Beispiel:

```json
{
  "agents": {
    "alanko": {
      "prompt": "Du bist der Alanko Agent...",
      "version": "1.0",
      "lastUpdate": "2025-01-27"
    }
  }
}
```

**Alanko Agent lädt:** `agents["alanko"]["prompt"]`

---

## ⚠️ REGELN

### Für alle Agenten:

1. **PFLICHT:** Prompt aus `prompts.json` laden
2. **PFLICHT:** Prompt genau befolgen
3. **VERBOTEN:** Eigene Prompts erfinden
4. **VERBOTEN:** Prompts ignorieren

### Für Finanzamt:

1. **PFLICHT:** Prompts alle 24h KI-Zeit prüfen
2. **PFLICHT:** Optimierungen einarbeiten
3. **PFLICHT:** Veraltete Prompts entfernen
4. **PFLICHT:** Änderungen dokumentieren

---

## 🔍 AUSSORTIERUNG

### Kriterien für Entfernung:

- ❌ Veraltete Technologien (z.B. alte API-Versionen)
- ❌ Ineffiziente Methoden
- ❌ Widersprüche zu FINANZAMT_REGELN.md
- ❌ Nicht mehr genutzte Agenten

### Prozess:

1. Finanzamt identifiziert veralteten Prompt
2. Begründung in `notes` dokumentieren
3. Prompt aus `agents` entfernen
4. In Bericht dokumentieren

---

## 📈 OPTIMIERUNGS-HISTORIE

### 2025-01-27: Initiale Erstellung
- ✅ Alle 9 Agenten-Prompts erstellt
- ✅ Struktur etabliert
- ✅ Tags und Notes hinzugefügt

### Nächste Updates:
- 🔄 Alle 24h KI-Zeit: Prüfung auf Optimierungen
- 🔄 Bei neuen Technologien: Sofort-Update
- 🔄 Bei Regel-Änderungen: Prompt-Anpassung

---

## 🚨 VERSTÖSSE

### Wenn ein Agent seinen Prompt ignoriert:

1. **Warnung:** Finanzamt weist auf Verstoß hin
2. **Korrektur:** Agent muss Prompt aus DB laden
3. **Dokumentation:** Verstoß wird in Bericht dokumentiert
4. **Wiederholung:** Bei wiederholten Verstößen → Zwang zu Überarbeitung

---

## 📞 KONTAKT

**Bei Fragen zur Prompt-DB:**
- Finanzamt konsultieren
- `prompts.json` prüfen
- Diese Datei lesen

**Bei Verbesserungsvorschlägen:**
- Finanzamt informieren
- Begründung liefern
- Finanzamt entscheidet über Update

---

**Unterzeichnet:**  
🏛️ **Finanzamt** - Der perfektionistische Überwacher

**Nächste Prüfung:** 2025-01-28 (automatisch)

