
import 'package:flutter/material.dart';
import '../../services/audit_logger.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../home/home_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final progress = context.watch<UserProgressProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(t.get('profile'))),
      body: SingleChildScrollView(padding: const EdgeInsets.all(16),
        child: Column(children: [
          const SizedBox(height: 20),
          Container(width: 100, height: 100,
            decoration: BoxDecoration(shape: BoxShape.circle,
              gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryLight])),
            child: const Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 16),
          Text('Learner', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text('${t.get('level')}: ${t.get('beginner')}',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Card(child: Padding(padding: const EdgeInsets.all(20),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _bigStat('🔥 ${progress.currentStreak}', t.get('streak')),
                _bigStat('📚 ${progress.totalWordsLearned}', t.get('words_learned')),
                _bigStat('⏱ ${progress.totalMinutesPracticed}', t.get('minutes_practiced')),
              ]),
            ]))),
          const SizedBox(height: 20),
          _menuItem(Icons.language, t.get('language'),
            () => Navigator.pushNamed(context, '/settings')),
          _menuItem(Icons.info, t.get('about'), () {}),
        ])),
    );
  }

  Widget _bigStat(String value, String label) {
    return Column(children: [
      Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
      Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]);
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap) {
    return Card(margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(leading: Icon(icon, color: AppColors.primary), title: Text(title),
        trailing: const Icon(Icons.chevron_right), onTap: onTap));
  }
}
