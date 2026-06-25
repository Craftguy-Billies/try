import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../debug/debug_logger.dart';
import '../models/user_progress.dart';
import '../models/exam_result.dart';

class ProgressProvider extends ChangeNotifier {
  static const _progressKey = 'user_progress';
  static const _examHistoryKey = 'exam_history';

  UserProgress _progress = UserProgress();
  List<ExamResult> _examHistory = [];

  ProgressProvider() {
    _loadAll();
  }

  UserProgress get progress => _progress;
  List<ExamResult> get examHistory => List.unmodifiable(_examHistory);

  // ─── Word actions ───

  void markWordLearned(String wordId) {
    _progress.markWordMastered(wordId);
    _progress.totalWordsLearned++;
    _progress.updateStreak();
    DebugLogger.logStateChange('ProgressProvider', 'Word mastered: $wordId');
    notifyListeners();
    _saveProgress();
  }

  void markWordReviewed(String wordId) {
    _progress.markWordReviewed(wordId);
    DebugLogger.logStateChange('ProgressProvider', 'Word reviewed: $wordId');
    notifyListeners();
    _saveProgress();
  }

  void toggleFavorite(String wordId) {
    if (_progress.favoriteWordIds.contains(wordId)) {
      _progress.favoriteWordIds.remove(wordId);
      DebugLogger.logStateChange('ProgressProvider', 'Word unfavorited: $wordId');
    } else {
      _progress.favoriteWordIds.add(wordId);
      DebugLogger.logStateChange('ProgressProvider', 'Word favorited: $wordId');
    }
    notifyListeners();
    _saveProgress();
  }

  // ─── Streak ───

  void updateStreak() {
    _progress.updateStreak();
    DebugLogger.logStateChange(
        'ProgressProvider', 'Streak updated: ${_progress.currentStreak}');
    notifyListeners();
    _saveProgress();
  }

  // ─── Statistics ───

  int getProgressForLevel(String level) => _progress.levelProgress[level] ?? 0;

  int getProgressForCategory(String category) =>
      _progress.categoryProgress[category] ?? 0;

  double getOverallProgress() {
    final totalLevels = _progress.levelProgress.values.fold<int>(0, (a, b) => a + b);
    if (totalLevels == 0) return 0.0;
    final totalMastered = _progress.masteredWordIds.length;
    return (totalMastered / totalLevels).clamp(0.0, 1.0);
  }

  // ─── Exam results ───

  void addExamResult(ExamResult result) {
    _examHistory.insert(0, result);
    DebugLogger.logStateChange(
        'ProgressProvider', 'Exam result added: ${result.id} (${result.percentageScore}%)');
    notifyListeners();
    _saveExamHistory();
  }

  List<ExamResult> getExamHistory() => List.unmodifiable(_examHistory);

  // ─── Reset ───

  void resetProgress() {
    _progress = UserProgress();
    _examHistory.clear();
    DebugLogger.logStateChange('ProgressProvider', 'Progress reset');
    notifyListeners();
    _saveProgress();
    _saveExamHistory();
  }

  // ─── Persistence ───

  Future<void> _loadAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final rawProgress = prefs.getString(_progressKey);
      if (rawProgress != null) {
        final json = jsonDecode(rawProgress) as Map<String, dynamic>;
        _progress = UserProgress.fromJson(json);
        DebugLogger.logInit('ProgressProvider loaded progress');
      }

      final rawExams = prefs.getStringList(_examHistoryKey);
      if (rawExams != null) {
        _examHistory = rawExams
            .map((e) => ExamResult.fromJson(jsonDecode(e) as Map<String, dynamic>))
            .toList();
        DebugLogger.logInit(
            'ProgressProvider loaded ${_examHistory.length} exam results');
      }
    } catch (e, stack) {
      DebugLogger.logError('ProgressProvider', 'Failed to load data: $e', stack: stack);
    }
    notifyListeners();
  }

  Future<void> _saveProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_progressKey, jsonEncode(_progress.toJson()));
    } catch (e, stack) {
      DebugLogger.logError('ProgressProvider', 'Failed to save progress: $e', stack: stack);
    }
  }

  Future<void> _saveExamHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = _examHistory.map((e) => jsonEncode(e.toJson())).toList();
      await prefs.setStringList(_examHistoryKey, raw);
    } catch (e, stack) {
      DebugLogger.logError(
          'ProgressProvider', 'Failed to save exam history: $e', stack: stack);
    }
  }
}
