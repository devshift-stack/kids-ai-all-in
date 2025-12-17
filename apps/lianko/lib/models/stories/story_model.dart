/// Eine Seite in der Geschichte
class StoryPage {
  final String text;           // Text der vorgelesen wird
  final String imageUrl;       // Bild zur Seite
  final String? highlightWord; // Wort zum Nachsprechen (optional)

  const StoryPage({
    required this.text,
    required this.imageUrl,
    this.highlightWord,
  });

  factory StoryPage.fromJson(Map<String, dynamic> json) {
    return StoryPage(
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      highlightWord: json['highlightWord'],
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'imageUrl': imageUrl,
    'highlightWord': highlightWord,
  };
}

/// Eine komplette Geschichte
class Story {
  final String id;
  final String title;
  final String coverImageUrl;
  final String language;
  final int minAge;
  final int maxAge;
  final List<StoryPage> pages;
  final String category; // tiere, familie, abenteuer, alltag

  const Story({
    required this.id,
    required this.title,
    required this.coverImageUrl,
    required this.language,
    required this.minAge,
    required this.maxAge,
    required this.pages,
    required this.category,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      language: json['language'] ?? 'bs',
      minAge: json['minAge'] ?? 3,
      maxAge: json['maxAge'] ?? 12,
      pages: (json['pages'] as List<dynamic>?)
          ?.map((p) => StoryPage.fromJson(p))
          .toList() ?? [],
      category: json['category'] ?? 'alltag',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'coverImageUrl': coverImageUrl,
    'language': language,
    'minAge': minAge,
    'maxAge': maxAge,
    'pages': pages.map((p) => p.toJson()).toList(),
    'category': category,
  };
}

/// Beispiel-Geschichten (hardcoded für Demo)
class SampleStories {
  static const hundeGeschichte = Story(
    id: 'hund_im_park',
    title: 'Der Hund im Park',
    coverImageUrl: 'assets/stories/hund_cover.png',
    language: 'de',
    minAge: 3,
    maxAge: 6,
    category: 'tiere',
    pages: [
      StoryPage(
        text: 'Das ist Max. Max ist ein Hund.',
        imageUrl: 'assets/stories/hund_1.png',
        highlightWord: 'Hund',
      ),
      StoryPage(
        text: 'Max geht in den Park.',
        imageUrl: 'assets/stories/hund_2.png',
        highlightWord: 'Park',
      ),
      StoryPage(
        text: 'Im Park sieht Max einen Ball.',
        imageUrl: 'assets/stories/hund_3.png',
        highlightWord: 'Ball',
      ),
      StoryPage(
        text: 'Max spielt mit dem Ball. Das macht Spaß!',
        imageUrl: 'assets/stories/hund_4.png',
        highlightWord: 'Spaß',
      ),
    ],
  );

  static const familienGeschichte = Story(
    id: 'meine_familie',
    title: 'Meine Familie',
    coverImageUrl: 'assets/stories/familie_cover.png',
    language: 'de',
    minAge: 3,
    maxAge: 6,
    category: 'familie',
    pages: [
      StoryPage(
        text: 'Das ist meine Mama.',
        imageUrl: 'assets/stories/familie_1.png',
        highlightWord: 'Mama',
      ),
      StoryPage(
        text: 'Das ist mein Papa.',
        imageUrl: 'assets/stories/familie_2.png',
        highlightWord: 'Papa',
      ),
      StoryPage(
        text: 'Ich habe eine Schwester.',
        imageUrl: 'assets/stories/familie_3.png',
        highlightWord: 'Schwester',
      ),
      StoryPage(
        text: 'Wir sind eine Familie. Ich liebe meine Familie!',
        imageUrl: 'assets/stories/familie_4.png',
        highlightWord: 'Familie',
      ),
    ],
  );

  static List<Story> getAll() => [
    hundeGeschichte,
    familienGeschichte,
  ];

  static List<Story> getByLanguage(String lang) {
    return getAll().where((s) => s.language == lang).toList();
  }

  static List<Story> getByAge(int age) {
    return getAll().where((s) => age >= s.minAge && age <= s.maxAge).toList();
  }
}
