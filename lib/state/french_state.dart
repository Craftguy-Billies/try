import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vocab_item.dart';
import '../data/french_vocab.dart';
import '../data/french_verbs.dart';
import '../data/french_grammar.dart';
import 'app_state.dart';

class FrenchState extends ChangeNotifier {
  static final FrenchState _instance = FrenchState._internal();
  factory FrenchState() => _instance;
  FrenchState._internal();

  final AppState _app = AppState();

  // Vocab items with SRS tracking
  List<VocabItem> _vocab = [];
  List<VocabItem> get vocab => List.unmodifiable(_vocab);

  bool _savePending = false;

  // Current quiz state
  List<VocabItem> _quizItems = [];
  int _quizIndex = 0;
  int _quizCorrect = 0;
  int _quizTotal = 0;
  bool _quizComplete = false;
  bool _quizActive = false; // guard against double quiz start
  String _quizMode = 'practice'; // 'practice' or 'exam'

  List<VocabItem> get quizItems => List.unmodifiable(_quizItems);
  int get quizIndex => _quizIndex;
  int get quizCorrect => _quizCorrect;
  int get quizTotal => _quizTotal;
  bool get quizComplete => _quizComplete;
  bool get quizActive => _quizActive;
  String get quizMode => _quizMode;

  // Exam mode
  int _examTimeRemaining = 300; // 5 minutes
  int get examTimeRemaining => _examTimeRemaining;
  String _examLevel = 'A1';
  String get examLevel => _examLevel;

  // Stats
  int get totalWordsStudied => _vocab.where((v) => v.srsLevel > 0).length;
  int get masteredWords => _vocab.where((v) => v.srsLevel >= 4).length;
  double get averageMastery => _vocab.isEmpty ? 0.0 : _vocab.map((v) => v.mastery).reduce((a, b) => a + b) / _vocab.length;

  bool _initialized = false;
  bool get initialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;
    _app.log('INIT', 'FrenchState initializing');
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load vocab items
      final savedVocab = prefs.getStringList('vocabItems') ?? [];
      if (savedVocab.isNotEmpty) {
        _vocab = savedVocab.map((s) {
          try {
            final decoded = jsonDecode(s) as Map<String, dynamic>;
            return VocabItem.fromJson(decoded);
          } catch (e) {
            _app.log('ERROR', 'Failed to decode vocab item', {'error': e.toString()});
            return null;
          }
        }).whereType<VocabItem>().toList();
        if (_vocab.isEmpty) {
          _vocab = allVocabWords.map((w) => VocabItem(word: w)).toList();
          _app.log('INIT', 'Fallback to fresh vocab after decode failure');
        } else {
          _app.log('INIT', 'Loaded saved vocab', {'count': _vocab.length});
        }
      } else {
        // Initialize with all vocab words
        _vocab = allVocabWords.map((w) => VocabItem(word: w)).toList();
        _app.log('INIT', 'Initialized fresh vocab', {'count': _vocab.length});
      }
    } catch (e) {
      _app.log('ERROR', 'FrenchState initialize failed', {'error': e.toString()});
      _vocab = allVocabWords.map((w) => VocabItem(word: w)).toList();
    }

    _initialized = true;
    notifyListeners();
    _app.log('INIT', 'FrenchState ready', {'vocabCount': _vocab.length});
  }

  Future<void> _saveVocab() async {
    if (_savePending) return;
    _savePending = true;
    try {
      await Future.delayed(const Duration(milliseconds: 100));
      final prefs = await SharedPreferences.getInstance();
      final encoded = _vocab.map((v) => jsonEncode(v.toJson())).toList();
      await prefs.setStringList('vocabItems', encoded);
    } catch (e) {
      _app.log('ERROR', 'Failed to save vocab', {'error': e.toString()});
    } finally {
      _savePending = false;
    }
  }

  void resetAll() {
    _vocab = allVocabWords.map((w) => VocabItem(word: w)).toList();
    _quizItems = [];
    _quizIndex = 0;
    _quizCorrect = 0;
    _quizTotal = 0;
    _quizComplete = false;
    _quizMode = 'practice';
    _app.log('SETTINGS', 'FrenchState reset', {'vocabCount': _vocab.length});
    _saveVocab();
    notifyListeners();
  }

  // Get due words for review
  List<VocabItem> getDueWords({String? category, int limit = 10}) {
    var due = _vocab.where((v) => v.isDue).toList();
    if (category != null) {
      due = due.where((v) => v.word.category == category).toList();
    }
    due.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    return due.take(limit).toList();
  }

  // Get words by category
  List<VocabItem> getWordsByCategory(String category) {
    return _vocab.where((v) => v.word.category == category).toList();
  }

  // Get words by SRS level
  List<VocabItem> getWordsByLevel(int level) {
    return _vocab.where((v) => v.srsLevel == level).toList();
  }

  // Mark word as correct/incorrect with SRS update
  void markWordCorrect(VocabItem item) {
    final idx = _vocab.indexOf(item);
    if (idx == -1) return;
    _vocab[idx].markCorrect();
    _app.addXP(10);
    _app.log('SRS', 'Word correct', {'word': item.word.french, 'level': _vocab[idx].srsLevel});
    _saveVocab();
    notifyListeners();
  }

  void markWordIncorrect(VocabItem item) {
    final idx = _vocab.indexOf(item);
    if (idx == -1) return;
    _vocab[idx].markIncorrect();
    _app.addXP(2);
    _app.log('SRS', 'Word incorrect', {'word': item.word.french, 'level': _vocab[idx].srsLevel});
    _saveVocab();
    notifyListeners();
  }

  // Quiz generation
  void startQuiz({int count = 10, String? category, String mode = 'practice'}) {
    if (_quizActive) {
      _app.log('QUIZ', 'Quiz rejected - already active');
      return;
    }
    _quizActive = true;
    _quizMode = mode;
    _quizIndex = 0;
    _quizCorrect = 0;
    _quizTotal = count;
    _quizComplete = false;

    var pool = category != null
        ? _vocab.where((v) => v.word.category == category).toList()
        : List<VocabItem>.from(_vocab);

    pool.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    _quizItems = pool.take(count).toList();
    _app.log('QUIZ', 'Quiz started', {'mode': mode, 'count': count, 'category': category ?? 'all'});
    notifyListeners();
  }

  void startExam({String level = 'A1', int timeSeconds = 300, int count = 30}) {
    if (_quizActive) {
      _app.log('QUIZ', 'Exam rejected - quiz already active');
      return;
    }
    _quizActive = true;
    _quizMode = 'exam';
    _examLevel = level;
    _examTimeRemaining = timeSeconds;

    List<VocabWord> delfVocab;
    switch (level) {
      case 'A1': delfVocab = delfA1Vocab; break;
      case 'A2': delfVocab = delfA2Vocab; break;
      case 'B1': delfVocab = delfB1Vocab; break;
      default: delfVocab = delfA1Vocab;
    }

    _quizItems = delfVocab.map((w) => _vocab.firstWhere((v) => v.word.french == w.french, orElse: () => VocabItem(word: w))).toList();
    _quizItems.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    _quizItems = _quizItems.take(count).toList();

    if (_quizItems.isEmpty) {
      _quizComplete = true;
      _quizActive = false;
      _app.log('ERROR', 'Exam has no quiz items', {'level': level});
      notifyListeners();
      return;
    }

    _quizIndex = 0;
    _quizCorrect = 0;
    _quizTotal = _quizItems.length;
    _quizComplete = false;
    _app.log('EXAM', 'Exam started', {'level': level, 'time': timeSeconds, 'count': _quizTotal});
    notifyListeners();
  }

  VocabItem? get currentQuizItem => _quizIndex < _quizItems.length ? _quizItems[_quizIndex] : null;

  List<String> generateOptions(VocabItem correct) {
    var options = <String>[correct.word.english];
    var pool = _vocab.where((v) => v.word.english != correct.word.english).toList();
    pool.shuffle(Random(DateTime.now().millisecondsSinceEpoch));
    for (final v in pool.take(3)) {
      options.add(v.word.english);
    }
    options.shuffle();
    return options;
  }

  bool answerQuiz(bool correct) {
    if (_quizComplete) return false;
    final item = _quizItems[_quizIndex];
    if (correct) {
      _quizCorrect++;
      markWordCorrect(item);
    } else {
      markWordIncorrect(item);
    }
    _quizIndex++;
    if (_quizIndex >= _quizItems.length) {
      _quizComplete = true;
      _quizActive = false;
      final xpBonus = _quizMode == 'exam' ? 50 : 20;
      _app.addXP(xpBonus * _quizCorrect);
      _app.updateStreak();
      _app.log('QUIZ', 'Quiz complete', {'correct': _quizCorrect, 'total': _quizTotal, 'mode': _quizMode});
    }
    notifyListeners();
    return true;
  }

  void tickExamTimer() {
    if (_quizMode != 'exam' || _quizComplete) return;
    if (_examTimeRemaining > 0) {
      _examTimeRemaining--;
      if (_examTimeRemaining == 0) {
        _quizComplete = true;
        _quizActive = false;
        _app.log('EXAM', 'Time up', {'correct': _quizCorrect, 'total': _quizTotal});
      }
      notifyListeners();
    }
  }

  void resetQuiz() {
    _quizItems = [];
    _quizIndex = 0;
    _quizCorrect = 0;
    _quizTotal = 0;
    _quizComplete = false;
    _quizActive = false;
    _quizMode = 'practice';
    _app.log('QUIZ', 'Quiz reset');
    notifyListeners();
  }

  // Category stats
  Map<String, double> get categoryMastery {
    final map = <String, List<double>>{};
    for (final v in _vocab) {
      map.putIfAbsent(v.word.category, () => []);
      map[v.word.category]!.add(v.mastery);
    }
    return map.map((k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length));
  }

  // Today's study count
  int get todayStudied {
    final today = DateTime.now();
    return _vocab.where((v) {
      return v.lastReviewed.year == today.year &&
          v.lastReviewed.month == today.month &&
          v.lastReviewed.day == today.day;
    }).length;
  }

  // Verbs access
  List<FrenchVerb> get allVerbsList => allVerbs;

  // Grammar access
  List<GrammarLesson> get grammarLessonList => grammarLessons;
}
