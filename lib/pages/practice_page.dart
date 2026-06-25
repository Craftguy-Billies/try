import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../state/french_state.dart';
import '../i18n/app_localizations.dart';


class PracticePage extends StatefulWidget {
  const PracticePage({super.key});

  @override
  State<PracticePage> createState() => _PracticePageState();
}

class _PracticePageState extends State<PracticePage>
    with SingleTickerProviderStateMixin {
  final FrenchState _french = FrenchState();
  final AppState _app = AppState();

  String? _selectedCategory;
  int _questionCount = 10;
  bool _quizStarted = false;

  int? _selectedAnswerIndex;
  bool? _lastAnswerCorrect;
  bool _isTransitioning = false;

  late final AnimationController _scoreAnimController;
  late final Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _scoreAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scoreAnimation = CurvedAnimation(
      parent: _scoreAnimController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _scoreAnimController.dispose();
    super.dispose();
  }

  List<String> get _categories {
    final cats = <String>{};
    for (final v in _french.vocab) {
      cats.add(v.word.category);
    }
    return cats.toList()..sort();
  }

  void _startQuiz() {
    _french.startQuiz(
      count: _questionCount,
      category: _selectedCategory,
      mode: 'practice',
    );
    setState(() {
      _quizStarted = true;
      _selectedAnswerIndex = null;
      _lastAnswerCorrect = null;
    });
    HapticFeedback.mediumImpact();
  }

  void _resetQuiz() {
    _french.resetQuiz();
    setState(() {
      _quizStarted = false;
      _selectedAnswerIndex = null;
      _lastAnswerCorrect = null;
    });
  }

  void _selectAnswer(int index, String answer) {
    if (_isTransitioning || _selectedAnswerIndex != null) return;

    final item = _french.currentQuizItem;
    if (item == null) return;

    final correct = answer == item.word.english;
    setState(() {
      _selectedAnswerIndex = index;
      _lastAnswerCorrect = correct;
    });

    if (correct) {
      HapticFeedback.heavyImpact();
      _scoreAnimController.forward(from: 0);
    } else {
      HapticFeedback.vibrate();
    }

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      _french.answerQuiz(correct);
      setState(() {
        _selectedAnswerIndex = null;
        _lastAnswerCorrect = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: _french,
      builder: (context, _) {
        if (!_quizStarted) {
          return _buildStartScreen(l10n, theme);
        }
        if (_french.quizComplete) {
          return _buildCompleteScreen(l10n, theme);
        }
        return _buildQuizScreen(l10n, theme);
      },
    );
  }

  Widget _buildStartScreen(AppLocalizations l10n, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withAlpha(180),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(50),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Center(
              child: Text('🧠', style: TextStyle(fontSize: 44)),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            l10n.practiceMode,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.selectCorrect,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(160),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l10n.categories,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(120),
              ),
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedCategory,
                hint: Text(l10n.all),
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(l10n.all),
                  ),
                  ..._categories.map((cat) => DropdownMenuItem<String>(
                        value: cat,
                        child: Text(cat),
                      )),
                ],
                onChanged: (val) => setState(() => _selectedCategory = val),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '${l10n.question}: $_questionCount',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [5, 10, 15, 20].map((count) {
              final selected = _questionCount == count;
              return ChoiceChip(
                label: Text('$count'),
                selected: selected,
                onSelected: (_) => setState(() => _questionCount = count),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: _startQuiz,
            icon: const Icon(Icons.play_arrow_rounded),
            label: Text(l10n.startLearning),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Quick stats
          _buildQuickStats(l10n, theme),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppLocalizations l10n, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(60),
        ),
      ),
      child: Column(
        children: [
          Text(
            l10n.categoryBreakdown,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _StatItem(
                icon: Icons.book,
                label: l10n.wordsLearned,
                value: '${_french.totalWordsStudied}',
                theme: theme,
              ),
              _StatItem(
                icon: Icons.star,
                label: l10n.mastered,
                value: '${_french.masteredWords}',
                theme: theme,
              ),
              _StatItem(
                icon: Icons.trending_up,
                label: l10n.accuracy,
                value: '${(_french.averageMastery * 100).toInt()}%',
                theme: theme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuizScreen(AppLocalizations l10n, ThemeData theme) {
    final item = _french.currentQuizItem;
    if (item == null) return const SizedBox.shrink();

    final options = _french.generateOptions(item);
    final correctAnswer = item.word.english;
    final progress = (_french.quizIndex + 1) / _french.quizTotal;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Progress bar + score
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_french.quizIndex + 1}/${_french.quizTotal}',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withAlpha(180),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, size: 14, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 4),
                    Text(
                      '${_french.quizCorrect}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // The question word
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withAlpha(15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withAlpha(15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.word.partOfSpeech,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  item.word.french,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    height: 1.3,
                  ),
                ),
                if (item.word.example != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    item.word.example!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 28),
          // Options
          ...List.generate(options.length, (index) {
            final option = options[index];
            final isCorrectOption = option == correctAnswer;
            Color? bgColor;
            Color? borderColor;
            IconData? trailingIcon;

            if (_selectedAnswerIndex != null) {
              if (index == _selectedAnswerIndex && !isCorrectOption) {
                bgColor = const Color(0xFFED2939).withAlpha(20);
                borderColor = const Color(0xFFED2939);
                trailingIcon = Icons.close;
              }
              if (isCorrectOption) {
                bgColor = const Color(0xFF2E7D32).withAlpha(20);
                borderColor = const Color(0xFF2E7D32);
                trailingIcon = Icons.check;
              }
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: bgColor ?? theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: borderColor ??
                        theme.colorScheme.outlineVariant.withAlpha(100),
                    width: borderColor != null ? 2 : 1,
                  ),
                  boxShadow: (_selectedAnswerIndex == null)
                      ? [
                          BoxShadow(
                            color: theme.colorScheme.shadow.withAlpha(8),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _selectedAnswerIndex == null
                        ? () => _selectAnswer(index, option)
                        : null,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _selectedAnswerIndex != null
                                  ? Colors.transparent
                                  : theme.colorScheme.primary.withAlpha(20),
                              border: Border.all(
                                color: _selectedAnswerIndex != null && !isCorrectOption && index == _selectedAnswerIndex
                                    ? const Color(0xFFED2939)
                                    : _selectedAnswerIndex != null && isCorrectOption
                                        ? const Color(0xFF2E7D32)
                                        : theme.colorScheme.primary.withAlpha(60),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                String.fromCharCode(65 + index),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: _selectedAnswerIndex != null && isCorrectOption
                                      ? const Color(0xFF2E7D32)
                                      : theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              option,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          if (trailingIcon != null)
                            Icon(
                              trailingIcon,
                              color: borderColor,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: _resetQuiz,
            icon: const Icon(Icons.close, size: 18),
            label: Text(l10n.cancel),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompleteScreen(AppLocalizations l10n, ThemeData theme) {
    final correct = _french.quizCorrect;
    final total = _french.quizTotal;
    final score = total > 0 ? correct / total : 0.0;
    final percentage = (score * 100).toInt();

    final Color scoreColor;
    final String emoji;
    if (score >= 0.8) {
      scoreColor = const Color(0xFF2E7D32);
      emoji = '🏆';
    } else if (score >= 0.5) {
      scoreColor = const Color(0xFFF57F17);
      emoji = '👍';
    } else {
      scoreColor = const Color(0xFFED2939);
      emoji = '💪';
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Text(emoji, style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            l10n.quizComplete,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Score ring
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 160,
                  height: 160,
                  child: CircularProgressIndicator(
                    value: score,
                    strokeWidth: 12,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    color: scoreColor,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: scoreColor,
                      ),
                    ),
                    Text(
                      '$correct/$total',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withAlpha(150),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
              border: Border.all(
                color: theme.colorScheme.outlineVariant.withAlpha(60),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  icon: Icons.check_circle,
                  label: l10n.correct,
                  value: '$correct',
                  color: const Color(0xFF2E7D32),
                  theme: theme,
                ),
                _StatItem(
                  icon: Icons.cancel,
                  label: l10n.incorrect,
                  value: '${total - correct}',
                  color: const Color(0xFFED2939),
                  theme: theme,
                ),
                _StatItem(
                  icon: Icons.stars,
                  label: 'XP',
                  value: '+${correct * 10}',
                  color: Colors.amber,
                  theme: theme,
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _resetQuiz,
                  icon: const Icon(Icons.home),
                  label: Text(l10n.backToLearn),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _startQuiz,
                  icon: const Icon(Icons.refresh),
                  label: Text(l10n.tryAgain),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;
  final ThemeData theme;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 22, color: color ?? theme.colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color ?? theme.colorScheme.onSurface,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(150),
          ),
        ),
      ],
    );
  }
}
