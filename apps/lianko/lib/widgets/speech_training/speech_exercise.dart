import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/speech_training_service.dart';
import 'sync_subtitle.dart';

/// Komplette Sprechübung-Komponente
/// Zeigt Wort, spielt vor, nimmt auf, gibt Feedback
class SpeechExercise extends ConsumerStatefulWidget {
  final String word;
  final String? imageUrl;
  final VoidCallback? onComplete;
  final VoidCallback? onSkip;

  const SpeechExercise({
    super.key,
    required this.word,
    this.imageUrl,
    this.onComplete,
    this.onSkip,
  });

  @override
  ConsumerState<SpeechExercise> createState() => _SpeechExerciseState();
}

class _SpeechExerciseState extends ConsumerState<SpeechExercise> {
  bool _hasStarted = false;
  SpeechResult? _lastResult;

  @override
  Widget build(BuildContext context) {
    final stateAsync = ref.watch(speechTrainingStateProvider);
    final state = stateAsync.valueOrNull ?? SpeechTrainingState.idle;

    // Ergebnis-Listener
    ref.listen<AsyncValue<SpeechResult>>(speechResultProvider, (prev, next) {
      next.whenData((result) {
        setState(() => _lastResult = result);
      });
    });

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Bild (falls vorhanden)
          if (widget.imageUrl != null)
            Container(
              width: 200,
              height: 200,
              margin: const EdgeInsets.only(bottom: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  widget.imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 64, color: Colors.grey),
                  ),
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 500.ms)
                .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),

          // Untertitel-Anzeige
          const LargeSubtitleDisplay(),

          const SizedBox(height: 32),

          // Status-Anzeige mit Animation
          _buildStatusIndicator(state),

          const SizedBox(height: 32),

          // Feedback-Anzeige (falls vorhanden)
          if (_lastResult != null && state == SpeechTrainingState.feedback)
            _buildFeedbackCard(_lastResult!),

          const SizedBox(height: 32),

          // Action-Buttons
          _buildActionButtons(state),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(SpeechTrainingState state) {
    switch (state) {
      case SpeechTrainingState.speaking:
        return _buildPulsingIndicator(
          icon: Icons.volume_up,
          color: const Color(0xFF2196F3),
          label: 'Lianko spricht...',
        );
      case SpeechTrainingState.listening:
        return _buildPulsingIndicator(
          icon: Icons.mic,
          color: const Color(0xFF4CAF50),
          label: 'Jetzt du!',
        );
      case SpeechTrainingState.processing:
        return _buildPulsingIndicator(
          icon: Icons.hourglass_empty,
          color: const Color(0xFFFF9800),
          label: 'Moment...',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildPulsingIndicator({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 40),
        )
            .animate(onPlay: (c) => c.repeat())
            .scale(
              begin: const Offset(1, 1),
              end: const Offset(1.15, 1.15),
              duration: 600.ms,
            )
            .then()
            .scale(
              begin: const Offset(1.15, 1.15),
              end: const Offset(1, 1),
              duration: 600.ms,
            ),
        const SizedBox(height: 16),
        Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackCard(SpeechResult result) {
    final color = result.isCorrect
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF9800);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Column(
        children: [
          Icon(
            result.isCorrect ? Icons.check_circle : Icons.refresh,
            color: color,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            result.feedback,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          if (!result.isCorrect && result.spokenWord.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Du hast gesagt: "${result.spokenWord}"',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  Widget _buildActionButtons(SpeechTrainingState state) {
    final service = ref.read(speechTrainingServiceProvider);

    // Während aktiver Übung keine Buttons
    if (state == SpeechTrainingState.speaking ||
        state == SpeechTrainingState.listening ||
        state == SpeechTrainingState.processing) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Skip-Button
        if (widget.onSkip != null)
          OutlinedButton.icon(
            onPressed: widget.onSkip,
            icon: const Icon(Icons.skip_next),
            label: const Text('Überspringen'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),

        const SizedBox(width: 16),

        // Start/Wiederholen-Button
        ElevatedButton.icon(
          onPressed: () async {
            setState(() {
              _hasStarted = true;
              _lastResult = null;
            });
            await service.speakAndListen(widget.word);

            // Nach Feedback: onComplete aufrufen wenn erfolgreich
            if (_lastResult?.isCorrect == true) {
              widget.onComplete?.call();
            }
          },
          icon: Icon(_hasStarted ? Icons.refresh : Icons.play_arrow),
          label: Text(_hasStarted ? 'Nochmal' : 'Start'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4CAF50),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),

        // Nur Anhören-Button
        if (_hasStarted) ...[
          const SizedBox(width: 16),
          OutlinedButton.icon(
            onPressed: () => service.speakWord(widget.word),
            icon: const Icon(Icons.hearing),
            label: const Text('Nur hören'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            ),
          ),
        ],
      ],
    );
  }
}

/// Übungsliste für mehrere Wörter
class SpeechExerciseList extends ConsumerStatefulWidget {
  final List<String> words;
  final List<String>? imageUrls;
  final VoidCallback? onAllComplete;

  const SpeechExerciseList({
    super.key,
    required this.words,
    this.imageUrls,
    this.onAllComplete,
  });

  @override
  ConsumerState<SpeechExerciseList> createState() => _SpeechExerciseListState();
}

class _SpeechExerciseListState extends ConsumerState<SpeechExerciseList> {
  int _currentIndex = 0;
  int _correctCount = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.words.length) {
      return _buildCompletionScreen();
    }

    return Column(
      children: [
        // Fortschritt
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                'Wort ${_currentIndex + 1} von ${widget.words.length}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const Spacer(),
              Text(
                '$_correctCount richtig',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Fortschrittsbalken
        LinearProgressIndicator(
          value: _currentIndex / widget.words.length,
          backgroundColor: Colors.grey[300],
          valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
        ),

        // Aktuelle Übung
        Expanded(
          child: SpeechExercise(
            word: widget.words[_currentIndex],
            imageUrl: widget.imageUrls?.elementAtOrNull(_currentIndex),
            onComplete: () {
              setState(() {
                _correctCount++;
                _currentIndex++;
              });
              if (_currentIndex >= widget.words.length) {
                widget.onAllComplete?.call();
              }
            },
            onSkip: () {
              setState(() => _currentIndex++);
              if (_currentIndex >= widget.words.length) {
                widget.onAllComplete?.call();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionScreen() {
    final percentage = (_correctCount / widget.words.length * 100).round();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            percentage >= 80 ? Icons.emoji_events : Icons.star,
            size: 100,
            color: percentage >= 80 ? Colors.amber : const Color(0xFF4CAF50),
          )
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            'Geschafft!',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$_correctCount von ${widget.words.length} richtig',
            style: const TextStyle(fontSize: 24),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
                _correctCount = 0;
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Nochmal üben'),
          ),
        ],
      ),
    );
  }
}
