import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/providers/locale_provider.dart';
import 'package:french_app/providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _dailyReminder = false;
  bool _soundEffects = true;
  bool _isLoading = true;

  static const Map<String, String> _flagEmoji = {
    'en': '🇬🇧',
    'es': '🇪🇸',
    'fr': '🇫🇷',
    'de': '🇩🇪',
    'zh': '🇨🇳',
    'ja': '🇯🇵',
    'ko': '🇰🇷',
    'pt': '🇧🇷',
    'ar': '🇸🇦',
    'hi': '🇮🇳',
    'it': '🇮🇹',
    'ru': '🇷🇺',
  };

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('SettingsScreen');
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _dailyReminder = prefs.getBool('daily_reminder') ?? false;
      _soundEffects = prefs.getBool('sound_effects') ?? true;
      _isLoading = false;
    });
  }

  Future<void> _setDailyReminder(bool value) async {
    DebugLogger.logAction('toggle_daily_reminder', details: {'value': value});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('daily_reminder', value);
    setState(() => _dailyReminder = value);
  }

  Future<void> _setSoundEffects(bool value) async {
    DebugLogger.logAction('toggle_sound_effects', details: {'value': value});
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_effects', value);
    setState(() => _soundEffects = value);
  }

  void _showLanguagePicker(AppLocalizations i18n, ThemeData theme, LocaleProvider localeProvider) {
    DebugLogger.logAction('open_language_picker');
    final locales = localeProvider.supportedLocales;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: theme.colorScheme.outlineVariant, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              Text(i18n.settingsLanguage, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(i18n.settingsLanguageDesc, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: locales.length,
                  itemBuilder: (_, index) {
                    final locale = locales[index];
                    final code = locale.languageCode;
                    final flag = _flagEmoji[code] ?? '🌐';
                    final isSelected = localeProvider.currentLocale.languageCode == code;
                    final nameInOwn = AppLocalizations.localizedLabels[code] ?? code;
                    return ListTile(
                      leading: Text(flag, style: const TextStyle(fontSize: 28)),
                      title: Text(nameInOwn, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                      trailing: isSelected ? Icon(Icons.check, color: theme.colorScheme.primary) : null,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      onTap: () {
                        DebugLogger.logAction('select_language', details: {'locale': code});
                        localeProvider.setLocale(locale);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showResetDialog(AppLocalizations i18n, ThemeData theme, ProgressProvider progressProvider) {
    DebugLogger.logAction('show_reset_dialog');
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: theme.colorScheme.error, size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(i18n.settingsResetTitle, style: theme.textTheme.titleMedium)),
          ],
        ),
        content: Text(i18n.settingsResetMessage, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(i18n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
            onPressed: () {
              DebugLogger.logAction('reset_progress');
              progressProvider.resetProgress();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      Icon(Icons.check_circle, color: theme.colorScheme.onError),
                      const SizedBox(width: 12),
                      Text(i18n.settingsResetConfirm, style: TextStyle(color: theme.colorScheme.onError)),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: theme.colorScheme.error,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text(i18n.confirm),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(i18n.settingsTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(i18n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader(i18n.profileAppearance, Icons.palette_outlined, theme),
          const SizedBox(height: 8),
          _buildThemeSelector(i18n, theme),
          const SizedBox(height: 24),

          _buildSectionHeader(i18n.profileLanguage, Icons.translate, theme),
          const SizedBox(height: 8),
          _buildLanguageSelector(i18n, theme),
          const SizedBox(height: 24),

          _buildSectionHeader(i18n.profileLearning, Icons.psychology_outlined, theme),
          const SizedBox(height: 8),
          _buildLearningToggles(i18n, theme),
          const SizedBox(height: 24),

          _buildSectionHeader(i18n.profileData, Icons.storage_outlined, theme),
          const SizedBox(height: 8),
          _buildResetButton(i18n, theme),
          const SizedBox(height: 24),

          _buildSectionHeader(i18n.profileAbout, Icons.info_outline, theme),
          const SizedBox(height: 8),
          _buildAboutSection(i18n, theme),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(AppLocalizations i18n, ThemeData theme) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        final currentMode = themeProvider.themeMode;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                _ThemeChip(
                  icon: Icons.light_mode,
                  label: i18n.settingsThemeLight,
                  selected: currentMode == ThemeMode.light,
                  onTap: () {
                    DebugLogger.logAction('set_theme', details: {'mode': 'light'});
                    themeProvider.setThemeMode(ThemeMode.light);
                  },
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  icon: Icons.dark_mode,
                  label: i18n.settingsThemeDark,
                  selected: currentMode == ThemeMode.dark,
                  onTap: () {
                    DebugLogger.logAction('set_theme', details: {'mode': 'dark'});
                    themeProvider.setThemeMode(ThemeMode.dark);
                  },
                  theme: theme,
                ),
                const SizedBox(width: 8),
                _ThemeChip(
                  icon: Icons.settings_brightness,
                  label: i18n.settingsThemeSystem,
                  selected: currentMode == ThemeMode.system,
                  onTap: () {
                    DebugLogger.logAction('set_theme', details: {'mode': 'system'});
                    themeProvider.setThemeMode(ThemeMode.system);
                  },
                  theme: theme,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageSelector(AppLocalizations i18n, ThemeData theme) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final code = localeProvider.currentLocale.languageCode;
        final flag = _flagEmoji[code] ?? '🌐';
        final name = AppLocalizations.localizedLabels[code] ?? code;
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
              child: Text(flag, style: const TextStyle(fontSize: 26)),
            ),
            title: Text(name, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
            subtitle: Text(i18n.settingsLanguageDesc, style: theme.textTheme.bodySmall),
            trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onTap: () => _showLanguagePicker(i18n, theme, localeProvider),
          ),
        );
      },
    );
  }

  Widget _buildLearningToggles(AppLocalizations i18n, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.notifications_active_outlined, color: theme.colorScheme.onTertiaryContainer, size: 22),
            ),
            title: Text(i18n.settingsDailyReminder, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            value: _dailyReminder,
            onChanged: _setDailyReminder,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          Divider(height: 1, indent: 68, endIndent: 16, color: theme.colorScheme.outlineVariant.withOpacity(0.2)),
          SwitchListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            secondary: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.volume_up_outlined, color: theme.colorScheme.onSecondaryContainer, size: 22),
            ),
            title: Text(i18n.settingsSoundEffects, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            value: _soundEffects,
            onChanged: _setSoundEffects,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }

  Widget _buildResetButton(AppLocalizations i18n, ThemeData theme) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.delete_forever, color: theme.colorScheme.onErrorContainer, size: 22),
            ),
            title: Text(i18n.settingsResetProgress, style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error, fontWeight: FontWeight.w600)),
            subtitle: Text(i18n.settingsResetConfirm, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error.withOpacity(0.7))),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onTap: () => _showResetDialog(i18n, theme, progressProvider),
          ),
        );
      },
    );
  }

  Widget _buildAboutSection(AppLocalizations i18n, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.info_outline, color: theme.colorScheme.onPrimaryContainer, size: 22),
            ),
            title: Text(i18n.settingsAboutApp, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            onTap: () {
              DebugLogger.logAction('view_about');
              showAboutDialog(
                context: context,
                applicationName: i18n.appTitle,
                applicationVersion: '1.0.0',
                applicationLegalese: i18n.translate('settings_credits'),
                children: [
                  const SizedBox(height: 12),
                  Text(i18n.appTagline, style: theme.textTheme.bodyMedium),
                ],
              );
            },
          ),
          Divider(height: 1, indent: 68, endIndent: 16, color: theme.colorScheme.outlineVariant.withOpacity(0.2)),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.tag, color: theme.colorScheme.onTertiaryContainer, size: 22),
            ),
            title: Text(i18n.settingsVersion, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Text('1.0.0', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600)),
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeData theme;

  const _ThemeChip({required this.icon, required this.label, required this.selected, required this.onTap, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
            border: Border.all(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              width: selected ? 2 : 0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: selected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant, size: 24),
              const SizedBox(height: 6),
              Text(label, style: theme.textTheme.labelSmall?.copyWith(
                color: selected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              )),
            ],
          ),
        ),
      ),
    );
  }
}

