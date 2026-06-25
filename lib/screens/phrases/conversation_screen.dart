
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/phrase.dart';
import '../../services/audit_logger.dart';
import '../../services/audio_service.dart';
import 'package:provider/provider.dart';

class ConversationScreen extends StatelessWidget {
  final Conversation conversation;
  const ConversationScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    final isFr = Localizations.localeOf(context).languageCode == 'fr';
    _logger.logScreenView('Conversation(${conversation.id})', p: {'lines': conversation.lines.length});

    return Scaffold(
      appBar: AppBar(title: Text(isFr ? conversation.titleFr : conversation.titleEn)),
      body: Column(children: [
        Container(width: double.infinity, padding: const EdgeInsets.all(16),
          color: AppColors.primary.withAlpha(15),
          child: Text(isFr ? conversation.scenarioFr : conversation.scenarioEn,
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary, fontStyle: FontStyle.italic))),
        Expanded(child: ListView.builder(padding: const EdgeInsets.all(16),
          itemCount: conversation.lines.length,
          itemBuilder: (ctx, i) {
            final line = conversation.lines[i];
            return Padding(padding: const EdgeInsets.only(bottom: 16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(line.speaker, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.primary)),
                const SizedBox(height: 4),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(child: Container(padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(line.french, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(line.english, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    ]))),
                  const SizedBox(width: 4),
                  IconButton(icon: const Icon(Icons.volume_up, size: 20),
                    onPressed: () {
                      _logger.logButton('Conversation', 'Audio:line$i', data: {'speaker': line.speaker});
                      context.read<AudioService>().speak(line.french);
                    }),
                ]),
              ]));
          })),
      ]),
    );
  }
}
