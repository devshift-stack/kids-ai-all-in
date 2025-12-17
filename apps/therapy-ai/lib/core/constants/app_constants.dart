/// App-wide constants for Therapy AI
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Therapy AI';
  static const String appVersion = '1.0.0';

  // Audio Settings
  static const int audioSampleRate = 16000; // Whisper recommended sample rate
  static const int audioChannels = 1; // Mono
  static const int audioBitDepth = 16;

  // Recording Settings
  static const Duration maxRecordingDuration = Duration(seconds: 30);
  static const Duration minRecordingDuration = Duration(seconds: 1);

  // Whisper Model Settings
  static const String whisperModelSize = 'base'; // base, small, medium, large
  static const String whisperModelPath = 'assets/models/whisper-base.bin';

  // ElevenLabs Settings
  static const String elevenLabsApiBaseUrl = 'https://api.elevenlabs.io/v1';
  static const int elevenLabsMaxVoiceCloneDuration = 300; // 5 minutes in seconds
  static const int elevenLabsMinVoiceCloneDuration = 60; // 1 minute in seconds

  // Exercise Settings
  static const int maxExercisesPerSession = 10;
  static const int minExercisesPerSession = 3;
  static const Duration exerciseCooldown = Duration(seconds: 2);

  // Progress Tracking
  static const int progressHistoryDays = 30;
  static const double minPronunciationScore = 0.0;
  static const double maxPronunciationScore = 100.0;

  // Hearing Loss Thresholds
  static const double mildHearingLoss = 25.0; // dB
  static const double moderateHearingLoss = 40.0; // dB
  static const double severeHearingLoss = 70.0; // dB
  static const double profoundHearingLoss = 90.0; // dB

  // Supported Languages
  static const List<String> supportedLanguages = [
    'bs', // Bosnian
    'en', // English
    'hr', // Croatian
    'sr', // Serbian
    'de', // German
    'tr', // Turkish
  ];

  // Default Language
  static const String defaultLanguage = 'bs';
}

