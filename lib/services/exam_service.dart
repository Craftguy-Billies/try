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
    _logger.logAsyncStart('Exam', 'init');
    _all = ExamData.allQuestions;
    _logger.logDataLoad('ExamData', _all!.length);
    _logger.logAsyncDone('Exam', 'init', data: {
      'questions': _all!.length, 'configs': configs.length,
    });
  }

  List<ExamQuestion> generateExam(ExamConfig config) {
    _logger.logAsyncStart('Exam', 'generateExam', data: {
      'level': config.level, 'target_count': config.questionCount,
      'categories': config.categories, 'time_min': config.timeMinutes,
    });

    final diffTarget = _diffFor(config.level);
    var pool = _all!.where((q) =>
      config.categories.contains(q.category) &&
      q.difficulty <= diffTarget).toList();

    _logger.debug('Exam', 'generateExam: filtered pool=${pool.length} (target=${config.questionCount})', data: {
      'diff_target': diffTarget, 'total_all': _all!.length,
    });

    if (pool.length < config.questionCount) {
      _logger.logEdge('Exam', 'insufficient-questions', data: {
        'pool': pool.length, 'needed': config.questionCount, 'level': config.level,
      });
      _logger.logFallback('Exam', 'insufficient filtered questions', 'using all questions as fallback');
      pool = _all!.toList();
      _logger.debug('Exam', 'generateExam: fallback pool=${pool.length}');
    }

    if (pool.isEmpty) {
      _logger.logEdge('Exam', 'completely-empty-pool — this should never happen');
      _logger.logAsyncDone('Exam', 'generateExam (empty)', data: {'count': 0});
      return [];
    }

    pool.shuffle(_random);
    final result = pool.take(config.questionCount).toList();
    _logger.logAsyncDone('Exam', 'generateExam', data: {
      'count': result.length, 'pool_available': pool.length,
    });
    return result;
  }

  int _diffFor(String level) {
    if (level.contains('A1')) return 1;
    if (level.contains('A2')) return 2;
    if (level.contains('B1')) return 3;
    return 4;
  }
}
