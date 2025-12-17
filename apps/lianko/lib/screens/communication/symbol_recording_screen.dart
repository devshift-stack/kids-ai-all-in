import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/communication/communication_model.dart';
import '../../services/child_recording_service.dart';
import '../../services/speech_training_service.dart';

/// Screen zum Aufnehmen der eigenen Stimme für alle Symbole
/// Bei Erstnutzung oder wenn Kind neue Wörter aufnehmen möchte
class SymbolRecordingScreen extends ConsumerStatefulWidget {
  const SymbolRecordingScreen({super.key});

  @override
  ConsumerState<SymbolRecordingScreen> createState() => _SymbolRecordingScreenState();
}

class _SymbolRecordingScreenState extends ConsumerState<SymbolRecordingScreen> {
  late List<CommunicationSymbol> _allSymbols;
  int _currentIndex = 0;
  bool _isRecording = false;
  bool _hasRecorded = false;
  Set<String> _recordedIds = {};

  @override
  void initState() {
    super.initState();
    _loadAllSymbols();
  }

  void _loadAllSymbols() {
    _allSymbols = [];

    // Alle Symbole aus allen Kategorien sammeln (flach)
    for (final category in CommunicationData.getAll()) {
      for (final symbol in category.symbols) {
        _allSymbols.add(symbol);

        // Sub-Optionen auch hinzufügen
        if (symbol.subOptions != null) {
          _allSymbols.addAll(symbol.subOptions!);
        }
      }
    }

    // Bereits aufgenommene laden
    _loadRecordedSymbols();
  }

  Future<void> _loadRecordedSymbols() async {
    final service = ref.read(childRecordingServiceProvider);
    await service.loadAllRecordings();
    setState(() {
      _recordedIds = service.recordedSymbolIds;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_allSymbols.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final symbol = _allSymbols[_currentIndex];
    final progress = (_currentIndex + 1) / _allSymbols.length;
    final isAlreadyRecorded = _recordedIds.contains(symbol.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Wörter aufnehmen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fertig'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Fortschritt
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentIndex + 1} von ${_allSymbols.length}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    Text(
                      '${_recordedIds.length} aufgenommen',
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Symbol-Karte
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Status Badge
                    if (isAlreadyRecorded)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF4CAF50),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Bereits aufgenommen',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                    // Bild
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            symbol.imageAsset,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey[100],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 64, color: Colors.grey[400]),
                                  const SizedBox(height: 8),
                                  Text(
                                    symbol.word,
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Wort groß anzeigen
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        symbol.word,
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2196F3),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Hilfetext
                    Text(
                      _isRecording
                          ? 'Sprich jetzt!'
                          : _hasRecorded
                              ? 'Super! Weiter oder nochmal?'
                              : 'Drücke und sprich das Wort',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Aufnahme-Buttons
                    _buildRecordingButtons(symbol, isAlreadyRecorded),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ).animate().fadeIn().scale(
                  begin: const Offset(0.95, 0.95),
                  end: const Offset(1, 1),
                ),
          ),

          // Navigation
          _buildNavigation(symbol),
        ],
      ),
    );
  }

  Widget _buildRecordingButtons(CommunicationSymbol symbol, bool isAlreadyRecorded) {
    final service = ref.read(childRecordingServiceProvider);
    final speechService = ref.read(speechTrainingServiceProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Anhören (TTS oder vorhandene Aufnahme)
          _RecordButton(
            icon: Icons.volume_up,
            label: 'Hören',
            color: Colors.blue,
            onPressed: () async {
              if (isAlreadyRecorded || _hasRecorded) {
                // Eigene Aufnahme abspielen
                await service.playRecording(symbol.id, symbol.word);
              } else {
                // TTS abspielen
                await speechService.speakWord(symbol.word);
              }
            },
          ),

          // Aufnehmen
          _RecordButton(
            icon: _isRecording ? Icons.stop : Icons.mic,
            label: _isRecording ? 'Stopp' : 'Aufnehmen',
            color: _isRecording ? Colors.red : const Color(0xFF4CAF50),
            isLarge: true,
            onPressed: () async {
              if (_isRecording) {
                // Aufnahme stoppen
                await service.stopRecording(symbol.id);
                setState(() {
                  _isRecording = false;
                  _hasRecorded = true;
                  _recordedIds.add(symbol.id);
                });
              } else {
                // Aufnahme starten
                await service.startRecording(symbol.id);
                setState(() => _isRecording = true);

                // Auto-Stopp nach 3 Sekunden
                Future.delayed(const Duration(seconds: 3), () {
                  if (_isRecording && mounted) {
                    service.stopRecording(symbol.id);
                    setState(() {
                      _isRecording = false;
                      _hasRecorded = true;
                      _recordedIds.add(symbol.id);
                    });
                  }
                });
              }
            },
          ),

          // Nochmal (löschen und neu)
          _RecordButton(
            icon: Icons.refresh,
            label: 'Nochmal',
            color: Colors.orange,
            onPressed: isAlreadyRecorded || _hasRecorded
                ? () async {
                    await service.deleteRecording(symbol.id);
                    setState(() {
                      _hasRecorded = false;
                      _recordedIds.remove(symbol.id);
                    });
                  }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigation(CommunicationSymbol symbol) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Zurück
          IconButton(
            onPressed: _currentIndex > 0
                ? () {
                    setState(() {
                      _currentIndex--;
                      _hasRecorded = false;
                    });
                  }
                : null,
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 32,
          ),

          // Überspringen
          TextButton(
            onPressed: () => _nextSymbol(),
            child: Text(
              'Überspringen',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          // Weiter
          IconButton(
            onPressed: () => _nextSymbol(),
            icon: Icon(
              _currentIndex == _allSymbols.length - 1
                  ? Icons.check_circle
                  : Icons.arrow_forward_ios,
            ),
            iconSize: 32,
            color: _currentIndex == _allSymbols.length - 1
                ? const Color(0xFF4CAF50)
                : null,
          ),
        ],
      ),
    );
  }

  void _nextSymbol() {
    if (_currentIndex < _allSymbols.length - 1) {
      setState(() {
        _currentIndex++;
        _hasRecorded = false;
      });
    } else {
      // Fertig - zeige Zusammenfassung
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.celebration, color: Color(0xFF4CAF50), size: 32),
            const SizedBox(width: 12),
            const Text('Super gemacht!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_recordedIds.length} von ${_allSymbols.length} Wörter aufgenommen',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: _recordedIds.length / _allSymbols.length,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
            ),
            const SizedBox(height: 8),
            Text(
              '${(_recordedIds.length / _allSymbols.length * 100).round()}%',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = 0;
                _hasRecorded = false;
              });
            },
            child: const Text('Mehr aufnehmen'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
            ),
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }
}

/// Aufnahme-Button
class _RecordButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onPressed;
  final bool isLarge;

  const _RecordButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onPressed,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 72.0 : 56.0;

    return GestureDetector(
      onTap: onPressed,
      child: Opacity(
        opacity: onPressed == null ? 0.4 : 1.0,
        child: Column(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 3),
              ),
              child: Icon(icon, color: color, size: isLarge ? 36 : 28),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
