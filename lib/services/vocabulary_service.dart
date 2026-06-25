import '../models/vocabulary.dart';
import '../data/vocabulary_data.dart';
import 'audit_logger.dart';

class VocabularyService {
  static final VocabularyService _instance = VocabularyService._();
  factory VocabularyService() => _instance;
  VocabularyService._();

  final _logger = AuditLogger();
  List<VocabularyWord>? _words;
  List<VocabularyCategory>? _cats;

  Future<void> init() async {
    _logger.logAsyncStart('Vocab', 'init');
    _words = VocabularyData.allWords;
    _cats = VocabularyData.categories;
    _logger.logDataLoad('VocabularyData', _words!.length);
    _logger.logAsyncDone('Vocab', 'init', data: {
      'words': _words!.length, 'categories': _cats!.length,
    });
  }

  List<VocabularyWord> get allWords => _words ?? [];
  List<VocabularyCategory> get categories => _cats ?? [];

  List<VocabularyWord> byCategory(String id) {
    final result = allWords.where((w) => w.category == id).toList();
    _logger.logFilter('Vocab', 'category=$id', results: result.length);
    return result;
  }

  List<VocabularyWord> byDifficulty(int d) {
    final result = allWords.where((w) => w.difficulty == d).toList();
    _logger.logFilter('Vocab', 'difficulty=$d', results: result.length);
    return result;
  }

  List<VocabularyWord> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) {
      _logger.logGuardSkip('Vocab', 'search-empty-query');
      return allWords;
    }
    final result = allWords.where((w) =>
      w.french.toLowerCase().contains(q) || w.english.toLowerCase().contains(q)).toList();
    _logger.logSearch('Vocab', q, results: result.length);
    if (result.isEmpty) _logger.logEdge('Vocab', 'search-no-results', data: {'query': q});
    return result;
  }

  VocabularyWord? getById(String id) {
    _logger.debug('Vocab', 'getById=$id');
    try {
      final word = allWords.firstWhere((w) => w.id == id);
      return word;
    } catch (_) {
      _logger.logFallback('Vocab', 'word-not-found', 'null', data: {'id': id});
      return null;
    }
  }

  List<VocabularyWord> randomWords({int count = 10, int? difficulty, String? category}) {
    _logger.debug('Vocab', 'randomWords count=$count', data: {'difficulty': difficulty, 'category': category});
    var pool = allWords.toList();
    if (difficulty != null) {
      final before = pool.length;
      pool = pool.where((w) => w.difficulty == difficulty).toList();
      _logger.debug('Vocab', 'randomWords difficulty filter: $before → ${pool.length}');
    }
    if (category != null) {
      final before = pool.length;
      pool = pool.where((w) => w.category == category).toList();
      _logger.debug('Vocab', 'randomWords category filter: $before → ${pool.length}');
    }
    if (pool.isEmpty) {
      _logger.logEdge('Vocab', 'randomWords-empty-pool', data: {'difficulty': difficulty, 'category': category});
      return [];
    }
    pool.shuffle();
    final result = pool.take(count).toList();
    _logger.debug('Vocab', 'randomWords returning ${result.length}');
    return result;
  }

  VocabularyCategory? getCategoryById(String id) {
    _logger.debug('Vocab', 'getCategoryById=$id');
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (_) {
      _logger.logFallback('Vocab', 'category-not-found', 'null', data: {'id': id});
      return null;
    }
  }
}
