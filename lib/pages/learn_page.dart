import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/french_state.dart';
import '../i18n/app_localizations.dart';
import '../models/vocab_item.dart';

class LearnPage extends StatefulWidget {
  const LearnPage({super.key});

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage>
    with SingleTickerProviderStateMixin {
  final FrenchState _french = FrenchState();

  List<VocabItem> _dueWords = [];
  int _currentIndex = 0;
  String? _selectedCategory;
  bool _isFlipped = false;
  bool _isAnimating = false;
  bool _showCheckmark = false;

  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  late final AnimationController _checkController;

  final PageController _cardPageController = PageController();

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _loadDueWords();
  }

  @override
  void dispose() {
    _flipController.dispose();
    _checkController.dispose();
    _cardPageController.dispose();
    super.dispose();
  }

  void _loadDueWords() {
    _dueWords = _french.getDueWords(category: _selectedCategory);
    _currentIndex = 0;
    _isFlipped = false;
    _flipController.reset();
    _showCheckmark = false;
    setState(() {});
  }

  VocabItem? get _currentWord =>
      _currentIndex < _dueWords.length ? _dueWords[_currentIndex] : null;

  List<String> get _categories {
    final cats = <String>{};
    for (final v in _french.vocab) {
      cats.add(v.word.category);
    }
    return cats.toList()..sort();
  }

  void _flipCard() {
    if (_isAnimating) return;
    setState(() => _isAnimating = true);
    if (_isFlipped) {
      _flipController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _isFlipped = false;
          _isAnimating = false;
        });
      });
    } else {
      _flipController.forward().then((_) {
        if (!mounted) return;
        setState(() {
          _isFlipped = true;
          _isAnimating = false;
        });
      });
    }
    HapticFeedback.lightImpact();
  }

  void _markCorrect() {
    if (_currentWord == null || _isAnimating) return;
    final word = _currentWord!;
    _french.markWordCorrect(word);
    HapticFeedback.mediumImpact();
    setState(() => _showCheckmark = true);
    _checkController.forward().then((_) {
      if (!mounted) return;
      _checkController.reset();
      _advanceCard();
    });
  }

  void _markIncorrect() {
    if (_currentWord == null || _isAnimating) return;
    final word = _currentWord!;
    _french.markWordIncorrect(word);
    HapticFeedback.heavyImpact();
    _advanceCard();
  }

  void _advanceCard() {
    if (_currentIndex >= _dueWords.length - 1) {
      setState(() {
        _showCheckmark = false;
        _dueWords.removeAt(_currentIndex);
      });
      if (_dueWords.isEmpty) {
        _loadDueWords();
      } else {
        _currentIndex = _dueWords.length - 1;
      }
      return;
    }
    setState(() {
      _isFlipped = false;
      _flipController.reset();
      _showCheckmark = false;
      _currentIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final allWords = _french.vocab;

    return RefreshIndicator(
      onRefresh: () async {
        _loadDueWords();
      },
      child: ListenableBuilder(
        listenable: _french,
        builder: (context, _) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildCategoryChips(l10n, theme),
              ),
              if (_dueWords.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(l10n, theme),
                )
              else ...[
                SliverToBoxAdapter(
                  child: _buildProgressHeader(l10n, theme),
                ),
                SliverToBoxAdapter(
                  child: _buildFlashcard(l10n, theme),
                ),
                if (!_isFlipped)
                  SliverToBoxAdapter(
                    child: _buildTapHint(l10n, theme),
                  )
                else
                  SliverToBoxAdapter(
                    child: _buildAnswerButtons(l10n, theme),
                  ),
                SliverToBoxAdapter(
                  child: _buildCategoryProgress(l10n, theme, allWords),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryChips(AppLocalizations l10n, ThemeData theme) {
    final cats = _categories;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: cats.length + 1,
          separatorBuilder: (_, __) => const SizedBox(width: 6),
          itemBuilder: (context, index) {
            if (index == 0) {
              final selected = _selectedCategory == null;
              return _CategoryChip(
                label: l10n.all,
                isSelected: selected,
                onTap: () {
                  setState(() => _selectedCategory = null);
                  _loadDueWords();
                },
              );
            }
            final cat = cats[index - 1];
            final selected = _selectedCategory == cat;
            return _CategoryChip(
              label: cat,
              isSelected: selected,
              onTap: () {
                setState(() => _selectedCategory = cat == _selectedCategory ? null : cat);
                _loadDueWords();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildProgressHeader(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_outlined, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            '${l10n.vocabulary} ${_currentIndex + 1} ${l10n.of_} ${_dueWords.length} ${l10n.today}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(180),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapHint(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Center(
        child: AnimatedOpacity(
          opacity: _isFlipped ? 0.0 : 0.7,
          duration: const Duration(milliseconds: 200),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.touch_app, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                l10n.flipCard,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFlashcard(AppLocalizations l10n, ThemeData theme) {
    final word = _currentWord;
    if (word == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: _flipCard,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            final value = _flipAnimation.value;
            final angle = value * pi;
            final isFrontVisible = value < 0.5;

            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              child: isFrontVisible
                  ? _buildCardFace(
                      theme: theme,
                      child: _buildFrontFace(word, theme),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildCardFace(
                        theme: theme,
                        child: _buildBackFace(word, theme),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardFace({required ThemeData theme, required Widget child}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 220, maxHeight: 260),
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withAlpha(60),
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _buildFrontFace(VocabItem word, ThemeData theme) {
    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  word.word.french,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                    height: 1.3,
                  ),
                ),
                if (word.word.example != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    word.word.example!,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withAlpha(140),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 12,
          right: 16,
          child: _SrsLevelBadge(level: word.srsLevel, size: 10),
        ),
      ],
    );
  }

  Widget _buildBackFace(VocabItem word, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _categoryColor(word.word.category).withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _categoryColor(word.word.category).withAlpha(80),
                ),
              ),
              child: Text(
                word.word.category,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: _categoryColor(word.word.category),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              word.word.english,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              word.word.partOfSpeech,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(150),
              ),
            ),
            if (word.word.example != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  word.word.example!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withAlpha(160),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerButtons(AppLocalizations l10n, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: _AnswerButton(
              label: l10n.stillLearning,
              icon: Icons.refresh,
              color: const Color(0xFFED2939),
              onPressed: _markIncorrect,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _AnswerButton(
              label: l10n.iKnowIt,
              icon: Icons.check,
              color: const Color(0xFF2E7D32),
              onPressed: _markCorrect,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProgress(
    AppLocalizations l10n,
    ThemeData theme,
    List<VocabItem> allWords,
  ) {
    final masteryMap = _french.categoryMastery;
    if (masteryMap.isEmpty) return const SizedBox.shrink();

    final entries = masteryMap.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.categoryBreakdown,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ...entries.take(5).map((entry) {
            final pct = (entry.value * 100).toInt();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$pct%',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value,
                      minHeight: 6,
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      color: Color.lerp(
                        const Color(0xFFED2939),
                        const Color(0xFF2E7D32),
                        entry.value,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n, ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('🎉', style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              l10n.allCaughtUp,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.comeBackLater,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withAlpha(160),
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _loadDueWords,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.retry),
            ),
          ],
        ),
      ),
    );
  }

  Color _categoryColor(String category) {
    final colors = [
      const Color(0xFF1A237E),
      const Color(0xFF004D40),
      const Color(0xFFB71C1C),
      const Color(0xFFE65100),
      const Color(0xFF4A148C),
      const Color(0xFF0D47A1),
      const Color(0xFF1B5E20),
      const Color(0xFF880E4F),
      const Color(0xFFBF360C),
      const Color(0xFF311B92),
    ];
    return colors[category.hashCode.abs() % colors.length];
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest.withAlpha(100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant.withAlpha(80),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface.withAlpha(180),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withAlpha(25),
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: color.withAlpha(80)),
          ),
        ),
      ),
    );
  }
}

class _SrsLevelBadge extends StatelessWidget {
  final int level;
  final double size;

  const _SrsLevelBadge({required this.level, this.size = 8});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        5,
        (i) => Container(
          width: size,
          height: size,
          margin: const EdgeInsets.symmetric(horizontal: 1.5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i < level
                ? const Color(0xFF1A237E).withAlpha(180)
                : const Color(0xFF1A237E).withAlpha(30),
          ),
        ),
      ),
    );
  }
}
