import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../services/age_adaptive_service.dart';

/// Child Dashboard Screen (v0-kids-ai-ui Design)
class ChildDashboardScreen extends ConsumerWidget {
  const ChildDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageService = ref.read(ageAdaptiveServiceProvider);
    final childName = ageService.getChildName() ?? 'Prijatelju';

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: KidsGradients.mainBackground,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Navigation (transparent)
              ModernNavBar(
                title: 'Kids AI',
                isTransparent: true,
                actions: [
                  NavButton(
                    icon: Icons.home,
                    onTap: () {},
                    isTransparent: true,
                  ),
                  NavButton(
                    icon: Icons.bar_chart,
                    onTap: () {
                      // Navigate to progress page
                    },
                    isTransparent: true,
                  ),
                  NavButton(
                    icon: Icons.logout,
                    onTap: () {
                      // Logout
                    },
                    isTransparent: true,
                  ),
                ],
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(childName),
                      const SizedBox(height: 32),
                      // Progress Overview
                      _buildProgressOverview(),
                      const SizedBox(height: 32),
                      // Learning Activities
                      _buildLearningActivities(),
                      const SizedBox(height: 32),
                      // Today's Challenges
                      _buildChallenges(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String childName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Zdravo, $childName! 👋',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Hajde da danas naučimo nešto novo!',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressOverview() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tvoj napredak',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: KidsColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: KidsColors.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '245',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: KidsColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const ModernProgress(
            value: 0.68,
            height: 12,
            color: KidsColors.primary,
            animated: true,
          ),
          const SizedBox(height: 8),
          const Text(
            '68% nivoa 5 završeno!',
            style: TextStyle(
              fontSize: 14,
              color: KidsColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLearningActivities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Aktivnosti učenja',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1024
                ? 4
                : constraints.maxWidth > 640
                    ? 2
                    : 1;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.9,
              children: [
                ActivityCard(
                  icon: const Icon(Icons.menu_book, size: 32, color: Colors.white),
                  title: 'Čitanje',
                  progress: 0.75,
                  color: const Color(0xFF2196F3), // bg-blue-500
                ),
                ActivityCard(
                  icon: const Icon(Icons.music_note, size: 32, color: Colors.white),
                  title: 'Muzika',
                  progress: 0.45,
                  color: const Color(0xFF9C27B0), // bg-purple-500
                ),
                ActivityCard(
                  icon: const Icon(Icons.palette, size: 32, color: Colors.white),
                  title: 'Umjetnost',
                  progress: 0.60,
                  color: const Color(0xFFE91E63), // bg-pink-500
                ),
                ActivityCard(
                  icon: const Icon(Icons.sports_esports, size: 32, color: Colors.white),
                  title: 'Igre',
                  progress: 0.90,
                  color: const Color(0xFF4CAF50), // bg-green-500
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildChallenges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Današnji izazovi',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 768 ? 2 : 1;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [
                ChallengeCard(
                  title: 'Učenje riječi',
                  description: 'Nauči 5 novih riječi danas',
                  reward: 20,
                  completed: 3,
                  total: 5,
                ),
                ChallengeCard(
                  title: 'Slušanje priče',
                  description: 'Poslušaj priču do kraja',
                  reward: 30,
                  completed: 0,
                  total: 1,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

