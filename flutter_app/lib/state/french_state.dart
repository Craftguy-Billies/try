import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vocab_item.dart';
import '../data/french_vocab.dart';
import 'app_state.dart';

enum QuizMode { frenchToEnglish, englishToFrench, multipleChoice }

class FrenchState extends ChangeNotifier {
  static const _keyVocab = 'french_vocab';
  static const _keyStats = 'french_stats';
  static const _keyStudyDays = 'french_study_days';

  final Map<String, VocabItem> _vocab = {};
  final Random _rng = Random();

  String _activeCategory = 'Greetings';
  String get activeCategory => _activeCategory;

  int _dailyXP = 0;
  int get dailyXP => _dailyXP;

  int _totalXP = 0;
  int get totalXP => _totalXP;

  int _streak = 0;
  int get streak => _streak;

  int _wordsLearned = 0;
  int get wordsLearned => _wordsLearned;

  final int _dailyGoal = 50;
  int get dailyGoal => _dailyGoal;

  DateTime _lastStudyDate = DateTime.now();
  DateTime get lastStudyDate => _lastStudyDate;

  final List<DateTime> _studyDays = [];
  List<DateTime> get studyDays => List.unmodifiable(_studyDays);

  final Map<String, int> _categoryProgress = {};
  Map<String, int> get categoryProgress => Map.unmodifiable(_categoryProgress);

  // Quiz state
  VocabItem? _currentQuizItem;
  VocabItem? get currentQuizItem => _currentQuizItem;

  List<VocabItem> _quizOptions = [];
  List<VocabItem> get quizOptions => List.unmodifiable(_quizOptions);

  int _quizStreak = 0;
  int get quizStreak => _quizStreak;

  int _quizCorrect = 0;
  int get quizCorrect => _quizCorrect;

  int _quizTotal = 0;
  int get quizTotal => _quizTotal;

  int _dailyWordsSeen = 0;
  int get dailyWordsSeen => _dailyWordsSeen;

  static const int _quizOptionCount = 4;

  FrenchState() {
    _initVocab();
    _checkDailyReset();
  }

  // ---- Persistence ----
  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Restore vocab progress
      final vocabJson = prefs.getString(_keyVocab);
      if (vocabJson != null) {
        final List<dynamic> data = jsonDecode(vocabJson);
        for (final entry in data) {
          final item = VocabItem.fromJson(entry as Map<String, dynamic>);
          if (_vocab.containsKey(item.id)) {
            final existing = _vocab[item.id]!;
            existing.level = item.level;
            existing.correctCount = item.correctCount;
            existing.incorrectCount = item.incorrectCount;
            existing.streak = item.streak;
            existing.nextReview = item.nextReview;
          }
        }
      }

      // Restore stats
      final statsJson = prefs.getString(_keyStats);
      if (statsJson != null) {
        final Map<String, dynamic> stats = jsonDecode(statsJson) as Map<String, dynamic>;
        _dailyXP = stats['dailyXP'] ?? 0;
        _totalXP = stats['totalXP'] ?? 0;
        _streak = stats['streak'] ?? 0;
        _wordsLearned = stats['wordsLearned'] ?? 0;
        _quizCorrect = stats['quizCorrect'] ?? 0;
        _quizTotal = stats['quizTotal'] ?? 0;
        if (stats['lastStudyDate'] != null) {
          _lastStudyDate = DateTime.parse(stats['lastStudyDate'] as String);
        }
      }

      // Restore study days
      final daysJson = prefs.getString(_keyStudyDays);
      if (daysJson != null) {
        final List<dynamic> days = jsonDecode(daysJson);
        _studyDays.clear();
        for (final d in days) {
          _studyDays.add(DateTime.parse(d as String));
        }
      }

      _updateCategoryProgress();
      _checkDailyReset();
      appState.log('FRENCH', 'Progress loaded: $_totalXP XP, $_streak day streak, $_wordsLearned words', color: Colors.teal);
      notifyListeners();
    } catch (e) {
      appState.log('FRENCH', 'Failed to load progress: $e', color: Colors.red);
    }
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save vocab progress (only fields that change)
      final vocabData = _vocab.values.map((v) => jsonEncode(v.toJson())).map((s) => jsonDecode(s)).toList();
      await prefs.setString(_keyVocab, jsonEncode(vocabData));

      // Save stats
      final stats = {
        'dailyXP': _dailyXP,
        'totalXP': _totalXP,
        'streak': _streak,
        'wordsLearned': _wordsLearned,
        'quizCorrect': _quizCorrect,
        'quizTotal': _quizTotal,
        'lastStudyDate': _lastStudyDate.toIso8601String(),
      };
      await prefs.setString(_keyStats, jsonEncode(stats));

      // Save study days
      final days = _studyDays.map((d) => d.toIso8601String()).toList();
      await prefs.setString(_keyStudyDays, jsonEncode(days));
    } catch (e) {
      appState.log('FRENCH', 'Failed to save progress: $e', color: Colors.red);
    }
  }

  void _initVocab() {
    for (final list in frenchVocabulary.values) {
      for (final item in list) {
        _vocab[item.id] = item;
      }
    }
    _updateCategoryProgress();
  }

  void _updateCategoryProgress() {
    for (final cat in frenchVocabulary.keys) {
      final words = frenchVocabulary[cat]!;
      final learned = words.where((w) => _vocab[w.id]!.level >= 3).length;
      _categoryProgress[cat] = words.isEmpty ? 0 : (learned * 100 ~/ words.length);
    }
  }

  void _checkDailyReset() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final lastDay = DateTime(_lastStudyDate.year, _lastStudyDate.month, _lastStudyDate.day);

    if (today.isAfter(lastDay)) {
      if (today.difference(lastDay).inDays == 1) {
        _streak++;
        if (!_studyDays.any((d) => d.year == lastDay.year && d.month == lastDay.month && d.day == lastDay.day)) {
          _studyDays.add(lastDay);
        }
      } else if (today.difference(lastDay).inDays > 1) {
        _streak = 0;
      }
      _dailyXP = 0;
      _dailyWordsSeen = 0;
      _lastStudyDate = now;
      if (!_studyDays.any((d) => d.year == today.year && d.month == today.month && d.day == today.day)) {
        _studyDays.add(today);
      }
    }
  }

  // ---- Categories ----
  List<String> get categories => frenchVocabulary.keys.toList();

  void setCategory(String category) {
    if (_activeCategory == category || !frenchVocabulary.containsKey(category)) return;
    _activeCategory = category;
    appState.log('FRENCH', 'Switched to category: $category', color: Colors.indigo);
    notifyListeners();
  }

  // ---- Vocabulary ----
  List<VocabItem> get wordsForActiveCategory => frenchVocabulary[_activeCategory]!;

  List<VocabItem> get allWords => _vocab.values.toList();

  List<VocabItem> getDueWords(String category) {
    _checkDailyReset();
    final words = frenchVocabulary[category]!;
    final due = words.where((w) => _vocab[w.id]!.isDue).toList();
    due.sort((a, b) => _vocab[a.id]!.level.compareTo(_vocab[b.id]!.level));
    return due;
  }

  int wordsLearnedInCategory(String category) {
    final words = frenchVocabulary[category]!;
    return words.where((w) => _vocab[w.id]!.level >= 3).length;
  }

  int totalWordsInCategory(String category) {
    return frenchVocabulary[category]!.length;
  }

  VocabItem? getNextDueWord(String category) {
    final due = getDueWords(category);
    if (due.isEmpty) return null;

    // Prioritize lower-level words with some randomness
    final lowLevel = due.where((w) => _vocab[w.id]!.level <= 2).toList();
    if (lowLevel.isNotEmpty) {
      return lowLevel[_rng.nextInt(lowLevel.length)];
    }
    return due[_rng.nextInt(due.length)];
  }

  void recordAnswer(VocabItem item, bool correct) {
    final v = _vocab[item.id]!;
    if (correct) {
      v.recordCorrect();
      _dailyXP += 10;
      _totalXP += 10;
      _quizCorrect++;
      _quizStreak++;
      if (_quizStreak % 5 == 0) {
        _dailyXP += 5; // streak bonus
        _totalXP += 5;
      }
      if (v.level == 3 && _wordsLearned < _vocab.values.where((w) => w.level >= 3).length) {
        _wordsLearned = _vocab.values.where((w) => w.level >= 3).length;
      }
      appState.log('FRENCH', '✅ Correct: "${v.french}" (level ${v.level}, streak $_quizStreak)', color: Colors.green);
    } else {
      v.recordIncorrect();
      _quizStreak = 0;
      appState.log('FRENCH', '❌ Incorrect: "${v.french}" (level ${v.level})', color: Colors.red);
    }
    _quizTotal++;
    _dailyWordsSeen++;
    _updateCategoryProgress();
    _lastStudyDate = DateTime.now();
    _save();
    notifyListeners();
  }

  // ---- Quiz ----
  void generateQuiz({QuizMode mode = QuizMode.multipleChoice}) {
    _checkDailyReset();
    final correct = getNextDueWord(_activeCategory);
    if (correct == null) {
      _currentQuizItem = null;
      _quizOptions = [];
      appState.log('FRENCH', 'All words in $_activeCategory are up to date! 🎉', color: Colors.green);
      notifyListeners();
      return;
    }
    _currentQuizItem = correct;

    final allInCategory = frenchVocabulary[_activeCategory]!
        .where((w) => w.id != correct.id)
        .toList();
    allInCategory.shuffle(_rng);
    final distractors = allInCategory.take(_quizOptionCount - 1).toList();

    // If not enough distractors in same category, pull from others
    if (distractors.length < _quizOptionCount - 1) {
      final others = _vocab.values
          .where((w) => w.category != _activeCategory && w.id != correct.id)
          .toList();
      others.shuffle(_rng);
      final needed = _quizOptionCount - 1 - distractors.length;
      distractors.addAll(others.take(needed));
    }

    _quizOptions = [correct, ...distractors];
    _quizOptions.shuffle(_rng);
    appState.log('FRENCH', 'Quiz: "${correct.french}" (level ${_vocab[correct.id]!.level})', color: Colors.indigo);
    notifyListeners();
  }

  void skipQuiz() {
    _currentQuizItem = null;
    _quizOptions = [];
    notifyListeners();
  }

  // ---- Stats ----
  int get totalWords => _vocab.length;

  double get overallMastery {
    final words = _vocab.values;
    if (words.isEmpty) return 0;
    return words.where((w) => w.level >= 3).length / words.length * 100;
  }

  int get masteredCount => _vocab.values.where((w) => w.level >= 4).length;

  int get learningCount => _vocab.values.where((w) => w.level >= 1 && w.level <= 3).length;

  int get newCount => _vocab.values.where((w) => w.level == 0).length;

  double get dailyProgress => _dailyGoal > 0 ? (_dailyXP / _dailyGoal).clamp(0.0, 1.0) : 0;

  int get streakBest {
    // Calculate best streak from study days
    if (_studyDays.isEmpty) return _streak > 0 ? _streak : 0;
    final days = _studyDays.map((d) => DateTime(d.year, d.month, d.day)).toSet().toList()
      ..sort();
    int best = 0, current = 1;
    for (int i = 1; i < days.length; i++) {
      if (days[i].difference(days[i - 1]).inDays == 1) {
        current++;
      } else {
        best = max(best, current);
        current = 1;
      }
    }
    best = max(best, current);
    best = max(best, _streak);
    return best;
  }

  int get weeklyStudyDays {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));
    return _studyDays.where((d) => d.isAfter(weekAgo) && !d.isAfter(now)).length;
  }

  String get level {
    if (_totalXP >= 10000) return '🇫🇷 Native';
    if (_totalXP >= 5000) return '🗼 Parisian';
    if (_totalXP >= 2500) return '🥐 Expert';
    if (_totalXP >= 1000) return '📚 Advanced';
    if (_totalXP >= 500) return '🎓 Intermediate';
    if (_totalXP >= 200) return '🌱 Beginner';
    return '👋 Newcomer';
  }

  int get xpToNextLevel {
    if (_totalXP >= 10000) return 0;
    if (_totalXP >= 5000) return 10000 - _totalXP;
    if (_totalXP >= 2500) return 5000 - _totalXP;
    if (_totalXP >= 1000) return 2500 - _totalXP;
    if (_totalXP >= 500) return 1000 - _totalXP;
    if (_totalXP >= 200) return 500 - _totalXP;
    return 200 - _totalXP;
  }

  double get xpLevelProgress {
    if (_totalXP >= 10000) return 1.0;
    if (_totalXP >= 5000) return (_totalXP - 5000) / 5000;
    if (_totalXP >= 2500) return (_totalXP - 2500) / 2500;
    if (_totalXP >= 1000) return (_totalXP - 1000) / 1500;
    if (_totalXP >= 500) return (_totalXP - 500) / 500;
    if (_totalXP >= 200) return (_totalXP - 200) / 300;
    return _totalXP / 200;
  }

  // ---- Reset ----
  void resetAll() {
    for (final v in _vocab.values) {
      v.level = 0;
      v.correctCount = 0;
      v.incorrectCount = 0;
      v.streak = 0;
      v.nextReview = null;
    }
    _dailyXP = 0;
    _totalXP = 0;
    _streak = 0;
    _wordsLearned = 0;
    _quizStreak = 0;
    _quizCorrect = 0;
    _quizTotal = 0;
    _dailyWordsSeen = 0;
    _studyDays.clear();
    _currentQuizItem = null;
    _quizOptions = [];
    _updateCategoryProgress();
    _save();
    appState.log('FRENCH', 'All progress reset', color: Colors.red);
    notifyListeners();
  }
}

final FrenchState frenchState = FrenchState();
