import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/communication/communication_model.dart';
import '../../services/child_recording_service.dart';
import '../../services/child_settings_service.dart';
import '../../services/speech_training_service.dart';

/// Screen für Aufnahme-Wiedergabe
/// Kind kann seine eigenen Aufnahmen anhören und mit Eltern-Aufnahmen vergleichen
class RecordingsScreen extends ConsumerStatefulWidget {
  const RecordingsScreen({super.key});

  @override
  ConsumerState<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends ConsumerState<RecordingsScreen> {
  Set<String> _recordedIds = {};
  bool _isLoading = true;
  String? _currentlyPlaying;

  @override
  void initState() {
    super.initState();
    _loadRecordings();
  }

  Future<void> _loadRecordings() async {
    final service = ref.read(childRecordingServiceProvider);
    await service.loadAllRecordings();

    setState(() {
      _recordedIds = service.recordedSymbolIds;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Sammle alle Symbole
    final allSymbols = <CommunicationSymbol>[];
    for (final category in CommunicationData.getAll()) {
      for (final symbol in category.symbols) {
        allSymbols.add(symbol);
        if (symbol.subOptions != null) {
          allSymbols.addAll(symbol.subOptions!);
        }
      }
    }

    // Filtere nur aufgenommene
    final recordedSymbols = allSymbols
        .where((s) => _recordedIds.contains(s.id))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Meine Aufnahmen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          // Anzahl Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic, color: Color(0xFF4CAF50), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${recordedSymbols.length}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : recordedSymbols.isEmpty
              ? _buildEmptyState()
              : _buildRecordingsList(recordedSymbols),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mic_off, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Noch keine Aufnahmen',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Gehe zum Zeig-Sprech-Modul\num Wörter aufzunehmen',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingsList(List<CommunicationSymbol> symbols) {
    final settings = ref.watch(currentChildSettingsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Deine Stimme',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tippe auf ein Wort um es anzuhören',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Wiedergabe-Modus Info
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: settings.useChildRecordings
                ? const Color(0xFF4CAF50).withOpacity(0.1)
                : const Color(0xFF2196F3).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                settings.useChildRecordings ? Icons.child_care : Icons.record_voice_over,
                color: settings.useChildRecordings
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFF2196F3),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  settings.useChildRecordings
                      ? 'Deine eigene Stimme wird abgespielt'
                      : 'App-Stimme wird abgespielt (Eltern-Einstellung)',
                  style: TextStyle(
                    color: settings.useChildRecordings
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF2196F3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Liste
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              final symbol = symbols[index];
              final isPlaying = _currentlyPlaying == symbol.id;

              return _RecordingCard(
                symbol: symbol,
                index: index,
                isPlaying: isPlaying,
                allowReRecord: settings.allowReRecording,
                onPlay: () => _playRecording(symbol),
                onPlayOriginal: () => _playOriginal(symbol),
                onReRecord: settings.allowReRecording
                    ? () => _reRecord(symbol)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _playRecording(CommunicationSymbol symbol) async {
    setState(() => _currentlyPlaying = symbol.id);

    final service = ref.read(childRecordingServiceProvider);
    await service.playRecording(symbol.id, symbol.word);

    if (mounted) {
      setState(() => _currentlyPlaying = null);
    }
  }

  Future<void> _playOriginal(CommunicationSymbol symbol) async {
    setState(() => _currentlyPlaying = '${symbol.id}_original');

    final service = ref.read(speechTrainingServiceProvider);
    await service.speakWord(symbol.word);

    if (mounted) {
      setState(() => _currentlyPlaying = null);
    }
  }

  Future<void> _reRecord(CommunicationSymbol symbol) async {
    // Zeige Dialog zur Bestätigung
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Neu aufnehmen?'),
        content: Text('Möchtest du "${symbol.word}" neu aufnehmen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Ja, aufnehmen'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _showRecordingSheet(symbol);
    }
  }

  void _showRecordingSheet(CommunicationSymbol symbol) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _RecordingBottomSheet(
        symbol: symbol,
        onComplete: () {
          _loadRecordings();
        },
      ),
    );
  }
}

/// Karte für eine Aufnahme
class _RecordingCard extends StatelessWidget {
  final CommunicationSymbol symbol;
  final int index;
  final bool isPlaying;
  final bool allowReRecord;
  final VoidCallback onPlay;
  final VoidCallback onPlayOriginal;
  final VoidCallback? onReRecord;

  const _RecordingCard({
    required this.symbol,
    required this.index,
    required this.isPlaying,
    required this.allowReRecord,
    required this.onPlay,
    required this.onPlayOriginal,
    this.onReRecord,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: isPlaying
            ? Border.all(color: const Color(0xFF4CAF50), width: 2)
            : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 56,
            height: 56,
            child: Image.asset(
              symbol.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                child: const Icon(Icons.image, color: Color(0xFF4CAF50)),
              ),
            ),
          ),
        ),
        title: Text(
          symbol.word,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Row(
          children: [
            // Meine Aufnahme abspielen
            _MiniPlayButton(
              icon: Icons.child_care,
              label: 'Meine',
              isPlaying: isPlaying,
              onTap: onPlay,
            ),
            const SizedBox(width: 8),
            // Original abspielen
            _MiniPlayButton(
              icon: Icons.record_voice_over,
              label: 'Original',
              isPlaying: false,
              color: Colors.blue,
              onTap: onPlayOriginal,
            ),
          ],
        ),
        trailing: allowReRecord
            ? IconButton(
                icon: const Icon(Icons.refresh),
                color: Colors.orange,
                onPressed: onReRecord,
                tooltip: 'Neu aufnehmen',
              )
            : const Icon(Icons.lock_outline, color: Colors.grey, size: 20),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms)
        .slideX(begin: 0.1, end: 0);
  }
}

/// Mini-Abspielen-Button
class _MiniPlayButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPlaying;
  final Color color;
  final VoidCallback onTap;

  const _MiniPlayButton({
    required this.icon,
    required this.label,
    required this.isPlaying,
    this.color = const Color(0xFF4CAF50),
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isPlaying ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isPlaying ? Icons.pause : icon,
              size: 14,
              color: isPlaying ? Colors.white : color,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isPlaying ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom Sheet für Neu-Aufnahme
class _RecordingBottomSheet extends ConsumerStatefulWidget {
  final CommunicationSymbol symbol;
  final VoidCallback onComplete;

  const _RecordingBottomSheet({
    required this.symbol,
    required this.onComplete,
  });

  @override
  ConsumerState<_RecordingBottomSheet> createState() => _RecordingBottomSheetState();
}

class _RecordingBottomSheetState extends ConsumerState<_RecordingBottomSheet> {
  bool _isRecording = false;
  bool _hasRecorded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // Symbol/Bild
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.asset(
                widget.symbol.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  child: const Icon(Icons.image, size: 48, color: Color(0xFF4CAF50)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Wort
          Text(
            widget.symbol.word,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 8),

          // Status
          Text(
            _isRecording
                ? 'Sprich jetzt...'
                : _hasRecorded
                    ? 'Aufnahme fertig!'
                    : 'Tippe zum Aufnehmen',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Record Button
          GestureDetector(
            onTap: _toggleRecording,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _isRecording
                    ? Colors.red
                    : _hasRecorded
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF4CAF50).withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isRecording ? Colors.red : const Color(0xFF4CAF50),
                  width: 3,
                ),
              ),
              child: Icon(
                _isRecording
                    ? Icons.stop
                    : _hasRecorded
                        ? Icons.check
                        : Icons.mic,
                color: _isRecording || _hasRecorded ? Colors.white : const Color(0xFF4CAF50),
                size: 40,
              ),
            )
                .animate(target: _isRecording ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.1, 1.1),
                  duration: 500.ms,
                )
                .then()
                .scale(
                  begin: const Offset(1.1, 1.1),
                  end: const Offset(1, 1),
                  duration: 500.ms,
                ),
          ),
          const SizedBox(height: 32),

          // Buttons
          if (_hasRecorded)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() => _hasRecorded = false);
                    },
                    child: const Text('Nochmal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onComplete();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                    ),
                    child: const Text('Fertig'),
                  ),
                ),
              ],
            ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Future<void> _toggleRecording() async {
    final service = ref.read(childRecordingServiceProvider);

    if (_isRecording) {
      // Stop
      await service.stopRecording(widget.symbol.id);
      setState(() {
        _isRecording = false;
        _hasRecorded = true;
      });
    } else {
      // Start
      await service.startRecording(widget.symbol.id);
      setState(() => _isRecording = true);

      // Auto-Stop nach 3 Sekunden
      Future.delayed(const Duration(seconds: 3), () {
        if (_isRecording && mounted) {
          _toggleRecording();
        }
      });
    }
  }
}
