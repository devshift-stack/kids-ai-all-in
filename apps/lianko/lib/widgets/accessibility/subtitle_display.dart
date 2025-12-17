import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/lianko_visual_service.dart';

/// Großes, gut lesbares Untertitel-Widget für schwerhörige Kinder
class SubtitleDisplay extends ConsumerWidget {
  final double fontSize;
  final EdgeInsets padding;
  final bool showBackground;

  const SubtitleDisplay({
    super.key,
    this.fontSize = 28.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subtitleAsync = ref.watch(liankoSubtitleProvider);
    final feedbackAsync = ref.watch(liankoFeedbackProvider);

    return subtitleAsync.when(
      data: (subtitle) {
        if (subtitle.isEmpty) return const SizedBox.shrink();

        final feedback = feedbackAsync.valueOrNull;
        final primaryColor = feedback?.primaryColor ?? Colors.blue;
        final secondaryColor = feedback?.secondaryColor ?? Colors.lightBlue;

        return Container(
          margin: const EdgeInsets.all(16),
          padding: padding,
          decoration: showBackground
              ? BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryColor.withOpacity(0.9),
                      secondaryColor.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (feedback?.icon != null) ...[
                Icon(
                  feedback!.icon,
                  size: fontSize + 8,
                  color: Colors.white,
                )
                    .animate(onPlay: (c) => c.repeat())
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
                const SizedBox(width: 16),
              ],
              Flexible(
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 300.ms)
            .slideY(begin: 0.3, end: 0, duration: 300.ms);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Permanentes Untertitel-Overlay für den unteren Bildschirmrand
class SubtitleOverlay extends ConsumerWidget {
  const SubtitleOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: const SubtitleDisplay(),
        ),
      ),
    );
  }
}
