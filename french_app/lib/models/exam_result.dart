class ExamQuestionResult {
  final String questionId;
  final String question;
  final String correctAnswer;
  final String? userAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;

  const ExamQuestionResult({
    required this.questionId,
    required this.question,
    required this.correctAnswer,
    this.userAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
  });

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'question': question,
      'correctAnswer': correctAnswer,
      'userAnswer': userAnswer,
      'isCorrect': isCorrect,
      'timeSpentSeconds': timeSpentSeconds,
    };
  }

  factory ExamQuestionResult.fromJson(Map<String, dynamic> json) {
    return ExamQuestionResult(
      questionId: json['questionId'] as String,
      question: json['question'] as String,
      correctAnswer: json['correctAnswer'] as String,
      userAnswer: json['userAnswer'] as String?,
      isCorrect: json['isCorrect'] as bool,
      timeSpentSeconds: json['timeSpentSeconds'] as int,
    );
  }
}

class ExamResult {
  final String id;
  final String level;
  final DateTime date;
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final int timeSpentSeconds;
  final double percentageScore;
  final List<ExamQuestionResult> questionResults;
  final String examType;

  const ExamResult({
    required this.id,
    required this.level,
    required this.date,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    required this.timeSpentSeconds,
    required this.percentageScore,
    required this.questionResults,
    required this.examType,
  });

  bool get isPassed => percentageScore >= 50.0;

  String get grade {
    if (percentageScore >= 90) return 'A';
    if (percentageScore >= 75) return 'B';
    if (percentageScore >= 60) return 'C';
    if (percentageScore >= 50) return 'D';
    return 'F';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'date': date.toIso8601String(),
      'totalQuestions': totalQuestions,
      'correctAnswers': correctAnswers,
      'incorrectAnswers': incorrectAnswers,
      'timeSpentSeconds': timeSpentSeconds,
      'percentageScore': percentageScore,
      'questionResults': questionResults.map((q) => q.toJson()).toList(),
      'examType': examType,
    };
  }

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      id: json['id'] as String,
      level: json['level'] as String,
      date: DateTime.parse(json['date'] as String),
      totalQuestions: json['totalQuestions'] as int,
      correctAnswers: json['correctAnswers'] as int,
      incorrectAnswers: json['incorrectAnswers'] as int,
      timeSpentSeconds: json['timeSpentSeconds'] as int,
      percentageScore: (json['percentageScore'] as num).toDouble(),
      questionResults: (json['questionResults'] as List<dynamic>)
          .map((q) =>
              ExamQuestionResult.fromJson(q as Map<String, dynamic>))
          .toList(),
      examType: json['examType'] as String,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ExamResult && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
