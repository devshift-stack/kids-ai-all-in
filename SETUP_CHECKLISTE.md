# ✅ Setup-Checkliste nach Neuinstallation

**Datum:** $(date '+%d.%m.%Y %H:%M:%S')  
**Projekt:** kids-ai-all-in (neu geklont)

---

## 📋 Was muss konfiguriert werden?

### 1. 🔑 Keystore-Dateien erstellen

#### Für Alanko, Lianko, Parent (gemeinsamer Keystore):
```bash
# Erstelle gemeinsamen Keystore
keytool -genkey -v -keystore apps/parent/android/app/kids-ai-shared-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias kids-ai \
  -storepass kidsai123456 \
  -keypass kidsai123456 \
  -dname "CN=Kids AI, OU=Development, O=DevShift, L=City, ST=State, C=DE"
```

#### Für Therapy AI (Li KI Training):
```bash
# Erstelle separaten Keystore
keytool -genkey -v -keystore apps/therapy-ai/android/app/lik-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias lik \
  -storepass kidsai123456 \
  -keypass kidsai123456 \
  -dname "CN=Li KI Training, OU=Development, O=DevShift, L=City, ST=State, C=DE"
```

---

### 2. 📝 key.properties Dateien erstellen

#### Alanko:
```properties
# apps/alanko/android/key.properties
storePassword=kidsai123456
keyPassword=kidsai123456
keyAlias=kids-ai
storeFile=app/kids-ai-shared-release-key.jks
```

#### Lianko:
```properties
# apps/lianko/android/key.properties
storePassword=kidsai123456
keyPassword=kidsai123456
keyAlias=kids-ai
storeFile=app/kids-ai-shared-release-key.jks
```

#### Parent:
```properties
# apps/parent/android/key.properties
storePassword=kidsai123456
keyPassword=kidsai123456
keyAlias=kids-ai
storeFile=app/kids-ai-shared-release-key.jks
```

#### Therapy AI:
```properties
# apps/therapy-ai/android/key.properties
storePassword=kidsai123456
keyPassword=kidsai123456
keyAlias=lik
storeFile=app/lik-release-key.jks
```

---

### 3. 🔥 Firebase-Konfigurationen prüfen

Stelle sicher, dass `google-services.json` für jede App vorhanden ist:
- ✅ `apps/alanko/android/app/google-services.json`
- ✅ `apps/lianko/android/app/google-services.json`
- ✅ `apps/parent/android/app/google-services.json`
- ✅ `apps/therapy-ai/android/app/google-services.json`

**Falls fehlend:** Lade von Firebase Console herunter.

---

### 4. 🌍 Environment-Variablen (Therapy AI)

Erstelle `.env` Datei für Therapy AI:
```bash
# apps/therapy-ai/.env
ELEVENLABS_API_KEY=dein_api_key_hier
ELEVENLABS_API_BASE_URL=https://api.elevenlabs.io/v1
OPENAI_API_KEY=dein_api_key_hier
OPENAI_API_BASE_URL=https://api.openai.com/v1
```

Oder nutze das Setup-Script:
```bash
cd apps/therapy-ai
bash setup_env.sh
```

---

### 5. 🔧 Build-Konfigurationen prüfen

Stelle sicher, dass in `build.gradle.kts` der Keystore-Pfad korrekt ist:
```kotlin
storeFile = keystoreProperties["storeFile"]?.let { rootProject.file(it as String) }
```

**Wichtig:** Muss `rootProject.file()` verwenden, nicht nur `file()`!

---

### 6. 📦 Package-Namen prüfen

Stelle sicher, dass Package-Namen korrekt sind:
- **Alanko:** `com.alanko.ai`
- **Lianko:** `com.lianko.ai`
- **Parent:** `com.kidsai.parent.kids_ai_parent`
- **Therapy AI:** `com.lik.app`

---

### 7. 📁 MainActivity.kt Pfade prüfen

Stelle sicher, dass MainActivity.kt am richtigen Ort ist:
- **Alanko:** `apps/alanko/android/app/src/main/kotlin/com/alanko/ai/MainActivity.kt`
- **Lianko:** `apps/lianko/android/app/src/main/kotlin/com/lianko/ai/MainActivity.kt`
- **Parent:** `apps/parent/android/app/src/main/kotlin/com/kidsai/parent/kids_ai_parent/MainActivity.kt`
- **Therapy AI:** `apps/therapy-ai/android/app/src/main/kotlin/com/lik/app/MainActivity.kt`

---

## 🚀 Schnell-Setup Script

Führe dieses Script aus, um alles automatisch zu konfigurieren:

```bash
# Erstelle alle Keystores
# ... (siehe oben)

# Erstelle alle key.properties
# ... (siehe oben)

# Prüfe alles
cd "/Users/dsselmanovic/cursor project/kids-ai-all-in"
bash -c 'for app in alanko lianko parent therapy-ai; do echo "Prüfe $app..."; done'
```

---

## ✅ Nach dem Setup

1. ✅ Alle Keystores erstellt
2. ✅ Alle key.properties erstellt
3. ✅ Firebase-Konfigurationen vorhanden
4. ✅ Environment-Variablen gesetzt
5. ✅ Build-Konfigurationen korrekt
6. ✅ Package-Namen korrekt
7. ✅ MainActivity.kt Pfade korrekt

**Dann kannst du die AAB-Dateien bauen!**

