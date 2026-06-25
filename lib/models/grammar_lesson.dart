
class GrammarLesson {
  final String id;
  final String titleEn;
  final String titleFr;
  final String descriptionEn;
  final String descriptionFr;
  final int difficulty;
  final List<GrammarSection> sections;
  final List<GrammarExercise> exercises;

  const GrammarLesson({
    required this.id, required this.titleEn, required this.titleFr,
    required this.descriptionEn, required this.descriptionFr,
    required this.difficulty, required this.sections, required this.exercises,
  });
}

class GrammarSection {
  final String headingEn;
  final String headingFr;
  final String contentEn;
  final String contentFr;
  final List<String>? examples;

  const GrammarSection({
    required this.headingEn, required this.headingFr,
    required this.contentEn, required this.contentFr, this.examples,
  });
}

class GrammarExercise {
  final String questionEn;
  final String questionFr;
  final String correctAnswer;
  final List<String> options;
  final String? explanation;

  const GrammarExercise({
    required this.questionEn, required this.questionFr,
    required this.correctAnswer, required this.options, this.explanation,
  });
}
