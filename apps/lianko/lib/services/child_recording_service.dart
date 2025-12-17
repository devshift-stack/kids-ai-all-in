import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:record/record.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import '../models/communication/communication_model.dart';

/// Service für Kind-Aufnahmen im Zeig-Sprech-Modul
/// Das Kind nimmt sich selbst auf, App spielt dann eigene Stimme ab

enum RecordingState {
  idle,
  recording,
  playing,
  processing,
}

class ChildRecordingService {
  // final _recorder = AudioRecorder();
  // final _player = AudioPlayer();

  RecordingState _state = RecordingState.idle;
  String? _currentRecordingPath;

  // Cache für geladene Aufnahmen (symbolId -> localPath)
  final Map<String, String> _recordingCache = {};

  RecordingState get state => _state;

  /// Startet Aufnahme für ein Symbol
  Future<void> startRecording(String symbolId) async {
    if (_state != RecordingState.idle) return;

    try {
      _state = RecordingState.recording;

      // Aufnahme-Pfad erstellen
      final dir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${dir.path}/child_recordings');
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }

      _currentRecordingPath = '${recordingsDir.path}/$symbolId.m4a';

      // TODO: Echte Aufnahme starten
      // await _recorder.start(
      //   RecordConfig(),
      //   path: _currentRecordingPath!,
      // );

      // Simuliere Aufnahme-Start
      if (kDebugMode) {
        print('🎙️ Aufnahme gestartet für: $symbolId');
      }

    } catch (e) {
      _state = RecordingState.idle;
      if (kDebugMode) {
        print('Fehler beim Starten der Aufnahme: $e');
      }
      rethrow;
    }
  }

  /// Stoppt Aufnahme und speichert
  Future<String?> stopRecording(String symbolId) async {
    if (_state != RecordingState.recording) return null;

    try {
      _state = RecordingState.processing;

      // TODO: Echte Aufnahme stoppen
      // final path = await _recorder.stop();

      // Simuliere Aufnahme-Ende
      final path = _currentRecordingPath;
      if (kDebugMode) {
        print('🎙️ Aufnahme beendet: $path');
      }

      if (path != null) {
        // In Cache speichern
        _recordingCache[symbolId] = path;

        // Optional: Zu Firebase hochladen für Sync
        // await _uploadToFirebase(symbolId, path);
      }

      _state = RecordingState.idle;
      _currentRecordingPath = null;

      return path;

    } catch (e) {
      _state = RecordingState.idle;
      if (kDebugMode) {
        print('Fehler beim Stoppen der Aufnahme: $e');
      }
      return null;
    }
  }

  /// Spielt Aufnahme des Kindes ab
  /// Falls keine Aufnahme vorhanden, wird TTS als Fallback verwendet
  Future<void> playRecording(String symbolId, String word) async {
    if (_state != RecordingState.idle) return;

    try {
      _state = RecordingState.playing;

      // Prüfe ob Kind-Aufnahme existiert
      final recordingPath = await _getRecordingPath(symbolId);

      if (recordingPath != null && await File(recordingPath).exists()) {
        // Kind's eigene Aufnahme abspielen
        if (kDebugMode) {
          print('🔊 Spiele Kind-Aufnahme: $word');
        }
        // TODO: Echte Wiedergabe
        // await _player.play(DeviceFileSource(recordingPath));
        // await _player.onPlayerComplete.first;

        // Simuliere Wiedergabe
        await Future.delayed(const Duration(milliseconds: 800));

      } else {
        // Fallback: TTS verwenden
        if (kDebugMode) {
          print('🔊 Kein Aufnahme vorhanden, nutze TTS für: $word');
        }
        // TODO: TTS Fallback
        // await FlutterTts().speak(word);
        await Future.delayed(const Duration(milliseconds: 500));
      }

      _state = RecordingState.idle;

    } catch (e) {
      _state = RecordingState.idle;
      if (kDebugMode) {
        print('Fehler bei Wiedergabe: $e');
      }
    }
  }

  /// Prüft ob Aufnahme für Symbol existiert
  Future<bool> hasRecording(String symbolId) async {
    final path = await _getRecordingPath(symbolId);
    if (path == null) return false;
    return File(path).exists();
  }

  /// Holt Aufnahme-Pfad aus Cache oder Dateisystem
  Future<String?> _getRecordingPath(String symbolId) async {
    // Erst im Cache schauen
    if (_recordingCache.containsKey(symbolId)) {
      return _recordingCache[symbolId];
    }

    // Dann im Dateisystem
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/child_recordings/$symbolId.m4a';

    if (await File(path).exists()) {
      _recordingCache[symbolId] = path;
      return path;
    }

    return null;
  }

  /// Löscht eine Aufnahme (für Neu-Aufnahme)
  Future<void> deleteRecording(String symbolId) async {
    final path = await _getRecordingPath(symbolId);
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      _recordingCache.remove(symbolId);
    }
  }

  /// Lädt alle vorhandenen Aufnahmen in den Cache
  Future<void> loadAllRecordings() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final recordingsDir = Directory('${dir.path}/child_recordings');

      if (!await recordingsDir.exists()) return;

      await for (final file in recordingsDir.list()) {
        if (file is File && file.path.endsWith('.m4a')) {
          final symbolId = file.path.split('/').last.replaceAll('.m4a', '');
          _recordingCache[symbolId] = file.path;
        }
      }

      if (kDebugMode) {
        print('📁 ${_recordingCache.length} Aufnahmen geladen');
      }

    } catch (e) {
      if (kDebugMode) {
        print('Fehler beim Laden der Aufnahmen: $e');
      }
    }
  }

  /// Holt Liste aller aufgenommenen Symbol-IDs
  Set<String> get recordedSymbolIds => _recordingCache.keys.toSet();

  /// Berechnet Fortschritt der Aufnahmen für eine Kategorie
  Future<double> getCategoryProgress(CommunicationCategory category) async {
    int recorded = 0;
    int total = 0;

    for (final symbol in category.symbols) {
      total++;
      if (await hasRecording(symbol.id)) recorded++;

      // Sub-Optionen zählen
      if (symbol.subOptions != null) {
        for (final sub in symbol.subOptions!) {
          total++;
          if (await hasRecording(sub.id)) recorded++;
        }
      }
    }

    return total > 0 ? recorded / total : 0;
  }

  void dispose() {
    // _recorder.dispose();
    // _player.dispose();
  }
}

/// Provider für den Recording Service
final childRecordingServiceProvider = Provider<ChildRecordingService>((ref) {
  final service = ChildRecordingService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider für Recording State
final recordingStateProvider = StreamProvider<RecordingState>((ref) {
  // TODO: Echten Stream implementieren
  return Stream.value(RecordingState.idle);
});

/// Provider für aufgenommene Symbol-IDs
final recordedSymbolsProvider = FutureProvider<Set<String>>((ref) async {
  final service = ref.watch(childRecordingServiceProvider);
  await service.loadAllRecordings();
  return service.recordedSymbolIds;
});
