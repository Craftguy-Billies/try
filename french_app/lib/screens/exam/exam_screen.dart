import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/data/french_vocab.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/models/exam_result.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'exam_result_screen.dart';

class ExamScreen extends StatefulWidget {
  final String level;
  final String examType;
  final List<Map<String, dynamic>> questions;

  const ExamScreen({
    super.key,
    required this.level,
    required this.examType,
    required this.questions,
  });

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  int _currentIndex = 0;
  int _selectedOptionIndex = -1;
  bool _isAnswerLocked = false;
  int _correctCount = 0;
  int _incorrectCount = 0;
  int _totalTimeSeconds = 0;
  Timer? _globalTimer;
  Timer? _questionTimer;
  Timer? _autoAdvanceTimer;
  int _questionElapsedSeconds = 0;
  final List<ExamQuestionResult> _questionResults = [];

  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _isFinished = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('ExamScreen');
    _initQuestions();
  }

  void _initQuestions() {
    try {
      if (widget.questions.isNotEmpty) {
        _questions = widget.questions;
      } else {
        _questions = _generateQuestionsInline(widget.level, widget.examType);
      }

      if (_questions.isEmpty) {
        setState(() {
          _errorMessage = 'No questions available for this level.';
          _isLoading = false;
        });
        return;
      }

      setState(() => _isLoading = false);
      _startGlobalTimer();
      _startQuestionTimer();
    } catch (e) {
      DebugLogger.logError('ExamScreen', e);
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _generateQuestionsInline(String level, String examType) {
    DebugLogger.logAction('Generating questions inline',
        details: {'level': level, 'type': examType});

    final vocab = getVocabByLevel(level);
    final minQuestions = examType == 'comprehensive' ? 20 : 10;
    final targetCount = examType == 'comprehensive' ? 30 : 20;

    if (vocab.length < minQuestions) {
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
      final bool isFrToEn = examType == 'comprehensive' ? i % 2 == 0 : true;

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

    return questions;
  }

  void _startGlobalTimer() {
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() => _totalTimeSeconds++);
      }
    });
  }

  void _startQuestionTimer() {
    _questionElapsedSeconds = 0;
    _questionTimer?.cancel();
    _questionTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      _questionElapsedSeconds++;
      if (_questionElapsedSeconds >= 30 && !_isAnswerLocked) {
        _handleTimeout();
      }
    });
  }

  void _handleTimeout() {
    if (_isAnswerLocked || !mounted) return;
    DebugLogger.logAction('Question timed out',
        details: {'index': _currentIndex, 'elapsed': _questionElapsedSeconds});

    setState(() {
      _isAnswerLocked = true;
      _selectedOptionIndex = -1;
      _incorrectCount++;
    });

    _questionResults.add(ExamQuestionResult(
      questionId: _questions[_currentIndex]['id'] as String,
      question: _questions[_currentIndex]['question'] as String,
      correctAnswer: _questions[_currentIndex]['correctAnswer'] as String,
      userAnswer: null,
      isCorrect: false,
      timeSpentSeconds: _questionElapsedSeconds,
    ));

    _autoAdvanceTimer = Timer(const Duration(milliseconds: 1500), _advanceQuestion);
  }

  void _selectOption(int index) {
    if (_isAnswerLocked || !mounted) return;

    _questionTimer?.cancel();
    final question = _questions[_currentIndex];
    final isCorrect = question['options'][index] == question['correctAnswer'];

    DebugLogger.logAction('Answer selected',
        details: {
          'questionIndex': _currentIndex,
          'selected': question['options'][index],
          'correct': isCorrect,
          'elapsed': _questionElapsedSeconds,
        });

    setState(() {
      _isAnswerLocked = true;
      _selectedOptionIndex = index;
      if (isCorrect) {
        _correctCount++;
      } else {
        _incorrectCount++;
      }
    });

    _questionResults.add(ExamQuestionResult(
      questionId: question['id'] as String,
      question: question['question'] as String,
      correctAnswer: question['correctAnswer'] as String,
      userAnswer: question['options'][index] as String,
      isCorrect: isCorrect,
      timeSpentSeconds: _questionElapsedSeconds,
    ));

    _autoAdvanceTimer = Timer(const Duration(milliseconds: 1500), _advanceQuestion);
  }

  void _advanceQuestion() {
    if (!mounted) return;
    _autoAdvanceTimer?.cancel();
    if (_currentIndex + 1 >= _questions.length) {
      _finishExam();
    } else {
      setState(() {
        _currentIndex++;
        _selectedOptionIndex = -1;
        _isAnswerLocked = false;
      });
      _startQuestionTimer();
    }
  }

  void _finishExam() {
    _globalTimer?.cancel();
    _questionTimer?.cancel();
    _autoAdvanceTimer?.cancel();

    DebugLogger.logAction('Exam finished',
        details: {
          'level': widget.level,
          'type': widget.examType,
          'correct': _correctCount,
          'incorrect': _incorrectCount,
          'totalTime': _totalTimeSeconds,
        });

    final percentage = _questions.isEmpty
        ? 0.0
        : (_correctCount / _questions.length) * 100.0;

    final result = ExamResult(
      id: 'exam_${DateTime.now().millisecondsSinceEpoch}',
      level: widget.level,
      date: DateTime.now(),
      totalQuestions: _questions.length,
      correctAnswers: _correctCount,
      incorrectAnswers: _incorrectCount,
      timeSpentSeconds: _totalTimeSeconds,
      percentageScore: percentage,
      questionResults: List.unmodifiable(_questionResults),
      examType: widget.examType,
    );

    setState(() => _isFinished = true);

    context.read<ProgressProvider>().addExamResult(result);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ExamResultScreen(examResult: result),
      ),
    );
  }

  void _showExitDialog() {
    DebugLogger.logAction('Exit exam dialog shown');
    final i18n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(i18n.translate('exam_confirm_exit_title')),
        content: Text(i18n.translate('exam_confirm_exit')),
        actions: [
          TextButton(
            onPressed: () {
              DebugLogger.logAction('Exit exam cancelled');
              Navigator.of(ctx).pop();
            },
            child: Text(i18n.cancel),
          ),
          FilledButton(
            onPressed: () {
              DebugLogger.logAction('Exit exam confirmed');
              _globalTimer?.cancel();
              _questionTimer?.cancel();
              _autoAdvanceTimer?.cancel();
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text(i18n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    _questionTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final mins = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final secs = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$mins:$secs';
  }

  String _levelLabel(AppLocalizations i18n) {
    switch (widget.level) {
      case 'A1': return i18n.translate('level_a1');
      case 'A2': return i18n.translate('level_a2');
      case 'B1': return i18n.translate('level_b1');
      case 'B2': return i18n.translate('level_b2');
      default: return widget.level;
    }
  }

  String _examTypeLabel(AppLocalizations i18n) {
    switch (widget.examType) {
      case 'vocabulary': return i18n.translate('exam_vocabulary');
      case 'grammar': return i18n.translate('exam_grammar');
      case 'comprehensive': return i18n.translate('exam_comprehensive');
      default: return widget.examType;
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(elevation: 0),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: 64, color: theme.colorScheme.error),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: Text(i18n.back),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];
    final options = List<String>.from(question['options'] as List);
    final progress = (_currentIndex + 1) / _questions.length;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _showExitDialog();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded),
            tooltip: i18n.cancel,
            onPressed: _showExitDialog,
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_levelLabel(i18n)}  ·  ${_examTypeLabel(i18n)}',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 2),
              Text(
                i18n
                    .translate('exam_question')
                    .replaceAll('{current}', '${_currentIndex + 1}')
                    .replaceAll('{total}', '${_questions.length}'),
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.timer_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    _formatTime(_totalTimeSeconds),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildProgressBar(theme, progress),
            Expanded(
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      _buildQuestionCard(theme, question),
                      const SizedBox(height: 24),
                      _buildOptionsGrid(theme, options, question),
                      const SizedBox(height: 24),
                      if (_isFinished) _buildViewResultsButton(i18n, theme),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(ThemeData theme, double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentIndex + 1} / ${_questions.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(ThemeData theme, Map<String, dynamic> question) {
    final questionText = question['question'] as String;
    final type = question['type'] as String;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.15),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              type == 'vocabulary'
                  ? 'Translate to English'
                  : 'Translate to French',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            questionText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: type == 'vocabulary' ? 36 : 30,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onPrimaryContainer,
              height: 1.25,
            ),
          ),
          if (type == 'vocabulary')
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Select the correct English translation',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(
    ThemeData theme,
    List<String> options,
    Map<String, dynamic> question,
  ) {
    final correctAnswer = question['correctAnswer'] as String;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildOptionCard(theme, 0, options, correctAnswer)),
            const SizedBox(width: 12),
            Expanded(child: _buildOptionCard(theme, 1, options, correctAnswer)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildOptionCard(theme, 2, options, correctAnswer)),
            const SizedBox(width: 12),
            Expanded(child: _buildOptionCard(theme, 3, options, correctAnswer)),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionCard(
    ThemeData theme,
    int index,
    List<String> options,
    String correctAnswer,
  ) {
    final isSelected = _selectedOptionIndex == index;
    final isCorrectOption = options[index] == correctAnswer;
    final showResult = _isAnswerLocked;

    Color? bgColor;
    Color? borderColor;
    Color textColor = theme.colorScheme.onSurface;

    if (showResult && isSelected) {
      if (isCorrectOption) {
        bgColor = const Color(0xFF00B894).withValues(alpha: 0.12);
        borderColor = const Color(0xFF00B894);
        textColor = const Color(0xFF00B894);
      } else {
        bgColor = const Color(0xFFFF6B6B).withValues(alpha: 0.12);
        borderColor = const Color(0xFFFF6B6B);
        textColor = const Color(0xFFFF6B6B);
      }
    } else if (showResult && isCorrectOption && !isSelected) {
      bgColor = const Color(0xFF00B894).withValues(alpha: 0.08);
      borderColor = const Color(0xFF00B894).withValues(alpha: 0.4);
      textColor = const Color(0xFF00B894);
    } else if (isSelected) {
      bgColor = theme.colorScheme.primary.withValues(alpha: 0.08);
      borderColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.primary;
    }

    return GestureDetector(
      onTap: showResult ? null : () => _selectOption(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 14),
        decoration: BoxDecoration(
          color: bgColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outline.withValues(alpha: 0.2),
            width: borderColor != null ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: (borderColor ?? Colors.black).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: showResult && isCorrectOption
                    ? const Color(0xFF00B894).withValues(alpha: 0.15)
                    : showResult && isSelected && !isCorrectOption
                        ? const Color(0xFFFF6B6B).withValues(alpha: 0.15)
                        : theme.colorScheme.surfaceContainerHighest,
              ),
              child: Center(
                child: showResult
                    ? Icon(
                        isCorrectOption ? Icons.check_rounded : Icons.close_rounded,
                        size: 18,
                        color: isCorrectOption
                            ? const Color(0xFF00B894)
                            : const Color(0xFFFF6B6B),
                      )
                    : Text(
                        String.fromCharCode(65 + index),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                options[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewResultsButton(AppLocalizations i18n, ThemeData theme) {
    return SizedBox(
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
          onPressed: _finishExam,
          icon: const Icon(Icons.assessment_rounded),
          label: const Text('View Results'),
        ),
      ),
    );
  }
}