import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/youtube/youtube_settings.dart';
import 'parent_child_service.dart';

/// Service zur Verwaltung des YouTube Belohnungssystems
class YouTubeRewardService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  YouTubeSettings _settings = const YouTubeSettings();
  YouTubeSettings get settings => _settings;
  
  // Tracking
  int _watchedMinutesToday = 0;
  int _tasksCompletedForSession = 0;
  bool _canWatch = true;
  Timer? _watchTimer;
  int _currentSessionMinutes = 0;
  
  int get watchedMinutesToday => _watchedMinutesToday;
  int get tasksCompletedForSession => _tasksCompletedForSession;
  bool get canWatch => _canWatch && _settings.isEnabled;
  int get tasksNeeded => _settings.tasksRequired - _tasksCompletedForSession;
  int get currentSessionMinutes => _currentSessionMinutes;
  
  // Sichere kindgerechte Videos (verifizierte YouTube IDs von Kinderkanälen)
  final List<Map<String, String>> _defaultSafeVideos = [
    // Cocomelon - Nursery Rhymes
    {'id': 'YwGPBkqJqbk', 'title': '🦈 Baby Shark', 'channel': 'Cocomelon'},
    {'id': 'e_04ZrNroTo', 'title': '🚌 Wheels on the Bus', 'channel': 'Cocomelon'},
    {'id': 'QkHQ0CYwjaI', 'title': '🔤 ABC Phonics Song', 'channel': 'Cocomelon'},

    // Super Simple Songs
    {'id': 'eCemGoEkVbA', 'title': '🌈 Rainbow Colors Song', 'channel': 'Super Simple'},
    {'id': 'DR-cfDsHCGA', 'title': '🔢 Count 1 to 10', 'channel': 'Super Simple'},
    {'id': 'Yt8GFgxlITs', 'title': '🐶 Old MacDonald', 'channel': 'Super Simple'},

    // Pinkfong
    {'id': 'XqZsoesa55w', 'title': '🦈 Baby Shark Original', 'channel': 'Pinkfong'},
    {'id': '4MR6D7tL40U', 'title': '🦁 Animal Songs Mix', 'channel': 'Pinkfong'},

    // Dave and Ava
    {'id': 'x00lXjDnLTQ', 'title': '⭐ Twinkle Twinkle', 'channel': 'Dave and Ava'},
    {'id': 'hPIrvk4KHLA', 'title': '🐑 Mary Had a Little Lamb', 'channel': 'Dave and Ava'},

    // Little Baby Bum
    {'id': 'gZSqJ8U0RQk', 'title': '🚗 5 Little Cars', 'channel': 'Little Baby Bum'},
    {'id': 'TxYF2S_WL50', 'title': '🎂 Happy Birthday Song', 'channel': 'Little Baby Bum'},

    // Blippi (Lernvideos)
    {'id': 'DHi9EvW7wQg', 'title': '🎨 Learn Colors', 'channel': 'Blippi'},
    {'id': 'BKVm5pJTfOU', 'title': '🚜 Vehicles for Kids', 'channel': 'Blippi'},

    // Hey Bear Sensory
    {'id': 'MIL_BkIX3T0', 'title': '🌈 Baby Sensory Rainbow', 'channel': 'Hey Bear'},
  ];
  
  List<Map<String, String>> get safeVideos => _defaultSafeVideos;
  
  String? _childId;
  String? _parentId;
  StreamSubscription<DocumentSnapshot>? _settingsSubscription;
  Completer<void>? _initializationCompleter;
  bool _isInitializing = false;
  
  String? get childId => _childId;
  String? get parentId => _parentId;
  
  /// Initialisiert den Service für ein Kind
  Future<void> initialize(String childId, {String? parentId}) async {
    // Prüfe ob bereits mit gleichen Parametern initialisiert
    if (_childId == childId && _parentId == parentId && _initializationCompleter == null) {
      return; // Bereits initialisiert mit gleichen Parametern
    }
    
    // Wenn Initialisierung bereits läuft, warte auf Abschluss
    if (_isInitializing && _initializationCompleter != null) {
      return _initializationCompleter!.future;
    }
    
    // Starte neue Initialisierung
    _isInitializing = true;
    _initializationCompleter = Completer<void>();
    
    try {
      // Lokale Variablen verwenden, um Race Condition zu vermeiden
      final localChildId = childId;
      final localParentId = parentId;
      
      // Verwende lokale Variablen für async Operationen (BEVOR Felder gesetzt werden)
      await _loadLocalState(localChildId);
      
      // Setze Felder erst NACH erfolgreichem Laden des lokalen States
      _childId = localChildId;
      _parentId = localParentId;
      
      // Jetzt Settings-Listener starten (nutzt die gesetzten Felder)
      _listenToSettings(localChildId, localParentId);
      
      _initializationCompleter!.complete();
    } catch (e) {
      _initializationCompleter!.completeError(e);
      rethrow;
    } finally {
      _isInitializing = false;
      _initializationCompleter = null;
    }
  }
  
  /// Lädt lokalen Status aus SharedPreferences
  Future<void> _loadLocalState(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final savedDate = prefs.getString('youtube_date_$childId');
    
    if (savedDate == today) {
      _watchedMinutesToday = prefs.getInt('youtube_watched_$childId') ?? 0;
    } else {
      // Neuer Tag - Reset
      _watchedMinutesToday = 0;
      await prefs.setString('youtube_date_$childId', today);
      await prefs.setInt('youtube_watched_$childId', 0);
    }
    
    _updateCanWatch();
    notifyListeners();
  }
  
  /// Speichert lokalen Status
  Future<void> _saveLocalState() async {
    if (_childId == null) return; // Kein childId gesetzt, nichts zu speichern
    
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    final childId = _childId!; // Lokale Variable verwenden
    await prefs.setString('youtube_date_$childId', today);
    await prefs.setInt('youtube_watched_$childId', _watchedMinutesToday);
  }
  
  /// Lauscht auf Settings-Änderungen von Parent Dashboard
  void _listenToSettings(String childId, String? parentId) {
    _settingsSubscription?.cancel();
    
    // Wenn parentId vorhanden, verschachtelte Struktur nutzen
    if (parentId != null) {
      _settingsSubscription = _firestore
          .collection('parents')
          .doc(parentId)
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('youtube')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _settings = YouTubeSettings.fromMap(snapshot.data()!);
          _updateCanWatch();
          notifyListeners();
        }
      });
    } else {
      // Fallback: flache Struktur für anonyme Nutzer (Legacy)
      _settingsSubscription = _firestore
          .collection('children')
          .doc(childId)
          .collection('settings')
          .doc('youtube')
          .snapshots()
          .listen((snapshot) {
        if (snapshot.exists) {
          _settings = YouTubeSettings.fromMap(snapshot.data()!);
          _updateCanWatch();
          notifyListeners();
        }
      });
    }
  }
  
  /// Prüft ob Kind noch schauen darf
  void _updateCanWatch() {
    // Prüfe tägliches Limit
    if (_settings.dailyLimitMinutes > 0 && 
        _watchedMinutesToday >= _settings.dailyLimitMinutes) {
      _canWatch = false;
      return;
    }
    
    // Prüfe ob Aufgaben nötig sind
    if (_currentSessionMinutes >= _settings.watchMinutesAllowed &&
        _tasksCompletedForSession < _settings.tasksRequired) {
      _canWatch = false;
      return;
    }
    
    _canWatch = true;
  }
  
  /// Startet das Anschauen (Timer läuft)
  void startWatching() {
    _watchTimer?.cancel();
    _watchTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _watchedMinutesToday++;
      _currentSessionMinutes++;
      _saveLocalState();
      _updateCanWatch();
      notifyListeners();
      
      if (!_canWatch) {
        pauseWatching();
      }
    });
  }
  
  /// Pausiert das Anschauen
  void pauseWatching() {
    _watchTimer?.cancel();
    _watchTimer = null;
  }
  
  /// Kind hat eine Aufgabe erledigt
  void completeTask() {
    _tasksCompletedForSession++;
    
    if (_tasksCompletedForSession >= _settings.tasksRequired) {
      // Alle Aufgaben erledigt - Session reset
      _currentSessionMinutes = 0;
      _tasksCompletedForSession = 0;
      _updateCanWatch();
    }
    
    notifyListeners();
  }
  
  /// Prüft ob YouTube Feature angezeigt werden soll
  bool get shouldShowYouTube => _settings.isEnabled;
  
  /// Gibt verbleibende Zeit zurück
  int get remainingMinutes {
    if (_settings.dailyLimitMinutes == 0) return -1; // Unbegrenzt
    return _settings.dailyLimitMinutes - _watchedMinutesToday;
  }
  
  /// Gibt Session-Zeit bis zur nächsten Pause zurück
  int get minutesUntilPause {
    return _settings.watchMinutesAllowed - _currentSessionMinutes;
  }
  
  @override
  void dispose() {
    _watchTimer?.cancel();
    _settingsSubscription?.cancel();
    super.dispose();
  }
}

// Provider
final youtubeRewardServiceProvider = ChangeNotifierProvider<YouTubeRewardService>((ref) {
  final service = YouTubeRewardService();
  
  // Automatische Initialisierung wenn parentId/childId verfügbar
  final parentChildService = ref.watch(parentChildServiceProvider);
  final parentId = parentChildService.parentId;
  final childId = parentChildService.activeChildId;
  
  // Initialisierung nur wenn ParentChildService bereits initialisiert ist
  if (parentChildService.isInitialized && childId != null) {
    // Initialisierung asynchron starten - wird im Hintergrund abgeschlossen
    service.initialize(childId, parentId: parentId).catchError((error) {
      debugPrint('Error initializing YouTubeRewardService: $error');
    });
  }
  
  // Listener für Änderungen an parentId/childId
  ref.listen<ParentChildService>(
    parentChildServiceProvider,
    (previous, next) {
      final newChildId = next.activeChildId;
      final newParentId = next.parentId;
      
      // Re-initialize wenn childId ODER parentId sich ändert
      // WICHTIG: Prüfe beide Werte, nicht nur childId
      if (next.isInitialized && 
          newChildId != null && 
          (newChildId != service.childId || newParentId != service.parentId)) {
        service.initialize(newChildId, parentId: newParentId).catchError((error) {
          debugPrint('Error re-initializing YouTubeRewardService: $error');
        });
      }
    },
  );
  
  return service;
});

// Settings Provider (für UI)
final youtubeSettingsProvider = Provider<YouTubeSettings>((ref) {
  return ref.watch(youtubeRewardServiceProvider).settings;
});

// Can Watch Provider
final canWatchYouTubeProvider = Provider<bool>((ref) {
  return ref.watch(youtubeRewardServiceProvider).canWatch;
});
