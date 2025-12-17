import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../models/exercise.dart';
import '../../models/child_profile.dart';
import '../../providers/child_profile_provider.dart';
import '../../providers/services_providers.dart';
import '../../services/adaptive_exercise_service.dart';
import '../../services/progress_tracking_service.dart';
import '../../widgets/exercise_card_widget.dart';
import '../../widgets/progress_chart_widget.dart';
import '../../core/theme/app_theme.dart';
import '../../core/routes/app_routes.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  List<Exercise> _availableExercises = [];
  Map<String, dynamic>? _progressStats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final profileState = ref.read(childProfileProvider);
    final profile = profileState.profile;

    if (profile != null) {
      // Lade verfügbare Übungen
      final adaptiveService = ref.read(adaptiveExerciseServiceProvider);
      final exercises = await adaptiveService.getNextExercise(
        childProfile: profile,
        completedExercises: [],
      );

      // Lade Fortschritts-Statistiken
      final progressService = ref.read(progressTrackingServiceProvider);
      final stats = await progressService.calculateProgressStats(
        childId: profile.id,
      );

      setState(() {
        _availableExercises = [exercises]; // Für jetzt nur eine Übung
        _progressStats = stats;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _startExercise(Exercise exercise) async {
    await Navigator.of(context).pushNamed(
      AppRoutes.exercise,
      arguments: {'exercise': exercise},
    );
    // Lade Daten neu nach Übung
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(childProfileProvider);
    final profile = profileState.profile;

    if (profileState.isLoading || _isLoading) {
      return Scaffold(
        backgroundColor: KidsColors.backgroundLight,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (profile == null) {
      return Scaffold(
        backgroundColor: KidsColors.backgroundLight,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kein Profil gefunden',
                style: KidsTypography.h2,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.childProfile,
                  );
                },
                child: const Text('Profil erstellen'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      appBar: AppBar(
        title: Text('Hallo, ${profile.name}! 👋'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Settings Screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Overview
              if (_progressStats != null) _buildProgressOverview(),
              const SizedBox(height: 32),

              // Available Exercises
              Text(
                'Verfügbare Übungen',
                style: KidsTypography.h2,
              ),
              const SizedBox(height: 16),
              if (_availableExercises.isEmpty)
                _buildEmptyState()
              else
                ..._availableExercises.map((exercise) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ExerciseCardWidget(
                        exercise: exercise,
                        onTap: () => _startExercise(exercise),
                      ),
                    )),
              const SizedBox(height: 32),

              // Quick Stats
              _buildQuickStats(profile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    final stats = _progressStats!;
    final avgScore = stats['averageScore'] as double? ?? 0.0;
    final streak = stats['currentStreak'] as int? ?? 0;
    final totalSessions = stats['totalSessions'] as int? ?? 0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: KidsGradients.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: KidsColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dein Fortschritt',
            style: KidsTypography.h3.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Durchschnitt',
                  '${avgScore.toInt()}%',
                  Icons.trending_up,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Streak',
                  '$streak Tage',
                  Icons.local_fire_department,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Sessions',
                  '$totalSessions',
                  Icons.fitness_center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: KidsTypography.h2.copyWith(
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: KidsTypography.caption.copyWith(
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.school_outlined,
            size: 64,
            color: KidsColors.gray400,
          ),
          const SizedBox(height: 16),
          Text(
            'Keine Übungen verfügbar',
            style: KidsTypography.h3.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte warte, während wir Übungen für dich vorbereiten',
            style: KidsTypography.bodyMedium.copyWith(
              color: KidsColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ChildProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Dein Profil',
            style: KidsTypography.h3,
          ),
          const SizedBox(height: 16),
          _buildProfileRow('Alter', '${profile.age} Jahre'),
          _buildProfileRow('Sprache', profile.language),
          _buildProfileRow(
            'Hörverlust',
            _getSeverityText(profile.hearingLossSeverity),
          ),
          _buildProfileRow(
            'Skill Level',
            '${profile.currentSkillLevel}/10',
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: KidsTypography.bodyMedium.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: KidsTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: KidsColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeverityText(HearingLossSeverity severity) {
    const texts = {
      HearingLossSeverity.normal: 'Normal',
      HearingLossSeverity.mild: 'Leicht',
      HearingLossSeverity.moderate: 'Mittel',
      HearingLossSeverity.severe: 'Schwer',
      HearingLossSeverity.profound: 'Sehr schwer',
    };
    return texts[severity] ?? 'Unbekannt';
  }
}

