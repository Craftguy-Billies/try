import 'dart:math';
import '../models/exam_question.dart';
import '../data/exam_data.dart';
import 'audit_logger.dart';

class ExamService {
  static final ExamService _instance = ExamService._();
  factory ExamService() => _instance;
  ExamService._();

  final _logger = AuditLogger();
  final _random = Random();
  List<ExamQuestion>? _all;

  static const List<ExamConfig> configs = [
    ExamConfig(level: 'A1 - Beginner', questionCount: 20, timeMinutes: 15, passingScore: 60,
        categories: ['basics', 'greetings', 'family', 'food', 'daily']),
    ExamConfig(level: 'A2 - Elementary', questionCount: 30, timeMinutes: 25, passingScore: 65,
        categories: ['travel', 'shopping', 'health', 'weather', 'work']),
    ExamConfig(level: 'B1 - Intermediate', questionCount: 40, timeMinutes: 35, passingScore: 70,
        categories: ['society', 'education', 'technology', 'culture', 'environment']),
    ExamConfig(level: 'B2 - Upper Intermediate', questionCount: 50, timeMinutes: 50, passingScore: 70,
        categories: ['politics', 'economy', 'arts', 'science', 'philosophy']),
  ];

  Future<void> init() async {
    _logger.info('Exam', 'Initializing');
    _all = ExamData.allQuestions;
    _logger.info('Exam', 'Loaded ${_all!.length} questions');
  }

  List<ExamQuestion> generateExam(ExamConfig config) {
    var pool = _all!.where((q) =>
      config.categories.contains(q.category) &&
      q.difficulty <= _diffFor(config.level)).toList();

    if (pool.length < config.questionCount) {
      _logger.warn('Exam', 'Not enough questions, using all');
      pool = _all!.toList();
    }
    pool.shuffle(_random);
    return pool.take(config.questionCount).toList();
  }

  int _diffFor(String level) {
    if (level.contains('A1')) return 1;
    if (level.contains('A2')) return 2;
    if (level.contains('B1')) return 3;
    return 4;
  }
}
