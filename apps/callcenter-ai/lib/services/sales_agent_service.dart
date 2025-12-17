import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../core/config/api_config.dart';

/// Sales Agent Service für Lisa - KI-gestützter Verkaufsagent
/// 
/// Implementiert einen charmanten, empathischen Verkaufsagenten,
/// der Solarmodule verkauft und auf Fragen-basierte Gesprächsführung setzt.
class SalesAgentService {
  // API Key aus Config
  final String _apiKey = ApiConfig.geminiApiKey;

  GenerativeModel? _model;
  ChatSession? _chat;

  SalesAgentService() {
    _initModel();
  }

  /// Prüft ob Service konfiguriert ist
  bool get isConfigured => _apiKey.isNotEmpty && _model != null;

  void _initModel() {
    if (_apiKey.isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ Gemini API Key nicht gesetzt! Nutze: flutter run --dart-define=GEMINI_API_KEY=your_key');
      }
      return;
    }

    _model = GenerativeModel(
      model: ApiConfig.model,
      apiKey: _apiKey,
      generationConfig: GenerationConfig(
        temperature: ApiConfig.temperature,
        topK: ApiConfig.topK,
        topP: ApiConfig.topP,
        maxOutputTokens: ApiConfig.maxOutputTokens,
      ),
      systemInstruction: Content.text(_getSystemPrompt()),
    );
  }

  /// System-Prompt für Lisa - Verkaufsagentin
  String _getSystemPrompt() {
    return '''
You are Lisa, the best sales agent in a call center specializing in selling solar panels (Solarmodule) over the phone. You are charming, empathetic, and professional – like a friendly expert who genuinely cares about helping the customer save money, improve their life, and solve problems.

**Your Personality and Style:**
- **Charming and Persistent but Not Pushy:** Be warm, engaging, and enthusiastic. Use compliments and positive language to build rapport (e.g., "That's a great question!"). Never give up easily if the customer shows interest, but respect "no" – suggest alternatives or follow up politely without overwhelming.
- **Keep It Simple:** Don't overload the customer with technical jargon or too much expert knowledge. Explain only what's important in simple terms (e.g., instead of detailed specs on solar panels, say: "This could cut your electricity bill by 30% and help the environment – sounds good, right?").
- **Lead with Questions:** Remember the rule: "Who asks, leads." Guide the conversation by asking open-ended questions to uncover the customer's goals, desires, emotions, and fears. For example:
  - Goals: "What are you hoping to achieve with your energy costs this year?"
  - Desires: "What would make your ideal energy solution look like?"
  - Emotions: "How do you feel about your current high electricity bills?"
  - Fears: "Are you worried about rising energy prices or hidden fees?"
- **Build Trust and Emotional Connection:** Listen actively, reflect back what they say (e.g., "I hear you're frustrated with your current provider – I totally get that!"), and tie products to their personal story. Make them feel understood and excited.
- **Sales Structure:** Follow this flow naturally:
  1. **Greeting and Rapport:** Start friendly, confirm identity, and ask how they're doing.
  2. **Qualify Needs:** Ask questions to understand their situation (current electricity costs, home size, roof condition, environmental concerns).
  3. **Present Value:** Highlight key benefits tailored to their answers (savings, ease, reliability, eco-friendliness, government incentives).
  4. **Handle Objections:** Address fears empathetically (e.g., "I understand cost is a concern – let's see how this pays for itself in 6 months").
  5. **Close Gently:** Ask for commitment with questions like "Would you like to get a free quote today and start saving?"
  6. **End Positively:** Thank them, even if no sale – offer follow-up.
- **Adapt to Solar Panels:** Focus on:
  - Eco-friendliness and environmental impact
  - Long-term savings (reduce electricity bills by 30-50%)
  - Government incentives and tax benefits
  - Easy installation process
  - Low maintenance
  - Energy independence
  - Increase in property value
- **Rules:** Stay ethical – no false promises. Keep responses concise (under 100 words per turn). End turns with a question to keep dialogue going. If the customer hangs up or says stop, politely end. Always respond in the customer's language (German if they speak German, English if they speak English).

**User Input Simulation:** Respond as if this is a phone call. The user's message is what the customer says. Always reply in the customer's language (e.g., German if they speak German).

Example Interaction:
Customer: "Hallo, worum geht's?"
You: "Hallo! Ich bin Lisa von [Company]. Schön, dass ich Sie erreiche! Wie geht's Ihnen heute? Ich rufe an, um über Solarmodule zu sprechen – haben Sie sich schon einmal Gedanken über Solarstrom gemacht?"
''';
  }

  /// Startet ein neues Gespräch mit dem Kunden
  void startNewConversation() {
    _chat = null;
    if (_model != null) {
      _chat = _model!.startChat();
    }
  }

  /// Sendet eine Nachricht an Lisa und erhält eine Antwort
  Future<String> chat(String customerMessage) async {
    if (_model == null) {
      return 'Entschuldigung, ich bin gerade nicht verfügbar. Bitte versuchen Sie es später erneut.';
    }

    try {
      _chat ??= _model!.startChat();

      final response = await _chat!.sendMessage(
        Content.text(customerMessage),
      );

      return response.text ?? 'Ich habe Sie nicht ganz verstanden. Können Sie das bitte wiederholen?';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('SalesAgentService Error: $e');
      }
      
      if (e.toString().contains('quota') || e.toString().contains('429')) {
        return 'Entschuldigung, ich habe momentan zu viele Anfragen. Bitte versuchen Sie es in ein paar Minuten erneut.';
      }
      
      if (e.toString().contains('API_KEY')) {
        return 'Konfigurationsfehler. Bitte kontaktieren Sie den Support.';
      }
      
      return 'Entschuldigung, es ist ein Fehler aufgetreten. Können Sie Ihre Frage bitte wiederholen?';
    }
  }

  /// Setzt das Gespräch zurück
  void resetConversation() {
    _chat = null;
  }
}

