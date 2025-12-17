# Test Prompts für Lianko

Diese Datei enthält individuelle Test-Prompts für jedes Modul.
Kopiere den jeweiligen Prompt und gib ihn Claude zur Test-Generierung.

---

## 1. MODELS

---

### 1.1 AudiogramModel

```
MODUL: AudiogramModel
DATEI: lib/models/audiogram/audiogram_model.dart
SPEICHERN IN: test/models/audiogram/audiogram_model_test.dart

BESCHREIBUNG:
Verarbeitet Audiogramm-Daten für Kinder mit Hörbeeinträchtigung.
Berechnet Hörverlust-Level nach WHO-Standard.

KLASSEN ZU TESTEN:

1. EarAudiogram
   - values: Map<int, int> (Frequenz Hz → dB)
   - pta: double (Pure Tone Average)
   - highFrequencyAverage: double
   - lowFrequencyAverage: double
   - hasHighFrequencyLoss: bool
   - valueAt(int freq): int?

2. AudiogramData
   - leftEar, rightEar: EarAudiogram
   - averagePta: double
   - hearingLossLevel: HearingLossLevel
   - hasHighFrequencyLoss: bool
   - betterEar, worseEar: EarAudiogram
   - fromMap(), toMap()

3. HearingLossLevel (enum)
   - normal (≤25 dB)
   - mild (26-40 dB)
   - moderate (41-60 dB)
   - severe (61-80 dB)
   - profound (>80 dB)

4. AudiogramRecommendations
   - fromAudiogram(AudiogramData): berechnet Empfehlungen
   - speechRate, pitch, subtitlesAlwaysOn, etc.

EDGE CASES:
- Leeres EarAudiogram (values: {})
- Nur manche Frequenzen vorhanden
- Asymmetrischer Hörverlust (links stark, rechts leicht)
- Grenzwerte (genau 25, 40, 60, 80 dB)
- Extreme Werte (0 dB, 120 dB)

BEISPIEL-TESTS:
```dart
test('PTA berechnet Durchschnitt von 500, 1000, 2000, 4000 Hz', () {
  final ear = EarAudiogram(values: {500: 40, 1000: 50, 2000: 60, 4000: 70});
  expect(ear.pta, equals(55.0));
});

test('HearingLossLevel.moderate bei 45 dB', () {
  final audiogram = AudiogramData(
    leftEar: EarAudiogram(values: {500: 45, 1000: 45, 2000: 45, 4000: 45}),
    rightEar: EarAudiogram(values: {500: 45, 1000: 45, 2000: 45, 4000: 45}),
    measuredAt: DateTime.now(),
  );
  expect(audiogram.hearingLossLevel, equals(HearingLossLevel.moderate));
});
```

ABHÄNGIGKEITEN: Keine (reines Dart)
```

---

### 1.2 ChildSettingsModel

```
MODUL: ChildSettingsModel
DATEI: lib/models/settings/child_settings_model.dart
SPEICHERN IN: test/models/settings/child_settings_model_test.dart

BESCHREIBUNG:
Zentrale Einstellungen für ein Kind, synchronisiert mit ParentsDash.

KLASSEN ZU TESTEN:

1. ChildSettingsModel
   - fromFirestore(DocumentSnapshot): parsed Firestore-Dokument
   - defaults(): Standardwerte
   - Alle Properties (name, age, timeLimit, etc.)

2. TimeLimit
   - dailyMinutes, breakIntervalMinutes, breakDurationMinutes
   - bedtimeEnabled, bedtimeStart, bedtimeEnd
   - fromMap(), toMap(), defaults()

3. GameSetting
   - isEnabled, maxLevel
   - fromMap(), toMap(), defaults()

4. AccessibilitySettings
   - subtitlesEnabled, subtitleLanguage
   - textScale, highContrast
   - fromMap(), toMap(), defaults()

5. LiankoSettings
   - zeigSprechEnabled, useChildRecordings
   - speechRate, language, autoRepeat, maxAttempts
   - hearingAidCheckEnabled, requireBothEars
   - notifyParentOnNoHearingAid, notifyParentOnDifficulty
   - fromMap(), toMap(), defaults()

6. LeaderboardConsent
   - canSeeLeaderboard, canBeOnLeaderboard
   - displayNameType
   - fromMap(), toMap(), defaults()

EDGE CASES:
- Leere Map in fromMap()
- Fehlende Felder → Defaults
- Ungültige Typen (String statt int)
- Null-Werte

BEISPIEL-TESTS:
```dart
test('LiankoSettings.defaults hat korrekteStandardwerte', () {
  final settings = LiankoSettings.defaults();
  expect(settings.speechRate, equals(0.4));
  expect(settings.language, equals('bs'));
  expect(settings.hearingAidCheckEnabled, isTrue);
});

test('TimeLimit.fromMap parsed alle Felder', () {
  final map = {'dailyMinutes': 90, 'breakIntervalMinutes': 20};
  final timeLimit = TimeLimit.fromMap(map);
  expect(timeLimit.dailyMinutes, equals(90));
  expect(timeLimit.breakIntervalMinutes, equals(20));
});
```

ABHÄNGIGKEITEN:
- Mock für DocumentSnapshot (Firestore)
```

---

### 1.3 CommunicationModel

```
MODUL: CommunicationModel
DATEI: lib/models/communication/communication_model.dart
SPEICHERN IN: test/models/communication/communication_model_test.dart

BESCHREIBUNG:
Zeig-Sprech-Modul - Symbole für nonverbale Kommunikation.

KLASSEN ZU TESTEN:

1. CommunicationCategory (enum)
   - Alle Kategorien: schmerzen, essen, trinken, gefuehle, etc.
   - displayName, icon, color

2. CommunicationSymbol
   - id, name, imagePath, audioPath, category
   - hasCustomRecording
   - fromJson(), toJson()

3. Hilfsfunktionen
   - getSymbolsForCategory()
   - getAllCategories()

EDGE CASES:
- Ungültige Kategorie in fromJson
- Fehlende Felder
- Leere Listen

ABHÄNGIGKEITEN: Keine
```

---

### 1.4 VocabularyModel

```
MODUL: VocabularyModel
DATEI: lib/models/vocabulary/vocabulary_model.dart
SPEICHERN IN: test/models/vocabulary/vocabulary_model_test.dart

BESCHREIBUNG:
Vokabel-Daten für Lernspiele (Tiere, Familie, Essen, etc.)

KLASSEN ZU TESTEN:

1. VocabularyCategory (enum)
   - tiere, familie, essen, koerper, farben, zahlen
   - displayName, icon

2. VocabularyItem
   - id, word, imagePath, audioPath, category
   - difficulty (1-3)
   - fromJson(), toJson()

EDGE CASES:
- Ungültige difficulty (0, 4, negative)
- Leere Strings

ABHÄNGIGKEITEN: Keine
```

---

### 1.5 StoryModel

```
MODUL: StoryModel
DATEI: lib/models/stories/story_model.dart
SPEICHERN IN: test/models/stories/story_model_test.dart

BESCHREIBUNG:
Interaktive Geschichten mit Bildern und Audio.

KLASSEN ZU TESTEN:

1. Story
   - id, title, coverImage, pages
   - totalPages, difficulty
   - fromJson(), toJson()

2. StoryPage
   - pageNumber, text, imagePath, audioPath
   - highlightWords (für Mitlesen)
   - fromJson(), toJson()

EDGE CASES:
- Geschichte ohne Seiten
- Leere highlightWords

ABHÄNGIGKEITEN: Keine
```

---

### 1.6 SyllableModel

```
MODUL: SyllableModel
DATEI: lib/models/syllables/syllable_model.dart
SPEICHERN IN: test/models/syllables/syllable_model_test.dart

BESCHREIBUNG:
Silben-Training für Sprachentwicklung.

KLASSEN ZU TESTEN:

1. Syllable
   - syllable, audioPath, exampleWords
   - difficulty
   - fromJson(), toJson()

2. SyllableExercise
   - targetSyllable, options, correctIndex
   - fromJson()

ABHÄNGIGKEITEN: Keine
```

---

### 1.7 GameItem

```
MODUL: GameItem
DATEI: lib/models/games/game_item.dart
SPEICHERN IN: test/models/games/game_item_test.dart

BESCHREIBUNG:
Spiel-Definitionen und Metadaten.

KLASSEN ZU TESTEN:

1. GameItem
   - id, name, description, iconPath
   - minAge, maxAge, difficulty
   - isAvailableForAge(int age): bool

EDGE CASES:
- Alter genau auf Grenze (minAge, maxAge)
- Alter außerhalb des Bereichs

ABHÄNGIGKEITEN: Keine
```

---

## 2. SERVICES

---

### 2.1 AIAudiogramReaderService

```
MODUL: AIAudiogramReaderService
DATEI: lib/services/ai_audiogram_reader_service.dart
SPEICHERN IN: test/services/ai_audiogram_reader_service_test.dart

BESCHREIBUNG:
Analysiert Audiogramm-Fotos mit Gemini Vision AI.

KLASSEN ZU TESTEN:

1. AIAudiogramReaderService
   - initialize(apiKey): Initialisiert Gemini
   - analyzeImage(Uint8List): Analysiert Bild
   - isReady: bool

2. AudiogramReadResult
   - success, error
   - leftEar, rightEar, confidence, notes
   - toAudiogramData(): Konvertiert zu AudiogramData
   - confidencePercent, isHighConfidence

METHODEN:
- _buildAnalysisPrompt(): Generiert Gemini-Prompt
- _parseResponse(): Parsed JSON-Antwort
- _parseEarData(): Konvertiert Ear-Daten

EDGE CASES:
- Gemini gibt Fehler zurück
- JSON-Parsing schlägt fehl
- Kein Audiogramm im Bild erkannt
- Niedrige Konfidenz (<0.5)

MOCK BENÖTIGT:
- GenerativeModel (Gemini API)

BEISPIEL-TESTS:
```dart
test('parseResponse extrahiert dB-Werte korrekt', () {
  final jsonResponse = '''
  {
    "success": true,
    "leftEar": {"500": 40, "1000": 50},
    "rightEar": {"500": 35, "1000": 45},
    "confidence": 0.85
  }
  ''';
  final result = service._parseResponse(jsonResponse);
  expect(result.success, isTrue);
  expect(result.leftEar?.values[500], equals(40));
});
```

ABHÄNGIGKEITEN:
- Mock für GenerativeModel
```

---

### 2.2 HearingAidDetectionService

```
MODUL: HearingAidDetectionService
DATEI: lib/services/hearing_aid_detection_service.dart
SPEICHERN IN: test/services/hearing_aid_detection_service_test.dart

BESCHREIBUNG:
Erkennt Hörgeräte mittels Kamera und ML Kit.

KLASSEN ZU TESTEN:

1. HearingAidDetectionResult
   - result (enum), confidence
   - leftEarDetected, rightEarDetected
   - isDetected, bothEarsDetected

2. HearingAidDetectionService
   - _rgbToHsv(): RGB zu HSV Konvertierung
   - _isHearingAidColor(): Prüft auf Hörgeräte-Farben
   - _analyzeEarRegion(): Analysiert Pixel-Region

METHODEN (privat, aber testbar):
- _rgbToHsv(r, g, b): Korrekte HSV-Werte
- _isHearingAidColor(hue, sat, val): Erkennt typische Farben

EDGE CASES:
- Kein Gesicht im Bild
- Sehr dunkles/helles Bild
- Bunte vs. hautfarbene Hörgeräte

ABHÄNGIGKEITEN:
- Mock für CameraController
- Mock für FaceDetector
```

---

### 2.3 AudiogramAdaptiveTTSService

```
MODUL: AudiogramAdaptiveTTSService
DATEI: lib/services/audiogram_adaptive_tts_service.dart
SPEICHERN IN: test/services/audiogram_adaptive_tts_service_test.dart

BESCHREIBUNG:
TTS passt sich an Audiogramm-Daten an.

KLASSEN ZU TESTEN:

1. AudiogramAdaptiveTTSService
   - initialize(): Initialisiert TTS
   - speak(text): Spricht mit angepassten Settings
   - speakWord(word, emphasized): Betonte Aussprache
   - recommendations: Aktuelle Empfehlungen
   - shouldShowSubtitles, shouldEnlargeAnimations

PROVIDER ZU TESTEN:
- shouldShowSubtitlesProvider
- recommendedTextScaleProvider
- hearingLossLevelProvider

EDGE CASES:
- Kein Audiogramm vorhanden → Fallback
- Audiogramm nicht bestätigt
- Extreme Hörverlust-Werte

ABHÄNGIGKEITEN:
- Mock für FlutterTts
- Mock für Ref (Riverpod)
```

---

### 2.4 ParentNotificationService

```
MODUL: ParentNotificationService
DATEI: lib/services/parent_notification_service.dart
SPEICHERN IN: test/services/parent_notification_service_test.dart

BESCHREIBUNG:
Sendet Push-Benachrichtigungen an Eltern.

KLASSEN ZU TESTEN:

1. ParentNotification
   - type, title, body, data, timestamp
   - toMap(), fromMap()

2. ParentNotificationService
   - notifyHearingAidNotWorn(): Benachrichtigt bei fehlenden Hörgeräten
   - notifyLearningDifficulty(): Bei Lern-Schwierigkeiten
   - logHearingAidCheck(): Speichert Check-Ergebnis
   - getTodayHearingAidStats(): Tagesstatistik

3. HearingAidStats
   - totalChecks, wearingCount, notWearingCount
   - wearingPercentage

EDGE CASES:
- Benachrichtigung deaktiviert → nicht senden
- Keine childId → früh returnen
- Firestore-Fehler

ABHÄNGIGKEITEN:
- Mock für FirebaseFirestore
- Mock für Ref
```

---

### 2.5 AnalyticsService

```
MODUL: AnalyticsService
DATEI: lib/services/analytics_service.dart
SPEICHERN IN: test/services/analytics_service_test.dart

BESCHREIBUNG:
Firebase Analytics Event-Tracking.

METHODEN ZU TESTEN:

1. User Properties
   - setUserProperties(): Setzt User-Daten
   - _getAgeGroup(age): Berechnet Altersgruppe

2. Events
   - logScreenView()
   - logGameStart(), logGameComplete()
   - logWordPractice(), logLearningDifficulty()
   - logHearingAidCheck()
   - logSessionStart(), logSessionEnd()

EDGE CASES:
- _getAgeGroup für alle Alter (3-12)
- Null-Parameter

ABHÄNGIGKEITEN:
- Mock für FirebaseAnalytics
- Mock für FirebaseCrashlytics
```

---

### 2.6 TimeLimitService

```
MODUL: TimeLimitService
DATEI: lib/services/time_limit_service.dart
SPEICHERN IN: test/services/time_limit_service_test.dart

BESCHREIBUNG:
Verwaltet tägliche Spielzeit und Pausen.

METHODEN ZU TESTEN:

- getRemainingTime(): Verbleibende Minuten
- isTimeUp(): Limit erreicht?
- shouldTakeBreak(): Pause nötig?
- isBedtime(): Schlafenszeit?

EDGE CASES:
- Genau auf Limit
- Über Mitternacht
- Bedtime deaktiviert

ABHÄNGIGKEITEN:
- Mock für SharedPreferences
```

---

### 2.7 Premium Services

```
MODUL: PremiumServices
DATEIEN:
- lib/services/premium/battery_reminder_service.dart
- lib/services/premium/progress_export_service.dart
- lib/services/premium/speech_therapy_service.dart
- lib/services/premium/audiogram_service.dart

SPEICHERN IN: test/services/premium/[name]_test.dart

BatteryReminderService:
- shouldShowReminder(): Prüft ob Erinnerung fällig
- markBatteryChanged(): Speichert Wechseldatum
- getDaysSinceChange(): Tage seit letztem Wechsel

ProgressExportService:
- generatePDFReport(): Erstellt PDF
- getWeeklyStats(): Wochenstatistik

SpeechTherapyService:
- getAssignedExercises(): Holt Übungen
- logExerciseComplete(): Speichert Fortschritt

AudiogramService:
- getStoredAudiogram(): Lädt gespeichertes Audiogramm
- saveAudiogram(): Speichert neues Audiogramm

ABHÄNGIGKEITEN:
- Mock für Firestore
- Mock für SharedPreferences
```

---

## 3. PROVIDERS

---

### 3.1 ChildSettingsProvider

```
MODUL: ChildSettingsProvider
DATEI: lib/providers/child_settings_provider.dart
SPEICHERN IN: test/providers/child_settings_provider_test.dart

PROVIDER ZU TESTEN:

- currentChildIdProvider
- childSettingsStreamProvider
- childSettingsProvider
- liankoSettingsProvider
- timeLimitProvider
- accessibilityProvider

HILFSFUNKTIONEN:
- isGameEnabled(settings, gameId)
- areSubtitlesEnabled(settings)
- getSubtitleLanguage(settings)

ABHÄNGIGKEITEN:
- Mock für Firestore
- ProviderContainer für Tests
```

---

## 4. UTILS

---

### 4.1 DateUtils (falls vorhanden)

```
MODUL: DateUtils
DATEI: lib/utils/date_utils.dart (falls vorhanden)
SPEICHERN IN: test/utils/date_utils_test.dart

Typische Funktionen:
- formatDate()
- isToday()
- daysBetween()
```

---

## Zusammenfassung

| Modul | Priorität | Abhängigkeiten |
|-------|-----------|----------------|
| AudiogramModel | 🔴 Hoch | Keine |
| ChildSettingsModel | 🔴 Hoch | Firestore Mock |
| AIAudiogramReaderService | 🔴 Hoch | Gemini Mock |
| HearingAidDetectionService | 🟠 Mittel | Camera/ML Mock |
| ParentNotificationService | 🟠 Mittel | Firestore Mock |
| AnalyticsService | 🟡 Niedrig | Firebase Mock |
| TimeLimitService | 🟠 Mittel | Prefs Mock |
| CommunicationModel | 🟡 Niedrig | Keine |
| VocabularyModel | 🟡 Niedrig | Keine |

---

## Anwendung

1. Kopiere den gewünschten Prompt
2. Gib ihn Claude ein
3. Claude generiert die Test-Datei
4. Speichere unter dem angegebenen Pfad
5. Führe `flutter test` aus
