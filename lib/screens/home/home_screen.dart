
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/audit_logger.dart';
import '../../services/storage_service.dart';
import '../../models/user_progress.dart';
import '../../services/vocabulary_service.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/category_card.dart';
import '../../widgets/app_drawer.dart';
import '../vocabulary/vocabulary_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    final t = Translations(Localizations.localeOf(context).languageCode);
    final vocab = context.read<VocabularyService>();
    final progress = context.watch<UserProgressProvider>();

    _logger.logScreenView('Home', p: {
      'words': progress.totalWordsLearned, 'streak': progress.currentStreak,
      'categories': vocab.categories.length, 'loaded': progress.isLoaded,
    });

    if (!progress.isLoaded) {
      _logger.logEdge('Home', 'progress-not-loaded-yet — showing stale/zero data');
    }
    if (vocab.categories.isEmpty) {
      _logger.logEdge('Home', 'empty-categories — no vocabulary categories available');
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _logger.logBackPress('Home', handled: false, data: {'note': 'root — system back ignored'});
        }
      },
      child: Scaffold(
      appBar: AppBar(title: Text(t.get('app_name'))),
      drawer: const AppDrawer(currentRoute: '/'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ProgressCard(wordsLearned: progress.totalWordsLearned, streak: progress.currentStreak,
            minutesPracticed: progress.totalMinutesPracticed, dailyGoal: progress.dailyGoalWords),
          const SizedBox(height: 24),
          Text(t.get('categories'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          if (vocab.categories.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(child: Text(t.get('no_data'),
                style: TextStyle(fontSize: 15, color: AppColors.textSecondary))))
          else
            GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: 1.0, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: vocab.categories.length,
            itemBuilder: (ctx, i) {
              final cat = vocab.categories[i];
              final catProgress = progress.getCategoryProgress(cat.id, cat.wordCount);
              Color color;
              try {
                color = Color(int.parse('FF${cat.colorHex.substring(1)}', radix: 16));
              } catch (_) {
                _logger.logFallback('Home', 'color-parse-failed', 'primary color', data: {'hex': cat.colorHex});
                color = AppColors.primary;
              }
              return CategoryCard(categoryId: cat.id, nameKey: cat.nameKey, iconName: cat.icon,
                color: color, wordCount: cat.wordCount, progress: catProgress,
                onTap: () {
                  _logger.logTap('Home', 'CategoryCard(${cat.id})');
                  _logger.logNavigate('Home', 'VocabularyList(${cat.id})', method: 'push');
                  try {
                    Navigator.push(ctx, MaterialPageRoute(
                      builder: (_) => VocabularyListScreen(categoryId: cat.id, categoryName: t.get(cat.nameKey))));
                  } catch (e, stack) {
                    _logger.logAsyncFail('Home', 'push-VocabularyList', e, stack, data: {'catId': cat.id});
                  }
                });
            }),
          const SizedBox(height: 24),
          Text(t.get('quick_actions'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _QuickAction(icon: Icons.menu_book, label: t.get('vocabulary'), color: AppColors.primary,
              onTap: () {
                _logger.logButton('Home', 'QuickAction:Vocabulary');
                Navigator.pushNamed(context, '/vocabulary');
              })),
            const SizedBox(width: 12),
            Expanded(child: _QuickAction(icon: Icons.quiz, label: t.get('exam'), color: AppColors.accent,
              onTap: () {
                _logger.logButton('Home', 'QuickAction:Exam');
                Navigator.pushNamed(context, '/exam');
              })),
            const SizedBox(width: 12),
            Expanded(child: _QuickAction(icon: Icons.auto_stories, label: t.get('grammar'), color: AppColors.success,
              onTap: () {
                _logger.logButton('Home', 'QuickAction:Grammar');
                Navigator.pushNamed(context, '/grammar');
              })),
          ]),
          const SizedBox(height: 20),
        ]),
      ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(elevation: 3, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16),
        child: Padding(padding: const EdgeInsets.all(16),
          child: Column(children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withAlpha(30), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 28)),
            const SizedBox(height: 10),
            Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          ]))));
  }
}

class UserProgressProvider extends ChangeNotifier {
  final _logger = AuditLogger();
  int totalWordsLearned = 0;
  int totalMinutesPracticed = 0;
  int currentStreak = 0;
  int longestStreak = 0;
  int dailyGoalWords = 20;
  DateTime? _lastPracticeDate;
  bool _loaded = false;
  bool _savePending = false;
  final Map<String, int> categoryProgress = {};
  final Map<String, bool> completedWords = {};

  bool get isLoaded => _loaded;

  Future<void> loadFromStorage() async {
    if (_loaded) {
      _logger.logGuard('Progress', 'loadFromStorage-already-loaded');
      return;
    }
    _logger.logAsyncStart('Progress', 'loadFromStorage');
    try {
      final stored = await StorageService().loadProgress();
      totalWordsLearned = stored.totalWordsLearned;
      totalMinutesPracticed = stored.totalMinutesPracticed;
      currentStreak = stored.currentStreak;
      longestStreak = stored.longestStreak;
      dailyGoalWords = stored.dailyGoalWords;
      _lastPracticeDate = stored.lastPracticeDate;
      categoryProgress.addAll(stored.categoryProgress);
      completedWords.addAll(stored.completedWords);
      _loaded = true;
      notifyListeners();
      _logger.logAsyncDone('Progress', 'loadFromStorage', data: {
        'words': totalWordsLearned, 'streak': currentStreak,
        'minutes': totalMinutesPracticed, 'completedCount': completedWords.length,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('Progress', 'loadFromStorage', e, stack);
      _logger.logRecover('Progress', 'load failure — using defaults');
      _loaded = true;
    }
  }

  Future<void> _saveToStorage() async {
    _logger.logAsyncStart('Progress', 'saveToStorage');
    try {
      await StorageService().saveProgress(_toUserProgress());
      _logger.logAsyncDone('Progress', 'saveToStorage', data: {
        'words': totalWordsLearned, 'streak': currentStreak,
      });
    } catch (e, stack) {
      _logger.logAsyncFail('Progress', 'saveToStorage', e, stack);
    }
  }

  UserProgress _toUserProgress() {
    return UserProgress(
      totalWordsLearned: totalWordsLearned,
      totalMinutesPracticed: totalMinutesPracticed,
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      lastPracticeDate: _lastPracticeDate,
      categoryProgress: Map<String, int>.from(categoryProgress),
      completedWords: Map<String, bool>.from(completedWords),
      dailyGoalWords: dailyGoalWords,
    );
  }

  double getCategoryProgress(String catId, int total) {
    if (total <= 0) {
      _logger.logZero('Progress', 'getCategoryProgress-total', data: {'catId': catId, 'total': total});
      return 0.0;
    }
    final done = categoryProgress[catId] ?? 0;
    if (done > total) {
      _logger.logOverflow('Progress', 'categoryProgress', value: done, max: total,
          data: {'catId': catId});
      return 1.0;
    }
    return done / total;
  }

  void markWordComplete(String wordId, String categoryId) {
    if (wordId.isEmpty) {
      _logger.logValidation('Progress', 'wordId', 'empty-id');
      return;
    }
    if (categoryId.isEmpty) {
      _logger.logValidation('Progress', 'categoryId', 'empty-category', data: {'wordId': wordId});
    }
    if (completedWords[wordId] == true) {
      _logger.logGuardSkip('Progress', 'word-already-complete', data: {'wordId': wordId});
      return;
    }
    final oldWords = totalWordsLearned;
    final oldStreak = currentStreak;
    completedWords[wordId] = true;
    totalWordsLearned++;
    categoryProgress[categoryId] = (categoryProgress[categoryId] ?? 0) + 1;
    totalMinutesPracticed++;
    _updateStreak();
    notifyListeners();
    _scheduleSave();
    _logger.logStateChangeInt('Progress', 'totalWordsLearned', oldWords, totalWordsLearned);
    _logger.logStateChangeInt('Progress', 'currentStreak', oldStreak, currentStreak);
    _logger.debug('Progress', 'markWordComplete', data: {
      'wordId': wordId, 'categoryId': categoryId, 'catProgress': categoryProgress[categoryId],
    });
  }

  void _scheduleSave() {
    if (_savePending) {
      _logger.logDebounce('Progress', 'scheduleSave — already pending');
      return;
    }
    _savePending = true;
    _saveToStorage().then((_) {
      _savePending = false;
    }).catchError((e, stack) {
      _savePending = false;
      _logger.logAsyncFail('Progress', 'scheduleSave-error', e, stack);
    });
  }

  void _updateStreak() {
    final now = DateTime.now();
    if (_lastPracticeDate != null) {
      final diff = now.difference(_lastPracticeDate!).inDays;
      if (diff == 0) {
        _logger.debug('Progress', 'updateStreak — same day, no change');
        return; // Same day, don't increment
      }
      if (diff == 1) {
        currentStreak++;
        _logger.debug('Progress', 'updateStreak → $currentStreak (consecutive day)');
      } else {
        _logger.logEdge('Progress', 'streak-broken', data: {
          'daysSince': diff, 'oldStreak': currentStreak,
        });
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
      _logger.debug('Progress', 'updateStreak → first day (streak started)');
    }
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
      _logger.info('Progress', 'new longest streak: $longestStreak');
    }
    _lastPracticeDate = now;
    notifyListeners();
  }

  void addPracticeTime(int minutes) {
    if (minutes <= 0) {
      _logger.logValidation('Progress', 'addPracticeTime', 'non-positive minutes',
          data: {'minutes': minutes});
      return;
    }
    if (minutes > 480) {
      _logger.logOverflow('Progress', 'addPracticeTime', value: minutes, max: 480,
          data: {'note': 'capped at 8 hours'});
      minutes = 480;
    }
    final old = totalMinutesPracticed;
    totalMinutesPracticed += minutes;
    _logger.logStateChangeInt('Progress', 'totalMinutesPracticed', old, totalMinutesPracticed);
    notifyListeners();
    _scheduleSave();
  }

  Future<void> resetAll() async {
    _logger.logDataClear('ProgressProvider');
    totalWordsLearned = 0;
    totalMinutesPracticed = 0;
    currentStreak = 0;
    longestStreak = 0;
    _lastPracticeDate = null;
    categoryProgress.clear();
    completedWords.clear();
    notifyListeners();
    try {
      await StorageService().clearAll();
      _logger.info('Progress', 'resetAll — storage cleared and in-memory reset');
    } catch (e, stack) {
      _logger.logAsyncFail('Progress', 'resetAll-storageClear', e, stack);
    }
  }

  int get totalLearned => completedWords.values.where((v) => v).length;
}
