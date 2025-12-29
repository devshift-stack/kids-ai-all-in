import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Child Detail Screen - Detaillierte Ansicht eines Kindes
class ChildDetailScreen extends StatelessWidget {
  final String childId;

  const ChildDetailScreen({
    super.key,
    required this.childId,
  });

  @override
  Widget build(BuildContext context) {
    // Lade Kind-Daten aus Firebase (Placeholder - wird später implementiert)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kind-Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil-Info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      child: Text(childId[0].toUpperCase()),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Kind: $childId',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Statistiken
            Text(
              'Statistiken',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Statistiken werden geladen (Placeholder)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Statistiken werden geladen...', style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),

            const SizedBox(height: 24),

            // Letzte Sessions
            Text(
              'Letzte Sessions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Sessions werden geladen (Placeholder)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Sessions werden geladen...', style: Theme.of(context).textTheme.bodyMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

