import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/stories/story_model.dart';
import '../../widgets/stories/story_card.dart';
import '../../widgets/stories/story_reader.dart';

/// Screen zur Auswahl einer Geschichte
class StoriesScreen extends ConsumerWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stories = SampleStories.getAll();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Geschichten'),
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
                  'Wähle eine Geschichte',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hör zu und sprich die Wörter nach',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          // Kategorie Filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildCategoryChip('Alle', null, true),
                _buildCategoryChip('Tiere', 'tiere', false),
                _buildCategoryChip('Familie', 'familie', false),
                _buildCategoryChip('Abenteuer', 'abenteuer', false),
                _buildCategoryChip('Alltag', 'alltag', false),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Story Liste
          Expanded(
            child: stories.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 24),
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return StoryCard(
                        story: story,
                        index: index,
                        onTap: () => _openStory(context, story),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, String? category, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) {
          // TODO: Filter implementieren
        },
        backgroundColor: Colors.white,
        selectedColor: const Color(0xFF4CAF50).withOpacity(0.2),
        checkmarkColor: const Color(0xFF4CAF50),
        labelStyle: TextStyle(
          color: isSelected ? const Color(0xFF4CAF50) : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_stories, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Keine Geschichten verfügbar',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  void _openStory(BuildContext context, Story story) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryReader(
          story: story,
          onComplete: () {
            // TODO: Belohnung geben
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Geschichte geschafft! 🌟'),
                backgroundColor: Color(0xFF4CAF50),
              ),
            );
          },
        ),
      ),
    );
  }
}
