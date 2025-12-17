import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/charts/progress_chart_widget.dart';
import '../../widgets/cards/stat_card_widget.dart';
import '../../services/parent_dashboard_service.dart';

/// Dashboard Screen - Hauptübersicht
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Lade Dashboard-Daten
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(parentDashboardServiceProvider).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardData = ref.watch(dashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Therapy Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(parentDashboardServiceProvider).loadDashboardData();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Überschrift
              Text(
                'Übersicht',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 24),

              // Statistik-Karten
              _buildStatsGrid(dashboardData),

              const SizedBox(height: 32),

              // Fortschritts-Chart
              _buildProgressSection(dashboardData),

              const SizedBox(height: 32),

              // Letzte Übungen
              _buildRecentExercises(dashboardData),

              const SizedBox(height: 32),

              // Schnellzugriff
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.childList);
        },
        icon: const Icon(Icons.people),
        label: const Text('Kinder verwalten'),
      ),
    );
  }

  Widget _buildStatsGrid(dynamic dashboardData) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        StatCardWidget(
          title: 'Aktive Kinder',
          value: dashboardData?.activeChildrenCount ?? 0,
          icon: Icons.people,
          color: AppTheme.primaryColor,
        ),
        StatCardWidget(
          title: 'Sessions heute',
          value: dashboardData?.sessionsToday ?? 0,
          icon: Icons.today,
          color: AppTheme.successColor,
        ),
        StatCardWidget(
          title: 'Durchschnittliche Erfolgsrate',
          value: '${dashboardData?.averageSuccessRate ?? 0}%',
          icon: Icons.trending_up,
          color: AppTheme.infoColor,
        ),
        StatCardWidget(
          title: 'Gesamt Übungen',
          value: dashboardData?.totalExercises ?? 0,
          icon: Icons.fitness_center,
          color: AppTheme.warningColor,
        ),
      ],
    );
  }

  Widget _buildProgressSection(dynamic dashboardData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fortschritt (7 Tage)',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: ProgressChartWidget(
                data: dashboardData?.weeklyProgress ?? [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentExercises(dynamic dashboardData) {
    final exercises = dashboardData?.recentExercises ?? [];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Letzte Übungen',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (exercises.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Noch keine Übungen'),
                ),
              )
            else
              ...exercises.take(5).map((exercise) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: exercise['success'] == true
                          ? AppTheme.successColor
                          : AppTheme.warningColor,
                      child: Icon(
                        exercise['success'] == true
                            ? Icons.check
                            : Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(exercise['word'] ?? ''),
                    subtitle: Text(
                      '${exercise['childName'] ?? ''} - ${exercise['date'] ?? ''}',
                    ),
                    trailing: Text('${exercise['score'] ?? 0}%'),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Schnellzugriff',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.people, size: 18),
                  label: const Text('Kinder'),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.childList);
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.download, size: 18),
                  label: const Text('Export'),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.export);
                  },
                ),
                ActionChip(
                  avatar: const Icon(Icons.settings, size: 18),
                  label: const Text('Einstellungen'),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

