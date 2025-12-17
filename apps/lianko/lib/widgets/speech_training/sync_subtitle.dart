import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/speech_training_service.dart';
import '../../services/child_settings_service.dart';

/// Synchrone Untertitel - hebt das aktuell gesprochene Wort hervor
class SyncSubtitle extends ConsumerWidget {
  final double fontSize;
  final Color activeColor;
  final Color inactiveColor;

  const SyncSubtitle({
    super.key,
    this.fontSize = 32.0,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleAsync = ref.watch(subtitleProvider);
    final currentWordAsync = ref.watch(currentWordProvider);

    final subtitle = subtitleAsync.valueOrNull ?? '';
    final currentWord = currentWordAsync.valueOrNull ?? '';

    if (subtitle.isEmpty) return const SizedBox.shrink();

    final words = subtitle.split(' ');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: words.map((word) {
          final isActive = word.toLowerCase() == currentWord.toLowerCase();

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? activeColor.withOpacity(0.3) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isActive
                  ? Border.all(color: activeColor, width: 2)
                  : null,
            ),
            child: Text(
              word,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? activeColor : inactiveColor,
              ),
            ),
          );
        }).toList(),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.2, end: 0, duration: 300.ms);
  }
}

/// Große Untertitel-Anzeige für den Hauptbereich
/// Nur sichtbar wenn Eltern es im Parent Dashboard aktiviert haben
class LargeSubtitleDisplay extends ConsumerWidget {
  const LargeSubtitleDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prüfe ob Untertitel aktiviert sind (default: AUS)
    final settings = ref.watch(currentChildSettingsProvider);
    if (!settings.subtitlesEnabled) return const SizedBox.shrink();

    final subtitleAsync = ref.watch(subtitleProvider);
    final stateAsync = ref.watch(speechTrainingStateProvider);

    final subtitle = subtitleAsync.valueOrNull ?? '';
    final state = stateAsync.valueOrNull ?? SpeechTrainingState.idle;

    if (subtitle.isEmpty) return const SizedBox.shrink();

    // Verschiedene Farben je nach State
    Color bgColor;
    IconData icon;
    String label;

    switch (state) {
      case SpeechTrainingState.speaking:
        bgColor = const Color(0xFF2196F3); // Blau - Lianko spricht
        icon = Icons.volume_up;
        label = 'Hör zu:';
        break;
      case SpeechTrainingState.listening:
        bgColor = const Color(0xFF4CAF50); // Grün - Kind spricht
        icon = Icons.mic;
        label = 'Sprich nach:';
        break;
      case SpeechTrainingState.processing:
        bgColor = const Color(0xFFFF9800); // Orange - Verarbeitung
        icon = Icons.hourglass_empty;
        label = 'Moment...';
        break;
      case SpeechTrainingState.feedback:
        bgColor = const Color(0xFF9C27B0); // Lila - Feedback
        icon = Icons.star;
        label = '';
        break;
      default:
        bgColor = const Color(0xFF607D8B); // Grau - Idle
        icon = Icons.chat_bubble;
        label = '';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, bgColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: bgColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status-Icon und Label
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 28)
                  .animate(
                    onPlay: (c) => state == SpeechTrainingState.listening
                        ? c.repeat()
                        : c.forward(),
                  )
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    duration: 500.ms,
                  )
                  .then()
                  .scale(
                    begin: const Offset(1.2, 1.2),
                    end: const Offset(1, 1),
                    duration: 500.ms,
                  ),
              if (label.isNotEmpty) ...[
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          // Haupt-Text
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1), duration: 300.ms);
  }
}
