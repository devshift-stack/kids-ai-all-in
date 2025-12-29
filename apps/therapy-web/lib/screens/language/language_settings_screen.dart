import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Language Settings Screen
class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  String _primaryLanguage = 'bs';
  final List<String> _secondaryLanguages = [];
  final List<String> _availableLanguages = ['bs', 'en', 'hr', 'sr', 'de', 'tr'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sprach-Einstellungen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sprach-Konfiguration',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 32),

                // Primärsprache
                _buildPrimaryLanguageSection(),

                const SizedBox(height: 32),

                // Sekundärsprachen
                _buildSecondaryLanguagesSection(),

                const SizedBox(height: 32),

                // Speichern-Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text(
                      'Einstellungen speichern',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryLanguageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Primärsprache',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _primaryLanguage,
              decoration: const InputDecoration(
                labelText: 'Wähle die Primärsprache',
                border: OutlineInputBorder(),
              ),
              items: _availableLanguages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(_getLanguageName(lang)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _primaryLanguage = value ?? 'bs');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryLanguagesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sekundärsprachen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ..._availableLanguages
                .where((lang) => lang != _primaryLanguage)
                .map((lang) => CheckboxListTile(
                      title: Text(_getLanguageName(lang)),
                      value: _secondaryLanguages.contains(lang),
                      onChanged: (value) {
                        setState(() {
                          if (value == true) {
                            _secondaryLanguages.add(lang);
                          } else {
                            _secondaryLanguages.remove(lang);
                          }
                        });
                      },
                    )),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    const names = {
      'bs': 'Bosnisch',
      'en': 'Englisch',
      'hr': 'Kroatisch',
      'sr': 'Serbisch',
      'de': 'Deutsch',
      'tr': 'Türkisch',
    };
    return names[code] ?? code;
  }

  void _saveSettings() {
    // Speichere Einstellungen in Firebase (Placeholder - wird später implementiert)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Einstellungen wurden gespeichert'),
      ),
    );
  }
}

