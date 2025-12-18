import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Zentrale API-Konfiguration für Alanko
/// 
/// Verwaltet API-Keys aus verschiedenen Quellen:
/// 1. Compile-Time (--dart-define)
/// 2. Runtime (SharedPreferences für Admin/Debug)
/// 3. Remote Config (Firebase Remote Config)
class ApiConfig {
  // Singleton Pattern
  static final ApiConfig _instance = ApiConfig._internal();
  factory ApiConfig() => _instance;
  ApiConfig._internal();

  // ═══════════════════════════════════════════════════════════════
  // API Keys
  // ═══════════════════════════════════════════════════════════════

  /// Gemini API Key
  /// 
  /// Priorität:
  /// 1. Runtime Override (aus SharedPreferences oder Remote Config)
  /// 2. Compile-Time (--dart-define=GEMINI_API_KEY=xxx)
  /// 
  /// Beispiel:
  /// ```bash
  /// flutter run --dart-define=GEMINI_API_KEY=AIzaSy...
  /// ```
  static const String _compileTimeGeminiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  String? _runtimeGeminiKey;

  /// Aktueller Gemini API Key
  String get geminiApiKey {
    // Runtime Override hat Priorität
    if (_runtimeGeminiKey != null && _runtimeGeminiKey!.isNotEmpty) {
      return _runtimeGeminiKey!;
    }
    // Fallback auf Compile-Time Key
    return _compileTimeGeminiKey;
  }

  /// Prüfe ob Gemini API Key gesetzt ist
  bool get hasGeminiKey => geminiApiKey.isNotEmpty;

  // ═══════════════════════════════════════════════════════════════
  // Runtime Configuration
  // ═══════════════════════════════════════════════════════════════

  /// Setze Gemini API Key zur Laufzeit
  /// 
  /// Nützlich für:
  /// - Admin/Debug Screens
  /// - Firebase Remote Config
  /// - Dynamische Key-Rotation
  void setGeminiKey(String key) {
    _runtimeGeminiKey = key;
    if (kDebugMode) {
      print('✓ Gemini API Key zur Laufzeit gesetzt');
    }
  }

  /// Lade Konfiguration aus SharedPreferences
  /// 
  /// Für Admin-Features: API-Key im Debug-Modus ändern
  Future<void> loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _runtimeGeminiKey = prefs.getString('api_gemini_key');
    
    if (kDebugMode && _runtimeGeminiKey != null) {
      print('✓ API-Key aus SharedPreferences geladen');
    }
  }

  /// Speichere Konfiguration in SharedPreferences
  /// 
  /// Nur für Debug/Admin-Zwecke!
  Future<void> saveToPreferences() async {
    if (_runtimeGeminiKey == null) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('api_gemini_key', _runtimeGeminiKey!);
    
    if (kDebugMode) {
      print('✓ API-Key in SharedPreferences gespeichert');
    }
  }

  /// Lösche Runtime-Konfiguration
  Future<void> clearRuntimeConfig() async {
    _runtimeGeminiKey = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('api_gemini_key');
    
    if (kDebugMode) {
      print('✓ Runtime-Konfiguration gelöscht');
    }
  }

  // ═══════════════════════════════════════════════════════════════
  // Debug & Diagnostics
  // ═══════════════════════════════════════════════════════════════

  /// Debug-Info über aktuelle Konfiguration
  void printDebugInfo() {
    if (!kDebugMode) return;

    print('═══════════════════════════════════════════════════════');
    print('API Configuration Status:');
    print('───────────────────────────────────────────────────────');
    print('Gemini API Key:');
    print('  • Compile-Time: ${_compileTimeGeminiKey.isNotEmpty ? "✓ Gesetzt" : "✗ Nicht gesetzt"}');
    print('  • Runtime:      ${_runtimeGeminiKey != null ? "✓ Override aktiv" : "✗ Kein Override"}');
    print('  • Aktuell:      ${hasGeminiKey ? "✓ Verfügbar" : "✗ FEHLT!"}');
    print('═══════════════════════════════════════════════════════');
  }

  /// API-Key Status für UI
  String getStatusMessage() {
    if (!hasGeminiKey) {
      return '❌ Gemini API-Key fehlt';
    }
    
    if (_runtimeGeminiKey != null) {
      return '✓ API-Key aktiv (Runtime Override)';
    }
    
    return '✓ API-Key aktiv (Compile-Time)';
  }

  // ═══════════════════════════════════════════════════════════════
  // Future: Firebase Remote Config Integration
  // ═══════════════════════════════════════════════════════════════

  /// Lade Konfiguration aus Firebase Remote Config (Placeholder - wird später implementiert)
  /// 
  /// Ermöglicht:
  /// - Keys ohne App-Update ändern
  /// - Feature Flags
  /// - A/B Testing
  /// - Notfall-Deaktivierung
  /*
  Future<void> loadFromRemoteConfig() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.fetchAndActivate();
    
    final remoteKey = remoteConfig.getString('gemini_api_key');
    if (remoteKey.isNotEmpty) {
      _runtimeGeminiKey = remoteKey;
      if (kDebugMode) {
        print('✓ API-Key aus Firebase Remote Config geladen');
      }
    }
  }
  */
}

/// Globale Instanz für einfachen Zugriff
final apiConfig = ApiConfig();
