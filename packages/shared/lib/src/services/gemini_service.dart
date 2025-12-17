import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Gender enum for profile personalization
enum ProfileGender { boy, girl, other }

/// User profile data for AI personalization
class GeminiUserProfile {
  final String id;
  final String name;
  final int age;
  final ProfileGender gender;

  const GeminiUserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
  });
}

/// Shared Gemini AI Service for Kids AI apps
/// 
/// Provides child-friendly AI interactions using Google's Gemini API.
/// API key must be provided via environment variable:
/// ```bash
/// flutter run --dart-define=GEMINI_API_KEY=your_key_here
/// ```
class GeminiService {
  // API Key über --dart-define=GEMINI_API_KEY=xxx setzen
  // Für Entwicklung: flutter run --dart-define=GEMINI_API_KEY=your_key_here
  static const String _envApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  final String _apiKey;
  GenerativeModel? _model;
  ChatSession? _chat;
  GeminiUserProfile? _currentProfile;

  /// Creates a GeminiService instance.
  /// 
  /// [apiKey] - Optional API key. If not provided, uses environment variable.
  GeminiService({String? apiKey}) : _apiKey = apiKey ?? _envApiKey {
    _initModel();
  }

  /// Whether the service is properly configured with an API key
  bool get isConfigured => _apiKey.isNotEmpty;

  void _initModel() {
    if (_apiKey.isEmpty) {
      if (kDebugMode) {
        print('⚠️ Gemini API Key nicht gesetzt! Nutze: flutter run --dart-define=GEMINI_API_KEY=your_key');
      }
      return;
    }

    _model = GenerativeModel(
      model: 'gemini-1.5-flash', // Free tier model
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.7,
        topK: 40,
        topP: 0.95,
        maxOutputTokens: 256,
      ),
      systemInstruction: Content.text(_getSystemPrompt()),
    );
  }

  String _getSystemPrompt() {
    final profile = _currentProfile;
    final age = profile?.age ?? 6;
    final name = profile?.name ?? 'Kind';
    final isBoy = profile?.gender == ProfileGender.boy;
    final gender = isBoy ? 'Junge' : 'Mädchen';

    return '''
Du bist Alanko, ein freundlicher und lustiger KI-Assistent für Kinder.
Du sprichst mit $name, einem $age Jahre alten $gender.

WICHTIGE REGELN:
- Antworte IMMER auf Bosnisch/Kroatisch/Serbisch (Latinica)
- Benutze einfache, kurze Sätze die ein $age-jähriges Kind versteht
- Sei freundlich, geduldig und ermutigend
- Mache Lernen spielerisch und spaßig
- Antworte in maximal 2-3 kurzen Sätzen
- Benutze keine komplizierten Wörter
- Sei wie ein freundlicher großer Bruder/Schwester
- Wenn du etwas nicht weißt, sag es ehrlich
- Vermeide gruselige, gewalttätige oder unangemessene Inhalte
- Erkläre Dinge mit Beispielen die Kinder kennen (Tiere, Spielzeug, Essen)

THEMEN die $name mag:
${isBoy ? '- Autos, Dinosaurier, Weltraum, Roboter, Superhelden, Sport' : '- Prinzessinnen, Einhörner, Tiere, Natur, Kunst, Feen'}

Beispiel für gute Antworten:
- "Super Frage! Weißt du, Dinosaurier lebten vor ganz, ganz langer Zeit."
- "Das ist toll! Du bist sehr schlau."
- "Lass uns ein Spiel spielen! Rate mal..."
''';
  }

  /// Sets the current user profile for personalized responses
  void setProfile(GeminiUserProfile profile) {
    _currentProfile = profile;
    _initModel();
    _chat = null; // Reset chat for new profile
  }

  /// Asks Gemini a question and returns a child-friendly response
  Future<String> ask(String question) async {
    if (_model == null) {
      return 'Alanko ist gerade müde. Frag mich später nochmal!';
    }

    try {
      _chat ??= _model!.startChat();

      final response = await _chat!.sendMessage(Content.text(question));
      return response.text ?? 'Hmm, das weiß ich nicht. Frag mich etwas anderes!';
    } catch (e) {
      if (kDebugMode) {
        print('Gemini Error: $e');
      }
      if (e.toString().contains('quota')) {
        return 'Alanko braucht eine kleine Pause. Wir haben heute schon viel geredet!';
      }
      return 'Ups, da ist etwas schief gegangen. Versuch es nochmal!';
    }
  }

  /// Generates a short story for children
  Future<String> generateStory({
    required String theme,
    required int age,
  }) async {
    if (_model == null) {
      return 'Alanko kann gerade keine Geschichte erzählen.';
    }

    final prompt = '''
Erzähle eine kurze, lustige Geschichte für ein $age-jähriges Kind.
Thema: $theme
Die Geschichte soll:
- Maximal 100 Wörter haben
- Ein Happy End haben
- Einfache Wörter benutzen
- Spannend und lustig sein
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Es war einmal... Oh, ich habe den Faden verloren!';
    } catch (e) {
      if (kDebugMode) {
        print('Gemini Story Error: $e');
      }
      return 'Alanko ist gerade müde. Die Geschichte erzähle ich dir morgen!';
    }
  }

  /// Generates a quiz question for children
  Future<String> generateQuiz({
    required String topic,
    required int age,
  }) async {
    if (_model == null) {
      return 'Quiz nicht verfügbar.';
    }

    final prompt = '''
Erstelle eine einfache Quiz-Frage für ein $age-jähriges Kind.
Thema: $topic
Format:
Frage: [einfache Frage]
A) [Antwort 1]
B) [Antwort 2]
C) [Antwort 3]
Richtig: [A/B/C]
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Quiz konnte nicht erstellt werden.';
    } catch (e) {
      if (kDebugMode) {
        print('Gemini Quiz Error: $e');
      }
      return 'Quiz nicht verfügbar.';
    }
  }

  /// Generates an age-appropriate explanation
  Future<String> explain({
    required String topic,
    required int age,
  }) async {
    if (_model == null) {
      return 'Erklärung nicht verfügbar.';
    }

    final prompt = '''
Erkläre "$topic" für ein $age-jähriges Kind.
- Benutze einfache Wörter
- Maximal 3 kurze Sätze
- Benutze Beispiele die Kinder kennen
''';

    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      return response.text ?? 'Das kann ich gerade nicht erklären.';
    } catch (e) {
      if (kDebugMode) {
        print('Gemini Explain Error: $e');
      }
      return 'Das kann ich gerade nicht erklären.';
    }
  }

  /// Resets the current chat session
  void resetChat() {
    _chat = null;
  }
}
