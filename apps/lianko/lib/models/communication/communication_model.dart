/// Zeig-Sprech-Modul - Kommunikation durch Bilder
/// Kind kann sich selbst aufnehmen, App spielt dann eigene Stimme ab

/// Ein einzelnes Kommunikations-Symbol
class CommunicationSymbol {
  final String id;
  final String word;
  final String imageAsset;
  final String? childRecordingUrl; // Aufnahme des Kindes
  final List<CommunicationSymbol>? subOptions; // Unter-Optionen

  const CommunicationSymbol({
    required this.id,
    required this.word,
    required this.imageAsset,
    this.childRecordingUrl,
    this.subOptions,
  });

  CommunicationSymbol copyWith({
    String? id,
    String? word,
    String? imageAsset,
    String? childRecordingUrl,
    List<CommunicationSymbol>? subOptions,
  }) {
    return CommunicationSymbol(
      id: id ?? this.id,
      word: word ?? this.word,
      imageAsset: imageAsset ?? this.imageAsset,
      childRecordingUrl: childRecordingUrl ?? this.childRecordingUrl,
      subOptions: subOptions ?? this.subOptions,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'word': word,
    'imageAsset': imageAsset,
    'childRecordingUrl': childRecordingUrl,
    'subOptions': subOptions?.map((s) => s.toJson()).toList(),
  };

  factory CommunicationSymbol.fromJson(Map<String, dynamic> json) {
    return CommunicationSymbol(
      id: json['id'],
      word: json['word'],
      imageAsset: json['imageAsset'],
      childRecordingUrl: json['childRecordingUrl'],
      subOptions: json['subOptions'] != null
          ? (json['subOptions'] as List)
              .map((s) => CommunicationSymbol.fromJson(s))
              .toList()
          : null,
    );
  }
}

/// Kategorie mit mehreren Symbolen
class CommunicationCategory {
  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final List<CommunicationSymbol> symbols;
  final bool isEnabled; // Eltern können Kategorien ein/ausschalten
  final bool sendPushOnUse; // Bei Nutzung Push an Eltern (z.B. Schmerzen)

  const CommunicationCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.symbols,
    this.isEnabled = true,
    this.sendPushOnUse = false,
  });

  CommunicationCategory copyWith({
    String? id,
    String? name,
    String? icon,
    int? colorValue,
    List<CommunicationSymbol>? symbols,
    bool? isEnabled,
    bool? sendPushOnUse,
  }) {
    return CommunicationCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      colorValue: colorValue ?? this.colorValue,
      symbols: symbols ?? this.symbols,
      isEnabled: isEnabled ?? this.isEnabled,
      sendPushOnUse: sendPushOnUse ?? this.sendPushOnUse,
    );
  }
}

/// Vordefinierte Kommunikations-Kategorien
class CommunicationData {
  // 1. Schmerzen/Unwohlsein - mit Push an Eltern
  static const schmerzen = CommunicationCategory(
    id: 'schmerzen',
    name: 'Schmerzen',
    icon: '🩹',
    colorValue: 0xFFE53935,
    sendPushOnUse: true,
    symbols: [
      CommunicationSymbol(
        id: 'schmerzen_kopf',
        word: 'Kopf tut weh',
        imageAsset: 'assets/communication/schmerzen/kopf.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_bauch',
        word: 'Bauch tut weh',
        imageAsset: 'assets/communication/schmerzen/bauch.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_hals',
        word: 'Hals tut weh',
        imageAsset: 'assets/communication/schmerzen/hals.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_ohr',
        word: 'Ohr tut weh',
        imageAsset: 'assets/communication/schmerzen/ohr.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_zahn',
        word: 'Zahn tut weh',
        imageAsset: 'assets/communication/schmerzen/zahn.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_bein',
        word: 'Bein tut weh',
        imageAsset: 'assets/communication/schmerzen/bein.png',
      ),
      CommunicationSymbol(
        id: 'schmerzen_arm',
        word: 'Arm tut weh',
        imageAsset: 'assets/communication/schmerzen/arm.png',
      ),
    ],
  );

  // 2. Essen
  static const essen = CommunicationCategory(
    id: 'essen',
    name: 'Essen',
    icon: '🍽️',
    colorValue: 0xFFFF9800,
    symbols: [
      CommunicationSymbol(
        id: 'essen_fruehstueck',
        word: 'Frühstück',
        imageAsset: 'assets/communication/essen/fruehstueck.png',
        subOptions: [
          CommunicationSymbol(id: 'essen_muesli', word: 'Müsli', imageAsset: 'assets/communication/essen/muesli.png'),
          CommunicationSymbol(id: 'essen_brot', word: 'Brot', imageAsset: 'assets/communication/essen/brot.png'),
          CommunicationSymbol(id: 'essen_ei', word: 'Ei', imageAsset: 'assets/communication/essen/ei.png'),
        ],
      ),
      CommunicationSymbol(
        id: 'essen_mittag',
        word: 'Mittagessen',
        imageAsset: 'assets/communication/essen/mittag.png',
      ),
      CommunicationSymbol(
        id: 'essen_snack',
        word: 'Snack',
        imageAsset: 'assets/communication/essen/snack.png',
        subOptions: [
          CommunicationSymbol(id: 'essen_obst', word: 'Obst', imageAsset: 'assets/communication/essen/obst.png'),
          CommunicationSymbol(id: 'essen_kekse', word: 'Kekse', imageAsset: 'assets/communication/essen/kekse.png'),
          CommunicationSymbol(id: 'essen_suess', word: 'Süßigkeiten', imageAsset: 'assets/communication/essen/suess.png'),
        ],
      ),
      CommunicationSymbol(
        id: 'essen_abend',
        word: 'Abendessen',
        imageAsset: 'assets/communication/essen/abend.png',
      ),
    ],
  );

  // 3. Trinken
  static const trinken = CommunicationCategory(
    id: 'trinken',
    name: 'Trinken',
    icon: '🥤',
    colorValue: 0xFF2196F3,
    symbols: [
      CommunicationSymbol(id: 'trinken_wasser', word: 'Wasser', imageAsset: 'assets/communication/trinken/wasser.png'),
      CommunicationSymbol(id: 'trinken_saft', word: 'Saft', imageAsset: 'assets/communication/trinken/saft.png'),
      CommunicationSymbol(id: 'trinken_milch', word: 'Milch', imageAsset: 'assets/communication/trinken/milch.png'),
      CommunicationSymbol(id: 'trinken_kakao', word: 'Kakao', imageAsset: 'assets/communication/trinken/kakao.png'),
      CommunicationSymbol(id: 'trinken_tee', word: 'Tee', imageAsset: 'assets/communication/trinken/tee.png'),
    ],
  );

  // 4. Gefühle
  static const gefuehle = CommunicationCategory(
    id: 'gefuehle',
    name: 'Gefühle',
    icon: '😊',
    colorValue: 0xFFE91E63,
    symbols: [
      CommunicationSymbol(id: 'gefuehl_gluecklich', word: 'Glücklich', imageAsset: 'assets/communication/gefuehle/gluecklich.png'),
      CommunicationSymbol(id: 'gefuehl_traurig', word: 'Traurig', imageAsset: 'assets/communication/gefuehle/traurig.png'),
      CommunicationSymbol(id: 'gefuehl_wuetend', word: 'Wütend', imageAsset: 'assets/communication/gefuehle/wuetend.png'),
      CommunicationSymbol(id: 'gefuehl_muede', word: 'Müde', imageAsset: 'assets/communication/gefuehle/muede.png'),
      CommunicationSymbol(id: 'gefuehl_angst', word: 'Ängstlich', imageAsset: 'assets/communication/gefuehle/angst.png'),
      CommunicationSymbol(id: 'gefuehl_langweilig', word: 'Langweilig', imageAsset: 'assets/communication/gefuehle/langweilig.png'),
    ],
  );

  // 5. Aktivitäten
  static const aktivitaeten = CommunicationCategory(
    id: 'aktivitaeten',
    name: 'Aktivitäten',
    icon: '🎮',
    colorValue: 0xFF9C27B0,
    symbols: [
      CommunicationSymbol(id: 'aktiv_spielen', word: 'Spielen', imageAsset: 'assets/communication/aktivitaeten/spielen.png'),
      CommunicationSymbol(id: 'aktiv_fernsehen', word: 'Fernsehen', imageAsset: 'assets/communication/aktivitaeten/fernsehen.png'),
      CommunicationSymbol(id: 'aktiv_draussen', word: 'Draußen', imageAsset: 'assets/communication/aktivitaeten/draussen.png'),
      CommunicationSymbol(id: 'aktiv_schlafen', word: 'Schlafen', imageAsset: 'assets/communication/aktivitaeten/schlafen.png'),
      CommunicationSymbol(id: 'aktiv_kuscheln', word: 'Kuscheln', imageAsset: 'assets/communication/aktivitaeten/kuscheln.png'),
      CommunicationSymbol(id: 'aktiv_vorlesen', word: 'Vorlesen', imageAsset: 'assets/communication/aktivitaeten/vorlesen.png'),
    ],
  );

  // 6. Toilette/Hygiene
  static const toilette = CommunicationCategory(
    id: 'toilette',
    name: 'Toilette',
    icon: '🚽',
    colorValue: 0xFF00BCD4,
    symbols: [
      CommunicationSymbol(id: 'toilette_wc', word: 'Toilette', imageAsset: 'assets/communication/toilette/wc.png'),
      CommunicationSymbol(id: 'toilette_haende', word: 'Hände waschen', imageAsset: 'assets/communication/toilette/haende.png'),
      CommunicationSymbol(id: 'toilette_baden', word: 'Baden', imageAsset: 'assets/communication/toilette/baden.png'),
      CommunicationSymbol(id: 'toilette_zaehne', word: 'Zähne putzen', imageAsset: 'assets/communication/toilette/zaehne.png'),
    ],
  );

  // 7. Hilfe - mit Push an Eltern
  static const hilfe = CommunicationCategory(
    id: 'hilfe',
    name: 'Hilfe',
    icon: '🆘',
    colorValue: 0xFFFF5722,
    sendPushOnUse: true,
    symbols: [
      CommunicationSymbol(id: 'hilfe_brauche', word: 'Ich brauche Hilfe', imageAsset: 'assets/communication/hilfe/hilfe.png'),
      CommunicationSymbol(id: 'hilfe_verstehe', word: 'Ich verstehe nicht', imageAsset: 'assets/communication/hilfe/verstehe.png'),
      CommunicationSymbol(id: 'hilfe_nochmal', word: 'Nochmal zeigen', imageAsset: 'assets/communication/hilfe/nochmal.png'),
    ],
  );

  // 8. Ja/Nein - Schnellantworten
  static const jaNein = CommunicationCategory(
    id: 'janein',
    name: 'Ja/Nein',
    icon: '✅',
    colorValue: 0xFF4CAF50,
    symbols: [
      CommunicationSymbol(id: 'antwort_ja', word: 'Ja', imageAsset: 'assets/communication/janein/ja.png'),
      CommunicationSymbol(id: 'antwort_nein', word: 'Nein', imageAsset: 'assets/communication/janein/nein.png'),
      CommunicationSymbol(id: 'antwort_vielleicht', word: 'Vielleicht', imageAsset: 'assets/communication/janein/vielleicht.png'),
    ],
  );

  // 9. Menschen rufen
  static const menschen = CommunicationCategory(
    id: 'menschen',
    name: 'Menschen',
    icon: '👨‍👩‍👧',
    colorValue: 0xFF795548,
    sendPushOnUse: true,
    symbols: [
      CommunicationSymbol(id: 'mensch_mama', word: 'Mama', imageAsset: 'assets/communication/menschen/mama.png'),
      CommunicationSymbol(id: 'mensch_papa', word: 'Papa', imageAsset: 'assets/communication/menschen/papa.png'),
      CommunicationSymbol(id: 'mensch_oma', word: 'Oma', imageAsset: 'assets/communication/menschen/oma.png'),
      CommunicationSymbol(id: 'mensch_opa', word: 'Opa', imageAsset: 'assets/communication/menschen/opa.png'),
      CommunicationSymbol(id: 'mensch_geschwister', word: 'Geschwister', imageAsset: 'assets/communication/menschen/geschwister.png'),
    ],
  );

  // 10. Orte
  static const orte = CommunicationCategory(
    id: 'orte',
    name: 'Orte',
    icon: '🏠',
    colorValue: 0xFF607D8B,
    symbols: [
      CommunicationSymbol(id: 'ort_zuhause', word: 'Nach Hause', imageAsset: 'assets/communication/orte/zuhause.png'),
      CommunicationSymbol(id: 'ort_draussen', word: 'Rausgehen', imageAsset: 'assets/communication/orte/draussen.png'),
      CommunicationSymbol(id: 'ort_spielplatz', word: 'Spielplatz', imageAsset: 'assets/communication/orte/spielplatz.png'),
      CommunicationSymbol(id: 'ort_arzt', word: 'Arzt', imageAsset: 'assets/communication/orte/arzt.png'),
    ],
  );

  static List<CommunicationCategory> getAll() => [
    schmerzen,
    essen,
    trinken,
    gefuehle,
    aktivitaeten,
    toilette,
    hilfe,
    jaNein,
    menschen,
    orte,
  ];

  static CommunicationCategory? getById(String id) {
    try {
      return getAll().firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
