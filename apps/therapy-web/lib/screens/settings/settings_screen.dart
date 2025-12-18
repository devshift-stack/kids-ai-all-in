import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../core/theme/app_theme.dart';

/// Settings Screen - Hauptübersicht für Web UI
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy AI - Einstellungen'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Einstellungen',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 32),

                // Einstellungs-Kategorien
                _buildSettingsGrid(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 24,
      mainAxisSpacing: 24,
      childAspectRatio: 1.5,
      children: [
        _buildSettingsCard(
          context,
          title: 'Sprach-Einstellungen',
          description: 'Multi-Language Support, Primärsprache, Dialekte',
          icon: Icons.language,
          color: AppTheme.primaryColor,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.language);
          },
        ),
        _buildSettingsCard(
          context,
          title: 'Phonem-Einstellungen',
          description: 'Problem-Phoneme markieren, Prioritäten setzen',
          icon: Icons.text_fields,
          color: AppTheme.secondaryColor,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.phoneme);
          },
        ),
        _buildSettingsCard(
          context,
          title: 'Avatar-Konfiguration',
          description: 'Avatar erstellen, Bilder hochladen, testen',
          icon: Icons.face,
          color: Colors.purple,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.avatar);
          },
        ),
        _buildSettingsCard(
          context,
          title: 'Therapie-Einstellungen',
          description: 'Hörverlust-Profil, Übungs-Konfiguration, AI-Anpassungen',
          icon: Icons.medical_services,
          color: Colors.green,
          onTap: () {
            // Navigate to Therapy Settings (Placeholder)
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Therapie-Einstellungen werden implementiert...'),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 48, color: color),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

