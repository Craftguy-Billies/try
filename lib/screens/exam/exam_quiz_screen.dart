
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../models/exam_question.dart';
import '../../services/audit_logger.dart';
import '../../services/exam_service.dart';
import '../home/home_screen.dart';
import 'exam_result_screen.dart';

class ExamQuizScreen extends StatefulWidget {
  final ExamConfig config;
  const ExamQuizScreen({super.key, required this.config});
  @override
  State<ExamQuizScreen> createState() => _ExamQuizScreenState();
}

class _ExamQuizScreenState extends State<ExamQuizScreen> {
  final _logger = AuditLogger();
  late List<ExamQuestion> _questions;
  int _current = 0;
  final Map<int, String> _answers = {};
  int _secondsLeft = 0;
  Timer? _timer;
  bool _submitted = false;
  int _tickCount = 0;

  @override
  void initState() {
    super.initState();
    _logger.logInit('ExamQuiz', data: {
      'level': widget.config.level, 'questionCount': widget.config.questionCount,
      'timeMin': widget.config.timeMinutes, 'passScore': widget.config.passingScore,
    });
    _logger.logScreenView('ExamQuiz(${widget.config.level})');

    _questions = ExamService().generateExam(widget.config);
    _secondsLeft = widget.config.timeMinutes * 60;

    _logger.logTimerStart('ExamQuiz', seconds: _secondsLeft);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tickCount++;
      setState(() {
        _secondsLeft--;
        if (_secondsLeft <= 0) {
          _logger.logTimerExpire('ExamQuiz', data: {'tickCount': _tickCount});
          _submit(reason: 'timeout');
        }
      });
      if (_secondsLeft > 0 && _secondsLeft % 30 == 0) {
        _logger.logTimerTick('ExamQuiz', _secondsLeft);
      }
    });
  }

  @override
  void dispose() {
    _logger.logDispose('ExamQuiz', data: {
      'submitted': _submitted, 'currentQ': _current, 'secondsLeft': _secondsLeft,
    });
    if (!_submitted) _logger.logEdge('ExamQuiz', 'disposed-without-submit');
    _timer?.cancel();
    super.dispose();
  }

  void _submit({String reason = 'user'}) {
    if (_submitted) {
      _logger.logGuard('ExamQuiz', 'double-submit', data: {'reason': reason});
      return;
    }
    _submitted = true;
    _logger.logTimerCancel('ExamQuiz');
    _timer?.cancel();

    int correct = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i].correctAnswer) correct++;
    }
    final score = _questions.isNotEmpty ? (correct * 100 / _questions.length).round() : 0;
    final unanswered = _questions.length - _answers.length;

    _logger.logUserAction('Exam submitted', p: {
      'level': widget.config.level, 'score': score, 'correct': correct,
      'total': _questions.length, 'unanswered': unanswered, 'reason': reason,
      'timeUsed_s': (widget.config.timeMinutes * 60) - _secondsLeft,
    });

    final progress = context.read<UserProgressProvider>();
    progress.addPracticeTime(widget.config.timeMinutes);

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (_) => ExamResultScreen(score: score, total: _questions.length,
        correct: correct, config: widget.config, questions: _questions, answers: _answers)));
  }

  void _showQuitDialog() {
    _logger.logDialogShow('QuitConfirm', 'ExamQuiz', data: {
      'currentQ': _current, 'answered': _answers.length, 'total': _questions.length,
    });
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: Text(Translations(Localizations.localeOf(ctx).languageCode).get('cancel')),
      content: const Text('Are you sure you want to quit? Your progress will be lost.'),
      actions: [
        TextButton(onPressed: () {
          _logger.logDialogResult('QuitConfirm', 'Continue');
          Navigator.pop(ctx);
        }, child: const Text('Continue')),
        TextButton(onPressed: () {
          _logger.logDialogResult('QuitConfirm', 'Quit', data: {
            'answered': _answers.length, 'questionsSoFar': _current + 1,
          });
          _logger.logEdge('ExamQuiz', 'user-quit-early', data: {
            'progress': '${_current + 1}/${_questions.length}', 'answered': _answers.length,
          });
          Navigator.pop(ctx);
          _timer?.cancel();
          _logger.logTimerCancel('ExamQuiz');
          Navigator.pop(context);
        },
          child: const Text('Quit', style: TextStyle(color: AppColors.error))),
      ]));
  }

  void _selectAnswer(String opt) {
    if (_submitted) return;
    final prev = _answers[_current];
    _logger.logTap('ExamQuiz', 'answer:${_current}', data: {
      'prev': prev, 'selected': opt, 'isChange': prev != null && prev != opt,
    });
    setState(() => _answers[_current] = opt);
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    if (_questions.isEmpty) {
      _logger.logEdge('ExamQuiz', 'empty-questions');
      return Scaffold(appBar: AppBar(), body: Center(child: Text(t.get('no_data'))));
    }
    if (_current >= _questions.length) {
      _logger.logEdge('ExamQuiz', 'index-out-of-bounds', data: {'current': _current, 'total': _questions.length});
      _submit(reason: 'index_oob');
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final q = _questions[_current];
    final mins = _secondsLeft ~/ 60;
    final secs = (_secondsLeft % 60).toString().padLeft(2, '0');

    return PopScope(canPop: false, onPopInvokedWithResult: (didPop, _) {
      if (!didPop) {
        _logger.logBackPress('ExamQuiz');
        _showQuitDialog();
      }
    }, child: Scaffold(
      appBar: AppBar(title: Text('${t.get('exam')} - ${widget.config.level}'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: _showQuitDialog),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 16),
            child: Row(children: [
              const Icon(Icons.timer, color: Colors.white, size: 20),
              const SizedBox(width: 4),
              Text('$mins:$secs', style: TextStyle(color: _secondsLeft < 60 ? AppColors.accent : Colors.white,
                fontWeight: FontWeight.w700, fontSize: 16)),
            ])),
        ]),
      body: Column(children: [
        LinearProgressIndicator(value: (_current + 1) / _questions.length, backgroundColor: AppColors.primary.withAlpha(20),
          color: AppColors.primary, minHeight: 4),
        Expanded(child: SingleChildScrollView(padding: const EdgeInsets.all(20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(20)),
              child: Text('Question ${_current + 1}/${_questions.length}',
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
            const SizedBox(height: 20),
            Text(q.prompt, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 24),
            ...q.options.map((opt) => Padding(padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(onTap: () => _selectAnswer(opt),
                borderRadius: BorderRadius.circular(12),
                child: Container(width: double.infinity, padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _answers[_current] == opt ? AppColors.primary.withAlpha(30) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: _answers[_current] == opt ? AppColors.primary : Colors.grey[300]!, width: 2)),
                  child: Row(children: [
                    Container(width: 28, height: 28, alignment: Alignment.center,
                      decoration: BoxDecoration(shape: BoxShape.circle,
                        color: _answers[_current] == opt ? AppColors.primary : Colors.grey[200]),
                      child: _answers[_current] == opt
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : Text(opt[0], style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600))),
                    const SizedBox(width: 12),
                    Expanded(child: Text(opt, style: TextStyle(fontSize: 16,
                      color: _answers[_current] == opt ? AppColors.primary : AppColors.textPrimary))),
                  ])),
              ))),
            const SizedBox(height: 24),
            Row(children: [
              if (_current > 0) TextButton.icon(onPressed: () {
                _logger.logButton('ExamQuiz', 'Back', data: {'from': _current, 'to': _current - 1});
                setState(() => _current--);
              },
                icon: const Icon(Icons.arrow_back), label: const Text('Back'))
              else const Spacer(),
              const Spacer(),
              if (_current < _questions.length - 1)
                ElevatedButton(onPressed: () {
                  _logger.logButton('ExamQuiz', 'Next', data: {'from': _current, 'to': _current + 1});
                  setState(() => _current++);
                },
                  child: Text(t.get('next')))
              else
                ElevatedButton(onPressed: () => _submit(reason: 'user'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
                  child: Text(t.get('save'))),
            ]),
          ]))),
      ]),
    ));
  }
}
