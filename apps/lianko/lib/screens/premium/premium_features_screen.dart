import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../services/premium/premium_module.dart';

/// Premium Features Übersicht
///
/// Zentrale Verwaltung aller Premium-Features:
/// - Batterie-Erinnerung
/// - Audiogramm-Import
/// - Logopädie-Modus
/// - Export für Ärzte
class PremiumFeaturesScreen extends ConsumerStatefulWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  ConsumerState<PremiumFeaturesScreen> createState() => _PremiumFeaturesScreenState();
}

class _PremiumFeaturesScreenState extends ConsumerState<PremiumFeaturesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Features'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          _buildHeader(),
          const SizedBox(height: 24),

          // Batterie-Erinnerung
          _buildFeatureCard(
            icon: Icons.battery_charging_full,
            iconColor: Colors.amber,
            title: 'Batterie-Erinnerung',
            subtitle: 'Nie wieder leere Hörgeräte-Batterien',
            description: 'Automatische Erinnerung an den Batteriewechsel basierend auf deinem eingestellten Intervall.',
            onTap: () => _openBatterySettings(context),
            statusWidget: _buildBatteryStatus(),
          ),
          const SizedBox(height: 16),

          // Audiogramm-Import
          _buildFeatureCard(
            icon: Icons.hearing,
            iconColor: Colors.blue,
            title: 'Audiogramm-Import',
            subtitle: 'Individuelle Frequenz-Anpassung',
            description: 'Lade das Audiogramm deines Kindes hoch und die App passt die Frequenzen automatisch an.',
            onTap: () => _openAudiogramImport(context),
            statusWidget: _buildAudiogramStatus(),
          ),
          const SizedBox(height: 16),

          // Logopädie-Modus
          _buildFeatureCard(
            icon: Icons.record_voice_over,
            iconColor: Colors.purple,
            title: 'Logopädie-Modus',
            subtitle: 'Übungen vom Logopäden',
            description: 'Verbinde dich mit dem Logopäden deines Kindes für spezielle Übungen.',
            onTap: () => _openSpeechTherapy(context),
            statusWidget: _buildTherapistStatus(),
          ),
          const SizedBox(height: 16),

          // Export für Ärzte
          _buildFeatureCard(
            icon: Icons.picture_as_pdf,
            iconColor: Colors.red,
            title: 'Fortschritts-Export',
            subtitle: 'PDF-Reports für HNO & Logopäden',
            description: 'Erstelle professionelle Fortschritts-Reports zum Teilen mit Ärzten.',
            onTap: () => _openExportDialog(context),
            statusWidget: null,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withOpacity(0.8),
            AppTheme.primaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Premium Features',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Erweiterte Funktionen für optimales Hörtraining',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
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

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    Widget? statusWidget,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade700,
                ),
              ),
              if (statusWidget != null) ...[
                const SizedBox(height: 12),
                statusWidget,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBatteryStatus() {
    return Consumer(
      builder: (context, ref, _) {
        final statusAsync = ref.watch(batteryStatusProvider);

        return statusAsync.when(
          data: (status) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: status.needsReminder ? Colors.amber.shade100 : Colors.green.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  status.needsReminder ? Icons.warning : Icons.check_circle,
                  size: 16,
                  color: status.needsReminder ? Colors.amber.shade700 : Colors.green.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  status.message,
                  style: TextStyle(
                    fontSize: 12,
                    color: status.needsReminder ? Colors.amber.shade700 : Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const Text('Status nicht verfügbar', style: TextStyle(fontSize: 12)),
        );
      },
    );
  }

  Widget _buildAudiogramStatus() {
    return Consumer(
      builder: (context, ref, _) {
        final audiogramAsync = ref.watch(currentAudiogramProvider);

        return audiogramAsync.when(
          data: (audiogram) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: audiogram != null ? Colors.green.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  audiogram != null ? Icons.check_circle : Icons.upload_file,
                  size: 16,
                  color: audiogram != null ? Colors.green.shade700 : Colors.grey.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  audiogram != null ? 'Audiogramm vorhanden' : 'Noch kein Audiogramm',
                  style: TextStyle(
                    fontSize: 12,
                    color: audiogram != null ? Colors.green.shade700 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const SizedBox(),
        );
      },
    );
  }

  Widget _buildTherapistStatus() {
    return Consumer(
      builder: (context, ref, _) {
        final therapistAsync = ref.watch(linkedTherapistProvider);

        return therapistAsync.when(
          data: (therapist) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: therapist != null ? Colors.purple.shade100 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  therapist != null ? Icons.link : Icons.link_off,
                  size: 16,
                  color: therapist != null ? Colors.purple.shade700 : Colors.grey.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  therapist != null ? 'Verbunden: ${therapist.name}' : 'Nicht verbunden',
                  style: TextStyle(
                    fontSize: 12,
                    color: therapist != null ? Colors.purple.shade700 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          loading: () => const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          error: (_, __) => const SizedBox(),
        );
      },
    );
  }

  // ============================================================
  // NAVIGATION
  // ============================================================

  void _openBatterySettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const BatterySettingsSheet(),
    );
  }

  void _openAudiogramImport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AudiogramImportScreen()),
    );
  }

  void _openSpeechTherapy(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SpeechTherapyScreen()),
    );
  }

  void _openExportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const ExportOptionsSheet(),
    );
  }
}

// ============================================================
// SUB-SCREENS & SHEETS
// ============================================================

/// Batterie-Einstellungen Sheet
class BatterySettingsSheet extends ConsumerStatefulWidget {
  const BatterySettingsSheet({super.key});

  @override
  ConsumerState<BatterySettingsSheet> createState() => _BatterySettingsSheetState();
}

class _BatterySettingsSheetState extends ConsumerState<BatterySettingsSheet> {
  bool _isEnabled = true;
  int _intervalDays = 7;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await ref.read(batteryReminderServiceProvider).loadSettings();
    setState(() {
      _isEnabled = settings.isEnabled;
      _intervalDays = settings.intervalDays;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '🔋 Batterie-Erinnerung',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Aktivierung
            SwitchListTile(
              title: const Text('Erinnerung aktiviert'),
              subtitle: const Text('Benachrichtigung vor leerem Akku'),
              value: _isEnabled,
              onChanged: (value) => setState(() => _isEnabled = value),
            ),
            const Divider(),

            // Intervall
            ListTile(
              title: const Text('Wechsel-Intervall'),
              subtitle: Text('Alle $_intervalDays Tage'),
            ),
            Slider(
              value: _intervalDays.toDouble(),
              min: 3,
              max: 14,
              divisions: 11,
              label: '$_intervalDays Tage',
              onChanged: (value) => setState(() => _intervalDays = value.round()),
            ),
            const SizedBox(height: 20),

            // Batterie jetzt gewechselt
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () async {
                  await ref.read(batteryReminderServiceProvider).markBatteryChanged();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Batteriewechsel gespeichert!')),
                    );
                    Navigator.pop(context);
                  }
                },
                icon: const Icon(Icons.check),
                label: const Text('Batterien gerade gewechselt'),
              ),
            ),
            const SizedBox(height: 12),

            // Speichern
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : () async {
                  setState(() => _isSaving = true);
                  await ref.read(batteryReminderServiceProvider).saveSettings(
                    BatteryReminderSettings(
                      isEnabled: _isEnabled,
                      intervalDays: _intervalDays,
                    ),
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Einstellungen gespeichert!')),
                    );
                  }
                },
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Speichern'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Audiogramm Import Screen
class AudiogramImportScreen extends ConsumerStatefulWidget {
  const AudiogramImportScreen({super.key});

  @override
  ConsumerState<AudiogramImportScreen> createState() => _AudiogramImportScreenState();
}

class _AudiogramImportScreenState extends ConsumerState<AudiogramImportScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audiogramm Import'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade100, Colors.teal.shade50],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.hearing, size: 48, color: Colors.teal.shade700),
                  const SizedBox(height: 12),
                  Text(
                    'Audiogramm hinzufügen',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Die App passt sich automatisch an die Hörschwelle deines Kindes an.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.teal.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Option 1: Foto aufnehmen
            _buildImportOption(
              icon: Icons.camera_alt,
              title: 'Audiogramm fotografieren',
              subtitle: 'Foto vom HNO-Arzt-Bericht machen',
              onTap: _isProcessing ? null : () => _captureAudiogram(fromCamera: true),
            ),
            const SizedBox(height: 12),

            // Option 2: Aus Galerie
            _buildImportOption(
              icon: Icons.photo_library,
              title: 'Aus Galerie wählen',
              subtitle: 'Vorhandenes Bild auswählen',
              onTap: _isProcessing ? null : () => _captureAudiogram(fromCamera: false),
            ),
            const SizedBox(height: 12),

            // Option 3: Manuelle Eingabe
            _buildImportOption(
              icon: Icons.edit,
              title: 'Manuell eingeben',
              subtitle: 'Werte selbst eintragen',
              onTap: _isProcessing ? null : _showManualEntry,
            ),
            const SizedBox(height: 24),

            // Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade700),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Das Audiogramm wird nur lokal gespeichert und hilft der App, Sprache und Töne optimal anzupassen.',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            if (_isProcessing) ...[
              const SizedBox(height: 24),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Center(child: Text('Verarbeite Audiogramm...')),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImportOption({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Future<void> _captureAudiogram({required bool fromCamera}) async {
    setState(() => _isProcessing = true);
    // TODO: Implementiere Bild-Aufnahme und AI-Analyse
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isProcessing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audiogramm-Import wird bald verfügbar sein')),
      );
    }
  }

  void _showManualEntry() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Manuelle Eingabe wird bald verfügbar sein')),
    );
  }
}

/// Speech Therapy Screen - Logopädie-Modus
class SpeechTherapyScreen extends ConsumerStatefulWidget {
  const SpeechTherapyScreen({super.key});

  @override
  ConsumerState<SpeechTherapyScreen> createState() => _SpeechTherapyScreenState();
}

class _SpeechTherapyScreenState extends ConsumerState<SpeechTherapyScreen> {
  final _codeController = TextEditingController();
  bool _isLinking = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logopädie-Modus'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple.shade100, Colors.purple.shade50],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(Icons.record_voice_over, size: 48, color: Colors.purple.shade700),
                  const SizedBox(height: 12),
                  Text(
                    'Mit Logopäden verbinden',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Der Logopäde kann spezielle Übungen zuweisen und den Fortschritt verfolgen.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.purple.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Code-Eingabe
            Text(
              'Therapeuten-Code eingeben',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                hintText: 'z.B. ABC123',
                prefixIcon: const Icon(Icons.key),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _isLinking ? null : _linkTherapist,
              icon: _isLinking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.link),
              label: Text(_isLinking ? 'Verbinde...' : 'Verbinden'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Info-Karten
            _buildInfoCard(
              icon: Icons.assignment,
              title: 'Übungen erhalten',
              description: 'Der Logopäde weist individuelle Übungen für bestimmte Laute zu.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.insights,
              title: 'Fortschritt teilen',
              description: 'Der Logopäde sieht, welche Laute gut klappen und wo Übung nötig ist.',
            ),
            const SizedBox(height: 12),
            _buildInfoCard(
              icon: Icons.security,
              title: 'Datenschutz',
              description: 'Nur der verknüpfte Logopäde hat Zugriff auf die Übungsdaten.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.purple.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.purple.shade700),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _linkTherapist() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bitte Code eingeben')),
      );
      return;
    }

    setState(() => _isLinking = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLinking = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logopädie-Verknüpfung wird bald verfügbar sein')),
      );
    }
  }
}

/// Export Options Sheet
class ExportOptionsSheet extends ConsumerStatefulWidget {
  const ExportOptionsSheet({super.key});

  @override
  ConsumerState<ExportOptionsSheet> createState() => _ExportOptionsSheetState();
}

class _ExportOptionsSheetState extends ConsumerState<ExportOptionsSheet> {
  ReportType _selectedType = ReportType.parent;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.8,
      expand: false,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '📄 Report erstellen',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Wähle den Report-Typ für den Empfänger',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Report Type Selection
            _buildReportTypeOption(
              ReportType.audiologist,
              'HNO / Audiologe',
              'Fokus auf Audiogramm und Hörgeräte-Nutzung',
              Icons.medical_services,
            ),
            _buildReportTypeOption(
              ReportType.speechTherapist,
              'Logopäde',
              'Fokus auf Sprachentwicklung und Phoneme',
              Icons.record_voice_over,
            ),
            _buildReportTypeOption(
              ReportType.parent,
              'Eltern',
              'Übersichtlicher Gesamtbericht',
              Icons.family_restroom,
            ),

            const SizedBox(height: 20),

            // Generate Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isGenerating ? null : _generateReport,
                icon: _isGenerating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(_isGenerating ? 'Wird erstellt...' : 'PDF erstellen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportTypeOption(
    ReportType type,
    String title,
    String subtitle,
    IconData icon,
  ) {
    final isSelected = _selectedType == type;
    return Card(
      elevation: isSelected ? 2 : 0,
      color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppTheme.primaryColor : Colors.grey),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primaryColor) : null,
        onTap: () => setState(() => _selectedType = type),
      ),
    );
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);

    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      final file = await ref.read(progressExportServiceProvider).generateProgressReport(
        type: _selectedType,
        dateRange: DateTimeRange(start: thirtyDaysAgo, end: now),
      );

      if (file != null && mounted) {
        await ref.read(progressExportServiceProvider).shareReport(file);
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report konnte nicht erstellt werden')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
