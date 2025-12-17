# ⚡ Whisper.cpp Quick Start

Schnelle Anleitung zum Herunterladen von whisper.cpp.

---

## 🎯 Was du brauchst

1. **whisper.cpp Source Code** (von GitHub)
2. **Model-Datei** (Base Model empfohlen)

---

## 📥 Download-Links (Empfohlene Quellen)

### ⭐ 1. GitHub Repository (Source Code) - EMPFOHLEN
**Offizielle Quelle:** https://github.com/ggerganov/whisper.cpp

```bash
git clone https://github.com/ggerganov/whisper.cpp.git
```

**Warum GitHub:**
- ✅ Offizielle Quelle vom Entwickler
- ✅ Immer aktuelle Version
- ✅ Sicher und verifiziert
- ✅ Vollständiger Source Code

---

### ⭐ 2. Hugging Face (Model-Dateien) - EMPFOHLEN
**Repository:** https://huggingface.co/ggerganov/whisper.cpp

**Base Model (Empfohlen):**
```bash
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
```

**Oder im Browser:**
- Gehe zu: https://huggingface.co/ggerganov/whisper.cpp
- Klicke auf "Files and versions"
- Suche "ggml-base.bin" → Download

**Warum Hugging Face:**
- ✅ Offizielle Model-Distribution
- ✅ Schnelle Downloads
- ✅ Verifizierte Dateien
- ✅ Verschiedene Model-Größen verfügbar

---

## 🚀 Schnellstart (3 Schritte)

### Schritt 1: Repository klonen
```bash
cd ~/Downloads
git clone https://github.com/ggerganov/whisper.cpp.git
```

### Schritt 2: Model herunterladen
```bash
cd whisper.cpp
wget https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.bin
```

### Schritt 3: Model in Projekt kopieren
```bash
# Erstelle Ordner (falls nicht vorhanden)
mkdir -p "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai/assets/models"

# Kopiere Model
cp ggml-base.bin "/Users/dsselmanovic/cursor project/kids-ai-all-in/apps/therapy-ai/assets/models/whisper-base.bin"
```

---

## ✅ Fertig!

Das Model ist jetzt im Projekt. Ich kann dann die Integration implementieren.

---

**Wichtig:** 
- Base Model ist ~150MB
- Stelle sicher, dass genug Speicherplatz vorhanden ist
- Das Model wird in die App eingebunden (App wird größer)

---

**Nächster Schritt:** Sage Bescheid, wenn das Model heruntergeladen ist, dann implementiere ich die Integration!

