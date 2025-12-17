import 'package:flutter/material.dart' show Color;

/// Ein einzelnes Wort im Wortschatz
class VocabularyWord {
  final String word;
  final String imageUrl;
  final String? audioUrl;    // Optional: Eltern-Aufnahme
  final String category;

  const VocabularyWord({
    required this.word,
    required this.imageUrl,
    this.audioUrl,
    required this.category,
  });
}

/// Wortschatz-Kategorie
class VocabularyCategory {
  final String id;
  final String name;
  final String icon;
  final int colorValue; // Farbe als int für const
  final List<VocabularyWord> words;

  const VocabularyCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.words,
  });

  /// Holt die Flutter Color
  Color get color => Color(colorValue);
}

/// Vordefinierte Wortschatz-Kategorien
class VocabularyData {
  static const tiere = VocabularyCategory(
    id: 'tiere',
    name: 'Tiere',
    icon: '🐾',
    colorValue: 0xFF4CAF50,
    words: [
      VocabularyWord(word: 'Hund', imageUrl: 'assets/vocabulary/tiere/hund.png', category: 'tiere'),
      VocabularyWord(word: 'Katze', imageUrl: 'assets/vocabulary/tiere/katze.png', category: 'tiere'),
      VocabularyWord(word: 'Maus', imageUrl: 'assets/vocabulary/tiere/maus.png', category: 'tiere'),
      VocabularyWord(word: 'Vogel', imageUrl: 'assets/vocabulary/tiere/vogel.png', category: 'tiere'),
      VocabularyWord(word: 'Fisch', imageUrl: 'assets/vocabulary/tiere/fisch.png', category: 'tiere'),
      VocabularyWord(word: 'Pferd', imageUrl: 'assets/vocabulary/tiere/pferd.png', category: 'tiere'),
      VocabularyWord(word: 'Kuh', imageUrl: 'assets/vocabulary/tiere/kuh.png', category: 'tiere'),
      VocabularyWord(word: 'Schwein', imageUrl: 'assets/vocabulary/tiere/schwein.png', category: 'tiere'),
      VocabularyWord(word: 'Schaf', imageUrl: 'assets/vocabulary/tiere/schaf.png', category: 'tiere'),
      VocabularyWord(word: 'Huhn', imageUrl: 'assets/vocabulary/tiere/huhn.png', category: 'tiere'),
    ],
  );

  static const familie = VocabularyCategory(
    id: 'familie',
    name: 'Familie',
    icon: '👨‍👩‍👧‍👦',
    colorValue: 0xFFE91E63,
    words: [
      VocabularyWord(word: 'Mama', imageUrl: 'assets/vocabulary/familie/mama.png', category: 'familie'),
      VocabularyWord(word: 'Papa', imageUrl: 'assets/vocabulary/familie/papa.png', category: 'familie'),
      VocabularyWord(word: 'Oma', imageUrl: 'assets/vocabulary/familie/oma.png', category: 'familie'),
      VocabularyWord(word: 'Opa', imageUrl: 'assets/vocabulary/familie/opa.png', category: 'familie'),
      VocabularyWord(word: 'Bruder', imageUrl: 'assets/vocabulary/familie/bruder.png', category: 'familie'),
      VocabularyWord(word: 'Schwester', imageUrl: 'assets/vocabulary/familie/schwester.png', category: 'familie'),
      VocabularyWord(word: 'Baby', imageUrl: 'assets/vocabulary/familie/baby.png', category: 'familie'),
      VocabularyWord(word: 'Tante', imageUrl: 'assets/vocabulary/familie/tante.png', category: 'familie'),
      VocabularyWord(word: 'Onkel', imageUrl: 'assets/vocabulary/familie/onkel.png', category: 'familie'),
    ],
  );

  static const essen = VocabularyCategory(
    id: 'essen',
    name: 'Essen',
    icon: '🍎',
    colorValue: 0xFFFF9800,
    words: [
      VocabularyWord(word: 'Apfel', imageUrl: 'assets/vocabulary/essen/apfel.png', category: 'essen'),
      VocabularyWord(word: 'Banane', imageUrl: 'assets/vocabulary/essen/banane.png', category: 'essen'),
      VocabularyWord(word: 'Brot', imageUrl: 'assets/vocabulary/essen/brot.png', category: 'essen'),
      VocabularyWord(word: 'Milch', imageUrl: 'assets/vocabulary/essen/milch.png', category: 'essen'),
      VocabularyWord(word: 'Wasser', imageUrl: 'assets/vocabulary/essen/wasser.png', category: 'essen'),
      VocabularyWord(word: 'Käse', imageUrl: 'assets/vocabulary/essen/kaese.png', category: 'essen'),
      VocabularyWord(word: 'Ei', imageUrl: 'assets/vocabulary/essen/ei.png', category: 'essen'),
      VocabularyWord(word: 'Kuchen', imageUrl: 'assets/vocabulary/essen/kuchen.png', category: 'essen'),
    ],
  );

  static const koerper = VocabularyCategory(
    id: 'koerper',
    name: 'Körper',
    icon: '🖐️',
    colorValue: 0xFF2196F3,
    words: [
      VocabularyWord(word: 'Hand', imageUrl: 'assets/vocabulary/koerper/hand.png', category: 'koerper'),
      VocabularyWord(word: 'Fuß', imageUrl: 'assets/vocabulary/koerper/fuss.png', category: 'koerper'),
      VocabularyWord(word: 'Kopf', imageUrl: 'assets/vocabulary/koerper/kopf.png', category: 'koerper'),
      VocabularyWord(word: 'Auge', imageUrl: 'assets/vocabulary/koerper/auge.png', category: 'koerper'),
      VocabularyWord(word: 'Ohr', imageUrl: 'assets/vocabulary/koerper/ohr.png', category: 'koerper'),
      VocabularyWord(word: 'Nase', imageUrl: 'assets/vocabulary/koerper/nase.png', category: 'koerper'),
      VocabularyWord(word: 'Mund', imageUrl: 'assets/vocabulary/koerper/mund.png', category: 'koerper'),
      VocabularyWord(word: 'Bauch', imageUrl: 'assets/vocabulary/koerper/bauch.png', category: 'koerper'),
    ],
  );

  static const farben = VocabularyCategory(
    id: 'farben',
    name: 'Farben',
    icon: '🌈',
    colorValue: 0xFF9C27B0,
    words: [
      VocabularyWord(word: 'Rot', imageUrl: 'assets/vocabulary/farben/rot.png', category: 'farben'),
      VocabularyWord(word: 'Blau', imageUrl: 'assets/vocabulary/farben/blau.png', category: 'farben'),
      VocabularyWord(word: 'Grün', imageUrl: 'assets/vocabulary/farben/gruen.png', category: 'farben'),
      VocabularyWord(word: 'Gelb', imageUrl: 'assets/vocabulary/farben/gelb.png', category: 'farben'),
      VocabularyWord(word: 'Orange', imageUrl: 'assets/vocabulary/farben/orange.png', category: 'farben'),
      VocabularyWord(word: 'Lila', imageUrl: 'assets/vocabulary/farben/lila.png', category: 'farben'),
      VocabularyWord(word: 'Rosa', imageUrl: 'assets/vocabulary/farben/rosa.png', category: 'farben'),
      VocabularyWord(word: 'Weiß', imageUrl: 'assets/vocabulary/farben/weiss.png', category: 'farben'),
      VocabularyWord(word: 'Schwarz', imageUrl: 'assets/vocabulary/farben/schwarz.png', category: 'farben'),
    ],
  );

  static const zahlen = VocabularyCategory(
    id: 'zahlen',
    name: 'Zahlen',
    icon: '🔢',
    colorValue: 0xFF00BCD4,
    words: [
      VocabularyWord(word: 'Eins', imageUrl: 'assets/vocabulary/zahlen/1.png', category: 'zahlen'),
      VocabularyWord(word: 'Zwei', imageUrl: 'assets/vocabulary/zahlen/2.png', category: 'zahlen'),
      VocabularyWord(word: 'Drei', imageUrl: 'assets/vocabulary/zahlen/3.png', category: 'zahlen'),
      VocabularyWord(word: 'Vier', imageUrl: 'assets/vocabulary/zahlen/4.png', category: 'zahlen'),
      VocabularyWord(word: 'Fünf', imageUrl: 'assets/vocabulary/zahlen/5.png', category: 'zahlen'),
      VocabularyWord(word: 'Sechs', imageUrl: 'assets/vocabulary/zahlen/6.png', category: 'zahlen'),
      VocabularyWord(word: 'Sieben', imageUrl: 'assets/vocabulary/zahlen/7.png', category: 'zahlen'),
      VocabularyWord(word: 'Acht', imageUrl: 'assets/vocabulary/zahlen/8.png', category: 'zahlen'),
      VocabularyWord(word: 'Neun', imageUrl: 'assets/vocabulary/zahlen/9.png', category: 'zahlen'),
      VocabularyWord(word: 'Zehn', imageUrl: 'assets/vocabulary/zahlen/10.png', category: 'zahlen'),
    ],
  );

  static List<VocabularyCategory> getAll() => [
    tiere,
    familie,
    essen,
    koerper,
    farben,
    zahlen,
  ];

  static VocabularyCategory? getById(String id) {
    return getAll().where((c) => c.id == id).firstOrNull;
  }
}

extension ListExtension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
