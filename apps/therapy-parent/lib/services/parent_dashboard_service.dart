import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// Dashboard Data Model
class DashboardData {
  final int activeChildrenCount;
  final int sessionsToday;
  final double averageSuccessRate;
  final int totalExercises;
  final List<Map<String, dynamic>> weeklyProgress;
  final List<Map<String, dynamic>> recentExercises;

  DashboardData({
    required this.activeChildrenCount,
    required this.sessionsToday,
    required this.averageSuccessRate,
    required this.totalExercises,
    required this.weeklyProgress,
    required this.recentExercises,
  });
}

/// Parent Dashboard Service
class ParentDashboardService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lädt Dashboard-Daten
  Future<DashboardData> loadDashboardData() async {
    try {
      // Lade alle Kind-Profile
      final childrenSnapshot = await _firestore
          .collection('child_profiles')
          .get();

      final activeChildrenCount = childrenSnapshot.docs.length;

      // Lade Sessions von heute
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final sessionsSnapshot = await _firestore
          .collection('therapy_sessions')
          .where('startTime', isGreaterThanOrEqualTo: startOfDay)
          .get();

      final sessionsToday = sessionsSnapshot.docs.length;

      // Berechne Durchschnitts-Erfolgsrate
      double totalSuccessRate = 0.0;
      int totalSessions = 0;

      for (var sessionDoc in sessionsSnapshot.docs) {
        final sessionData = sessionDoc.data();
        if (sessionData['averagePronunciationScore'] != null) {
          totalSuccessRate +=
              (sessionData['averagePronunciationScore'] as num).toDouble();
          totalSessions++;
        }
      }

      final averageSuccessRate =
          totalSessions > 0 ? totalSuccessRate / totalSessions : 0.0;

      // Lade alle Übungen
      int totalExercises = 0;
      for (var sessionDoc in sessionsSnapshot.docs) {
        final sessionData = sessionDoc.data();
        totalExercises += sessionData['completedExercises'] ?? 0;
      }

      // Lade wöchentliche Fortschritts-Daten
      final weeklyProgress = await _loadWeeklyProgress();

      // Lade letzte Übungen
      final recentExercises = await _loadRecentExercises();

      return DashboardData(
        activeChildrenCount: activeChildrenCount,
        sessionsToday: sessionsToday,
        averageSuccessRate: averageSuccessRate,
        totalExercises: totalExercises,
        weeklyProgress: weeklyProgress,
        recentExercises: recentExercises,
      );
    } catch (e) {
      debugPrint('Fehler beim Laden der Dashboard-Daten: $e');
      return DashboardData(
        activeChildrenCount: 0,
        sessionsToday: 0,
        averageSuccessRate: 0.0,
        totalExercises: 0,
        weeklyProgress: [],
        recentExercises: [],
      );
    }
  }

  /// Lädt wöchentliche Fortschritts-Daten
  Future<List<Map<String, dynamic>>> _loadWeeklyProgress() async {
    try {
      final now = DateTime.now();
      final weekAgo = now.subtract(const Duration(days: 7));

      final sessionsSnapshot = await _firestore
          .collection('therapy_sessions')
          .where('startTime', isGreaterThanOrEqualTo: weekAgo)
          .orderBy('startTime')
          .get();

      final Map<String, List<double>> dailyScores = {};

      for (var doc in sessionsSnapshot.docs) {
        final data = doc.data();
        final date = (data['startTime'] as Timestamp).toDate();
        final dateKey = '${date.year}-${date.month}-${date.day}';
        final score = (data['averagePronunciationScore'] as num?)?.toDouble() ?? 0.0;

        dailyScores.putIfAbsent(dateKey, () => []).add(score);
      }

      return dailyScores.entries.map((entry) {
        final avgScore = entry.value.reduce((a, b) => a + b) / entry.value.length;
        return {
          'date': entry.key,
          'score': avgScore,
        };
      }).toList();
    } catch (e) {
      debugPrint('Fehler beim Laden der wöchentlichen Fortschritts-Daten: $e');
      return [];
    }
  }

  /// Lädt letzte Übungen
  Future<List<Map<String, dynamic>>> _loadRecentExercises() async {
    try {
      final sessionsSnapshot = await _firestore
          .collection('therapy_sessions')
          .orderBy('startTime', descending: true)
          .limit(20)
          .get();

      final List<Map<String, dynamic>> exercises = [];

      for (var sessionDoc in sessionsSnapshot.docs) {
        final sessionData = sessionDoc.data();
        final attempts = sessionData['exerciseAttempts'] as List? ?? [];

        for (var attempt in attempts) {
          final result = attempt['result'];
          if (result != null) {
            exercises.add({
              'word': result['targetWord'] ?? '',
              'score': result['pronunciationScore'] ?? 0,
              'success': result['isSuccessful'] ?? false,
              'date': (sessionData['startTime'] as Timestamp).toDate().toString(),
              'childName': sessionData['childName'] ?? '',
            });
          }
        }
      }

      return exercises.take(10).toList();
    } catch (e) {
      debugPrint('Fehler beim Laden der letzten Übungen: $e');
      return [];
    }
  }
}

/// Provider für Parent Dashboard Service
final parentDashboardServiceProvider =
    Provider<ParentDashboardService>((ref) => ParentDashboardService());

/// Provider für Dashboard-Daten
final dashboardDataProvider = FutureProvider<DashboardData>((ref) async {
  final service = ref.watch(parentDashboardServiceProvider);
  return await service.loadDashboardData();
});

