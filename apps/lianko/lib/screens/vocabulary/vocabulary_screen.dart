import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/vocabulary/vocabulary_model.dart';
import '../../services/speech_training_service.dart';
import '../../widgets/speech_training/speech_exercise.dart';

/// Hauptscreen für Wortschatz-Übungen
class VocabularyScreen extends ConsumerWidget {
  const VocabularyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = VocabularyData.getAll();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Wortschatz'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Wähle eine Kategorie',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lerne neue Wörter mit Bildern',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Kategorien Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
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

  void _openCategory(BuildContext context, VocabularyCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VocabularyCategoryScreen(category: category),
      ),
    );
  }
}

/// Karte für eine Kategorie
class _CategoryCard extends StatelessWidget {
  final VocabularyCategory category;
  final int index;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(category.color.value);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon/Emoji
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Name
            Text(
              category.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            // Anzahl Wörter
            Text(
              '${category.words.length} Wörter',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

/// Screen für eine einzelne Kategorie
class VocabularyCategoryScreen extends ConsumerStatefulWidget {
  final VocabularyCategory category;

  const VocabularyCategoryScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<VocabularyCategoryScreen> createState() => _VocabularyCategoryScreenState();
}

class _VocabularyCategoryScreenState extends ConsumerState<VocabularyCategoryScreen> {
  int _currentIndex = 0;
  int _correctCount = 0;
  bool _showExercise = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.category.color.value);
    final word = widget.category.words[_currentIndex];

    if (_currentIndex >= widget.category.words.length) {
      return _buildCompletionScreen(color);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text(widget.category.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text(
                '${_currentIndex + 1}/${widget.category.words.length}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: _showExercise
          ? _buildExerciseView(word)
          : _buildWordCard(word, color),
    );
  }

  Widget _buildWordCard(VocabularyWord word, Color color) {
    final service = ref.read(speechTrainingServiceProvider);

    return Column(
      children: [
        // Fortschritt
        LinearProgressIndicator(
          value: _currentIndex / widget.category.words.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation(color),
        ),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Bild
                Expanded(
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        word.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Container(
                          color: color.withOpacity(0.1),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 80, color: color.withOpacity(0.5)),
                              const SizedBox(height: 8),
                              Text(
                                word.word,
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                ),

                const SizedBox(height: 24),

                // Wort
                Text(
                  word.word,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 200.ms),

                const SizedBox(height: 32),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Nur hören
                    _buildActionButton(
                      icon: Icons.volume_up,
                      label: 'Hören',
                      color: Colors.blue,
                      onTap: () => service.speakWord(word.word),
                    ),

                    // Üben
                    _buildActionButton(
                      icon: Icons.mic,
                      label: 'Üben',
                      color: color,
                      onTap: () => setState(() => _showExercise = true),
                    ),

                    // Weiter
                    _buildActionButton(
                      icon: Icons.arrow_forward,
                      label: 'Weiter',
                      color: Colors.grey,
                      onTap: _nextWord,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseView(VocabularyWord word) {
    return SpeechExercise(
      word: word.word,
      imageUrl: word.imageUrl,
      onComplete: () {
        setState(() {
          _correctCount++;
          _showExercise = false;
        });
        _nextWord();
      },
      onSkip: () {
        setState(() => _showExercise = false);
        _nextWord();
      },
    );
  }

  void _nextWord() {
    setState(() {
      if (_currentIndex < widget.category.words.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = widget.category.words.length; // Trigger completion
      }
    });
  }

  Widget _buildCompletionScreen(Color color) {
    final percentage = (_correctCount / widget.category.words.length * 100).round();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              percentage >= 80 ? Icons.emoji_events : Icons.star,
              size: 100,
              color: percentage >= 80 ? Colors.amber : color,
            )
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut),

            const SizedBox(height: 24),

            Text(
              'Kategorie geschafft!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              '$_correctCount von ${widget.category.words.length} richtig',
              style: const TextStyle(fontSize: 20),
            ),

            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                      _correctCount = 0;
                    });
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Nochmal'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.check),
                  label: const Text('Fertig'),
                  style: ElevatedButton.styleFrom(backgroundColor: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
