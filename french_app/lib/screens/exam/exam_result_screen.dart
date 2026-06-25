import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/models/exam_result.dart';
import 'package:french_app/providers/progress_provider.dart';

class ExamResultScreen extends StatelessWidget {
  final ExamResult examResult;

  const ExamResultScreen({
    super.key,
    required this.examResult,
  });

  @override
  Widget build(BuildContext context) {
    DebugLogger.logScreenView('ExamResultScreen');

    return _ExamResultBody(examResult: examResult);
  }
}

class _ExamResultBody extends StatefulWidget {
  final ExamResult examResult;
  const _ExamResultBody({required this.examResult});

  @override
  State<_ExamResultBody> createState() => _ExamResultBodyState();
}

class _ExamResultBodyState extends State<_ExamResultBody>
    with SingleTickerProviderStateMixin {
  bool _initialized = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
    _saveResultOnce();
  }

  void _saveResultOnce() {
    if (_initialized) return;
    _initialized = true;

    Future.microtask(() {
      if (!mounted) return;
      try {
        final provider = context.read<ProgressProvider>();
        final alreadyExists = provider.examHistory.any((e) => e.id == widget.examResult.id);
        if (!alreadyExists) {
          provider.addExamResult(widget.examResult);
          DebugLogger.logAction('ExamResultScreen: saved result to provider',
              details: {'id': widget.examResult.id});
        }
      } catch (e) {
        DebugLogger.logError('ExamResultScreen', e);
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _levelLabel(AppLocalizations i18n) {
    switch (widget.examResult.level) {
      case 'A1': return i18n.translate('level_a1');
      case 'A2': return i18n.translate('level_a2');
      case 'B1': return i18n.translate('level_b1');
      case 'B2': return i18n.translate('level_b2');
      default: return widget.examResult.level;
    }
  }

  String _examTypeLabel(AppLocalizations i18n) {
    switch (widget.examResult.examType) {
      case 'vocabulary': return i18n.translate('exam_vocabulary');
      case 'grammar': return i18n.translate('exam_grammar');
      case 'comprehensive': return i18n.translate('exam_comprehensive');
      default: return widget.examResult.examType;
    }
  }

  AppLocalizations get i18n => AppLocalizations.of(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = widget.examResult;
    final isPassed = result.isPassed;
    final grade = result.grade;
    final percentage = result.percentageScore;

    return Scaffold(
      body: Column(
        children: [
          _buildResultHeader(theme, isPassed, percentage, grade, result.date),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                children: [
                  _buildStatsRow(theme, result),
                  const SizedBox(height: 24),
                  _buildReviewSection(theme, result),
                  const SizedBox(height: 28),
                  _buildActionButtons(theme),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultHeader(
    ThemeData theme,
    bool isPassed,
    double percentage,
    String grade,
    DateTime date,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isPassed
              ? [const Color(0xFF00B894), const Color(0xFF00CEC9)]
              : [const Color(0xFFFF6B35), const Color(0xFFFF8C42)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: (isPassed ? const Color(0xFF00B894) : const Color(0xFFFF6B35))
                .withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 48, 24, 36),
          child: Column(
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: _buildScoreCircle(percentage, grade),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPassed ? Icons.emoji_events_rounded : Icons.fitness_center_rounded,
                    color: Colors.white.withValues(alpha: 0.9),
                    size: 28,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isPassed ? i18n.congratulations : i18n.keepGoing,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                isPassed
                    ? 'You passed the ${_examTypeLabel(i18n)} at ${_levelLabel(i18n)}!'
                    : 'Keep practicing to improve your ${_examTypeLabel(i18n)} skills.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                DateFormat.yMMMMd().format(date),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(double percentage, String grade) {
    return SizedBox(
      width: 130,
      height: 130,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 130,
            height: 130,
            child: CircularProgressIndicator(
              value: percentage / 100,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${percentage.toInt()}%',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  i18n.translate('exam_grade').replaceAll('{grade}', grade),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ThemeData theme, ExamResult result) {
    final mins = result.timeSpentSeconds ~/ 60;
    final secs = (result.timeSpentSeconds % 60).toString().padLeft(2, '0');
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.check_circle_rounded,
            '${result.correctAnswers}',
            i18n.translate('exam_correct').split(':').first,
            const Color(0xFF00B894),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.cancel_rounded,
            '${result.incorrectAnswers}',
            i18n.translate('exam_incorrect').split(':').first,
            const Color(0xFFFF6B6B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            theme,
            Icons.timer_rounded,
            '${mins}m ${secs}s',
            i18n.translate('exam_time_spent').split(':').first,
            const Color(0xFF4A6CF7),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    ThemeData theme,
    IconData icon,
    String value,
    String label,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewSection(ThemeData theme, ExamResult result) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            i18n.translate('exam_review_answers'),
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        ...result.questionResults.asMap().entries.map(
              (entry) => _buildReviewItem(theme, entry.key + 1, entry.value),
            ),
      ],
    );
  }

  Widget _buildReviewItem(ThemeData theme, int number, ExamQuestionResult qr) {
    final isCorrect = qr.isCorrect;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCorrect
                ? const Color(0xFF00B894).withValues(alpha: 0.2)
                : const Color(0xFFFF6B6B).withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCorrect
                    ? const Color(0xFF00B894).withValues(alpha: 0.12)
                    : const Color(0xFFFF6B6B).withValues(alpha: 0.12),
              ),
              child: Center(
                child: Icon(
                  isCorrect ? Icons.check_rounded : Icons.close_rounded,
                  size: 16,
                  color: isCorrect ? const Color(0xFF00B894) : const Color(0xFFFF6B6B),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '#$number',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        qr.question,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  _buildAnswerLine(
                    theme,
                    'Your answer: ',
                    qr.userAnswer ?? '(timed out)',
                    isCorrect: isCorrect,
                  ),
                  if (!isCorrect)
                    _buildAnswerLine(
                      theme,
                      'Correct: ',
                      qr.correctAnswer,
                      isCorrect: true,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerLine(
    ThemeData theme,
    String label,
    String answer, {
    required bool isCorrect,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          Expanded(
            child: Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isCorrect ? const Color(0xFF00B894) : const Color(0xFFFF6B6B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              onPressed: () {
                DebugLogger.logAction('Try Again tapped',
                    details: {'level': widget.examResult.level});
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(i18n.tryAgain),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              side: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              DebugLogger.logAction('Back to Home tapped');
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            icon: const Icon(Icons.home_rounded),
            label: Text(i18n.translate('exam_back_to_home')),
          ),
        ),
      ],
    );
  }
}