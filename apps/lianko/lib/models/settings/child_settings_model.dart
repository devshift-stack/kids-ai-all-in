import 'package:cloud_firestore/cloud_firestore.dart';
import '../audiogram/audiogram_model.dart';

/// Komplettes Settings-Model für ein Kind
/// Wird vom ParentsDash gesteuert und in Echtzeit synchronisiert
class ChildSettingsModel {
  final String id;
  final String name;
  final int age;
  final String? avatarUrl;
  final TimeLimit timeLimit;
  final Map<String, GameSetting> gameSettings;
  final AccessibilitySettings accessibility;
  final LiankoSettings liankoSettings;
  final LeaderboardConsent leaderboardConsent;
  final AudiogramData? audiogram; // AI Audiogramm Reader Daten

  ChildSettingsModel({
    required this.id,
    required this.name,
    required this.age,
    this.avatarUrl,
    required this.timeLimit,
    required this.gameSettings,
    required this.accessibility,
    required this.liankoSettings,
    required this.leaderboardConsent,
    this.audiogram,
  });

  factory ChildSettingsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return ChildSettingsModel(
      id: doc.id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      avatarUrl: data['avatarUrl'],
      timeLimit: TimeLimit.fromMap(data['timeLimit'] ?? {}),
      gameSettings: _parseGameSettings(data['gameSettings']),
      accessibility: AccessibilitySettings.fromMap(data['accessibilitySettings'] ?? {}),
      liankoSettings: LiankoSettings.fromMap(data['liankoSettings'] ?? {}),
      leaderboardConsent: LeaderboardConsent.fromMap(data['leaderboardConsent'] ?? {}),
      audiogram: data['audiogram'] != null
          ? AudiogramData.fromMap(data['audiogram'])
          : null,
    );
  }

  static Map<String, GameSetting> _parseGameSettings(dynamic data) {
    if (data == null) return {};
    final map = data as Map<String, dynamic>;
    return map.map((key, value) => MapEntry(key, GameSetting.fromMap(value)));
  }

  /// Standardwerte für ein neues Kind (nicht verknüpft)
  factory ChildSettingsModel.defaults() {
    return ChildSettingsModel(
      id: '',
      name: 'Kind',
      age: 6,
      timeLimit: TimeLimit.defaults(),
      gameSettings: {},
      accessibility: AccessibilitySettings.defaults(),
      liankoSettings: LiankoSettings.defaults(),
      leaderboardConsent: LeaderboardConsent.defaults(),
    );
  }
}

/// Zeitlimit-Einstellungen
class TimeLimit {
  final int dailyMinutes;
  final int breakIntervalMinutes;
  final int breakDurationMinutes;
  final bool bedtimeEnabled;
  final String? bedtimeStart; // HH:mm
  final String? bedtimeEnd;   // HH:mm

  TimeLimit({
    required this.dailyMinutes,
    required this.breakIntervalMinutes,
    required this.breakDurationMinutes,
    required this.bedtimeEnabled,
    this.bedtimeStart,
    this.bedtimeEnd,
  });

  factory TimeLimit.fromMap(Map<String, dynamic> map) {
    return TimeLimit(
      dailyMinutes: map['dailyMinutes'] ?? 60,
      breakIntervalMinutes: map['breakIntervalMinutes'] ?? 30,
      breakDurationMinutes: map['breakDurationMinutes'] ?? 5,
      bedtimeEnabled: map['bedtimeEnabled'] ?? false,
      bedtimeStart: map['bedtimeStart'],
      bedtimeEnd: map['bedtimeEnd'],
    );
  }

  factory TimeLimit.defaults() {
    return TimeLimit(
      dailyMinutes: 60,
      breakIntervalMinutes: 30,
      breakDurationMinutes: 5,
      bedtimeEnabled: false,
    );
  }

  Map<String, dynamic> toMap() => {
    'dailyMinutes': dailyMinutes,
    'breakIntervalMinutes': breakIntervalMinutes,
    'breakDurationMinutes': breakDurationMinutes,
    'bedtimeEnabled': bedtimeEnabled,
    'bedtimeStart': bedtimeStart,
    'bedtimeEnd': bedtimeEnd,
  };
}

/// Einstellung für ein einzelnes Spiel
class GameSetting {
  final bool isEnabled;
  final int? maxLevel;

  GameSetting({
    required this.isEnabled,
    this.maxLevel,
  });

  factory GameSetting.fromMap(Map<String, dynamic> map) {
    return GameSetting(
      isEnabled: map['isEnabled'] ?? true,
      maxLevel: map['maxLevel'],
    );
  }

  factory GameSetting.defaults() {
    return GameSetting(isEnabled: true);
  }

  Map<String, dynamic> toMap() => {
    'isEnabled': isEnabled,
    'maxLevel': maxLevel,
  };
}

/// Barrierefreiheit-Einstellungen
class AccessibilitySettings {
  final bool subtitlesEnabled;
  final String subtitleLanguage;
  final double textScale;
  final bool highContrast;

  AccessibilitySettings({
    required this.subtitlesEnabled,
    required this.subtitleLanguage,
    required this.textScale,
    required this.highContrast,
  });

  factory AccessibilitySettings.fromMap(Map<String, dynamic> map) {
    return AccessibilitySettings(
      subtitlesEnabled: map['subtitlesEnabled'] ?? false,
      subtitleLanguage: map['subtitleLanguage'] ?? 'de',
      textScale: (map['textScale'] ?? 1.0).toDouble(),
      highContrast: map['highContrast'] ?? false,
    );
  }

  factory AccessibilitySettings.defaults() {
    return AccessibilitySettings(
      subtitlesEnabled: false,
      subtitleLanguage: 'de',
      textScale: 1.0,
      highContrast: false,
    );
  }

  Map<String, dynamic> toMap() => {
    'subtitlesEnabled': subtitlesEnabled,
    'subtitleLanguage': subtitleLanguage,
    'textScale': textScale,
    'highContrast': highContrast,
  };
}

/// Lianko-spezifische Einstellungen (Sprachtraining für Schwerhörige)
class LiankoSettings {
  final bool zeigSprechEnabled;      // Zeig-Sprech-Modul aktiviert
  final bool useChildRecordings;     // Kind-Aufnahmen nutzen statt TTS
  final bool allowReRecording;       // Kind darf neu aufnehmen
  final double speechRate;           // Sprechgeschwindigkeit (0.3-0.6)
  final String language;             // Sprache (bs, de, en, hr, sr, tr)
  final bool autoRepeat;             // Bei Fehler automatisch wiederholen
  final int maxAttempts;             // Max Versuche pro Wort
  final bool parentRecordingEnabled; // Eltern-Aufnahme aktiviert
  final bool hearingAidCheckEnabled; // Hörgeräte-Check vor YouTube/Videos
  final bool requireBothEars;        // Beide Ohren müssen Hörgeräte haben

  // Eltern-Benachrichtigungen
  final bool notifyParentOnNoHearingAid;  // Push wenn keine Hörgeräte
  final bool notifyParentOnDifficulty;    // Push bei Lern-Schwierigkeiten
  final bool dailySummaryEnabled;          // Tägliche Zusammenfassung senden

  LiankoSettings({
    required this.zeigSprechEnabled,
    required this.useChildRecordings,
    required this.allowReRecording,
    required this.speechRate,
    required this.language,
    required this.autoRepeat,
    required this.maxAttempts,
    required this.parentRecordingEnabled,
    required this.hearingAidCheckEnabled,
    required this.requireBothEars,
    required this.notifyParentOnNoHearingAid,
    required this.notifyParentOnDifficulty,
    required this.dailySummaryEnabled,
  });

  factory LiankoSettings.fromMap(Map<String, dynamic> map) {
    return LiankoSettings(
      zeigSprechEnabled: map['zeigSprechEnabled'] ?? false,
      useChildRecordings: map['useChildRecordings'] ?? true,
      allowReRecording: map['allowReRecording'] ?? false,
      speechRate: (map['speechRate'] ?? 0.4).toDouble(),
      language: map['language'] ?? 'bs',
      autoRepeat: map['autoRepeat'] ?? true,
      maxAttempts: map['maxAttempts'] ?? 3,
      parentRecordingEnabled: map['parentRecordingEnabled'] ?? false,
      hearingAidCheckEnabled: map['hearingAidCheckEnabled'] ?? true,
      requireBothEars: map['requireBothEars'] ?? false,
      notifyParentOnNoHearingAid: map['notifyParentOnNoHearingAid'] ?? true,
      notifyParentOnDifficulty: map['notifyParentOnDifficulty'] ?? true,
      dailySummaryEnabled: map['dailySummaryEnabled'] ?? false,
    );
  }

  factory LiankoSettings.defaults() {
    return LiankoSettings(
      zeigSprechEnabled: false,
      useChildRecordings: true,
      allowReRecording: false,
      speechRate: 0.4,
      language: 'bs',
      autoRepeat: true,
      maxAttempts: 3,
      parentRecordingEnabled: false,
      hearingAidCheckEnabled: true,       // Standard: AN
      requireBothEars: false,             // Standard: Ein Ohr reicht
      notifyParentOnNoHearingAid: true,   // Standard: AN
      notifyParentOnDifficulty: true,     // Standard: AN
      dailySummaryEnabled: false,         // Standard: AUS
    );
  }

  Map<String, dynamic> toMap() => {
    'zeigSprechEnabled': zeigSprechEnabled,
    'useChildRecordings': useChildRecordings,
    'allowReRecording': allowReRecording,
    'speechRate': speechRate,
    'language': language,
    'autoRepeat': autoRepeat,
    'maxAttempts': maxAttempts,
    'parentRecordingEnabled': parentRecordingEnabled,
    'hearingAidCheckEnabled': hearingAidCheckEnabled,
    'requireBothEars': requireBothEars,
    'notifyParentOnNoHearingAid': notifyParentOnNoHearingAid,
    'notifyParentOnDifficulty': notifyParentOnDifficulty,
    'dailySummaryEnabled': dailySummaryEnabled,
  };
}

/// Leaderboard-Einwilligung
class LeaderboardConsent {
  final bool canSeeLeaderboard;
  final bool canBeOnLeaderboard;
  final String displayNameType; // 'full', 'initials', 'anonymous'

  LeaderboardConsent({
    required this.canSeeLeaderboard,
    required this.canBeOnLeaderboard,
    required this.displayNameType,
  });

  factory LeaderboardConsent.fromMap(Map<String, dynamic> map) {
    return LeaderboardConsent(
      canSeeLeaderboard: map['canSeeLeaderboard'] ?? false,
      canBeOnLeaderboard: map['canBeOnLeaderboard'] ?? false,
      displayNameType: map['displayNameType'] ?? 'anonymous',
    );
  }

  factory LeaderboardConsent.defaults() {
    return LeaderboardConsent(
      canSeeLeaderboard: false,
      canBeOnLeaderboard: false,
      displayNameType: 'anonymous',
    );
  }

  Map<String, dynamic> toMap() => {
    'canSeeLeaderboard': canSeeLeaderboard,
    'canBeOnLeaderboard': canBeOnLeaderboard,
    'displayNameType': displayNameType,
  };
}
