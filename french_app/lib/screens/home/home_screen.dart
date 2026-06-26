import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/providers/theme_provider.dart';
import 'package:french_app/screens/learn/learn_screen.dart';
import 'package:french_app/screens/exam/exam_home_screen.dart';
import 'package:french_app/screens/learn/flashcard_screen.dart';
import 'package:french_app/screens/learn/vocab_list_screen.dart';
import 'package:french_app/screens/profile/settings_screen.dart';
import 'package:french_app/data/french_vocab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userName;

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('HomeScreen');
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name');
    if (mounted && name != null && name.isNotEmpty) {
      setState(() => _userName = name);
    }
  }

  Future<void> _onRefresh() async {
    DebugLogger.logAction('HomeScreen pull-to-refresh');
    await Future.delayed(const Duration(milliseconds: 600));
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final now = DateTime.now();
    final dateStr = DateFormat.MMMMd().format(now);

    return Consumer2<ProgressProvider, ThemeProvider>(
      builder: (context, progressProvider, themeProvider, _) {
        final progress = progressProvider.progress;
        final dailyGoal = 20;
        final dailyProgress =
            (progress.totalWordsLearned % dailyGoal) / dailyGoal;

        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🇫🇷', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                const Text(
                  'FrenchLearn',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                ),
              ],
            ),
            centerTitle: false,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: i18n.settings,
                onPressed: () {
                  DebugLogger.logNavigation('HomeScreen', 'SettingsScreen');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Greeting ──
                  _buildGreeting(i18n, dateStr),
                  const SizedBox(height: 20),

                  // ── Streak Card ──
                  _buildStreakCard(progress.currentStreak, i18n),
                  const SizedBox(height: 16),

                  // ── Stats Row ──
                  _buildStatsRow(progress, dailyProgress, i18n),
                  const SizedBox(height: 24),

                  // ── Quick Actions Heading ──
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 12),
                    child: Text(
                      i18n.home_continue_learning,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),

                  // ── Quick Action Cards (2x2 grid) ──
                  _buildQuickActionsGrid(i18n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─── Greeting ───

  Widget _buildGreeting(AppLocalizations i18n, String dateStr) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _userName != null && _userName!.isNotEmpty
                ? '${i18n.home_greeting} $_userName!'
                : i18n.home_greeting,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dateStr,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Streak Card ───

  Widget _buildStreakCard(int streak, AppLocalizations i18n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🔥', style: TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                i18n.home_streak,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$streak ${streak == 1 ? 'day' : 'days'}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Icon(
            Icons.local_fire_department_rounded,
            size: 44,
            color: Colors.white.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }

  // ─── Stats Row ───

  Widget _buildStatsRow(
    dynamic progress,
    double dailyProgress,
    AppLocalizations i18n,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.book_rounded,
            iconColor: const Color(0xFF4A6CF7),
            value: '${progress.totalWordsLearned}',
            label: i18n.home_words_learned,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildStatCard(
            icon: Icons.refresh_rounded,
            iconColor: const Color(0xFFFF6B35),
            value: '${progress.totalWordsReviewed}',
            label: i18n.home_review_due,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildDailyGoalCard(dailyProgress, i18n),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalCard(double progress, AppLocalizations i18n) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF00B894).withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.track_changes_rounded,
                size: 22, color: Color(0xFF00B894)),
          ),
          const SizedBox(height: 10),
          Text(
            '${(progress * 100).toInt()}%',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 4,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .outline
                  .withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00B894)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            i18n.home_daily_goal,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Quick Actions Grid ───

  Widget _buildQuickActionsGrid(AppLocalizations i18n) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: i18n.learn,
                subtitle: i18n.vocabulary,
                icon: Icons.menu_book_rounded,
                gradient: const [Color(0xFFFF6B35), Color(0xFFFF8C42)],
                onTap: () {
                  DebugLogger.logNavigation('HomeScreen', 'LearnScreen');
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LearnScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                title: i18n.exam,
                subtitle: i18n.home_start_exam,
                icon: Icons.star_rounded,
                gradient: const [Color(0xFF4A6CF7), Color(0xFF6B8AFF)],
                onTap: () {
                  DebugLogger.logNavigation('HomeScreen', 'ExamHomeScreen');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ExamHomeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _QuickActionCard(
                title: i18n.home_flashcards,
                subtitle: i18n.home_flashcards_subtitle,
                icon: Icons.style_rounded,
                gradient: const [Color(0xFF00B894), Color(0xFF00CEC9)],
                onTap: () {
                  final words = getAllVocab();
                  words.shuffle();
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => FlashcardScreen(words: words),
                  ));
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _QuickActionCard(
                title: i18n.home_categories,
                subtitle: i18n.home_categories_subtitle,
                icon: Icons.folder_rounded,
                gradient: const [Color(0xFF9B59B6), Color(0xFFB07CC6)],
                onTap: () {
                  DebugLogger.logNavigation('HomeScreen', 'VocabListScreen');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const VocabListScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
