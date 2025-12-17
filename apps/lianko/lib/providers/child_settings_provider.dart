import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/settings/child_settings_model.dart';
import '../services/parent_link_service.dart';

/// Provider für die Child-ID (aus lokalem Speicher geladen)
final currentChildIdProvider = StateProvider<String?>((ref) => null);

/// Stream Provider für Echtzeit-Sync der Kind-Einstellungen
///
/// Wenn childId gesetzt ist, werden alle Einstellungen vom ParentsDash
/// in Echtzeit synchronisiert. Änderungen im Dashboard erscheinen sofort.
final childSettingsStreamProvider = StreamProvider<ChildSettingsModel?>((ref) {
  final childId = ref.watch(currentChildIdProvider);

  if (childId == null || childId.isEmpty) {
    // Nicht verknüpft = Standardwerte
    return Stream.value(ChildSettingsModel.defaults());
  }

  return FirebaseFirestore.instance
      .collection('children')
      .doc(childId)
      .snapshots()
      .map((doc) {
        if (!doc.exists) return ChildSettingsModel.defaults();
        return ChildSettingsModel.fromFirestore(doc);
      });
});

/// Synchrone Version der Settings (cached)
final childSettingsProvider = Provider<ChildSettingsModel>((ref) {
  final asyncSettings = ref.watch(childSettingsStreamProvider);
  return asyncSettings.when(
    data: (settings) => settings ?? ChildSettingsModel.defaults(),
    loading: () => ChildSettingsModel.defaults(),
    error: (_, __) => ChildSettingsModel.defaults(),
  );
});

/// Provider für Lianko-spezifische Settings
final liankoSettingsProvider = Provider<LiankoSettings>((ref) {
  final settings = ref.watch(childSettingsProvider);
  return settings.liankoSettings;
});

/// Provider für Zeitlimit-Settings
final timeLimitProvider = Provider<TimeLimit>((ref) {
  final settings = ref.watch(childSettingsProvider);
  return settings.timeLimit;
});

/// Provider für Accessibility-Settings
final accessibilityProvider = Provider<AccessibilitySettings>((ref) {
  final settings = ref.watch(childSettingsProvider);
  return settings.accessibility;
});

/// Provider zum Initialisieren der Child-ID beim App-Start
final childIdInitializerProvider = FutureProvider<String?>((ref) async {
  final linkService = ref.read(parentLinkServiceProvider);
  final childId = await linkService.getLinkedChildId();

  if (childId != null) {
    // Child-ID in State setzen
    ref.read(currentChildIdProvider.notifier).state = childId;
  }

  return childId;
});

/// Hilfsfunktion: Prüft ob ein bestimmtes Spiel aktiviert ist
bool isGameEnabled(ChildSettingsModel settings, String gameId) {
  final gameSetting = settings.gameSettings[gameId];
  return gameSetting?.isEnabled ?? true; // Default: aktiviert
}

/// Hilfsfunktion: Prüft ob Untertitel aktiviert sind
bool areSubtitlesEnabled(ChildSettingsModel settings) {
  return settings.accessibility.subtitlesEnabled;
}

/// Hilfsfunktion: Holt die Untertitel-Sprache
String getSubtitleLanguage(ChildSettingsModel settings) {
  return settings.accessibility.subtitleLanguage;
}
