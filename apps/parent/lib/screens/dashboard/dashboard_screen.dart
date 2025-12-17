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
            'Fehler: $error',
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
              'Noch keine Kinder',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: KidsColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Füge dein erstes Kind hinzu, um die Lern-Apps zu verbinden.',
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
              label: const Text('Kind hinzufügen'),
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
}
