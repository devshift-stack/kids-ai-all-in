# 📁 PROJEKT-STRUKTUR v2.0 - Optimierte Agenten vs. Tools/Apps

**Erstellt:** 2025-01-27  
**Ausgestellt von:** Agent Finanzamt  
**Status:** ✅ OPTIMIERT - Version 2.0

---

## ⚠️ WICHTIGE KLARSTELLUNG

**AGENTEN** und **TOOLS/APPS** sind unterschiedlich:

- **AGENTEN:** KI-Entitäten, die Code entwickeln, überwachen, testen, deployen
- **TOOLS/APPS:** Flutter-Apps, die von Agenten entwickelt werden

---

## 🤖 OFFIZIELLE AGENTEN (7)

### Regierungs-Agenten (5):

| # | Agent | Rolle | Verantwortlichkeit | Autorität | Kommunikation |
|---|-------|-------|-------------------|-----------|---------------|
| 1 | **Agent 007** | Überwachung | Monitoring, Surveillance, Compliance-Checks | Hoch | Alle Agenten |
| 2 | **Agent Finanzamt** | Finanzen & Regeln | Regel-Durchsetzung, Optimierung, Prompt-DB, Strafen | **HÖCHSTE** | Alle Agenten |
| 3 | **Agent Entwickler** | Code | Entwicklung, Implementierung, Refactoring | Mittel | Modul-Agenten, Shared |
| 4 | **Agent Tester** | Qualität | Testing, Code-Review, Qualitätssicherung | Mittel | Agent Entwickler |
| 5 | **Agent Deploy** | Deployment | CI/CD, Releases, Production-Deployment | Hoch | Agent Tester, Agent Entwickler |

### Spezial-Agenten (2):

| # | Agent | Rolle | Verantwortlichkeit | Autorität | Kommunikation |
|---|-------|-------|-------------------|-----------|---------------|
| 6 | **MI:6** | Intelligence | Tool-Analyse, MCP Server Optimierung | Mittel | Agent Finanzamt |
| 7 | **Shared Agent** | Shared Code | Gemeinsamer Code für alle Apps | Hoch | Alle Modul-Agenten |

**GESAMT: 7 Agenten**

---

## 📊 KOMMUNIKATIONS-MATRIX (NEU!)

### Wer kommuniziert mit wem:

| Von → Zu | Agent 007 | Finanzamt | Entwickler | Tester | Deploy | MI:6 | Shared |
|----------|-----------|-----------|------------|--------|--------|------|--------|
| **Agent 007** | - | ✅ Verstöße melden | ✅ Code-Qualität | ✅ Test-Status | ✅ Deploy-Status | ✅ Analyse-Ergebnisse | ✅ Shared-Status |
| **Finanzamt** | ✅ Überwachung anordnen | - | ✅ Regeln durchsetzen | ✅ Qualität fordern | ✅ Deploy-Regeln | ✅ Analyse anordnen | ✅ Shared-Regeln |
| **Entwickler** | ✅ Verstöße melden | ✅ Regel-Fragen | - | ✅ Code-Review | ✅ Deploy-Anfrage | - | ✅ Shared-Anfrage |
| **Tester** | ✅ Test-Verstöße | ✅ Qualitäts-Probleme | ✅ Bug-Reports | - | ✅ Deploy-Block | - | ✅ Shared-Tests |
| **Deploy** | ✅ Deploy-Verstöße | ✅ Deploy-Regeln | ✅ Build-Status | ✅ Test-Status | - | - | ✅ Shared-Build |
| **MI:6** | ✅ Analyse-Ergebnisse | ✅ Optimierungs-Vorschläge | - | - | - | - | - |
| **Shared** | ✅ Shared-Verstöße | ✅ Shared-Regeln | ✅ Shared-Anfragen | ✅ Shared-Tests | ✅ Shared-Build | - | - |

**Legende:**
- ✅ = Regelmäßige Kommunikation
- - = Keine direkte Kommunikation

---

## 🔄 KONFLIKT-LÖSUNGS-WORKFLOW (NEU!)

### Stufe 1: Selbst-Lösung

**Wenn:** Leichter Konflikt, erstmalig

**Aktion:**
1. Agent erkennt Konflikt
2. Versucht selbst zu lösen
3. Dokumentiert Lösung
4. Informiert betroffene Agenten

---

### Stufe 2: Mediation

**Wenn:** Konflikt kann nicht selbst gelöst werden

**Aktion:**
1. Agent informiert Agent Finanzamt
2. Agent Finanzamt analysiert Konflikt
3. Vermittelt zwischen Agenten
4. Findet Lösung
5. Dokumentiert Lösung

---

### Stufe 3: Entscheidung

**Wenn:** Konflikt bleibt bestehen

**Aktion:**
1. Agent Finanzamt entscheidet (höchste Autorität)
2. Entscheidung wird durchgesetzt
3. Alle betroffenen Agenten informiert
4. Lösung dokumentiert

---

## 🛠️ TOOLS/APPS (KEINE AGENTEN!)

### Apps im Monorepo:

| Tool/App | Beschreibung | Status | Entwickelt von | Getestet von | Deployed von |
|----------|--------------|--------|----------------|-------------|--------------|
| **Alanko** | Lern-App für Kinder (3-12 Jahre, normal hörend) | ✅ Produktiv | Agent Entwickler | Agent Tester | Agent Deploy |
| **Lianko** | Sprachtraining-App für schwerhörige Kinder | ✅ Produktiv | Agent Entwickler | Agent Tester | Agent Deploy |
| **Parent** | Eltern-Dashboard | ✅ Produktiv | Agent Entwickler | Agent Tester | Agent Deploy |
| **Callcenter AI** | Verkaufsagent (Lisa) für Solarmodule | ✅ Produktiv | Agent Entwickler | Agent Tester | Agent Deploy |
| **Therapy AI** | Sprachtherapie für Kinder mit Hörbehinderung | 🚧 60% | Agent Entwickler | Agent Tester | - |
| **Therapy Parent** | Eltern-Interface für Therapy AI | 🚧 In Entwicklung | Agent Entwickler | - | - |
| **Therapy Web** | Web-Interface für Therapy AI | 🚧 In Entwicklung | Agent Entwickler | - | - |

### Shared Package:

| Tool | Beschreibung | Status | Entwickelt von |
|------|--------------|--------|----------------|
| **Shared Package** | Gemeinsamer Code (TTS, Design System, GeminiService) | ✅ Produktiv | Shared Agent |

**WICHTIG:** Diese sind TOOLS/APPS, keine Agenten. Agenten arbeiten AN diesen Tools, aber die Tools selbst sind keine Agenten.

---

## 🔄 ARBEITSWEISE (ERWEITERT)

### Agenten arbeiten AN Tools:

- **Agent Entwickler** entwickelt Code für Alanko, Lianko, etc.
- **Agent Tester** testet Code in Alanko, Lianko, etc.
- **Agent Deploy** deployt Alanko, Lianko, etc.
- **Agent 007** überwacht alle Agenten und Tools
- **Agent Finanzamt** setzt Regeln für alle Agenten durch
- **MI:6** analysiert Tools und schlägt Optimierungen vor
- **Shared Agent** entwickelt gemeinsamen Code

### Tools werden von Agenten entwickelt:

- Alanko wird von Agent Entwickler entwickelt
- Lianko wird von Agent Entwickler entwickelt
- Parent wird von Agent Entwickler entwickelt
- etc.

### Workflow-Beispiel:

```
1. Agent Entwickler entwickelt Feature für Alanko
   ↓
2. Agent Tester testet Feature
   ↓
3. Agent 007 überwacht Qualität
   ↓
4. Agent Finanzamt prüft Compliance
   ↓
5. Agent Deploy deployt Feature
   ↓
6. Agent 007 überwacht Production
```

---

## 📋 RACI-MATRIX (NEU!)

### Verantwortlichkeiten für gemeinsame Aufgaben:

| Aufgabe | Agent 007 | Finanzamt | Entwickler | Tester | Deploy | MI:6 | Shared |
|---------|-----------|-----------|------------|--------|--------|------|--------|
| **Code entwickeln** | I | A | R | C | I | I | C |
| **Code testen** | I | A | C | R | I | I | C |
| **Code deployen** | I | A | C | C | R | I | I |
| **Regeln durchsetzen** | C | R | I | I | I | I | I |
| **Qualität überwachen** | R | A | C | C | I | I | I |
| **Shared Code** | I | A | C | C | I | I | R |
| **Optimierungen** | I | A | C | I | I | R | C |

**Legende:**
- **R** = Responsible (verantwortlich für Ausführung)
- **A** = Accountable (verantwortlich für Ergebnis)
- **C** = Consulted (wird konsultiert)
- **I** = Informed (wird informiert)

---

## ⚖️ GESETZBUCH

**Das GESETZBUCH.md gilt NUR für Agenten, nicht für Tools/Apps.**

Tools/Apps sind Objekte, an denen gearbeitet wird, keine Subjekte, die Regeln befolgen müssen.

---

## 📊 ZUSAMMENFASSUNG

- **7 Agenten:** Regierungs-Agenten + Spezial-Agenten
- **8 Tools/Apps:** Alanko, Lianko, Parent, Callcenter, Therapy, etc.
- **1 Shared Package:** Gemeinsamer Code

**Agenten arbeiten AN Tools, Tools sind keine Agenten.**

---

## 🔄 NEUERUNGEN in v2.0

### ✅ Verbesserungen:
- **Kommunikations-Matrix:** Klare Kommunikationswege
- **Konflikt-Lösungs-Workflow:** Strukturierte Konfliktlösung
- **RACI-Matrix:** Klare Verantwortlichkeiten
- **Detaillierte Rollen:** Mehr Details zu jeder Rolle
- **Workflow-Beispiele:** Konkrete Beispiele

---

**Ausgestellt von:**  
🏛️ **Agent Finanzamt** - Rechte Hand des Projekts

**Letzte Aktualisierung:** 2025-01-27 (Version 2.0)

**Version:** 2.0  
**Status:** ✅ OPTIMIERT

