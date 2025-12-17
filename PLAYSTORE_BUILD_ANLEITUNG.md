# Play Store Build-Anleitung

Diese Anleitung erklärt, wie Sie APK- oder AAB-Dateien für alle drei Apps (Alanko, Lianko, ParentsDash) für den Google Play Store erstellen.

## ⚠️ WICHTIG: Probleme die behoben wurden

1. ✅ **Lianko applicationId korrigiert**: Von `com.alanko.ai` zu `com.lianko.ai`
2. ✅ **Signing-Konfiguration hinzugefügt**: Alle Apps unterstützen jetzt Release-Signing
3. ✅ **ProGuard-Regeln hinzugefügt**: Für optimierte Release-Builds

## Voraussetzungen

1. **Flutter SDK** installiert und im PATH
2. **Java JDK 17** oder höher installiert
3. **Android SDK** installiert
4. **KeyStore-Datei** für Signing (siehe Schritt 1)

## Schritt 1: KeyStore erstellen

Für den Play Store benötigen Sie einen Signing-Key. Erstellen Sie einen KeyStore für jede App:

### Alanko KeyStore erstellen:
```bash
cd apps/alanko/android
keytool -genkey -v -keystore alanko-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias alanko
```

### Lianko KeyStore erstellen:
```bash
cd apps/lianko/android
keytool -genkey -v -keystore lianko-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias lianko
```

### ParentsDash KeyStore erstellen:
```bash
cd apps/parent/android
keytool -genkey -v -keystore parent-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias parent
```

**WICHTIG**: 
- Bewahren Sie die Passwörter sicher auf!
- Die KeyStore-Dateien sollten NICHT in Git committed werden
- Notieren Sie sich: KeyStore-Passwort, Key-Alias, Key-Passwort

## Schritt 2: key.properties-Dateien erstellen

Erstellen Sie für jede App eine `key.properties`-Datei im `android/`-Verzeichnis:

### apps/alanko/android/key.properties:
```properties
storePassword=IHHR_KEYSTORE_PASSWORT
keyPassword=IHHR_KEY_PASSWORT
keyAlias=alanko
storeFile=app/alanko-release-key.jks
```

### apps/lianko/android/key.properties:
```properties
storePassword=IHHR_KEYSTORE_PASSWORT
keyPassword=IHHR_KEY_PASSWORT
keyAlias=lianko
storeFile=app/lianko-release-key.jks
```

### apps/parent/android/key.properties:
```properties
storePassword=IHHR_KEYSTORE_PASSWORT
keyPassword=IHHR_KEY_PASSWORT
keyAlias=parent
storeFile=app/parent-release-key.jks
```

**WICHTIG**: 
- Ersetzen Sie `IHHR_KEYSTORE_PASSWORT` und `IHHR_KEY_PASSWORT` mit Ihren tatsächlichen Passwörtern
- Fügen Sie `key.properties` zu `.gitignore` hinzu (sollte bereits ignoriert sein)

## Schritt 3: KeyStore-Dateien verschieben

Verschieben Sie die erstellten KeyStore-Dateien in das `app/`-Verzeichnis jeder App:

```bash
# Alanko
mv apps/alanko/android/alanko-release-key.jks apps/alanko/android/app/

# Lianko
mv apps/lianko/android/lianko-release-key.jks apps/lianko/android/app/

# Parent
mv apps/parent/android/parent-release-key.jks apps/parent/android/app/
```

## Schritt 4: Dependencies installieren

Stellen Sie sicher, dass alle Dependencies installiert sind:

```bash
# Im Root-Verzeichnis
flutter pub get

# Für jede App
cd apps/alanko && flutter pub get
cd ../lianko && flutter pub get
cd ../parent && flutter pub get
```

## Schritt 5: APK oder AAB erstellen

### Option A: Android App Bundle (AAB) - EMPFOHLEN für Play Store

AAB ist das bevorzugte Format für den Play Store, da Google dann optimierte APKs für verschiedene Geräte erstellt.

#### Alanko AAB:
```bash
cd apps/alanko
flutter build appbundle --release
```
Die AAB-Datei finden Sie unter: `build/app/outputs/bundle/release/app-release.aab`

#### Lianko AAB:
```bash
cd apps/lianko
flutter build appbundle --release
```
Die AAB-Datei finden Sie unter: `build/app/outputs/bundle/release/app-release.aab`

#### ParentsDash AAB:
```bash
cd apps/parent
flutter build appbundle --release
```
Die AAB-Datei finden Sie unter: `build/app/outputs/bundle/release/app-release.aab`

### Option B: APK erstellen

Falls Sie APK-Dateien benötigen:

#### Alanko APK:
```bash
cd apps/alanko
flutter build apk --release
```
Die APK-Datei finden Sie unter: `build/app/outputs/flutter-apk/app-release.apk`

#### Lianko APK:
```bash
cd apps/lianko
flutter build apk --release
```
Die APK-Datei finden Sie unter: `build/app/outputs/flutter-apk/app-release.apk`

#### ParentsDash APK:
```bash
cd apps/parent
flutter build apk --release
```
Die APK-Datei finden Sie unter: `build/app/outputs/flutter-apk/app-release.apk`

### Option C: Split APKs (für verschiedene Architekturen)

Falls Sie separate APKs für verschiedene Architekturen benötigen:

```bash
flutter build apk --release --split-per-abi
```

Dies erstellt separate APKs für:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

## Schritt 6: Play Store Upload

1. Gehen Sie zu [Google Play Console](https://play.google.com/console)
2. Wählen Sie Ihre App aus (oder erstellen Sie eine neue)
3. Gehen Sie zu "Release" > "Production" (oder "Internal Testing" / "Closed Testing")
4. Klicken Sie auf "Create new release"
5. Laden Sie die AAB-Datei hoch (oder APK, falls Sie APK verwenden)
6. Füllen Sie die Release-Notizen aus
7. Überprüfen und veröffentlichen

## Troubleshooting

### Problem: "key.properties not found"
- Stellen Sie sicher, dass die `key.properties`-Datei im `android/`-Verzeichnis jeder App existiert
- Überprüfen Sie die Pfade in der Datei

### Problem: "Keystore file not found"
- Stellen Sie sicher, dass die KeyStore-Datei im `android/app/`-Verzeichnis liegt
- Überprüfen Sie den `storeFile`-Pfad in `key.properties` (sollte `app/xxx-release-key.jks` sein)

### Problem: "Wrong password"
- Überprüfen Sie, ob die Passwörter in `key.properties` korrekt sind
- Stellen Sie sicher, dass Sie das richtige KeyStore-Passwort und Key-Passwort verwenden

### Problem: Build schlägt fehl
- Führen Sie `flutter clean` aus und versuchen Sie es erneut
- Stellen Sie sicher, dass alle Dependencies installiert sind: `flutter pub get`
- Überprüfen Sie, ob Flutter auf dem neuesten Stand ist: `flutter upgrade`

## Wichtige Hinweise

1. **AAB vs APK**: Google empfiehlt AAB für den Play Store, da es kleinere Download-Größen ermöglicht
2. **Version Code**: Erhöhen Sie den `versionCode` in `pubspec.yaml` bei jedem Release
3. **Version Name**: Aktualisieren Sie die `version` in `pubspec.yaml` (z.B. `1.0.0+1` → `1.0.1+2`)
4. **KeyStore-Sicherheit**: Bewahren Sie Ihre KeyStore-Dateien und Passwörter sicher auf - verlieren Sie sie nicht!
5. **Testing**: Testen Sie die Release-Builds vor dem Upload auf echten Geräten

## Application IDs

- **Alanko**: `com.alanko.ai`
- **Lianko**: `com.lianko.ai`
- **ParentsDash**: `com.kidsai.parent.kids_ai_parent`

Diese IDs müssen in der Google Play Console registriert werden, bevor Sie Apps hochladen können.

