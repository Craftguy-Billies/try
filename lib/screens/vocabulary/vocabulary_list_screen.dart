
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../models/vocabulary.dart';
import '../../services/vocabulary_service.dart';
import 'flashcard_screen.dart';
import 'word_detail_screen.dart';

class VocabularyListScreen extends StatefulWidget {
  final String? categoryId;
  final String? categoryName;
  const VocabularyListScreen({super.key, this.categoryId, this.categoryName});
  @override
  State<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends State<VocabularyListScreen> {
  String _searchQuery = '';
  int _difficultyFilter = 0; // 0 = all

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final vocab = context.watch<VocabularyService>();
    var words = widget.categoryId != null ? vocab.byCategory(widget.categoryId!) : vocab.allWords;
    if (_searchQuery.isNotEmpty) words = words.where((w) =>
      w.french.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      w.english.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    if (_difficultyFilter > 0) words = words.where((w) => w.difficulty == _difficultyFilter).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName ?? t.get('vocabulary'))),
      body: Column(children: [
        Padding(padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            decoration: InputDecoration(hintText: t.get('search'), prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _searchQuery = '')) : null),
            onChanged: (v) => setState(() => _searchQuery = v))),
        SingleChildScrollView(scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [0, 1, 2, 3, 4].map((d) {
            return Padding(padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(d == 0 ? t.get('all') : VocabularyWord.difficultyLabel(d)),
                selected: _difficultyFilter == d,
                onSelected: (v) => setState(() => _difficultyFilter = v ? d : 0),
                selectedColor: AppColors.primary.withAlpha(40),
                checkmarkColor: AppColors.primary));
          }).toList())),
        if (words.isNotEmpty) Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('${words.length} ${t.get('words_learned').split(' ').last.toLowerCase()}',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            TextButton.icon(icon: const Icon(Icons.stacked_bar_chart, size: 18),
              label: Text(t.get('flashcards')), onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => FlashcardScreen(words: words)));
              }),
          ])),
        Expanded(child: words.isEmpty ? Center(child: Text(t.get('no_data'),
          style: TextStyle(color: AppColors.textSecondary, fontSize: 16))) : ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: words.length, itemBuilder: (ctx, i) {
            final word = words[i];
            return Card(margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Container(width: 44, height: 44, alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
                  child: Text(VocabularyWord.difficultyLabel(word.difficulty),
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary))),
                title: Text(word.french, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                subtitle: Text('${word.english}  •  ${word.partOfSpeech}',
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => WordDetailScreen(word: word))),
              ));
          })),
      ]),
    );
  }
}
