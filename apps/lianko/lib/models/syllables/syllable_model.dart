/// Silben-Training Model
/// Wörter aufgeteilt in Silben zum Üben

/// Ein Wort mit Silben-Aufteilung
class SyllableWord {
  final String word;              // Vollständiges Wort
  final List<String> syllables;   // Aufgeteilte Silben
  final String imageAsset;        // Bild zum Wort
  final String category;

  const SyllableWord({
    required this.word,
    required this.syllables,
    required this.imageAsset,
    required this.category,
  });

  /// Wort mit Bindestrichen zwischen Silben
  String get hyphenated => syllables.join('-');

  /// Anzahl der Silben
  int get syllableCount => syllables.length;
}

/// Silben-Kategorie (nach Schwierigkeit)
class SyllableCategory {
  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final int difficulty;  // 1 = leicht (2 Silben), 2 = mittel (3), 3 = schwer (4+)
  final List<SyllableWord> words;

  const SyllableCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.difficulty,
    required this.words,
  });
}

/// Vordefinierte Silben-Wörter
class SyllableData {
  // Leicht: 2 Silben
  static const leicht = SyllableCategory(
    id: 'leicht',
    name: 'Leicht',
    icon: '⭐',
    colorValue: 0xFF4CAF50,
    difficulty: 1,
    words: [
      SyllableWord(word: 'Apfel', syllables: ['Ap', 'fel'], imageAsset: 'assets/syllables/apfel.png', category: 'leicht'),
      SyllableWord(word: 'Hase', syllables: ['Ha', 'se'], imageAsset: 'assets/syllables/hase.png', category: 'leicht'),
      SyllableWord(word: 'Sonne', syllables: ['Son', 'ne'], imageAsset: 'assets/syllables/sonne.png', category: 'leicht'),
      SyllableWord(word: 'Blume', syllables: ['Blu', 'me'], imageAsset: 'assets/syllables/blume.png', category: 'leicht'),
      SyllableWord(word: 'Hunde', syllables: ['Hun', 'de'], imageAsset: 'assets/syllables/hunde.png', category: 'leicht'),
      SyllableWord(word: 'Katze', syllables: ['Kat', 'ze'], imageAsset: 'assets/syllables/katze.png', category: 'leicht'),
      SyllableWord(word: 'Mama', syllables: ['Ma', 'ma'], imageAsset: 'assets/syllables/mama.png', category: 'leicht'),
      SyllableWord(word: 'Papa', syllables: ['Pa', 'pa'], imageAsset: 'assets/syllables/papa.png', category: 'leicht'),
      SyllableWord(word: 'Oma', syllables: ['O', 'ma'], imageAsset: 'assets/syllables/oma.png', category: 'leicht'),
      SyllableWord(word: 'Opa', syllables: ['O', 'pa'], imageAsset: 'assets/syllables/opa.png', category: 'leicht'),
      SyllableWord(word: 'Auto', syllables: ['Au', 'to'], imageAsset: 'assets/syllables/auto.png', category: 'leicht'),
      SyllableWord(word: 'Bett', syllables: ['Bett'], imageAsset: 'assets/syllables/bett.png', category: 'leicht'),
      SyllableWord(word: 'Ball', syllables: ['Ball'], imageAsset: 'assets/syllables/ball.png', category: 'leicht'),
    ],
  );

  // Mittel: 3 Silben
  static const mittel = SyllableCategory(
    id: 'mittel',
    name: 'Mittel',
    icon: '⭐⭐',
    colorValue: 0xFFFF9800,
    difficulty: 2,
    words: [
      SyllableWord(word: 'Banane', syllables: ['Ba', 'na', 'ne'], imageAsset: 'assets/syllables/banane.png', category: 'mittel'),
      SyllableWord(word: 'Tomate', syllables: ['To', 'ma', 'te'], imageAsset: 'assets/syllables/tomate.png', category: 'mittel'),
      SyllableWord(word: 'Elefant', syllables: ['E', 'le', 'fant'], imageAsset: 'assets/syllables/elefant.png', category: 'mittel'),
      SyllableWord(word: 'Computer', syllables: ['Com', 'pu', 'ter'], imageAsset: 'assets/syllables/computer.png', category: 'mittel'),
      SyllableWord(word: 'Telefon', syllables: ['Te', 'le', 'fon'], imageAsset: 'assets/syllables/telefon.png', category: 'mittel'),
      SyllableWord(word: 'Rakete', syllables: ['Ra', 'ke', 'te'], imageAsset: 'assets/syllables/rakete.png', category: 'mittel'),
      SyllableWord(word: 'Erdbeere', syllables: ['Erd', 'bee', 're'], imageAsset: 'assets/syllables/erdbeere.png', category: 'mittel'),
      SyllableWord(word: 'Familie', syllables: ['Fa', 'mi', 'lie'], imageAsset: 'assets/syllables/familie.png', category: 'mittel'),
      SyllableWord(word: 'Schokolade', syllables: ['Scho', 'ko', 'la', 'de'], imageAsset: 'assets/syllables/schokolade.png', category: 'mittel'),
    ],
  );

  // Schwer: 4+ Silben
  static const schwer = SyllableCategory(
    id: 'schwer',
    name: 'Schwer',
    icon: '⭐⭐⭐',
    colorValue: 0xFFE53935,
    difficulty: 3,
    words: [
      SyllableWord(word: 'Schmetterling', syllables: ['Schmet', 'ter', 'ling'], imageAsset: 'assets/syllables/schmetterling.png', category: 'schwer'),
      SyllableWord(word: 'Kindergarten', syllables: ['Kin', 'der', 'gar', 'ten'], imageAsset: 'assets/syllables/kindergarten.png', category: 'schwer'),
      SyllableWord(word: 'Schokolade', syllables: ['Scho', 'ko', 'la', 'de'], imageAsset: 'assets/syllables/schokolade.png', category: 'schwer'),
      SyllableWord(word: 'Wassermelone', syllables: ['Was', 'ser', 'me', 'lo', 'ne'], imageAsset: 'assets/syllables/wassermelone.png', category: 'schwer'),
      SyllableWord(word: 'Regenbogen', syllables: ['Re', 'gen', 'bo', 'gen'], imageAsset: 'assets/syllables/regenbogen.png', category: 'schwer'),
      SyllableWord(word: 'Geburtstag', syllables: ['Ge', 'burts', 'tag'], imageAsset: 'assets/syllables/geburtstag.png', category: 'schwer'),
      SyllableWord(word: 'Feuerwehr', syllables: ['Feu', 'er', 'wehr'], imageAsset: 'assets/syllables/feuerwehr.png', category: 'schwer'),
      SyllableWord(word: 'Hubschrauber', syllables: ['Hub', 'schrau', 'ber'], imageAsset: 'assets/syllables/hubschrauber.png', category: 'schwer'),
    ],
  );

  // Tiere
  static const tiere = SyllableCategory(
    id: 'tiere',
    name: 'Tiere',
    icon: '🐾',
    colorValue: 0xFF9C27B0,
    difficulty: 2,
    words: [
      SyllableWord(word: 'Elefant', syllables: ['E', 'le', 'fant'], imageAsset: 'assets/syllables/elefant.png', category: 'tiere'),
      SyllableWord(word: 'Giraffe', syllables: ['Gi', 'raf', 'fe'], imageAsset: 'assets/syllables/giraffe.png', category: 'tiere'),
      SyllableWord(word: 'Krokodil', syllables: ['Kro', 'ko', 'dil'], imageAsset: 'assets/syllables/krokodil.png', category: 'tiere'),
      SyllableWord(word: 'Schmetterling', syllables: ['Schmet', 'ter', 'ling'], imageAsset: 'assets/syllables/schmetterling.png', category: 'tiere'),
      SyllableWord(word: 'Marienkäfer', syllables: ['Ma', 'ri', 'en', 'kä', 'fer'], imageAsset: 'assets/syllables/marienkaefer.png', category: 'tiere'),
      SyllableWord(word: 'Pinguin', syllables: ['Pin', 'gu', 'in'], imageAsset: 'assets/syllables/pinguin.png', category: 'tiere'),
      SyllableWord(word: 'Papagei', syllables: ['Pa', 'pa', 'gei'], imageAsset: 'assets/syllables/papagei.png', category: 'tiere'),
    ],
  );

  static List<SyllableCategory> getAll() => [
    leicht,
    mittel,
    schwer,
    tiere,
  ];

  static SyllableCategory? getById(String id) {
    try {
      return getAll().firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
