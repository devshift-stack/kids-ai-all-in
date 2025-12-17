import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../providers/pin_provider.dart';
import 'co_parent_screen.dart';

/// Provider for notification settings
final notificationSettingsProvider = StateNotifierProvider<NotificationSettingsNotifier, NotificationSettings>((ref) {
  return NotificationSettingsNotifier();
});

class NotificationSettings {
  final bool enabled;
  final bool activityAlerts;
  final bool dailyReport;
  final bool deviceAlerts;

  const NotificationSettings({
    this.enabled = true,
    this.activityAlerts = true,
    this.dailyReport = false,
    this.deviceAlerts = true,
  });

  NotificationSettings copyWith({
    bool? enabled,
    bool? activityAlerts,
    bool? dailyReport,
    bool? deviceAlerts,
  }) {
    return NotificationSettings(
      enabled: enabled ?? this.enabled,
      activityAlerts: activityAlerts ?? this.activityAlerts,
      dailyReport: dailyReport ?? this.dailyReport,
      deviceAlerts: deviceAlerts ?? this.deviceAlerts,
    );
  }
}

class NotificationSettingsNotifier extends StateNotifier<NotificationSettings> {
  NotificationSettingsNotifier() : super(const NotificationSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      enabled: prefs.getBool('notif_enabled') ?? true,
      activityAlerts: prefs.getBool('notif_activity') ?? true,
      dailyReport: prefs.getBool('notif_daily') ?? false,
      deviceAlerts: prefs.getBool('notif_device') ?? true,
    );
  }

  Future<void> setEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_enabled', value);
    state = state.copyWith(enabled: value);
  }

  Future<void> setActivityAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_activity', value);
    state = state.copyWith(activityAlerts: value);
  }

  Future<void> setDailyReport(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_daily', value);
    state = state.copyWith(dailyReport: value);
  }

  Future<void> setDeviceAlerts(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_device', value);
    state = state.copyWith(deviceAlerts: value);
  }
}

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pinConfig = ref.watch(pinConfigProvider.notifier);
    final notifSettings = ref.watch(notificationSettingsProvider);
    final notifNotifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: KidsColors.background,
      appBar: ModernNavBar(
        title: 'Postavke',
        actions: [
          NavButton(
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
            },
          ),
          NavButton(
            icon: Icons.settings,
            onTap: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Postavke',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: KidsColors.textPrimary,
              ),
            ),
            const SizedBox(height: 32),
            // Profile Section
            _buildProfileSection(),
            const SizedBox(height: 24),
            // Time Limits Section
            _buildTimeLimitsSection(),
            const SizedBox(height: 24),
            // Notifications Section
            _buildNotificationsSection(ref, notifSettings, notifNotifier),
            const SizedBox(height: 24),
            // Content Controls Section
            _buildContentControlsSection(),
            const SizedBox(height: 24),
            // Audio Settings Section
            _buildAudioSettingsSection(),
            const SizedBox(height: 24),
            // Security Section
            _buildSecuritySection(context, ref, pinConfig),
            const SizedBox(height: 24),
            // Family Section
            _buildFamilySection(context),
            const SizedBox(height: 24),
            // Language Section
            _buildLanguageSection(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _getCurrentLanguageName(BuildContext context) {
    final locale = context.locale;
    switch (locale.languageCode) {
      case 'de':
        return 'Deutsch';
      case 'en':
        return 'English';
      case 'tr':
        return 'Türkçe';
      case 'bs':
        return 'Bosanski';
      case 'sr':
        return 'Srpski';
      case 'hr':
        return 'Hrvatski';
      default:
        return 'Deutsch';
    }
  }

  Future<void> _showLanguageDialog(BuildContext context) async {
    final languages = [
      {'code': 'de', 'name': 'Deutsch', 'flag': '🇩🇪'},
      {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
      {'code': 'bs', 'name': 'Bosanski', 'flag': '🇧🇦'},
      {'code': 'sr', 'name': 'Srpski', 'flag': '🇷🇸'},
      {'code': 'hr', 'name': 'Hrvatski', 'flag': '🇭🇷'},
    ];

    await showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2D2D44),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Sprache wählen',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...languages.map((lang) {
              final isSelected = context.locale.languageCode == lang['code'];
              return ListTile(
                leading: Text(
                  lang['flag']!,
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(
                  lang['name']!,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF6C63FF) : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle, color: Color(0xFF6C63FF))
                    : null,
                onTap: () {
                  context.setLocale(Locale(lang['code']!));
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // Profile Section (v0 Design)
  Widget _buildProfileSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildInputField(
                label: 'Ime djeteta',
                value: 'Max Mustermann',
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Godine',
                value: '8',
                keyboardType: TextInputType.number,
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: KidsColors.primary,
                ),
                child: const Text('Ažuriraj profil'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Time Limits Section (v0 Design)
  Widget _buildTimeLimitsSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Vremenska ograničenja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildSwitchRow(
                title: 'Dnevno vremensko ograničenje',
                subtitle: 'Maksimalno trajanje korištenja dnevno',
                trailing: Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '60',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Min',
                      style: TextStyle(color: KidsColors.textSecondary),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              _buildSwitchRow(
                title: 'Podsjetnik za pauzu',
                subtitle: 'Podsjetite nakon 30 minuta na pauzu',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Notifications Section (v0 Design)
  Widget _buildNotificationsSection(
    WidgetRef ref,
    NotificationSettings notifSettings,
    NotificationSettingsNotifier notifNotifier,
  ) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Obavještenja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildSwitchRow(
                title: 'Izvještaji o napretku',
                subtitle: 'Sedmični pregled putem emaila',
                trailing: Switch(
                  value: notifSettings.dailyReport,
                  onChanged: (value) => notifNotifier.setDailyReport(value),
                ),
              ),
              const Divider(height: 32),
              _buildSwitchRow(
                title: 'Uspjesi',
                subtitle: 'Obavijesti o novim značkama',
                trailing: Switch(
                  value: notifSettings.activityAlerts,
                  onChanged: (value) => notifNotifier.setActivityAlerts(value),
                ),
              ),
              const Divider(height: 32),
              _buildSwitchRow(
                title: 'Podsjetnici za aktivnosti',
                subtitle: 'Pošalji dnevni podsjetnik za učenje',
                trailing: Switch(
                  value: notifSettings.enabled,
                  onChanged: (value) => notifNotifier.setEnabled(value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Content Controls Section (v0 Design)
  Widget _buildContentControlsSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.visibility, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Postavke sadržaja',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildSwitchRow(
                title: 'Sadržaj prilagođen godinama',
                subtitle: 'Prikaži samo sadržaj za uzrasnu grupu',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              const Divider(height: 32),
              _buildSwitchRow(
                title: 'AI podrška',
                subtitle: 'Aktiviraj personalizirane prijedloge za učenje',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Audio Settings Section (v0 Design)
  Widget _buildAudioSettingsSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.volume_up, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Audio i TTS',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildSwitchRow(
                title: 'Tekst-u-govor',
                subtitle: 'Automatski čitaj tekstove',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
              const Divider(height: 32),
              _buildSwitchRow(
                title: 'Zvučni efekti',
                subtitle: 'Puštaj zvukove pri uspjesima',
                trailing: Switch(
                  value: true,
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Security Section (v0 Design)
  Widget _buildSecuritySection(
    BuildContext context,
    WidgetRef ref,
    PinConfigNotifier pinConfig,
  ) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Sigurnost',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildSwitchRow(
                title: 'PIN zaštita za roditeljski pristup',
                subtitle: 'Zaštiti pristup kontrolnoj tabli',
                trailing: Switch(
                  value: pinConfig.isPinEnabled,
                  onChanged: (value) {
                    if (value) {
                      _showSetPinDialog(context, ref);
                    } else {
                      _showDisablePinDialog(context, ref);
                    }
                  },
                ),
              ),
              if (pinConfig.isPinEnabled) ...[
                const Divider(height: 32),
                _buildInputField(
                  label: 'Postavi novi PIN',
                  value: '',
                  obscureText: true,
                  hintText: '••••',
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => _showChangePinDialog(context, ref),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: KidsColors.secondary,
                    side: const BorderSide(color: KidsColors.secondary),
                  ),
                  child: const Text('Promijeni PIN'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // Family Section
  Widget _buildFamilySection(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.people, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Familija',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.people, color: KidsColors.textPrimary),
            title: const Text(
              'Elternteile verwalten',
              style: TextStyle(color: KidsColors.textPrimary),
            ),
            subtitle: const Text(
              'Weiteren Elternteil einladen',
              style: TextStyle(color: KidsColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right, color: KidsColors.textSecondary),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CoParentScreen()),
            ),
          ),
        ],
      ),
    );
  }

  // Language Section
  Widget _buildLanguageSection(BuildContext context) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.language, size: 20, color: KidsColors.textSecondary),
              const SizedBox(width: 8),
              const Text(
                'Jezik',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.language, color: KidsColors.textPrimary),
            title: const Text(
              'App-Sprache',
              style: TextStyle(color: KidsColors.textPrimary),
            ),
            subtitle: Text(
              _getCurrentLanguageName(context),
              style: const TextStyle(color: KidsColors.textSecondary),
            ),
            trailing: const Icon(Icons.chevron_right, color: KidsColors.textSecondary),
            onTap: () => _showLanguageDialog(context),
          ),
        ],
      ),
    );
  }

  // Helper Widgets
  Widget _buildInputField({
    required String label,
    required String value,
    String? hintText,
    bool obscureText = false,
    TextInputType? keyboardType,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: KidsColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: TextEditingController(text: value),
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: KidsColors.border),
            ),
            filled: true,
            fillColor: KidsColors.surface,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: KidsColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: KidsColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Future<void> _showSetPinDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();

    final pin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: const Text('PIN festlegen', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 4,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
          decoration: InputDecoration(
            hintText: '••••',
            hintStyle: TextStyle(color: Colors.white.withValues(alpha:0.3)),
            filled: true,
            fillColor: Colors.white.withValues(alpha:0.1),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );

    if (pin != null && pin.length == 4) {
      final pinNotifier = ref.read(pinConfigProvider.notifier);
      await pinNotifier.setPin(pin);
    }
  }

  Future<void> _showDisablePinDialog(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();

    final pin = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: const Text('PIN deaktivieren', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Gib deinen aktuellen PIN ein:',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 24, letterSpacing: 8),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white.withValues(alpha:0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Deaktivieren'),
          ),
        ],
      ),
    );

    if (pin != null && pin.length == 4) {
      final pinNotifier = ref.read(pinConfigProvider.notifier);
      final success = await pinNotifier.disablePin(pin);
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falscher PIN'), backgroundColor: Colors.redAccent),
        );
      }
    }
  }

  Future<void> _showChangePinDialog(BuildContext context, WidgetRef ref) async {
    final oldController = TextEditingController();
    final newController = TextEditingController();

    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D2D44),
        title: const Text('PIN ändern', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8),
              decoration: InputDecoration(
                labelText: 'Alter PIN',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha:0.5)),
                filled: true,
                fillColor: Colors.white.withValues(alpha:0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 4,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8),
              decoration: InputDecoration(
                labelText: 'Neuer PIN',
                labelStyle: TextStyle(color: Colors.white.withValues(alpha:0.5)),
                filled: true,
                fillColor: Colors.white.withValues(alpha:0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, {
              'old': oldController.text,
              'new': newController.text,
            }),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
            child: const Text('Ändern'),
          ),
        ],
      ),
    );

    if (result != null && result['old']!.length == 4 && result['new']!.length == 4) {
      final pinNotifier = ref.read(pinConfigProvider.notifier);
      final success = await pinNotifier.changePin(result['old']!, result['new']!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(success ? 'PIN geändert' : 'Falscher PIN'),
            backgroundColor: success ? Colors.green : Colors.redAccent,
          ),
        );
      }
    }
  }

}
