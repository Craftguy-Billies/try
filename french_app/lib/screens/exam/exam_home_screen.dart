import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/data/french_vocab.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/models/exam_result.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:intl/intl.dart';
import 'exam_screen.dart';
import 'exam_result_screen.dart';

class ExamHomeScreen extends StatefulWidget {
  const ExamHomeScreen({super.key});

  @override
  State<ExamHomeScreen> createState() => _ExamHomeScreenState();
}

class _ExamHomeScreenState extends State<ExamHomeScreen> {
  String _selectedLevel = 'A1';
  String _selectedExamType = 'vocabulary';

  static const _levelConfigs = [
    _LevelConfig('A1', 'A1', 'Beginner Level', Color(0xFF00B894), Icons.school_rounded),
    _LevelConfig('A2', 'A2', 'Elementary Level', Color(0xFF4A6CF7), Icons.menu_book_rounded),
    _LevelConfig('B1', 'B1', 'Intermediate Level', Color(0xFFFF6B35), Icons.auto_stories_rounded),
    _LevelConfig('B2', 'B2', 'Upper Intermediate Level', Color(0xFF9B59B6), Icons.workspace_premium_rounded),
  ];

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('ExamHomeScreen');
  }

  String _levelI18nKey(String level) {
    switch (level) {
      case 'A1': return 'level_a1';
      case 'A2': return 'level_a2';
      case 'B1': return 'level_b1';
      case 'B2': return 'level_b2';
      default: return 'level_a1';
    }
  }

  List<Map<String, dynamic>> _generateQuestions(String level, String examType) {
    final vocab = getVocabByLevel(level);
    final minQuestions = examType == 'comprehensive' ? 20 : 10;
    final targetCount = examType == 'comprehensive' ? 30 : 20;

    if (vocab.length < minQuestions) {
      DebugLogger.logAction('Exam generation failed',
          details: {'level': level, 'type': examType, 'vocabCount': vocab.length});
      throw Exception('Not enough vocabulary words for $level level. '
          'Need at least $minQuestions, but only ${vocab.length} available.');
    }

    final rng = Random();
    final shuffled = List<VocabItem>.from(vocab)..shuffle(rng);
    final selected = shuffled.take(targetCount).toList();
    final allEnglish = vocab.map((v) => v.english).toList();

    final questions = <Map<String, dynamic>>[];

    for (int i = 0; i < selected.length; i++) {
      final item = selected[i];
      final bool isFrToEn;
      if (examType == 'comprehensive') {
        isFrToEn = i % 2 == 0;
      } else {
        isFrToEn = true;
      }

      final questionText = isFrToEn ? item.french : item.english;
      final correctAnswer = isFrToEn ? item.english : item.french;

      final wrongPool = isFrToEn
          ? allEnglish.where((e) => e != item.english).toList()
          : vocab.where((v) => v.french != item.french).map((v) => v.french).toList();

      final wrongOptions = (wrongPool..shuffle(rng)).take(3).toList();
      while (wrongOptions.length < 3) {
        wrongOptions.add('---');
      }

      final options = [...wrongOptions, correctAnswer]..shuffle(rng);

      questions.add({
        'id': item.id,
        'question': questionText,
        'options': options,
        'correctAnswer': correctAnswer,
        'type': isFrToEn ? 'vocabulary' : 'translation',
      });
    }

    DebugLogger.logAction('Exam questions generated',
        details: {'level': level, 'type': examType, 'count': questions.length});
    return questions;
  }

  void _startExam() {
    DebugLogger.logAction('Start Exam tapped',
        details: {'level': _selectedLevel, 'type': _selectedExamType});

    try {
      final questions = _generateQuestions(_selectedLevel, _selectedExamType);
      DebugLogger.logNavigation('ExamHomeScreen', 'ExamScreen');
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ExamScreen(
            level: _selectedLevel,
            examType: _selectedExamType,
            questions: questions,
          ),
        ),
      );
    } catch (e) {
      DebugLogger.logError('ExamHomeScreen', e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  void _openResult(ExamResult result) {
    DebugLogger.logNavigation('ExamHomeScreen', 'ExamResultScreen');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(examResult: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final examHistory = context.watch<ProgressProvider>().examHistory;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverHeader(i18n, theme),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLevelSection(i18n, theme),
                  const SizedBox(height: 24),
                  _buildExamTypeSection(i18n, theme),
                  const SizedBox(height: 28),
                  _buildStartButton(i18n, theme),
                  const SizedBox(height: 32),
                  _buildExamHistorySection(i18n, theme, examHistory),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(AppLocalizations i18n, ThemeData theme) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 180,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1A73E8), Color(0xFF4A6CF7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.emoji_events_rounded,
                            color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        i18n.translate('exam_title'),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Test your French knowledge with DELF-style exams. Choose your level and exam type below.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSection(AppLocalizations i18n, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            i18n.translate('exam_select_level'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        _ResponsiveGrid(
          children: _levelConfigs.map((config) {
            final isSelected = _selectedLevel == config.level;
            return GestureDetector(
              onTap: () {
                setState(() => _selectedLevel = config.level);
                DebugLogger.logAction('Level selected',
                    details: {'level': config.level});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? config.color : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? config.color
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: config.color.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.25)
                            : config.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        config.icon,
                        color: isSelected ? Colors.white : config.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      i18n.translate(_levelI18nKey(config.level)),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      config.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? Colors.white.withValues(alpha: 0.8)
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExamTypeSection(AppLocalizations i18n, ThemeData theme) {
    final types = [
      _ExamType('vocabulary', i18n.translate('exam_vocabulary'),
          'Test your French vocabulary knowledge', Icons.translate_rounded),
      _ExamType('grammar', i18n.translate('exam_grammar'),
          'Test your French grammar skills', Icons.spellcheck_rounded),
      _ExamType('comprehensive', i18n.translate('exam_comprehensive'),
          'Full DELF-style comprehensive test', Icons.assignment_rounded),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            'Exam Type',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        ...types.map((type) {
          final isSelected = _selectedExamType == type.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedExamType = type.key);
                DebugLogger.logAction('Exam type selected',
                    details: {'type': type.key});
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? theme.colorScheme.primary.withValues(alpha: 0.12)
                            : theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        type.icon,
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.onPrimaryContainer
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            type.subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: (isSelected
                                      ? theme.colorScheme.onPrimaryContainer
                                      : theme.colorScheme.onSurface)
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline.withValues(alpha: 0.4),
                          width: isSelected ? 6 : 2,
                        ),
                        color: isSelected
                            ? theme.colorScheme.surface
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStartButton(AppLocalizations i18n, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            textStyle: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            elevation: 0,
          ),
          onPressed: _startExam,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.play_arrow_rounded, size: 26),
              const SizedBox(width: 8),
              Text(i18n.translate('exam_start')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExamHistorySection(
    AppLocalizations i18n,
    ThemeData theme,
    List<ExamResult> examHistory,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            i18n.translate('exam_history'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (examHistory.isEmpty)
          _buildEmptyHistory(i18n, theme)
        else
          ...examHistory.take(10).map((result) => _buildHistoryItem(i18n, theme, result)),
      ],
    );
  }

  Widget _buildEmptyHistory(AppLocalizations i18n, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.history_rounded,
            size: 48,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            i18n.translate('exam_no_history'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Complete your first exam to see results here.',
            style: TextStyle(
              fontSize: 13,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(AppLocalizations i18n, ThemeData theme, ExamResult result) {
    final dateStr = DateFormat.MMMd().format(result.date);
    final isPassed = result.isPassed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () => _openResult(result),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${i18n.translate(_levelI18nKey(result.level))} — ${_examTypeLabel(i18n, result.examType)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${result.percentageScore.toInt()}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isPassed ? const Color(0xFF00B894) : const Color(0xFFFF6B6B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: isPassed
                          ? const Color(0xFF00B894).withValues(alpha: 0.12)
                          : const Color(0xFFFF6B6B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isPassed ? i18n.passed : i18n.failed,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isPassed ? const Color(0xFF00B894) : const Color(0xFFFF6B6B),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _examTypeLabel(AppLocalizations i18n, String type) {
    switch (type) {
      case 'vocabulary': return i18n.translate('exam_vocabulary');
      case 'grammar': return i18n.translate('exam_grammar');
      case 'comprehensive': return i18n.translate('exam_comprehensive');
      default: return type;
    }
  }
}

class _LevelConfig {
  final String id;
  final String level;
  final String description;
  final Color color;
  final IconData icon;
  const _LevelConfig(this.id, this.level, this.description, this.color, this.icon);
}

class _ExamType {
  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  const _ExamType(this.key, this.title, this.subtitle, this.icon);
}

class _ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  const _ResponsiveGrid({required this.children});

  @override
  Widget build(BuildContext context) {
    final half = (children.length / 2).ceil();
    final rows = <Widget>[];
    for (int i = 0; i < half; i++) {
      final first = children[i * 2];
      final second = (i * 2 + 1 < children.length) ? children[i * 2 + 1] : null;
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: i < half - 1 ? 10 : 0),
          child: Row(
            children: [
              Expanded(child: first),
              if (second != null) ...[
                const SizedBox(width: 10),
                Expanded(child: second),
              ] else
                const Expanded(child: SizedBox()),
            ],
          ),
        ),
      );
    }
    return Column(children: rows);
  }
}
