import 'package:flutter/material.dart';
import 'package:french_app/models/vocab_item.dart';

class VocabCard extends StatelessWidget {
  final VocabItem item;
  final bool isFavorite;
  final bool isMastered;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final bool compact;

  const VocabCard({
    super.key,
    required this.item,
    this.isFavorite = false,
    this.isMastered = false,
    this.onTap,
    this.onFavoriteToggle,
    this.compact = false,
  });

  Color _posColor(String? pos, ThemeData theme) {
    switch (pos?.toLowerCase()) {
      case 'noun':
        return Colors.indigo;
      case 'verb':
        return Colors.teal;
      case 'adjective':
        return Colors.orange;
      case 'adverb':
        return Colors.pink;
      case 'expression':
        return Colors.deepPurple;
      case 'preposition':
        return Colors.blueGrey;
      case 'conjunction':
        return Colors.brown;
      default:
        return theme.colorScheme.secondary;
    }
  }

  IconData _posIcon(String? pos) {
    switch (pos?.toLowerCase()) {
      case 'noun':
        return Icons.label;
      case 'verb':
        return Icons.play_circle;
      case 'adjective':
        return Icons.palette;
      case 'adverb':
        return Icons.speed;
      case 'expression':
        return Icons.chat_bubble;
      default:
        return Icons.bookmark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final posColor = _posColor(item.partOfSpeech, theme);
    final frenchSize = compact ? 18.0 : 22.0;

    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          Feedback.forTap(context);
          onTap!();
        }
      },
      child: AnimatedScale(
        scale: 1.0,
        duration: const Duration(milliseconds: 200),
        child: Card(
          elevation: compact ? 1 : 2,
          shadowColor: theme.shadowColor.withOpacity(0.15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isMastered
                ? BorderSide(color: Colors.green.shade300, width: 1.2)
                : BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.25)),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  item.french,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontSize: frenchSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              if (isMastered) ...[
                                const SizedBox(width: 6),
                                Icon(Icons.check_circle, size: 18, color: Colors.green.shade500),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.english,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: compact ? 13 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (onFavoriteToggle != null)
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Feedback.forTap(context);
                          onFavoriteToggle!();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              key: ValueKey(isFavorite),
                              size: 22,
                              color: isFavorite ? Colors.red.shade400 : theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                if (item.pronunciation != null && item.pronunciation!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.pronunciation!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontStyle: FontStyle.italic,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                      fontSize: compact ? 11 : 12,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (item.partOfSpeech != null)
                      _ChipWidget(
                        icon: _posIcon(item.partOfSpeech),
                        label: item.partOfSpeech!,
                        color: posColor,
                        compact: compact,
                      ),
                    if (item.gender != null)
                      _ChipWidget(
                        icon: item.gender == 'masculine' ? Icons.male : Icons.female,
                        label: item.gender == 'masculine' ? 'm' : 'f',
                        color: item.gender == 'masculine' ? Colors.blue : Colors.pink,
                        compact: compact,
                      ),
                    if (!compact)
                      _ChipWidget(
                        icon: Icons.signal_cellular_alt,
                        label: item.level,
                        color: _levelColor(item.level, theme),
                        compact: compact,
                      ),
                  ],
                ),
                if (!compact && item.exampleSentence != null && item.exampleSentence!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.exampleSentence!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        if (item.exampleTranslation != null && item.exampleTranslation!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            item.exampleTranslation!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _levelColor(String level, ThemeData theme) {
    switch (level.toUpperCase()) {
      case 'A1':
        return Colors.green;
      case 'A2':
        return Colors.blue;
      case 'B1':
        return Colors.orange;
      case 'B2':
        return Colors.purple;
      default:
        return theme.colorScheme.secondary;
    }
  }
}

class _ChipWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool compact;

  const _ChipWidget({required this.icon, required this.label, required this.color, required this.compact});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 8, vertical: compact ? 2 : 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: compact ? 12 : 14, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 10 : 11,
            ),
          ),
        ],
      ),
    );
  }
}
