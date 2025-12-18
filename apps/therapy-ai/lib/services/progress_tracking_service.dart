import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../models/therapy_session.dart';
import '../models/exercise.dart';
import '../models/speech_analysis_result.dart';
import '../core/constants/app_constants.dart';
import '../core/error_handler.dart';

/// Progress Tracking Service
/// Handles progress tracking, statistics, and Firebase integration
class ProgressTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Speichert eine Therapie-Session
  /// 
  /// [session] - Die Therapie-Session
  Future<void> saveSession(TherapySession session) async {
    try {
      await ErrorHandler.executeWithRetry(
        function: () async {
          await _firestore
              .collection('therapy_sessions')
              .doc(session.id)
              .set(session.toJson());
        },
        onRetry: (attempt, delay) {
          debugPrint('Firebase Session Save Retry $attempt nach ${delay.inSeconds}s...');
        },
      );
    } catch (e) {
      throw Exception('Fehler beim Speichern der Session: ${ErrorHandler.handleFirebaseError(e)}');
    }
  }

  /// Holt alle Sessions für ein Kind
  /// 
  /// [childId] - ID des Kindes
  /// [limit] - Maximale Anzahl (optional)
  /// 
  /// Returns: Liste von Sessions
  Future<List<TherapySession>> getSessions({
    required String childId,
    int? limit,
  }) async {
    try {
      Query query = _firestore
          .collection('therapy_sessions')
          .where('childProfileId', isEqualTo: childId)
          .orderBy('startTime', descending: true);

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs
          .map((doc) => TherapySession.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Sessions: $e');
    }
  }

  /// Berechnet Fortschritts-Statistiken
  /// 
  /// [childId] - ID des Kindes
  /// [days] - Anzahl der Tage (optional, default: 30)
  /// 
  /// Returns: Map mit Statistiken
  Future<Map<String, dynamic>> calculateProgressStats({
    required String childId,
    int days = 30,
  }) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: days));
      final sessions = await getSessions(childId: childId);

      final recentSessions = sessions.where((s) => s.startTime.isAfter(cutoffDate)).toList();

      if (recentSessions.isEmpty) {
        return _emptyStats();
      }

      // Berechne Durchschnitte
      final totalSessions = recentSessions.length;
      final totalExercises = recentSessions
          .map((s) => s.completedExercises)
          .fold(0, (a, b) => a + b);
      final averageScore = recentSessions
          .map((s) => s.averagePronunciationScore)
          .reduce((a, b) => a + b) /
          totalSessions;
      final totalDuration = recentSessions
          .map((s) => s.duration ?? Duration.zero)
          .fold(Duration.zero, (a, b) => a + b);

      // Berechne Trends
      final firstHalf = recentSessions.take(totalSessions ~/ 2).toList();
      final secondHalf = recentSessions.skip(totalSessions ~/ 2).toList();

      final firstHalfAvg = firstHalf.isNotEmpty
          ? firstHalf.map((s) => s.averagePronunciationScore).reduce((a, b) => a + b) /
              firstHalf.length
          : 0.0;
      final secondHalfAvg = secondHalf.isNotEmpty
          ? secondHalf.map((s) => s.averagePronunciationScore).reduce((a, b) => a + b) /
              secondHalf.length
          : 0.0;

      final improvementTrend = secondHalfAvg - firstHalfAvg;

      // Berechne Beste/Schlechteste Session
      final bestSession = recentSessions.reduce((a, b) =>
          a.averagePronunciationScore > b.averagePronunciationScore ? a : b);
      final worstSession = recentSessions.reduce((a, b) =>
          a.averagePronunciationScore < b.averagePronunciationScore ? a : b);

      // Berechne Streak (Tage in Folge)
      final streak = _calculateStreak(recentSessions);

      return {
        'totalSessions': totalSessions,
        'totalExercises': totalExercises,
        'averageScore': averageScore,
        'totalDuration': totalDuration,
        'improvementTrend': improvementTrend,
        'bestSession': {
          'score': bestSession.averagePronunciationScore,
          'date': bestSession.startTime,
        },
        'worstSession': {
          'score': worstSession.averagePronunciationScore,
          'date': worstSession.startTime,
        },
        'currentStreak': streak,
        'averageExercisesPerSession': totalExercises / totalSessions,
        'averageDurationPerSession': Duration(
          milliseconds: totalDuration.inMilliseconds ~/ totalSessions,
        ),
      };
    } catch (e) {
      throw Exception('Fehler bei Fortschritts-Berechnung: $e');
    }
  }

  /// Berechnet Streak (Tage in Folge)
  int _calculateStreak(List<TherapySession> sessions) {
    if (sessions.isEmpty) return 0;

    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));

    int streak = 0;
    DateTime? lastDate;

    for (final session in sessions) {
      final sessionDate = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );

      if (lastDate == null) {
        // Erste Session
        final today = DateTime.now();
        final todayDate = DateTime(today.year, today.month, today.day);
        final diff = todayDate.difference(sessionDate).inDays;

        if (diff <= 1) {
          streak = 1;
          lastDate = sessionDate;
        } else {
          break;
        }
      } else {
        final diff = lastDate.difference(sessionDate).inDays;
        if (diff == 1) {
          streak++;
          lastDate = sessionDate;
        } else {
          break;
        }
      }
    }

    return streak;
  }

  /// Leere Statistiken
  Map<String, dynamic> _emptyStats() {
    return {
      'totalSessions': 0,
      'totalExercises': 0,
      'averageScore': 0.0,
      'totalDuration': Duration.zero,
      'improvementTrend': 0.0,
      'bestSession': null,
      'worstSession': null,
      'currentStreak': 0,
      'averageExercisesPerSession': 0.0,
      'averageDurationPerSession': Duration.zero,
    };
  }

  /// Speichert Fortschritts-Update für ein Kind
  /// 
  /// [childId] - ID des Kindes
  /// [update] - Update-Daten
  Future<void> updateChildProgress({
    required String childId,
    required Map<String, dynamic> update,
  }) async {
    try {
      await _firestore
          .collection('child_profiles')
          .doc(childId)
          .update({
        'progress': update,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Fehler beim Aktualisieren des Fortschritts: $e');
    }
  }

  /// Holt Fortschritts-Daten für ein Kind
  /// 
  /// [childId] - ID des Kindes
  /// 
  /// Returns: Fortschritts-Daten
  Future<Map<String, dynamic>?> getChildProgress(String childId) async {
    try {
      final doc = await _firestore
          .collection('child_profiles')
          .doc(childId)
          .get();

      if (!doc.exists) {
        return null;
      }

      final data = doc.data();
      return data?['progress'] as Map<String, dynamic>?;
    } catch (e) {
      throw Exception('Fehler beim Abrufen des Fortschritts: $e');
    }
  }

  /// Speichert detaillierte Übungs-Ergebnisse
  /// 
  /// [childId] - ID des Kindes
  /// [exerciseId] - ID der Übung
  /// [result] - Analyse-Ergebnis
  Future<void> saveExerciseResult({
    required String childId,
    required String exerciseId,
    required SpeechAnalysisResult result,
  }) async {
    try {
      await _firestore
          .collection('exercise_results')
          .add({
        'childId': childId,
        'exerciseId': exerciseId,
        'result': result.toJson(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Fehler beim Speichern des Übungs-Ergebnisses: $e');
    }
  }

  /// Holt Übungs-Ergebnisse für ein Kind
  /// 
  /// [childId] - ID des Kindes
  /// [exerciseId] - ID der Übung (optional)
  /// [limit] - Maximale Anzahl (optional)
  /// 
  /// Returns: Liste von Ergebnissen
  Future<List<Map<String, dynamic>>> getExerciseResults({
    required String childId,
    String? exerciseId,
    int? limit,
  }) async {
    try {
      Query query = _firestore
          .collection('exercise_results')
          .where('childId', isEqualTo: childId)
          .orderBy('timestamp', descending: true);

      if (exerciseId != null) {
        query = query.where('exerciseId', isEqualTo: exerciseId);
      }

      if (limit != null) {
        query = query.limit(limit);
      }

      final snapshot = await query.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'exerciseId': (data as Map<String, dynamic>)['exerciseId'],
          'result': (data as Map<String, dynamic>)['result'],
          'timestamp': (data as Map<String, dynamic>)['timestamp'],
        };
      }).toList();
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Übungs-Ergebnisse: $e');
    }
  }

  /// Berechnet Übungs-spezifische Statistiken
  /// 
  /// [childId] - ID des Kindes
  /// [exerciseId] - ID der Übung
  /// 
  /// Returns: Statistiken für die Übung
  Future<Map<String, dynamic>> getExerciseStats({
    required String childId,
    required String exerciseId,
  }) async {
    try {
      final results = await getExerciseResults(
        childId: childId,
        exerciseId: exerciseId,
      );

      if (results.isEmpty) {
        return {
          'attempts': 0,
          'averageScore': 0.0,
          'bestScore': 0.0,
          'successRate': 0.0,
        };
      }

      final scores = results
          .map((r) => (r['result'] as Map)['pronunciationScore'] as double? ?? 0.0)
          .toList();

      final attempts = results.length;
      final averageScore = scores.reduce((a, b) => a + b) / attempts;
      final bestScore = scores.reduce((a, b) => a > b ? a : b);
      final successful = scores.where((s) => s >= 70.0).length;
      final successRate = (successful / attempts) * 100;

      return {
        'attempts': attempts,
        'averageScore': averageScore,
        'bestScore': bestScore,
        'successRate': successRate,
        'lastAttempt': results.first['timestamp'],
      };
    } catch (e) {
      throw Exception('Fehler bei Übungs-Statistik: $e');
    }
  }

  /// Generiert Fortschritts-Report
  /// 
  /// [childId] - ID des Kindes
  /// [startDate] - Start-Datum
  /// [endDate] - End-Datum
  /// 
  /// Returns: Detaillierter Report
  Future<Map<String, dynamic>> generateProgressReport({
    required String childId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final sessions = await getSessions(childId: childId);
      final filteredSessions = sessions
          .where((s) => s.startTime.isAfter(startDate) && s.startTime.isBefore(endDate))
          .toList();

      final stats = await calculateProgressStats(childId: childId);
      final exerciseResults = await getExerciseResults(childId: childId);

      return {
        'period': {
          'start': startDate,
          'end': endDate,
        },
        'sessions': filteredSessions.length,
        'overallStats': stats,
        'exerciseResults': exerciseResults.length,
        'recommendations': _generateRecommendations(stats),
      };
    } catch (e) {
      throw Exception('Fehler bei Report-Generierung: $e');
    }
  }

  /// Generiert Empfehlungen basierend auf Statistiken
  List<String> _generateRecommendations(Map<String, dynamic> stats) {
    final recommendations = <String>[];

    final averageScore = stats['averageScore'] as double? ?? 0.0;
    final improvementTrend = stats['improvementTrend'] as double? ?? 0.0;
    final streak = stats['currentStreak'] as int? ?? 0;

    if (averageScore < 60) {
      recommendations.add('Fokus auf Grundlagen-Übungen legen');
    }

    if (improvementTrend < 0) {
      recommendations.add('Schwierigkeit anpassen - möglicherweise zu hoch');
    }

    if (streak < 3) {
      recommendations.add('Regelmäßiges Üben fördert den Fortschritt');
    }

    if (averageScore > 80 && improvementTrend > 5) {
      recommendations.add('Ausgezeichnet! Schwierigkeit kann erhöht werden');
    }

    if (recommendations.isEmpty) {
      recommendations.add('Weiter so! Guter Fortschritt');
    }

    return recommendations;
  }

  /// Löscht alle Daten für ein Kind (für Testing/Reset)
  /// 
  /// [childId] - ID des Kindes
  Future<void> clearAllData(String childId) async {
    try {
      // Lösche Sessions
      final sessions = await getSessions(childId: childId);
      for (final session in sessions) {
        await _firestore
            .collection('therapy_sessions')
            .doc(session.id)
            .delete();
      }

      // Lösche Übungs-Ergebnisse
      final results = await getExerciseResults(childId: childId);
      for (final result in results) {
        await _firestore
            .collection('exercise_results')
            .doc(result['id'] as String)
            .delete();
      }

      // Lösche Fortschritts-Daten
      await _firestore
          .collection('child_profiles')
          .doc(childId)
          .update({
        'progress': null,
      });
    } catch (e) {
      throw Exception('Fehler beim Löschen der Daten: $e');
    }
  }
}

