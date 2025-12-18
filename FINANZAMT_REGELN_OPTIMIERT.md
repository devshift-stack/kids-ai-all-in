# 🏛️ FINANZAMT REGELN v2.0 - Optimierte Zentrale Regeln

**Erstellt:** 2025-01-27  
**Status:** ✅ OPTIMIERT - Version 2.0  
**Vorherige Version:** 1.1

---

## 📋 QUICK-REFERENCE

| Regel | Priorität | Wichtigste Punkte |
|-------|-----------|------------------|
| **1. Sicherheit** | 🔴 KRITISCH | Keine API Keys, Input-Validierung, Secrets schützen |
| **2. Code-Stil** | 🟡 WICHTIG | Dart Style Guide, Dokumentation, Tests |
| **3. Architektur** | 🟡 WICHTIG | Feature-Based, Repository Pattern, Shared Code |
| **4. Testing** | 🟡 WICHTIG | 70% Coverage, Unit/Widget/Integration Tests |
| **5. Performance** | 🟢 EMPFOHLEN | Widget-Optimierung, Caching, Lazy Loading |
| **6. Workflow** | 🟡 WICHTIG | Branch-Strategy, PR, Commit-Messages |
| **7. Monitoring** | 🟢 EMPFOHLEN | Berichte, Metriken, Tracking |
| **8. Optimierung** | 🟢 EMPFOHLEN | Code-Duplikation <5%, Dependencies aktualisieren |

---

## 🎯 MISSION STATEMENT

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
  "metadata": {
    "version": "2.0",
    "lastUpdate": "YYYY-MM-DD",
    "maintainedBy": "Agent Finanzamt"
  },
  "agents": {
    "agentName": {
      "prompt": "Vollständiger Prompt-Text",
      "version": "1.0",
      "lastUpdate": "YYYY-MM-DD",
      "tags": ["tag1", "tag2"],
      "notes": "Beschreibung",
      "dependencies": ["otherAgent"],
      "author": "Agent Finanzamt"
    }
  }
}
```

**Nutzung:**
1. Öffne `prompts.json`
2. Finde deinen Agent: `agents["dein-agent-name"]`
3. Lade Prompt: `agents["dein-agent-name"]["prompt"]`
4. Prüfe Version: `agents["dein-agent-name"]["version"]`
5. Befolge Prompt genau - keine Abweichungen!

**Updates:**
- Finanzamt aktualisiert Prompts alle 24h KI-Zeit
- Veraltete Prompts werden entfernt
- Optimierungen werden eingearbeitet
- Siehe `PROMPT_DB_MANAGEMENT.md` für Details

**VERBOTEN:**
- ❌ Eigene Prompts erfinden
- ❌ Prompts ignorieren
- ❌ Veraltete Prompts nutzen
- ❌ Prompt ohne User-Bestätigung ändern

---

## 📋 REGELN FÜR ALLE AGENTEN (OPTIMIERT)

### 1. 🔒 SICHERHEIT (🔴 KRITISCH!)

#### 1.1 API Keys & Secrets

**VERBOTEN:**
- ❌ API Keys im Code hardcodieren
- ❌ API Keys in Dokumentation committen
- ❌ Secrets in Git-History
- ❌ `.env` Dateien committen
- ❌ API Keys in Logs ausgeben

**ERLAUBT:**
- ✅ API Keys über `String.fromEnvironment()` laden
- ✅ `.env` Dateien für lokale Entwicklung (in `.gitignore`)
- ✅ Environment Variables für CI/CD
- ✅ Firebase Remote Config für Production
- ✅ Secure Storage für sensible Daten

**Beispiel (OPTIMIERT):**
```dart
// ❌ FALSCH
static const String _apiKey = 'AIzaSyD5jBRl-Ti0r_uSyx5JW24H3CySQ8RWrS8';

// ✅ RICHTIG - Mit Fallback und Validierung
static String get _apiKey {
  const key = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );
  
  if (key.isEmpty) {
    throw StateError(
      'GEMINI_API_KEY nicht gesetzt! '
      'Nutze: flutter run --dart-define=GEMINI_API_KEY=your_key'
    );
  }
  
  return key;
}
```

**Build-Kommando:**
```bash
flutter run --dart-define=GEMINI_API_KEY=your_key_here
```

#### 1.2 Input-Validierung (ERWEITERT)

**PFLICHT:** Alle User-Inputs validieren vor Firebase/API-Calls:

```dart
// ✅ RICHTIG - Vollständige Validierung
String? validateInput(String? input) {
  if (input == null || input.isEmpty) {
    return 'Eingabe darf nicht leer sein';
  }
  
  if (input.length > 1000) {
    return 'Eingabe zu lang (max. 1000 Zeichen)';
  }
  
  // SQL-Injection/NoSQL-Injection verhindern
  if (input.contains(RegExp(r'[<>"\';]'))) {
    return 'Ungültige Zeichen enthalten';
  }
  
  return null; // Validierung erfolgreich
}
```

**Validierungs-Checkliste:**
- [ ] String-Länge prüfen
- [ ] Datentypen validieren
- [ ] SQL-Injection/NoSQL-Injection verhindern
- [ ] XSS-Schutz bei Web-Outputs
- [ ] Null-Checks
- [ ] Format-Validierung (Email, URL, etc.)

---

### 2. 📝 CODE-STIL & EINHEITLICHKEIT (🟡 WICHTIG)

#### 2.1 Dart Style Guide (ERWEITERT)

**PFLICHT:** Flutter/Dart Style Guide befolgen:

| Typ | Konvention | Beispiel |
|-----|------------|----------|
| Klasse | `PascalCase` | `UserProfile`, `GameService` |
| Variable | `camelCase` | `userName`, `gameScore` |
| Funktion | `camelCase` | `calculateScore()`, `loadProfile()` |
| Konstante | `SCREAMING_SNAKE_CASE` | `MAX_SCORE`, `DEFAULT_AGE` |
| Private | `_camelCase` | `_apiKey`, `_firebaseService` |
| Datei | `snake_case.dart` | `user_profile.dart`, `game_service.dart` |
| Enum | `PascalCase` | `GameState`, `UserRole` |
| Extension | `PascalCase` | `StringExtensions`, `DateTimeExtensions` |

**Auto-Format (OPTIMIERT):**
```bash
# Vor jedem Commit - Vollständige Checkliste
flutter format .                    # Code formatieren
flutter analyze                     # Linter-Fehler prüfen
flutter test                        # Tests ausführen
dart fix --apply                    # Automatische Fixes
```

#### 2.2 Dokumentation (ERWEITERT)

**PFLICHT:** Jede öffentliche Funktion/Klasse dokumentieren:

```dart
/// Berechnet den Score für einen Benutzer basierend auf Name und Alter.
///
/// Die Funktion berücksichtigt verschiedene Faktoren:
/// - Alter des Benutzers (jüngere Benutzer erhalten Bonus)
/// - Länge des Namens (längere Namen erhalten kleinen Bonus)
/// - Zufälliger Faktor für Fairness
/// 
/// **Parameter:**
/// - [name]: Der Name des Benutzers (muss nicht leer sein)
/// - [age]: Das Alter des Benutzers (muss zwischen 3 und 12 sein)
/// 
/// **Rückgabewert:**
/// Ein `Future<int>` mit dem berechneten Score (0-100)
/// 
/// **Beispiel:**
/// ```dart
/// final result = await calculateScore(name: 'Max', age: 8);
/// print(result); // z.B. 85
/// ```
/// 
/// **Throws:**
/// - [ArgumentError] wenn name leer ist oder age außerhalb 3-12
/// - [StateError] wenn Berechnung fehlschlägt
/// 
/// **Siehe auch:**
/// - [UserProfile] für Benutzer-Datenmodell
/// - [GameService] für Spiel-Logik
Future<int> calculateScore({
  required String name,
  required int age,
}) async {
  // Implementation
}
```

**Dokumentations-Checkliste:**
- [ ] Kurze Beschreibung (1 Satz)
- [ ] Detaillierte Erklärung (wenn nötig)
- [ ] Alle Parameter dokumentiert
- [ ] Rückgabewert dokumentiert
- [ ] Beispiel-Code
- [ ] Throws dokumentiert
- [ ] Siehe auch (wenn relevant)

---

### 3. 🏗️ ARCHITEKTUR & STRUKTUR (🟡 WICHTIG)

#### 3.1 Feature-Based Structure (OPTIMIERT)

**Empfohlen:** Feature-Based Structure für bessere Organisation:

```
lib/
├── features/
│   ├── auth/
│   │   ├── models/
│   │   │   └── user_profile.dart
│   │   ├── repositories/
│   │   │   └── auth_repository.dart
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   ├── screens/
│   │   │   └── login_screen.dart
│   │   └── widgets/
│   │       └── login_button.dart
│   ├── games/
│   │   └── [gleiche Struktur]
│   └── profile/
│       └── [gleiche Struktur]
├── core/
│   ├── theme/
│   │   ├── colors.dart
│   │   ├── typography.dart
│   │   └── spacing.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   └── formatters.dart
│   └── constants/
│       └── app_constants.dart
└── main.dart
```

**Vorteile:**
- ✅ Klare Trennung nach Features
- ✅ Einfache Navigation
- ✅ Wiederverwendbare Core-Komponenten
- ✅ Testbare Struktur

#### 3.2 Shared Code (OPTIMIERT)

**Regel:** Code der in >1 App genutzt wird → `packages/shared/`

**Workflow (VEREINFACHT):**
1. **Prüfen:** Wird Code in anderen Apps genutzt?
2. **Anfrage:** SHARED_ANFRAGE.md erstellen
3. **Warten:** Shared Agent prüft und implementiert
4. **Nutzen:** `flutter pub get` ausführen

**SHARED_ANFRAGE.md Template:**
```markdown
# SHARED ANFRAGE

**Von:** [Modul-Name]
**Datum:** [YYYY-MM-DD]
**Priorität:** [HOCH/MITTEL/NIEDRIG]

## Was wird benötigt?
[Kurze Beschreibung]

## Warum?
[Begründung - warum in Shared?]

## Vorgeschlagener Code
```dart
// Code-Vorschlag
```

## Betrifft andere Module?
- [ ] Alanko
- [ ] Lianko
- [ ] Parent
- [ ] Callcenter

## Breaking Changes?
- [ ] Ja (Migration nötig)
- [ ] Nein
```

#### 3.3 Repository Pattern (ERWEITERT)

**Empfohlen:** Services abstrahieren mit Repository Pattern:

```dart
// Interface
abstract class ProfileRepository {
  Future<Result<UserProfile>> get(String id);
  Future<Result<void>> save(UserProfile profile);
  Future<Result<void>> delete(String id);
}

// Implementation
class FirebaseProfileRepository implements ProfileRepository {
  final FirebaseFirestore _firestore;
  
  FirebaseProfileRepository(this._firestore);
  
  @override
  Future<Result<UserProfile>> get(String id) async {
    try {
      final doc = await _firestore.collection('users').doc(id).get();
      if (!doc.exists) {
        return Failure('Benutzer nicht gefunden');
      }
      return Success(UserProfile.fromFirestore(doc));
    } catch (e) {
      return Failure('Fehler: $e');
    }
  }
  
  // ... weitere Methoden
}

// Mock für Tests
class MockProfileRepository implements ProfileRepository {
  @override
  Future<Result<UserProfile>> get(String id) async {
    return Success(UserProfile.test());
  }
  
  // ... weitere Methoden
}
```

---

### 4. 🧪 TESTING (🟡 WICHTIG)

#### 4.1 Test-Coverage Ziel (VERSCHÄRFT)

**Minimum:** 80% Code Coverage für Services (verschärft von 70%)

**Priorität:**
1. ✅ Unit Tests für Services (PFLICHT)
2. ✅ Widget Tests für UI-Komponenten (PFLICHT)
3. ✅ Integration Tests für User-Flows (EMPFOHLEN)

#### 4.2 Test-Struktur (OPTIMIERT)

```
test/
├── models/
│   └── user_profile_test.dart
├── services/
│   └── gemini_service_test.dart
├── widgets/
│   └── category_card_test.dart
└── integration/
    └── auth_flow_test.dart
```

#### 4.3 Test-Best Practices (ERWEITERT)

**PFLICHT:**
- ✅ Mock externe Dependencies (Firebase, APIs)
- ✅ Test Edge Cases (leere Strings, null, große Zahlen)
- ✅ Test Error-Handling
- ✅ Test Success-Paths
- ✅ Test mit verschiedenen Daten

**Beispiel:**
```dart
group('GeminiService Tests', () {
  late GeminiService service;
  late MockGeminiApi mockApi;
  
  setUp(() {
    mockApi = MockGeminiApi();
    service = GeminiService(mockApi);
  });
  
  test('sollte erfolgreich Antwort generieren', () async {
    // Arrange
    when(mockApi.generateText(any)).thenAnswer(
      (_) async => 'Test Antwort',
    );
    
    // Act
    final result = await service.generateResponse('Test');
    
    // Assert
    expect(result.isSuccess, true);
    expect(result.value, 'Test Antwort');
  });
  
  test('sollte Fehler bei leerem Input behandeln', () async {
    // Act
    final result = await service.generateResponse('');
    
    // Assert
    expect(result.isFailure, true);
    expect(result.error, contains('leer'));
  });
  
  test('sollte Netzwerkfehler behandeln', () async {
    // Arrange
    when(mockApi.generateText(any)).thenThrow(
      NetworkException('Keine Verbindung'),
    );
    
    // Act
    final result = await service.generateResponse('Test');
    
    // Assert
    expect(result.isFailure, true);
    expect(result.error, contains('Netzwerk'));
  });
});
```

---

### 5. 🚀 PERFORMANCE (🟢 EMPFOHLEN)

#### 5.1 Widget-Optimierung (ERWEITERT)

**PFLICHT:**
- ✅ `const` Constructors verwenden wo möglich
- ✅ `ListView.builder` statt `ListView` für lange Listen
- ✅ `Expanded`/`Flexible` statt `SizedBox` mit fester Größe
- ✅ `AutomaticKeepAliveClientMixin` für teure Widgets
- ✅ `RepaintBoundary` für komplexe Widgets

```dart
// ❌ FALSCH
ListView(
  children: items.map((item) => ItemWidget(item)).toList(),
)

// ✅ RICHTIG
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemWidget(items[index]),
  cacheExtent: 500, // Optional: Caching
)
```

#### 5.2 Image-Optimization (ERWEITERT)

```dart
// ✅ OPTIMIERT
CachedNetworkImage(
  imageUrl: imageUrl,
  memCacheWidth: 300,  // Memory-Optimierung
  memCacheHeight: 300,
  placeholder: (context, url) => const CircularProgressIndicator(),
  errorWidget: (context, url, error) => const Icon(Icons.error),
  fadeInDuration: const Duration(milliseconds: 300),
)
```

#### 5.3 API-Calls (ERWEITERT)

```dart
// ✅ OPTIMIERT - Mit Caching und Retry
class ApiService {
  final Map<String, CachedResult> _cache = {};
  
  Future<Result<T>> get<T>(String endpoint) async {
    // Cache prüfen
    if (_cache.containsKey(endpoint)) {
      final cached = _cache[endpoint]!;
      if (!cached.isExpired) {
        return Success(cached.data as T);
      }
    }
    
    // Retry-Logic mit Exponential Backoff
    for (int attempt = 0; attempt < 3; attempt++) {
      try {
        final response = await _http.get(endpoint);
        final data = _parseResponse<T>(response);
        
        // Cache speichern
        _cache[endpoint] = CachedResult(data, Duration(minutes: 5));
        
        return Success(data);
      } catch (e) {
        if (attempt == 2) return Failure('Fehler: $e');
        await Future.delayed(Duration(seconds: pow(2, attempt).toInt()));
      }
    }
    
    return Failure('Maximale Versuche erreicht');
  }
}
```

---

### 6. 🔄 WORKFLOW & GIT (🟡 WICHTIG)

#### 6.1 Branch-Strategy (OPTIMIERT)

**PFLICHT:** Niemals direkt auf `main` pushen!

**Workflow (VEREINFACHT):**
```bash
# 1. Main aktualisieren
git checkout main
git pull origin main

# 2. Feature-Branch erstellen
git checkout -b feature/beschreibung

# 3. Änderungen machen
# ... Code schreiben ...

# 4. Committen
git add -A
git commit -m "feat: Beschreibung"

# 5. Pushen
git push -u origin feature/beschreibung

# 6. PR erstellen (via GitHub CLI oder Web)
gh pr create --title "feat: Beschreibung" --body "Beschreibung"
```

#### 6.2 Commit-Messages (OPTIMIERT)

**Format:** `type(scope): Beschreibung`

**Typen:**
- `feat:` - Neues Feature
- `fix:` - Bug Fix
- `refactor:` - Code Refactoring
- `docs:` - Dokumentation
- `style:` - Formatting
- `test:` - Tests
- `chore:` - Build-Tools, Dependencies
- `perf:` - Performance-Verbesserung
- `ci:` - CI/CD Änderungen

**Beispiele:**
```
feat(auth): Add login screen with email validation
fix(games): Remove hardcoded API key from gemini_service
refactor(shared): Move CategoryCard to shared package
docs(api): Update API setup instructions
perf(ui): Optimize ListView with builder pattern
```

#### 6.3 Pull Request Checklist (ERWEITERT)

Vor jedem PR prüfen:
- [ ] Code formatiert (`flutter format .`)
- [ ] Keine Linter-Fehler (`flutter analyze`)
- [ ] Tests geschrieben/aktualisiert
- [ ] Tests bestehen (`flutter test`)
- [ ] Dokumentation aktualisiert
- [ ] Keine API Keys/Secrets committed
- [ ] Keine Debug-Prints im Code
- [ ] Changelog aktualisiert (falls nötig)
- [ ] Breaking Changes dokumentiert
- [ ] Migration-Guide (falls nötig)

---

### 7. 📊 MONITORING & REPORTING (🟢 EMPFOHLEN)

#### 7.1 Finanzamt-Berichte (OPTIMIERT)

**Häufigkeit:**
- **Täglich:** Kurzbericht (automatisch)
- **Wöchentlich:** Ausführlicher Bericht
- **Monatlich:** Abschlussbericht

**Inhalt:**
- Statistik pro Agent (Zeilen Code, Bugs, Optimierungen)
- Kritische Probleme
- Code-Qualität-Metriken
- Empfehlungen
- Belohnungen vergeben

#### 7.2 Metriken (VERSCHÄRFT)

**Tracken:**
- Code-Duplikation (Ziel: <3% - verschärft von <5%)
- Test-Coverage (Ziel: >80% - verschärft von >70%)
- Linter-Fehler (Ziel: 0)
- Performance (App-Start <2s, 60 FPS)
- Verstöße pro Agent (Ziel: <3/Monat - verschärft von <5)

---

### 8. ⚠️ VERBOTENE AKTIONEN (ERWEITERT)

**NIEMALS:**
- ❌ Direkt auf `main` pushen
- ❌ `git push --force` auf main
- ❌ API Keys/Secrets committen
- ❌ Code ohne Tests committen
- ❌ Code ohne Dokumentation committen
- ❌ Code ohne `flutter analyze` committen
- ❌ Shared-Code ohne Shared-Agent ändern
- ❌ Andere Module ohne Erlaubnis ändern
- ❌ Breaking Changes ohne Migration-Guide
- ❌ Code ohne User-Bestätigung pushen

---

### 9. ✅ BEST PRACTICES (ERWEITERT)

#### 9.1 Error-Handling (OPTIMIERT)

```dart
// ✅ OPTIMIERT - Mit Result Pattern
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final String error;
  const Failure(this.error);
}

Future<Result<UserProfile>> loadProfile(String id) async {
  try {
    final data = await _api.getProfile(id);
    return Success(data);
  } on NetworkException catch (e) {
    return Failure('Netzwerkfehler: ${e.message}');
  } on ValidationException catch (e) {
    return Failure('Validierungsfehler: ${e.message}');
  } catch (e, stackTrace) {
    // Log für Debugging
    debugPrint('Unerwarteter Fehler: $e\n$stackTrace');
    return Failure('Unerwarteter Fehler: $e');
  }
}
```

#### 9.2 Null-Safety (OPTIMIERT)

```dart
// ✅ RICHTIG
String? get userName => _user?.name;
String get userNameOrEmpty => _user?.name ?? '';
String get userNameOrDefault => _user?.name ?? 'Unbekannt';

// ❌ FALSCH
String get userName => _user!.name; // Nur wenn absolut sicher!
```

#### 9.3 State Management (OPTIMIERT)

**Empfohlen:** Riverpod für State Management

```dart
// Provider für Services
final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

// StateProvider für einfachen State
final counterProvider = StateProvider<int>((ref) => 0);

// FutureProvider für async Data
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final service = ref.watch(geminiServiceProvider);
  return await service.getProfile();
});
```

---

### 10. 🎯 OPTIMIERUNGEN (ERWEITERT)

#### 10.1 Code-Duplikation (VERSCHÄRFT)

**Ziel:** <3% Code-Duplikation (verschärft von <5%)

**Vorgehen:**
1. Duplikation identifizieren (automatische Tools)
2. Prüfen ob in Shared gehört
3. Wenn ja → Shared Agent kontaktieren
4. Wenn nein → Lokal refactoren

#### 10.2 Dependencies (OPTIMIERT)

**Regel:** Regelmäßig aktualisieren, aber vorsichtig:

```bash
# Prüfen welche Updates verfügbar sind
flutter pub outdated

# Minor/Patch Updates (sicher)
flutter pub upgrade

# Major Updates (nur nach Tests!)
flutter pub upgrade --major-versions
```

**Checkliste vor Dependency-Update:**
- [ ] Changelog gelesen
- [ ] Breaking Changes geprüft
- [ ] Tests bestehen noch
- [ ] Code angepasst (falls nötig)
- [ ] Dokumentation aktualisiert

---

## 📞 KONTAKT & ESKALATION (OPTIMIERT)

**Bei Problemen:**
1. Zuerst selbst analysieren
2. Dokumentation prüfen
3. Wenn unklar → User fragen
4. Bei kritischen Problemen → Sofort Finanzamt informieren

**Eskalations-Workflow:**
1. **Selbst lösen** (max. 1h)
2. **User fragen** (bei Unklarheiten)
3. **Finanzamt informieren** (bei kritischen Problemen)
4. **Agent 007 alarmieren** (bei Sicherheitsproblemen)

---

## 🔄 UPDATES

**Diese Regeln werden kontinuierlich aktualisiert:**
- Neue Best Practices hinzugefügt
- Verstöße dokumentiert
- Optimierungen eingearbeitet
- Prompt-DB regelmäßig aktualisiert (alle 24h KI-Zeit)

**Letzte Aktualisierung:** 2025-01-27 (Version 2.0)

**Zugehörige Dateien:**
- `GESETZBUCH.md` - ⚠️ OFFIZIELLE GESETZE UND STRAFEN (HÖCHSTE PRIORITÄT)
- `FINANZAMT_VERSTOESSE.md` - Verstoß-Protokoll
- `prompts.json` - Zentrale Prompt-Datenbank
- `PROMPT_DB_MANAGEMENT.md` - Verwaltung der Prompt-DB
- `FINANZAMT_BERICHT_*.md` - Regelmäßige Berichte

---

**Unterzeichnet:**  
🏛️ **Agent Finanzamt** - Der perfektionistische Überwacher

**Version:** 2.0  
**Status:** ✅ OPTIMIERT

