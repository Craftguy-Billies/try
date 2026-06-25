import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/french_state.dart';


import '../i18n/app_localizations.dart';

class ExamPage extends StatefulWidget {
  const ExamPage({super.key});

  @override
  State<ExamPage> createState() => _ExamPageState();
}

enum _ExamPhase { setup, running, complete }

class _ExamPageState extends State<ExamPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final FrenchState _french = FrenchState();

  _ExamPhase _phase = _ExamPhase.setup;
  Timer? _timer;
  bool _isAnswering = false;
  bool _wasPaused = false;

  String _selectedLevel = 'A1';
  int _selectedTime = 5;
  int _selectedCount = 10;

  int _totalTime = 300;
  int _timeUsed = 0;
  final List<_AnswerRecord> _answers = [];

  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  static const _timeOptions = [3, 5, 10];
  static const _countOptions = [10, 20, 30];
  static const _levels = ['A1', 'A2', 'B1'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_phase != _ExamPhase.running) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _timer?.cancel();
      _wasPaused = true;
    } else if (state == AppLifecycleState.resumed && _wasPaused) {
      _wasPaused = false;
      _startTimer();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _pulseCtrl.dispose();
    super.dispose();
  }

  int get _timeRemaining => _french.examTimeRemaining;

  void _startExam() {
    _totalTime = _selectedTime * 60;
    _timeUsed = 0;
    _answers.clear();
    _french.startExam(
      level: _selectedLevel,
      timeSeconds: _totalTime,
      count: _selectedCount,
    );
    if (_french.quizTotal == 0) {
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noData)),
      );
      return;
    }
    setState(() => _phase = _ExamPhase.running);
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _french.tickExamTimer();
      _timeUsed++;
      if (_french.quizComplete) {
        _timer?.cancel();
        _recordUnanswered();
        setState(() => _phase = _ExamPhase.complete);
        HapticFeedback.heavyImpact();
      }
      setState(() {});
    });
  }

  void _recordUnanswered() {
    for (int i = _answers.length; i < _french.quizTotal; i++) {
      _answers.add(const _AnswerRecord(
          question: '', correctAnswer: '', chosenAnswer: '⏱', isCorrect: false));
    }
  }

  void _answerQuestion(String chosen) {
    if (_isAnswering || _french.quizComplete) return;
    final item = _french.currentQuizItem;
    if (item == null) return;

    _isAnswering = true;
    final correct = chosen == item.word.english;
    _answers.add(_AnswerRecord(
      question: item.word.french,
      correctAnswer: item.word.english,
      chosenAnswer: chosen,
      isCorrect: correct,
    ));
    _french.answerQuiz(correct);

    if (_french.quizComplete) {
      _timer?.cancel();
      setState(() => _phase = _ExamPhase.complete);
      HapticFeedback.heavyImpact();
    }
    setState(() {});
    _isAnswering = false;
  }

  void _resetExam() {
    _timer?.cancel();
    _french.resetQuiz();
    setState(() {
      _phase = _ExamPhase.setup;
      _answers.clear();
      _timeUsed = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    switch (_phase) {
      case _ExamPhase.setup:
        return _buildSetup(theme, l10n);
      case _ExamPhase.running:
        return _buildRunning(theme, l10n);
      case _ExamPhase.complete:
        return _buildComplete(theme, l10n);
    }
  }

  Widget _buildSetup(ThemeData theme, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              Icons.school_rounded, l10n.selectExamLevel, theme),
          const SizedBox(height: 12),
          _buildLevelChips(theme),
          const SizedBox(height: 28),
          _buildSectionHeader(
              Icons.timer_rounded, '${l10n.timeRemaining} (${l10n.minutes})',
              theme),
          const SizedBox(height: 12),
          _buildOptionChips(
              _timeOptions, _selectedTime, (v) => setState(() => _selectedTime = v),
              (v) => '$v ${l10n.minutes}'),
          const SizedBox(height: 28),
          _buildSectionHeader(
              Icons.quiz_rounded, l10n.question, theme),
          const SizedBox(height: 12),
          _buildOptionChips(
              _countOptions, _selectedCount, (v) => setState(() => _selectedCount = v),
              (v) => '$v'),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _startExam,
              icon: const Icon(Icons.play_arrow_rounded, size: 28),
              label: Text(l10n.startExam,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
      IconData icon, String title, ThemeData theme) {
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildLevelChips(ThemeData theme) {
    final colors = {
      'A1': const Color(0xFF4CAF50),
      'A2': const Color(0xFFFF9800),
      'B1': const Color(0xFFE91E63),
    };

    return Row(
      children: _levels.map((l) {
        final selected = _selectedLevel == l;
        final color = colors[l]!;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ChoiceChip(
            label: Text(l,
                style: TextStyle(
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? Colors.white : theme.colorScheme.onSurface,
                  fontSize: 16,
                )),
            selected: selected,
            onSelected: (_) => setState(() => _selectedLevel = l),
            selectedColor: color,
            backgroundColor:
                theme.colorScheme.surfaceContainerHighest.withAlpha(100),
            side: BorderSide.none,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildOptionChips(List<int> options, int selected,
      ValueChanged<int> onSelect, String Function(int) label) {
    return Row(
      children: options.map((o) {
        final isSel = selected == o;
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: ChoiceChip(
            label: Text(label(o),
                style: TextStyle(
                  fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                  color: isSel ? Colors.white : null,
                )),
            selected: isSel,
            onSelected: (_) => onSelect(o),
            selectedColor: const Color(0xFF1A237E),
            side: BorderSide.none,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRunning(ThemeData theme, AppLocalizations l10n) {
    final item = _french.currentQuizItem;
    final progress =
        _french.quizTotal > 0 ? _french.quizIndex / _french.quizTotal : 0.0;

    if (item == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(l10n.loading,
                style: theme.textTheme.bodyLarge),
          ],
        ),
      );
    }

    final options = _french.generateOptions(item);
    final isLowTime = _timeRemaining <= 60;

    return Column(
      children: [
        _buildTimerBar(theme, l10n, isLowTime),
        _buildProgressBar(theme, progress),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${l10n.question} ${_french.quizIndex + 1}/${_french.quizTotal}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(150),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 28, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer
                            .withAlpha(80),
                        theme.colorScheme.primaryContainer
                            .withAlpha(30),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.primary.withAlpha(40),
                    ),
                  ),
                  child: Text(
                    item.word.french,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(l10n.selectCorrect,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                    )),
                const SizedBox(height: 16),
                ...options.map((opt) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _answerQuestion(opt);
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: theme.colorScheme.outline
                                .withAlpha(80),
                          ),
                          backgroundColor: theme
                              .colorScheme.surfaceContainerHighest
                              .withAlpha(50),
                        ),
                        child: Text(
                          opt,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimerBar(
      ThemeData theme, AppLocalizations l10n, bool isLowTime) {
    final mins = _timeRemaining ~/ 60;
    final secs = _timeRemaining % 60;
    final timeStr =
        '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: isLowTime
          ? const Color(0xFFE53935).withAlpha(20)
          : theme.colorScheme.surfaceContainerHighest.withAlpha(60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _pulseAnim,
            builder: (context, child) {
              if (!isLowTime) {
                return child!;
              }
              return Transform.scale(
                scale: _pulseAnim.value,
                child: child,
              );
            },
            child: Icon(
              Icons.timer_rounded,
              color: isLowTime
                  ? const Color(0xFFE53935)
                  : theme.colorScheme.onSurface.withAlpha(180),
              size: 22,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              fontFeatures: const [FontFeature.tabularFigures()],
              color: isLowTime
                  ? const Color(0xFFE53935)
                  : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    return ClipRRect(
      child: LinearProgressIndicator(
        value: progress,
        minHeight: 4,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        valueColor:
            AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
      ),
    );
  }

  Widget _buildComplete(ThemeData theme, AppLocalizations l10n) {
    final correct = _french.quizCorrect;
    final total = _french.quizTotal;
    final pct = total > 0 ? (correct / total * 100).round() : 0;
    final passed = pct >= 70;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildScoreRing(theme, l10n, pct, passed),
          const SizedBox(height: 16),
          Text(
            passed ? l10n.passed : l10n.keepPracticing,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: passed
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFFFF9800),
            ),
          ),
          const SizedBox(height: 32),
          _buildScoreBreakdown(theme, l10n, correct, total, pct),
          const SizedBox(height: 20),
          if (_answers.any((a) => !a.isCorrect)) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showMistakes(theme, l10n),
                icon: const Icon(Icons.replay_rounded),
                label: Text(l10n.reviewMistakes,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: _resetExam,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(l10n.tryAgain,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600)),
                  style: FilledButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetExam,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  style: OutlinedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScoreRing(ThemeData theme, AppLocalizations l10n, int pct, bool passed) {
    final color =
        passed ? const Color(0xFF4CAF50) : const Color(0xFFFF9800);
    return SizedBox(
      width: 160,
      height: 160,
      child: CustomPaint(
        painter: _RingPainter(
          progress: pct / 100,
          color: color,
          bgColor: theme.colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
              Text(
                l10n.scoreCapitalized,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color:
                      theme.colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown(ThemeData theme, AppLocalizations l10n,
      int correct, int total, int pct) {
    final incorrect = total - correct;
    final mins = _timeUsed ~/ 60;
    final secs = _timeUsed % 60;
    final timeStr =
        '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildBreakdownRow(
                theme, l10n.correct, '$correct/$total', const Color(0xFF4CAF50)),
            const SizedBox(height: 12),
            _buildBreakdownRow(theme, l10n.incorrect, '$incorrect/$total',
                const Color(0xFFF44336)),
            const SizedBox(height: 12),
            _buildBreakdownRow(theme, l10n.percentageCapitalized, '$pct%',
                theme.colorScheme.primary),
            const SizedBox(height: 12),
            _buildBreakdownRow(
                theme, l10n.timeUsed, timeStr, const Color(0xFF607D8B)),
          ],
        ),
      ),
    );
  }

  Widget _buildBreakdownRow(
      ThemeData theme, String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(160),
            )),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: color,
            )),
      ],
    );
  }

  void _showMistakes(ThemeData theme, AppLocalizations l10n) {
    final mistakes =
        _answers.where((a) => !a.isCorrect).toList();
    if (mistakes.isEmpty) return;

    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.3,
          expand: false,
          builder: (ctx, scrollCtrl) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                children: [
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onSurface.withAlpha(40),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${l10n.reviewMistakes} (${mistakes.length})',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollCtrl,
                      itemCount: mistakes.length,
                      separatorBuilder: (_, __) =>
                          const Divider(height: 1),
                      itemBuilder: (ctx, i) {
                        final m = mistakes[i];
                        final isTimeout =
                            m.chosenAnswer == '⏱';
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            isTimeout
                                ? Icons.timer_off_rounded
                                : Icons.close_rounded,
                            color: const Color(0xFFF44336),
                          ),
                          title: Text(m.question,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              )),
                          subtitle: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              if (isTimeout)
                                Text(l10n.timeRanOut,
                                    style: const TextStyle(
                                        color: Color(0xFFF44336),
                                        fontStyle:
                                            FontStyle.italic))
                              else
                                Text(
                                    '${l10n.yourAnswer} ${m.chosenAnswer}',
                                    style: const TextStyle(
                                        color: Color(0xFFF44336))),
                              Text(
                                '${l10n.correctAnswer} ${m.correctAnswer}',
                                style: const TextStyle(
                                  color: Color(0xFF4CAF50),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AnswerRecord {
  final String question;
  final String correctAnswer;
  final String chosenAnswer;
  final bool isCorrect;

  const _AnswerRecord({
    required this.question,
    required this.correctAnswer,
    required this.chosenAnswer,
    required this.isCorrect,
  });
}

class _RingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color bgColor;

  _RingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    const strokeWidth = 12.0;

    final bgPaint = Paint()
      ..color = bgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..shader = SweepGradient(
        colors: [color, color.withAlpha(180)],
        endAngle: math.pi * 2 * progress,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        color != oldDelegate.color;
  }
}
