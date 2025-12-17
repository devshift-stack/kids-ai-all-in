import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/settings/child_settings_model.dart';
import '../providers/child_settings_provider.dart';

/// Lokale Einstellungen für ein Kind (SharedPreferences)
/// Diese werden als Fallback genutzt wenn keine Firestore-Verbindung besteht
class ChildSettings {
  final bool subtitlesEnabled;      // Untertitel an/aus (default: aus)
  final String language;            // Sprache (default: bs)
  final double speechRate;          // Sprechgeschwindigkeit (0.3-0.6)
  final bool autoRepeat;            // Automatisch wiederholen bei Fehler
  final int maxAttempts;            // Max. Versuche pro Wort

  // Zeig-Sprech-Modul Einstellungen
  final bool zeigSprechEnabled;     // Modul aktiviert (default: aus)
  final bool useChildRecordings;    // Kind-Aufnahmen nutzen statt TTS (default: ja)
  final bool allowReRecording;      // Kind darf neu aufnehmen (Eltern-Genehmigung)

  const ChildSettings({
    this.subtitlesEnabled = false,  // Standard: AUS
    this.language = 'bs',
    this.speechRate = 0.4,
    this.autoRepeat = true,
    this.maxAttempts = 3,
    this.zeigSprechEnabled = false, // Standard: AUS (Eltern aktivieren)
    this.useChildRecordings = true, // Standard: JA (Kind-Stimme nutzen)
    this.allowReRecording = false,  // Standard: NEIN (Eltern müssen erlauben)
  });

  ChildSettings copyWith({
    bool? subtitlesEnabled,
    String? language,
    double? speechRate,
    bool? autoRepeat,
    int? maxAttempts,
    bool? zeigSprechEnabled,
    bool? useChildRecordings,
    bool? allowReRecording,
  }) {
    return ChildSettings(
      subtitlesEnabled: subtitlesEnabled ?? this.subtitlesEnabled,
      language: language ?? this.language,
      speechRate: speechRate ?? this.speechRate,
      autoRepeat: autoRepeat ?? this.autoRepeat,
      maxAttempts: maxAttempts ?? this.maxAttempts,
      zeigSprechEnabled: zeigSprechEnabled ?? this.zeigSprechEnabled,
      useChildRecordings: useChildRecordings ?? this.useChildRecordings,
      allowReRecording: allowReRecording ?? this.allowReRecording,
    );
  }

  Map<String, dynamic> toJson() => {
    'subtitlesEnabled': subtitlesEnabled,
    'language': language,
    'speechRate': speechRate,
    'autoRepeat': autoRepeat,
    'maxAttempts': maxAttempts,
    'zeigSprechEnabled': zeigSprechEnabled,
    'useChildRecordings': useChildRecordings,
    'allowReRecording': allowReRecording,
  };

  factory ChildSettings.fromJson(Map<String, dynamic> json) {
    return ChildSettings(
      subtitlesEnabled: json['subtitlesEnabled'] ?? false,
      language: json['language'] ?? 'bs',
      speechRate: (json['speechRate'] ?? 0.4).toDouble(),
      autoRepeat: json['autoRepeat'] ?? true,
      maxAttempts: json['maxAttempts'] ?? 3,
      zeigSprechEnabled: json['zeigSprechEnabled'] ?? false,
      useChildRecordings: json['useChildRecordings'] ?? true,
      allowReRecording: json['allowReRecording'] ?? false,
    );
  }

  /// Konvertiert von LiankoSettings (Firestore Model)
  factory ChildSettings.fromLiankoSettings(LiankoSettings liankoSettings, AccessibilitySettings accessibility) {
    return ChildSettings(
      subtitlesEnabled: accessibility.subtitlesEnabled,
      language: liankoSettings.language,
      speechRate: liankoSettings.speechRate,
      autoRepeat: liankoSettings.autoRepeat,
      maxAttempts: liankoSettings.maxAttempts,
      zeigSprechEnabled: liankoSettings.zeigSprechEnabled,
      useChildRecordings: liankoSettings.useChildRecordings,
      allowReRecording: liankoSettings.allowReRecording,
    );
  }
}

/// Service zum Laden/Speichern der Kind-Einstellungen
/// Nutzt Firestore für Echtzeit-Sync, SharedPreferences als Fallback
class ChildSettingsService {
  static const _keyPrefix = 'lianko_child_';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== Lokale Methoden (SharedPreferences) ====================

  /// Lädt Einstellungen aus lokalem Speicher
  Future<ChildSettings> loadLocalSettings(String childId) async {
    final prefs = await SharedPreferences.getInstance();

    return ChildSettings(
      subtitlesEnabled: prefs.getBool('${_keyPrefix}${childId}_subtitles') ?? false,
      language: prefs.getString('${_keyPrefix}${childId}_language') ?? 'bs',
      speechRate: prefs.getDouble('${_keyPrefix}${childId}_speechRate') ?? 0.4,
      autoRepeat: prefs.getBool('${_keyPrefix}${childId}_autoRepeat') ?? true,
      maxAttempts: prefs.getInt('${_keyPrefix}${childId}_maxAttempts') ?? 3,
      zeigSprechEnabled: prefs.getBool('${_keyPrefix}${childId}_zeigSprech') ?? false,
      useChildRecordings: prefs.getBool('${_keyPrefix}${childId}_useChildRec') ?? true,
      allowReRecording: prefs.getBool('${_keyPrefix}${childId}_allowReRec') ?? false,
    );
  }

  /// Speichert Einstellungen in lokalem Speicher (Cache)
  Future<void> saveLocalSettings(String childId, ChildSettings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('${_keyPrefix}${childId}_subtitles', settings.subtitlesEnabled);
    await prefs.setString('${_keyPrefix}${childId}_language', settings.language);
    await prefs.setDouble('${_keyPrefix}${childId}_speechRate', settings.speechRate);
    await prefs.setBool('${_keyPrefix}${childId}_autoRepeat', settings.autoRepeat);
    await prefs.setInt('${_keyPrefix}${childId}_maxAttempts', settings.maxAttempts);
    await prefs.setBool('${_keyPrefix}${childId}_zeigSprech', settings.zeigSprechEnabled);
    await prefs.setBool('${_keyPrefix}${childId}_useChildRec', settings.useChildRecordings);
    await prefs.setBool('${_keyPrefix}${childId}_allowReRec', settings.allowReRecording);
  }

  // ==================== Firestore Methoden (Remote Sync) ====================

  /// Lädt Einstellungen aus Firestore
  Future<ChildSettings?> loadFromFirestore(String childId) async {
    try {
      final doc = await _firestore.collection('children').doc(childId).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      final liankoSettings = LiankoSettings.fromMap(data['liankoSettings'] ?? {});
      final accessibility = AccessibilitySettings.fromMap(data['accessibilitySettings'] ?? {});

      return ChildSettings.fromLiankoSettings(liankoSettings, accessibility);
    } catch (e) {
      // Firestore nicht verfügbar, nutze lokale Daten
      return null;
    }
  }

  /// Speichert Lianko-spezifische Einstellungen in Firestore
  Future<void> saveToFirestore(String childId, ChildSettings settings) async {
    try {
      await _firestore.collection('children').doc(childId).update({
        'liankoSettings': {
          'zeigSprechEnabled': settings.zeigSprechEnabled,
          'useChildRecordings': settings.useChildRecordings,
          'allowReRecording': settings.allowReRecording,
          'speechRate': settings.speechRate,
          'language': settings.language,
          'autoRepeat': settings.autoRepeat,
          'maxAttempts': settings.maxAttempts,
          'parentRecordingEnabled': false,
        },
        'accessibilitySettings': {
          'subtitlesEnabled': settings.subtitlesEnabled,
          'subtitleLanguage': settings.language,
        },
      });
    } catch (e) {
      // Firestore nicht verfügbar, nur lokal speichern
    }
  }

  // ==================== Hybride Methoden (Firestore + Local) ====================

  /// Lädt Einstellungen (Firestore first, Local fallback)
  Future<ChildSettings> loadSettings(String childId) async {
    // 1. Versuche aus Firestore zu laden
    final firestoreSettings = await loadFromFirestore(childId);
    if (firestoreSettings != null) {
      // Cache lokal
      await saveLocalSettings(childId, firestoreSettings);
      return firestoreSettings;
    }

    // 2. Fallback: Lokale Daten
    return loadLocalSettings(childId);
  }

  /// Speichert Einstellungen (Lokal + Firestore)
  Future<void> saveSettings(String childId, ChildSettings settings) async {
    // 1. Immer lokal speichern
    await saveLocalSettings(childId, settings);

    // 2. Versuche Firestore zu aktualisieren
    await saveToFirestore(childId, settings);
  }

  /// Stream für Echtzeit-Sync aus Firestore
  Stream<ChildSettings> watchSettings(String childId) {
    return _firestore
        .collection('children')
        .doc(childId)
        .snapshots()
        .map((doc) {
          if (!doc.exists) return const ChildSettings();

          final data = doc.data() as Map<String, dynamic>;
          final liankoSettings = LiankoSettings.fromMap(data['liankoSettings'] ?? {});
          final accessibility = AccessibilitySettings.fromMap(data['accessibilitySettings'] ?? {});

          return ChildSettings.fromLiankoSettings(liankoSettings, accessibility);
        });
  }

  /// Setzt nur Untertitel an/aus
  Future<void> setSubtitles(String childId, bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('${_keyPrefix}${childId}_subtitles', enabled);

    try {
      await _firestore.collection('children').doc(childId).update({
        'accessibilitySettings.subtitlesEnabled': enabled,
      });
    } catch (_) {}
  }

  /// Setzt nur Sprache
  Future<void> setLanguage(String childId, String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${_keyPrefix}${childId}_language', language);

    try {
      await _firestore.collection('children').doc(childId).update({
        'liankoSettings.language': language,
        'accessibilitySettings.subtitleLanguage': language,
      });
    } catch (_) {}
  }
}

// Providers
final childSettingsServiceProvider = Provider<ChildSettingsService>((ref) {
  return ChildSettingsService();
});

/// Provider für aktuelle Kind-Einstellungen (mit childId)
final localChildSettingsProvider = FutureProvider.family<ChildSettings, String>((ref, childId) async {
  final service = ref.watch(childSettingsServiceProvider);
  return service.loadSettings(childId);
});

/// Stream Provider für Echtzeit-Sync der lokalen Settings
final localChildSettingsStreamProvider = StreamProvider.family<ChildSettings, String>((ref, childId) {
  final service = ref.watch(childSettingsServiceProvider);
  return service.watchSettings(childId);
});

/// Globale Einstellungen (ohne childId, für einfache Fälle)
final currentChildSettingsProvider = StateProvider<ChildSettings>((ref) {
  return const ChildSettings(); // Default: Untertitel AUS
});

/// Provider der die aktuellen Settings aus dem Firestore-Model konvertiert
final liankoChildSettingsProvider = Provider<ChildSettings>((ref) {
  final fullSettings = ref.watch(childSettingsProvider);
  return ChildSettings.fromLiankoSettings(
    fullSettings.liankoSettings,
    fullSettings.accessibility,
  );
});
