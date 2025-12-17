# Kids AI Shared – Public API Referenz (`kids_ai_shared`)

Diese Datei dokumentiert **alle öffentlichen APIs** des Pakets `kids_ai_shared` – d. h. alles, was über `lib/kids_ai_shared.dart` exportiert wird.

> Import in Apps:
>
> ```dart
> import 'package:kids_ai_shared/kids_ai_shared.dart';
> ```

---

## Installation & Voraussetzungen

- **Dependency**: Das Paket wird in den Apps typischerweise als Git‑Dependency eingebunden.
- **Assets**: Damit Audio/FX funktionieren, müssen die Assets aus `packages/shared/assets/…` in der App verfügbar sein (die Shared‑`pubspec.yaml` enthält die Asset‑Deklarationen für dieses Package).
- **Plattform‑Berechtigungen** (je nach Nutzung):
  - **Mikrofon**: benötigt für `RecordingService` (Speech‑to‑Text).
  - **Notifications**: benötigt für `PushNotificationService`.

---

## Automatische API‑Doku (DartDoc)

Für eine HTML‑Referenz (zusätzlich zu dieser Markdown‑Doku):

```bash
cd /workspace/packages/shared
flutter pub get
# je nach Tooling:
# 1) falls verfügbar
 dart doc
# oder 2) klassisch
 dartdoc
```

---

## Public API Übersicht (Exports)

Öffentliche Exports aus `lib/kids_ai_shared.dart`:

- **Audio (TTS/Pre‑Recorded/Cache)**
  - `PreRecordedAudioService`
  - `FluentTtsService`, `OfflineMode`, `OfflinePreloadResult`, `OfflineAvailability`
  - `TtsProvider`, `TtsProviderType`, `EdgeTtsProvider`, `AzureTtsProvider`, `GoogleTtsProvider`
  - `TtsCacheManager`, `CacheStats`
  - `TtsConfig`, `TtsVoiceConfig`
- **Audio (STT/Recording)**
  - `RecordingService`, `listenForSpeech`
  - `SttProviderBase`, `GoogleSttProvider`, `AzureSttProvider`, `WhisperSttProvider`, `SttProviderFactory`, `SttProvider`
  - `SttLanguages`, `SttLanguageConfig`, `RecordingSettings`, `RecognitionResult`, `RecognitionStatus`, `RecognitionError`
- **Sound Effects**
  - `SoundEffectsService`, `SoundEffect`, `SoundCategory`, `SoundConfig` + Helper `playSound`, `playCorrectSound`, …
- **Theme**
  - `KidsColors`, `KidsTypography`, `KidsSpacing`, `KidsGradients`, `KidsShadows`
- **Widgets**
  - `KidButton`, `KidIconButton`, `KidButtonVariant`, `KidButtonSize`
  - `KidCard`, `KidGameCard`, `KidStatCard`, `KidCardVariant`
  - `KidAvatar`, `KidAvatarGroup`, `KidAvatarData`, `KidAvatarSize`
  - `LiankoAvatar`, `LiankoEmotion`
- **Notifications**
  - `PushNotificationService`, `KidsNotification`, `NotificationType`
  - Presets: `KidsReminders`, `LiankoNotifications`, `AlankoNotifications`
- **Offline Sync**
  - `OfflineSyncService`, `SyncAction`, `CacheEntry`
  - Riverpod Provider: `offlineSyncServiceProvider`, `isOnlineProvider`, `pendingActionsCountProvider`
- **Error Handling**
  - `ErrorHandlingService`, `AppError`, `ErrorType`, `ErrorSeverity`
  - Riverpod Provider: `errorHandlingServiceProvider`
  - Extension: `AsyncErrorHandling<T>.handleErrors()`
- **Utils**
  - `GameUtils`

---

## Audio – Pre‑Recorded Phrasen (`PreRecordedAudioService`)

Spielt **voraufgenommene** MP3‑Assets für fixe Phrasen ab bzw. liefert Pfade/Text für UI‑Untertitel.

### Asset‑Layout

`assets/audio/{sprache}/{typ}_{nummer}.mp3` (Sprache ist z. B. `de`, `en`, `bs` …)

Beispiel: `assets/audio/de/correct_1.mp3`

### Wichtige APIs

- **Singleton**: `PreRecordedAudioService()`
- **Sprache setzen**: `setLanguage(String languageCode)` (nimmt `de-DE` → `de`)
- **Verfügbarkeit prüfen**: `hasPreRecordedAudio(String type)`
- **Zufälligen Asset‑Pfad holen**: `getAudioPath(String type)`
- **Zufälligen Text holen**: `getPhraseText(String type)`
- **Aufnahmeliste erzeugen**: `generateRecordingList()` → `Map<String, List<AudioFileInfo>>`
- **Asset‑Vollständigkeit prüfen**: `checkAudioFiles(String language)` → `AudioCheckResult`

### Beispiel

```dart
final pre = PreRecordedAudioService();
pre.setLanguage('de-DE');

if (pre.hasPreRecordedAudio('correct')) {
  final path = pre.getAudioPath('correct');
  final subtitle = pre.getPhraseText('correct');
  // path z.B. assets/audio/de/correct_3.mp3
  // subtitle z.B. "Ausgezeichnet!"
}
```

---

## Audio – Flüssige Sprachausgabe (`FluentTtsService`)

`FluentTtsService` kombiniert:

1. **Pre‑Recorded Audio** (für kurze Standardphrasen)
2. **Cache** (lokal gespeicherte MP3s)
3. **Cloud TTS** (Edge → optional Azure → optional Google)
4. **Offline Fallback** via `flutter_tts`

### Kernkonzepte

- **Singleton**: `FluentTtsService.instance`
- **Offline‑Strategie**: `OfflineMode` (`auto`, `forceOffline`, `forceOnline`)
- **Callbacks**:
  - `onStartSpeaking(String text)`
  - `onFinishSpeaking()`
  - `onError(String error)`
  - `onConnectivityChanged(bool isOffline)`

### Wichtige APIs

- **Init**: `init({String? azureKey, String? googleKey})`
  - Edge‑TTS wird immer hinzugefügt.
  - Azure/Google nur, wenn Key gesetzt ist.
- **Sprache setzen**: `setLanguage(String language)` (z. B. `de-DE`)
- **Kurztext sprechen**: `speak(String text)`
- **Langtext sprechen**: `speakLong(String text)` (Satz‑Pufferung)
- **Stop**: `stop()`
- **Preload**: `preloadCommonPhrases()`
- **Cache**: `getCacheStats()`, `clearCache()`
- **Connectivity**: `checkConnectivity()`
- **Offline‑Preload**: `preloadForOffline({additionalTexts, onProgress})` → `OfflinePreloadResult`
- **Offline‑only sprechen**: `speakOfflineOnly(String text)`
- **Offline‑Fähigkeit**: `getOfflineAvailability()` → `OfflineAvailability`

### Minimalbeispiel (TTS)

```dart
final tts = FluentTtsService.instance;
await tts.init();
await tts.setLanguage('de-DE');

tts.onError = (msg) {
  // Logging/UI
};

await tts.speak('Hallo!');
```

### Beispiel: Offline‑Preload (WLAN‑Phase)

```dart
final tts = FluentTtsService.instance;
await tts.init(azureKey: '<optional>', googleKey: '<optional>');
await tts.setLanguage('de-DE');

final result = await tts.preloadForOffline(
  additionalTexts: ['Bitte wiederholen.', 'Sehr gut!'],
  onProgress: (current, total) {
    // Progress UI
  },
);

// result.loaded / result.failed / result.skipped
```

---

## Audio – TTS Provider (`TtsProvider`, `EdgeTtsProvider`, `AzureTtsProvider`, `GoogleTtsProvider`)

### `TtsProvider` (abstrakt)

- `Future<Uint8List?> synthesize(String text, String language)`
- `String get name`
- `Future<bool> isAvailable()`

### Provider‑Typen

- **Edge**: `EdgeTtsProvider` (kostenlos, ohne Key; versucht mehrere Endpoints)
- **Azure**: `AzureTtsProvider(subscriptionKey, region = 'westeurope')`
- **Google**: `GoogleTtsProvider(apiKey)`

> In der Praxis musst du diese Provider selten direkt nutzen – `FluentTtsService.init()` verwaltet die Provider‑Liste.

---

## Audio – TTS Konfiguration (`TtsConfig`, `TtsVoiceConfig`)

### `TtsConfig`

- `voices`: Map von Sprache → `TtsVoiceConfig`
- `childVoices`: alternative Kinderstimmen (für jüngere Kinder)
- `defaultRate`, `defaultPitch`, `audioFormat`
- Cache‑Policy: `maxCacheSizeMb`, `cacheDurationDays`
- `commonPhrases`: häufige Phrasen pro Sprache
- **Stimmenwahl**: `getVoiceForChild(String language, int age)`
- `supportedLanguages`, `isLanguageSupported(language)`

### Beispiel

```dart
final voice = TtsConfig.getVoiceForChild('de-DE', 5);
// voice.edgeVoice / voice.azureVoice / voice.googleVoice
```

---

## Audio – Cache (`TtsCacheManager`, `CacheStats`)

Speichert generierte MP3s unter `.../tts_cache/` und hält einen Memory‑Index.

### Wichtige APIs

- `init()` (legt Cache‑Ordner an, lädt vorhandene Dateien, räumt alte Dateien)
- `hasCache(text, language)`
- `getFromCache(text, language)` → `Future<File?>`
- `saveToCache(text, language, audioBytes)`
- `preloadPhrases(language, synthesizeFunc)` (nutzt `TtsConfig.commonPhrases`)
- `getStats()` → `CacheStats`
- `clearCache()`

---

## Audio – Recording & Speech‑to‑Text

### Konfiguration (`recording_config.dart`)

- `SttProvider` (Enum): `onDevice`, `google`, `azure`, `whisper`
- `SttLanguageConfig`: Codes für On‑Device/Google/Azure/Whisper
- `SttLanguages`: vordefinierte Sprachen + `fromCode()` + `defaultLanguage`
- `RecordingSettings`: Sample‑Rate/Listen‑Time/Partial‑Results etc.
  - Presets: `RecordingSettings.forKids`, `RecordingSettings.forShortAnswers`
- `RecognitionResult`: Text/Confidence/Final/Alternates/Duration
- `RecognitionStatus`: `ready`, `listening`, `processing`, `done`, `error`, `unavailable`
- `RecognitionError`: Standardfehler (Mic‑Permission, Network, Timeout, …)

### `RecordingService`

Zentraler Einstieg für STT.

- **Singleton**: `RecordingService.instance`
- **Init**: `initialize({language, settings, cloudProvider})`
  - fordert Mikrofon‑Permission an
  - initialisiert `speech_to_text` (On‑Device)
  - optional: setzt Cloud‑Provider als Fallback
- **Start**: `startListening({language, useCloudFallback = true})`
- **Stop**: `stopListening()`
- **Cancel**: `cancel()`
- **Callbacks**:
  - `onResult(RecognitionResult)`
  - `onStatusChange(RecognitionStatus)`
  - `onError(RecognitionError)`
  - `onSoundLevel(double)`

### Quick‑Helper: `listenForSpeech()`

```dart
final result = await listenForSpeech(
  language: SttLanguages.german,
  timeout: const Duration(seconds: 10),
);
if (result.isNotEmpty) {
  // result.text
}
```

### Cloud‑Provider (`SttProviderBase` + Implementierungen)

- `GoogleSttProvider(apiKey, enableAutomaticPunctuation = true, model = 'default')`
- `AzureSttProvider(subscriptionKey, region)`
- `WhisperSttProvider(apiKey, model = 'whisper-1')`
- `SttProviderFactory.create(SttProvider, {apiKey, subscriptionKey, region})`

#### Beispiel: Cloud‑Fallback aktivieren

```dart
final cloud = SttProviderFactory.create(
  SttProvider.whisper,
  apiKey: '<OPENAI_API_KEY>',
);

await RecordingService.instance.initialize(
  language: SttLanguages.german,
  settings: RecordingSettings.forKids,
  cloudProvider: cloud,
);

RecordingService.instance.onResult = (r) {
  // r.text
};

await RecordingService.instance.startListening(useCloudFallback: true);
```

---

## Sound Effects (`SoundEffectsService`)

Spielt UI‑ und Spiel‑Sounds aus Assets ab.

### Wichtige APIs

- **Singleton**: `SoundEffectsService.instance`
- `initialize()`
- `play(SoundEffect effect)`
- `stop(SoundEffect effect)` / `stopAll()`
- `setMasterVolume(double)`
- `setCategoryVolume(SoundCategory, double)`
- `toggleMute()` / `setMuted(bool)`
- `dispose()`

### Helper

- `playSound(effect)`
- `playCorrectSound()`, `playWrongSound()`, `playButtonSound()`, `playCoinSound()`, `playLevelUpSound()`

### Beispiel

```dart
await SoundEffectsService.instance.initialize();
await playButtonSound();
await playCorrectSound();
```

---

## Theme

### `KidsColors`

Konstanten für Primär/Sekundär/Akzent, Feedback‑Farben, Neutral‑Farben, Gamification‑Farben, Dark‑Palette.

Nützliche Helper:

- `randomAvatarColor()`
- `avatarColorAt(int index)`
- `createMaterialColor(Color color)`

### `KidsTypography`

Vordefinierte `TextStyle`s + `textTheme` für `ThemeData`.

### `KidsSpacing`

Einheitliche Spacing‑Konstanten, BorderRadius‑Presets, Größen (Icons, Avatare, Buttons), `EdgeInsets`‑Presets und `SizedBox`‑Gaps.

### `KidsGradients` / `KidsShadows`

Gradients (primary/secondary/accent/special) + Shadows (`sm`, `md`, `lg`, `xl`, colored shadows).

### Beispiel (Theme‑Nutzung)

```dart
Container(
  padding: KidsSpacing.paddingMd,
  decoration: const BoxDecoration(
    gradient: KidsGradients.primary,
    boxShadow: KidsShadows.md,
    borderRadius: KidsSpacing.borderRadiusLg,
  ),
  child: Text('Hallo', style: KidsTypography.headlineMedium),
);
```

---

## Widgets

### `KidButton` / `KidIconButton`

- Varianten: `KidButtonVariant` (`primary`, `secondary`, `accent`, `success`, `outline`, `ghost`)
- Größen: `KidButtonSize` (`small`, `medium`, `large`, `extraLarge`)
- Features: Loading‑State, Disabled‑State, Full‑Width, Press‑Animation.

Beispiel:

```dart
KidButton(
  label: 'Start',
  icon: Icons.play_arrow,
  variant: KidButtonVariant.primary,
  size: KidButtonSize.large,
  onPressed: () {},
);
```

### `KidCard` / `KidGameCard` / `KidStatCard`

- Varianten: `KidCardVariant` (`elevated`, `outlined`, `filled`, `gradient`)
- Optional: `onTap`, `onLongPress`, `isSelected`, `isDisabled`, `animateOnTap`.

Beispiel:

```dart
KidCard(
  variant: KidCardVariant.outlined,
  onTap: () {},
  child: const Text('Inhalt'),
);
```

### `KidAvatar` / `KidAvatarGroup`

- `KidAvatar`: Bild‑URL, Initialen‑Fallback, Icon‑Fallback, Badge/Online‑Status.
- `KidAvatarGroup`: gestapelte Avatare aus `KidAvatarData`.

Beispiel:

```dart
KidAvatar(
  name: 'Max Mustermann',
  size: KidAvatarSize.lg,
  isOnline: true,
);
```

### `LiankoAvatar`

Animierter, einfacher Charakter‑Avatar über `LiankoEmotion`.

Beispiel:

```dart
const LiankoAvatar(
  emotion: LiankoEmotion.thinking,
  isAnimated: true,
);
```

---

## Offline Sync (`OfflineSyncService`)

Queue‑basierter Offline‑Sync (Actions werden lokal gespeichert und später synchronisiert) + einfacher JSON‑Cache.

### Wichtige APIs

- `initialize()`
- `setOnlineStatus(bool online)` (triggert Sync beim Wechsel offline→online)
- `queueAction(SyncAction action)`
- `syncPendingActions()`
- `onSyncAction`: Callback, den die App setzen muss: `Future<bool> Function(SyncAction action)`

### Cache‑APIs

- `cacheData(key, data)`
- `getCachedData(key)` → `CacheEntry?`
- `isCacheValid(key, maxAge: …)`
- `getWithCache(key, fetchFn, maxAge: …)`
- `clearCache()`

### Riverpod Provider

- `offlineSyncServiceProvider`
- `isOnlineProvider`
- `pendingActionsCountProvider`

### Beispiel: Action queue’n und in App ausführen

```dart
final sync = OfflineSyncService();
await sync.initialize();

sync.onSyncAction = (action) async {
  // Hier: Firestore/REST Update ausführen
  // return true bei Erfolg, sonst false
  return true;
};

await sync.queueAction(
  SyncAction(
    type: SyncAction.update,
    collection: 'progress',
    documentId: 'abc',
    data: {'score': 10},
  ),
);
```

---

## Error Handling (`ErrorHandlingService`)

Zentraler Service für:

- Globales Flutter/Platform Error‑Hooking (`initialize()`)
- Normalisierung in kinderfreundliche Messages
- UI‑Helper: Dialog & Snackbar
- Fehler‑Stream + Log

### Wichtige APIs

- Singleton: `ErrorHandlingService()`
- `initialize()`
- `errorStream` (Stream von `AppError`)
- `errorLog` (read‑only Liste)
- `handleNetworkError(error, context: …)`
- `handleFirebaseError(error, context: …)`
- `handleError(error, context: …, type: …, severity: …)`
- `showErrorDialog(context, error)` / `showErrorSnackbar(context, error)`
- `clearErrorLog()`

### Riverpod

- `errorHandlingServiceProvider`

### Future‑Extension

`Future<T>.handleErrors(errorService: …)` loggt Fehler und gibt `T?` zurück.

Beispiel:

```dart
final errors = ErrorHandlingService();
errors.initialize();

final result = await Future.value(123).handleErrors(errorService: errors);
```

---

## Notifications (`PushNotificationService`)

Kombiniert Firebase Cloud Messaging + lokale Notifications.

### Kern-Modelle

- `NotificationType` (Enum)
- `KidsNotification` (Map/RemoteMessage‑Konvertierung)

### `PushNotificationService`

- Singleton: `PushNotificationService.instance`
- `initialize()`
- Callbacks:
  - `onNotificationReceived(KidsNotification)`
  - `onNotificationTapped(KidsNotification)`
  - `onTokenRefresh(String token)`
- `showNotification({title, body, type, data})`
- `scheduleNotification({title, body, scheduledTime, type, data})`
- Topic‑APIs: `subscribeToTopic(topic)`, `unsubscribeFromTopic(topic)`
- Cleanup: `clearAllNotifications()`, `clearNotification(id)`

### Presets

- `KidsReminders.scheduleDailyReminder(hour, minute, customMessage)`
- `KidsReminders.showRewardNotification(...)`
- `KidsReminders.showNewContentNotification(...)`
- `LiankoNotifications.*` (hörtraining‑spezifisch)
- `AlankoNotifications.*` (sprachentwicklung‑spezifisch)

### Beispiel

```dart
final push = PushNotificationService.instance;
final ok = await push.initialize();
if (!ok) {
  // Permissions abgelehnt
}

push.onNotificationTapped = (n) {
  // Deep‑Link / Navigation
};

await push.showNotification(
  title: 'Zeit zum Lernen',
  body: 'Lass uns ein Spiel starten!',
  type: NotificationType.reminder,
);
```

---

## Utils (`GameUtils`)

Helper für Schwierigkeits‑ und Score‑Darstellung.

- `getDifficultyColor(double difficulty)`
- `getDifficultyText(double difficulty)`
- `getDifficultyInfo(double difficulty)` → Record `({Color color, String text})`
- `getAccuracyColor(int accuracy)`
- `calculateAccuracy(int correct, int total)`

Beispiel:

```dart
final acc = GameUtils.calculateAccuracy(7, 10);
final color = GameUtils.getAccuracyColor(acc);
```
