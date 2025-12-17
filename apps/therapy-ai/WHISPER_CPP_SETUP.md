# 🎤 Whisper.cpp Setup & Integration

Anleitung zum Herunterladen und Integrieren von whisper.cpp in die Therapy AI App.

---

## 📥 Offizielle Quelle

### **GitHub Repository (Hauptquelle)**
**URL:** https://github.com/ggerganov/whisper.cpp

**Was ist das:**
- ✅ Offizielle C++ Implementierung von Whisper
- ✅ Open Source (MIT License)
- ✅ Aktive Community
- ✅ Multi-Platform Support
- ✅ Quantisierte Modelle (kleinere Dateien)

---

## 🔽 Download-Optionen

### Option 1: GitHub Repository klonen (Empfohlen)

```bash
# Repository klonen
git clone https://github.com/ggerganov/whisper.cpp.git

# In separates Verzeichnis (nicht im Projekt)
cd ~/Downloads  # oder woanders
git clone https://github.com/ggerganov/whisper.cpp.git
```

**Vorteile:**
- ✅ Immer aktuelle Version
- ✅ Alle Modelle verfügbar
- ✅ Build-Scripts enthalten

---

### Option 2: Releases herunterladen

**URL:** https://github.com/ggerganov/whisper.cpp/releases

**Was herunterladen:**
- **Pre-built Binaries** (falls verfügbar für deine Plattform)
- **Source Code** (ZIP-Datei)

**Für Flutter Integration:**
- Wir brauchen die **Source Code** (nicht die Binaries)
- Wir bauen es selbst für iOS/Android

---

### Option 3: Modelle direkt herunterladen

**Model-Download URLs:**
- **Base Model (empfohlen):** https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
- **Small Model:** https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-small.bin
- **Tiny Model:** https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-tiny.bin

**Hugging Face Repository:**
https://huggingface.co/ggerganov/whisper.cpp

---

## 📦 Was wir brauchen

### Für Flutter Integration:

1. **Source Code** (aus GitHub)
   - C++ Dateien
   - Build-Scripts
   - Header-Dateien

2. **Model-Datei** (.bin)
   - Base Model: ~150MB
   - Small Model: ~500MB
   - Empfehlung: Base für Start

3. **Platform-spezifische Builds**
   - Android: Native Library (.so)
   - iOS: Framework (.framework)

---

## 🛠️ Integration in Flutter

### Schritt 1: Repository klonen

```bash
# Außerhalb des Projekts
cd ~/Downloads
git clone https://github.com/ggerganov/whisper.cpp.git
cd whisper.cpp
```

### Schritt 2: Model herunterladen

```bash
# Base Model (empfohlen)
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin

# Oder mit curl
curl -L https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin -o ggml-base.bin
```

### Schritt 3: Für Android/iOS bauen

**Android:**
```bash
# Android NDK nötig
# Build-Script ausführen
./build-android.sh
```

**iOS:**
```bash
# Xcode nötig
# Build-Script ausführen
./build-ios.sh
```

---

## 🔗 Alternative: Flutter Plugin verwenden

### Option: whisper_flutter_plugin (Community)

**Wenn verfügbar:**
- Suche auf pub.dev nach "whisper"
- Oder GitHub nach "whisper flutter"

**Vorteil:**
- ✅ Bereits für Flutter vorbereitet
- ✅ Einfacher zu integrieren

**Nachteil:**
- ⚠️ Möglicherweise nicht aktiv gepflegt
- ⚠️ Nicht offiziell

---

## 📋 Empfohlener Workflow

### Für unsere App:

1. **GitHub Repository klonen** (einmalig)
   ```bash
   git clone https://github.com/ggerganov/whisper.cpp.git
   ```

2. **Model herunterladen** (Base Model)
   ```bash
   wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
   ```

3. **Model in App einbinden**
   - In `apps/therapy-ai/assets/models/` kopieren
   - Oder Download-Mechanismus implementieren

4. **Platform Channels erstellen**
   - Android: Kotlin/Java Bridge
   - iOS: Swift Bridge
   - whisper.cpp Funktionen aufrufen

---

## 🎯 Konkrete Schritte für dich

### Jetzt:

1. **Repository klonen:**
   ```bash
   cd ~/Downloads  # oder woanders
   git clone https://github.com/ggerganov/whisper.cpp.git
   ```

2. **Model herunterladen:**
   ```bash
   cd whisper.cpp
   wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
   ```

3. **Model in Projekt kopieren:**
   ```bash
   # Erstelle Models-Ordner
   mkdir -p "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai/assets/models"
   
   # Kopiere Model
   cp ggml-base.bin "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai/assets/models/whisper-base.bin"
   ```

---

## 📚 Ressourcen & Links

### Offizielle Quellen:
- **GitHub:** https://github.com/ggerganov/whisper.cpp
- **Hugging Face Models:** https://huggingface.co/ggerganov/whisper.cpp
- **Releases:** https://github.com/ggerganov/whisper.cpp/releases

### Dokumentation:
- **README:** https://github.com/ggerganov/whisper.cpp/blob/master/README.md
- **Examples:** https://github.com/ggerganov/whisper.cpp/tree/master/examples

### Model-Größen:
| Model | Größe | Parameter | Empfehlung |
|-------|-------|-----------|------------|
| tiny | ~75MB | 39M | Sehr schnell, weniger genau |
| base | ~150MB | 74M | **Empfohlen für Start** ⭐ |
| small | ~500MB | 244M | Gute Balance |
| medium | ~1.5GB | 769M | Sehr genau |
| large | ~3GB | 1.55B | Beste Genauigkeit |

---

## ⚠️ Wichtige Hinweise

1. **Model-Größe:**
   - Base Model (~150MB) ist ein guter Start
   - Kann später auf Small (~500MB) upgraden

2. **Speicherplatz:**
   - Stelle sicher, dass genug Platz auf dem Gerät ist
   - Model kann auch beim ersten Start heruntergeladen werden

3. **Build-Komplexität:**
   - Platform Channels erfordern native Code
   - Android NDK und Xcode nötig
   - Alternativ: Erst mit OpenAI API prototypen

---

## 🚀 Nächste Schritte

Nach dem Download:
1. ✅ Model in Projekt kopieren
2. ⏭️ Platform Channels erstellen
3. ⏭️ WhisperSpeechService implementieren
4. ⏭️ Integration testen

---

**Empfehlung:** Starte mit dem **Base Model** von Hugging Face - es ist der beste Kompromiss zwischen Größe und Genauigkeit.

