
class VocabularyWord {
  final String id;
  final String french;
  final String english;
  final String? pronunciation;
  final String partOfSpeech;
  final String? exampleFrench;
  final String? exampleEnglish;
  final String category;
  final int difficulty; // 1=A1, 2=A2, 3=B1, 4=B2
  final List<String>? synonyms;
  final String? gender; // masculine, feminine

  const VocabularyWord({
    required this.id,
    required this.french,
    required this.english,
    this.pronunciation,
    required this.partOfSpeech,
    this.exampleFrench,
    this.exampleEnglish,
    required this.category,
    required this.difficulty,
    this.synonyms,
    this.gender,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'french': french, 'english': english,
    'pronunciation': pronunciation, 'partOfSpeech': partOfSpeech,
    'exampleFrench': exampleFrench, 'exampleEnglish': exampleEnglish,
    'category': category, 'difficulty': difficulty,
    'synonyms': synonyms, 'gender': gender,
  };

  factory VocabularyWord.fromJson(Map<String, dynamic> json) => VocabularyWord(
    id: json['id'] as String, french: json['french'] as String,
    english: json['english'] as String, pronunciation: json['pronunciation'] as String?,
    partOfSpeech: json['partOfSpeech'] as String,
    exampleFrench: json['exampleFrench'] as String?,
    exampleEnglish: json['exampleEnglish'] as String?,
    category: json['category'] as String,
    difficulty: json['difficulty'] as int,
    synonyms: (json['synonyms'] as List?)?.cast<String>(),
    gender: json['gender'] as String?,
  );

  static String difficultyLabel(int d) {
    switch (d) { case 1: return 'A1'; case 2: return 'A2'; case 3: return 'B1'; case 4: return 'B2'; default: return '?'; }
  }
}

class VocabularyCategory {
  final String id;
  final String nameKey;
  final String icon;
  final String colorHex;
  final int wordCount;

  const VocabularyCategory({
    required this.id, required this.nameKey, required this.icon,
    required this.colorHex, required this.wordCount,
  });
}
