
class UserProgress {
  int totalWordsLearned;
  int totalMinutesPracticed;
  int currentStreak;
  int longestStreak;
  DateTime? lastPracticeDate;
  Map<String, int> categoryProgress;
  Map<String, bool> completedWords;
  Map<String, int> examScores;
  String nativeLanguage;
  bool onboardingCompleted;
  bool darkMode;
  bool notificationsEnabled;
  int dailyGoalWords;

  UserProgress({
    this.totalWordsLearned = 0,
    this.totalMinutesPracticed = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastPracticeDate,
    Map<String, int>? categoryProgress,
    Map<String, bool>? completedWords,
    Map<String, int>? examScores,
    this.nativeLanguage = 'en',
    this.onboardingCompleted = false,
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.dailyGoalWords = 20,
  })  : categoryProgress = categoryProgress ?? {},
        completedWords = completedWords ?? {},
        examScores = examScores ?? {};

  Map<String, dynamic> toJson() => {
    'totalWordsLearned': totalWordsLearned,
    'totalMinutesPracticed': totalMinutesPracticed,
    'currentStreak': currentStreak,
    'longestStreak': longestStreak,
    'lastPracticeDate': lastPracticeDate?.toIso8601String(),
    'categoryProgress': categoryProgress,
    'completedWords': completedWords,
    'examScores': examScores,
    'nativeLanguage': nativeLanguage,
    'onboardingCompleted': onboardingCompleted,
    'darkMode': darkMode,
    'notificationsEnabled': notificationsEnabled,
    'dailyGoalWords': dailyGoalWords,
  };

  factory UserProgress.fromJson(Map<String, dynamic> json) => UserProgress(
    totalWordsLearned: json['totalWordsLearned'] as int? ?? 0,
    totalMinutesPracticed: json['totalMinutesPracticed'] as int? ?? 0,
    currentStreak: json['currentStreak'] as int? ?? 0,
    longestStreak: json['longestStreak'] as int? ?? 0,
    lastPracticeDate: json['lastPracticeDate'] != null ? DateTime.tryParse(json['lastPracticeDate'] as String) : null,
    categoryProgress: (json['categoryProgress'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
    completedWords: (json['completedWords'] as Map?)?.map((k, v) => MapEntry(k.toString(), v as bool)),
    examScores: (json['examScores'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
    nativeLanguage: json['nativeLanguage'] as String? ?? 'en',
    onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
    darkMode: json['darkMode'] as bool? ?? false,
    notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
    dailyGoalWords: json['dailyGoalWords'] as int? ?? 20,
  );

  void updateStreak() {
    final now = DateTime.now();
    if (lastPracticeDate != null) {
      final diff = now.difference(lastPracticeDate!).inDays;
      if (diff == 0) return;
      if (diff == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }
    if (currentStreak > longestStreak) longestStreak = currentStreak;
    lastPracticeDate = now;
  }

  double getCategoryProgress(String categoryId, int total) {
    final done = categoryProgress[categoryId] ?? 0;
    return total > 0 ? done / total : 0.0;
  }

  int get totalLearned => completedWords.values.where((v) => v).length;
}
