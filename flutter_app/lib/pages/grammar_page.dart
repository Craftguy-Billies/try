import 'package:flutter/material.dart';
import '../data/french_grammar.dart';
import '../models/verb.dart';
import '../state/app_state.dart';

class GrammarPage extends StatefulWidget {
  const GrammarPage({super.key});
  @override
  State<GrammarPage> createState() => _GrammarPageState();
}

class _GrammarPageState extends State<GrammarPage> {
  GrammarLesson? _selectedLesson;
  String _filterCategory = 'All';

  List<String> get _categories {
    final cats = <String>{'All'};
    for (final l in grammarLessons) {
      cats.add(l.category);
    }
    return cats.toList();
  }

  List<GrammarLesson> get _filteredLessons {
    if (_filterCategory == 'All') return grammarLessons;
    return grammarLessons.where((l) => l.category == _filterCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedLesson != null ? _selectedLesson!.title : 'Grammar'),
        centerTitle: true,
        leading: _selectedLesson != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() => _selectedLesson = null);
                },
              )
            : null,
      ),
      body: _selectedLesson != null ? _buildLessonView() : _buildLessonList(),
    );
  }

  Widget _buildLessonList() {
    final cs = Theme.of(context).colorScheme;
    final lessons = _filteredLessons;

    return Column(
      children: [
        // Category filter
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 6),
            itemBuilder: (_, i) {
              final cat = _categories[i];
              final active = cat == _filterCategory;
              return FilterChip(
                label: Text(cat, style: TextStyle(fontSize: 12, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
                selected: active,
                onSelected: (_) => setState(() => _filterCategory = cat),
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        ),
        const Divider(height: 1),
        // Lesson cards
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: lessons.length,
            itemBuilder: (_, i) {
              final lesson = lessons[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    setState(() => _selectedLesson = lesson);
                    appState.log('FRENCH', 'Grammar: ${lesson.title}', color: Colors.teal);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 44, height: 44,
                          decoration: BoxDecoration(
                            color: _categoryColor(lesson.category).withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_categoryIcon(lesson.category), color: _categoryColor(lesson.category), size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lesson.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                              const SizedBox(height: 2),
                              Text(lesson.category, style: TextStyle(fontSize: 12, color: cs.onSurface.withAlpha(130))),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, color: cs.onSurface.withAlpha(80)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLessonView() {
    final cs = Theme.of(context).colorScheme;
    final lesson = _selectedLesson!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _categoryColor(lesson.category).withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(lesson.category, style: TextStyle(color: _categoryColor(lesson.category), fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          const SizedBox(height: 12),
          Text(lesson.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          // Content
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest.withAlpha(70),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SelectableText(
              lesson.content,
              style: TextStyle(fontSize: 14, height: 1.7, color: cs.onSurface),
            ),
          ),
          if (lesson.tip != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withAlpha(60)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.tips_and_updates, size: 18, color: Colors.amber),
                  const SizedBox(width: 10),
                  Expanded(child: Text(lesson.tip!, style: TextStyle(fontSize: 13, color: Colors.amber.shade900, fontWeight: FontWeight.w500))),
                ],
              ),
            ),
          ],
          if (lesson.examples.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text('Examples', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...lesson.examples.map((ex) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cs.primaryContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(ex, style: TextStyle(fontSize: 13, color: cs.onPrimaryContainer, fontStyle: FontStyle.italic)),
            )),
          ],
        ],
      ),
    );
  }

  Color _categoryColor(String category) {
    switch (category) {
      case 'Basics': return Colors.blue;
      case 'Verbs': return Colors.orange;
      default: return Colors.teal;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case 'Basics': return Icons.abc;
      case 'Verbs': return Icons.edit_note;
      default: return Icons.menu_book;
    }
  }
}
