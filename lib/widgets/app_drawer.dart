
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../i18n/translations.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    return Drawer(
      child: SafeArea(
        child: Column(children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primaryLight],
              begin: Alignment.topLeft, end: Alignment.bottomRight)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(height: 20),
              Container(padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withAlpha(40), shape: BoxShape.circle),
                child: const Icon(Icons.language, color: Colors.white, size: 36)),
              const SizedBox(height: 16),
              Text(t.get('app_name'), style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(t.get('app_tagline'), style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 13)),
            ]),
          ),
          _drawerItem(context, Icons.home, t.get('home'), '/', currentRoute),
          _drawerItem(context, Icons.menu_book, t.get('vocabulary'), '/vocabulary', currentRoute),
          _drawerItem(context, Icons.quiz, t.get('exam'), '/exam', currentRoute),
          _drawerItem(context, Icons.auto_stories, t.get('grammar'), '/grammar', currentRoute),
          _drawerItem(context, Icons.chat_bubble, t.get('phrases'), '/phrases', currentRoute),
          const Spacer(),
          const Divider(),
          _drawerItem(context, Icons.person, t.get('profile'), '/profile', currentRoute),
          _drawerItem(context, Icons.settings, t.get('settings'), '/settings', currentRoute),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  Widget _drawerItem(BuildContext context, IconData icon, String title, String route, String current) {
    final selected = route == current;
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
      title: Text(title, style: TextStyle(color: selected ? AppColors.primary : AppColors.textPrimary,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      selected: selected,
      selectedTileColor: AppColors.primary.withAlpha(15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: () {
        Navigator.pop(context);
        if (route != current) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
