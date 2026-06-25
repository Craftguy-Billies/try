
enum ExamQuestionType { multipleChoice, fillBlank, translation, listening }

class ExamQuestion {
  final String id;
  final ExamQuestionType type;
  final String prompt;
  final String correctAnswer;
  final List<String> options;
  final String? explanation;
  final int difficulty;
  final String category;
  final String? audioPath;

  const ExamQuestion({
    required this.id, required this.type, required this.prompt,
    required this.correctAnswer, required this.options, this.explanation,
    required this.difficulty, required this.category, this.audioPath,
  });
}

class ExamConfig {
  final String level;
  final int questionCount;
  final int timeMinutes;
  final int passingScore;
  final List<String> categories;

  const ExamConfig({
    required this.level, required this.questionCount,
    required this.timeMinutes, required this.passingScore,
    required this.categories,
  });
}
