/// API Configuration for Callcenter AI
class ApiConfig {
  ApiConfig._();

  // API Key über --dart-define=GEMINI_API_KEY=xxx setzen
  // Für Entwicklung: flutter run --dart-define=GEMINI_API_KEY=your_key_here
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  // Modell-Konfiguration
  static const String model = 'gemini-1.5-flash'; // Free tier model
  
  // Generation-Parameter für natürlichere Verkaufsgespräche
  static const double temperature = 0.8; // Höher für natürlichere Gespräche
  static const int topK = 40;
  static const double topP = 0.95;
  static const int maxOutputTokens = 512; // Längere Antworten für Verkaufsgespräche

  /// Prüft ob API Key gesetzt ist
  static bool get isConfigured => geminiApiKey.isNotEmpty;
}

