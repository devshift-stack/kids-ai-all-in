# 📦 AAB-Datei erstellen - Anleitung

## ✅ Voraussetzungen

1. **Richtiges Verzeichnis**: Du musst im Projekt-Root sein
2. **Keystore vorhanden**: `android/app/lik-release-key.jks` existiert ✓

## 🚀 Befehle ausführen

### Schritt 1: Zum Projekt-Root navigieren

```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai"
```

**WICHTIG:** Der Pfad enthält Leerzeichen, daher müssen die Anführungszeichen verwendet werden!

### Schritt 2: Flutter Clean & Dependencies

```bash
flutter clean
flutter pub get
```

### Schritt 3: AAB-Datei erstellen

```bash
flutter build appbundle --release
```

**Alternative** (falls Debug-Symbol-Warnung erscheint):
```bash
flutter build appbundle --release --no-tree-shake-icons
```

## 📍 AAB-Datei Speicherort

Nach erfolgreichem Build findest du die AAB-Datei hier:

```
apps/therapy-ai/build/app/outputs/bundle/release/app-release.aab
```

## ⚠️ Mögliche Probleme & Lösungen

### Problem 1: "Keystore file not found"
**Lösung:** Der Keystore-Pfad in `android/key.properties` ist korrekt:
```
storeFile=app/lik-release-key.jks
```

### Problem 2: Gradle Cache Fehler
**Lösung:**
```bash
cd android
./gradlew --stop
rm -rf ~/.gradle/caches/8.14
cd ..
flutter clean
flutter pub get
flutter build appbundle --release
```

### Problem 3: "No pubspec.yaml file found"
**Lösung:** Du bist im falschen Verzeichnis. Navigiere zum Projekt-Root:
```bash
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai"
```

## ✅ Erfolgreicher Build

Wenn der Build erfolgreich ist, siehst du:
```
✓ Built build/app/outputs/bundle/release/app-release.aab
```

Die Datei ist dann bereit für den Upload in die Google Play Console!

---

**Hinweis:** Die Warnung über Debug-Symbole ist nicht kritisch - die AAB-Datei wird trotzdem erstellt.

