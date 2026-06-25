
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/audit_logger.dart';
import '../../services/exam_service.dart';
import 'exam_quiz_screen.dart';

class ExamHomeScreen extends StatelessWidget {
  const ExamHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    final t = Translations(Localizations.localeOf(context).languageCode);
    _logger.logScreenView('ExamHome');
    if (ExamService.configs.isEmpty) {
      _logger.logEdge('ExamHome', 'empty-exam-configs');
    }

    return Scaffold(
      appBar: AppBar(title: Text(t.get('exam'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Container(padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(colors: [AppColors.accent, AppColors.accentLight])),
          child: Column(children: [
            const Icon(Icons.quiz, color: Colors.white, size: 48),
            const SizedBox(height: 12),
            const Text('DELF/DALF', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white)),
            const SizedBox(height: 4),
            Text(t.get('exam'), style: TextStyle(fontSize: 14, color: Colors.white.withAlpha(200))),
          ])),
        const SizedBox(height: 20),
        if (ExamService.configs.isEmpty)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Center(child: Text(t.get('no_data'),
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary))),
          )
        else
          ...ExamService.configs.map((config) => Card(margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Container(width: 50, height: 50, alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(12)),
              child: Text(config.level.split(' ')[0], style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.primary, fontSize: 18))),
            title: Text(config.level, style: const TextStyle(fontWeight: FontWeight.w700)),
            subtitle: Text('${config.questionCount} questions • ${config.timeMinutes} min • ${config.passingScore}% ${t.get('passed').toLowerCase()}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              _logger.logButton('ExamHome', 'Select:${config.level}');
              _logger.logNavigate('ExamHome', 'ExamQuiz(${config.level})', method: 'push');
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ExamQuizScreen(config: config)));
            },
          ))),
      ]),
    );
  }
}
