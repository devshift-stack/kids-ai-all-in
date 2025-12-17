import 'package:flutter/material.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';

/// Child Progress Screen (v0-kids-ai-ui Design)
class ChildProgressScreen extends StatelessWidget {
  const ChildProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    onTap: () {
                      Navigator.pop(context);
                    },
                    isTransparent: true,
                  ),
                  NavButton(
                    icon: Icons.bar_chart,
                    onTap: () {},
                    isTransparent: true,
                  ),
                  NavButton(
                    icon: Icons.logout,
                    onTap: () {},
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
                      const Text(
                        'Tvoji uspjesi 🏆',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Stats Overview
                      _buildStatsOverview(),
                      const SizedBox(height: 32),
                      // Weekly Progress
                      _buildWeeklyProgress(),
                      const SizedBox(height: 32),
                      // Achievements
                      _buildAchievements(),
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

  Widget _buildStatsOverview() {
    return LayoutBuilder(
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
          childAspectRatio: 1.1,
          children: [
            StatCard(
              icon: const Icon(Icons.star, size: 24, color: Color(0xFFFFC107)),
              title: 'Ukupno zvijezda',
              value: '245',
              subtitle: '',
            ),
            StatCard(
              icon: const Icon(Icons.workspace_premium, size: 24, color: Color(0xFF9C27B0)),
              title: 'Nivo',
              value: '5',
              subtitle: '',
            ),
            StatCard(
              icon: const Icon(Icons.trending_up, size: 24, color: Color(0xFF4CAF50)),
              title: 'Dnevna serija',
              value: '12',
              subtitle: '',
            ),
            StatCard(
              icon: const Icon(Icons.emoji_events, size: 24, color: Color(0xFF2196F3)),
              title: 'Značke',
              value: '8',
              subtitle: '',
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklyProgress() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ova sedmica',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              _buildDayProgress('Ponedjeljak', 85),
              const SizedBox(height: 16),
              _buildDayProgress('Utorak', 92),
              const SizedBox(height: 16),
              _buildDayProgress('Srijeda', 78),
              const SizedBox(height: 16),
              _buildDayProgress('Četvrtak', 95),
              const SizedBox(height: 16),
              _buildDayProgress('Petak', 88),
              const SizedBox(height: 16),
              _buildDayProgress('Subota', 70),
              const SizedBox(height: 16),
              _buildDayProgress('Nedjelja', 0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayProgress(String day, int value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              day,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: KidsColors.textPrimary,
              ),
            ),
            Text(
              '$value%',
              style: const TextStyle(
                fontSize: 14,
                color: KidsColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ModernProgress(
          value: value / 100,
          height: 8,
          color: KidsColors.primary,
          animated: true,
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Značke',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
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
                  const BadgeCard(emoji: '🌟', title: 'Prvi koraci', unlocked: true),
                  const BadgeCard(emoji: '📚', title: 'Knjižni moljac', unlocked: true),
                  const BadgeCard(emoji: '🎨', title: 'Umjetnik', unlocked: true),
                  const BadgeCard(emoji: '🎵', title: 'Muzičar', unlocked: true),
                  const BadgeCard(emoji: '🏃', title: 'Brzi trkač', unlocked: true),
                  const BadgeCard(emoji: '🧠', title: 'Mislilac', unlocked: true),
                  const BadgeCard(emoji: '💪', title: 'Istrajan', unlocked: true),
                  const BadgeCard(emoji: '🌈', title: 'Duga', unlocked: true),
                  const BadgeCard(emoji: '🚀', title: 'Raketa', unlocked: false),
                  const BadgeCard(emoji: '🎯', title: 'Precizan', unlocked: false),
                  const BadgeCard(emoji: '⭐', title: 'Superzvijezda', unlocked: false),
                  const BadgeCard(emoji: '🏆', title: 'Šampion', unlocked: false),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

