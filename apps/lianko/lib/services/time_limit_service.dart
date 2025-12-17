import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings/child_settings_model.dart';
import '../providers/child_settings_provider.dart';

/// Service zur Verwaltung von Zeitlimits
///
/// Überwacht:
/// - Tägliche Spielzeit
/// - Pausen-Intervalle
/// - Schlafenszeit
class TimeLimitService {
  static const String _todayPlayTimeKey = 'today_play_time_minutes';
  static const String _lastPlayDateKey = 'last_play_date';
  static const String _sessionStartKey = 'session_start_time';

  Timer? _sessionTimer;

  /// Prüft ob das Kind noch spielen darf
  Future<TimeLimitStatus> checkTimeLimit(TimeLimit? timeLimit) async {
    // Keine Limits gesetzt = erlaubt
    if (timeLimit == null) return TimeLimitStatus.allowed();

    // Tägliche Spielzeit laden
    final todayMinutes = await _getTodayPlayTime();

    // 1. Tägliches Limit erreicht?
    if (todayMinutes >= timeLimit.dailyMinutes) {
      return TimeLimitStatus.limitReached(
        message: 'Du hast heute schon ${timeLimit.dailyMinutes} Minuten gespielt! Bis morgen! 🌙',
        usedMinutes: todayMinutes,
        limitMinutes: timeLimit.dailyMinutes,
      );
    }

    // 2. Schlafenszeit?
    if (timeLimit.bedtimeEnabled && _isDuringBedtime(timeLimit)) {
      return TimeLimitStatus.bedtime(
        message: 'Es ist Schlafenszeit! Gute Nacht! 😴',
        bedtimeStart: timeLimit.bedtimeStart,
        bedtimeEnd: timeLimit.bedtimeEnd,
      );
    }

    // 3. Pause nötig?
    final sessionMinutes = await _getCurrentSessionTime();
    if (sessionMinutes >= timeLimit.breakIntervalMinutes) {
      return TimeLimitStatus.breakNeeded(
        breakMinutes: timeLimit.breakDurationMinutes,
        message: 'Zeit für eine kleine Pause! ${timeLimit.breakDurationMinutes} Minuten 🧘',
      );
    }

    // Alles OK
    final remainingMinutes = timeLimit.dailyMinutes - todayMinutes;
    return TimeLimitStatus.allowed(
      remainingMinutes: remainingMinutes,
      sessionMinutes: sessionMinutes,
    );
  }

  /// Startet eine neue Spielsession
  Future<void> startSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionStartKey, DateTime.now().toIso8601String());

    // Timer starten (jede Minute aktualisieren)
    _sessionTimer?.cancel();
    _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _addPlayTime(1);
    });
  }

  /// Beendet die aktuelle Session
  Future<void> endSession() async {
    _sessionTimer?.cancel();
    _sessionTimer = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionStartKey);
  }

  /// Pausiert die Session (z.B. App in Background)
  void pauseSession() {
    _sessionTimer?.cancel();
  }

  /// Setzt die Session fort
  void resumeSession() {
    if (_sessionTimer == null || !_sessionTimer!.isActive) {
      _sessionTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
        await _addPlayTime(1);
      });
    }
  }

  /// Prüft ob aktuell Schlafenszeit ist
  bool _isDuringBedtime(TimeLimit timeLimit) {
    if (!timeLimit.bedtimeEnabled) return false;
    if (timeLimit.bedtimeStart == null || timeLimit.bedtimeEnd == null) return false;

    final now = TimeOfDay.now();
    final start = _parseTime(timeLimit.bedtimeStart!);
    final end = _parseTime(timeLimit.bedtimeEnd!);

    if (start == null || end == null) return false;

    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    // Über Mitternacht?
    if (startMinutes > endMinutes) {
      return nowMinutes >= startMinutes || nowMinutes < endMinutes;
    } else {
      return nowMinutes >= startMinutes && nowMinutes < endMinutes;
    }
  }

  TimeOfDay? _parseTime(String time) {
    try {
      final parts = time.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    } catch (_) {
      return null;
    }
  }

  /// Holt die heutige Spielzeit in Minuten
  Future<int> _getTodayPlayTime() async {
    final prefs = await SharedPreferences.getInstance();

    // Prüfen ob es ein neuer Tag ist
    final lastPlayDate = prefs.getString(_lastPlayDateKey);
    final today = DateTime.now().toIso8601String().substring(0, 10);

    if (lastPlayDate != today) {
      // Neuer Tag = Reset
      await prefs.setInt(_todayPlayTimeKey, 0);
      await prefs.setString(_lastPlayDateKey, today);
      return 0;
    }

    return prefs.getInt(_todayPlayTimeKey) ?? 0;
  }

  /// Aktuelle Session-Zeit in Minuten
  Future<int> _getCurrentSessionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final startStr = prefs.getString(_sessionStartKey);

    if (startStr == null) return 0;

    final start = DateTime.tryParse(startStr);
    if (start == null) return 0;

    return DateTime.now().difference(start).inMinutes;
  }

  /// Fügt Spielzeit hinzu
  Future<void> _addPlayTime(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await _getTodayPlayTime();
    await prefs.setInt(_todayPlayTimeKey, current + minutes);
  }

  /// Setzt die tägliche Spielzeit zurück (für Tests/Debug)
  Future<void> resetDailyPlayTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_todayPlayTimeKey, 0);
  }

  void dispose() {
    _sessionTimer?.cancel();
  }
}

/// Status der Zeitlimit-Prüfung
class TimeLimitStatus {
  final bool canPlay;
  final TimeLimitReason reason;
  final String? message;
  final int? remainingMinutes;
  final int? breakMinutes;
  final int? usedMinutes;
  final int? limitMinutes;
  final int? sessionMinutes;
  final String? bedtimeStart;
  final String? bedtimeEnd;

  TimeLimitStatus._({
    required this.canPlay,
    required this.reason,
    this.message,
    this.remainingMinutes,
    this.breakMinutes,
    this.usedMinutes,
    this.limitMinutes,
    this.sessionMinutes,
    this.bedtimeStart,
    this.bedtimeEnd,
  });

  factory TimeLimitStatus.allowed({
    int? remainingMinutes,
    int? sessionMinutes,
  }) =>
      TimeLimitStatus._(
        canPlay: true,
        reason: TimeLimitReason.allowed,
        remainingMinutes: remainingMinutes,
        sessionMinutes: sessionMinutes,
      );

  factory TimeLimitStatus.limitReached({
    required String message,
    required int usedMinutes,
    required int limitMinutes,
  }) =>
      TimeLimitStatus._(
        canPlay: false,
        reason: TimeLimitReason.dailyLimitReached,
        message: message,
        usedMinutes: usedMinutes,
        limitMinutes: limitMinutes,
      );

  factory TimeLimitStatus.bedtime({
    required String message,
    String? bedtimeStart,
    String? bedtimeEnd,
  }) =>
      TimeLimitStatus._(
        canPlay: false,
        reason: TimeLimitReason.bedtime,
        message: message,
        bedtimeStart: bedtimeStart,
        bedtimeEnd: bedtimeEnd,
      );

  factory TimeLimitStatus.breakNeeded({
    required int breakMinutes,
    required String message,
  }) =>
      TimeLimitStatus._(
        canPlay: false,
        reason: TimeLimitReason.breakNeeded,
        message: message,
        breakMinutes: breakMinutes,
      );

  /// Formatierte verbleibende Zeit
  String get remainingTimeFormatted {
    if (remainingMinutes == null) return '';
    final hours = remainingMinutes! ~/ 60;
    final mins = remainingMinutes! % 60;
    if (hours > 0) {
      return '${hours}h ${mins}min';
    }
    return '${mins}min';
  }
}

enum TimeLimitReason {
  allowed,
  dailyLimitReached,
  bedtime,
  breakNeeded,
}

// Riverpod Providers

final timeLimitServiceProvider = Provider<TimeLimitService>((ref) {
  final service = TimeLimitService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider für den aktuellen Zeitlimit-Status
final timeLimitStatusProvider = FutureProvider<TimeLimitStatus>((ref) async {
  final timeLimit = ref.watch(timeLimitProvider);
  final service = ref.watch(timeLimitServiceProvider);
  return await service.checkTimeLimit(timeLimit);
});

/// Provider für die verbleibende Spielzeit
final remainingPlayTimeProvider = FutureProvider<int?>((ref) async {
  final status = await ref.watch(timeLimitStatusProvider.future);
  return status.remainingMinutes;
});
