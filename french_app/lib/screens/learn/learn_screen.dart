import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/data/french_vocab.dart';
import 'package:french_app/models/vocab_item.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'vocab_list_screen.dart';
import 'flashcard_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  String _selectedLevel = 'All';

  static const _levels = ['All', 'A1', 'A2', 'B1', 'B2'];

  static const _categoryIcons = {
    'Greetings & Politeness': Icons.handshake,
    'Family & People': Icons.people,
    'Food & Drinks': Icons.restaurant,
    'Clothing': Icons.checkroom,
    'Home & Furniture': Icons.home,
    'City & Transport': Icons.location_city,
    'Work & School': Icons.work,
    'Numbers & Time': Icons.tag,
    'Nature & Animals': Icons.nature,
    'Sports & Hobbies': Icons.sports_soccer,
    'Colors & Shapes': Icons.palette,
    'Body & Health': Icons.accessibility,
    'Weather & Seasons': Icons.cloud,
    'Media & Technology': Icons.devices,
    'Travel & Holidays': Icons.flight,
    'Academic & Professional': Icons.school,
  };

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('LearnScreen');
  }

  List<VocabItem> _filteredVocab() {
    if (_selectedLevel == 'All') return getAllVocab();
    return getVocabByLevel(_selectedLevel);
  }

  Map<String, int> _categoryWordCounts() {
    final words = _filteredVocab();
    final counts = <String, int>{};
    for (final w in words) {
      counts[w.category] = (counts[w.category] ?? 0) + 1;
    }
    return counts;
  }

  void _navigateToVocabList(String category) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VocabListScreen(
          category: category,
          level: _selectedLevel == 'All' ? null : _selectedLevel,
        ),
      ),
    );
  }

  void _navigateToFlashcards() {
    final words = _filteredVocab();
    if (words.isEmpty) return;
    words.shuffle();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FlashcardScreen(words: words)),
    );
  }

  void _showSearch() {
    final i18n = AppLocalizations.of(context);
    showSearch(
      context: context,
      delegate: _VocabSearchDelegate(vocab: _filteredVocab(), i18n: i18n),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final categoryCounts = _categoryWordCounts();
    final categories = categoryCounts.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.learnTitle),
        elevation: 0,
        scrolledUnderElevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: i18n.search,
            onPressed: _showSearch,
          ),
        ],
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progress, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _levels.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final level = _levels[index];
                    final selected = _selectedLevel == level;
                    return FilterChip(
                      label: Text(level == 'All' ? i18n.levelAll : level),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedLevel = level),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest
                          .withOpacity(0.5),
                      selectedColor: theme.colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                        color: selected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  i18n.learnSelectCategory,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Text(
                          i18n.noData,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 1.15,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final count = categoryCounts[cat] ?? 0;
                          final icon = _categoryIcons[cat] ?? Icons.category;
                          return _CategoryCard(
                            category: cat,
                            icon: icon,
                            wordCount: count,
                            i18n: i18n,
                            onTap: () => _navigateToVocabList(cat),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToFlashcards,
        icon: const Icon(Icons.flash_on),
        label: Text(i18n.learnFlashcards),
        elevation: 4,
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final int wordCount;
  final AppLocalizations i18n;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.icon,
    required this.wordCount,
    required this.i18n,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hash = category.hashCode;
    final hue = (hash.abs() % 360).toDouble();
    final baseColor = HSLColor.fromAHSL(0.75, hue, 0.5, 0.45).toColor();
    final lightColor = HSLColor.fromAHSL(0.75, hue, 0.6, 0.55).toColor();

    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: baseColor.withOpacity(0.35),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [baseColor, lightColor],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 28, color: Colors.white),
              ),
              const Spacer(),
              Text(
                _categoryDisplayName(category, i18n),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                '$wordCount ${wordCount == 1 ? 'word' : 'words'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
            ],
          ),
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

// ─── Search Delegate ───

class _VocabSearchDelegate extends SearchDelegate<String> {
  final List<VocabItem> vocab;
  final AppLocalizations i18n;

  _VocabSearchDelegate({required this.vocab, required this.i18n});

  @override
  String get searchFieldLabel => i18n.learnSearch;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme.of(context).copyWith(
        elevation: 0,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, ''),
      );

  @override
  Widget buildResults(BuildContext context) => _buildSearchResults(context);

  @override
  Widget buildSuggestions(BuildContext context) => _buildSearchResults(context);

  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);
    final queryLower = query.toLowerCase();
    final results = vocab.where((v) {
      return v.french.toLowerCase().contains(queryLower) ||
          v.english.toLowerCase().contains(queryLower) ||
          v.category.toLowerCase().contains(queryLower);
    }).toList();

    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 64,
                color: theme.colorScheme.onSurface.withOpacity(0.4)),
            const SizedBox(height: 16),
            Text(
              query.isNotEmpty
                  ? '${i18n.noData} for "$query"'
                  : i18n.noData,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (_, __) => const Divider(height: 1, indent: 72),
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              item.french[0].toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          title: Text(item.french,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(item.english),
          trailing: Chip(
            label: Text(item.level, style: const TextStyle(fontSize: 11)),
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        );
      },
    );
  }
}
