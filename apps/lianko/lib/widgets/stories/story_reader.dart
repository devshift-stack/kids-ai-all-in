import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/stories/story_model.dart';
import '../../services/speech_training_service.dart';
import '../../services/child_settings_service.dart';

/// Story Reader - Zeigt Geschichte mit Bildern, liest vor, ermöglicht Nachsprechen
class StoryReader extends ConsumerStatefulWidget {
  final Story story;
  final VoidCallback? onComplete;

  const StoryReader({
    super.key,
    required this.story,
    this.onComplete,
  });

  @override
  ConsumerState<StoryReader> createState() => _StoryReaderState();
}

class _StoryReaderState extends ConsumerState<StoryReader> {
  int _currentPage = 0;
  bool _isReading = false;
  bool _showRepeatOption = false;

  @override
  Widget build(BuildContext context) {
    final page = widget.story.pages[_currentPage];
    final settings = ref.watch(currentChildSettingsProvider);
    final stateAsync = ref.watch(speechTrainingStateProvider);
    final state = stateAsync.valueOrNull ?? SpeechTrainingState.idle;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header mit Fortschritt
            _buildHeader(),

            // Bild
            Expanded(
              flex: 3,
              child: _buildImage(page),
            ),

            // Text-Bereich
            Expanded(
              flex: 2,
              child: _buildTextArea(page, settings, state),
            ),

            // Navigation
            _buildNavigation(state),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  widget.story.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: (_currentPage + 1) / widget.story.pages.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF4CAF50)),
                ),
                Text(
                  'Seite ${_currentPage + 1} von ${widget.story.pages.length}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(width: 48), // Balance für Close-Button
        ],
      ),
    );
  }

  Widget _buildImage(StoryPage page) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
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
          page.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: Colors.grey[200],
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.image, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 8),
                Text(
                  'Bild: ${page.imageUrl.split('/').last}',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  Widget _buildTextArea(StoryPage page, ChildSettings settings, SpeechTrainingState state) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text mit hervorgehobenem Wort
          _buildStoryText(page),

          const SizedBox(height: 16),

          // Nachsprech-Option (wenn highlightWord vorhanden)
          if (page.highlightWord != null && _showRepeatOption)
            _buildRepeatSection(page, state),

          // Untertitel (wenn aktiviert)
          if (settings.subtitlesEnabled && _isReading)
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.volume_up, color: Colors.blue, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Wird vorgelesen...',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStoryText(StoryPage page) {
    if (page.highlightWord == null) {
      return Text(
        page.text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 24,
          height: 1.5,
        ),
      );
    }

    // Text mit hervorgehobenem Wort
    final parts = page.text.split(page.highlightWord!);

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 24,
          height: 1.5,
          color: Colors.black87,
        ),
        children: [
          if (parts.isNotEmpty) TextSpan(text: parts[0]),
          TextSpan(
            text: page.highlightWord,
            style: const TextStyle(
              color: Color(0xFF4CAF50),
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildRepeatSection(StoryPage page, SpeechTrainingState state) {
    final service = ref.read(speechTrainingServiceProvider);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            'Sprich nach: "${page.highlightWord}"',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Nur hören
              OutlinedButton.icon(
                onPressed: state == SpeechTrainingState.idle
                    ? () => service.speakWord(page.highlightWord!)
                    : null,
                icon: const Icon(Icons.volume_up),
                label: const Text('Hören'),
              ),
              const SizedBox(width: 12),
              // Nachsprechen
              ElevatedButton.icon(
                onPressed: state == SpeechTrainingState.idle
                    ? () => service.speakAndListen(page.highlightWord!)
                    : null,
                icon: const Icon(Icons.mic),
                label: const Text('Nachsprechen'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildNavigation(SpeechTrainingState state) {
    final service = ref.read(speechTrainingServiceProvider);
    final isFirstPage = _currentPage == 0;
    final isLastPage = _currentPage == widget.story.pages.length - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Zurück
          IconButton(
            onPressed: isFirstPage
                ? null
                : () {
                    setState(() {
                      _currentPage--;
                      _showRepeatOption = false;
                    });
                  },
            icon: const Icon(Icons.arrow_back_ios),
            iconSize: 32,
            color: isFirstPage ? Colors.grey[300] : Colors.grey[700],
          ),

          // Vorlesen Button
          ElevatedButton.icon(
            onPressed: state == SpeechTrainingState.idle
                ? () async {
                    final page = widget.story.pages[_currentPage];
                    setState(() => _isReading = true);
                    await service.speakWord(page.text);
                    setState(() {
                      _isReading = false;
                      if (page.highlightWord != null) {
                        _showRepeatOption = true;
                      }
                    });
                  }
                : null,
            icon: Icon(_isReading ? Icons.stop : Icons.play_arrow),
            label: Text(_isReading ? 'Stopp' : 'Vorlesen'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),

          // Weiter / Fertig
          IconButton(
            onPressed: () {
              if (isLastPage) {
                widget.onComplete?.call();
                Navigator.of(context).pop();
              } else {
                setState(() {
                  _currentPage++;
                  _showRepeatOption = false;
                });
              }
            },
            icon: Icon(isLastPage ? Icons.check_circle : Icons.arrow_forward_ios),
            iconSize: 32,
            color: isLastPage ? const Color(0xFF4CAF50) : Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
