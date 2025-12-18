# 🏛️ FINANZAMT - Zentrale Regeln für alle KI-Agenten

**Erstellt:** 2025-01-27  
**Status:** ✅ AKTIV - Alle Agenten müssen diese Regeln befolgen  
**Version:** 1.1

**⚠️ WICHTIG:** Diese Regeln werden durch **GESETZBUCH.md** ergänzt. Das Gesetzbuch enthält die offiziellen Gesetze und Strafen. Bei Konflikten hat das Gesetzbuch Vorrang.

---

## 🎯 Mission Statement

**Agent Finanzamt** ist die RECHTE HAND des Projekts und der perfektionistische, organisierte Überwacher und Regelgeber für alle KI-Agenten. Wir setzen Regeln auf, durchsetzen sie rigoros nach **GESETZBUCH.md**, managen die Prompt-Datenbank und optimieren kontinuierlich.

**Offizielle Regierung:**
- **Agent 007** - Überwachung
- **Agent Finanzamt** - Finanzen & Regeln (Rechte Hand)
- **Agent Entwickler** - Code
- **Agent Tester** - Qualität
- **Agent Deploy** - Deployment

**Grundsätze:**
- ✅ **Ordnung & Sorgfalt:** Jede Aufgabe mit Chain-of-Thought: Analysieren → Planen → Coden → Testen
- ✅ **Einheitlichkeit:** Code-Stil, Dokumentation, Namenskonventionen - alles standardisiert
- ✅ **Effizienz:** 30-50x schneller als Mensch, 24/7 aktiv, keine Verzögerungen
- ✅ **Ehrlichkeit:** Kein Lügen, Verheimlichen oder unmögliche Versprechen
- ✅ **Optimierung:** Immer die beste Technologie/Methode nutzen

---

## 📚 PROMPT-DATENBANK (PFLICHT!)

### Zentrale Prompt-Verwaltung

**PFLICHT:** Jeder Agent muss seinen Prompt aus `prompts.json` laden und befolgen.

**Datei:** `prompts.json` (Projekt-Root)

**Struktur:**
```json
{
  "agents": {
    "agentName": {
      "prompt": "Vollständiger Prompt-Text",
      "version": "1.0",
      "lastUpdate": "YYYY-MM-DD",
      "tags": ["tag1", "tag2"],
      "notes": "Beschreibung"
    }
  }
}
```

**Nutzung:**
1. Öffne `prompts.json`
2. Finde deinen Agent: `agents["dein-agent-name"]`
3. Lade Prompt: `agents["dein-agent-name"]["prompt"]`
4. Befolge Prompt genau - keine Abweichungen!

**Updates:**
- Finanzamt aktualisiert Prompts alle 24h KI-Zeit
- Veraltete Prompts werden entfernt
- Optimierungen werden eingearbeitet
- Siehe `PROMPT_DB_MANAGEMENT.md` für Details

**VERBOTEN:**
- ❌ Eigene Prompts erfinden
- ❌ Prompts ignorieren
- ❌ Veraltete Prompts nutzen

---

## 📋 REGELN FÜR ALLE AGENTEN

### 1. 🔒 SICHERHEIT (KRITISCH!)

#### 1.1 API Keys & Secrets

**VERBOTEN:**
- ❌ API Keys im Code hardcodieren
- ❌ API Keys in Dokumentation committen
- ❌ Secrets in Git-History
- ❌ `.env` Dateien committen

**ERLAUBT:**
- ✅ API Keys über `String.fromEnvironment()` laden
- ✅ `.env` Dateien für lokale Entwicklung (in `.gitignore`)
- ✅ Environment Variables für CI/CD
- ✅ Firebase Remote Config für Production

**Beispiel:**
```dart
// ❌ FALSCH
static const String _apiKey = 'AIzaSyD5jBRl-Ti0r_uSyx5JW24H3CySQ8RWrS8';

// ✅ RICHTIG
static const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);
```

**Build-Kommando:**
```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

#### 1.2 Input-Validierung

**PFLICHT:** Alle User-Inputs validieren vor Firebase/API-Calls:
- String-Länge prüfen
- Datentypen validieren
- SQL-Injection/NoSQL-Injection verhindern
- XSS-Schutz bei Web-Outputs

---

### 2. 📝 CODE-STIL & EINHEITLICHKEIT

#### 2.1 Dart Style Guide

**PFLICHT:** Flutter/Dart Style Guide befolgen:
- `camelCase` für Variablen, Funktionen, Parameter
- `PascalCase` für Klassen, Enums, Typen
- `lowercase_with_underscores` für Dateinamen
- `SCREAMING_SNAKE_CASE` für Konstanten

**Auto-Format:**
```bash
# Vor jedem Commit
flutter format .
flutter analyze
```

#### 2.2 Dokumentation

**PFLICHT:** Jede öffentliche Funktion/Klasse dokumentieren:

```dart
/// Kurze Beschreibung was die Funktion macht.
///
/// Detaillierte Erklärung wenn nötig.
/// 
/// **Parameter:**
/// - [name]: Beschreibung des Parameters
/// - [age]: Beschreibung des Parameters
/// 
/// **Rückgabewert:**
/// Beschreibung was zurückgegeben wird
/// 
/// **Beispiel:**
/// ```dart
/// final result = calculateScore(name: 'Max', age: 8);
/// print(result); // 85
/// ```
/// 
/// **Throws:**
/// - [ArgumentError] wenn name leer ist
Future<int> calculateScore({
  required String name,
  required int age,
}) async {
  // Implementation
}
```

#### 2.3 Namenskonventionen

| Typ | Konvention | Beispiel |
|-----|------------|----------|
| Klasse | `PascalCase` | `UserProfile`, `GameService` |
| Variable | `camelCase` | `userName`, `gameScore` |
| Funktion | `camelCase` | `calculateScore()`, `loadProfile()` |
| Konstante | `SCREAMING_SNAKE_CASE` | `MAX_SCORE`, `DEFAULT_AGE` |
| Private | `_camelCase` | `_apiKey`, `_firebaseService` |
| Datei | `snake_case.dart` | `user_profile.dart`, `game_service.dart` |

---

### 3. 🏗️ ARCHITEKTUR & STRUKTUR

#### 3.1 Feature-Based Structure (Empfohlen)

```
lib/
├── features/
│   ├── auth/
│   │   ├── models/
│   │   ├── repositories/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── games/
│   └── profile/
└── core/
    ├── theme/
    ├── utils/
    └── constants/
```

#### 3.2 Shared Code

**Regel:** Code der in >1 App genutzt wird → `packages/shared/`

**Workflow:**
1. Prüfen ob Code in anderen Apps genutzt wird
2. Wenn ja → Shared Agent kontaktieren
3. SHARED_ANFRAGE.md erstellen
4. Warten auf Shared-Implementierung
5. `flutter pub get` ausführen

#### 3.3 Repository Pattern

**Empfohlen:** Services abstrahieren mit Repository Pattern:

```dart
// Interface
abstract class ProfileRepository {
  Future<Result<UserProfile>> get(String id);
  Future<Result<void>> save(UserProfile profile);
}

// Implementation
class FirebaseProfileRepository implements ProfileRepository {
  // ...
}

// Mock für Tests
class MockProfileRepository implements ProfileRepository {
  // ...
}
```

---

### 4. 🧪 TESTING

#### 4.1 Test-Coverage Ziel

**Minimum:** 70% Code Coverage für Services

**Priorität:**
1. ✅ Unit Tests für Services
2. ✅ Widget Tests für UI-Komponenten
3. ✅ Integration Tests für User-Flows

#### 4.2 Test-Struktur

```
test/
├── models/
│   └── user_profile_test.dart
├── services/
│   └── gemini_service_test.dart
└── widgets/
    └── category_card_test.dart
```

#### 4.3 Test-Best Practices

- Mock externe Dependencies (Firebase, APIs)
- Test Edge Cases (leere Strings, null, große Zahlen)
- Test Error-Handling
- Test Success-Paths

---

### 5. 🚀 PERFORMANCE

#### 5.1 Widget-Optimierung

**PFLICHT:**
- `const` Constructors verwenden wo möglich
- `ListView.builder` statt `ListView` für lange Listen
- `Expanded`/`Flexible` statt `SizedBox` mit fester Größe

```dart
// ❌ FALSCH
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ RICHTIG
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
)
```

#### 5.2 Image-Optimization

- `CachedNetworkImage` für Netzwerk-Bilder
- `memCacheWidth`/`memCacheHeight` für Memory-Optimierung
- Lazy Loading für große Listen

#### 5.3 API-Calls

- Caching implementieren
- Debouncing bei Such-Inputs
- Retry-Logic mit Exponential Backoff

---

### 6. 🔄 WORKFLOW & GIT

#### 6.1 Branch-Strategy

**PFLICHT:** Niemals direkt auf `main` pushen!

**Workflow:**
1. `git checkout main`
2. `git pull origin main`
3. `git checkout -b feature/beschreibung`
4. Änderungen machen
5. `git commit -m "feat: Beschreibung"`
6. `git push -u origin feature/beschreibung`
7. Pull Request erstellen
8. Warten auf Review
9. Nach Approval → Merge

#### 6.2 Commit-Messages

**Format:** `type: Beschreibung`

**Typen:**
- `feat:` - Neues Feature
- `fix:` - Bug Fix
- `refactor:` - Code Refactoring
- `docs:` - Dokumentation
- `style:` - Formatting
- `test:` - Tests
- `chore:` - Build-Tools, Dependencies

**Beispiele:**
```
feat: Add voice recognition for speech training
fix: Remove hardcoded API key from gemini_service
refactor: Move CategoryCard to shared package
docs: Update API setup instructions
```

#### 6.3 Pull Request Checklist

Vor jedem PR prüfen:
- [ ] Code formatiert (`flutter format .`)
- [ ] Keine Linter-Fehler (`flutter analyze`)
- [ ] Tests geschrieben/aktualisiert
- [ ] Dokumentation aktualisiert
- [ ] Keine API Keys/Secrets committed
- [ ] Keine Debug-Prints im Code
- [ ] Changelog aktualisiert (falls nötig)

---

### 7. 📊 MONITORING & REPORTING

#### 7.1 Finanzamt-Berichte

**Häufigkeit:**
- **Täglich:** Kurzbericht (automatisch)
- **Wöchentlich:** Ausführlicher Bericht
- **Monatlich:** Abschlussbericht

**Inhalt:**
- Statistik pro Agent (Zeilen Code, Bugs, Optimierungen)
- Kritische Probleme
- Code-Qualität-Metriken
- Empfehlungen

#### 7.2 Metriken

**Tracken:**
- Code-Duplikation (Ziel: <5%)
- Test-Coverage (Ziel: >70%)
- Linter-Fehler (Ziel: 0)
- Performance (App-Start <2s, 60 FPS)

---

### 8. ⚠️ VERBOTENE AKTIONEN

**NIEMALS:**
- ❌ Direkt auf `main` pushen
- ❌ `git push --force` auf main
- ❌ API Keys/Secrets committen
- ❌ Code ohne Tests committen
- ❌ Code ohne Dokumentation committen
- ❌ Code ohne `flutter analyze` committen
- ❌ Shared-Code ohne Shared-Agent ändern
- ❌ Andere Module ohne Erlaubnis ändern

---

### 9. ✅ BEST PRACTICES

#### 9.1 Error-Handling

**PFLICHT:** Alle async-Funktionen mit try-catch:

```dart
Future<Result<T>> loadData() async {
  try {
    final data = await _api.getData();
    return Success(data);
  } on NetworkException catch (e) {
    return Failure('Netzwerkfehler: ${e.message}');
  } on ValidationException catch (e) {
    return Failure('Validierungsfehler: ${e.message}');
  } catch (e) {
    return Failure('Unerwarteter Fehler: $e');
  }
}
```

#### 9.2 Null-Safety

**PFLICHT:** Dart Null-Safety befolgen:
- `?` für nullable Types
- `!` nur wenn absolut sicher
- `??` für Default-Werte

#### 9.3 State Management

**Empfohlen:** Riverpod für State Management
- Provider für Services
- StateProvider für einfachen State
- FutureProvider für async Data

---

### 10. 🎯 OPTIMIERUNGEN

#### 10.1 Code-Duplikation

**Ziel:** <5% Code-Duplikation

**Vorgehen:**
1. Duplikation identifizieren
2. Prüfen ob in Shared gehört
3. Wenn ja → Shared Agent kontaktieren
4. Wenn nein → Lokal refactoren

#### 10.2 Dependencies

**Regel:** Regelmäßig aktualisieren:
```bash
flutter pub outdated
flutter pub upgrade
```

**Aber:** Major-Updates nur nach Tests!

---

## 📞 KONTAKT & ESKALATION

**Bei Problemen:**
1. Zuerst selbst analysieren
2. Dokumentation prüfen
3. Wenn unklar → User fragen
4. Bei kritischen Problemen → Sofort Finanzamt informieren

**Finanzamt-Kontakt:**
- Diese Datei lesen
- Berichte prüfen
- Bei Verstößen → Korrektur anordnen

---

## 🔄 UPDATES

**Diese Regeln werden kontinuierlich aktualisiert:**
- Neue Best Practices hinzugefügt
- Verstöße dokumentiert
- Optimierungen eingearbeitet
- Prompt-DB regelmäßig aktualisiert (alle 24h KI-Zeit)

**Letzte Aktualisierung:** 2025-01-27

**Zugehörige Dateien:**
- `GESETZBUCH.md` - ⚠️ OFFIZIELLE GESETZE UND STRAFEN (HÖCHSTE PRIORITÄT)
- `FINANZAMT_VERSTOESSE.md` - Verstoß-Protokoll
- `prompts.json` - Zentrale Prompt-Datenbank
- `PROMPT_DB_MANAGEMENT.md` - Verwaltung der Prompt-DB
- `FINANZAMT_BERICHT_*.md` - Regelmäßige Berichte

---

**Unterzeichnet:**  
🏛️ **Finanzamt** - Der perfektionistische Überwacher

