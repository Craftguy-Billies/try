import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../state/french_state.dart';


import '../i18n/app_localizations.dart';
import '../models/log_entry.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage>
    with SingleTickerProviderStateMixin {
  final AppState _app = AppState();
  final FrenchState _french = FrenchState();

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: Listenable.merge([_app, _french]),
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildXpBar(theme, l10n),
              const SizedBox(height: 16),
              _buildStreakCard(theme, l10n),
              const SizedBox(height: 16),
              _buildStatsRow(theme, l10n),
              const SizedBox(height: 24),
              _buildCategoryMastery(theme, l10n),
              const SizedBox(height: 24),
              _buildStudyCalendar(theme, l10n),
              const SizedBox(height: 24),
              _buildRecentActivity(theme, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _buildXpBar(ThemeData theme, AppLocalizations l10n) {
    final level = _app.level;
    final progress = _app.levelProgress;
    final totalXP = _app.totalXP;
    final xpToNext = _app.xpToNextLevel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '$level',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${l10n.level} $level',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '$totalXP ${l10n.totalXP}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface
                                .withAlpha(140),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  l10n.xpToLevel.replaceFirst('{}', '$xpToNext').replaceFirst('{}', '${level + 1}'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(120),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(ThemeData theme, AppLocalizations l10n) {
    return Card(
      child: InkWell(
        onTap: () => HapticFeedback.lightImpact(),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseAnim,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnim.value,
                    child: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6D00), Color(0xFFFF9100)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_app.streak} ${l10n.days}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    l10n.studyStreak,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withAlpha(140),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                '🔥',
                style: TextStyle(fontSize: 32),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, AppLocalizations l10n) {
    final todayCount = _french.todayStudied;
    final wordsStudied = _french.totalWordsStudied;

    final correctTotal = _french.vocab
        .map((v) => v.correctCount)
        .fold<int>(0, (a, b) => a + b);
    final incorrectTotal = _french.vocab
        .map((v) => v.incorrectCount)
        .fold<int>(0, (a, b) => a + b);
    final total = correctTotal + incorrectTotal;
    final accuracy = total > 0
        ? (correctTotal / total * 100).toStringAsFixed(1)
        : '0.0';

    final stats = [
      (_buildStatIcon(Icons.school_rounded, const Color(0xFF1A237E)),
       '$wordsStudied', l10n.wordsLearned),
      (_buildStatIcon(Icons.verified_rounded, const Color(0xFF4CAF50)),
       '${_french.masteredWords}', l10n.mastered),
      (_buildStatIcon(
           Icons.check_circle_outline_rounded, const Color(0xFF2196F3)),
       '$accuracy%', l10n.accuracy),
      (_buildStatIcon(Icons.today_rounded, const Color(0xFFFF9800)),
       '$todayCount', l10n.today),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Column(
                children: [
                  s.$1,
                  const SizedBox(height: 8),
                  Text(
                    s.$2,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s.$3,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withAlpha(140),
                      fontSize: 11,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatIcon(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildCategoryMastery(ThemeData theme, AppLocalizations l10n) {
    final mastery = _french.categoryMastery;
    if (mastery.isEmpty) return const SizedBox.shrink();

    final entries = mastery.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.categoryBreakdown,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            ...entries.map((e) {
              final pct = (e.value * 100).toStringAsFixed(0);
              final color = _masteryColor(e.value);
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13)),
                        Text('$pct%',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: color,
                            )),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: e.value,
                        minHeight: 8,
                        backgroundColor: theme
                            .colorScheme.surfaceContainerHighest,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(color),
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

  Color _masteryColor(double value) {
    if (value >= 0.8) return const Color(0xFF4CAF50);
    if (value >= 0.5) return const Color(0xFFFFC107);
    if (value >= 0.3) return const Color(0xFFFF9800);
    return const Color(0xFFF44336);
  }

  Widget _buildStudyCalendar(ThemeData theme, AppLocalizations l10n) {
    final today = DateTime.now();
    final days = <DateTime>[];
    for (int i = 6; i >= 0; i--) {
      days.add(today.subtract(Duration(days: i)));
    }

    final dayHeaders = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    final weekdayAdjusted = <int>[];
    for (final d in days) {
      weekdayAdjusted.add(d.weekday);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.studyCalendar,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (i) {
                final d = days[i];
                final isToday = d.day == today.day &&
                    d.month == today.month &&
                    d.year == today.year;
                final hasStudied = _studiedOnDate(d);

                return Column(
                  children: [
                    Text(
                      dayHeaders[i],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface
                            .withAlpha(120),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isToday
                            ? theme.colorScheme.primary
                            : hasStudied
                                ? const Color(0xFF4CAF50)
                                    .withAlpha(30)
                                : theme
                                    .colorScheme.surfaceContainerHighest,
                        border: isToday
                            ? Border.all(
                                color: theme.colorScheme.primary,
                                width: 2)
                            : null,
                      ),
                      child: Center(
                        child: hasStudied
                            ? Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF4CAF50),
                                ),
                              )
                            : Text(
                                '${d.day}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isToday
                                      ? FontWeight.w700
                                      : FontWeight.normal,
                                  color: isToday
                                      ? Colors.white
                                      : theme
                                          .colorScheme.onSurface
                                          .withAlpha(160),
                                ),
                              ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  bool _studiedOnDate(DateTime date) {
    return _french.vocab.any((v) {
      return v.lastReviewed.year == date.year &&
          v.lastReviewed.month == date.month &&
          v.lastReviewed.day == date.day;
    });
  }

  Widget _buildRecentActivity(ThemeData theme, AppLocalizations l10n) {
    final logs = _app.logs
        .where((l) =>
            l.category == 'SRS' ||
            l.category == 'QUIZ' ||
            l.category == 'FLASHCARD')
        .toList()
        .reversed
        .take(5)
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.recentActivity,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            if (logs.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    l10n.noData,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface
                          .withAlpha(120),
                    ),
                  ),
                ),
              )
            else
              ...logs.map((log) => _buildActivityItem(theme, log)),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(ThemeData theme, LogEntry log) {
    final iconMap = {
      'SRS': Icons.repeat_rounded,
      'QUIZ': Icons.quiz_rounded,
      'FLASHCARD': Icons.style_rounded,
    };

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: log.color.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconMap[log.category] ?? Icons.circle_rounded,
              color: log.color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  log.message,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13),
                ),
                Text(
                  log.formattedTime,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface
                        .withAlpha(100),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
