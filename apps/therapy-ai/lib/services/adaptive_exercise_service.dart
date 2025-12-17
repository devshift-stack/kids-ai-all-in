import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../models/exercise.dart';
import '../models/speech_analysis_result.dart';
import '../models/therapy_session.dart';
import '../core/constants/app_constants.dart';

/// Adaptive Exercise Service
/// Manages exercise selection, difficulty adjustment, and performance tracking
class AdaptiveExerciseService {
  final Map<String, List<SpeechAnalysisResult>> _performanceHistory = {};
  final Map<String, int> _exerciseAttempts = {}; // exerciseId -> attempts
  final Map<String, double> _exerciseSuccessRate = {}; // exerciseId -> success rate

  /// Gibt die nächste Übung basierend auf Profil und Historie zurück
  /// 
  /// [childProfile] - Profil des Kindes
  /// [completedExercises] - Liste der bereits absolvierten Übungen
  /// 
  /// Returns: Nächste empfohlene Übung
  Future<Exercise> getNextExercise({
    required ChildProfile childProfile,
    List<Exercise>? completedExercises,
  }) async {
    // Hole Übungs-Bibliothek basierend auf Skill-Level
    final availableExercises = _getExercisesForSkillLevel(
      childProfile.currentSkillLevel,
      childProfile.hearingLossSeverity,
    );

    // Filtere bereits abgeschlossene Übungen
    final completedIds = completedExercises?.map((e) => e.id).toSet() ?? {};
    final remainingExercises = availableExercises
        .where((e) => !completedIds.contains(e.id))
        .toList();

    if (remainingExercises.isEmpty) {
      // Alle Übungen abgeschlossen - erhöhe Schwierigkeit oder wiederhole
      return _getAdaptiveExercise(childProfile, availableExercises);
    }

    // Wähle Übung basierend auf Performance
    return _selectBestExercise(
      remainingExercises,
      childProfile,
    );
  }

  /// Passt Schwierigkeit dynamisch an
  /// 
  /// [currentExercise] - Aktuelle Übung
  /// [performance] - Performance-Ergebnis
  /// 
  /// Returns: Angepasste Übung
  Exercise adjustDifficulty({
    required Exercise currentExercise,
    required SpeechAnalysisResult performance,
  }) {
    final successRate = performance.pronunciationScore / 100.0;
    final newDifficulty = currentExercise.difficultyLevel;

    // Erhöhe Schwierigkeit bei guter Performance
    if (successRate >= 0.9 && newDifficulty < 10) {
      return currentExercise.copyWith(
        difficultyLevel: newDifficulty + 1,
        minPronunciationScore: (currentExercise.minPronunciationScore * 1.1).clamp(0.0, 100.0),
      );
    }

    // Reduziere Schwierigkeit bei schlechter Performance
    if (successRate < 0.6 && newDifficulty > 1) {
      return currentExercise.copyWith(
        difficultyLevel: newDifficulty - 1,
        minPronunciationScore: (currentExercise.minPronunciationScore * 0.9).clamp(0.0, 100.0),
      );
    }

    return currentExercise;
  }

  /// Berechnet Fortschritt für ein Kind
  /// 
  /// [childId] - ID des Kindes
  /// 
  /// Returns: Map mit Fortschritts-Metriken
  Future<Map<String, dynamic>> calculateProgress(String childId) async {
    final history = _performanceHistory[childId] ?? [];
    if (history.isEmpty) {
      return {
        'averageScore': 0.0,
        'improvementTrend': 0.0,
        'totalExercises': 0,
        'successRate': 0.0,
      };
    }

    final scores = history.map((r) => r.pronunciationScore).toList();
    final averageScore = scores.reduce((a, b) => a + b) / scores.length;

    // Berechne Verbesserungs-Trend (letzte 5 vs. erste 5)
    double improvementTrend = 0.0;
    if (history.length >= 10) {
      final firstFive = history.take(5).map((r) => r.pronunciationScore).toList();
      final lastFive = history.skip(history.length - 5).map((r) => r.pronunciationScore).toList();
      final firstAvg = firstFive.reduce((a, b) => a + b) / firstFive.length;
      final lastAvg = lastFive.reduce((a, b) => a + b) / lastFive.length;
      improvementTrend = lastAvg - firstAvg;
    }

    final successful = history.where((r) => r.isSuccessful).length;
    final successRate = (successful / history.length) * 100;

    return {
      'averageScore': averageScore,
      'improvementTrend': improvementTrend,
      'totalExercises': history.length,
      'successRate': successRate,
      'recentScores': scores.length > 5 ? scores.sublist(scores.length - 5) : scores,
    };
  }

  /// Generiert personalisierten Übungsplan
  /// 
  /// [childProfile] - Profil des Kindes
  /// [durationDays] - Dauer des Plans in Tagen
  /// 
  /// Returns: Liste von Übungen für den Plan
  Future<List<Exercise>> generateExercisePlan({
    required ChildProfile childProfile,
    int durationDays = 7,
  }) async {
    final plan = <Exercise>[];
    final exercisesPerDay = AppConstants.maxExercisesPerSession;
    final totalExercises = durationDays * exercisesPerDay;

    // Hole verfügbare Übungen
    final availableExercises = _getExercisesForSkillLevel(
      childProfile.currentSkillLevel,
      childProfile.hearingLossSeverity,
    );

    // Berücksichtige Hörverlust-Profil
    final adaptedExercises = _adaptExercisesForHearingLoss(
      availableExercises,
      childProfile,
    );

    // Erstelle Plan mit Spaced Repetition
    for (int i = 0; i < totalExercises; i++) {
      final exercise = _selectExerciseWithSpacedRepetition(
        adaptedExercises,
        childProfile.id,
        i,
      );
      plan.add(exercise);
    }

    return plan;
  }

  /// Speichert Performance-Ergebnis
  /// 
  /// [childId] - ID des Kindes
  /// [result] - Analyse-Ergebnis
  /// [exerciseId] - ID der Übung
  void recordPerformance({
    required String childId,
    required SpeechAnalysisResult result,
    required String exerciseId,
  }) {
    // Füge zu Historie hinzu
    _performanceHistory.putIfAbsent(childId, () => []).add(result);

    // Aktualisiere Versuche
    _exerciseAttempts[exerciseId] = (_exerciseAttempts[exerciseId] ?? 0) + 1;

    // Aktualisiere Erfolgs-Rate
    final history = _performanceHistory[childId] ?? [];
    final successful = history.where((r) => r.isSuccessful).length;
    _exerciseSuccessRate[exerciseId] = history.isNotEmpty
        ? (successful / history.length) * 100
        : 0.0;

    // Begrenze Historie auf letzten 100 Einträge
    if (history.length > 100) {
      _performanceHistory[childId] = history.sublist(history.length - 100);
    }
  }

  /// Holt Übungen für Skill-Level
  List<Exercise> _getExercisesForSkillLevel(
    int skillLevel,
    HearingLossSeverity severity,
  ) {
    if (skillLevel <= 2) {
      return ExerciseLibrary.getBeginnerExercises();
    } else if (skillLevel <= 5) {
      return ExerciseLibrary.getIntermediateExercises();
    } else {
      return ExerciseLibrary.getAdvancedExercises();
    }
  }

  /// Passt Übungen an Hörverlust an
  List<Exercise> _adaptExercisesForHearingLoss(
    List<Exercise> exercises,
    ChildProfile profile,
  ) {
    // Für asymmetrischen Hörverlust: Fokus auf besseres Ohr
    if (profile.isAsymmetric) {
      // Passe Übungen an - könnte spezielle Frequenzen betonen
      return exercises.map((e) {
        // Anpassungen basierend auf Hörverlust
        return e;
      }).toList();
    }

    return exercises;
  }

  /// Wählt beste Übung basierend auf Performance
  Exercise _selectBestExercise(
    List<Exercise> exercises,
    ChildProfile profile,
  ) {
    if (exercises.isEmpty) {
      return ExerciseLibrary.getBeginnerExercises().first;
    }

    // Sortiere nach Erfolgs-Rate (niedrigste zuerst - mehr Übung nötig)
    exercises.sort((a, b) {
      final rateA = _exerciseSuccessRate[a.id] ?? 0.0;
      final rateB = _exerciseSuccessRate[b.id] ?? 0.0;
      return rateA.compareTo(rateB);
    });

    // Wähle Übung mit niedrigster Erfolgs-Rate (braucht mehr Übung)
    // Oder zufällige, wenn alle ähnlich sind
    return exercises.first;
  }

  /// Wählt Übung mit Spaced Repetition
  Exercise _selectExerciseWithSpacedRepetition(
    List<Exercise> exercises,
    String childId,
    int index,
  ) {
    if (exercises.isEmpty) {
      return ExerciseLibrary.getBeginnerExercises().first;
    }

    // Spaced Repetition: Wiederhole schwierige Übungen öfter
    final history = _performanceHistory[childId] ?? [];
    if (history.isNotEmpty && index % 3 == 0) {
      // Jede 3. Übung: Wiederhole eine mit niedriger Erfolgs-Rate
      final lowPerformanceExercises = exercises.where((e) {
        final rate = _exerciseSuccessRate[e.id] ?? 100.0;
        return rate < 70.0;
      }).toList();

      if (lowPerformanceExercises.isNotEmpty) {
        return lowPerformanceExercises.first;
      }
    }

    // Sonst: Zufällige oder nächste Übung
    return exercises[index % exercises.length];
  }

  /// Generiert adaptive Übung (wenn alle abgeschlossen)
  Exercise _getAdaptiveExercise(
    ChildProfile profile,
    List<Exercise> availableExercises,
  ) {
    // Erhöhe Skill-Level und hole neue Übungen
    final newSkillLevel = (profile.currentSkillLevel + 1).clamp(1, 10);
    final newExercises = _getExercisesForSkillLevel(
      newSkillLevel,
      profile.hearingLossSeverity,
    );

    if (newExercises.isNotEmpty) {
      return newExercises.first;
    }

    // Fallback: Wiederhole letzte Übung mit erhöhter Schwierigkeit
    if (availableExercises.isNotEmpty) {
      final lastExercise = availableExercises.last;
      return lastExercise.copyWith(
        difficultyLevel: (lastExercise.difficultyLevel + 1).clamp(1, 10),
      );
    }

    // Ultimate Fallback
    return ExerciseLibrary.getBeginnerExercises().first;
  }

  /// Holt Performance-Historie
  List<SpeechAnalysisResult> getPerformanceHistory(String childId) {
    return _performanceHistory[childId] ?? [];
  }

  /// Löscht Performance-Historie
  void clearHistory(String childId) {
    _performanceHistory.remove(childId);
    _exerciseAttempts.clear();
    _exerciseSuccessRate.clear();
  }
}

