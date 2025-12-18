# 🚀 Genkit Migration - Detaillierter Plan mit Prioritäten

**Datum:** 17. Dezember 2024  
**Status:** 📋 Planungsphase - Bereit für Review

---

## 📦 Übersicht aller Repositories

### **1. apps/alanko** - Kinder-App (Normal hörend)
- **Zweck:** Lern-App für Kinder (3-12 Jahre)
- **AI-Services:** Gemini (Chat, Stories, Quiz, Spiele)
- **Status:** ✅ Produktiv
- **Migration:** 🔴 Hoch priorisiert

### **2. apps/lianko** - Kinder-App (Schwerhörig)
- **Zweck:** Sprachtraining für schwerhörige Kinder mit Hörgeräten
- **AI-Services:** Gemini (Chat, Stories, Quiz, Spiele) + Audiogramm-Analyse
- **Status:** ✅ Produktiv
- **Migration:** 🔴 Hoch priorisiert

### **3. apps/callcenter-ai** - Verkaufsagent
- **Zweck:** KI-gestützter Verkaufsagent (Lisa) für Solarmodule
- **AI-Services:** Gemini (Verkaufsgespräche) + Express.js Backend
- **Status:** ✅ Produktiv
- **Migration:** 🟡 Mittel priorisiert

### **4. apps/therapy-ai** - Sprachtherapie-App
- **Zweck:** AI-gestützte Sprachtherapie für Kinder mit Hörbehinderung
- **AI-Services:** OpenAI Whisper (STT) + ElevenLabs (Voice Cloning) + Adaptive Exercise
- **Status:** 🚧 In Entwicklung (60%)
- **Migration:** 🟢 Niedrig priorisiert (andere APIs)

### **5. apps/parent** - Eltern-Dashboard
- **Zweck:** Dashboard für Eltern zur Überwachung ihrer Kinder
- **AI-Services:** ❌ Keine direkten AI-Funktionen
- **Status:** ✅ Produktiv
- **Migration:** ⚪ Nicht nötig

### **6. apps/therapy-parent** - Eltern-App für Therapy-AI
- **Zweck:** Eltern-Interface für Therapy-AI
- **AI-Services:** ❌ Keine direkten AI-Funktionen
- **Status:** 🚧 In Entwicklung
- **Migration:** ⚪ Nicht nötig

### **7. apps/therapy-web** - Web-Interface
- **Zweck:** Web-Interface für Therapy-AI
- **AI-Services:** Avatar-Generierung (optional)
- **Status:** 🚧 In Entwicklung
- **Migration:** ⚪ Optional

### **8. packages/shared** - Shared Package
- **Zweck:** Gemeinsamer Code für alle Apps
- **AI-Services:** GeminiService (Shared)
- **Status:** ✅ Produktiv
- **Migration:** 🔴 Hoch priorisiert (wird von Alanko/Lianko genutzt)

---

## 🔍 Detaillierte AI-Funktionen pro Repository

### **📱 apps/alanko - AI-Funktionen**

#### **1. GeminiService** (`lib/services/gemini_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `ask(String question)` | Chat-Funktion - Alanko beantwortet Fragen | ✅ `genkitFlow: alankoChat` | 🔴 Hoch |
| `generateStory({theme, age})` | Generiert kurze Geschichten für Kinder | ✅ `genkitFlow: generateStory` | 🔴 Hoch |
| `generateQuiz({topic, age})` | Erstellt Quiz-Fragen für Kinder | ✅ `genkitFlow: generateQuiz` | 🔴 Hoch |

**Aktuell:**
- Direkte Gemini API-Calls
- API-Key via `--dart-define=GEMINI_API_KEY`
- System-Prompt für Alanko-Persönlichkeit

**Mit Genkit:**
- Flow: `alankoChat` mit RAG (Kind-Profil aus Firestore)
- Flow: `generateStory` mit strukturiertem JSON-Output
- Flow: `generateQuiz` mit strukturiertem JSON-Output

---

#### **2. AIGameService** (`lib/services/ai_game_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `generateWordForLetter(letter, age)` | Generiert Wort für Buchstaben-Spiel | ✅ `genkitFlow: generateWordForLetter` | 🟡 Mittel |
| `generateMathProblem(age)` | Erstellt Rechenaufgaben | ✅ `genkitFlow: generateMathProblem` | 🟡 Mittel |
| `generateColorQuiz(age)` | Erstellt Farben-Quiz | ✅ `genkitFlow: generateColorQuiz` | 🟡 Mittel |
| `generateAnimalQuestion(age)` | Erstellt Tier-Fragen | ✅ `genkitFlow: generateAnimalQuestion` | 🟡 Mittel |
| `generateShapeQuestion(age)` | Erstellt Formen-Fragen | ✅ `genkitFlow: generateShapeQuestion` | 🟡 Mittel |
| `generateStory(age, theme)` | Generiert kurze Geschichten | ✅ `genkitFlow: generateStory` (wiederverwendet) | 🟡 Mittel |

**Aktuell:**
- Nutzt GeminiService.ask() mit speziellen Prompts
- Parsing von Text-Responses (fehleranfällig)
- Fallback auf Default-Werte bei Fehlern

**Mit Genkit:**
- Strukturierte JSON-Outputs (kein Parsing nötig)
- Bessere Fehlerbehandlung
- RAG: Altersangepasste Inhalte basierend auf Kind-Profil

---

### **📱 apps/lianko - AI-Funktionen**

#### **1. GeminiService** (`lib/services/gemini_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `ask(String question)` | Chat-Funktion - Lianko beantwortet Fragen | ✅ `genkitFlow: liankoChat` | 🔴 Hoch |
| `generateStory({theme, age})` | Generiert kurze Geschichten | ✅ `genkitFlow: generateStory` (shared) | 🔴 Hoch |
| `generateQuiz({topic, age})` | Erstellt Quiz-Fragen | ✅ `genkitFlow: generateQuiz` (shared) | 🔴 Hoch |

**Hinweis:** Gleiche Funktionen wie Alanko, aber mit angepasstem System-Prompt für schwerhörige Kinder.

---

#### **2. AIGameService** (`lib/services/ai_game_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `generateWordForLetter(letter, age)` | Generiert Wort für Buchstaben-Spiel | ✅ `genkitFlow: generateWordForLetter` (shared) | 🟡 Mittel |
| `generateMathProblem(age)` | Erstellt Rechenaufgaben | ✅ `genkitFlow: generateMathProblem` (shared) | 🟡 Mittel |
| `generateColorQuiz(age)` | Erstellt Farben-Quiz | ✅ `genkitFlow: generateColorQuiz` (shared) | 🟡 Mittel |
| `generateAnimalQuestion(age)` | Erstellt Tier-Fragen | ✅ `genkitFlow: generateAnimalQuestion` (shared) | 🟡 Mittel |
| `generateShapeQuestion(age)` | Erstellt Formen-Fragen | ✅ `genkitFlow: generateShapeQuestion` (shared) | 🟡 Mittel |
| `generateStory(age, theme)` | Generiert kurze Geschichten | ✅ `genkitFlow: generateStory` (shared) | 🟡 Mittel |

**Hinweis:** Identisch zu Alanko, kann gleiche Genkit Flows nutzen.

---

#### **3. AIAudiogramReaderService** (`lib/services/ai_audiogram_reader_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `analyzeImage(imageBytes)` | Analysiert Audiogramm-Bild mit Gemini Vision | ✅ `genkitFlow: analyzeAudiogram` | 🔴 Hoch |

**Aktuell:**
- Nutzt Gemini Vision API direkt
- Extrahiert dB-Werte aus Audiogramm-Bildern
- JSON-Parsing aus Text-Response

**Mit Genkit:**
- Flow: `analyzeAudiogram` mit strukturiertem JSON-Output
- Bessere Fehlerbehandlung
- RAG: Kann historische Audiogramme aus Firestore vergleichen

---

### **📱 apps/callcenter-ai - AI-Funktionen**

#### **1. SalesAgentService** (`lib/services/sales_agent_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `chat(String message)` | Verkaufsgespräch mit Lisa | ✅ `genkitFlow: salesChat` | 🟡 Mittel |

**Aktuell:**
- Direkte Gemini API-Calls
- System-Prompt für Lisa (Verkaufsagentin)
- Session-Management im Backend

**Mit Genkit:**
- Flow: `salesChat` mit Session-Management
- RAG: Kunden-Daten aus CRM (optional)
- Tool-Calling: Speichere Gespräch in DB

---

#### **2. Backend API** (`backend/server.js`)
| Endpoint | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `POST /api/v1/sessions` | Erstellt neue Session | ✅ Genkit Flow mit Session-ID | 🟡 Mittel |
| `POST /api/v1/sessions/:id/chat` | Chat-Nachricht | ✅ `genkitFlow: salesChat` | 🟡 Mittel |
| `GET /api/v1/sessions/:id` | Session-Status | ✅ Genkit Flow (optional) | 🟢 Niedrig |
| `DELETE /api/v1/sessions/:id` | Session beenden | ✅ Genkit Flow (optional) | 🟢 Niedrig |

**Aktuell:**
- Express.js Backend mit Gemini API
- In-Memory Session-Storage
- Rate-Limiting

**Mit Genkit:**
- Ersetzt gesamtes Backend durch Genkit Flows
- Session-Management in Firestore
- Automatisches Rate-Limiting durch Firebase

---

### **📱 apps/therapy-ai - AI-Funktionen**

#### **1. WhisperSpeechService** (`lib/services/whisper_speech_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `transcribeAudio(audioPath, language)` | Speech-to-Text | ❌ Bleibt OpenAI Whisper | ⚪ Nicht migrieren |
| `analyzeSpeech(audioPath, targetWord, language)` | Analysiert Aussprache | ⚠️ Optional: Genkit für Analyse | 🟢 Optional |

**Hinweis:** OpenAI Whisper bleibt, da Genkit keine STT-Funktion hat. Optional: Genkit für Analyse-Logik.

---

#### **2. ElevenLabsVoiceService** (`lib/services/elevenlabs_voice_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `cloneVoice(audioPath, voiceName)` | Klont Stimme | ❌ Bleibt ElevenLabs | ⚪ Nicht migrieren |
| `generateSpeech(text, voiceId)` | TTS mit geklonter Stimme | ❌ Bleibt ElevenLabs | ⚪ Nicht migrieren |

**Hinweis:** ElevenLabs bleibt, da Genkit keine Voice-Cloning-Funktion hat.

---

#### **3. AdaptiveExerciseService** (`lib/services/adaptive_exercise_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `generateExercisePlan(childProfile, durationDays)` | Generiert Übungsplan | ✅ `genkitFlow: generateExercisePlan` | 🟡 Mittel |

**Aktuell:**
- Lokale Logik ohne AI
- Basierend auf Kind-Profil

**Mit Genkit:**
- Flow: `generateExercisePlan` mit RAG (Fortschritt aus Firestore)
- Bessere Personalisierung
- Strukturierter Output

---

### **📦 packages/shared - AI-Funktionen**

#### **1. GeminiService** (`lib/src/services/gemini_service.dart`)
| Funktion | Beschreibung | Genkit Migration | Priorität |
|----------|--------------|------------------|-----------|
| `ask(String question)` | Chat-Funktion | ✅ Wird durch Genkit ersetzt | 🔴 Hoch |
| `generateStory({theme, age})` | Generiert Geschichten | ✅ Wird durch Genkit ersetzt | 🔴 Hoch |
| `generateQuiz({topic, age})` | Erstellt Quiz | ✅ Wird durch Genkit ersetzt | 🔴 Hoch |
| `explain({topic, age})` | Erklärt Themen | ✅ `genkitFlow: explainTopic` | 🟡 Mittel |

**Hinweis:** Wird von Alanko und Lianko genutzt. Migration hier betrifft beide Apps.

---

## 🎯 Priorisierte Migrations-Liste

### **🔴 PRIORITÄT 1: Hoch (Sofort migrieren)**

#### **1.1 Shared GeminiService → Genkit**
- **Betroffene Apps:** Alanko, Lianko
- **Funktionen:**
  - ✅ `ask()` → `genkitFlow: alankoChat` / `genkitFlow: liankoChat`
  - ✅ `generateStory()` → `genkitFlow: generateStory`
  - ✅ `generateQuiz()` → `genkitFlow: generateQuiz`
- **Aufwand:** 2-3 Tage
- **Vorteil:** Zentrale Verwaltung, RAG möglich, Code-Reduktion

#### **1.2 Lianko Audiogramm-Analyse → Genkit**
- **Betroffene App:** Lianko
- **Funktion:**
  - ✅ `analyzeImage()` → `genkitFlow: analyzeAudiogram`
- **Aufwand:** 1 Tag
- **Vorteil:** Strukturierter JSON-Output, bessere Fehlerbehandlung, RAG für historische Vergleiche

---

### **🟡 PRIORITÄT 2: Mittel (Nach Priorität 1)**

#### **2.1 Alanko/Lianko AIGameService → Genkit**
- **Betroffene Apps:** Alanko, Lianko
- **Funktionen:**
  - ✅ `generateWordForLetter()` → `genkitFlow: generateWordForLetter`
  - ✅ `generateMathProblem()` → `genkitFlow: generateMathProblem`
  - ✅ `generateColorQuiz()` → `genkitFlow: generateColorQuiz`
  - ✅ `generateAnimalQuestion()` → `genkitFlow: generateAnimalQuestion`
  - ✅ `generateShapeQuestion()` → `genkitFlow: generateShapeQuestion`
- **Aufwand:** 2-3 Tage
- **Vorteil:** Strukturierte Outputs (kein Parsing), RAG für altersangepasste Inhalte

#### **2.2 Callcenter-AI Backend → Genkit**
- **Betroffene App:** Callcenter-AI
- **Funktionen:**
  - ✅ `POST /api/v1/sessions` → Genkit Flow
  - ✅ `POST /api/v1/sessions/:id/chat` → `genkitFlow: salesChat`
- **Aufwand:** 2 Tage
- **Vorteil:** Ersetzt Express.js Backend, Session-Management in Firestore, automatisches Scaling

#### **2.3 Therapy-AI Exercise Plan → Genkit**
- **Betroffene App:** Therapy-AI
- **Funktion:**
  - ✅ `generateExercisePlan()` → `genkitFlow: generateExercisePlan`
- **Aufwand:** 1-2 Tage
- **Vorteil:** RAG für bessere Personalisierung basierend auf Fortschritt

---

### **🟢 PRIORITÄT 3: Niedrig (Optional)**

#### **3.1 Therapy-AI Speech Analysis → Genkit**
- **Betroffene App:** Therapy-AI
- **Funktion:**
  - ⚠️ `analyzeSpeech()` → Optional: Genkit für Analyse-Logik
- **Aufwand:** 1 Tag
- **Hinweis:** OpenAI Whisper bleibt für STT, Genkit nur für Analyse

#### **3.2 Shared explain() → Genkit**
- **Betroffene Apps:** Alanko, Lianko
- **Funktion:**
  - ✅ `explain()` → `genkitFlow: explainTopic`
- **Aufwand:** 0.5 Tage
- **Vorteil:** Strukturierter Output

---

### **⚪ NICHT MIGRIEREN**

#### **Therapy-AI:**
- ❌ **WhisperSpeechService** - Bleibt OpenAI Whisper (keine Alternative in Genkit)
- ❌ **ElevenLabsVoiceService** - Bleibt ElevenLabs (keine Alternative in Genkit)

**Grund:** Genkit hat keine STT oder Voice-Cloning-Funktionen. Diese APIs bleiben.

---

## 📋 Genkit Flow-Übersicht (Nach Migration)

### **Shared Flows (für mehrere Apps):**
1. ✅ `generateStory` - Geschichten generieren (Alanko, Lianko)
2. ✅ `generateQuiz` - Quiz erstellen (Alanko, Lianko)
3. ✅ `generateWordForLetter` - Wörter für Buchstaben-Spiel (Alanko, Lianko)
4. ✅ `generateMathProblem` - Rechenaufgaben (Alanko, Lianko)
5. ✅ `generateColorQuiz` - Farben-Quiz (Alanko, Lianko)
6. ✅ `generateAnimalQuestion` - Tier-Fragen (Alanko, Lianko)
7. ✅ `generateShapeQuestion` - Formen-Fragen (Alanko, Lianko)
8. ✅ `explainTopic` - Themen erklären (Alanko, Lianko)

### **App-spezifische Flows:**
1. ✅ `alankoChat` - Chat mit Alanko (Alanko)
2. ✅ `liankoChat` - Chat mit Lianko (Lianko)
3. ✅ `analyzeAudiogram` - Audiogramm-Analyse (Lianko)
4. ✅ `salesChat` - Verkaufsgespräch mit Lisa (Callcenter-AI)
5. ✅ `generateExercisePlan` - Übungsplan generieren (Therapy-AI)

**Gesamt: 13 Genkit Flows**

---

## 🚀 Migrations-Roadmap (Empfohlen)

### **Woche 1: Setup & Shared Services**
- **Tag 1-2:** Genkit Setup in Firebase Functions
- **Tag 3-4:** Shared Flows migrieren (`generateStory`, `generateQuiz`, etc.)
- **Tag 5:** Testing & Deployment

### **Woche 2: Alanko & Lianko**
- **Tag 1-2:** Alanko GeminiService → Genkit
- **Tag 3-4:** Lianko GeminiService + Audiogramm → Genkit
- **Tag 5:** AIGameService → Genkit (beide Apps)

### **Woche 3: Callcenter-AI & Therapy-AI**
- **Tag 1-2:** Callcenter-AI Backend → Genkit
- **Tag 3-4:** Therapy-AI Exercise Plan → Genkit
- **Tag 5:** Testing & Dokumentation

**Gesamt: 3 Wochen**

---

## 📊 Zusammenfassung

| Kategorie | Anzahl | Status |
|-----------|--------|--------|
| **Repositories** | 8 | ✅ Analysiert |
| **AI-Services** | 12 | ✅ Identifiziert |
| **AI-Funktionen** | 25+ | ✅ Kategorisiert |
| **Genkit Flows (geplant)** | 13 | 📋 Bereit für Migration |
| **Priorität 1 (Hoch)** | 2 | 🔴 Sofort migrieren |
| **Priorität 2 (Mittel)** | 3 | 🟡 Nach Priorität 1 |
| **Priorität 3 (Niedrig)** | 2 | 🟢 Optional |
| **Nicht migrieren** | 2 | ⚪ Bleibt bei OpenAI/ElevenLabs |

---

## ❓ Was benötige ich von dir?

### **1. Firebase-Projekt-Info:**
- [ ] Firebase-Projekt-ID
- [ ] Firebase-Projekt-Name
- [ ] Bereits Genkit installiert? (Ja/Nein)

### **2. API-Keys:**
- [ ] Gemini API-Key (für Genkit)
- [ ] Sollen API-Keys in Firebase Functions gespeichert werden? (Ja/Nein)

### **3. Prioritäten-Bestätigung:**
- [ ] Priorität 1 (Shared + Audiogramm) bestätigen?
- [ ] Priorität 2 (Spiele + Callcenter) bestätigen?
- [ ] Priorität 3 (Optional) überspringen?

### **4. Migrations-Strategie:**
- [ ] Schrittweise Migration (App für App)?
- [ ] Oder alle auf einmal?
- [ ] Test-Phase vor Production?

### **5. RAG-Integration:**
- [ ] Soll Genkit Firestore-Daten lesen (RAG)?
- [ ] Welche Collections sollen genutzt werden?
  - [ ] `children` (Kind-Profile)
  - [ ] `progress` (Fortschritt)
  - [ ] `audiograms` (Audiogramme)
  - [ ] Andere?

---

**Status:** ✅ Analyse abgeschlossen - Bereit für deine Bestätigung!

**Nächster Schritt:** Sobald du die Fragen beantwortet hast, starte ich mit der Migration.

