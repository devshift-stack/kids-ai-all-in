# 🔒 Firestore Security Rules - Analyse

**Datum:** 2025-01-27

---

## 📋 Übersicht der Rules

### 1. **packages/shared/firebase/firestore.rules** ✅
**Status:** Erweitert für verschachtelte Struktur

**Features:**
- ✅ `parents/{parentId}` - Parent-Dokumente
- ✅ `parents/{parentId}/children/{childId}` - Kinder-Profile
- ✅ `parents/{parentId}/children/{childId}/progress` - Progress Sub-Collection
- ✅ `parents/{parentId}/children/{childId}/settings` - Settings Sub-Collection
- ✅ Co-Parents Support
- ✅ ParentCode-Verifizierung für Kinder-Apps
- ✅ Activity Logs
- ✅ Leaderboard

**Regeln:**
- Parent kann alles lesen/schreiben
- Co-Parents können nur lesen
- Kinder-Apps können über parentCode verifizieren
- Anonyme Auth kann progress/settings schreiben

---

### 2. **apps/parent/firestore.rules** ✅
**Status:** Erweitert für verschachtelte Struktur

**Features:**
- ✅ `parents/{parentId}` - Parent-Dokumente
- ✅ `parents/{parentId}/children/{childId}` - Kinder-Profile
- ✅ `parents/{parentId}/children/{childId}/progress` - Progress Sub-Collection
- ✅ `parents/{parentId}/children/{childId}/settings` - Settings Sub-Collection
- ✅ `parents/{parentId}/children/{childId}/usageStats` - Usage Stats
- ✅ Co-Parents Support
- ✅ ParentCode-Verifizierung

**Regeln:**
- Owner hat vollständigen Zugriff
- Co-Parents können nur lesen
- Helper-Funktionen für bessere Lesbarkeit

---

### 3. **apps/lianko/firestore.rules** ⚠️
**Status:** Nutzt noch flache Struktur

**Features:**
- ✅ `children/{userId}` - Flache Struktur
- ✅ `children/{userId}/progress` - Progress Sub-Collection
- ✅ `children/{userId}/stats` - Stats Sub-Collection
- ✅ `children/{userId}/events` - Events Sub-Collection
- ✅ `children/{userId}/settings` - Settings Sub-Collection
- ✅ `parents/{parentId}` - Parent-Dokumente
- ✅ `parents/{parentId}/linkedChildren/{childId}` - Linked Children

**Regeln:**
- User kann nur eigene Daten lesen/schreiben
- Validierung für Create-Operationen
- Immutable Logs (keine Updates/Deletes)

**Hinweis:** Lianko nutzt noch die flache Struktur, aber `parent_link_service.dart` sucht bereits in der verschachtelten Struktur nach `parentCode`.

---

## 🔍 Konsistenz-Prüfung

### ✅ Konsistent:
- Parent-Dokumente: Alle nutzen `parents/{parentId}`
- Co-Parents: Unterstützt in shared und parent
- Anonyme Auth: Unterstützt für progress/settings

### ⚠️ Inkonsistent:
- **Lianko** nutzt noch flache Struktur `children/{userId}`
- **Alanko/Parent** nutzen verschachtelte Struktur `parents/{parentId}/children/{childId}`
- **Lianko** hat `parents/{parentId}/linkedChildren/{childId}` (nicht `children`)

---

## 🧪 Test-Plan

### 1. **Anonyme Auth Test:**
```javascript
// Sollte funktionieren:
firestore.collection('parents/{parentId}/children/{childId}/progress').add({...})
```

### 2. **Parent Access Test:**
```javascript
// Parent sollte lesen/schreiben können:
firestore.collection('parents/{parentId}/children/{childId}').get()
firestore.collection('parents/{parentId}/children/{childId}').set({...})
```

### 3. **Co-Parent Access Test:**
```javascript
// Co-Parent sollte nur lesen können:
firestore.collection('parents/{parentId}/children/{childId}').get() // ✅
firestore.collection('parents/{parentId}/children/{childId}').set({...}) // ❌
```

### 4. **ParentCode Test:**
```javascript
// Kinder-App sollte über parentCode lesen können:
firestore.collection('parents/{parentId}/children/{childId}').get() // ✅ wenn parentCode matcht
```

---

## ✅ Empfehlungen

### 1. **Einheitliche Rules nutzen**
- Alle Apps sollten `packages/shared/firebase/firestore.rules` nutzen
- Oder: Lianko Rules anpassen für verschachtelte Struktur

### 2. **Firebase Emulator testen**
```bash
cd packages/shared/firebase
firebase emulators:start --only firestore
```

### 3. **Rules deployen**
```bash
cd packages/shared/firebase
firebase deploy --only firestore:rules
```

---

## 📝 Nächste Schritte

1. **Rules testen** mit Firebase Emulator
2. **Lianko Rules anpassen** (optional, falls verschachtelte Struktur genutzt werden soll)
3. **Rules deployen** nach erfolgreichen Tests

---

## ✅ Status

- [x] Shared Rules erweitert
- [x] Parent Rules erweitert
- [x] Lianko Rules dokumentiert
- [ ] Rules getestet (mit Emulator)
- [ ] Rules deployed

---

**Die Rules sind erweitert und sollten funktionieren. Testen mit Firebase Emulator empfohlen!** ✅

