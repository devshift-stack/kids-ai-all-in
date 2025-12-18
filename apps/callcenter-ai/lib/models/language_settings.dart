import '../services/premium_tts_service.dart';

/// Sprach-Einstellungen für den Callcenter-Agenten
class LanguageSettings {
  final SupportedLanguage language;
  final String greeting;
  final String agentName;

  const LanguageSettings({
    required this.language,
    required this.greeting,
    required this.agentName,
  });

  static const Map<SupportedLanguage, LanguageSettings> settings = {
    SupportedLanguage.german: LanguageSettings(
      language: SupportedLanguage.german,
      greeting: 'Hallo! Ich bin Lisa, Ihre Verkaufsberaterin. Schön, dass ich Sie erreiche! Wie geht es Ihnen heute? Ich rufe an, um über Solarmodule zu sprechen – haben Sie sich schon einmal Gedanken über Solarstrom gemacht?',
      agentName: 'Lisa',
    ),
    SupportedLanguage.bosnian: LanguageSettings(
      language: SupportedLanguage.bosnian,
      greeting: 'Zdravo! Ja sam Lisa, vaša prodajna savjetnica. Drago mi je što vas mogu kontaktirati! Kako ste danas? Zovem vas da razgovorimo o solarnim panelima – da li ste ikada razmišljali o solarnoj energiji?',
      agentName: 'Lisa',
    ),
    SupportedLanguage.serbian: LanguageSettings(
      language: SupportedLanguage.serbian,
      greeting: 'Zdravo! Ja sam Lisa, vaša prodajna savetnica. Drago mi je što vas mogu kontaktirati! Kako ste danas? Zovem vas da razgovorimo o solarnim panelima – da li ste ikada razmišljali o solarnoj energiji?',
      agentName: 'Lisa',
    ),
  };

  static LanguageSettings getSettings(SupportedLanguage language) {
    return settings[language] ?? settings[SupportedLanguage.german]!;
  }
}

