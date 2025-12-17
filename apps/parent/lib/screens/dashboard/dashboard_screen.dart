import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../providers/children_provider.dart';
import '../../models/child.dart';
import '../children/add_child_screen.dart';
import '../children/child_detail_screen.dart';
import '../settings/settings_screen.dart';
import '../../widgets/cards/child_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final childrenAsync = ref.watch(childrenProvider);

    return Scaffold(
      backgroundColor: KidsColors.background,
      appBar: ModernNavBar(
        title: 'Kids AI Roditelj',
        actions: [
          NavButton(
            icon: Icons.home,
            onTap: () {},
          ),
          NavButton(
            icon: Icons.settings,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: childrenAsync.when(
        data: (children) => _buildContent(context, ref, children),
        loading: () => const Center(
          child: CircularProgressIndicator(color: KidsColors.primary),
        ),
        error: (error, _) => Center(
          child: Text(
            'Greška: $error',
            style: const TextStyle(color: KidsColors.error),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddChild(context),
        backgroundColor: KidsColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Kind hinzufügen'),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WidgetRef ref, List<Child> children) {
    if (children.isEmpty) {
      return _buildEmptyState(context);
    }

    // Wenn mehrere Kinder, zeige Grid. Wenn eins, zeige vollständiges Dashboard
    if (children.length > 1) {
      return RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(childrenProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHeader(children.length),
            const SizedBox(height: 24),
            _buildChildrenGrid(context, children),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      );
    }

    // Vollständiges Dashboard für ein Kind (v0 Design)
    final child = children.first;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(childrenProvider);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeader(1),
          const SizedBox(height: 24),
          _buildChildProfileCard(context, ref, child),
          const SizedBox(height: 24),
          _buildStatsGrid(),
          const SizedBox(height: 24),
          _buildLearningProgressSection(),
          const SizedBox(height: 24),
          _buildRecentActivitySection(),
          const SizedBox(height: 24),
          _buildWeeklyOverview(),
          const SizedBox(height: 100), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.child_care,
              size: 80,
              color: KidsColors.textMuted,
            ),
            const SizedBox(height: 24),
            Text(
              'Još nema djece',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: KidsColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dodajte svoje prvo dijete da povežete aplikacije za učenje.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: KidsColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddChild(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: KidsColors.primary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              icon: const Icon(Icons.add),
              label: const Text('Dodaj dijete'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int childCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rodiiteljska kontrolna tabla',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: KidsColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pratite napredak vašeg djeteta u učenju',
          style: TextStyle(
            fontSize: 18,
            color: KidsColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenGrid(BuildContext context, List<Child> children) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) {
        final child = children[index];
        return ChildCard(
          child: child,
          onTap: () => _navigateToChildDetail(context, child),
        );
      },
    );
  }

  void _navigateToAddChild(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddChildScreen(),
      ),
    );
  }

  void _navigateToChildDetail(BuildContext context, Child child) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChildDetailScreen(child: child),
      ),
    );
  }

  // Child Profile Card (v0 Design)
  Widget _buildChildProfileCard(
      BuildContext context, WidgetRef ref, Child child) {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: KidsColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Name and Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  child.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: KidsColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${child.age} godina • Nivo 5',
                  style: const TextStyle(
                    fontSize: 16,
                    color: KidsColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          // Settings Button
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            icon: const Icon(Icons.settings, size: 16),
            label: const Text('Postavke'),
            style: OutlinedButton.styleFrom(
              foregroundColor: KidsColors.primary,
              side: const BorderSide(color: KidsColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  // Stats Grid (v0 Design)
  Widget _buildStatsGrid() {
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
          childAspectRatio: 1.2,
          children: [
            StatCard(
              icon: const Icon(Icons.access_time, size: 20),
              title: 'Danas',
              value: '45 Min',
              subtitle: 'Aktivno vrijeme',
            ),
            StatCard(
              icon: const Icon(Icons.trending_up, size: 20),
              title: 'Ova sedmica',
              value: '4.5 Sati',
              subtitle: 'Vrijeme učenja',
            ),
            StatCard(
              icon: const Icon(Icons.workspace_premium, size: 20),
              title: 'Značke',
              value: '8',
              subtitle: 'Otključano',
            ),
            StatCard(
              icon: const Icon(Icons.menu_book, size: 20),
              title: 'Lekcije',
              value: '23',
              subtitle: 'Završeno',
            ),
          ],
        );
      },
    );
  }

  // Learning Progress Section (v0 Design)
  Widget _buildLearningProgressSection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Oblasti učenja',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              ProgressItem(
                label: 'Čitanje i pisanje',
                value: 85,
                color: const Color(0xFF2196F3), // bg-blue-500
              ),
              const SizedBox(height: 24),
              ProgressItem(
                label: 'Matematika',
                value: 72,
                color: const Color(0xFF4CAF50), // bg-green-500
              ),
              const SizedBox(height: 24),
              ProgressItem(
                label: 'Jezici',
                value: 68,
                color: const Color(0xFF9C27B0), // bg-purple-500
              ),
              const SizedBox(height: 24),
              ProgressItem(
                label: 'Kreativnost',
                value: 90,
                color: const Color(0xFFE91E63), // bg-pink-500
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Recent Activity Section (v0 Design)
  Widget _buildRecentActivitySection() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nedavne aktivnosti',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: [
              const ActivityItem(
                activity: "Lekcija 'Učenje slova' završena",
                time: 'Prije 2 sata',
                points: 20,
              ),
              const SizedBox(height: 16),
              const ActivityItem(
                activity: "Značka 'Knjižni moljac' dobijena",
                time: 'Prije 5 sati',
                points: 50,
              ),
              const SizedBox(height: 16),
              const ActivityItem(
                activity: '15 minuta slušanja muzike',
                time: 'Juče',
                points: 10,
              ),
              const SizedBox(height: 16),
              const ActivityItem(
                activity: 'Dnevni izazov savladan',
                time: 'Juče',
                points: 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Weekly Overview (v0 Design)
  Widget _buildWeeklyOverview() {
    return ModernCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pregled sedmice',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: KidsColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          WeeklyOverview(
            dayData: {
              'Pon': '30m',
              'Uto': '35m',
              'Sri': '40m',
              'Čet': '45m',
              'Pet': '50m',
              'Sub': '55m',
              'Ned': '-',
            },
          ),
        ],
      ),
    );
  }
}
