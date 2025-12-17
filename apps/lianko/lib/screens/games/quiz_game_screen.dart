import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/communication/communication_model.dart';
import '../../services/child_recording_service.dart';
import '../../services/child_settings_service.dart';
import '../../services/speech_training_service.dart';

/// Rätsel-Spiel basierend auf den aufgenommenen Wörtern
/// Kind hört ein Wort (eigene Aufnahme oder TTS) und muss das richtige Bild auswählen
class QuizGameScreen extends ConsumerStatefulWidget {
  const QuizGameScreen({super.key});

  @override
  ConsumerState<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends ConsumerState<QuizGameScreen> {
  final Random _random = Random();

  List<CommunicationSymbol> _allSymbols = [];
  List<CommunicationSymbol> _currentOptions = [];
  CommunicationSymbol? _correctAnswer;

  int _score = 0;
  int _totalQuestions = 0;
  int _streak = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _loadSymbols();
  }

  void _loadSymbols() {
    _allSymbols = [];

    // Alle Symbole aus allen Kategorien sammeln
    for (final category in CommunicationData.getAll()) {
      for (final symbol in category.symbols) {
        _allSymbols.add(symbol);
        if (symbol.subOptions != null) {
          _allSymbols.addAll(symbol.subOptions!);
        }
      }
    }

    // Erstes Rätsel generieren
    _generateNewQuestion();
  }

  void _generateNewQuestion() {
    if (_allSymbols.length < 3) return;

    // Mische alle Symbole
    final shuffled = List<CommunicationSymbol>.from(_allSymbols)..shuffle(_random);

    // Wähle 3-4 zufällige Optionen
    final optionCount = _random.nextBool() ? 3 : 4;
    _currentOptions = shuffled.take(optionCount).toList();

    // Wähle eine als richtige Antwort
    _correctAnswer = _currentOptions[_random.nextInt(_currentOptions.length)];

    setState(() {
      _hasAnswered = false;
      _isCorrect = false;
    });

    // Automatisch abspielen nach kurzer Verzögerung
    Future.delayed(const Duration(milliseconds: 500), _playCurrentWord);
  }

  Future<void> _playCurrentWord() async {
    if (_correctAnswer == null || _isPlaying) return;

    setState(() => _isPlaying = true);

    final settings = ref.read(currentChildSettingsProvider);
    final recordingService = ref.read(childRecordingServiceProvider);
    final speechService = ref.read(speechTrainingServiceProvider);

    // Prüfe ob Kind-Aufnahme vorhanden und aktiviert
    final hasRecording = await recordingService.hasRecording(_correctAnswer!.id);

    if (hasRecording && settings.useChildRecordings) {
      // Kind-Aufnahme abspielen
      await recordingService.playRecording(_correctAnswer!.id, _correctAnswer!.word);
    } else {
      // TTS abspielen
      await speechService.speakWord(_correctAnswer!.word);
    }

    setState(() => _isPlaying = false);
  }

  void _checkAnswer(CommunicationSymbol selected) {
    if (_hasAnswered) return;

    final correct = selected.id == _correctAnswer?.id;

    setState(() {
      _hasAnswered = true;
      _isCorrect = correct;
      _totalQuestions++;

      if (correct) {
        _score++;
        _streak++;
      } else {
        _streak = 0;
      }
    });

    // Feedback Sound/Vibration
    if (correct) {
      // TODO: Erfolgs-Sound
    } else {
      // TODO: Fehler-Sound
    }

    // Nächste Frage nach Verzögerung
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _generateNewQuestion();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_correctAnswer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Rätsel-Spiel'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          // Score anzeigen
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
                  const Icon(Icons.star, color: Color(0xFFFFD700), size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '$_score',
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
      body: Column(
        children: [
          // Streak-Anzeige
          if (_streak >= 3)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFFFFD700).withOpacity(0.2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    '$_streak richtig hintereinander!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9800),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: -0.5, end: 0),

          // Anweisung
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _hasAnswered
                      ? (_isCorrect ? 'Richtig! 🎉' : 'Das war: ${_correctAnswer!.word}')
                      : 'Welches Bild hörst du?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _hasAnswered
                        ? (_isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFE53935))
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Nochmal hören Button
                ElevatedButton.icon(
                  onPressed: _isPlaying ? null : _playCurrentWord,
                  icon: Icon(_isPlaying ? Icons.volume_up : Icons.replay),
                  label: Text(_isPlaying ? 'Spielt...' : 'Nochmal hören'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                  ),
                ),
              ],
            ),
          ),

          // Bilder-Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _currentOptions.length <= 3 ? 2 : 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                itemCount: _currentOptions.length,
                itemBuilder: (context, index) {
                  final symbol = _currentOptions[index];
                  final isCorrectAnswer = symbol.id == _correctAnswer?.id;
                  final showResult = _hasAnswered;

                  return _QuizOptionCard(
                    symbol: symbol,
                    index: index,
                    isSelected: showResult && isCorrectAnswer,
                    isCorrect: isCorrectAnswer,
                    showResult: showResult,
                    onTap: () => _checkAnswer(symbol),
                  );
                },
              ),
            ),
          ),

          // Statistik
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StatItem(label: 'Richtig', value: '$_score', color: const Color(0xFF4CAF50)),
                _StatItem(label: 'Gesamt', value: '$_totalQuestions', color: Colors.grey),
                _StatItem(
                  label: 'Quote',
                  value: _totalQuestions > 0
                      ? '${(_score / _totalQuestions * 100).round()}%'
                      : '-',
                  color: const Color(0xFF2196F3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Option-Karte im Quiz
class _QuizOptionCard extends StatelessWidget {
  final CommunicationSymbol symbol;
  final int index;
  final bool isSelected;
  final bool isCorrect;
  final bool showResult;
  final VoidCallback onTap;

  const _QuizOptionCard({
    required this.symbol,
    required this.index,
    required this.isSelected,
    required this.isCorrect,
    required this.showResult,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.transparent;
    Color bgColor = Colors.white;

    if (showResult) {
      if (isCorrect) {
        borderColor = const Color(0xFF4CAF50);
        bgColor = const Color(0xFF4CAF50).withOpacity(0.1);
      } else if (isSelected) {
        borderColor = const Color(0xFFE53935);
        bgColor = const Color(0xFFE53935).withOpacity(0.1);
      }
    }

    return GestureDetector(
      onTap: showResult ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: borderColor,
            width: showResult ? 4 : 0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Bild
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                symbol.imageAsset,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        symbol.word,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Ergebnis-Overlay
            if (showResult && isCorrect)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 24),
                ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
              ),

            if (showResult && !isCorrect && isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ).animate().shake(),
              ),

            // Wort anzeigen nach Antwort
            if (showResult)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  ),
                  child: Text(
                    symbol.word,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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

/// Statistik-Item
class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
