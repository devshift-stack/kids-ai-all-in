import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/premium_tts_service.dart';
import '../models/language_settings.dart';

/// Provider für Sprach-Einstellungen
final languageProvider = StateNotifierProvider<LanguageNotifier, SupportedLanguage>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<SupportedLanguage> {
  LanguageNotifier() : super(SupportedLanguage.german) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('selected_language') ?? 'german';
      state = SupportedLanguage.values.firstWhere(
        (lang) => lang.name == languageCode,
        orElse: () => SupportedLanguage.german,
      );
    } catch (e) {
      state = SupportedLanguage.german;
    }
  }

  Future<void> setLanguage(SupportedLanguage language) async {
    state = language;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('selected_language', language.name);
    } catch (e) {
      // Ignore
    }
  }

  LanguageSettings get settings => LanguageSettings.getSettings(state);
}

