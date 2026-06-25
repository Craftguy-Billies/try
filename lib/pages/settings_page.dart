import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../state/french_state.dart';
import 'onboarding_page.dart';

import '../i18n/app_localizations.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppState _app = AppState();
  final FrenchState _french = FrenchState();
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: _app.displayName);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _app,
      builder: (context, _) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileSection(theme, l10n),
              const SizedBox(height: 20),
              _buildLanguageSection(theme, l10n),
              const SizedBox(height: 20),
              _buildThemeSection(theme, l10n),
              const SizedBox(height: 20),
              _buildDailyGoalSection(theme, l10n),
              const SizedBox(height: 20),
              _buildDebugSection(theme, l10n),
              const SizedBox(height: 20),
              _buildAboutSection(theme, l10n),
              const SizedBox(height: 20),
              _buildResetSection(theme, l10n),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildProfileSection(ThemeData theme, AppLocalizations l10n) {
    final initials = _app.displayName.isNotEmpty
        ? _app.displayName
            .split(RegExp(r'\s+'))
            .where((s) => s.isNotEmpty)
            .take(2)
            .map((s) => s[0].toUpperCase())
            .join()
        : '?';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: l10n.displayName,
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        onSubmitted: (v) {
                          _app.setDisplayName(v.trim());
                          HapticFeedback.lightImpact();
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${l10n.level} ${_app.level} · ${_app.totalXP} ${l10n.totalXP}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface
                              .withAlpha(150),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(ThemeData theme, AppLocalizations l10n) {
    final langData = {
      'en': ('English', '🇬🇧'),
      'zh': ('中文', '🇨🇳'),
      'ja': ('日本語', '🇯🇵'),
      'ko': ('한국어', '🇰🇷'),
      'es': ('Español', '🇪🇸'),
      'fr': ('Français', '🇫🇷'),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.language, theme),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 2.8,
              children: AppState.supportedLocales.map((loc) {
                final code = loc.languageCode;
                final data = langData[code]!;
                final isSelected =
                    _app.locale.languageCode == code;
                return GestureDetector(
                  onTap: () {
                    _app.setLocale(loc);
                    HapticFeedback.selectionClick();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary.withAlpha(30)
                          : theme
                              .colorScheme.surfaceContainerHighest
                              .withAlpha(80),
                      borderRadius:
                          BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(data.$2,
                            style:
                                const TextStyle(fontSize: 22)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            data.$1,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              fontSize: 13,
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme
                                      .colorScheme.onSurface,
                            ),
                            overflow:
                                TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThemeSection(ThemeData theme, AppLocalizations l10n) {
    final isDark = _app.themeMode == ThemeMode.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.theme, theme),
        Card(
          child: SwitchListTile(
            title: Text(
              isDark ? l10n.darkTheme : l10n.lightTheme,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              isDark ? l10n.reduceEyeStrain : l10n.brightAndClear,
              style: theme.textTheme.bodySmall,
            ),
            secondary: Icon(
              isDark
                  ? Icons.dark_mode_rounded
                  : Icons.light_mode_rounded,
              color: isDark ? Colors.amber : Colors.orange,
            ),
            value: isDark,
            onChanged: (v) {
              _app.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
              HapticFeedback.lightImpact();
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyGoalSection(ThemeData theme, AppLocalizations l10n) {
    final goal = _app.dailyGoal;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.dailyGoal, theme),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.flag_rounded,
                            size: 22,
                            color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(l10n.dailyGoal,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary
                            .withAlpha(25),
                        borderRadius:
                            BorderRadius.circular(20),
                      ),
                      child: Text(
                        '$goal ${l10n.wordsLearned.split(' ').last}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor:
                        theme.colorScheme.primary,
                    inactiveTrackColor: theme
                        .colorScheme.surfaceContainerHighest,
                    thumbColor: theme.colorScheme.primary,
                    overlayColor: theme.colorScheme.primary
                        .withAlpha(40),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: goal.toDouble(),
                    min: 5,
                    max: 50,
                    divisions: 9,
                    label: '$goal',
                    onChanged: (v) {
                      _app.setDailyGoal(v.round());
                    },
                    onChangeEnd: (_) =>
                        HapticFeedback.lightImpact(),
                  ),
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    Text('5',
                        style: TextStyle(
                            fontSize: 11,
                            color: theme
                                .colorScheme.onSurface
                                .withAlpha(120))),
                    Text('50',
                        style: TextStyle(
                            fontSize: 11,
                            color: theme
                                .colorScheme.onSurface
                                .withAlpha(120))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDebugSection(ThemeData theme, AppLocalizations l10n) {
    final isDebug = _app.debugMode;
    final logCount = _app.logs.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.debugCapitalized, theme),
        Card(
          child: Column(
            children: [
              SwitchListTile(
                title: Text(l10n.debugLogs,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600)),
                subtitle: Text(
                    '$logCount ${l10n.debugLogs.toLowerCase()}',
                    style: theme.textTheme.bodySmall),
                secondary: Icon(
                  Icons.bug_report_rounded,
                  color: isDebug
                      ? const Color(0xFFFF9800)
                      : theme.colorScheme.onSurface
                          .withAlpha(100),
                ),
                value: isDebug,
                onChanged: (v) {
                  _app.setDebugMode(v);
                  HapticFeedback.lightImpact();
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          HapticFeedback.mediumImpact();
                          _showLogsDialog(theme, l10n);
                        },
                        icon: const Icon(
                            Icons.list_alt_rounded,
                            size: 18),
                        label: Text(l10n.viewLogs,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      onPressed: () {
                        _app.clearLogs();
                        HapticFeedback.mediumImpact();
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(l10n.clearLogs),
                            behavior: SnackBarBehavior
                                .floating,
                          ),
                        );
                      },
                      icon: const Icon(
                          Icons.delete_outline_rounded,
                          size: 18,
                          color: Color(0xFFF44336)),
                      label: Text(l10n.clearLogs,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color:
                                  Color(0xFFF44336))),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10)),
                        side: const BorderSide(
                            color: Color(0xFFF44336)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  void _showLogsDialog(ThemeData theme, AppLocalizations l10n) {
    final logs = _app.logs.reversed.take(100).toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.list_alt_rounded, size: 20),
              const SizedBox(width: 8),
              Text(l10n.debugLogsTitle,
                  style:
                      const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.6,
            child: logs.isEmpty
                ? Center(child: Text(l10n.noLogEntries))
                : ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final log = logs[i];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: log.color,
                          ),
                        ),
                        title: Text(log.message,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    FontWeight.w600)),
                        subtitle: Text(
                          '${log.formattedTime} · ${log.category}',
                          style: TextStyle(
                              fontSize: 11,
                              color: theme
                                  .colorScheme.onSurface
                                  .withAlpha(120)),
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.closeCapitalized),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutSection(ThemeData theme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(l10n.about, theme),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF1A237E),
                            Color(0xFF3949AB)
                          ],
                        ),
                      ),
                      child: const Center(
                        child: Text('🇫🇷',
                            style: TextStyle(fontSize: 22)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text('French Learn',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 17)),
                        Text(l10n.appVersion,
                            style: theme
                                .textTheme.bodySmall
                                ?.copyWith(
                              color: theme
                                  .colorScheme.onSurface
                                  .withAlpha(140),
                            )),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.aboutDescription,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: theme.colorScheme.onSurface
                        .withAlpha(180),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetSection(ThemeData theme, AppLocalizations l10n) {
    return Card(
      color: const Color(0xFFF44336).withAlpha(12),
      child: ListTile(
        leading: const Icon(
          Icons.warning_rounded,
          color: Color(0xFFF44336),
        ),
        title: Text(
          l10n.resetProgress,
          style: const TextStyle(
            color: Color(0xFFF44336),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          l10n.resetWarning,
          style: theme.textTheme.bodySmall?.copyWith(
            color:
                theme.colorScheme.onSurface.withAlpha(120),
          ),
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () => _showResetConfirm(theme, l10n),
      ),
    );
  }

  void _showResetConfirm(ThemeData theme, AppLocalizations l10n) {
    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.warning_rounded,
                  color: Color(0xFFF44336)),
              const SizedBox(width: 8),
              Text(l10n.resetConfirmTitle),
            ],
          ),
          content: Text(l10n.resetConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                await _app.resetAll();
                _french.resetAll();
                if (mounted) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const OnboardingPage()),
                    (route) => false,
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFF44336),
              ),
              child: Text(l10n.resetProgress,
                  style:
                      const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        );
      },
    );
  }
}
