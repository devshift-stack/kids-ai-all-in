import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Phoneme Settings Screen
class PhonemeSettingsScreen extends StatefulWidget {
  const PhonemeSettingsScreen({super.key});

  @override
  State<PhonemeSettingsScreen> createState() => _PhonemeSettingsScreenState();
}

class _PhonemeSettingsScreenState extends State<PhonemeSettingsScreen> {
  final Map<String, bool> _problemPhonemes = {};
  final Map<String, int> _phonemePriorities = {};

  final List<String> _commonPhonemes = [
    'p', 'b', 't', 'd', 'k', 'g', 'f', 'v', 's', 'z',
    'ʃ', 'ʒ', 'tʃ', 'dʒ', 'm', 'n', 'ŋ', 'l', 'r', 'j', 'w',
    'a', 'e', 'i', 'o', 'u', 'ə', 'ɛ', 'ɔ', 'ɪ', 'ʊ',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phonem-Einstellungen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phonem-Konfiguration',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Markiere Problem-Phoneme und setze Prioritäten für die Therapie.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),

                // Phonem-Grid
                _buildPhonemeGrid(),

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

  Widget _buildPhonemeGrid() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _commonPhonemes.map((phoneme) {
            final isProblem = _problemPhonemes[phoneme] ?? false;
            final priority = _phonemePriorities[phoneme] ?? 0;

            return Card(
              color: isProblem ? Colors.red.shade50 : null,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _problemPhonemes[phoneme] = !isProblem;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        phoneme,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isProblem ? Colors.red : null,
                        ),
                      ),
                      if (isProblem) ...[
                        const SizedBox(height: 8),
                        DropdownButton<int>(
                          value: priority,
                          items: [1, 2, 3, 4, 5].map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text('Priorität $p'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _phonemePriorities[phoneme] = value ?? 1;
                            });
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Speichere Einstellungen in Firebase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Phonem-Einstellungen wurden gespeichert'),
      ),
    );
  }
}

