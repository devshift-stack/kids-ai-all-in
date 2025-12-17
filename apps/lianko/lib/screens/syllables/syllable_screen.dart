import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/syllables/syllable_model.dart';
import '../../services/speech_training_service.dart';

/// Hauptscreen für Silben-Training
class SyllableScreen extends ConsumerWidget {
  const SyllableScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = SyllableData.getAll();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Silben-Training'),
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
                  'Wähle eine Schwierigkeit',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Lerne Wörter in Silben zu sprechen',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Kategorien
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
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

  void _openCategory(BuildContext context, SyllableCategory category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SyllablePracticeScreen(category: category),
      ),
    );
  }
}

/// Kategorie-Karte
class _CategoryCard extends StatelessWidget {
  final SyllableCategory category;
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${category.words.length} Wörter',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  // Schwierigkeits-Sterne
                  Row(
                    children: List.generate(
                      3,
                      (i) => Icon(
                        Icons.star,
                        size: 16,
                        color: i < category.difficulty
                            ? const Color(0xFFFFD700)
                            : Colors.grey[300],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Pfeil
            Icon(
              Icons.arrow_forward_ios,
              color: color,
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }
}

/// Übungs-Screen für eine Kategorie
class SyllablePracticeScreen extends ConsumerStatefulWidget {
  final SyllableCategory category;

  const SyllablePracticeScreen({
    super.key,
    required this.category,
  });

  @override
  ConsumerState<SyllablePracticeScreen> createState() => _SyllablePracticeScreenState();
}

class _SyllablePracticeScreenState extends ConsumerState<SyllablePracticeScreen> {
  int _currentIndex = 0;
  int _currentSyllable = 0;
  bool _showFullWord = false;
  int _completedWords = 0;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.category.colorValue);
    final word = widget.category.words[_currentIndex];

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
      body: Column(
        children: [
          // Fortschritt
          LinearProgressIndicator(
            value: (_currentIndex + 1) / widget.category.words.length,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(color),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Bild
                  Expanded(
                    flex: 2,
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
                          word.imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Container(
                            color: color.withOpacity(0.1),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image, size: 64, color: color.withOpacity(0.5)),
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
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Silben-Anzeige
                  _buildSyllableDisplay(word, color),

                  const SizedBox(height: 24),

                  // Buttons
                  _buildControls(word, color),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSyllableDisplay(SyllableWord word, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // Silben als klickbare Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: word.syllables.asMap().entries.map((entry) {
              final index = entry.key;
              final syllable = entry.value;
              final isActive = _showFullWord || index <= _currentSyllable;
              final isCurrent = !_showFullWord && index == _currentSyllable;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: GestureDetector(
                  onTap: () => _speakSyllable(syllable),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrent
                          ? color
                          : isActive
                              ? color.withOpacity(0.2)
                              : Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: isCurrent
                          ? Border.all(color: color, width: 3)
                          : null,
                    ),
                    child: Text(
                      syllable,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isCurrent
                            ? Colors.white
                            : isActive
                                ? color
                                : Colors.grey[400],
                      ),
                    ),
                  ),
                )
                    .animate(
                      target: isCurrent ? 1 : 0,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 300.ms,
                    ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Klatsch-Anzeige (Hände für jede Silbe)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              word.syllableCount,
              (index) {
                final isActive = index <= _currentSyllable;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '👏',
                    style: TextStyle(
                      fontSize: 32,
                      color: isActive ? null : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                )
                    .animate(
                      target: index == _currentSyllable && !_showFullWord ? 1 : 0,
                    )
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.3, 1.3),
                      duration: 200.ms,
                      curve: Curves.elasticOut,
                    );
              },
            ),
          ),

          // Vollständiges Wort
          if (_showFullWord)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                word.word,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ).animate().fadeIn().scale(),
        ],
      ),
    );
  }

  Widget _buildControls(SyllableWord word, Color color) {
    final service = ref.read(speechTrainingServiceProvider);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Hören (aktuelle Silbe oder ganzes Wort)
        _ControlButton(
          icon: Icons.volume_up,
          label: _showFullWord ? 'Wort hören' : 'Silbe hören',
          color: Colors.blue,
          onTap: () {
            if (_showFullWord) {
              service.speakWord(word.word);
            } else {
              _speakSyllable(word.syllables[_currentSyllable]);
            }
          },
        ),

        // Weiter (nächste Silbe oder ganzes Wort)
        _ControlButton(
          icon: _showFullWord ? Icons.arrow_forward : Icons.arrow_downward,
          label: _showFullWord ? 'Weiter' : 'Nächste',
          color: color,
          isLarge: true,
          onTap: () {
            if (_showFullWord) {
              // Nächstes Wort
              _nextWord();
            } else if (_currentSyllable < word.syllableCount - 1) {
              // Nächste Silbe
              setState(() => _currentSyllable++);
              _speakSyllable(word.syllables[_currentSyllable]);
            } else {
              // Alle Silben durch - zeige ganzes Wort
              setState(() => _showFullWord = true);
              service.speakWord(word.word);
            }
          },
        ),

        // Alle auf einmal
        _ControlButton(
          icon: Icons.fast_forward,
          label: 'Alles',
          color: Colors.orange,
          onTap: () => _playAllSyllables(word, service),
        ),
      ],
    );
  }

  void _speakSyllable(String syllable) {
    final service = ref.read(speechTrainingServiceProvider);
    service.speakWord(syllable);
  }

  Future<void> _playAllSyllables(SyllableWord word, SpeechTrainingService service) async {
    // Spiele alle Silben nacheinander ab
    for (int i = 0; i < word.syllableCount; i++) {
      setState(() => _currentSyllable = i);
      await service.speakWord(word.syllables[i]);
      await Future.delayed(const Duration(milliseconds: 300));
    }

    // Dann das ganze Wort
    setState(() => _showFullWord = true);
    await Future.delayed(const Duration(milliseconds: 500));
    await service.speakWord(word.word);
  }

  void _nextWord() {
    if (_currentIndex < widget.category.words.length - 1) {
      setState(() {
        _currentIndex++;
        _currentSyllable = 0;
        _showFullWord = false;
        _completedWords++;
      });
    } else {
      // Alle Wörter geschafft
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Text('🎉', style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Text('Geschafft!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Du hast alle ${widget.category.words.length} Wörter geübt!',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => const Icon(
                  Icons.star,
                  color: Color(0xFFFFD700),
                  size: 40,
                ),
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
                _currentSyllable = 0;
                _showFullWord = false;
              });
            },
            child: const Text('Nochmal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(widget.category.colorValue),
            ),
            child: const Text('Fertig'),
          ),
        ],
      ),
    );
  }
}

/// Control Button
class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isLarge;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = isLarge ? 72.0 : 56.0;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
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
    );
  }
}
