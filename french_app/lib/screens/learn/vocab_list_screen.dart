import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/data/french_vocab.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'flashcard_screen.dart';

enum FilterMode { all, unlearned, favorites, mastered }

class VocabListScreen extends StatefulWidget {
  final String? category;
  final String? level;

  const VocabListScreen({super.key, this.category, this.level});

  @override
  State<VocabListScreen> createState() => _VocabListScreenState();
}

class _VocabListScreenState extends State<VocabListScreen> {
  FilterMode _filter = FilterMode.all;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('VocabListScreen',
        details: {'category': widget.category, 'level': widget.level});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VocabItem> _getBaseWords() {
    var words = getAllVocab();
    if (widget.level != null) {
      words = words.where((w) => w.level == widget.level).toList();
    }
    if (widget.category != null) {
      words = words.where((w) => w.category == widget.category).toList();
    }
    return words;
  }

  List<VocabItem> _filterWords(List<VocabItem> words, ProgressProvider progress) {
    switch (_filter) {
      case FilterMode.unlearned:
        return words.where((w) => !progress.progress.masteredWordIds.contains(w.id)).toList();
      case FilterMode.favorites:
        return words.where((w) => progress.progress.favoriteWordIds.contains(w.id)).toList();
      case FilterMode.mastered:
        return words.where((w) => progress.progress.masteredWordIds.contains(w.id)).toList();
      case FilterMode.all:
        return words;
    }
  }

  List<VocabItem> _searchWords(List<VocabItem> words) {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return words;
    return words.where((w) {
      return w.french.toLowerCase().contains(query) ||
          w.english.toLowerCase().contains(query) ||
          (w.exampleSentence?.toLowerCase().contains(query) ?? false);
    }).toList();
  }

  String _screenTitle(AppLocalizations i18n) {
    if (widget.category != null) {
      return _categoryDisplayName(widget.category!, i18n);
    }
    if (widget.level != null) return '${i18n.learnSelectLevel}: ${widget.level}';
    return i18n.vocabulary;
  }

  void _navigateToFlashcards(List<VocabItem> words) {
    if (words.isEmpty) return;
    final shuffled = List<VocabItem>.from(words)..shuffle();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FlashcardScreen(words: shuffled)),
    );
  }

  void _startQuiz(List<VocabItem> words) {
    // Quiz mode navigates to flashcards with shuffled words
    _navigateToFlashcards(words);
  }

  void _showDetailSheet(VocabItem item) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.3,
          maxChildSize: 0.85,
          expand: false,
          builder: (ctx, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onSurface.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(item.french,
                      style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.english,
                      style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7))),
                  if (item.pronunciation != null) ...[
                    const SizedBox(height: 8),
                    Text('🔊 ${item.pronunciation}',
                        style: theme.textTheme.bodyLarge?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.primary)),
                  ],
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (item.partOfSpeech != null)
                        Chip(
                          avatar: const Icon(Icons.category, size: 16),
                          label: Text(item.partOfSpeech!),
                          visualDensity: VisualDensity.compact,
                        ),
                      if (item.gender != null)
                        Chip(
                          avatar: Icon(
                            item.gender == 'feminine'
                                ? Icons.female
                                : Icons.male,
                            size: 16,
                            color: item.gender == 'feminine'
                                ? Colors.pink
                                : Colors.blue,
                          ),
                          label: Text(item.gender!),
                          visualDensity: VisualDensity.compact,
                          backgroundColor: (item.gender == 'feminine'
                                  ? Colors.pink
                                  : Colors.blue)
                              .withOpacity(0.1),
                        ),
                      Chip(
                        avatar: const Icon(Icons.speed, size: 16),
                        label: Text('DELF ${item.level}'),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  if (item.exampleSentence != null) ...[
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('🇫🇷 ${item.exampleSentence}',
                              style: theme.textTheme.bodyLarge),
                          if (item.exampleTranslation != null) ...[
                            const SizedBox(height: 8),
                            Text('🇬🇧 ${item.exampleTranslation}',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.7))),
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final baseWords = _getBaseWords();

    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle(i18n)),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.style),
            tooltip: i18n.learnFlashcards,
            onPressed: () {
              final progress = context.read<ProgressProvider>();
              final filtered = _filterWords(baseWords, progress);
              _navigateToFlashcards(filtered);
            },
          ),
          IconButton(
            icon: const Icon(Icons.quiz),
            tooltip: i18n.learnQuiz,
            onPressed: () {
              final progress = context.read<ProgressProvider>();
              final filtered = _filterWords(baseWords, progress);
              _startQuiz(filtered);
            },
          ),
        ],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progress, _) {
          final filtered = _filterWords(baseWords, progress);
          final searched = _searchWords(filtered);

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: i18n.learnSearch,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor:
                        theme.colorScheme.surfaceContainerHighest.withOpacity(0.4),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              // Filter chips
              SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(
                      label: 'All',
                      selected: _filter == FilterMode.all,
                      theme: theme,
                      onTap: () => setState(() => _filter = FilterMode.all),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Unlearned',
                      selected: _filter == FilterMode.unlearned,
                      theme: theme,
                      onTap: () => setState(() => _filter = FilterMode.unlearned),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Favorites',
                      selected: _filter == FilterMode.favorites,
                      theme: theme,
                      onTap: () => setState(() => _filter = FilterMode.favorites),
                    ),
                    const SizedBox(width: 8),
                    _buildFilterChip(
                      label: 'Mastered',
                      selected: _filter == FilterMode.mastered,
                      theme: theme,
                      onTap: () => setState(() => _filter = FilterMode.mastered),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Word count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text(
                      '${searched.length} ${searched.length == 1 ? 'word' : 'words'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const Spacer(),
                    if (_filter == FilterMode.mastered)
                      Text(
                        '${searched.length}/${baseWords.length} mastered',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Word list
              Expanded(
                child: searched.isEmpty
                    ? _EmptyState(theme: theme, i18n: i18n, filter: _filter)
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: searched.length,
                        itemBuilder: (context, index) {
                          return _VocabCard(
                            item: searched[index],
                            progress: progress,
                            onTap: () => _showDetailSheet(searched[index]),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13,
            color: selected
                ? theme.colorScheme.onPrimaryContainer
                : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _VocabCard extends StatelessWidget {
  final VocabItem item;
  final ProgressProvider progress;
  final VoidCallback onTap;

  const _VocabCard({
    required this.item,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMastered = progress.progress.masteredWordIds.contains(item.id);
    final isFavorite = progress.progress.favoriteWordIds.contains(item.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isMastered ? 0 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isMastered
            ? BorderSide(
                color: theme.colorScheme.primary.withOpacity(0.3), width: 1)
            : BorderSide.none,
      ),
      color: isMastered
          ? theme.colorScheme.primaryContainer.withOpacity(0.15)
          : theme.colorScheme.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.french,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            if (isMastered)
                              Icon(Icons.check_circle,
                                  size: 20, color: theme.colorScheme.primary),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.english,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : null,
                      size: 22,
                    ),
                    onPressed: () => progress.toggleFavorite(item.id),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (item.partOfSpeech != null)
                    _MiniBadge(
                      label: item.partOfSpeech!,
                      color: theme.colorScheme.secondaryContainer,
                      textColor: theme.colorScheme.onSecondaryContainer,
                    ),
                  if (item.gender != null)
                    _MiniBadge(
                      label: item.gender == 'feminine' ? 'f' : 'm',
                      color: (item.gender == 'feminine'
                              ? Colors.pink
                              : Colors.blue)
                          .withOpacity(0.15),
                      textColor: item.gender == 'feminine'
                          ? Colors.pink.shade700
                          : Colors.blue.shade700,
                    ),
                  _MiniBadge(
                    label: item.level,
                    color: theme.colorScheme.tertiaryContainer,
                    textColor: theme.colorScheme.onTertiaryContainer,
                  ),
                ],
              ),
              if (item.pronunciation != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.pronunciation!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
              if (item.exampleSentence != null) ...[
                const SizedBox(height: 8),
                Text(
                  item.exampleSentence!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.55),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _MiniBadge({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations i18n;
  final FilterMode filter;

  const _EmptyState({
    required this.theme,
    required this.i18n,
    required this.filter,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, message) = switch (filter) {
      FilterMode.favorites => (
          Icons.favorite_border,
          'No favorite words yet.\nTap the heart icon to add words.',
        ),
      FilterMode.mastered => (
          Icons.check_circle_outline,
          'No mastered words yet.\nStudy flashcards to mark words as learned!',
        ),
      FilterMode.unlearned => (
          Icons.auto_awesome,
          'All words in this category are mastered!\nGreat job! 🎉',
        ),
      FilterMode.all => (
          Icons.inbox_outlined,
          i18n.noData,
        ),
    };

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72,
                color: theme.colorScheme.onSurface.withOpacity(0.25)),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _categoryDisplayName(String category, AppLocalizations i18n) {
  final key = _categoryToI18nKey(category);
  return key != null ? i18n.translate(key) : category;
}

String? _categoryToI18nKey(String category) {
  return switch (category) {
    'Greetings & Politeness' => 'cat_greetings',
    'Family & People' => 'cat_family',
    'Food & Drinks' => 'cat_food',
    'Clothing' => 'cat_clothing',
    'Home & Furniture' => 'cat_home',
    'City & Transport' => 'cat_city',
    'Work & School' => 'cat_work',
    'Numbers & Time' => 'cat_numbers',
    'Nature & Animals' => 'cat_nature',
    'Sports & Hobbies' => 'cat_sports',
    'Colors & Shapes' => 'cat_colors',
    'Body & Health' => 'cat_body',
    'Weather & Seasons' => 'cat_weather',
    'Media & Technology' => 'cat_media',
    'Travel & Holidays' => 'cat_travel',
    _ => null,
  };
}

