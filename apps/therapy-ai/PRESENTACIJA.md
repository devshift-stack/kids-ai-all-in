# Therapy AI - AI-Pokretač Aplikacija za Terapiju Govora

## 📱 Pregled Projekta

**Therapy AI** je inovativna mobilna aplikacija koja koristi umjetnu inteligenciju za pomoć djeci sa slušnim oštećenjima u učenju govora i artikulacije.

---

## 🎯 Glavni Ciljevi

### 1. Personalizovana Terapija
- AI analizira govor djeteta u realnom vremenu
- Prilagođava vježbe na osnovu napretka
- Fokus na asimetrična slušna oštećenja

### 2. Interaktivno Učenje
- Interaktivne vježbe govora
- Trenutni feedback o izgovoru
- Gamifikacija za motivaciju

### 3. Personalizovani Glas
- Integracija glasa terapeuta/audiologa
- Emocionalna povezanost kroz poznati glas
- Povećana motivacija za vježbanje

---

## 🛠️ Tehnologije

### OpenAI Whisper
- **Svrha:** Prepoznavanje i analiza govora
- **Karakteristike:**
  - Visoka tačnost transkripcije (do 95%)
  - Analiza izgovora i artikulacije
  - Detekcija nivoa glasnoće
  - Rad na uređaju (offline)

### ElevenLabs
- **Svrha:** Kloniranje glasa terapeuta
- **Karakteristike:**
  - Prirodan, emocionalan glas
  - Podrška za 29+ jezika
  - Niska latencija
  - GDPR kompatibilno

### Adaptive Logic (Dart)
- **Svrha:** Prilagođavanje vježbi
- **Karakteristike:**
  - Praćenje performansi
  - Dinamička prilagodba težine
  - Algoritmi za ponavljanje
  - Personalizovani planovi vježbi

### Flutter
- **Svrha:** Cross-platform razvoj
- **Karakteristike:**
  - iOS i Android iz jednog koda
  - Brz razvoj
  - Hot reload
  - Dizajn prilagođen djeci

---

## 📊 Funkcionalnosti

### 1. Analiza Govora
```
┌─────────────────────────┐
│  Dijete govori          │
│         ↓               │
│  Whisper analizira      │
│         ↓               │
│  Rezultati:             │
│  • Tačnost izgovora     │
│  • Nivo glasnoće        │
│  • Artikulacija         │
│  • Fonemska analiza     │
└─────────────────────────┘
```

### 2. Prilagođene Vježbe
- **Početni nivo:** Jednostavne riječi (Mama, Papa)
- **Srednji nivo:** Rečenice i fonemi
- **Napredni nivo:** Konverzacije

### 3. Praćenje Napretka
- Dnevni/nedeljni grafikoni
- Trendovi poboljšanja
- Statistike uspješnosti
- Achievement badge-ovi

---

## 🎨 Korisničko Iskustvo

### Setup Faza
1. **Kloniranje Glasa**
   - Upload audio uzorka terapeuta
   - Testiranje kloniranog glasa
   - Konfiguracija postavki

2. **Profil Djeteta**
   - Unos slušnog oštećenja (lijevo/desno uho)
   - Dob i jezičke preferencije
   - Terapijski ciljevi

### Terapijska Sesija
1. **Prikaz Vježbe**
   - Instrukcije na ekranu
   - Ciljna riječ/fraza
   - Vizuelni indikatori

2. **Snimanje**
   - Dijete ponavlja
   - Real-time analiza
   - Vizuelni feedback

3. **Rezultati**
   - Detaljna analiza
   - Grafikon talasa
   - Preporuke za poboljšanje

---

## 🔒 Privatnost i Sigurnost

### Zaštita Podataka
- ✅ Sva audio obrada na uređaju (Whisper)
- ✅ ElevenLabs API samo za TTS generisanje
- ✅ Nema čuvanja audio u cloud-u
- ✅ GDPR kompatibilno
- ✅ Roditeljski pristanak za kloniranje glasa

### Medicinska Odgovornost
- ⚠️ **Nije medicinski proizvod**
- ⚠️ **Ne dijagnostikuje**
- ✅ **Samo podrška terapiji**
- ✅ **Konsultacija sa stručnjacima preporučena**

---

## 📈 Plan Implementacije

### Faza 1: Osnova (Nedelja 1-2)
- ✅ Struktura aplikacije
- ✅ Whisper integracija
- ✅ Osnovno snimanje i transkripcija

### Faza 2: Kloniranje Glasa (Nedelja 2-3)
- ⏳ ElevenLabs API integracija
- ⏳ Workflow za kloniranje
- ⏳ TTS sa kloniranim glasom

### Faza 3: Adaptivna Logika (Nedelja 3-4)
- ⏳ Adaptive Exercise Service
- ⏳ Praćenje performansi
- ⏳ Algoritmi prilagodbe

### Faza 4: Napredna Analiza (Nedelja 4-5)
- ⏳ Scoring izgovora
- ⏳ Analiza glasnoće
- ⏳ Fonemska detekcija

### Faza 5: UI/UX (Nedelja 5-6)
- ⏳ Kompletiranje ekrana
- ⏳ Gamifikacija
- ⏳ Vizualizacija napretka

### Faza 6: Testiranje (Nedelja 6-7)
- ⏳ Testiranje sa stvarnim uzorcima
- ⏳ Optimizacija performansi
- ⏳ Fine-tuning algoritama

---

## 💡 Prednosti

### Za Djecu
- 🎮 Zabavno učenje kroz igru
- 📊 Vidljiv napredak
- 🎯 Personalizovane vježbe
- 💪 Povećana motivacija

### Za Roditelje
- 📈 Praćenje napretka
- 🏥 Podrška profesionalnoj terapiji
- 💰 Isplativije od čestih posjeta
- ⏰ Fleksibilnost vremena

### Za Terapeute
- 📊 Detaljni podaci o napretku
- 🎯 Fokus na problematična područja
- 📝 Dokumentacija sesija
- 🔄 Kontinuirana podrška između sesija

---

## 🌍 Podržani Jezici

- 🇧🇦 **Bosanski** (default)
- 🇬🇧 **Engleski**
- 🇭🇷 **Hrvatski**
- 🇷🇸 **Srpski**
- 🇩🇪 **Njemački**
- 🇹🇷 **Turski**

---

## 📱 Platforme

- ✅ **Android** (minSdk: 21+)
- ✅ **iOS** (iOS 12+)
- 🔄 **Offline mode** podržan

---

## 🚀 Budućnost

### Kratkoročno
- Fine-tuning Whisper modela sa uzorcima dječjeg govora
- Više tipova vježbi
- Integracija sa parent dashboard-om

### Dugoročno
- AR elementi za vizuelizaciju
- Multiplayer/socijalne funkcije
- Integracija sa slušnim aparatima
- AI asistent za roditelje

---

## 📞 Kontakt i Podrška

**Projekt:** Therapy AI  
**Verzija:** 1.0.0  
**Status:** U razvoju

---

## 📚 Reference

- OpenAI Whisper: https://openai.com/research/whisper
- ElevenLabs: https://elevenlabs.io
- Flutter: https://flutter.dev

---

**Napomena:** Ova aplikacija je dizajnirana kao pomoćni alat za profesionalnu terapiju, ne kao zamjena za medicinsku dijagnozu ili tretman.

