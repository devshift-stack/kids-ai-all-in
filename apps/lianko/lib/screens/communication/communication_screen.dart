import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/communication/communication_model.dart';
import '../../services/child_recording_service.dart';
import 'symbol_recording_screen.dart';

/// Hauptscreen für das Zeig-Sprech-Modul
/// Kind kann durch Bilder zeigen was es möchte
class CommunicationScreen extends ConsumerStatefulWidget {
  const CommunicationScreen({super.key});

  @override
  ConsumerState<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends ConsumerState<CommunicationScreen> {
  bool _showSetupPrompt = true;

  @override
  void initState() {
    super.initState();
    _checkFirstUse();
  }

  Future<void> _checkFirstUse() async {
    final service = ref.read(childRecordingServiceProvider);
    await service.loadAllRecordings();

    // Wenn schon Aufnahmen vorhanden, Setup-Prompt nicht zeigen
    if (service.recordedSymbolIds.isNotEmpty) {
      setState(() => _showSetupPrompt = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categories = CommunicationData.getAll();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Zeig mir'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          // Aufnahme-Setup Button
          IconButton(
            icon: const Icon(Icons.mic),
            onPressed: () => _openRecordingSetup(context),
            tooltip: 'Wörter aufnehmen',
          ),
        ],
      ),
      body: Column(
        children: [
          // Setup-Prompt bei Erstnutzung
          if (_showSetupPrompt) _buildSetupPrompt(),

          // Ja/Nein Schnellzugriff (immer sichtbar)
          _buildQuickAnswers(),

          // Kategorien Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: categories.length - 1, // Ohne Ja/Nein (ist oben)
              itemBuilder: (context, index) {
                // Überspringe Ja/Nein Kategorie
                final filteredCategories = categories.where((c) => c.id != 'janein').toList();
                final category = filteredCategories[index];

                return _CategoryCard(
                  category: category,
                  index: index,
                  onTap: () => _openCategory(context, category),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupPrompt() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF4CAF50).withOpacity(0.1),
            const Color(0xFF2196F3).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.mic, color: Color(0xFF4CAF50), size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Deine Stimme aufnehmen?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Nimm die Wörter auf, dann hörst du dich selbst!',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _showSetupPrompt = false),
                  child: const Text('Später'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _showSetupPrompt = false);
                    _openRecordingSetup(context);
                  },
                  icon: const Icon(Icons.mic),
                  label: const Text('Aufnehmen'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.2, end: 0);
  }

  Widget _buildQuickAnswers() {
    final jaNein = CommunicationData.jaNein;
    final service = ref.read(childRecordingServiceProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: jaNein.symbols.map((symbol) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: _QuickAnswerButton(
                symbol: symbol,
                color: Color(jaNein.colorValue),
                onTap: () => _playSymbol(service, symbol),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _playSymbol(ChildRecordingService service, CommunicationSymbol symbol) {
    service.playRecording(symbol.id, symbol.word);

    // Visuelles Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up, color: Colors.white),
            const SizedBox(width: 8),
            Text(symbol.word, style: const TextStyle(fontSize: 18)),
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openCategory(BuildContext context, CommunicationCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategorySymbolsScreen(category: category),
      ),
    );
  }

  void _openRecordingSetup(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SymbolRecordingScreen(),
      ),
    );
  }
}

/// Karte für eine Kategorie
class _CategoryCard extends StatelessWidget {
  final CommunicationCategory category;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.colorValue);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon groß
            Text(
              category.icon,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 8),
            // Name
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            // Push-Indikator
            if (category.sendPushOnUse)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.notifications_active, size: 14, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      'Benachrichtigt',
                      style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

/// Schnellantwort-Button (Ja/Nein/Vielleicht)
class _QuickAnswerButton extends StatelessWidget {
  final CommunicationSymbol symbol;
  final Color color;
  final VoidCallback onTap;

  const _QuickAnswerButton({
    required this.symbol,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isJa = symbol.word == 'Ja';
    final isNein = symbol.word == 'Nein';

    final buttonColor = isJa
        ? const Color(0xFF4CAF50)
        : isNein
            ? const Color(0xFFE53935)
            : const Color(0xFFFF9800);

    return Material(
      color: buttonColor.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: buttonColor.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isJa ? Icons.check_circle : isNein ? Icons.cancel : Icons.help,
                color: buttonColor,
                size: 24,
              ),
              const SizedBox(width: 6),
              Text(
                symbol.word,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: buttonColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Screen für Symbole einer Kategorie
class CategorySymbolsScreen extends ConsumerWidget {
  final CommunicationCategory category;

  const CategorySymbolsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(category.colorValue);
    final service = ref.read(childRecordingServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: category.symbols.length,
        itemBuilder: (context, index) {
          final symbol = category.symbols[index];

          return _SymbolCard(
            symbol: symbol,
            color: color,
            index: index,
            onTap: () {
              if (symbol.subOptions != null && symbol.subOptions!.isNotEmpty) {
                // Zeige Unter-Optionen
                _openSubOptions(context, symbol, color);
              } else {
                // Direkt abspielen
                _playAndNotify(context, service, symbol, category);
              }
            },
          );
        },
      ),
    );
  }

  void _openSubOptions(
    BuildContext context,
    CommunicationSymbol symbol,
    Color color,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SubOptionsScreen(
          parentSymbol: symbol,
          color: color,
          category: category,
        ),
      ),
    );
  }

  void _playAndNotify(
    BuildContext context,
    ChildRecordingService service,
    CommunicationSymbol symbol,
    CommunicationCategory category,
  ) {
    service.playRecording(symbol.id, symbol.word);

    // Visuelles Feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.volume_up, color: Colors.white),
            const SizedBox(width: 8),
            Text(symbol.word, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Color(category.colorValue),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Push an Eltern wenn aktiviert
    if (category.sendPushOnUse && kDebugMode) {
      print('📱 Push an Eltern: Kind hat "${symbol.word}" ausgewählt');
    }
  }
}

/// Karte für ein einzelnes Symbol
class _SymbolCard extends StatelessWidget {
  final CommunicationSymbol symbol;
  final Color color;
  final int index;
  final VoidCallback onTap;

  const _SymbolCard({
    required this.symbol,
    required this.color,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasSubOptions = symbol.subOptions != null && symbol.subOptions!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Bild
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      symbol.imageAsset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: color.withOpacity(0.1),
                        child: Icon(
                          Icons.image,
                          size: 48,
                          color: color.withOpacity(0.5),
                        ),
                      ),
                    ),
                    // Sub-Options Indikator
                    if (hasSubOptions)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: color,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Wort
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
              ),
              child: Text(
                symbol.word,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}

/// Screen für Unter-Optionen
class SubOptionsScreen extends ConsumerWidget {
  final CommunicationSymbol parentSymbol;
  final Color color;
  final CommunicationCategory category;

  const SubOptionsScreen({
    super.key,
    required this.parentSymbol,
    required this.color,
    required this.category,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(childRecordingServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(parentSymbol.word),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: parentSymbol.subOptions!.length,
        itemBuilder: (context, index) {
          final symbol = parentSymbol.subOptions![index];

          return _SymbolCard(
            symbol: symbol,
            color: color,
            index: index,
            onTap: () {
              service.playRecording(symbol.id, symbol.word);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.volume_up, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(symbol.word, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  duration: const Duration(seconds: 2),
                  backgroundColor: color,
                  behavior: SnackBarBehavior.floating,
                ),
              );

              if (category.sendPushOnUse && kDebugMode) {
                print('📱 Push an Eltern: Kind hat "${symbol.word}" ausgewählt');
              }
            },
          );
        },
      ),
    );
  }
}
