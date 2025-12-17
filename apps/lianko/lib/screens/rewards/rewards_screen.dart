import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/reward_service.dart';

/// Belohnungs-Screen - zeigt Sterne, Abzeichen, Fortschritt
class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewardState = ref.watch(rewardServiceProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Header mit Sternen
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: const Color(0xFF4CAF50),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4CAF50),
                      Color(0xFF2196F3),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '⭐',
                        style: TextStyle(fontSize: 48),
                      ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                      const SizedBox(height: 8),
                      Text(
                        '${rewardState.totalStars}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Sterne gesammelt',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            title: const Text('Meine Belohnungen'),
          ),

          // Streak-Info
          SliverToBoxAdapter(
            child: _buildStreakCard(rewardState),
          ),

          // Statistiken
          SliverToBoxAdapter(
            child: _buildStatsRow(rewardState),
          ),

          // Abzeichen-Titel
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                'Meine Abzeichen',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Abzeichen-Grid
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final allBadges = AvailableBadges.all;
                  final badge = allBadges[index];
                  final isEarned = rewardState.hasBadge(badge.id);

                  return _BadgeCard(
                    badge: badge,
                    isEarned: isEarned,
                    index: index,
                  );
                },
                childCount: AvailableBadges.all.length,
              ),
            ),
          ),

          // Fortschritt
          SliverToBoxAdapter(
            child: _buildProgressSection(rewardState),
          ),

          // Bottom Padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(RewardState state) {
    if (state.currentStreak == 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFF9800).withOpacity(0.2),
            const Color(0xFFFFD700).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFF9800).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${state.currentStreak} Tage Serie!',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9800),
                  ),
                ),
                Text(
                  'Weiter so! Jeden Tag üben lohnt sich.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: -0.2, end: 0);
  }

  Widget _buildStatsRow(RewardState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _StatCard(
            emoji: '⭐',
            value: '${state.totalStars}',
            label: 'Sterne',
            color: const Color(0xFFFFD700),
          ),
          const SizedBox(width: 12),
          _StatCard(
            emoji: '🏆',
            value: '${state.earnedRewards.where((r) => r.type == RewardType.trophy).length}',
            label: 'Pokale',
            color: const Color(0xFFFF9800),
          ),
          const SizedBox(width: 12),
          _StatCard(
            emoji: '🎖️',
            value: '${state.earnedRewards.length}',
            label: 'Abzeichen',
            color: const Color(0xFF4CAF50),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(RewardState state) {
    return Container(
      margin: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mein Fortschritt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          _ProgressItem(
            label: 'Wörter geübt',
            current: state.getActivityCount('words_practiced'),
            target: 50,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 12),

          _ProgressItem(
            label: 'Silben geübt',
            current: state.getActivityCount('syllables_practiced'),
            target: 30,
            color: const Color(0xFF2196F3),
          ),
          const SizedBox(height: 12),

          _ProgressItem(
            label: 'Geschichten',
            current: state.getActivityCount('stories_completed'),
            target: 10,
            color: const Color(0xFF9C27B0),
          ),
          const SizedBox(height: 12),

          _ProgressItem(
            label: 'Quiz richtig',
            current: state.getActivityCount('quiz_correct'),
            target: 100,
            color: const Color(0xFFFF9800),
          ),
        ],
      ),
    );
  }
}

/// Statistik-Karte
class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Abzeichen-Karte
class _BadgeCard extends StatelessWidget {
  final dynamic badge;  // _BadgeInfo
  final bool isEarned;
  final int index;

  const _BadgeCard({
    required this.badge,
    required this.isEarned,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBadgeDialog(context),
      child: Container(
        decoration: BoxDecoration(
          color: isEarned ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          boxShadow: isEarned
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isEarned ? badge.emoji : '🔒',
              style: TextStyle(
                fontSize: 36,
                color: isEarned ? null : Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                badge.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isEarned ? Colors.black87 : Colors.grey[500],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 50))
        .fadeIn(duration: 300.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }

  void _showBadgeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isEarned ? badge.emoji : '🔒',
              style: const TextStyle(fontSize: 64),
            ),
            const SizedBox(height: 16),
            Text(
              badge.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            if (!isEarned) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Noch nicht freigeschaltet',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

/// Fortschritts-Balken
class _ProgressItem extends StatelessWidget {
  final String label;
  final int current;
  final int target;
  final Color color;

  const _ProgressItem({
    required this.label,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              '$current / $target',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

/// Dialog für neue Belohnung (zur Anzeige wenn Badge verdient wird)
class NewRewardDialog extends StatelessWidget {
  final Reward reward;

  const NewRewardDialog({super.key, required this.reward});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            '🎉',
            style: TextStyle(fontSize: 48),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 8),
          const Text(
            'Neues Abzeichen!',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            reward.emoji,
            style: const TextStyle(fontSize: 80),
          )
              .animate()
              .fadeIn(delay: 300.ms)
              .scale(begin: const Offset(0.5, 0.5), duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(
            reward.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            reward.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Super!',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }
}

/// Hilfsfunktion zum Anzeigen einer neuen Belohnung
void showNewRewardDialog(BuildContext context, Reward reward) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => NewRewardDialog(reward: reward),
  );
}
