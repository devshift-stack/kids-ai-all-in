import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Settings Screen
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Benachrichtigungen'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Notifications Settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Voice-Cloning verwalten'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Voice Management
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Sprache'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to Language Settings
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Über'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Show About Dialog
            },
          ),
        ],
      ),
    );
  }
}

