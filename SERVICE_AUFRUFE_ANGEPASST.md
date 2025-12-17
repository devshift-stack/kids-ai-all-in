# ✅ Service-Aufrufe angepasst

**Datum:** 2025-01-27

---

## 🔧 Durchgeführte Anpassungen

### 1. **Provider für parentId/childId erstellt**

**Datei:** `apps/alanko/lib/providers/firebase_context_provider.dart`

- `currentParentIdProvider` - Liefert aktuelle Parent-ID
- `currentChildIdProvider` - Liefert aktuelle Child-ID
- `firebaseServiceWithContextProvider` - Wrapper für FirebaseService mit automatischem Context

**Vorteil:** Services müssen nicht mehr manuell `parentId`/`childId` übergeben bekommen.

---

### 2. **YouTubeRewardService automatische Initialisierung**

**Datei:** `apps/alanko/lib/services/youtube_reward_service.dart`

- Provider initialisiert automatisch mit `parentId`/`childId` wenn verfügbar
- Keine manuelle Initialisierung mehr nötig

**Vorher:**
```dart
final service = ref.read(youtubeRewardServiceProvider);
await service.initialize(childId, parentId: parentId);
```

**Nachher:**
```dart
final service = ref.watch(youtubeRewardServiceProvider);
// Automatisch initialisiert!
```

---

### 3. **FirebaseServiceWithContext**

**Wrapper-Klasse** die automatisch `parentId`/`childId` an alle Methoden übergibt:

- `saveChildProfile()` - Automatisch mit parentId/childId
- `getChildProfile()` - Automatisch mit parentId/childId
- `saveLearningProgress()` - Automatisch mit parentId/childId
- `getLearningProgress()` - Automatisch mit parentId/childId

**Verwendung:**
```dart
// Statt:
final firebaseService = ref.watch(firebaseServiceProvider);
await firebaseService.saveChildProfile(
  name: name,
  age: age,
  preferredLanguage: language,
  parentId: parentId,  // ← manuell
  childId: childId,    // ← manuell
);

// Jetzt:
final firebaseService = ref.watch(firebaseServiceWithContextProvider);
await firebaseService.saveChildProfile(
  name: name,
  age: age,
  preferredLanguage: language,
  // parentId/childId automatisch!
);
```

---

## 📋 Noch zu prüfen

### Direkte Service-Aufrufe

Die folgenden Services werden möglicherweise noch direkt aufgerufen und müssen angepasst werden:

1. **FirebaseService direkte Aufrufe:**
   - Suche nach: `firebaseServiceProvider` oder `FirebaseService()`
   - Ersetze mit: `firebaseServiceWithContextProvider`

2. **YouTubeRewardService:**
   - ✅ Automatisch initialisiert
   - Keine Änderungen nötig

3. **Andere Services:**
   - Prüfe ob andere Services `parentId`/`childId` benötigen
   - Nutze `currentParentIdProvider` und `currentChildIdProvider`

---

## 🧪 Test-Plan

### 1. Provider testen:
```dart
// In einem Widget:
final parentId = ref.watch(currentParentIdProvider);
final childId = ref.watch(currentChildIdProvider);
// Sollten die richtigen Werte liefern
```

### 2. FirebaseService testen:
```dart
final service = ref.watch(firebaseServiceWithContextProvider);
await service.saveChildProfile(...);
// Sollte automatisch parentId/childId nutzen
```

### 3. YouTubeRewardService testen:
```dart
final service = ref.watch(youtubeRewardServiceProvider);
// Sollte automatisch initialisiert sein
print(service.settings); // Sollte Settings laden
```

---

## ⚠️ Wichtige Hinweise

1. **Legacy-Kompatibilität:** 
   - FirebaseService unterstützt noch Fallback auf flache Struktur
   - Funktioniert auch ohne parentId/childId (für anonyme Nutzer)

2. **Provider-Abhängigkeiten:**
   - `firebaseServiceWithContextProvider` hängt von `parentChildServiceProvider` ab
   - `parentChildServiceProvider` muss initialisiert sein

3. **Initialisierung:**
   - `parentChildService.initialize()` muss aufgerufen werden
   - Geschieht normalerweise in `main.dart` oder App-Startup

---

## ✅ Status

- [x] Provider erstellt
- [x] YouTubeRewardService automatische Initialisierung
- [x] FirebaseServiceWithContext erstellt
- [ ] Direkte Service-Aufrufe prüfen und anpassen
- [ ] Tests durchführen

