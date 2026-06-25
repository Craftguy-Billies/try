
import 'package:flutter/material.dart';
import '../../services/audit_logger.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/storage_service.dart';
import '../../app.dart';

class LanguageSwitchScreen extends StatelessWidget {
  const LanguageSwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _logger = AuditLogger(); _logger.logScreenView('LanguageSwitch'); final t = Translations(Localizations.localeOf(context).languageCode);
    final current = Localizations.localeOf(context).languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(t.get('language'))),
      body: ListView.builder(padding: const EdgeInsets.all(16),
        itemCount: AppLanguage.supported.length,
        itemBuilder: (ctx, i) {
          final lang = AppLanguage.supported[i];
          final selected = lang.code == current;
          return Card(margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Text(lang.flag, style: const TextStyle(fontSize: 28)),
              title: Text(lang.nativeName, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
              subtitle: Text(lang.name),
              trailing: selected ? const Icon(Icons.check_circle, color: AppColors.success) : null,
              onTap: selected ? null : () {
                _logger.logTap('LanguageSwitch', '${lang.code}');
                _logger.logNavigate('LanguageSwitch', 'app.changeLanguage(${lang.code})', method: 'callback');
                StorageService().setLanguage(lang.code);
                final appState = FrenchLearnApp.of(context);
                if (appState == null) {
                  _logger.logEdge('LanguageSwitch', 'FrenchLearnApp.of(context) is null — cannot change language');
                  _logger.logRecover('LanguageSwitch', 'language change aborted — no ancestor state');
                  return;
                }
                appState.changeLanguage(lang.code);
                Navigator.pop(context, true);
              },
            ));
        }),
    );
  }
}
