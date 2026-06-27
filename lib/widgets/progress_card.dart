
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../i18n/translations.dart';
import '../services/audit_logger.dart';

class ProgressCard extends StatelessWidget {
  final int wordsLearned;
  final int streak;
  final int minutesPracticed;
  final int dailyGoal;

  const ProgressCard({super.key, required this.wordsLearned, required this.streak,
    required this.minutesPracticed, required this.dailyGoal});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final _logger = AuditLogger();
    _logger.logScreenView('Home.ProgressCard', p: {
      'words': wordsLearned, 'streak': streak,
      'minutes': minutesPracticed, 'goal': dailyGoal,
    });
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft, end: Alignment.bottomRight,
          ),
        ),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            _stat(context, Icons.menu_book, '$wordsLearned', t.get('words_learned')),
            _stat(context, Icons.local_fire_department, '$streak', t.get('streak')),
            _stat(context, Icons.timer, '$minutesPracticed', t.get('minutes_practiced')),
            _stat(context, Icons.flag, '$dailyGoal', t.get('daily_goal')),
          ]),
          const SizedBox(height: 16),
          ClipRRect(borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: dailyGoal > 0 ? (wordsLearned / dailyGoal).clamp(0.0, 1.0) : 0.0,
              backgroundColor: Colors.white.withAlpha(60),
              color: AppColors.accent, minHeight: 8)),
        ]),
      ),
    );
  }

  Widget _stat(BuildContext context, IconData icon, String value, String label) {
    final _logger = AuditLogger();
    return GestureDetector(
      onTap: () {
        _logger.logTap('ProgressCard', 'Stat:$label', data: {'value': value});
      },
      child: Column(children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
        Text(label, style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 11)),
      ]),
    );
  }
}
