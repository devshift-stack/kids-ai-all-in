import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../core/design_system.dart';
import '../../core/routes/app_routes.dart';
import '../../providers/child_profile_provider.dart';
import '../../core/constants/app_constants.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(childProfileProvider);
    final profile = profileState.profile;

    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Einstellungen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(TherapyDesignSystem.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profil-Info
              if (profile != null) _buildProfileSection(profile),
              SizedBox(height: TherapyDesignSystem.spacingXXL),

              // Sprache
              _buildLanguageSection(profile),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // Audio-Einstellungen
              _buildAudioSettings(profile),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // App-Einstellungen
              _buildAppSettings(),
              SizedBox(height: TherapyDesignSystem.spacingXL),

              // Account
              _buildAccountSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection(profile) {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profil',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          Row(
            children: [
              Container(
                width: TherapyDesignSystem.touchTargetPrimary,
                height: TherapyDesignSystem.touchTargetPrimary,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: KidsGradients.primaryGradient,
                ),
                child: Center(
                  child: Text(
                    profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '?',
                    style: TherapyDesignSystem.h2Style.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(width: TherapyDesignSystem.spacingLG),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: TherapyDesignSystem.bodyLargeStyle.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: TherapyDesignSystem.spacingSM),
                    Text(
                      '${profile.age} Jahre',
                      style: TherapyDesignSystem.bodyMediumStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection(profile) {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sprache',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          Wrap(
            spacing: TherapyDesignSystem.spacingMD,
            runSpacing: TherapyDesignSystem.spacingMD,
            children: AppConstants.supportedLanguages.map((lang) {
              final isSelected = profile?.language == lang;
              return ChoiceChip(
                label: Text(_getLanguageName(lang)),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected && profile != null) {
                    ref.read(childProfileProvider.notifier).saveProfile(
                          profile.copyWith(language: lang),
                        );
                  }
                },
                selectedColor: TherapyDesignSystem.statusActive,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : KidsColors.textPrimary,
                  fontSize: 20,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: TherapyDesignSystem.spacingLG,
                  vertical: TherapyDesignSystem.spacingMD,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioSettings(profile) {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Audio-Einstellungen',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          
          // Preferred Volume
          if (profile != null) ...[
            Text(
              'Lautstärke: ${(profile.preferredVolume * 100).toInt()}%',
              style: TherapyDesignSystem.bodyLargeStyle,
            ),
            SizedBox(height: TherapyDesignSystem.spacingMD),
            Slider(
              value: profile.preferredVolume,
              min: 0.5,
              max: 1.0,
              divisions: 10,
              label: '${(profile.preferredVolume * 100).toInt()}%',
              onChanged: (value) {
                ref.read(childProfileProvider.notifier).saveProfile(
                      profile.copyWith(preferredVolume: value),
                    );
              },
              activeColor: TherapyDesignSystem.statusActive,
            ),
            SizedBox(height: TherapyDesignSystem.spacingXL),
          ],

          // Speech Rate
          if (profile != null) ...[
            Text(
              'Sprechgeschwindigkeit: ${(profile.preferredSpeechRate * 100).toInt()}%',
              style: TherapyDesignSystem.bodyLargeStyle,
            ),
            SizedBox(height: TherapyDesignSystem.spacingMD),
            Slider(
              value: profile.preferredSpeechRate,
              min: 0.3,
              max: 0.8,
              divisions: 10,
              label: '${(profile.preferredSpeechRate * 100).toInt()}%',
              onChanged: (value) {
                ref.read(childProfileProvider.notifier).saveProfile(
                      profile.copyWith(preferredSpeechRate: value),
                    );
              },
              activeColor: TherapyDesignSystem.statusActive,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAppSettings() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'App-Einstellungen',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Benachrichtigungen',
            subtitle: 'Erinnerungen für Übungen',
            onTap: () {
              // TODO: Notification Settings
            },
          ),
          Divider(height: TherapyDesignSystem.spacingXL),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: 'Automatisch bei niedrigem Licht',
            onTap: () {
              // TODO: Dark Mode Toggle
            },
          ),
          Divider(height: TherapyDesignSystem.spacingXL),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Hilfe & Support',
            subtitle: 'FAQ und Kontakt',
            onTap: () {
              // TODO: Help Screen
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account',
            style: TherapyDesignSystem.h3Style,
          ),
          SizedBox(height: TherapyDesignSystem.spacingLG),
          
          _buildSettingsTile(
            icon: Icons.delete_outline,
            title: 'Profil löschen',
            subtitle: 'Alle Daten werden gelöscht',
            titleColor: TherapyDesignSystem.statusError,
            onTap: () {
              _showDeleteConfirmation();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return InkWell(
      onTap: () {
        TherapyDesignSystem.hapticSelection();
        onTap();
      },
      borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusMedium),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: TherapyDesignSystem.spacingMD),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(TherapyDesignSystem.spacingMD),
              decoration: BoxDecoration(
                color: TherapyDesignSystem.statusActiveBg,
                borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusMedium),
              ),
              child: Icon(
                icon,
                color: titleColor ?? TherapyDesignSystem.statusActive,
                size: TherapyDesignSystem.touchTargetIcon * 0.6,
              ),
            ),
            SizedBox(width: TherapyDesignSystem.spacingLG),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TherapyDesignSystem.bodyLargeStyle.copyWith(
                      color: titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: TherapyDesignSystem.spacingXS),
                  Text(
                    subtitle,
                    style: TherapyDesignSystem.captionStyle,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: KidsColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Profil löschen?',
          style: TherapyDesignSystem.h3Style,
        ),
        content: Text(
          'Möchtest du wirklich dein Profil löschen? Alle Daten werden unwiderruflich gelöscht.',
          style: TherapyDesignSystem.bodyMediumStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Abbrechen',
              style: TherapyDesignSystem.bodyLargeStyle,
            ),
          ),
          TextButton(
            onPressed: () async {
              final profile = ref.read(childProfileProvider).profile;
              if (profile != null) {
                await ref.read(childProfileProvider.notifier).deleteProfile();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AppRoutes.childProfile,
                    (route) => false,
                  );
                }
              }
            },
            child: Text(
              'Löschen',
              style: TherapyDesignSystem.bodyLargeStyle.copyWith(
                color: TherapyDesignSystem.statusError,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    const names = {
      'bs': 'Bosanski',
      'en': 'English',
      'hr': 'Hrvatski',
      'sr': 'Srpski',
      'de': 'Deutsch',
      'tr': 'Türkçe',
    };
    return names[code] ?? code;
  }
}

