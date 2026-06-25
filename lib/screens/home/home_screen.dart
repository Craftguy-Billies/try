
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/vocabulary_service.dart';
import '../../widgets/progress_card.dart';
import '../../widgets/category_card.dart';
import '../../widgets/app_drawer.dart';
import '../vocabulary/vocabulary_list_screen.dart';
import '../exam/exam_home_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final vocab = context.watch<VocabularyService>();
    final progress = context.watch<UserProgressProvider>();

    return Scaffold(
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
          GridView.builder(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
              childAspectRatio: 1.0, crossAxisSpacing: 12, mainAxisSpacing: 12),
            itemCount: vocab.categories.length,
            itemBuilder: (ctx, i) {
              final cat = vocab.categories[i];
              final color = Color(int.parse('FF${cat.colorHex.substring(1)}', radix: 16));
              final catProgress = progress.getCategoryProgress(cat.id, cat.wordCount);
              return CategoryCard(categoryId: cat.id, nameKey: cat.nameKey, iconName: cat.icon,
                color: color, wordCount: cat.wordCount, progress: catProgress,
                onTap: () => Navigator.push(ctx, MaterialPageRoute(
                  builder: (_) => VocabularyListScreen(categoryId: cat.id, categoryName: t.get(cat.nameKey)))));
            }),
          const SizedBox(height: 24),
          Text(t.get('quick_actions'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          const SizedBox(height: 14),
          Row(children: [
            Expanded(child: _QuickAction(icon: Icons.menu_book, label: t.get('vocabulary'), color: AppColors.primary,
              onTap: () => Navigator.pushNamed(context, '/vocabulary'))),
            const SizedBox(width: 12),
            Expanded(child: _QuickAction(icon: Icons.quiz, label: t.get('exam'), color: AppColors.accent,
              onTap: () => Navigator.pushNamed(context, '/exam'))),
            const SizedBox(width: 12),
            Expanded(child: _QuickAction(icon: Icons.auto_stories, label: t.get('grammar'), color: AppColors.success,
              onTap: () => Navigator.pushNamed(context, '/grammar'))),
          ]),
          const SizedBox(height: 20),
        ]),
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
  int totalWordsLearned = 0;
  int totalMinutesPracticed = 0;
  int currentStreak = 0;
  int dailyGoalWords = 20;
  final Map<String, int> categoryProgress = {};
  final Map<String, bool> completedWords = {};

  double getCategoryProgress(String catId, int total) {
    final done = categoryProgress[catId] ?? 0;
    return total > 0 ? done / total : 0.0;
  }

  void markWordComplete(String wordId, String categoryId) {
    if (completedWords[wordId] == true) return;
    completedWords[wordId] = true;
    totalWordsLearned++;
    categoryProgress[categoryId] = (categoryProgress[categoryId] ?? 0) + 1;
    totalMinutesPracticed++;
    updateStreak();
    notifyListeners();
  }

  void updateStreak() {
    currentStreak = (currentStreak + 1);
    notifyListeners();
  }

  void addPracticeTime(int minutes) {
    totalMinutesPracticed += minutes;
    notifyListeners();
  }
}
