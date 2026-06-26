import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../i18n/translations.dart';
import '../../services/audit_logger.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    final routeName = ModalRoute.of(context)?.settings.name ?? '/unknown';

    AuditLogger().logScreenView('NotFound', p: {'route': routeName});

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          AuditLogger().logBackPress('NotFound', handled: false);
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(t.get('app_name'))),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.error.withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.sentiment_dissatisfied_rounded,
                    size: 64, color: AppColors.error),
                ),
                const SizedBox(height: 32),
                Text('404',
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    height: 1,
                    letterSpacing: -2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(t.get('page_not_found'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(t.get('page_not_found_desc'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 36),
                ElevatedButton.icon(
                  onPressed: () {
                    AuditLogger().logButton('NotFound', 'GoHome');
                    Navigator.pushNamedAndRemoveUntil(
                      context, '/home', (_) => false);
                  },
                  icon: const Icon(Icons.home_rounded, size: 20),
                  label: Text(t.get('go_home')),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
