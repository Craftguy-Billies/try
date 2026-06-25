import 'package:flutter/material.dart';
import '../state/french_state.dart';
import '../state/app_state.dart';
import '../widgets/confetti.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});
  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  bool _confettiTrigger = false;

  void _triggerConfetti() {
    setState(() => _confettiTrigger = true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _confettiTrigger = false);
      });
    });
  }

  Widget _buildConfettiTrigger() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _triggerConfetti();
    });
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Reset all progress',
            onPressed: () => _confirmReset(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: frenchState,
        builder: (context, _) => ConfettiWidget(
          trigger: _confettiTrigger,
          particleCount: 40,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLevelCard(cs),
                const SizedBox(height: 12),
                _buildStreakCard(cs),
                const SizedBox(height: 12),
                _buildDailyProgress(cs),
                const SizedBox(height: 12),
                _buildBreakdownCard(cs),
                const SizedBox(height: 12),
                _buildCategoryProgress(cs),
                const SizedBox(height: 12),
                _buildStudyCalendar(cs),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF6750A4), Color(0xFF9C27B0)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(frenchState.level.split(' ').first, style: const TextStyle(fontSize: 28)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(frenchState.level, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('${frenchState.totalXP} XP total', style: TextStyle(fontSize: 13, color: cs.onSurface.withAlpha(150))),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text('${frenchState.wordsLearned}', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: cs.primary)),
                    Text('words', style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(130))),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: frenchState.xpLevelProgress,
                  backgroundColor: cs.surfaceContainerHighest,
                  color: cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${frenchState.totalXP} XP', style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(130))),
                Text('Next: ${frenchState.xpToNextLevel == 0 ? 'MAX' : '+${frenchState.xpToNextLevel} XP'}',
                  style: TextStyle(fontSize: 11, color: cs.primary, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _miniStat(
              icon: Icons.local_fire_department,
              value: '${frenchState.streak}',
              label: 'Day Streak',
              color: Colors.orange,
              cs: cs,
            ),
            _divider(cs),
            _miniStat(
              icon: Icons.emoji_events,
              value: '${frenchState.streakBest}',
              label: 'Best Streak',
              color: Colors.amber,
              cs: cs,
            ),
            _divider(cs),
            _miniStat(
              icon: Icons.calendar_today,
              value: '${frenchState.weeklyStudyDays}/7',
              label: 'This Week',
              color: Colors.blue,
              cs: cs,
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat({required IconData icon, required String value, required String label, required Color color, required ColorScheme cs}) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: cs.onSurface.withAlpha(130))),
        ],
      ),
    );
  }

  Widget _divider(ColorScheme cs) {
    return Container(width: 1, height: 48, color: cs.outline.withAlpha(30));
  }

  Widget _buildDailyProgress(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Daily Goal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
                Text('${frenchState.dailyXP} / ${frenchState.dailyGoal} XP',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: frenchState.dailyProgress >= 1.0 ? Colors.green : cs.primary)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                height: 14,
                child: LinearProgressIndicator(
                  value: frenchState.dailyProgress,
                  backgroundColor: cs.surfaceContainerHighest,
                  color: frenchState.dailyProgress >= 1.0 ? Colors.green : cs.primary,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              frenchState.dailyProgress >= 1.0
                  ? '🎉 Daily goal reached!'
                  : '${frenchState.dailyGoal - frenchState.dailyXP} XP to go',
              style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(150)),
            ),
            if (frenchState.dailyProgress >= 1.0 && frenchState.dailyXP == frenchState.dailyGoal)
              _buildConfettiTrigger(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownCard(ColorScheme cs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vocabulary Breakdown', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 12),
            Row(
              children: [
                _breakdownStat('Mastered', frenchState.masteredCount, Colors.green, cs),
                _breakdownStat('Learning', frenchState.learningCount, Colors.orange, cs),
                _breakdownStat('New', frenchState.newCount, Colors.grey, cs),
              ],
            ),
            const SizedBox(height: 10),
            Text('${frenchState.overallMastery.toStringAsFixed(1)}% overall mastery',
              style: TextStyle(fontSize: 12, color: cs.onSurface.withAlpha(150))),
          ],
        ),
      ),
    );
  }

  Widget _breakdownStat(String label, int count, Color color, ColorScheme cs) {
    return Expanded(
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(130))),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(ColorScheme cs) {
    final cats = frenchState.categories;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category Progress', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 12),
            ...cats.map((cat) {
              final progress = frenchState.categoryProgress[cat] ?? 0;
              final learned = frenchState.wordsLearnedInCategory(cat);
              final total = frenchState.totalWordsInCategory(cat);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(cat, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                        Text('$learned/$total', style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(150))),
                      ],
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: SizedBox(
                        height: 6,
                        child: LinearProgressIndicator(
                          value: progress / 100,
                          backgroundColor: cs.surfaceContainerHighest,
                          color: progress >= 80 ? Colors.green : progress >= 40 ? Colors.orange : Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStudyCalendar(ColorScheme cs) {
    final days = frenchState.studyDays;
    if (days.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text('Start studying to see your calendar!',
              style: TextStyle(color: cs.onSurface.withAlpha(130))),
          ),
        ),
      );
    }

    final now = DateTime.now();
    // Show last 30 days
    final startDate = now.subtract(const Duration(days: 29));
    final weeks = <List<DateTime>>[];
    var currentWeek = <DateTime>[];

    for (int i = 0; i < 30; i++) {
      final d = DateTime(startDate.year, startDate.month, startDate.day + i);
      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
      currentWeek.add(d);
    }
    if (currentWeek.isNotEmpty) weeks.add(currentWeek);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Study Calendar', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: cs.onSurface)),
            const SizedBox(height: 12),
            // Day labels
            Row(
              children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((d) => Expanded(
                child: Center(child: Text(d, style: TextStyle(fontSize: 10, color: cs.onSurface.withAlpha(100), fontWeight: FontWeight.w600))),
              )).toList(),
            ),
            const SizedBox(height: 4),
            ...weeks.map((week) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Row(
                children: week.map((d) {
                  final studied = days.any((sd) =>
                    sd.year == d.year && sd.month == d.month && sd.day == d.day);
                  final isFuture = d.isAfter(now);
                  final isToday = d.year == now.year && d.month == now.month && d.day == now.day;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      height: 28,
                      decoration: BoxDecoration(
                        color: isFuture
                            ? Colors.transparent
                            : studied
                                ? Colors.green.shade400
                                : cs.surfaceContainerHighest.withAlpha(100),
                        borderRadius: BorderRadius.circular(5),
                        border: isToday && !studied
                            ? Border.all(color: Colors.orange, width: 1.5)
                            : null,
                      ),
                      child: isFuture ? null : Center(
                        child: Text('${d.day}', style: TextStyle(
                          fontSize: 10,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                          color: studied ? Colors.white : cs.onSurface.withAlpha(120),
                        )),
                      ),
                    ),
                  );
                }).toList(),
              ),
            )),
            const SizedBox(height: 8),
            Row(
              children: [
                _legendDot(Colors.green.shade400, 'Studied'),
                const SizedBox(width: 16),
                _legendDot(cs.surfaceContainerHighest, 'No study'),
                const SizedBox(width: 16),
                _legendDot(Colors.orange, 'Today', isBorder: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendDot(Color color, String label, {bool isBorder = false}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, height: 12,
          decoration: BoxDecoration(
            color: isBorder ? Colors.transparent : color,
            borderRadius: BorderRadius.circular(3),
            border: isBorder ? Border.all(color: color, width: 1.5) : null,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10)),
      ],
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset All Progress?'),
        content: const Text('This will clear all XP, streaks, and vocabulary progress. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              appState.log('FRENCH', 'Reset cancelled', color: Colors.grey);
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              frenchState.resetAll();
              Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All progress reset'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Reset Everything'),
          ),
        ],
      ),
    );
  }
}
