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
    // TODO: Lade Kind-Daten aus Firebase

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
            // TODO: Zeige Statistiken

            const SizedBox(height: 24),

            // Letzte Sessions
            Text(
              'Letzte Sessions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // TODO: Zeige Sessions
          ],
        ),
      ),
    );
  }
}

