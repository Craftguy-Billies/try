
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/audit_logger.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/storage_service.dart';
import '../../app.dart';
import '../home/home_screen.dart';
import 'language_switch_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _logger = AuditLogger();
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  bool _loaded = false;
  bool _clearing = false;

  @override
  void initState() {
    super.initState();
    _logger.logInit('Settings');
    _logger.logScreenView('Settings');
    _loadPreferences();
  }

  @override
  void dispose() {
    _logger.logDispose('Settings', data: {
      'darkMode': _darkMode, 'notifications': _notificationsEnabled,
      'clearing': _clearing,
    });
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    _logger.logAsyncStart('Settings', 'loadPreferences');
    try {
      final dark = await StorageService().getDarkMode();
      final notif = await StorageService().getNotificationsEnabled();
      if (mounted) {
        setState(() {
          _darkMode = dark;
          _notificationsEnabled = notif;
          _loaded = true;
        });
        _logger.logAsyncDone('Settings', 'loadPreferences', data: {
          'darkMode': _darkMode, 'notifications': _notificationsEnabled,
        });
      } else {
        _logger.logEdge('Settings', 'not-mounted-after-loadPreferences');
      }
    } catch (e, stack) {
      _logger.logAsyncFail('Settings', 'loadPreferences', e, stack);
      _logger.logRecover('Settings', 'pref load failed — using defaults');
      if (mounted) setState(() => _loaded = true);
    }
  }

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
            _logger.logTap('Settings', 'Language');
            final changed = await Navigator.push<bool>(context,
              MaterialPageRoute(builder: (_) => const LanguageSwitchScreen()));
            if (changed == true && context.mounted) {
              _logger.logEdge('Settings', 'language changed — app rebuilds via router');
              setState(() {}); // Force rebuild to reflect new language in subtitle
            }
          })),
        Card(child: SwitchListTile(
          secondary: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.dark_mode, color: AppColors.primary)),
          title: Text(t.get('dark_mode')),
          value: _darkMode,
          onChanged: _loaded ? (v) {
            _logger.logToggle('Settings', 'darkMode', v, data: {'was': _darkMode});
            setState(() => _darkMode = v);
            StorageService().setDarkMode(v).catchError((e, stack) {
              _logger.logAsyncFail('Settings', 'setDarkMode-persist', e, stack);
            });
            // Notify app to rebuild with new theme
            final appState = FrenchLearnApp.of(context);
            if (appState != null) {
              _logger.logEdge('Settings', 'dark mode toggle — app rebuild needed');
              appState.setState(() {});
            }
          } : null)),
        Card(child: SwitchListTile(
          secondary: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.primary.withAlpha(20), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.notifications, color: AppColors.primary)),
          title: Text(t.get('notifications')),
          value: _notificationsEnabled,
          onChanged: _loaded ? (v) {
            _logger.logToggle('Settings', 'notifications', v, data: {'was': _notificationsEnabled});
            setState(() => _notificationsEnabled = v);
            StorageService().setNotificationsEnabled(v).catchError((e, stack) {
              _logger.logAsyncFail('Settings', 'setNotificationsEnabled-persist', e, stack);
            });
          } : null)),
        const SizedBox(height: 24),
        Text('Data', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
        const SizedBox(height: 8),
        Card(child: ListTile(
          leading: Container(width: 40, height: 40, alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.error.withAlpha(30), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.delete, color: AppColors.error)),
          title: const Text('Clear All Data', style: TextStyle(color: AppColors.error)),
          subtitle: const Text('Reset all progress and settings'),
          onTap: _clearing ? null : () async {
            _logger.logTap('Settings', 'ClearAllData');
            _logger.logDialogShow('ClearDataConfirm', 'Settings');
            final confirmed = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
              title: const Text('Clear All Data?'),
              content: const Text('This will permanently delete all your progress, scores, and settings.'),
              actions: [
                TextButton(onPressed: () { _logger.logDialogResult('ClearDataConfirm', 'cancel'); Navigator.pop(ctx, false); }, child: Text(t.get('cancel'))),
                TextButton(onPressed: () { _logger.logDialogResult('ClearDataConfirm', 'confirm'); Navigator.pop(ctx, true); },
                  child: Text(t.get('delete'), style: const TextStyle(color: AppColors.error))),
              ],
            ));
            if (confirmed == true && context.mounted) {
              _clearing = true;
              _logger.logUserAction('ClearAllData confirmed');
              try {
                await context.read<UserProgressProvider>().resetAll();
              } catch (e, stack) {
                _logger.logAsyncFail('Settings', 'resetAll-failed', e, stack);
              }
              _clearing = false;
              if (context.mounted) {
                setState(() { _darkMode = false; _notificationsEnabled = true; });
                try {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
                  _logger.debug('Settings', 'ClearAllData snackbar shown');
                } catch (e, stack) {
                  _logger.logAsyncFail('Settings', 'showSnackBar', e, stack);
                }
              }
            }
          })),
      ]),
    );
  }
}
