import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Export Screen
class ExportScreen extends StatelessWidget {
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf),
                title: const Text('PDF-Report generieren'),
                subtitle: const Text('Detaillierter Fortschritts-Report'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Generate PDF Report
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('PDF-Export wird implementiert...'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.table_chart),
                title: const Text('CSV-Export'),
                subtitle: const Text('Daten für Analysen exportieren'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Generate CSV Export
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('CSV-Export wird implementiert...'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

