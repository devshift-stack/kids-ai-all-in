import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Belohnungssystem für Kinder
/// Sammelt Sterne, Sticker und Abzeichen

/// Belohnungs-Typen
enum RewardType {
  star,      // Sterne für einzelne Übungen
  sticker,   // Sticker für abgeschlossene Kategorien
  badge,     // Abzeichen für besondere Leistungen
  trophy,    // Pokale für große Meilensteine
}

/// Einzelne Belohnung
class Reward {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final RewardType type;
  final DateTime earnedAt;

  const Reward({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
    required this.earnedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'emoji': emoji,
    'type': type.index,
    'earnedAt': earnedAt.toIso8601String(),
  };

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    emoji: json['emoji'],
    type: RewardType.values[json['type']],
    earnedAt: DateTime.parse(json['earnedAt']),
  );
}

/// Verfügbare Abzeichen
class AvailableBadges {
  // Anfänger-Abzeichen
  static const firstWord = _BadgeInfo(
    id: 'first_word',
    name: 'Erstes Wort',
    description: 'Dein erstes Wort gesprochen!',
    emoji: '🌟',
    type: RewardType.badge,
  );

  static const fiveWords = _BadgeInfo(
    id: 'five_words',
    name: 'Wort-Sammler',
    description: '5 Wörter geübt',
    emoji: '📚',
    type: RewardType.badge,
  );

  static const tenWords = _BadgeInfo(
    id: 'ten_words',
    name: 'Wort-Meister',
    description: '10 Wörter geübt',
    emoji: '🎓',
    type: RewardType.badge,
  );

  // Silben-Abzeichen
  static const firstSyllable = _BadgeInfo(
    id: 'first_syllable',
    name: 'Silben-Start',
    description: 'Erstes Silben-Training!',
    emoji: '🎵',
    type: RewardType.badge,
  );

  static const syllableMaster = _BadgeInfo(
    id: 'syllable_master',
    name: 'Silben-Profi',
    description: '20 Silben-Wörter geübt',
    emoji: '🏆',
    type: RewardType.trophy,
  );

  // Geschichten-Abzeichen
  static const firstStory = _BadgeInfo(
    id: 'first_story',
    name: 'Geschichten-Fan',
    description: 'Erste Geschichte gehört',
    emoji: '📖',
    type: RewardType.badge,
  );

  static const storyTeller = _BadgeInfo(
    id: 'story_teller',
    name: 'Geschichten-Erzähler',
    description: '5 Geschichten abgeschlossen',
    emoji: '📚',
    type: RewardType.trophy,
  );

  // Rätsel-Abzeichen
  static const quizStart = _BadgeInfo(
    id: 'quiz_start',
    name: 'Rätsel-Rater',
    description: 'Erstes Rätsel gelöst',
    emoji: '🧩',
    type: RewardType.badge,
  );

  static const quizStreak5 = _BadgeInfo(
    id: 'quiz_streak_5',
    name: 'Blitz-Denker',
    description: '5 richtige hintereinander!',
    emoji: '⚡',
    type: RewardType.badge,
  );

  static const quizStreak10 = _BadgeInfo(
    id: 'quiz_streak_10',
    name: 'Super-Gehirn',
    description: '10 richtige hintereinander!',
    emoji: '🧠',
    type: RewardType.trophy,
  );

  // Aufnahme-Abzeichen
  static const firstRecording = _BadgeInfo(
    id: 'first_recording',
    name: 'Meine Stimme',
    description: 'Erstes Wort aufgenommen',
    emoji: '🎤',
    type: RewardType.badge,
  );

  static const voiceStar = _BadgeInfo(
    id: 'voice_star',
    name: 'Stimm-Star',
    description: '10 Wörter aufgenommen',
    emoji: '⭐',
    type: RewardType.trophy,
  );

  // Tägliche Abzeichen
  static const dailyLogin = _BadgeInfo(
    id: 'daily_login',
    name: 'Fleißig',
    description: 'Heute geübt!',
    emoji: '✅',
    type: RewardType.sticker,
  );

  static const weekStreak = _BadgeInfo(
    id: 'week_streak',
    name: 'Wochensieger',
    description: '7 Tage hintereinander geübt',
    emoji: '🏅',
    type: RewardType.trophy,
  );

  static List<_BadgeInfo> get all => [
    firstWord, fiveWords, tenWords,
    firstSyllable, syllableMaster,
    firstStory, storyTeller,
    quizStart, quizStreak5, quizStreak10,
    firstRecording, voiceStar,
    dailyLogin, weekStreak,
  ];
}

class _BadgeInfo {
  final String id;
  final String name;
  final String description;
  final String emoji;
  final RewardType type;

  const _BadgeInfo({
    required this.id,
    required this.name,
    required this.description,
    required this.emoji,
    required this.type,
  });

  Reward toReward() => Reward(
    id: id,
    name: name,
    description: description,
    emoji: emoji,
    type: type,
    earnedAt: DateTime.now(),
  );
}

/// Reward State
class RewardState {
  final int totalStars;
  final int totalStickers;
  final List<Reward> earnedRewards;
  final Map<String, int> activityCounts;  // z.B. 'words_practiced': 15
  final List<DateTime> practiceHistory;   // Für Streak-Berechnung
  final int currentStreak;                // Tage hintereinander

  const RewardState({
    this.totalStars = 0,
    this.totalStickers = 0,
    this.earnedRewards = const [],
    this.activityCounts = const {},
    this.practiceHistory = const [],
    this.currentStreak = 0,
  });

  bool hasBadge(String badgeId) {
    return earnedRewards.any((r) => r.id == badgeId);
  }

  int getActivityCount(String activity) {
    return activityCounts[activity] ?? 0;
  }

  RewardState copyWith({
    int? totalStars,
    int? totalStickers,
    List<Reward>? earnedRewards,
    Map<String, int>? activityCounts,
    List<DateTime>? practiceHistory,
    int? currentStreak,
  }) {
    return RewardState(
      totalStars: totalStars ?? this.totalStars,
      totalStickers: totalStickers ?? this.totalStickers,
      earnedRewards: earnedRewards ?? this.earnedRewards,
      activityCounts: activityCounts ?? this.activityCounts,
      practiceHistory: practiceHistory ?? this.practiceHistory,
      currentStreak: currentStreak ?? this.currentStreak,
    );
  }

  Map<String, dynamic> toJson() => {
    'totalStars': totalStars,
    'totalStickers': totalStickers,
    'earnedRewards': earnedRewards.map((r) => r.toJson()).toList(),
    'activityCounts': activityCounts,
    'practiceHistory': practiceHistory.map((d) => d.toIso8601String()).toList(),
    'currentStreak': currentStreak,
  };

  factory RewardState.fromJson(Map<String, dynamic> json) {
    return RewardState(
      totalStars: json['totalStars'] ?? 0,
      totalStickers: json['totalStickers'] ?? 0,
      earnedRewards: (json['earnedRewards'] as List?)
          ?.map((r) => Reward.fromJson(r))
          .toList() ?? [],
      activityCounts: Map<String, int>.from(json['activityCounts'] ?? {}),
      practiceHistory: (json['practiceHistory'] as List?)
          ?.map((d) => DateTime.parse(d))
          .toList() ?? [],
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}

/// Reward Service - verwaltet alle Belohnungen
class RewardService extends StateNotifier<RewardState> {
  static const _storageKey = 'lianko_rewards';

  RewardService() : super(const RewardState()) {
    _loadState();
  }

  /// Lädt gespeicherten Zustand
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_storageKey);
    if (json != null) {
      try {
        state = RewardState.fromJson(jsonDecode(json));
      } catch (e) {
        if (kDebugMode) {
          print('Fehler beim Laden der Belohnungen: $e');
        }
      }
    }
  }

  /// Speichert aktuellen Zustand
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(state.toJson()));
  }

  /// Fügt Sterne hinzu
  Future<void> addStars(int count) async {
    state = state.copyWith(totalStars: state.totalStars + count);
    await _saveState();
  }

  /// Fügt Sticker hinzu
  Future<void> addSticker() async {
    state = state.copyWith(totalStickers: state.totalStickers + 1);
    await _saveState();
  }

  /// Erhöht Aktivitäts-Zähler und prüft auf neue Abzeichen
  Future<List<Reward>> recordActivity(String activity, {int increment = 1}) async {
    final newCounts = Map<String, int>.from(state.activityCounts);
    newCounts[activity] = (newCounts[activity] ?? 0) + increment;

    state = state.copyWith(activityCounts: newCounts);

    // Prüfe auf neue Abzeichen
    final newBadges = await _checkForNewBadges(activity, newCounts[activity]!);

    await _saveState();
    return newBadges;
  }

  /// Markiert heutiges Üben
  Future<List<Reward>> recordDailyPractice() async {
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);

    // Prüfe ob heute schon geübt
    final alreadyPracticedToday = state.practiceHistory.any((d) {
      final dateStart = DateTime(d.year, d.month, d.day);
      return dateStart == todayStart;
    });

    if (alreadyPracticedToday) return [];

    // Füge heute hinzu
    final newHistory = [...state.practiceHistory, today];

    // Berechne Streak
    int streak = 1;
    for (int i = newHistory.length - 2; i >= 0; i--) {
      final prevDate = DateTime(
        newHistory[i].year,
        newHistory[i].month,
        newHistory[i].day,
      );
      final expectedPrevDate = todayStart.subtract(Duration(days: streak));

      if (prevDate == expectedPrevDate) {
        streak++;
      } else {
        break;
      }
    }

    state = state.copyWith(
      practiceHistory: newHistory,
      currentStreak: streak,
    );

    final newBadges = <Reward>[];

    // Daily Badge
    if (!state.hasBadge('daily_login')) {
      newBadges.add(await awardBadge(AvailableBadges.dailyLogin));
    }

    // Week Streak Badge
    if (streak >= 7 && !state.hasBadge('week_streak')) {
      newBadges.add(await awardBadge(AvailableBadges.weekStreak));
    }

    await _saveState();
    return newBadges;
  }

  /// Verleiht ein Abzeichen
  Future<Reward> awardBadge(_BadgeInfo badge) async {
    if (state.hasBadge(badge.id)) {
      return state.earnedRewards.firstWhere((r) => r.id == badge.id);
    }

    final reward = badge.toReward();
    state = state.copyWith(
      earnedRewards: [...state.earnedRewards, reward],
    );

    await _saveState();
    return reward;
  }

  /// Prüft automatisch auf neue Abzeichen
  Future<List<Reward>> _checkForNewBadges(String activity, int count) async {
    final newBadges = <Reward>[];

    switch (activity) {
      case 'words_practiced':
        if (count >= 1 && !state.hasBadge('first_word')) {
          newBadges.add(await awardBadge(AvailableBadges.firstWord));
        }
        if (count >= 5 && !state.hasBadge('five_words')) {
          newBadges.add(await awardBadge(AvailableBadges.fiveWords));
        }
        if (count >= 10 && !state.hasBadge('ten_words')) {
          newBadges.add(await awardBadge(AvailableBadges.tenWords));
        }
        break;

      case 'syllables_practiced':
        if (count >= 1 && !state.hasBadge('first_syllable')) {
          newBadges.add(await awardBadge(AvailableBadges.firstSyllable));
        }
        if (count >= 20 && !state.hasBadge('syllable_master')) {
          newBadges.add(await awardBadge(AvailableBadges.syllableMaster));
        }
        break;

      case 'stories_completed':
        if (count >= 1 && !state.hasBadge('first_story')) {
          newBadges.add(await awardBadge(AvailableBadges.firstStory));
        }
        if (count >= 5 && !state.hasBadge('story_teller')) {
          newBadges.add(await awardBadge(AvailableBadges.storyTeller));
        }
        break;

      case 'quiz_correct':
        if (count >= 1 && !state.hasBadge('quiz_start')) {
          newBadges.add(await awardBadge(AvailableBadges.quizStart));
        }
        break;

      case 'quiz_streak':
        if (count >= 5 && !state.hasBadge('quiz_streak_5')) {
          newBadges.add(await awardBadge(AvailableBadges.quizStreak5));
        }
        if (count >= 10 && !state.hasBadge('quiz_streak_10')) {
          newBadges.add(await awardBadge(AvailableBadges.quizStreak10));
        }
        break;

      case 'recordings_made':
        if (count >= 1 && !state.hasBadge('first_recording')) {
          newBadges.add(await awardBadge(AvailableBadges.firstRecording));
        }
        if (count >= 10 && !state.hasBadge('voice_star')) {
          newBadges.add(await awardBadge(AvailableBadges.voiceStar));
        }
        break;
    }

    return newBadges;
  }
}

// Providers
final rewardServiceProvider = StateNotifierProvider<RewardService, RewardState>((ref) {
  return RewardService();
});

final totalStarsProvider = Provider<int>((ref) {
  return ref.watch(rewardServiceProvider).totalStars;
});

final currentStreakProvider = Provider<int>((ref) {
  return ref.watch(rewardServiceProvider).currentStreak;
});

final earnedBadgesProvider = Provider<List<Reward>>((ref) {
  return ref.watch(rewardServiceProvider).earnedRewards;
});
