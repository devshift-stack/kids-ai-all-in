import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Zustände des Sprachtrainings
enum SpeechTrainingState {
  idle,           // Warte auf Aktion
  speaking,       // Lianko spricht vor
  listening,      // Kind spricht nach
  processing,     // Auswertung läuft
  feedback,       // Feedback wird gezeigt
}

/// Ergebnis einer Sprechübung
class SpeechResult {
  final String targetWord;      // Zielwort
  final String spokenWord;      // Was das Kind gesagt hat
  final double confidence;      // Erkennungssicherheit (0-1)
  final bool isCorrect;         // Richtig ausgesprochen?
  final String feedback;        // Feedback-Text

  SpeechResult({
    required this.targetWord,
    required this.spokenWord,
    required this.confidence,
    required this.isCorrect,
    required this.feedback,
  });
}

/// Wort mit Timing für synchrone Untertitel
class TimedWord {
  final String word;
  final int startMs;
  final int endMs;

  TimedWord({required this.word, required this.startMs, required this.endMs});
}

/// Hauptservice für Sprachtraining bei schwerhörigen Kindern
class SpeechTrainingService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();

  int _currentAge = 6;
  String _currentLanguage = 'bs-BA';
  SpeechTrainingState _state = SpeechTrainingState.idle;
  bool _sttAvailable = false;

  // Stream Controllers
  final _stateController = StreamController<SpeechTrainingState>.broadcast();
  final _currentWordController = StreamController<String>.broadcast();
  final _subtitleController = StreamController<String>.broadcast();
  final _resultController = StreamController<SpeechResult>.broadcast();
  final _progressController = StreamController<double>.broadcast();

  // Streams
  Stream<SpeechTrainingState> get stateStream => _stateController.stream;
  Stream<String> get currentWordStream => _currentWordController.stream;
  Stream<String> get subtitleStream => _subtitleController.stream;
  Stream<SpeechResult> get resultStream => _resultController.stream;
  Stream<double> get progressStream => _progressController.stream;

  SpeechTrainingState get currentState => _state;

  SpeechTrainingService() {
    _initServices();
  }

  Future<void> _initServices() async {
    await _initTts();
    await _initStt();
  }

  /// TTS für hörgeräteoptimierte Sprachausgabe
  Future<void> _initTts() async {
    // Langsamer und deutlicher für Hörgeräteträger
    await _tts.setLanguage(_currentLanguage);
    await _tts.setSpeechRate(_getSpeechRateForAge());
    await _tts.setPitch(1.0); // Natürliche Tonhöhe
    await _tts.setVolume(1.0); // Volle Lautstärke

    if (Platform.isAndroid) {
      await _tts.setEngine('com.google.android.tts');
    }

    if (Platform.isIOS) {
      await _tts.setSharedInstance(true);
      await _tts.setIosAudioCategory(
        IosTextToSpeechAudioCategory.playback,
        [
          IosTextToSpeechAudioCategoryOptions.allowBluetooth,
          IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        ],
        IosTextToSpeechAudioMode.voicePrompt,
      );
    }

    _tts.setStartHandler(() {
      _updateState(SpeechTrainingState.speaking);
    });

    _tts.setCompletionHandler(() {
      if (_state == SpeechTrainingState.speaking) {
        _updateState(SpeechTrainingState.idle);
      }
    });

    // Wort-für-Wort Callback für synchrone Untertitel
    _tts.setProgressHandler((text, start, end, word) {
      _currentWordController.add(word);
    });
  }

  /// STT für Spracherkennung der Kinderaussprache
  Future<void> _initStt() async {
    _sttAvailable = await _stt.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_state == SpeechTrainingState.listening) {
            _updateState(SpeechTrainingState.processing);
          }
        }
      },
      onError: (error) {
        _updateState(SpeechTrainingState.idle);
      },
    );
  }

  /// Sprechgeschwindigkeit basierend auf Alter
  /// Jüngere Kinder = langsamere Sprache
  double _getSpeechRateForAge() {
    if (_currentAge <= 4) return 0.3;  // Sehr langsam
    if (_currentAge <= 6) return 0.35; // Langsam
    if (_currentAge <= 8) return 0.4;  // Moderat langsam
    if (_currentAge <= 10) return 0.45; // Leicht langsam
    return 0.5; // Normal-langsam
  }

  void _updateState(SpeechTrainingState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  Future<void> setAge(int age) async {
    _currentAge = age;
    await _tts.setSpeechRate(_getSpeechRateForAge());
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = _getLocaleFromCode(languageCode);
    await _tts.setLanguage(_currentLanguage);
  }

  String _getLocaleFromCode(String code) {
    switch (code) {
      case 'bs': return 'bs-BA';
      case 'en': return 'en-US';
      case 'hr': return 'hr-HR';
      case 'sr': return 'sr-RS';
      case 'de': return 'de-DE';
      case 'tr': return 'tr-TR';
      default: return 'bs-BA';
    }
  }

  /// Spricht ein Wort/Satz langsam und deutlich vor
  /// Mit synchronen Untertiteln
  Future<void> speakWord(String text) async {
    if (_state == SpeechTrainingState.speaking) {
      await stop();
    }

    _subtitleController.add(text);
    _updateState(SpeechTrainingState.speaking);
    await _tts.speak(text);
  }

  /// Spricht vor und wartet dann auf Nachsprechen
  Future<void> speakAndListen(String targetWord) async {
    // 1. Lianko spricht vor
    await speakWord(targetWord);

    // Warte bis TTS fertig
    await Future.delayed(const Duration(milliseconds: 500));

    // 2. Warte auf Kind
    await _listenForResponse(targetWord);
  }

  /// Hört auf die Aussprache des Kindes
  Future<void> _listenForResponse(String targetWord) async {
    if (!_sttAvailable) {
      _resultController.add(SpeechResult(
        targetWord: targetWord,
        spokenWord: '',
        confidence: 0,
        isCorrect: false,
        feedback: 'Mikrofon nicht verfügbar',
      ));
      return;
    }

    _updateState(SpeechTrainingState.listening);

    String recognizedText = '';
    double confidence = 0;

    await _stt.listen(
      onResult: (result) {
        recognizedText = result.recognizedWords;
        confidence = result.confidence;

        // Live-Anzeige was erkannt wird
        _subtitleController.add(recognizedText);
      },
      listenFor: Duration(seconds: _currentAge <= 6 ? 8 : 5),
      pauseFor: Duration(seconds: _currentAge <= 6 ? 3 : 2),
      localeId: _currentLanguage,
      listenMode: ListenMode.dictation,
    );

    // Warte auf Ergebnis
    await Future.delayed(Duration(seconds: _currentAge <= 6 ? 9 : 6));

    // 3. Auswertung
    _updateState(SpeechTrainingState.processing);

    final result = _evaluateSpeech(targetWord, recognizedText, confidence);
    _resultController.add(result);

    // 4. Feedback
    _updateState(SpeechTrainingState.feedback);
    await _giveFeedback(result);

    _updateState(SpeechTrainingState.idle);
  }

  /// Wertet die Aussprache aus
  SpeechResult _evaluateSpeech(String target, String spoken, double confidence) {
    final targetLower = target.toLowerCase().trim();
    final spokenLower = spoken.toLowerCase().trim();

    // Exakte Übereinstimmung
    if (targetLower == spokenLower) {
      return SpeechResult(
        targetWord: target,
        spokenWord: spoken,
        confidence: confidence,
        isCorrect: true,
        feedback: _getPositiveFeedback(),
      );
    }

    // Ähnlichkeit prüfen (für kleine Aussprachefehler)
    final similarity = _calculateSimilarity(targetLower, spokenLower);

    if (similarity > 0.8) {
      return SpeechResult(
        targetWord: target,
        spokenWord: spoken,
        confidence: confidence,
        isCorrect: true,
        feedback: _getAlmostCorrectFeedback(),
      );
    }

    if (similarity > 0.5) {
      return SpeechResult(
        targetWord: target,
        spokenWord: spoken,
        confidence: confidence,
        isCorrect: false,
        feedback: _getTryAgainFeedback(),
      );
    }

    return SpeechResult(
      targetWord: target,
      spokenWord: spoken,
      confidence: confidence,
      isCorrect: false,
      feedback: _getEncouragementFeedback(),
    );
  }

  /// Berechnet Ähnlichkeit zwischen zwei Strings (Levenshtein-basiert)
  double _calculateSimilarity(String s1, String s2) {
    if (s1.isEmpty || s2.isEmpty) return 0;
    if (s1 == s2) return 1;

    final maxLen = s1.length > s2.length ? s1.length : s2.length;
    final distance = _levenshteinDistance(s1, s2);

    return 1 - (distance / maxLen);
  }

  int _levenshteinDistance(String s1, String s2) {
    final m = s1.length;
    final n = s2.length;
    final dp = List.generate(m + 1, (_) => List.filled(n + 1, 0));

    for (var i = 0; i <= m; i++) dp[i][0] = i;
    for (var j = 0; j <= n; j++) dp[0][j] = j;

    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = s1[i - 1] == s2[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return dp[m][n];
  }

  /// Gibt Feedback zur Aussprache
  Future<void> _giveFeedback(SpeechResult result) async {
    await speakWord(result.feedback);
  }

  // Feedback-Texte
  String _getPositiveFeedback() {
    final phrases = _feedbackPhrases[_currentLanguage.split('-').first] ??
                   _feedbackPhrases['bs']!;
    return phrases['correct']![DateTime.now().millisecond % phrases['correct']!.length];
  }

  String _getAlmostCorrectFeedback() {
    final phrases = _feedbackPhrases[_currentLanguage.split('-').first] ??
                   _feedbackPhrases['bs']!;
    return phrases['almost']![DateTime.now().millisecond % phrases['almost']!.length];
  }

  String _getTryAgainFeedback() {
    final phrases = _feedbackPhrases[_currentLanguage.split('-').first] ??
                   _feedbackPhrases['bs']!;
    return phrases['tryAgain']![DateTime.now().millisecond % phrases['tryAgain']!.length];
  }

  String _getEncouragementFeedback() {
    final phrases = _feedbackPhrases[_currentLanguage.split('-').first] ??
                   _feedbackPhrases['bs']!;
    return phrases['encourage']![DateTime.now().millisecond % phrases['encourage']!.length];
  }

  static const _feedbackPhrases = {
    'bs': {
      'correct': ['Odlično!', 'Bravo!', 'Super si!', 'Tačno tako!', 'Savršeno!'],
      'almost': ['Skoro savršeno!', 'Vrlo dobro!', 'Bravo, samo malo sporije!'],
      'tryAgain': ['Pokušaj ponovo!', 'Još jednom!', 'Hajde opet!'],
      'encourage': ['Možeš ti to!', 'Polako, nije problem!', 'Slušaj i ponovi!'],
    },
    'en': {
      'correct': ['Excellent!', 'Great job!', 'Perfect!', 'That\'s right!', 'Amazing!'],
      'almost': ['Almost perfect!', 'Very good!', 'Great, just a bit slower!'],
      'tryAgain': ['Try again!', 'One more time!', 'Let\'s try again!'],
      'encourage': ['You can do it!', 'Take your time!', 'Listen and repeat!'],
    },
    'de': {
      'correct': ['Ausgezeichnet!', 'Super!', 'Perfekt!', 'Genau richtig!', 'Toll!'],
      'almost': ['Fast perfekt!', 'Sehr gut!', 'Toll, nur etwas langsamer!'],
      'tryAgain': ['Versuch es nochmal!', 'Noch einmal!', 'Probieren wir es nochmal!'],
      'encourage': ['Du schaffst das!', 'Lass dir Zeit!', 'Hör zu und wiederhole!'],
    },
    'hr': {
      'correct': ['Odlično!', 'Bravo!', 'Super!', 'Tako je!', 'Savršeno!'],
      'almost': ['Skoro savršeno!', 'Vrlo dobro!', 'Bravo, samo malo sporije!'],
      'tryAgain': ['Pokušaj opet!', 'Još jednom!', 'Hajde ponovno!'],
      'encourage': ['Možeš ti to!', 'Polako!', 'Slušaj i ponovi!'],
    },
    'sr': {
      'correct': ['Одлично!', 'Браво!', 'Супер!', 'Тако је!', 'Савршено!'],
      'almost': ['Скоро савршено!', 'Врло добро!', 'Браво, само мало спорије!'],
      'tryAgain': ['Покушај поново!', 'Још једном!', 'Хајде опет!'],
      'encourage': ['Можеш ти то!', 'Полако!', 'Слушај и понови!'],
    },
    'tr': {
      'correct': ['Mükemmel!', 'Harika!', 'Süper!', 'Aynen öyle!', 'Muhteşem!'],
      'almost': ['Neredeyse mükemmel!', 'Çok iyi!', 'Harika, sadece biraz daha yavaş!'],
      'tryAgain': ['Tekrar dene!', 'Bir kez daha!', 'Hadi tekrar!'],
      'encourage': ['Yapabilirsin!', 'Acele etme!', 'Dinle ve tekrarla!'],
    },
  };

  /// Stoppt alle Audio-Aktivitäten
  Future<void> stop() async {
    await _tts.stop();
    await _stt.stop();
    _updateState(SpeechTrainingState.idle);
  }

  void dispose() {
    _stateController.close();
    _currentWordController.close();
    _subtitleController.close();
    _resultController.close();
    _progressController.close();
    _tts.stop();
    _stt.stop();
  }
}

// Riverpod Providers
final speechTrainingServiceProvider = Provider<SpeechTrainingService>((ref) {
  final service = SpeechTrainingService();
  ref.onDispose(() => service.dispose());
  return service;
});

final speechTrainingStateProvider = StreamProvider<SpeechTrainingState>((ref) {
  final service = ref.watch(speechTrainingServiceProvider);
  return service.stateStream;
});

final currentWordProvider = StreamProvider<String>((ref) {
  final service = ref.watch(speechTrainingServiceProvider);
  return service.currentWordStream;
});

final subtitleProvider = StreamProvider<String>((ref) {
  final service = ref.watch(speechTrainingServiceProvider);
  return service.subtitleStream;
});

final speechResultProvider = StreamProvider<SpeechResult>((ref) {
  final service = ref.watch(speechTrainingServiceProvider);
  return service.resultStream;
});
