import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/french_state.dart';
import '../models/vocab_item.dart';

class PracticePage extends StatefulWidget {
  const PracticePage({super.key});
  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage> {
  int? _selectedIndex;
  bool? _lastCorrect;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (frenchState.currentQuizItem == null) {
        frenchState.generateQuiz();
      }
    });
  }

  void _select(int index) {
    if (_answered) return;
    setState(() {
      _selectedIndex = index;
      _answered = true;
    });

    final correct = frenchState.currentQuizItem!;
    final chosen = frenchState.quizOptions[index];
    final isCorrect = chosen.id == correct.id;

    HapticFeedback.mediumImpact();
    _lastCorrect = isCorrect;
    frenchState.recordAnswer(correct, isCorrect);
  }

  void _nextQuestion() {
    setState(() {
      _selectedIndex = null;
      _lastCorrect = null;
      _answered = false;
    });
    frenchState.generateQuiz();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final quizItem = frenchState.currentQuizItem;
    final options = frenchState.quizOptions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: frenchState.quizStreak >= 3 ? Colors.orange : cs.onSurface.withAlpha(80), size: 20),
                Text('${frenchState.quizStreak}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: frenchState.quizStreak >= 3 ? Colors.orange : cs.onSurface.withAlpha(120))),
              ],
            ),
          ),
        ],
      ),
      body: quizItem == null || options.isEmpty
          ? _buildEmptyState(cs)
          : _buildQuiz(cs, quizItem, options),
    );
  }

  Widget _buildEmptyState(ColorScheme cs) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 72, color: Colors.amber.shade300),
          const SizedBox(height: 16),
          Text('All words mastered!', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Switch to a new category\nto continue practicing', style: TextStyle(color: cs.onSurface.withAlpha(150)), textAlign: TextAlign.center),
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () {
              final cats = frenchState.categories;
              final idx = cats.indexOf(frenchState.activeCategory);
              final next = cats[(idx + 1) % cats.length];
              frenchState.setCategory(next);
              frenchState.generateQuiz();
              setState(() {});
            },
            child: const Text('Try Another Category'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuiz(ColorScheme cs, VocabItem quizItem, List<VocabItem> options) {
    return Column(
      children: [
        // Progress header
        _buildProgressBar(cs),
        // Question
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer.withAlpha(80),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: cs.primary.withAlpha(40)),
                  ),
                  child: Column(
                    children: [
                      Text('Translate this word:', style: TextStyle(fontSize: 14, color: cs.onSurface.withAlpha(150))),
                      const SizedBox(height: 12),
                      Text(
                        quizItem.french,
                        style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.center,
                      ),
                      if (quizItem.ipa != null) ...[
                        const SizedBox(height: 4),
                        Text(quizItem.ipa!, style: TextStyle(fontSize: 15, color: cs.onSurface.withAlpha(100), fontStyle: FontStyle.italic)),
                      ],
                      if (quizItem.gender != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          quizItem.gender == 'm' ? '(masculin)' : '(féminin)',
                          style: TextStyle(fontSize: 13, color: cs.onSurface.withAlpha(120)),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...List.generate(options.length, (i) {
                  final opt = options[i];
                  final isCorrectAnswer = opt.id == quizItem.id;
                  final isSelected = _selectedIndex == i;
                  Color? bgColor;
                  Color? borderColor;

                  if (_answered) {
                    if (isCorrectAnswer) {
                      bgColor = Colors.green.withAlpha(25);
                      borderColor = Colors.green;
                    } else if (isSelected && !isCorrectAnswer) {
                      bgColor = Colors.red.withAlpha(25);
                      borderColor = Colors.red;
                    }
                  } else if (isSelected) {
                    bgColor = cs.primary.withAlpha(20);
                    borderColor = cs.primary;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: bgColor ?? cs.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: borderColor ?? cs.outline.withAlpha(60),
                          width: isSelected || (_answered && isCorrectAnswer) ? 2 : 1,
                        ),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _answered ? null : () => _select(i),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          child: Row(
                            children: [
                              Container(
                                width: 32, height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _answered && isCorrectAnswer
                                      ? Colors.green
                                      : _answered && isSelected && !isCorrectAnswer
                                          ? Colors.red
                                          : cs.surfaceContainerHighest,
                                ),
                                child: Center(
                                  child: _answered && isCorrectAnswer
                                      ? const Icon(Icons.check, size: 18, color: Colors.white)
                                      : _answered && isSelected && !isCorrectAnswer
                                          ? const Icon(Icons.close, size: 18, color: Colors.white)
                                          : Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.w600, color: cs.onSurface)),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  opt.english,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                    color: _answered && isCorrectAnswer ? Colors.green.shade800 : cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        // Bottom bar
        if (_answered)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            child: Column(
              children: [
                if (_lastCorrect == false && quizItem.example != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      '"${quizItem.example}"',
                      style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: cs.onSurface.withAlpha(150)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Question'),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar(ColorScheme cs) {
    final mastered = frenchState.masteredCount;
    final learning = frenchState.learningCount;
    final untried = frenchState.newCount;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            children: [
              _statDot('Mastered', mastered, Colors.green),
              const SizedBox(width: 16),
              _statDot('Learning', learning, Colors.orange),
              const SizedBox(width: 16),
              _statDot('New', untried, Colors.grey),
              const Spacer(),
              Text('${frenchState.quizCorrect}/${frenchState.quizTotal} correct',
                style: TextStyle(fontSize: 12, color: cs.onSurface.withAlpha(120))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              child: Row(
                children: [
                  if (mastered > 0) Flexible(flex: mastered, child: Container(color: Colors.green)),
                  if (learning > 0) Flexible(flex: learning, child: Container(color: Colors.orange)),
                  if (untried > 0) Flexible(flex: untried, child: Container(color: Colors.grey.shade300)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statDot(String label, int count, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text('$label $count', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
