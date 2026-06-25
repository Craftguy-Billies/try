class VocabItem {
  final String id;
  final String french;
  final String english;
  final String? pronunciation;
  final String category;
  final String level;
  final String? exampleSentence;
  final String? exampleTranslation;
  final String? partOfSpeech;
  final String? gender;

  const VocabItem({
    required this.id,
    required this.french,
    required this.english,
    this.pronunciation,
    required this.category,
    required this.level,
    this.exampleSentence,
    this.exampleTranslation,
    this.partOfSpeech,
    this.gender,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'french': french,
      'english': english,
      'pronunciation': pronunciation,
      'category': category,
      'level': level,
      'exampleSentence': exampleSentence,
      'exampleTranslation': exampleTranslation,
      'partOfSpeech': partOfSpeech,
      'gender': gender,
    };
  }

  factory VocabItem.fromJson(Map<String, dynamic> json) {
    return VocabItem(
      id: json['id'] as String,
      french: json['french'] as String,
      english: json['english'] as String,
      pronunciation: json['pronunciation'] as String?,
      category: json['category'] as String,
      level: json['level'] as String,
      exampleSentence: json['exampleSentence'] as String?,
      exampleTranslation: json['exampleTranslation'] as String?,
      partOfSpeech: json['partOfSpeech'] as String?,
      gender: json['gender'] as String?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is VocabItem && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
