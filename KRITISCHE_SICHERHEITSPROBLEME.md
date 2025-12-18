# 🚨 KRITISCHE SICHERHEITSPROBLEME - SOFORT BEHEBEN

**Erstellt:** 2025-12-18 03:16  
**Status:** 🔴 KRITISCH  
**Priorität:** HÖCHSTE

---

## 🔴 PROBLEM 1: Hardcodierter API-Key in Alanko

### Datei:
`apps/alanko/lib/services/gemini_service.dart`

### Problem:
```dart
static const String _apiKey = 'AIzaSyD5jBRl-Ti0r_uSyx5JW24H3CySQ8RWrS8';
```

**KRITISCH:**
- ✅ API-Key ist im Code hardcodiert
- ✅ In Git-History permanent gespeichert
- ✅ Kann von Dritten missbraucht werden
- ✅ Quota-Verbrauch und Kosten möglich
- ✅ Verstoß gegen Google Cloud ToS

### Lösung:
```dart
// SICHERE LÖSUNG:
static const String _apiKey = String.fromEnvironment(
  'GEMINI_API_KEY',
  defaultValue: '',
);
```

### Sofortmaßnahmen:
1. **JETZT:** API-Key bei Google Cloud rotieren
2. **JETZT:** Hardcodierten Key aus Code entfernen
3. **JETZT:** Environment-Variable implementieren
4. **DANN:** `.env` Datei erstellen (nicht committen!)
5. **DANN:** `.gitignore` prüfen

**Aufwand:** 30 Minuten  
**Impact:** 🔴 KRITISCH - Sofort beheben

---

## 🔴 PROBLEM 2: Potenzielle Credentials in Dateien

### Gefundene Dateien mit Credentials:
- `apps/callcenter-ai/lib/core/config/api_config.dart`
- `apps/callcenter-ai/backend/server.js`
- `apps/therapy-ai/lib/core/env_config.dart`
- `apps/alanko/android/app/build.gradle.kts`
- `apps/lianko/android/app/build.gradle.kts`

### Aktion:
- [ ] Alle Dateien auf hardcodierte Credentials prüfen
- [ ] Credentials zu Environment-Variablen verschieben
- [ ] `.env` Dateien zu `.gitignore` hinzufügen
- [ ] Git-History auf geleakte Keys prüfen

**Aufwand:** 1-2 Stunden  
**Impact:** 🔴 KRITISCH - Sicherheitsrisiko

---

## 🔴 PROBLEM 3: Fehlende Input-Validierung

### Dateien:
- `apps/lianko/lib/services/firebase_service.dart`
- `apps/alanko/lib/services/firebase_service.dart`

### Problem:
- Keine Validierung der Eingabedaten vor Firebase-Speicherung
- Mögliche Injection-Angriffe
- Datenintegrität gefährdet

### Lösung:
```dart
Future<void> saveChildProfile({
  required String name,
  required int age,
  required String preferredLanguage,
}) async {
  // Validierung hinzufügen
  if (name.isEmpty || name.length > 50) {
    throw ArgumentError('Invalid name');
  }
  if (age < 0 || age > 18) {
    throw ArgumentError('Invalid age');
  }
  // ... weitere Validierungen
}
```

**Aufwand:** 2-3 Stunden  
**Impact:** 🟡 WICHTIG - Sicherheit verbessern

---

## 🔴 PROBLEM 4: Security-Tool Whitelist zu aggressiv

### Problem:
Security-Tool hat legitime Prozesse blockiert:
- Kaspersky Anti-Virus
- Opera Browser
- System-Frameworks (CryptoTokenKit)

### Lösung:
- ✅ Whitelist erweitert
- ✅ Legitime Prozesse hinzugefügt
- ✅ Tool neu konfiguriert

**Status:** ✅ BEHOBEN

---

## 📋 SOFORTMASSNAHMEN - CHECKLISTE

### Heute (JETZT):
- [ ] **KRITISCH:** API-Key bei Google Cloud rotieren
- [ ] **KRITISCH:** Hardcodierten Key aus Code entfernen
- [ ] **KRITISCH:** Environment-Variable implementieren
- [ ] **KRITISCH:** Alle Dateien auf Credentials prüfen
- [ ] **WICHTIG:** Input-Validierung hinzufügen

### Diese Woche:
- [ ] Git-History auf geleakte Keys prüfen
- [ ] `.env` Dateien erstellen
- [ ] `.gitignore` aktualisieren
- [ ] CI/CD Secrets konfigurieren
- [ ] Security-Audit durchführen

---

## 🛡️ PRÄVENTIVE MAßNAHMEN

### Code-Review-Regeln:
1. ✅ Keine Credentials im Code
2. ✅ Keine API-Keys hardcodieren
3. ✅ Environment-Variablen verwenden
4. ✅ Input-Validierung immer
5. ✅ Security-Scan vor jedem Commit

### Automatisierung:
- [ ] Pre-commit Hook für Credential-Check
- [ ] CI/CD Pipeline für Security-Scan
- [ ] Automatische API-Key-Rotation
- [ ] Secrets-Management (Vault, etc.)

---

**Status:** 🔴 KRITISCH - Sofortmaßnahmen erforderlich

**Nächste Aktion:** API-Key rotieren und aus Code entfernen

