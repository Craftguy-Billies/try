
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/vocabulary.dart';
import '../../services/audit_logger.dart';
import '../../services/audio_service.dart';
import 'package:provider/provider.dart';

class WordDetailScreen extends StatelessWidget {
  final VocabularyWord word;
  const WordDetailScreen({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    _logger.logScreenView('WordDetail(${word.id})', p: {'word': word.french});

    // Log missing optional fields for auditing
    if (word.pronunciation == null) _logger.debug('WordDetail', 'no-pronunciation', data: {'id': word.id});
    if (word.exampleFrench == null) _logger.debug('WordDetail', 'no-example', data: {'id': word.id});
    if (word.gender == null) _logger.debug('WordDetail', 'no-gender', data: {'id': word.id});
    if (word.synonyms == null || word.synonyms!.isEmpty) _logger.debug('WordDetail', 'no-synonyms', data: {'id': word.id});

    return Scaffold(
      appBar: AppBar(title: Text(word.french)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const SizedBox(height: 20),
          Container(width: 100, height: 100,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])),
            child: Center(child: Text(VocabularyWord.difficultyLabel(word.difficulty),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)))),
          const SizedBox(height: 24),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(word.french, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
            const SizedBox(width: 12),
            IconButton.filled(onPressed: () {
              _logger.logButton('WordDetail', 'Audio:${word.french}');
              context.read<AudioService>().speak(word.french);
            },
              icon: const Icon(Icons.volume_up), style: IconButton.styleFrom(backgroundColor: AppColors.accent)),
          ]),
          if (word.pronunciation != null) ...[
            const SizedBox(height: 6),
            Text(word.pronunciation!, style: TextStyle(fontSize: 16, color: AppColors.textSecondary)),
          ],
          const SizedBox(height: 12),
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(20)),
            child: Text(word.partOfSpeech.toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600))),
          const SizedBox(height: 20),
          Card(child: Padding(padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _infoRow('Translation', word.english),
              if (word.gender != null) _infoRow('Gender', word.gender!),
              if (word.synonyms != null && word.synonyms!.isNotEmpty) _infoRow('Synonyms', word.synonyms!.join(', ')),
            ]))),
          if (word.exampleFrench != null) ...[
            const SizedBox(height: 16),
            Card(child: Padding(padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Example', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.primary)),
                const SizedBox(height: 8),
                Text(word.exampleFrench!, style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(word.exampleEnglish!, style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
              ]))),
          ],
        ]),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 80, child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))),
      ]));
  }
}
