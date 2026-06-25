
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/storage_service.dart';
import 'language_switch_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final lang = AppLanguage.fromCode(Localizations.localeOf(context).languageCode);

    return Scaffold(
      appBar: AppBar(title: Text(t.get('settings'))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const SizedBox(height: 8),
        Text('Preferences', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Card(child: ListTile(
          leading: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: Text(lang.flag, style: const TextStyle(fontSize: 20))),
          title: Text(t.get('language')),
          subtitle: Text('${lang.nativeName} (${lang.name})'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final changed = await Navigator.push<bool>(context,
              MaterialPageRoute(builder: (_) => const LanguageSwitchScreen()));
            if (changed == true && context.mounted) {
              // Router handles rebuild
            }
          })),
        Card(child: SwitchListTile(
          secondary: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.dark_mode, color: AppColors.primary)),
          title: Text(t.get('dark_mode')),
          value: false, onChanged: (_) {})),
        Card(child: SwitchListTile(
          secondary: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.notifications, color: AppColors.primary)),
          title: Text(t.get('notifications')),
          value: true, onChanged: (_) {})),
        const SizedBox(height: 24),
        Text('Data', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Card(child: ListTile(
          leading: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.error.withAlpha(30), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.delete, color: AppColors.error)),
          title: const Text('Clear All Data', style: TextStyle(color: AppColors.error)),
          subtitle: const Text('Reset all progress and settings'),
          onTap: () async {
            final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
              title: const Text('Clear All Data?'),
              content: const Text('This will permanently delete all your progress, scores, and settings.'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.get('cancel'))),
                TextButton(onPressed: () => Navigator.pop(ctx, true),
                  child: Text(t.get('delete'), style: const TextStyle(color: AppColors.error))),
              ],
            ));
            if (confirmed == true && context.mounted) {
              await StorageService().clearAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
              }
            }
          })),
      ]),
    );
  }
}
