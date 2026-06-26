
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
    int? totalWordsLearned,
    int? totalMinutesPracticed,
    int? currentStreak,
    int? longestStreak,
    this.lastPracticeDate,
    Map<String, int>? categoryProgress,
    Map<String, bool>? completedWords,
    Map<String, int>? examScores,
    this.nativeLanguage = 'en',
    this.onboardingCompleted = false,
    this.darkMode = false,
    this.notificationsEnabled = true,
    int? dailyGoalWords,
  })  : totalWordsLearned = _clampNonNeg(totalWordsLearned ?? 0),
        totalMinutesPracticed = _clampNonNeg(totalMinutesPracticed ?? 0),
        currentStreak = _clampNonNeg(currentStreak ?? 0),
        longestStreak = _clampNonNeg(longestStreak ?? 0),
        dailyGoalWords = _clampRange(dailyGoalWords ?? 20, 1, 200),
        categoryProgress = categoryProgress ?? {},
        completedWords = completedWords ?? {},
        examScores = examScores ?? {};

  static int _clampNonNeg(int v) => v < 0 ? 0 : v;
  static int _clampRange(int v, int min, int max) => v < min ? min : (v > max ? max : v);

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

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    // Safely parse numeric values, clamping negatives
    int safeInt(dynamic val, int fallback) {
      if (val == null) return fallback;
      if (val is int) return val < 0 ? 0 : val;
      if (val is num) return val.toInt() < 0 ? 0 : val.toInt();
      return fallback;
    }
    return UserProgress(
      totalWordsLearned: safeInt(json['totalWordsLearned'], 0),
      totalMinutesPracticed: safeInt(json['totalMinutesPracticed'], 0),
      currentStreak: safeInt(json['currentStreak'], 0),
      longestStreak: safeInt(json['longestStreak'], 0),
      lastPracticeDate: json['lastPracticeDate'] != null ? DateTime.tryParse(json['lastPracticeDate'] as String) : null,
      categoryProgress: (json['categoryProgress'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      completedWords: (json['completedWords'] as Map?)?.map((k, v) => MapEntry(k.toString(), v is bool ? v : false)),
      examScores: (json['examScores'] as Map?)?.map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
      nativeLanguage: json['nativeLanguage'] as String? ?? 'en',
      onboardingCompleted: json['onboardingCompleted'] as bool? ?? false,
      darkMode: json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      dailyGoalWords: safeInt(json['dailyGoalWords'], 20),
    );
  }

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
