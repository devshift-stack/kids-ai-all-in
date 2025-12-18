import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/language_provider.dart';
import '../../providers/premium_tts_provider.dart';
import '../../services/premium_tts_service.dart';

/// Dashboard Screen mit Einstellungen und Monitoring
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(languageProvider);
    final ttsService = ref.watch(premiumTtsServiceProvider);
    final languageNotifier = ref.read(languageProvider.notifier);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Einstellungen & Dashboard'),
        backgroundColor: AppTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sprachauswahl
            _buildLanguageSection(context, currentLanguage, languageNotifier),
            const SizedBox(height: AppTheme.spacingLg),
            
            // TTS Einstellungen
            _buildTtsSection(context, ttsService),
            const SizedBox(height: AppTheme.spacingLg),
            
            // Monitoring
            _buildMonitoringSection(context),
            const SizedBox(height: AppTheme.spacingLg),
            
            // Info
            _buildInfoSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(
    BuildContext context,
    SupportedLanguage currentLanguage,
    LanguageNotifier notifier,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                const Text(
                  'Sprache',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            ...SupportedLanguage.values.map((language) {
              final isSelected = language == currentLanguage;
              return RadioListTile<SupportedLanguage>(
                title: Text(_getLanguageName(language)),
                subtitle: Text(_getLanguageSubtitle(language)),
                value: language,
                groupValue: currentLanguage,
                onChanged: (value) {
                  if (value != null) {
                    notifier.setLanguage(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sprache geändert zu ${_getLanguageName(value)}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                activeColor: AppTheme.primaryColor,
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTtsSection(BuildContext context, PremiumTtsService ttsService) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.volume_up, color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                const Text(
                  'Text-to-Speech',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ttsService.isPremium
                            ? 'Premium TTS aktiv'
                            : 'Standard TTS aktiv',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ttsService.isPremium
                            ? 'Google Cloud TTS Neural2 (menschliche Stimme)'
                            : 'Flutter TTS (Fallback)',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ttsService.isPremium
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    ttsService.isPremium ? 'Premium' : 'Standard',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (!ttsService.isPremium) ...[
              const SizedBox(height: AppTheme.spacingMd),
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                decoration: BoxDecoration(
                  color: AppTheme.warningColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppTheme.warningColor),
                    const SizedBox(width: AppTheme.spacingSm),
                    Expanded(
                      child: Text(
                        'Für Premium-Stimmen setzen Sie GOOGLE_CLOUD_TTS_API_KEY',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMonitoringSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.analytics, color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                const Text(
                  'Monitoring',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            _buildStatItem('Aktive Sessions', '0', Icons.people),
            const SizedBox(height: AppTheme.spacingSm),
            _buildStatItem('Nachrichten heute', '0', Icons.message),
            const SizedBox(height: AppTheme.spacingSm),
            _buildStatItem('Durchschnittliche Antwortzeit', '< 2s', Icons.speed),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.textSecondary),
        const SizedBox(width: AppTheme.spacingSm),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: AppTheme.primaryColor),
                const SizedBox(width: AppTheme.spacingSm),
                const Text(
                  'Informationen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMd),
            Text(
              'Unterstützte Sprachen: Deutsch, Bosnisch, Serbisch\n'
              'Premium TTS: Google Cloud Neural2 Voices\n'
              'KI-Modell: Gemini 1.5 Flash',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getLanguageName(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.german:
        return 'Deutsch';
      case SupportedLanguage.bosnian:
        return 'Bosanski';
      case SupportedLanguage.serbian:
        return 'Srpski';
    }
  }

  String _getLanguageSubtitle(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.german:
        return 'German';
      case SupportedLanguage.bosnian:
        return 'Bosnian';
      case SupportedLanguage.serbian:
        return 'Serbian';
    }
  }
}

