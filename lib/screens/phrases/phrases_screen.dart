
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../data/phrase_data.dart';
import '../../models/phrase.dart';
import '../../services/audit_logger.dart';
import '../../services/audio_service.dart';
import 'package:provider/provider.dart';
import 'conversation_screen.dart';

class PhrasesScreen extends StatelessWidget {
  const PhrasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    final t = Translations(Localizations.localeOf(context).languageCode);
    _logger.logScreenView('Phrases');

    if (PhraseData.conversations.isEmpty) {
      _logger.logEdge('Phrases', 'empty-conversations-list');
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.get('phrases'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height: 8),
        Text('Conversations', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        if (PhraseData.conversations.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(child: Text('No conversations available',
              style: TextStyle(color: AppColors.textSecondary))),
          )
        else
          ...PhraseData.conversations.map((conv) => Card(margin: const EdgeInsets.only(bottom: 10),
          child: ListTile(
            contentPadding: const EdgeInsets.all(14),
            leading: Container(width: 44, height: 44, alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.accent.withAlpha(30), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.chat, color: AppColors.accent)),
            title: Text(Localizations.localeOf(context).languageCode == 'fr' ? conv.titleFr : conv.titleEn,
              style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text(Localizations.localeOf(context).languageCode == 'fr' ? conv.scenarioFr : conv.scenarioEn,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _logger.logTap('Phrases', 'conversation:${conv.id}');
              _logger.logNavigate('Phrases', 'Conversation(${conv.id})', method: 'push');
              try {
                Navigator.push(context, MaterialPageRoute(
                  builder: (_) => ConversationScreen(conversation: conv)));
              } catch (e, stack) {
                _logger.logAsyncFail('Phrases', 'push-ConversationScreen', e, stack,
                    data: {'convId': conv.id});
              }
            },
          ))),
        const SizedBox(height: 20),
        ..._phraseSections(context),
      ]),
    );
  }

  List<Widget> _phraseSections(BuildContext context) {
    return [
      _section(context, 'Greetings', PhraseData.greetings),
      _section(context, 'Dining', PhraseData.dining),
      _section(context, 'Travel', PhraseData.travel),
      _section(context, 'Shopping', PhraseData.shopping),
      _section(context, 'Daily Life', PhraseData.daily),
      _section(context, 'Emergency', PhraseData.emergency),
    ];
  }

  Widget _section(BuildContext context, String title, List<Phrase> phrases) {
    final _logger = AuditLogger();
    if (phrases.isEmpty) {
      _logger.logEdge('Phrases', 'empty-section', data: {'section': title});
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
      const SizedBox(height: 8),
      if (phrases.isEmpty)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text('No phrases available',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        )
      else
        ...phrases.map((p) => Card(margin: const EdgeInsets.only(bottom: 6),
          child: ListTile(
            title: Text(p.french, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(p.english + (p.formality != null ? '  \u2022  ${p.formality}' : '')),
            onTap: () {
              _logger.logTap('Phrases', 'phrase:${p.french}', data: {'section': title, 'english': p.english});
            },
            trailing: IconButton(icon: const Icon(Icons.volume_up, size: 20),
              onPressed: () {
                _logger.logButton('Phrases', 'Audio:$title', data: {'text': p.french});
                try {
                  context.read<AudioService>().speak(p.french);
                } catch (e, stack) {
                  _logger.logAsyncFail('Phrases', 'audio-speak', e, stack,
                      data: {'section': title, 'text': p.french});
                }
              }),
          ))),
      const SizedBox(height: 16),
    ]);
  }
}
