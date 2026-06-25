
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../i18n/translations.dart';

class CategoryCard extends StatelessWidget {
  final String categoryId;
  final String nameKey;
  final String iconName;
  final Color color;
  final int wordCount;
  final double progress;
  final VoidCallback onTap;

  const CategoryCard({super.key, required this.categoryId, required this.nameKey,
    required this.iconName, required this.color, required this.wordCount,
    required this.progress, required this.onTap});

  IconData _icon(String name) {
    switch (name) {
      case 'abc': return Icons.text_fields;
      case 'people': return Icons.people;
      case 'restaurant': return Icons.restaurant;
      case 'flight': return Icons.flight;
      case 'home': return Icons.home;
      case 'work': return Icons.work;
      case 'favorite': return Icons.favorite;
      case 'wb_sunny': return Icons.wb_sunny;
      case 'shopping_cart': return Icons.shopping_cart;
      case 'theater_comedy': return Icons.theater_comedy;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations(Localizations.localeOf(context).languageCode);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withAlpha(30), color.withAlpha(10)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withAlpha(40), borderRadius: BorderRadius.circular(12)),
                  child: Icon(_icon(iconName), color: color, size: 24)),
                const Spacer(),
                Text('$wordCount', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 14),
              Text(t.get(nameKey), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 10),
              ClipRRect(borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(value: progress, backgroundColor: color.withAlpha(30),
                  color: color, minHeight: 6)),
              const SizedBox(height: 6),
              Text('${(progress * 100).toInt()}% ${t.get('completed').toLowerCase()}',
                style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
        ),
      ),
    );
  }
}
