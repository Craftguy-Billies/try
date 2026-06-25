import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../state/french_state.dart';

import '../data/french_grammar.dart';
import '../i18n/app_localizations.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});

  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  final FrenchState _french = FrenchState();
  String _difficultyFilter = 'all';

  static const _levelFilters = {
    'all': 'allLevels',
    'beginner': 'beginner',
    'intermediate': 'intermediate',
    'advanced': 'advanced',
  };

  List<GrammarLesson> get _filteredLessons {
    var lessons = _french.grammarLessonList;
    switch (_difficultyFilter) {
      case 'beginner':
        lessons = lessons.where((l) => l.level <= 2).toList();
        break;
      case 'intermediate':
        lessons = lessons.where((l) => l.level == 3).toList();
        break;
      case 'advanced':
        lessons = lessons.where((l) => l.level >= 4).toList();
        break;
    }
    return lessons;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _french,
      builder: (context, _) {
        final lessons = _filteredLessons;
        return Column(
          children: [
            _buildFilterChips(theme, l10n),
            Expanded(
              child: lessons.isEmpty
                  ? Center(
                      child: Text(l10n.noData,
                          style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurface
                                  .withAlpha(120))),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                          16, 4, 16, 24),
                      itemCount: lessons.length,
                      itemBuilder: (ctx, i) =>
                          _LessonCard(lesson: lessons[i]),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChips(ThemeData theme, AppLocalizations l10n) {
    final labels = [
      l10n.allLevels,
      l10n.beginner,
      l10n.intermediate,
      l10n.advanced,
    ];
    final values = _levelFilters.keys.toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: List.generate(values.length, (i) {
          final selected = _difficultyFilter == values[i];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(labels[i]),
              selected: selected,
              onSelected: (_) =>
                  setState(() => _difficultyFilter = values[i]),
              selectedColor: theme.colorScheme.primary.withAlpha(40),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: TextStyle(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight:
                    selected ? FontWeight.w600 : FontWeight.normal,
              ),
              side: BorderSide(
                color: selected
                    ? theme.colorScheme.primary.withAlpha(120)
                    : theme.colorScheme.outline.withAlpha(60),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
        }),
      ),
    );
  }
}

class _LessonCard extends StatelessWidget {
  final GrammarLesson lesson;

  const _LessonCard({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.mediumImpact();
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => _GrammarDetailPage(lesson: lesson),
            ),
          );
        },
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
                    child: Text(
                      lesson.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StarsIndicator(level: lesson.level),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: lesson.topics.map((t) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withAlpha(100),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer
                            .withAlpha(200),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.arrow_forward_rounded,
                      size: 18,
                      color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    l10n.readLesson,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StarsIndicator extends StatelessWidget {
  final int level;
  const _StarsIndicator({required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < level ? Icons.star_rounded : Icons.star_outline_rounded,
          size: 18,
          color: i < level
              ? const Color(0xFFFFC107)
              : Colors.grey.withAlpha(100),
        );
      }),
    );
  }
}

class _GrammarDetailPage extends StatelessWidget {
  final GrammarLesson lesson;
  const _GrammarDetailPage({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title,
            style: const TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          _StarsIndicator(level: lesson.level),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (lesson.topics.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: lesson.topics.map((t) {
                  return Chip(
                    label: Text(t,
                        style: const TextStyle(fontSize: 11)),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.zero,
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
            _ParsedContent(
                content: lesson.content, theme: theme),
            const SizedBox(height: 32),
            Text(
              l10n.relatedTopics,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _buildRelatedLessons(context, theme, l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildRelatedLessons(BuildContext context, ThemeData theme, AppLocalizations l10n) {
    final related = FrenchState()
        .grammarLessonList
        .where((l) =>
            l.id != lesson.id &&
            (l.level - lesson.level).abs() <= 1)
        .take(4)
        .toList();

    if (related.isEmpty) return const SizedBox.shrink();

    return Column(
      children: related.map((r) {
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: _StarsIndicator(level: r.level),
          title: Text(r.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14)),
          trailing: const Icon(Icons.chevron_right_rounded),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => _GrammarDetailPage(lesson: r),
            ));
          },
        );
      }).toList(),
    );
  }
}

class _ParsedContent extends StatelessWidget {
  final String content;
  final ThemeData theme;

  const _ParsedContent({required this.content, required this.theme});

  @override
  Widget build(BuildContext context) {
    final blocks = _parseBlocks(content);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks.map((b) => _buildBlock(b)).toList(),
    );
  }

  List<_ContentBlock> _parseBlocks(String text) {
    final blocks = <_ContentBlock>[];
    final lines = text.split('\n');
    final buf = StringBuffer();
    String? currentType;

    void flush() {
      if (currentType != null && buf.isNotEmpty) {
        blocks.add(_ContentBlock(currentType!, buf.toString().trim()));
        buf.clear();
      } else if (currentType == null && buf.isNotEmpty) {
        blocks
            .add(_ContentBlock('paragraph', buf.toString().trim()));
        buf.clear();
      }
    }

    for (final line in lines) {
      if (line.startsWith('### ')) {
        flush();
        currentType = 'h3';
        buf.writeln(line.substring(4));
      } else if (line.startsWith('## ')) {
        flush();
        currentType = 'h2';
        buf.writeln(line.substring(3));
      } else if (line.startsWith('|') && line.endsWith('|')) {
        flush();
        currentType = 'table';
        buf.writeln(line);
      } else if (line.startsWith('- ')) {
        if (currentType != 'bullet') {
          flush();
          currentType = 'bullet';
        }
        buf.writeln(line.substring(2));
      } else if (line.trim().isEmpty) {
        flush();
        currentType = null;
      } else if (line.trim().startsWith('---')) {
        flush();
        currentType = null;
      } else {
        if (currentType == 'table') {
          buf.writeln(line);
        } else {
          if (currentType != 'paragraph') {
            flush();
            currentType = 'paragraph';
          }
          buf.writeln(line);
        }
      }
    }
    flush();
    return blocks;
  }

  Widget _buildBlock(_ContentBlock block) {
    switch (block.type) {
      case 'h2':
        return _buildHeader(block.text, 22);
      case 'h3':
        return _buildHeader(block.text, 18);
      case 'bullet':
        return _buildBulletList(block.text);
      case 'table':
        return _buildTable(block.text);
      case 'paragraph':
        return _buildParagraph(block.text);
      default:
        return _buildParagraph(block.text);
    }
  }

  Widget _buildHeader(String text, double size) {
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    final spans = <InlineSpan>[];
    int lastEnd = 0;

    for (final match in boldPattern.allMatches(text)) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: theme.colorScheme.primary,
        ),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    if (spans.isEmpty) {
      spans.add(TextSpan(text: text));
    }

    return Padding(
      padding: EdgeInsets.only(
          top: size == 22 ? 24 : 20, bottom: 10),
      child: Text.rich(
        TextSpan(children: spans),
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildRichText(text, theme),
    );
  }

  Widget _buildRichText(String text, ThemeData t) {
    final inlineCodePattern = RegExp(r'`([^`]+)`');
    final boldPattern = RegExp(r'\*\*(.+?)\*\*');
    final italicPattern = RegExp(r'\*(.+?)\*');

    final spans = <InlineSpan>[];
    int pos = 0;

    while (pos < text.length) {
      final nextMatches = <_Match>[];

      final icMatch = inlineCodePattern.matchAsPrefix(text, pos);
      if (icMatch != null) {
        nextMatches.add(_Match(icMatch.start, icMatch.end, 'code',
            icMatch.group(1)!));
      }

      final bMatch = boldPattern.matchAsPrefix(text, pos);
      if (bMatch != null) {
        nextMatches.add(
            _Match(bMatch.start, bMatch.end, 'bold', bMatch.group(1)!));
      }

      final iMatch = italicPattern.matchAsPrefix(text, pos);
      if (iMatch != null) {
        nextMatches.add(_Match(
            iMatch.start, iMatch.end, 'italic', iMatch.group(1)!));
      }

      if (nextMatches.isEmpty) {
        spans.add(TextSpan(text: text.substring(pos)));
        break;
      }

      nextMatches.sort((a, b) => a.start.compareTo(b.start));
      final m = nextMatches.first;

      if (m.start > pos) {
        spans.add(TextSpan(text: text.substring(pos, m.start)));
      }

      TextStyle style = const TextStyle();
      if (m.type == 'code') {
        style = TextStyle(
          fontFamily: 'monospace',
          backgroundColor: t.colorScheme.primaryContainer.withAlpha(80),
          color: t.colorScheme.primary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        );
      } else if (m.type == 'bold') {
        style = const TextStyle(fontWeight: FontWeight.w700);
      } else if (m.type == 'italic') {
        style = const TextStyle(fontStyle: FontStyle.italic);
      }

      spans.add(TextSpan(text: m.content, style: style));
      pos = m.end;
    }

    return Text.rich(
      TextSpan(
        children: spans,
        style: TextStyle(
          fontSize: 15,
          height: 1.55,
          color: t.colorScheme.onSurface.withAlpha(220),
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  Widget _buildBulletList(String text) {
    final items = text.split('\n').where((l) => l.trim().isNotEmpty);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10, right: 10),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(child: _buildRichText(item, theme)),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTable(String text) {
    final lines = text.split('\n');
    if (lines.length < 2) return _buildParagraph(text);

    final dataRows = <List<String>>[];
    for (final line in lines) {
      if (line.trim().startsWith('|---') || line.trim().startsWith('|--')) {
        continue;
      }
      final cells = line
          .split('|')
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty)
          .toList();
      if (cells.isNotEmpty) dataRows.add(cells);
    }

    if (dataRows.isEmpty) return _buildParagraph(text);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withAlpha(50),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Table(
          columnWidths: dataRows[0]
              .asMap()
              .map((i, _) => MapEntry(i, const FlexColumnWidth())),
          children: dataRows.asMap().entries.map((entry) {
            final i = entry.key;
            final row = entry.value;
            final isFirst = i == 0;
            return TableRow(
              decoration: BoxDecoration(
                color: isFirst
                    ? theme.colorScheme.primaryContainer.withAlpha(60)
                    : (i.isEven
                        ? theme.colorScheme.surfaceContainerHighest
                            .withAlpha(40)
                        : Colors.transparent),
              ),
              children: row.map((cell) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  child: _buildRichText(
                      cell, theme),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _ContentBlock {
  final String type;
  final String text;
  const _ContentBlock(this.type, this.text);
}

class _Match {
  final int start;
  final int end;
  final String type;
  final String content;
  const _Match(this.start, this.end, this.type, this.content);
}
