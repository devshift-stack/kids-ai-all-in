import 'package:flutter/foundation.dart';
import 'env_config.dart';

/// App configuration
class AppConfig {
  AppConfig._();

  // Environment
  static const bool isProduction = kReleaseMode;
  static const bool isDevelopment = kDebugMode;

  // API Keys (loaded from EnvConfig)
  static String? get elevenLabsApiKey => EnvConfig.elevenLabsApiKey;
  static String get elevenLabsApiBaseUrl => EnvConfig.elevenLabsApiBaseUrl;
  
  static String? get openAiApiKey => EnvConfig.openAiApiKey;
  static String get openAiApiBaseUrl => EnvConfig.openAiApiBaseUrl;

  // Feature Flags
  static const bool enableWhisperOnDevice = true;
  static const bool enableVoiceCloning = true;
  static const bool enableProgressTracking = true;
  static const bool enableOfflineMode = true;

  // Debug Settings
  static const bool enableDebugLogging = isDevelopment;
  static const bool enablePerformanceMonitoring = isProduction;
}

