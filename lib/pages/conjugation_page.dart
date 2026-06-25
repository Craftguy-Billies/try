import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/french_state.dart';
import '../data/french_verbs.dart';

import '../i18n/app_localizations.dart';

class ConjugationPage extends StatefulWidget {
  const ConjugationPage({super.key});

  @override
  State<ConjugationPage> createState() => _ConjugationPageState();
}

class _ConjugationPageState extends State<ConjugationPage>
    with SingleTickerProviderStateMixin {
  final FrenchState _french = FrenchState();
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _groupFilter = 'all';
  int? _expandedVerbIndex;

  static const _groupColors = {
    '1st': Color(0xFF4CAF50),
    '2nd': Color(0xFF2196F3),
    '3rd': Color(0xFFFF9800),
    'irregular': Color(0xFFE91E63),
  };

  static const _groupLabels = {
    '1st': '1er groupe',
    '2nd': '2e groupe',
    '3rd': '3e groupe',
    'irregular': 'Irrégulier',
  };

  List<FrenchVerb> get _filteredVerbs {
    var verbs = _french.allVerbsList;
    if (_groupFilter != 'all') {
      verbs = verbs.where((v) => v.group == _groupFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      verbs = verbs
          .where((v) =>
              v.infinitive.toLowerCase().contains(q) ||
              v.english.toLowerCase().contains(q))
          .toList();
    }
    return verbs;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _french,
      builder: (context, _) {
        final verbs = _filteredVerbs;
        return Column(
          children: [
            _buildSearchBar(theme, l10n),
            _buildGroupChips(theme),
            Expanded(
              child: verbs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off_rounded,
                              size: 56,
                              color: theme.colorScheme.onSurface
                                  .withAlpha(80)),
                          const SizedBox(height: 12),
                          Text(
                            l10n.noData,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withAlpha(120),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 24),
                      itemCount: verbs.length,
                      itemBuilder: (ctx, i) =>
                          _VerbCard(
                            verb: verbs[i],
                            isExpanded: _expandedVerbIndex == i,
                            theme: theme,
                            l10n: l10n,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _expandedVerbIndex =
                                    _expandedVerbIndex == i ? null : i;
                              });
                            },
                          ),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar(ThemeData theme, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
        decoration: InputDecoration(
          hintText: l10n.search,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded),
                  onPressed: () {
                    _searchCtrl.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: theme.colorScheme.surfaceContainerHighest
              .withAlpha(80),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildGroupChips(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _buildChip('Tous', 'all', theme),
          const SizedBox(width: 8),
          ..._groupLabels.entries.map(
            (e) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child:
                  _buildChip(e.value, e.key, theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String value, ThemeData theme) {
    final selected = _groupFilter == value;
    final color = _groupColors[value];
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _groupFilter = value),
      selectedColor: (color ?? theme.colorScheme.primary).withAlpha(40),
      checkmarkColor: color ?? theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: selected
            ? (color ?? theme.colorScheme.primary)
            : theme.colorScheme.onSurface,
        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: selected
            ? (color ?? theme.colorScheme.primary).withAlpha(120)
            : theme.colorScheme.outline.withAlpha(60),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _VerbCard extends StatefulWidget {
  final FrenchVerb verb;
  final bool isExpanded;
  final ThemeData theme;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  const _VerbCard({
    required this.verb,
    required this.isExpanded,
    required this.theme,
    required this.l10n,
    required this.onTap,
  });

  @override
  State<_VerbCard> createState() => _VerbCardState();
}

class _VerbCardState extends State<_VerbCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandCtrl;
  late Animation<double> _expandAnim;
  int _selectedTense = 0;

  static const _groupColors = {
    '1st': Color(0xFF4CAF50),
    '2nd': Color(0xFF2196F3),
    '3rd': Color(0xFFFF9800),
    'irregular': Color(0xFFE91E63),
  };

  @override
  void initState() {
    super.initState();
    _expandCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _expandAnim = CurvedAnimation(
      parent: _expandCtrl,
      curve: Curves.easeInOut,
    );
    if (widget.isExpanded) _expandCtrl.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant _VerbCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _expandCtrl.forward();
      } else {
        _expandCtrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _expandCtrl.dispose();
    super.dispose();
  }

  Color get _groupColor =>
      _groupColors[widget.verb.group] ?? widget.theme.colorScheme.primary;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final l10n = widget.l10n;
    final v = widget.verb;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(t, v),
              SizeTransition(
                sizeFactor: _expandAnim,
                axisAlignment: -1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildTenseTabs(t, l10n),
                    const SizedBox(height: 12),
                    _buildConjugationTable(t, v),
                    if (v.example != null) ...[
                      const SizedBox(height: 16),
                      _buildExample(t, v),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData t, FrenchVerb v) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                v.infinitive,
                style: t.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  color: _groupColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                v.english,
                style: t.textTheme.bodyMedium?.copyWith(
                  color: t.colorScheme.onSurface.withAlpha(160),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _groupColor.withAlpha(25),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _groupColor.withAlpha(80),
            ),
          ),
          child: Text(
            _ConjugationPageState._groupLabels[v.group] ?? v.group,
            style: TextStyle(
              color: _groupColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        AnimatedRotation(
          turns: widget.isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 350),
          child: Icon(
            Icons.expand_more_rounded,
            color: t.colorScheme.onSurface.withAlpha(120),
          ),
        ),
      ],
    );
  }

  Widget _buildTenseTabs(ThemeData t, AppLocalizations l10n) {
    final tenseLabels = [
      l10n.presentTense,
      l10n.imperfectTense,
      l10n.futureTense,
      l10n.pastTense,
      l10n.conditionalTense,
      l10n.subjunctiveTense,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(6, (i) {
          final selected = _selectedTense == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _selectedTense = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: selected
                      ? _groupColor
                      : t.colorScheme.surfaceContainerHighest
                          .withAlpha(100),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tenseLabels[i],
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : t.colorScheme.onSurface.withAlpha(180),
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildConjugationTable(ThemeData t, FrenchVerb v) {
    final tense = _selectedTense < v.tenses.length
        ? v.tenses[_selectedTense]
        : null;
    if (tense == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: t.colorScheme.outline.withAlpha(50),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(4),
        },
        children: [
          for (int i = 0; i < 6; i++)
            TableRow(
              decoration: BoxDecoration(
                color: i.isEven
                    ? t.colorScheme.surfaceContainerHighest
                        .withAlpha(50)
                    : Colors.transparent,
              ),
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  alignment: Alignment.centerRight,
                  child: Text(
                    tense.pronouns[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: t.colorScheme.onSurface.withAlpha(180),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    tense.conjugations[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: _groupColor,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildExample(ThemeData t, FrenchVerb v) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _groupColor.withAlpha(12),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(
            color: _groupColor.withAlpha(100),
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              size: 18, color: _groupColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              v.example!,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: t.colorScheme.onSurface.withAlpha(200),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
