
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../models/exam_question.dart';
import '../../services/audit_logger.dart';

class ExamResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final int correct;
  final ExamConfig config;
  final List<ExamQuestion> questions;
  final Map<int, String> answers;

  const ExamResultScreen({super.key, required this.score, required this.total,
    required this.correct, required this.config, required this.questions, required this.answers});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger();
    final t = Translations(Localizations.localeOf(context).languageCode);
    final passed = score >= config.passingScore;

    _logger.logScreenView('ExamResult(${config.level})', p: {
      'score': score, 'correct': correct, 'total': total, 'passed': passed,
    });

    return Scaffold(
      appBar: AppBar(title: Text(t.get('exam_result')), automaticallyImplyLeading: false),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 20),
          Container(width: 150, height: 150,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: LinearGradient(colors: passed ? [AppColors.success, AppColors.success.withAlpha(180)] : [AppColors.error, AppColors.error.withAlpha(180)])),
            child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(t.get(passed ? 'passed' : 'failed'), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
              Text('$score%', style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white)),
            ]))),
          const SizedBox(height: 24),
          Card(child: Padding(padding: const EdgeInsets.all(20),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _stat(t.get('score'), '$score%', AppColors.primary),
              _stat(t.get('correct'), '$correct/$total', AppColors.success),
              _stat(t.get('total_questions'), '$total', AppColors.accent),
            ]))),
          const SizedBox(height: 16),
          SizedBox(height: 200, child: PieChart(PieChartData(
            sections: [
              PieChartSectionData(value: correct.toDouble(), title: '${(correct/total*100).round()}%', color: AppColors.success, radius: 50, titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              PieChartSectionData(value: (total - correct).toDouble(), color: AppColors.error.withAlpha(150), radius: 40),
            ], centerSpaceRadius: 30))),
          const SizedBox(height: 20),
          SizedBox(width: double.infinity, child: ElevatedButton(
            onPressed: () {
              _logger.logButton('ExamResult', 'Home');
              Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(t.get('home'), style: const TextStyle(fontSize: 16)))),
          const SizedBox(height: 12),
          TextButton(onPressed: () {
            _logger.logButton('ExamResult', 'Review');
            _logger.logEdge('ExamResult', 'review-button — pops to exam home, not back to quiz');
            Navigator.pop(context);
          },
            child: Text(t.get('review') + ' ' + t.get('flashcards').toLowerCase())),
        ])),
    );
  }

  Widget _stat(String label, String value, Color color) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
    ]);
  }
}
