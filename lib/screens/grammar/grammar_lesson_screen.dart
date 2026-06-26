
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/grammar_lesson.dart';
import '../../services/audit_logger.dart';

class GrammarLessonScreen extends StatefulWidget {
  final GrammarLesson lesson;
  const GrammarLessonScreen({super.key, required this.lesson});
  @override
  State<GrammarLessonScreen> createState() => _GrammarLessonScreenState();
}

class _GrammarLessonScreenState extends State<GrammarLessonScreen> {
  final _logger = AuditLogger();
  int _exerciseIdx = 0;
  String? _selected;
  bool? _correct;

  @override
  void initState() {
    super.initState();
    _logger.logInit('GrammarLesson', data: {
      'lessonId': widget.lesson.id, 'exercises': widget.lesson.exercises.length,
      'sections': widget.lesson.sections.length,
    });
    _logger.logScreenView('GrammarLesson(${widget.lesson.id})');
    if (widget.lesson.sections.isEmpty) {
      _logger.logEdge('GrammarLesson', 'empty-sections', data: {'lessonId': widget.lesson.id});
    }
    if (widget.lesson.exercises.isEmpty) {
      _logger.logEdge('GrammarLesson', 'empty-exercises', data: {'lessonId': widget.lesson.id});
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logger.logLifecycle('GrammarLesson', 'didChangeDependencies', data: {
      'locale': Localizations.localeOf(context).languageCode,
    });
  }

  @override
  void dispose() {
    _logger.logDispose('GrammarLesson', data: {
      'lessonId': widget.lesson.id, 'exerciseCompleted': _exerciseIdx,
      'lastAnswer': _selected, 'correct': _correct,
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    final lesson = widget.lesson;
    return Scaffold(
      appBar: AppBar(title: Text(isFr ? lesson.titleFr : lesson.titleEn)),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ...lesson.sections.map((s) => Card(margin: const EdgeInsets.only(bottom: 12),
            child: Padding(padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(isFr ? s.headingFr : s.headingEn,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 8),
                Text(isFr ? s.contentFr : s.contentEn,
                  style: TextStyle(fontSize: 15, height: 1.6, color: AppColors.textPrimary)),
                if (s.examples != null && s.examples!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  ...s.examples!.map((e) => Padding(padding: const EdgeInsets.only(bottom: 4),
                    child: Container(width: double.infinity, padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(8)),
                      child: Text(e, style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontStyle: FontStyle.italic))))),
                ],
              ])))),
          if (lesson.exercises.isNotEmpty) ...[
            const SizedBox(height: 8),
            const Text('Exercises', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            const SizedBox(height: 12),
            if (_exerciseIdx >= lesson.exercises.length)
              Card(child: Padding(padding: const EdgeInsets.all(20),
                child: Column(children: [
                  const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                  const SizedBox(height: 8),
                  Text('All ${lesson.exercises.length} exercises completed!', textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.success)),
                ])))
            else ...[
              if (lesson.exercises[_exerciseIdx].options.isEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    Text('Exercise ${_exerciseIdx + 1}/${lesson.exercises.length} — No options available',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
                    const SizedBox(height: 12),
                    if (_exerciseIdx < lesson.exercises.length - 1)
                      TextButton(onPressed: () {
                        _logger.logButton('GrammarLesson', 'SkipExercise (empty options)', data: {'from': _exerciseIdx, 'to': _exerciseIdx + 1});
                        _logger.logEdge('GrammarLesson', 'skipping-exercise-with-empty-options', data: {'idx': _exerciseIdx});
                        setState(() { _exerciseIdx++; _selected = null; _correct = null; });
                      }, child: const Text('Skip')),
                  ]))),
              if (lesson.exercises[_exerciseIdx].options.isNotEmpty)
                Card(child: Padding(padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(isFr ? lesson.exercises[_exerciseIdx].questionFr : lesson.exercises[_exerciseIdx].questionEn,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 16),
                    ...lesson.exercises[_exerciseIdx].options.map((opt) => Padding(padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(onTap: _selected == null ? () {
                        final isCorrect = opt == lesson.exercises[_exerciseIdx].correctAnswer;
                        setState(() { _selected = opt; _correct = isCorrect; });
                        _logger.logTap('GrammarLesson', 'exercise:${_exerciseIdx}', data: {
                          'selected': opt, 'correct': isCorrect,
                        });
                        if (isCorrect) {
                          _logger.info('GrammarLesson', 'exercise $_exerciseIdx: CORRECT');
                        } else {
                          _logger.warn('GrammarLesson', 'exercise $_exerciseIdx: WRONG', data: {
                            'selected': opt, 'expected': lesson.exercises[_exerciseIdx].correctAnswer,
                          });
                        }
                      } : null, borderRadius: BorderRadius.circular(8),
                        child: Container(width: double.infinity, padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: _selected == opt ? (_correct == true ? AppColors.success.withAlpha(30) : AppColors.error.withAlpha(30)) : AppColors.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: _selected == opt ? (_correct == true ? AppColors.success : AppColors.error) : Colors.grey[300]!)),
                          child: Text(opt, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500,
                            color: _selected == opt ? (_correct == true ? AppColors.success : AppColors.error) : AppColors.textPrimary)))))),
                    if (_selected != null) ...[
                      const SizedBox(height: 12),
                      Row(children: [
                        Icon(_correct == true ? Icons.check_circle : Icons.cancel,
                          color: _correct == true ? AppColors.success : AppColors.error),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_correct == true
                          ? 'Correct!'
                          : 'Try again. Correct answer: ${lesson.exercises[_exerciseIdx].correctAnswer}',
                          style: TextStyle(color: _correct == true ? AppColors.success : AppColors.error))),
                        if (_exerciseIdx < lesson.exercises.length - 1)
                          TextButton(onPressed: () {
                            _logger.logButton('GrammarLesson', 'NextExercise', data: {'from': _exerciseIdx, 'to': _exerciseIdx + 1});
                            setState(() { _exerciseIdx++; _selected = null; _correct = null; });
                          },
                            child: const Text('Next')),
                      ]),
                    ],
                  ]))),
            ],
          ],
          const SizedBox(height: 24),
        ])),
    );
  }
}
