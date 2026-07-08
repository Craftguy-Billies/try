import '../data/french_vocab.dart';

class VocabItem {
  final VocabWord word;
  int srsLevel;
  DateTime nextReview;
  double mastery;
  DateTime createdAt;
  DateTime lastReviewed;
  int correctCount;
  int incorrectCount;

  static const List<int> intervals = [0, 4, 24, 72, 168, 720]; // hours

  VocabItem({
    required this.word,
    this.srsLevel = 0,
    DateTime? nextReview,
    this.mastery = 0.0,
    DateTime? createdAt,
    DateTime? lastReviewed,
    this.correctCount = 0,
    this.incorrectCount = 0,
  })  : nextReview = nextReview ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now(),
        lastReviewed = lastReviewed ?? DateTime.now();

  bool get isDue => DateTime.now().isAfter(nextReview);

  void markCorrect() {
    correctCount++;
    if (srsLevel < 5) srsLevel++;
    _updateNextReview();
    mastery = (mastery + 0.15).clamp(0.0, 1.0);
    lastReviewed = DateTime.now();
  }

  void markIncorrect() {
    incorrectCount++;
    srsLevel = (srsLevel - 1).clamp(0, 5);
    _updateNextReview();
    mastery = (mastery - 0.1).clamp(0.0, 1.0);
    lastReviewed = DateTime.now();
  }

  void _updateNextReview() {
    final hours = intervals[srsLevel];
    nextReview = DateTime.now().add(Duration(hours: hours));
  }

  String get levelLabel {
    const labels = ['New', 'Learning', 'Familiar', 'Known', 'Mastered', 'Fluent'];
    return labels[srsLevel];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VocabItem &&
          word.french == other.word.french &&
          word.english == other.word.english;

  @override
  int get hashCode => word.french.hashCode ^ word.english.hashCode;

  Map<String, dynamic> toJson() => {
        'french': word.french,
        'srsLevel': srsLevel,
        'nextReview': nextReview.toIso8601String(),
        'mastery': mastery,
        'createdAt': createdAt.toIso8601String(),
        'lastReviewed': lastReviewed.toIso8601String(),
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
      };

  static DateTime _parseDate(String? s) {
    if (s == null) return DateTime.now();
    try {
      return DateTime.parse(s);
    } catch (_) {
      return DateTime.now();
    }
  }

  factory VocabItem.fromJson(Map<String, dynamic> json) {
    final french = json['french'] as String;
    final word = allVocabWords.firstWhere(
      (w) => w.french == french,
      orElse: () => VocabWord(
        french: french,
        english: json['french'] as String,
        partOfSpeech: 'noun',
        category: 'Imported',
        difficulty: 1,
      ),
    );
    return VocabItem(
      word: word,
      srsLevel: json['srsLevel'] as int? ?? 0,
      nextReview: _parseDate(json['nextReview'] as String?),
      mastery: (json['mastery'] as num?)?.toDouble() ?? 0.0,
      createdAt: _parseDate(json['createdAt'] as String?),
      lastReviewed: _parseDate(json['lastReviewed'] as String?),
      correctCount: json['correctCount'] as int? ?? 0,
      incorrectCount: json['incorrectCount'] as int? ?? 0,
    );
  }
}
