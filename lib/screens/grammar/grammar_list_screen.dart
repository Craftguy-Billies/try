
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../data/grammar_data.dart';
import 'grammar_lesson_screen.dart';

class GrammarListScreen extends StatelessWidget {
  const GrammarListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    return Scaffold(
      appBar: AppBar(title: Text(t.get('grammar'))),
      body: ListView.builder(padding: const EdgeInsets.all(16),
        itemCount: GrammarData.lessons.length,
        itemBuilder: (ctx, i) {
          final lesson = GrammarData.lessons[i];
          return Card(margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(contentPadding: const EdgeInsets.all(16),
              leading: Container(width: 50, height: 50, alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(12)),
                child: Text('A$lesson.difficulty', style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary))),
              title: Text(Localizations.localeOf(context).languageCode == 'fr' ? lesson.titleFr : lesson.titleEn,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              subtitle: Text(Localizations.localeOf(context).languageCode == 'fr' ? lesson.descriptionFr : lesson.descriptionEn,
                style: TextStyle(color: AppColors.textSecondary)),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => GrammarLessonScreen(lesson: lesson)))));
        }),
    );
  }
}
