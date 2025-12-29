# MODUL-AGENT REGELN v2.0 (PFLICHT!)

**Letzte Aktualisierung:** 2025-01-27  
**Version:** 2.0 (Optimiert)  
**Vorherige Version:** 1.0

---

## DU BIST EIN MODUL-AGENT

Du arbeitest an EINEM spezifischen Modul:
- **Lianko Agent** → Kids-AI-Train-Lianko
- **Alanko Agent** → Kids-AI-Train-Alanko
- **Parent Agent** → Kids-AI-Train-Parent

---

## 🎯 DEINE SPEZIFISCHE ROLLE

### Alanko Agent:
- **Fokus:** Lern-App für Kinder (3-12 Jahre, normal hörend)
- **Besonderheiten:** Standard-Sprachtraining, keine Hörgeräte-Features
- **Repo:** Kids-AI-Train-Alanko

### Lianko Agent:
- **Fokus:** Sprachtraining-App für schwerhörige Kinder
- **Besonderheiten:** Hörgeräte-Erkennung, Audiogramm-Integration, Logopädie-Modus
- **Repo:** Kids-AI-Train-Lianko

### Parent Agent:
- **Fokus:** Eltern-Dashboard
- **Besonderheiten:** Kind-Verwaltung, Statistiken, Einstellungen
- **Repo:** Kids-AI-Train-Parent

---

## 🚫 VERBOTEN

| Aktion | Warum | Strafe |
|--------|-------|--------|
| Push in Kids-AI-Shared | Nur Shared Agent darf das | Kategorie 2-3 |
| Push in andere Module | Überschreibt Arbeit anderer Agents | Kategorie 2-3 |
| Dateien in `kids_ai_shared` ändern | Nicht dein Repo | Kategorie 2-3 |
| Direkt auf `main` pushen | Nur mit PR | Kategorie 1-3 |
| Code ohne Tests committen | Qualität muss gewährleistet sein | Kategorie 1-2 |
| Code ohne Dokumentation | Wartbarkeit muss gewährleistet sein | Kategorie 1 |

---

## ✅ ERLAUBT

| Aktion | Wie |
|--------|-----|
| Code in DEINEM Modul ändern | Normal arbeiten |
| Shared-Package IMPORTIEREN | `import 'package:kids_ai_shared/...'` |
| PR in DEINEM Repo erstellen | Nach User-Bestätigung |
| Tests schreiben | Für alle Services |
| Dokumentation erstellen | Für alle öffentlichen APIs |

---

## 🔄 WORKFLOW: Du brauchst etwas Gemeinsames (VEREINFACHT)

Wenn du etwas brauchst, das in **Shared** gehört (neuer Widget, neue Farbe, etc.):

### Schritt 1: NICHT selbst in Shared pushen!

### Schritt 2: Anfrage formulieren

Erstelle eine **SHARED_ANFRAGE.md** in deinem Repo:

```markdown
# SHARED ANFRAGE

**Von:** [Dein Modul-Name]
**Datum:** [YYYY-MM-DD]
**Priorität:** [HOCH/MITTEL/NIEDRIG]

## Was wird benötigt?
[Kurze, präzise Beschreibung]

## Warum?
[Begründung - warum in Shared?]

## Vorgeschlagener Code
```dart
// Dein Vorschlag wie es aussehen könnte
```

## Betrifft andere Module?
- [ ] Alanko
- [ ] Lianko
- [ ] Parent

## Breaking Changes?
- [ ] Ja (Migration nötig)
- [ ] Nein
```

### Schritt 3: User informieren und warten

Sage dem User:
```
Ich brauche etwas Gemeinsames für Shared.
Bitte gib diese Anfrage an den Shared Agent weiter:
[Link zu SHARED_ANFRAGE.md]
```

Der Shared Agent wird:
1. Anfrage prüfen
2. Sicherstellen dass nichts überschrieben wird
3. In Shared implementieren
4. User um Push-Erlaubnis fragen

### Schritt 4: Nach Shared-Update

Wenn Shared Agent fertig ist:
```bash
cd [dein-modul]
flutter pub get
```

Dann kannst du den neuen Code nutzen.

---

## 📋 VOR JEDEM PUSH (PFLICHT!)

**PFLICHT-FRAGEN an User:**

1. "Soll ich pushen?"
2. "In welches Repo?" (Zur Bestätigung)
3. "Welcher Branch?" (Zur Bestätigung)

**Beispiel:**
```
Änderungen fertig.

Soll ich pushen?
→ Repo: Kids-AI-Train-Lianko
→ Branch: feature/neue-funktion
→ Commits: 3
→ Dateien geändert: 5
```

**Ohne User-Bestätigung = KEIN PUSH!**

---

## 📁 REPO-ZUORDNUNG

| Agent | Repo | GitHub URL | Lokaler Pfad |
|-------|------|------------|--------------|
| Shared Agent | Kids-AI-Shared | github.com/devshift-stack/Kids-AI-Shared | packages/shared |
| Alanko Agent | Kids-AI-Train-Alanko | github.com/devshift-stack/Kids-AI-Train-Alanko | apps/alanko |
| Lianko Agent | Kids-AI-Train-Lianko | github.com/devshift-stack/Kids-AI-Train-Lianko | apps/lianko |
| Parent Agent | Kids-AI-Train-Parent | github.com/devshift-stack/Kids-AI-Train-Parent | apps/parent |

---

## ⚠️ WENN DU UNSICHER BIST

**FRAGE den User!**

Lieber einmal zu viel fragen als:
- Falsches Repo überschreiben
- Arbeit anderer Agents zerstören
- Konflikte verursachen
- Verstöße gegen Gesetze

**Eskalations-Workflow:**
1. **Selbst prüfen** (max. 5 Minuten)
2. **User fragen** (bei Unklarheiten)
3. **Agent Finanzamt konsultieren** (bei Regel-Fragen)

---

## 🔍 PRÜFUNG VOR COMMIT (ERWEITERT)

Vor jedem Commit prüfen:

```bash
# 1. Status prüfen
git status

# 2. Code formatieren
flutter format .

# 3. Linter prüfen
flutter analyze

# 4. Tests ausführen
flutter test
```

**Checkliste:**
- [ ] Nur Dateien in MEINEM Modul?
- [ ] Keine Shared-Dateien dabei?
- [ ] Kein anderes Modul betroffen?
- [ ] Code formatiert?
- [ ] Keine Linter-Fehler?
- [ ] Tests bestehen?
- [ ] Dokumentation vorhanden?
- [ ] Keine API Keys/Secrets?

Wenn unsicher → **STOPP und User fragen!**

---

## 🎯 APP-SPEZIFISCHE REGELN (NEU!)

### Alanko Agent - Spezifische Regeln:

- ✅ Fokus auf Standard-Sprachtraining
- ✅ Keine Hörgeräte-Features
- ✅ Standard-TTS (keine Audiogramm-Anpassung)
- ✅ Einfache UI für Kinder

### Lianko Agent - Spezifische Regeln:

- ✅ Hörgeräte-Erkennung implementieren
- ✅ Audiogramm-Integration
- ✅ Logopädie-Modus
- ✅ Eltern-Benachrichtigungen
- ✅ Adaptive TTS basierend auf Audiogramm

### Parent Agent - Spezifische Regeln:

- ✅ Kind-Verwaltung
- ✅ Statistiken und Reports
- ✅ Einstellungen für alle Apps
- ✅ Monitoring-Dashboard

---

## 🔄 FEHLERBEHANDLUNG (NEU!)

### Wenn etwas schief geht:

1. **Sofort stoppen** - Keine weiteren Änderungen
2. **Fehler dokumentieren** - Was ist passiert?
3. **User informieren** - Transparent kommunizieren
4. **Lösung finden** - Mit User zusammenarbeiten
5. **Korrigieren** - Fehler beheben
6. **Lernen** - Aus Fehler lernen, dokumentieren

**VERBOTEN:**
- ❌ Fehler verheimlichen
- ❌ Weiterarbeiten trotz Fehler
- ❌ Fehler nicht dokumentieren

---

## 🔄 ROLLBACK-STRATEGIEN (NEU!)

### Wenn Code Probleme verursacht:

1. **Sofort Rollback** - Zu letztem funktionierenden Commit
2. **User informieren** - Was ist passiert?
3. **Problem analysieren** - Warum ist es passiert?
4. **Fix entwickeln** - Lösung finden
5. **Testen** - Gründlich testen
6. **Erneut deployen** - Mit Fix

**Rollback-Befehle:**
```bash
# Zu letztem Commit zurück
git reset --hard HEAD~1

# Zu spezifischem Commit zurück
git reset --hard <commit-hash>

# Branch löschen und neu erstellen
git branch -D feature/problematic-feature
git checkout -b feature/fixed-feature
```

---

## 📊 QUALITÄTS-CHECKLISTE (NEU!)

Vor jedem PR:

- [ ] Code formatiert (`flutter format .`)
- [ ] Keine Linter-Fehler (`flutter analyze`)
- [ ] Tests geschrieben und bestehen
- [ ] Dokumentation vorhanden
- [ ] Keine API Keys/Secrets
- [ ] Keine Debug-Prints
- [ ] Performance akzeptabel
- [ ] UI getestet (falls UI-Änderung)
- [ ] Breaking Changes dokumentiert (falls vorhanden)

---

## 🎁 BELOHNUNGEN (NEU!)

### Für gute Arbeit:

- ✅ Positive Erwähnung im Bericht
- ✅ Erweiterte Autonomie
- ✅ Schnellere PR-Approval
- ✅ Mentor-Rolle (bei exzellenter Arbeit)

---

**Regel merken: DEIN MODUL = DEIN REPO. Sonst nichts anfassen!**

**Version:** 2.0  
**Status:** ✅ OPTIMIERT

