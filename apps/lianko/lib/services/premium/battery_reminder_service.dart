import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hörgeräte-Batterie Erinnerung Service
///
/// Erinnert Eltern/Kind an Batteriewechsel basierend auf:
/// - Eingestelltem Intervall (z.B. alle 5-7 Tage)
/// - Hörgeräte-Typ (Cochlea-Implantat vs. klassisches Hörgerät)
/// - Nutzungsmuster
class BatteryReminderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  static const String _prefsLastChangeKey = 'battery_last_change_date';
  static const String _prefsIntervalKey = 'battery_reminder_interval_days';
  static const String _prefsEnabledKey = 'battery_reminder_enabled';

  BatteryReminderService(this._ref);

  // ============================================================
  // EINSTELLUNGEN
  // ============================================================

  /// Speichert Batterie-Einstellungen
  Future<void> saveSettings(BatteryReminderSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsEnabledKey, settings.isEnabled);
    await prefs.setInt(_prefsIntervalKey, settings.intervalDays);

    if (settings.lastChangeDate != null) {
      await prefs.setString(
        _prefsLastChangeKey,
        settings.lastChangeDate!.toIso8601String(),
      );
    }

    // Auch in Firebase für Parent-Dashboard
    final childId = _ref.read(currentChildIdProvider);
    if (childId != null) {
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('battery')
          .set(settings.toMap());
    }
  }

  /// Lädt Batterie-Einstellungen
  Future<BatteryReminderSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    final isEnabled = prefs.getBool(_prefsEnabledKey) ?? true;
    final intervalDays = prefs.getInt(_prefsIntervalKey) ?? 7;
    final lastChangeDateStr = prefs.getString(_prefsLastChangeKey);

    DateTime? lastChangeDate;
    if (lastChangeDateStr != null) {
      lastChangeDate = DateTime.tryParse(lastChangeDateStr);
    }

    return BatteryReminderSettings(
      isEnabled: isEnabled,
      intervalDays: intervalDays,
      lastChangeDate: lastChangeDate,
    );
  }

  // ============================================================
  // BATTERIE-WECHSEL
  // ============================================================

  /// Markiert Batterie als gewechselt (heute)
  Future<void> markBatteryChanged() async {
    final settings = await loadSettings();
    final newSettings = BatteryReminderSettings(
      isEnabled: settings.isEnabled,
      intervalDays: settings.intervalDays,
      lastChangeDate: DateTime.now(),
    );
    await saveSettings(newSettings);

    // Log für Statistik
    await _logBatteryChange();
  }

  /// Loggt Batteriewechsel in Firebase
  Future<void> _logBatteryChange() async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return;

    try {
      await _firestore
          .collection('children')
          .doc(childId)
          .collection('batteryChanges')
          .add({
        'timestamp': FieldValue.serverTimestamp(),
        'type': 'manual', // manual oder scheduled
      });
    } catch (e) {
      if (kDebugMode) print('Battery log error: $e');
    }
  }

  // ============================================================
  // ERINNERUNGS-STATUS
  // ============================================================

  /// Prüft ob Erinnerung fällig ist
  Future<BatteryStatus> checkBatteryStatus() async {
    final settings = await loadSettings();

    if (!settings.isEnabled) {
      return BatteryStatus(
        needsReminder: false,
        daysUntilChange: null,
        daysSinceLastChange: null,
        message: 'Erinnerung deaktiviert',
      );
    }

    if (settings.lastChangeDate == null) {
      return BatteryStatus(
        needsReminder: true,
        daysUntilChange: 0,
        daysSinceLastChange: null,
        message: 'Wann hast du zuletzt die Batterien gewechselt?',
      );
    }

    final now = DateTime.now();
    final daysSinceChange = now.difference(settings.lastChangeDate!).inDays;
    final daysUntilChange = settings.intervalDays - daysSinceChange;

    if (daysUntilChange <= 0) {
      return BatteryStatus(
        needsReminder: true,
        daysUntilChange: 0,
        daysSinceLastChange: daysSinceChange,
        message: 'Zeit für neue Batterien! 🔋',
      );
    } else if (daysUntilChange <= 2) {
      return BatteryStatus(
        needsReminder: true,
        daysUntilChange: daysUntilChange,
        daysSinceLastChange: daysSinceChange,
        message: 'Noch $daysUntilChange Tag(e) bis zum Batteriewechsel',
      );
    } else {
      return BatteryStatus(
        needsReminder: false,
        daysUntilChange: daysUntilChange,
        daysSinceLastChange: daysSinceChange,
        message: 'Batterien sind noch gut! ✓',
      );
    }
  }

  /// Holt Batterie-Wechsel-Historie
  Future<List<DateTime>> getBatteryChangeHistory({int limit = 10}) async {
    final childId = _ref.read(currentChildIdProvider);
    if (childId == null) return [];

    try {
      final snapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('batteryChanges')
          .orderBy('timestamp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => (doc.data()['timestamp'] as Timestamp).toDate())
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Berechnet durchschnittliche Batterie-Lebensdauer
  Future<double?> getAverageBatteryLife() async {
    final history = await getBatteryChangeHistory(limit: 20);
    if (history.length < 2) return null;

    int totalDays = 0;
    for (int i = 0; i < history.length - 1; i++) {
      totalDays += history[i].difference(history[i + 1]).inDays;
    }

    return totalDays / (history.length - 1);
  }
}

// ============================================================
// MODELS
// ============================================================

/// Batterie-Erinnerungs-Einstellungen
class BatteryReminderSettings {
  final bool isEnabled;
  final int intervalDays;
  final DateTime? lastChangeDate;

  BatteryReminderSettings({
    required this.isEnabled,
    required this.intervalDays,
    this.lastChangeDate,
  });

  Map<String, dynamic> toMap() => {
    'isEnabled': isEnabled,
    'intervalDays': intervalDays,
    'lastChangeDate': lastChangeDate != null
        ? Timestamp.fromDate(lastChangeDate!)
        : null,
  };

  factory BatteryReminderSettings.fromMap(Map<String, dynamic> map) {
    return BatteryReminderSettings(
      isEnabled: map['isEnabled'] ?? true,
      intervalDays: map['intervalDays'] ?? 7,
      lastChangeDate: map['lastChangeDate'] != null
          ? (map['lastChangeDate'] as Timestamp).toDate()
          : null,
    );
  }

  /// Standard-Einstellungen
  factory BatteryReminderSettings.defaults() {
    return BatteryReminderSettings(
      isEnabled: true,
      intervalDays: 7,
      lastChangeDate: null,
    );
  }
}

/// Aktueller Batterie-Status
class BatteryStatus {
  final bool needsReminder;
  final int? daysUntilChange;
  final int? daysSinceLastChange;
  final String message;

  BatteryStatus({
    required this.needsReminder,
    this.daysUntilChange,
    this.daysSinceLastChange,
    required this.message,
  });
}

// ============================================================
// PROVIDERS
// ============================================================

/// Placeholder für Child ID - sollte aus dem echten Provider kommen
final currentChildIdProvider = Provider<String?>((ref) => null);

/// Battery Reminder Service Provider
final batteryReminderServiceProvider = Provider<BatteryReminderService>((ref) {
  return BatteryReminderService(ref);
});

/// Aktueller Batterie-Status
final batteryStatusProvider = FutureProvider<BatteryStatus>((ref) async {
  final service = ref.watch(batteryReminderServiceProvider);
  return service.checkBatteryStatus();
});

/// Batterie-Einstellungen
final batterySettingsProvider = FutureProvider<BatteryReminderSettings>((ref) async {
  final service = ref.watch(batteryReminderServiceProvider);
  return service.loadSettings();
});
