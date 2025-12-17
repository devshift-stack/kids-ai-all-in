import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/stories/story_model.dart';

/// Karte für eine Geschichte in der Auswahl-Liste
class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final int index;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    this.index = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover Bild
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  story.coverImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: _getCategoryColor(story.category).withOpacity(0.2),
                    child: Icon(
                      _getCategoryIcon(story.category),
                      size: 48,
                      color: _getCategoryColor(story.category),
                    ),
                  ),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategorie Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(story.category).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getCategoryName(story.category),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(story.category),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Titel
                    Text(
                      story.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Seiten-Anzahl und Alter
                    Row(
                      children: [
                        Icon(Icons.auto_stories, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${story.pages.length} Seiten',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.child_care, size: 16, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Text(
                          '${story.minAge}-${story.maxAge} Jahre',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Pfeil
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Icon(
                Icons.play_circle_fill,
                size: 40,
                color: _getCategoryColor(story.category),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 100))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.2, end: 0);
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'tiere': return const Color(0xFF4CAF50);
      case 'familie': return const Color(0xFFE91E63);
      case 'abenteuer': return const Color(0xFF2196F3);
      case 'alltag': return const Color(0xFFFF9800);
      default: return const Color(0xFF9C27B0);
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'tiere': return Icons.pets;
      case 'familie': return Icons.family_restroom;
      case 'abenteuer': return Icons.explore;
      case 'alltag': return Icons.home;
      default: return Icons.auto_stories;
    }
  }

  String _getCategoryName(String category) {
    switch (category) {
      case 'tiere': return 'Tiere';
      case 'familie': return 'Familie';
      case 'abenteuer': return 'Abenteuer';
      case 'alltag': return 'Alltag';
      default: return category;
    }
  }
}
