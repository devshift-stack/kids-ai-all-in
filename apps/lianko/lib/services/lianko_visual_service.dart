import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stimmungen für visuelle Darstellung
enum LiankoMood { happy, curious, excited, calm, encouraging }

/// Zustände der visuellen Kommunikation
enum LiankoVisualState { idle, showing, animating, waiting }

/// Feedback-Typen mit zugehörigen visuellen Eigenschaften
enum FeedbackType {
  correct,   // Grün, Konfetti, starke Vibration
  wrong,     // Orange (nicht rot!), sanfte Vibration, ermutigend
  encourage, // Blau, Herz-Animation
  hello,     // Regenbogen, Winken
  bye,       // Lila, Winken
  thinking,  // Gelb, Punkte-Animation
}

/// Visuelles Feedback-Daten
class VisualFeedback {
  final String text;
  final LiankoMood mood;
  final FeedbackType type;
  final Color primaryColor;
  final Color secondaryColor;
  final IconData icon;
  final bool shouldVibrate;
  final Duration displayDuration;

  const VisualFeedback({
    required this.text,
    required this.mood,
    required this.type,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    this.shouldVibrate = true,
    this.displayDuration = const Duration(seconds: 3),
  });
}

/// Hauptservice für visuelle Kommunikation (ersetzt Audio für schwerhörige Kinder)
class LiankoVisualService {
  int _currentAge = 6;
  String _currentLanguage = 'bs';
  LiankoVisualState _state = LiankoVisualState.idle;

  final _stateController = StreamController<LiankoVisualState>.broadcast();
  final _feedbackController = StreamController<VisualFeedback>.broadcast();
  final _subtitleController = StreamController<String>.broadcast();

  Stream<LiankoVisualState> get stateStream => _stateController.stream;
  Stream<VisualFeedback> get feedbackStream => _feedbackController.stream;
  Stream<String> get subtitleStream => _subtitleController.stream;
  LiankoVisualState get currentState => _state;

  /// Farben für jede Stimmung
  static const _moodColors = {
    LiankoMood.happy: (primary: Color(0xFF4CAF50), secondary: Color(0xFF81C784)),
    LiankoMood.curious: (primary: Color(0xFFFFEB3B), secondary: Color(0xFFFFF176)),
    LiankoMood.excited: (primary: Color(0xFFFF9800), secondary: Color(0xFFFFB74D)),
    LiankoMood.calm: (primary: Color(0xFF2196F3), secondary: Color(0xFF64B5F6)),
    LiankoMood.encouraging: (primary: Color(0xFF9C27B0), secondary: Color(0xFFBA68C8)),
  };

  /// Icons für Feedback-Typen
  static const _feedbackIcons = {
    FeedbackType.correct: Icons.check_circle,
    FeedbackType.wrong: Icons.refresh,
    FeedbackType.encourage: Icons.favorite,
    FeedbackType.hello: Icons.waving_hand,
    FeedbackType.bye: Icons.nights_stay,
    FeedbackType.thinking: Icons.lightbulb,
  };

  /// Vibrationsmuster für verschiedene Feedback-Typen
  Future<void> _vibrate(FeedbackType type) async {
    switch (type) {
      case FeedbackType.correct:
        // Fröhliches Muster: kurz-kurz-lang
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 100));
        await HapticFeedback.heavyImpact();
        break;
      case FeedbackType.wrong:
        // Sanftes Muster: nur leicht
        await HapticFeedback.lightImpact();
        break;
      case FeedbackType.encourage:
        // Herzschlag: lang-kurz, lang-kurz
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 150));
        await HapticFeedback.lightImpact();
        await Future.delayed(const Duration(milliseconds: 300));
        await HapticFeedback.heavyImpact();
        await Future.delayed(const Duration(milliseconds: 150));
        await HapticFeedback.lightImpact();
        break;
      case FeedbackType.hello:
      case FeedbackType.bye:
        // Freundlich: medium-medium
        await HapticFeedback.mediumImpact();
        await Future.delayed(const Duration(milliseconds: 200));
        await HapticFeedback.mediumImpact();
        break;
      case FeedbackType.thinking:
        // Nachdenklich: leicht pulsierend
        await HapticFeedback.selectionClick();
        break;
    }
  }

  void _updateState(LiankoVisualState newState) {
    _state = newState;
    _stateController.add(newState);
  }

  Future<void> setAge(int age) async {
    _currentAge = age;
  }

  Future<void> setLanguage(String languageCode) async {
    _currentLanguage = languageCode;
  }

  /// Zeigt Text als Untertitel an (ersetzt speak())
  Future<void> showText(String text, {LiankoMood mood = LiankoMood.happy}) async {
    _updateState(LiankoVisualState.showing);

    final colors = _moodColors[mood]!;

    final feedback = VisualFeedback(
      text: text,
      mood: mood,
      type: FeedbackType.hello, // Default
      primaryColor: colors.primary,
      secondaryColor: colors.secondary,
      icon: Icons.chat_bubble,
      shouldVibrate: false,
      displayDuration: _calculateDisplayDuration(text),
    );

    _feedbackController.add(feedback);
    _subtitleController.add(text);

    // Warte bis Text "gelesen" wurde
    await Future.delayed(feedback.displayDuration);
    _updateState(LiankoVisualState.idle);
  }

  /// Berechnet Anzeigedauer basierend auf Textlänge und Alter
  Duration _calculateDisplayDuration(String text) {
    // Jüngere Kinder brauchen mehr Zeit
    final wordsPerSecond = _currentAge <= 5 ? 1.0 : (_currentAge <= 8 ? 1.5 : 2.0);
    final wordCount = text.split(' ').length;
    final seconds = (wordCount / wordsPerSecond).ceil();

    // Minimum 2 Sekunden, Maximum 8 Sekunden
    return Duration(seconds: seconds.clamp(2, 8));
  }

  /// Reagiert mit visuellem Feedback (ersetzt react())
  Future<void> react(String type) async {
    final feedbackType = _getFeedbackType(type);
    final phrase = getPhrase(type);
    final mood = _getMoodForType(type);
    final colors = _moodColors[mood]!;

    _updateState(LiankoVisualState.animating);

    final feedback = VisualFeedback(
      text: phrase,
      mood: mood,
      type: feedbackType,
      primaryColor: colors.primary,
      secondaryColor: colors.secondary,
      icon: _feedbackIcons[feedbackType]!,
      shouldVibrate: true,
      displayDuration: _calculateDisplayDuration(phrase),
    );

    _feedbackController.add(feedback);
    _subtitleController.add(phrase);

    // Vibration auslösen
    await _vibrate(feedbackType);

    // Warte bis Animation fertig
    await Future.delayed(feedback.displayDuration);
    _updateState(LiankoVisualState.idle);
  }

  FeedbackType _getFeedbackType(String type) {
    switch (type) {
      case 'correct': return FeedbackType.correct;
      case 'wrong': return FeedbackType.wrong;
      case 'encourage': return FeedbackType.encourage;
      case 'hello': return FeedbackType.hello;
      case 'bye': return FeedbackType.bye;
      case 'thinking': return FeedbackType.thinking;
      default: return FeedbackType.hello;
    }
  }

  LiankoMood _getMoodForType(String type) {
    switch (type) {
      case 'correct': return LiankoMood.excited;
      case 'wrong': return LiankoMood.encouraging;
      case 'encourage': return LiankoMood.encouraging;
      case 'hello': return LiankoMood.happy;
      case 'bye': return LiankoMood.calm;
      case 'thinking': return LiankoMood.curious;
      default: return LiankoMood.happy;
    }
  }

  /// Begrüßung basierend auf Tageszeit
  String getGreeting(String childName) {
    final hour = DateTime.now().hour;
    String timeGreeting;
    String emoji;

    if (hour < 12) {
      timeGreeting = _getAgeAppropriateText('goodMorning');
      emoji = '☀️';
    } else if (hour < 18) {
      timeGreeting = _getAgeAppropriateText('goodAfternoon');
      emoji = '🌤️';
    } else {
      timeGreeting = _getAgeAppropriateText('goodEvening');
      emoji = '🌙';
    }

    return '$emoji $timeGreeting, $childName! ${_getAgeAppropriateText('welcomeBack')}';
  }

  String _getAgeAppropriateText(String key) {
    final texts = {
      'goodMorning': {
        'preschool': 'Dobro jutro',
        'earlySchool': 'Dobro jutro',
        'lateSchool': 'Dobro jutro',
      },
      'goodAfternoon': {
        'preschool': 'Ćao',
        'earlySchool': 'Dobar dan',
        'lateSchool': 'Dobar dan',
      },
      'goodEvening': {
        'preschool': 'Laku noć uskoro',
        'earlySchool': 'Dobra večer',
        'lateSchool': 'Dobra večer',
      },
      'welcomeBack': {
        'preschool': 'Hajde da se igramo! 🎮',
        'earlySchool': 'Spremni za učenje? 📚',
        'lateSchool': 'Šta želiš danas naučiti? 🎯',
      },
    };

    String ageGroup;
    if (_currentAge <= 5) {
      ageGroup = 'preschool';
    } else if (_currentAge <= 8) {
      ageGroup = 'earlySchool';
    } else {
      ageGroup = 'lateSchool';
    }

    return texts[key]?[ageGroup] ?? texts[key]?['earlySchool'] ?? '';
  }

  /// Phrasen mit Emojis für visuelle Unterstützung
  static const _liankoPhrases = {
    'bs': {
      'correct': ['Bravo! ⭐', 'Super! 🌟', 'Odlično! 🎉', 'Tako je! ✨', 'Fantastično! 🏆'],
      'wrong': ['Pokušaj opet! 💪', 'Skoro! 🎯', 'Ne brini, probaj ponovo! 🌈'],
      'encourage': ['Ti to možeš! 💪', 'Samo nastavi! 🚀', 'Vjerujem u tebe! ❤️'],
      'hello': ['Zdravo prijatelju! 👋', 'Ćao! 🤗', 'Drago mi je što si tu! 🌟'],
      'bye': ['Doviđenja! 👋', 'Vidimo se! 🌙', 'Bilo je super! ⭐'],
      'thinking': ['Hmm... 🤔', 'Razmišljam... 💭', 'Zanimljivo... 💡'],
    },
    'en': {
      'correct': ['Great job! ⭐', 'Awesome! 🌟', 'You got it! 🎉', 'Perfect! ✨', 'Amazing! 🏆'],
      'wrong': ['Try again! 💪', 'Almost! 🎯', 'Don\'t worry, try once more! 🌈'],
      'encourage': ['You can do it! 💪', 'Keep going! 🚀', 'I believe in you! ❤️'],
      'hello': ['Hello friend! 👋', 'Hi there! 🤗', 'Glad you\'re here! 🌟'],
      'bye': ['Goodbye! 👋', 'See you soon! 🌙', 'That was fun! ⭐'],
      'thinking': ['Hmm... 🤔', 'Let me think... 💭', 'Interesting... 💡'],
    },
    'de': {
      'correct': ['Super! ⭐', 'Toll! 🌟', 'Ausgezeichnet! 🎉', 'Richtig! ✨', 'Fantastisch! 🏆'],
      'wrong': ['Versuch es nochmal! 💪', 'Fast! 🎯', 'Keine Sorge, probier es nochmal! 🌈'],
      'encourage': ['Du schaffst das! 💪', 'Weiter so! 🚀', 'Ich glaube an dich! ❤️'],
      'hello': ['Hallo Freund! 👋', 'Hi! 🤗', 'Schön dass du da bist! 🌟'],
      'bye': ['Tschüss! 👋', 'Bis bald! 🌙', 'Das hat Spaß gemacht! ⭐'],
      'thinking': ['Hmm... 🤔', 'Lass mich nachdenken... 💭', 'Interessant... 💡'],
    },
    'hr': {
      'correct': ['Bravo! ⭐', 'Super! 🌟', 'Odlično! 🎉', 'Tako je! ✨', 'Fantastično! 🏆'],
      'wrong': ['Pokušaj opet! 💪', 'Skoro! 🎯', 'Ne brini, probaj ponovno! 🌈'],
      'encourage': ['Možeš ti to! 💪', 'Samo nastavi! 🚀', 'Vjerujem u tebe! ❤️'],
      'hello': ['Bok prijatelju! 👋', 'Ćao! 🤗', 'Drago mi je što si tu! 🌟'],
      'bye': ['Doviđenja! 👋', 'Vidimo se! 🌙', 'Bilo je super! ⭐'],
      'thinking': ['Hmm... 🤔', 'Razmišljam... 💭', 'Zanimljivo... 💡'],
    },
    'sr': {
      'correct': ['Браво! ⭐', 'Супер! 🌟', 'Одлично! 🎉', 'Тако је! ✨', 'Фантастично! 🏆'],
      'wrong': ['Пробај поново! 💪', 'Скоро! 🎯', 'Не брини, покушај опет! 🌈'],
      'encourage': ['Можеш ти то! 💪', 'Само настави! 🚀', 'Верујем у тебе! ❤️'],
      'hello': ['Здраво пријатељу! 👋', 'Ћао! 🤗', 'Драго ми је што си ту! 🌟'],
      'bye': ['Довиђења! 👋', 'Видимо се! 🌙', 'Било је супер! ⭐'],
      'thinking': ['Хмм... 🤔', 'Размишљам... 💭', 'Занимљиво... 💡'],
    },
    'tr': {
      'correct': ['Aferin! ⭐', 'Süper! 🌟', 'Mükemmel! 🎉', 'Doğru! ✨', 'Harika! 🏆'],
      'wrong': ['Tekrar dene! 💪', 'Neredeyse! 🎯', 'Endişelenme, bir daha dene! 🌈'],
      'encourage': ['Yapabilirsin! 💪', 'Devam et! 🚀', 'Sana inanıyorum! ❤️'],
      'hello': ['Merhaba arkadaşım! 👋', 'Selam! 🤗', 'Burada olduğuna sevindim! 🌟'],
      'bye': ['Hoşça kal! 👋', 'Görüşürüz! 🌙', 'Çok eğlenceliydi! ⭐'],
      'thinking': ['Hmm... 🤔', 'Düşüneyim... 💭', 'İlginç... 💡'],
    },
  };

  String getPhrase(String type) {
    final phrases = _liankoPhrases[_currentLanguage]?[type] ??
                   _liankoPhrases['bs']?[type] ??
                   [''];
    if (phrases.isEmpty) return '';
    return phrases[(DateTime.now().millisecond % phrases.length)];
  }

  void dispose() {
    _stateController.close();
    _feedbackController.close();
    _subtitleController.close();
  }
}

// Riverpod providers
final liankoVisualServiceProvider = Provider<LiankoVisualService>((ref) {
  final service = LiankoVisualService();
  ref.onDispose(() => service.dispose());
  return service;
});

final liankoVisualStateProvider = StreamProvider<LiankoVisualState>((ref) {
  final service = ref.watch(liankoVisualServiceProvider);
  return service.stateStream;
});

final liankoFeedbackProvider = StreamProvider<VisualFeedback>((ref) {
  final service = ref.watch(liankoVisualServiceProvider);
  return service.feedbackStream;
});

final liankoSubtitleProvider = StreamProvider<String>((ref) {
  final service = ref.watch(liankoVisualServiceProvider);
  return service.subtitleStream;
});
