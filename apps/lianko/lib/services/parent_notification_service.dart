import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings/child_settings_model.dart';
import '../providers/child_settings_provider.dart';

/// Arten von Eltern-Benachrichtigungen
enum ParentNotificationType {
  hearingAidNotWorn,      // Hörgeräte nicht getragen
  learningDifficulty,     // Schwierigkeiten beim Lernen
  dailyReport,            // Täglicher Fortschrittsbericht
  achievementUnlocked,    // Kind hat etwas erreicht
  sessionEnded,           // Spielsession beendet
}

/// Eine einzelne Benachrichtigung
class ParentNotification {
  final String id;
  final ParentNotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final DateTime timestamp;
  final bool isRead;

  ParentNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type.name,
    'title': title,
    'body': body,
    'data': data,
    'timestamp': Timestamp.fromDate(timestamp),
    'isRead': isRead,
  };

  factory ParentNotification.fromMap(Map<String, dynamic> map) {
    return ParentNotification(
      id: map['id'] ?? '',
      type: ParentNotificationType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ParentNotificationType.dailyReport,
      ),
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      data: map['data'],
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isRead: map['isRead'] ?? false,
    );
  }
}

/// Service für Eltern-Benachrichtigungen
///
/// Sendet Push-Benachrichtigungen an ParentsDash wenn:
/// - Kind keine Hörgeräte trägt (bei YouTube-Versuch)
/// - Kind Schwierigkeiten bei bestimmten Lauten/Wörtern hat
/// - Tägliche Zusammenfassung
class ParentNotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  ParentNotificationService(this._ref);

  /// Holt die aktuelle Kind-ID
  String? get _childId => _ref.read(currentChildIdProvider);

  // ============================================================
  // HÖRGERÄTE-BENACHRICHTIGUNGEN
  // ============================================================

  /// Benachrichtigt Eltern dass Kind keine Hörgeräte trägt
  Future<void> notifyHearingAidNotWorn({
    String? activity,
    int attemptCount = 1,
  }) async {
    final settings = _ref.read(childSettingsProvider);

    // Prüfen ob Benachrichtigung aktiviert
    if (!settings.liankoSettings.notifyParentOnNoHearingAid) {
      return;
    }

    await _sendNotification(
      type: ParentNotificationType.hearingAidNotWorn,
      title: '🦻 Hörgeräte-Erinnerung',
      body: activity != null
          ? 'Dein Kind wollte $activity starten, trägt aber keine Hörgeräte.'
          : 'Dein Kind trägt gerade keine Hörgeräte.',
      data: {
        'activity': activity,
        'attemptCount': attemptCount,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Speichert Hörgeräte-Check Ergebnis für Statistik
  Future<void> logHearingAidCheck({
    required bool wasWearing,
    required String context,
  }) async {
    final childId = _childId;
    if (childId == null) return;

    try {
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('hearingAidLogs')
          .add({
        'wasWearing': wasWearing,
        'context': context,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Wenn nicht getragen → Eltern benachrichtigen
      if (!wasWearing) {
        await notifyHearingAidNotWorn(activity: context);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Hörgeräte-Log Fehler: $e');
      }
    }
  }

  /// Holt Hörgeräte-Statistik für heute
  Future<HearingAidStats> getTodayHearingAidStats() async {
    final childId = _childId;
    if (childId == null) {
      return HearingAidStats(totalChecks: 0, wearingCount: 0, notWearingCount: 0);
    }

    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('hearingAidLogs')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .get();

      int wearing = 0;
      int notWearing = 0;

      for (final doc in snapshot.docs) {
        if (doc.data()['wasWearing'] == true) {
          wearing++;
        } else {
          notWearing++;
        }
      }

      return HearingAidStats(
        totalChecks: snapshot.docs.length,
        wearingCount: wearing,
        notWearingCount: notWearing,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Hörgeräte-Statistik Fehler: $e');
      }
      return HearingAidStats(totalChecks: 0, wearingCount: 0, notWearingCount: 0);
    }
  }

  // ============================================================
  // LERN-SCHWIERIGKEITEN BENACHRICHTIGUNGEN
  // ============================================================

  /// Benachrichtigt Eltern über Lern-Schwierigkeiten
  Future<void> notifyLearningDifficulty({
    required String category,
    required List<String> difficultItems,
    required int attemptCount,
  }) async {
    final settings = _ref.read(childSettingsProvider);

    // Prüfen ob Benachrichtigung aktiviert
    if (!settings.liankoSettings.notifyParentOnDifficulty) {
      return;
    }

    // Nur benachrichtigen wenn mehrere Versuche fehlgeschlagen
    if (attemptCount < 3) return;

    final itemsText = difficultItems.take(3).join(', ');

    await _sendNotification(
      type: ParentNotificationType.learningDifficulty,
      title: '📚 Lern-Hinweis',
      body: 'Dein Kind hatte heute Schwierigkeiten bei: $itemsText',
      data: {
        'category': category,
        'difficultItems': difficultItems,
        'attemptCount': attemptCount,
      },
    );
  }

  /// Speichert Lern-Schwierigkeit
  Future<void> logLearningDifficulty({
    required String word,
    required String category,
    required int attempts,
    required bool succeeded,
  }) async {
    final childId = _childId;
    if (childId == null) return;

    try {
      // Nur Schwierigkeiten loggen (nicht Erfolge)
      if (succeeded && attempts <= 2) return;

      await _firestore
          .collection('children')
          .doc(childId)
          .collection('learningDifficulties')
          .add({
        'word': word,
        'category': category,
        'attempts': attempts,
        'succeeded': succeeded,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Bei vielen Fehlversuchen → Eltern benachrichtigen
      if (!succeeded || attempts >= 3) {
        // Sammle Schwierigkeiten der letzten Stunde
        final recentDifficulties = await _getRecentDifficulties();
        if (recentDifficulties.length >= 3) {
          await notifyLearningDifficulty(
            category: category,
            difficultItems: recentDifficulties,
            attemptCount: attempts,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lern-Schwierigkeit Log Fehler: $e');
      }
    }
  }

  /// Holt Schwierigkeiten der letzten Stunde
  Future<List<String>> _getRecentDifficulties() async {
    final childId = _childId;
    if (childId == null) return [];

    try {
      final oneHourAgo = DateTime.now().subtract(const Duration(hours: 1));

      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('learningDifficulties')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(oneHourAgo))
          .where('succeeded', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .limit(10)
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['word'] as String)
          .toSet()
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ============================================================
  // ALLGEMEINE BENACHRICHTIGUNGEN
  // ============================================================

  /// Sendet eine Benachrichtigung an die Eltern
  Future<void> _sendNotification({
    required ParentNotificationType type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final childId = _childId;
    if (childId == null) return;

    try {
      final notification = ParentNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: type,
        title: title,
        body: body,
        data: data,
        timestamp: DateTime.now(),
      );

      // In Firestore speichern (ParentsDash liest diese)
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('parentNotifications')
          .add(notification.toMap());

      if (kDebugMode) {
        print('Eltern-Benachrichtigung gesendet: $title');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Benachrichtigung senden fehlgeschlagen: $e');
      }
    }
  }

  /// Sendet tägliche Zusammenfassung
  Future<void> sendDailySummary() async {
    final childId = _childId;
    if (childId == null) return;

    final hearingStats = await getTodayHearingAidStats();
    final difficulties = await _getRecentDifficulties();

    String body = 'Heute: ';

    if (hearingStats.totalChecks > 0) {
      final percentage = (hearingStats.wearingCount / hearingStats.totalChecks * 100).round();
      body += 'Hörgeräte $percentage% der Zeit getragen. ';
    }

    if (difficulties.isNotEmpty) {
      body += 'Übungsbedarf: ${difficulties.take(3).join(", ")}';
    } else {
      body += 'Keine Schwierigkeiten! 🎉';
    }

    await _sendNotification(
      type: ParentNotificationType.dailyReport,
      title: '📊 Tagesbericht',
      body: body,
      data: {
        'hearingAidStats': {
          'totalChecks': hearingStats.totalChecks,
          'wearingCount': hearingStats.wearingCount,
          'notWearingCount': hearingStats.notWearingCount,
        },
        'difficulties': difficulties,
      },
    );
  }
}

/// Hörgeräte-Statistik
class HearingAidStats {
  final int totalChecks;
  final int wearingCount;
  final int notWearingCount;

  HearingAidStats({
    required this.totalChecks,
    required this.wearingCount,
    required this.notWearingCount,
  });

  double get wearingPercentage =>
      totalChecks > 0 ? wearingCount / totalChecks * 100 : 0;
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// Parent Notification Service Provider
final parentNotificationServiceProvider = Provider<ParentNotificationService>((ref) {
  return ParentNotificationService(ref);
});

/// Heutige Hörgeräte-Statistik
final todayHearingAidStatsProvider = FutureProvider<HearingAidStats>((ref) async {
  final service = ref.watch(parentNotificationServiceProvider);
  return service.getTodayHearingAidStats();
});
