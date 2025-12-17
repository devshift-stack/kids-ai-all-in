import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings/child_settings_model.dart';
import '../providers/child_settings_provider.dart';

/// Service zur Prüfung des Spielzugriffs
///
/// Eltern können im ParentsDash einzelne Spiele aktivieren/deaktivieren.
/// Dieser Service filtert die verfügbaren Spiele basierend auf den Einstellungen.
class GameAccessService {
  /// Liste aller Spiel-IDs in Lianko
  static const List<String> allGameIds = [
    'letters',      // Buchstaben
    'numbers',      // Zahlen
    'colors',       // Farben
    'shapes',       // Formen
    'animals',      // Tiere
    'stories',      // Geschichten
    'vocabulary',   // Wortschatz
    'syllables',    // Silben-Training
    'quiz',         // Rätsel-Spiel
    'communication',// Zeig-Sprech-Modul
  ];

  /// Prüft ob ein bestimmtes Spiel für das Kind aktiviert ist
  bool isGameEnabled(ChildSettingsModel? settings, String gameId) {
    // Keine Settings = nicht verknüpft = alles erlaubt
    if (settings == null) return true;

    // Zeig-Sprech-Modul hat eigene Einstellung
    if (gameId == 'communication') {
      return settings.liankoSettings.zeigSprechEnabled;
    }

    final gameSetting = settings.gameSettings[gameId];
    return gameSetting?.isEnabled ?? true; // Default: aktiviert
  }

  /// Filtert eine Liste von Spielen basierend auf den Einstellungen
  List<GameItem> getAvailableGames(
    ChildSettingsModel? settings,
    List<GameItem> allGames,
  ) {
    return allGames.where((game) => isGameEnabled(settings, game.id)).toList();
  }

  /// Holt alle verfügbaren Spiel-IDs für ein Kind
  List<String> getAvailableGameIds(ChildSettingsModel? settings) {
    return allGameIds.where((id) => isGameEnabled(settings, id)).toList();
  }

  /// Zählt die Anzahl der verfügbaren Spiele
  int getAvailableGameCount(ChildSettingsModel? settings) {
    return getAvailableGameIds(settings).length;
  }

  /// Prüft ob alle Spiele deaktiviert sind (Notfall-Check)
  bool areAllGamesDisabled(ChildSettingsModel? settings) {
    return getAvailableGameCount(settings) == 0;
  }
}

/// Repräsentiert ein Spiel in der App
class GameItem {
  final String id;
  final String name;
  final String description;
  final String iconAsset;
  final String route;
  final bool isPremium;
  final int minAge;
  final int maxAge;

  const GameItem({
    required this.id,
    required this.name,
    required this.description,
    required this.iconAsset,
    required this.route,
    this.isPremium = false,
    this.minAge = 3,
    this.maxAge = 12,
  });

  /// Prüft ob das Spiel für ein bestimmtes Alter geeignet ist
  bool isSuitableForAge(int age) {
    return age >= minAge && age <= maxAge;
  }
}

/// Vordefinierte Spiele für Lianko
class LiankoGames {
  static const List<GameItem> all = [
    GameItem(
      id: 'letters',
      name: 'Buchstaben',
      description: 'Lerne das Alphabet',
      iconAsset: 'assets/games/letters.png',
      route: '/games/letters',
      minAge: 3,
      maxAge: 8,
    ),
    GameItem(
      id: 'numbers',
      name: 'Zahlen',
      description: 'Zählen lernen',
      iconAsset: 'assets/games/numbers.png',
      route: '/games/numbers',
      minAge: 3,
      maxAge: 8,
    ),
    GameItem(
      id: 'colors',
      name: 'Farben',
      description: 'Farben erkennen',
      iconAsset: 'assets/games/colors.png',
      route: '/games/colors',
      minAge: 3,
      maxAge: 6,
    ),
    GameItem(
      id: 'shapes',
      name: 'Formen',
      description: 'Formen kennenlernen',
      iconAsset: 'assets/games/shapes.png',
      route: '/games/shapes',
      minAge: 3,
      maxAge: 6,
    ),
    GameItem(
      id: 'animals',
      name: 'Tiere',
      description: 'Tiere und ihre Laute',
      iconAsset: 'assets/games/animals.png',
      route: '/games/animals',
      minAge: 3,
      maxAge: 8,
    ),
    GameItem(
      id: 'stories',
      name: 'Geschichten',
      description: 'Bilderbuch-Geschichten',
      iconAsset: 'assets/games/stories.png',
      route: '/stories',
      minAge: 3,
      maxAge: 12,
    ),
    GameItem(
      id: 'vocabulary',
      name: 'Wortschatz',
      description: 'Neue Wörter lernen',
      iconAsset: 'assets/games/vocabulary.png',
      route: '/vocabulary',
      minAge: 4,
      maxAge: 12,
    ),
    GameItem(
      id: 'syllables',
      name: 'Silben',
      description: 'Silben-Training',
      iconAsset: 'assets/games/syllables.png',
      route: '/syllables',
      minAge: 5,
      maxAge: 10,
    ),
    GameItem(
      id: 'quiz',
      name: 'Rätsel',
      description: 'Rate das richtige Bild',
      iconAsset: 'assets/games/quiz.png',
      route: '/quiz',
      minAge: 4,
      maxAge: 12,
    ),
    GameItem(
      id: 'communication',
      name: 'Zeig-Sprech',
      description: 'Zeige was du möchtest',
      iconAsset: 'assets/games/communication.png',
      route: '/communication',
      minAge: 3,
      maxAge: 12,
    ),
  ];

  /// Holt ein Spiel nach ID
  static GameItem? getById(String id) {
    try {
      return all.firstWhere((game) => game.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Filtert Spiele nach Alter
  static List<GameItem> getForAge(int age) {
    return all.where((game) => game.isSuitableForAge(age)).toList();
  }
}

// Riverpod Providers

final gameAccessServiceProvider = Provider<GameAccessService>((ref) {
  return GameAccessService();
});

/// Provider für verfügbare Spiele (gefiltert nach Settings)
final availableGamesProvider = Provider<List<GameItem>>((ref) {
  final settings = ref.watch(childSettingsProvider);
  final service = ref.watch(gameAccessServiceProvider);

  // Filtere nach Settings und Alter
  final filteredBySettings = service.getAvailableGames(settings, LiankoGames.all);
  return filteredBySettings.where((game) => game.isSuitableForAge(settings.age)).toList();
});

/// Provider zum Prüfen ob ein bestimmtes Spiel verfügbar ist
final isGameAvailableProvider = Provider.family<bool, String>((ref, gameId) {
  final settings = ref.watch(childSettingsProvider);
  final service = ref.watch(gameAccessServiceProvider);
  return service.isGameEnabled(settings, gameId);
});
