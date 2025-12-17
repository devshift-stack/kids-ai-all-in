import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_theme.dart';

/// Child List Screen - Liste aller Kinder
class ChildListScreen extends ConsumerWidget {
  const ChildListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Lade Kinder aus Firebase
    final children = <String>[]; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kinder'),
      ),
      body: children.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: AppTheme.textLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Noch keine Kinder hinzugefügt',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(children[index][0].toUpperCase()),
                  ),
                  title: Text(children[index]),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.childDetail,
                      arguments: children[index],
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to Add Child Screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

