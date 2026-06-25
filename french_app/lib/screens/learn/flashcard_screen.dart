import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/providers/progress_provider.dart';

class FlashcardScreen extends StatefulWidget {
  final List<VocabItem> words;

  const FlashcardScreen({super.key, required this.words});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late List<VocabItem> _cards;
  int _currentIndex = 0;
  bool _isFlipped = false;
  int _knownCount = 0;
  bool _isComplete = false;
  bool _showCheckmark = false;
  bool _showReview = false;

  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _cards = List<VocabItem>.from(widget.words)..shuffle();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
    DebugLogger.logScreenView('FlashcardScreen',
        details: {'wordCount': _cards.length});
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  VocabItem get _currentCard => _cards[_currentIndex];

  void _flipCard() {
    if (_isFlipped) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
    setState(() => _isFlipped = !_isFlipped);
  }

  void _markKnown() {
    final progress = context.read<ProgressProvider>();
    progress.markWordLearned(_currentCard.id);
    DebugLogger.logAction('Flashcard known', details: {
      'wordId': _currentCard.id,
      'french': _currentCard.french,
      'index': _currentIndex,
    });
    setState(() {
      _knownCount++;
      _showCheckmark = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _showCheckmark = false);
        _advanceCard();
      }
    });
  }

  void _markStillLearning() {
    final progress = context.read<ProgressProvider>();
    progress.markWordReviewed(_currentCard.id);
    DebugLogger.logAction('Flashcard still learning', details: {
      'wordId': _currentCard.id,
      'french': _currentCard.french,
      'index': _currentIndex,
    });
    setState(() => _showReview = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _showReview = false);
        _advanceCard();
      }
    });
  }

  void _advanceCard() {
    if (_currentIndex + 1 >= _cards.length) {
      setState(() => _isComplete = true);
      return;
    }
    setState(() {
      _currentIndex++;
      if (_isFlipped) {
        _isFlipped = false;
        _flipController.reset();
      }
    });
  }

  void _shuffle() {
    setState(() {
      _cards.shuffle();
      _currentIndex = 0;
      _isFlipped = false;
      _flipController.reset();
      _knownCount = 0;
      _isComplete = false;
    });
    DebugLogger.logAction('Flashcard reshuffled');
  }

  void _restart() {
    setState(() {
      _cards.shuffle();
      _currentIndex = 0;
      _isFlipped = false;
      _flipController.reset();
      _knownCount = 0;
      _isComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_cards.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(i18n.learnFlashcards), elevation: 0),
        body: Center(
          child: Text(i18n.noData,
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6))),
        ),
      );
    }

    if (_isComplete) {
      return _buildCompletionScreen(theme, i18n);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.learnFlashcards),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle),
            tooltip: 'Shuffle',
            onPressed: _shuffle,
          ),
        ],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progress, _) {
          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Progress indicator
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (_currentIndex + 1) / _cards.length,
                          minHeight: 6,
                          backgroundColor:
                              theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        i18n.flashcardProgress(_currentIndex + 1, _cards.length),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Card area
                Expanded(
                  child: GestureDetector(
                    onTap: _flipCard,
                    onHorizontalDragEnd: (details) {
                      if (details.primaryVelocity == null) return;
                      if (details.primaryVelocity! > 800) {
                        _markKnown();
                      } else if (details.primaryVelocity! < -800) {
                        _markStillLearning();
                      }
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _flipAnimation,
                          builder: (context, child) {
                            return Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(_flipAnimation.value * pi),
                              child: _flipAnimation.value < 0.5
                                  ? _buildFrontFace(theme, i18n)
                                  : Transform(
                                      alignment: Alignment.center,
                                      transform: Matrix4.identity()..rotateY(pi),
                                      child: _buildBackFace(theme, i18n),
                                    ),
                            );
                          },
                        ),
                        // Checkmark overlay
                        if (_showCheckmark)
                          _buildOverlay(Icons.check_circle, Colors.green, theme),
                        if (_showReview)
                          _buildOverlay(Icons.refresh, Colors.orange, theme),
                      ],
                    ),
                  ),
                ),
                // Swipe hint
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chevron_left,
                          size: 20,
                          color: theme.colorScheme.error.withOpacity(0.5)),
                      const SizedBox(width: 4),
                      Text(
                        i18n.flashcardTapToFlip,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right,
                          size: 20,
                          color: theme.colorScheme.primary.withOpacity(0.5)),
                    ],
                  ),
                ),
                // Action buttons
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _ActionButton(
                          label: i18n.flashcardStillLearning,
                          icon: Icons.refresh,
                          color: Colors.orange.shade700,
                          backgroundColor: Colors.orange.shade50,
                          onPressed: _markStillLearning,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _ActionButton(
                          label: i18n.flashcardKnown,
                          icon: Icons.check,
                          color: Colors.green.shade700,
                          backgroundColor: Colors.green.shade50,
                          onPressed: _markKnown,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFrontFace(ThemeData theme, AppLocalizations i18n) {
    final card = _currentCard;
    return _CardContainer(
      theme: theme,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Part of speech badge
          if (card.partOfSpeech != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                card.partOfSpeech!,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
          // French word
          Text(
            card.french,
            textAlign: TextAlign.center,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 42,
              letterSpacing: 1,
            ),
          ),
          // Pronunciation
          if (card.pronunciation != null) ...[
            const SizedBox(height: 16),
            Text(
              card.pronunciation!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
          // Gender badge
          if (card.gender != null) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: (card.gender == 'feminine'
                        ? Colors.pink
                        : Colors.blue)
                    .withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    card.gender == 'feminine' ? Icons.female : Icons.male,
                    size: 16,
                    color: card.gender == 'feminine'
                        ? Colors.pink
                        : Colors.blue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    card.gender!,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: card.gender == 'feminine'
                          ? Colors.pink.shade700
                          : Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 24),
          Text(
            i18n.flashcardTapToFlip,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackFace(ThemeData theme, AppLocalizations i18n) {
    final card = _currentCard;
    return _CardContainer(
      theme: theme,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              card.english,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
            if (card.gender != null) ...[
              const SizedBox(height: 12),
              Text(
                '(${card.gender})',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
            if (card.exampleSentence != null) ...[
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),
              Text(
                card.exampleSentence!,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
              if (card.exampleTranslation != null) ...[
                const SizedBox(height: 12),
                Text(
                  card.exampleTranslation!,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.65),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(IconData icon, Color color, ThemeData theme) {
    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(24),
        child: Icon(icon, size: 72, color: color),
      ),
    );
  }

  Widget _buildCompletionScreen(ThemeData theme, AppLocalizations i18n) {
    final scorePercent =
        _cards.isNotEmpty ? (_knownCount / _cards.length * 100).round() : 0;
    return Scaffold(
      appBar: AppBar(title: Text(i18n.learnFlashcards), elevation: 0),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                scorePercent >= 70 ? Icons.emoji_events : Icons.school,
                size: 96,
                color: scorePercent >= 70
                    ? Colors.amber
                    : theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                i18n.flashcardComplete,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                i18n.flashcardScore(_knownCount, _cards.length),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '$scorePercent%',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _knownCount / _cards.length,
                  minHeight: 10,
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.refresh),
                  label: Text(i18n.flashcardRestart),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: Text(i18n.flashcardBackToList),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardContainer extends StatelessWidget {
  final ThemeData theme;
  final Widget child;

  const _CardContainer({required this.theme, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.05),
              blurRadius: 40,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
          foregroundColor: color,
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

