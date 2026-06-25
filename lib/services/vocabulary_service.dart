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
    _logger.info('Vocab', 'Initializing');
    _words = VocabularyData.allWords;
    _cats = VocabularyData.categories;
    _logger.info('Vocab', 'Loaded ${_words!.length} words in ${_cats!.length} categories');
  }

  List<VocabularyWord> get allWords => _words ?? [];
  List<VocabularyCategory> get categories => _cats ?? [];

  List<VocabularyWord> byCategory(String id) => allWords.where((w) => w.category == id).toList();
  List<VocabularyWord> byDifficulty(int d) => allWords.where((w) => w.difficulty == d).toList();

  List<VocabularyWord> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return allWords;
    return allWords.where((w) =>
      w.french.toLowerCase().contains(q) || w.english.toLowerCase().contains(q)).toList();
  }

  VocabularyWord? getById(String id) {
    try { return allWords.firstWhere((w) => w.id == id); }
    catch (_) { _logger.warn('Vocab', 'Not found: $id'); return null; }
  }

  List<VocabularyWord> randomWords({int count = 10, int? difficulty, String? category}) {
    var pool = allWords.toList();
    if (difficulty != null) pool = pool.where((w) => w.difficulty == difficulty).toList();
    if (category != null) pool = pool.where((w) => w.category == category).toList();
    pool.shuffle();
    return pool.take(count).toList();
  }

  VocabularyCategory? getCategoryById(String id) {
    try { return categories.firstWhere((c) => c.id == id); } catch (_) { return null; }
  }
}
