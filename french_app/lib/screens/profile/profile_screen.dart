import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:french_app/debug/debug_logger.dart';
import 'package:french_app/i18n/app_localizations.dart';
import 'package:french_app/providers/progress_provider.dart';
import 'package:french_app/data/french_vocab.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  String _learningGoal = 'daily';
  bool _isLoading = true;

  static const _goalKeys = ['daily', 'exam', 'travel', 'work', 'casual'];

  @override
  void initState() {
    super.initState();
    DebugLogger.logScreenView('ProfileScreen');
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _learningGoal = prefs.getString('learning_goal') ?? 'daily';
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    DebugLogger.logAction('save_profile', details: {
      'name': _nameController.text,
      'email': _emailController.text,
      'goal': _learningGoal,
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', _nameController.text.trim());
    await prefs.setString('user_email', _emailController.text.trim());
    await prefs.setString('learning_goal', _learningGoal);

    if (!mounted) return;
    final i18n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(i18n.profileSaved, style: const TextStyle(fontSize: 16)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  static final Map<String, _GoalInfo> _goals = {
    'daily': _GoalInfo(Icons.repeat, 'profile_goal_daily', 'Practice a little every day to build a consistent habit.'),
    'exam': _GoalInfo(Icons.school, 'profile_goal_exam', 'Prepare systematically for DELF A1 through B2 certification.'),
    'travel': _GoalInfo(Icons.flight, 'profile_goal_travel', 'Learn practical French for your next trip to France.'),
    'work': _GoalInfo(Icons.business, 'profile_goal_work', 'Build professional French skills for career advancement.'),
    'casual': _GoalInfo(Icons.casino, 'profile_goal_casual', 'Learn at your own pace without pressure.'),
  };

  String _userInitials() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return '';
    final parts = name.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  static const _levelColors = {
    'A1': Colors.green,
    'A2': Colors.blue,
    'B1': Colors.orange,
    'B2': Colors.purple,
  };

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(i18n.profileTitle)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: true,
            title: Text(i18n.profileTitle),
            actions: [
              TextButton.icon(
                onPressed: _saveProfile,
                icon: const Icon(Icons.save),
                label: Text(i18n.profileSave),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _buildProfileHeader(i18n, theme)),
          SliverToBoxAdapter(child: _buildGoalSection(i18n, theme)),
          SliverToBoxAdapter(child: _buildStatsSection(i18n, theme)),
          SliverToBoxAdapter(child: _buildLevelProgressSection(i18n, theme)),
          SliverToBoxAdapter(child: _buildCategoryProgressSection(i18n, theme)),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations i18n, ThemeData theme) {
    final initials = _userInitials();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: initials.isNotEmpty
                ? Text(initials, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer))
                : Icon(Icons.person, size: 44, color: theme.colorScheme.onPrimaryContainer),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: i18n.profileName,
              hintText: i18n.profileNameHint,
              prefixIcon: const Icon(Icons.badge_outlined),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: i18n.profileEmail,
              prefixIcon: const Icon(Icons.email_outlined),
              filled: true,
              fillColor: theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalSection(AppLocalizations i18n, ThemeData theme) {
    final currentGoal = _goals[_learningGoal] ?? _goals['daily']!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.flag_circle, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(i18n.profileLearningGoal, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _showGoalPicker(i18n, theme),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                    color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(currentGoal.icon, color: theme.colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(i18n.translate(currentGoal.labelKey), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(currentGoal.description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurfaceVariant),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalPicker(AppLocalizations i18n, ThemeData theme) {
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
              Text(i18n.profileLearningGoal, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              ..._goalKeys.map((key) {
                final goal = _goals[key]!;
                final selected = _learningGoal == key;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      DebugLogger.logAction('select_goal', details: {'goal': key});
                      setState(() => _learningGoal = key);
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: selected ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest.withOpacity(0.3),
                        border: selected ? Border.all(color: theme.colorScheme.primary) : null,
                      ),
                      child: Row(
                        children: [
                          Icon(goal.icon, color: selected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurfaceVariant),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(i18n.translate(goal.labelKey), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                Text(goal.description, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          if (selected) Icon(Icons.check_circle, color: theme.colorScheme.primary),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsSection(AppLocalizations i18n, ThemeData theme) {
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final p = progressProvider.progress;
        final overall = progressProvider.getOverallProgress();

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(i18n.profileStats, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _StatCard(icon: Icons.menu_book_rounded, label: i18n.profileTotalLearned, value: p.totalWordsLearned.toString(), color: Colors.teal, theme: theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(icon: Icons.replay_rounded, label: i18n.profileTotalReviewed, value: p.totalWordsReviewed.toString(), color: Colors.indigo, theme: theme)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: _StatCard(icon: Icons.local_fire_department, label: i18n.profileCurrentStreak, value: '🔥 ${p.currentStreak}', color: Colors.deepOrange, theme: theme)),
                  const SizedBox(width: 10),
                  Expanded(child: _StatCard(icon: Icons.emoji_events, label: i18n.profileLongestStreak, value: '🏆 ${p.longestStreak}', color: Colors.amber.shade700, theme: theme)),
                ],
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(i18n.profileOverallProgress, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                          Text('${(overall * 100).toInt()}%', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.primary)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: overall,
                          minHeight: 8,
                          backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLevelProgressSection(AppLocalizations i18n, ThemeData theme) {
    final levels = getLevels();
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final allVocab = getAllVocab();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.trending_up, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(i18n.profileLevelProgress, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              ...levels.map((level) {
                final color = _levelColors[level] ?? theme.colorScheme.primary;
                final total = allVocab.where((v) => v.level == level).length;
                final mastered = progressProvider.getProgressForLevel(level);
                final ratio = total > 0 ? (mastered / total).clamp(0.0, 1.0) : 0.0;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(i18n.translate('level_${level.toLowerCase()}'), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                              Text(i18n.profileWords.replaceAll('{mastered}', '$mastered').replaceAll('{total}', '$total'), style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: ratio,
                              minHeight: 8,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  static const _categoryKeyMap = {
    'Greetings & Politeness': 'cat_greetings',
    'Family & People': 'cat_family',
    'Food & Drinks': 'cat_food',
    'Clothing': 'cat_clothing',
    'Home & Furniture': 'cat_home',
    'City & Transport': 'cat_city',
    'Work & School': 'cat_work',
    'Numbers & Time': 'cat_numbers',
    'Nature & Animals': 'cat_nature',
    'Sports & Hobbies': 'cat_sports',
    'Colors & Shapes': 'cat_colors',
    'Body & Health': 'cat_body',
    'Weather & Seasons': 'cat_weather',
    'Media & Technology': 'cat_media',
    'Travel & Holidays': 'cat_travel',
    'Academic & Professional': 'cat_work',
  };

  String _categoryDisplayName(String category, AppLocalizations i18n) {
    final key = _categoryKeyMap[category];
    if (key != null) return i18n.translate(key);
    return category;
  }

  Widget _buildCategoryProgressSection(AppLocalizations i18n, ThemeData theme) {
    final categories = getCategories();
    return Consumer<ProgressProvider>(
      builder: (context, progressProvider, _) {
        final allVocab = getAllVocab();
        final topCats = categories
            .map((c) => (category: c, total: allVocab.where((v) => v.category == c).length, mastered: progressProvider.getProgressForCategory(c)))
            .where((e) => e.total > 0)
            .toList()
          ..sort((a, b) {
            final ra = a.total > 0 ? a.mastered / a.total : 0.0;
            final rb = b.total > 0 ? b.mastered / b.total : 0.0;
            return rb.compareTo(ra);
          });

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.category_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(i18n.profileCategoryProgress, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 12),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: topCats.map((e) {
                      final ratio = e.total > 0 ? (e.mastered / e.total).clamp(0.0, 1.0) : 0.0;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _categoryDisplayName(e.category, i18n),
                                    style: theme.textTheme.bodyMedium,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text('${e.mastered}/${e.total}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 5,
                                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final ThemeData theme;

  const _StatCard({required this.icon, required this.label, required this.value, required this.color, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: theme.colorScheme.outlineVariant.withOpacity(0.3))),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 10),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: color)),
            const SizedBox(height: 2),
            Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _GoalInfo {
  final IconData icon;
  final String labelKey;
  final String description;
  const _GoalInfo(this.icon, this.labelKey, this.description);
}
