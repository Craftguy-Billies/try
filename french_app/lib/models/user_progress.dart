class UserProgress {
  int totalWordsLearned;
  int totalWordsReviewed;
  int currentStreak;
  int longestStreak;
  DateTime? lastStudyDate;
  Map<String, int> categoryProgress;
  Map<String, int> levelProgress;
  List<String> masteredWordIds;
  List<String> favoriteWordIds;
  Map<String, DateTime> lastReviewedMap;

  UserProgress({
    this.totalWordsLearned = 0,
    this.totalWordsReviewed = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.lastStudyDate,
    Map<String, int>? categoryProgress,
    Map<String, int>? levelProgress,
    List<String>? masteredWordIds,
    List<String>? favoriteWordIds,
    Map<String, DateTime>? lastReviewedMap,
  })  : categoryProgress = categoryProgress ?? {},
        levelProgress = levelProgress ?? {},
        masteredWordIds = masteredWordIds ?? [],
        favoriteWordIds = favoriteWordIds ?? [],
        lastReviewedMap = lastReviewedMap ?? {};

  bool get isStreakActive {
    if (lastStudyDate == null) return false;
    final now = DateTime.now();
    final diff = now.difference(lastStudyDate!);
    return diff.inHours < 36;
  }

  void markWordMastered(String wordId) {
    if (!masteredWordIds.contains(wordId)) {
      masteredWordIds.add(wordId);
    }
  }

  bool get hasMasteredWords => masteredWordIds.isNotEmpty;

  void markWordReviewed(String wordId) {
    totalWordsReviewed++;
    lastReviewedMap[wordId] = DateTime.now();
  }

  void updateStreak() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (lastStudyDate != null) {
      final lastDate = DateTime(
        lastStudyDate!.year,
        lastStudyDate!.month,
        lastStudyDate!.day,
      );
      final diff = todayDate.difference(lastDate).inDays;

      if (diff == 0) {
        // Already studied today – nothing to change
        return;
      } else if (diff == 1) {
        currentStreak++;
      } else {
        currentStreak = 1;
      }
    } else {
      currentStreak = 1;
    }

    lastStudyDate = today;
    if (currentStreak > longestStreak) {
      longestStreak = currentStreak;
    }
  }

  void incrementCategory(String category) {
    categoryProgress[category] = (categoryProgress[category] ?? 0) + 1;
  }

  void incrementLevel(String level) {
    levelProgress[level] = (levelProgress[level] ?? 0) + 1;
  }

  Map<String, dynamic> toJson() {
    return {
      'totalWordsLearned': totalWordsLearned,
      'totalWordsReviewed': totalWordsReviewed,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastStudyDate': lastStudyDate?.toIso8601String(),
      'categoryProgress': categoryProgress,
      'levelProgress': levelProgress,
      'masteredWordIds': masteredWordIds,
      'favoriteWordIds': favoriteWordIds,
      'lastReviewedMap':
          lastReviewedMap.map((k, v) => MapEntry(k, v.toIso8601String())),
    };
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    final rawReviewed = json['lastReviewedMap'] as Map<String, dynamic>?;
    return UserProgress(
      totalWordsLearned: json['totalWordsLearned'] as int? ?? 0,
      totalWordsReviewed: json['totalWordsReviewed'] as int? ?? 0,
      currentStreak: json['currentStreak'] as int? ?? 0,
      longestStreak: json['longestStreak'] as int? ?? 0,
      lastStudyDate: json['lastStudyDate'] != null
          ? DateTime.tryParse(json['lastStudyDate'] as String)
          : null,
      categoryProgress:
          (json['categoryProgress'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, (v as num).toInt()),
              ) ??
              {},
      levelProgress: (json['levelProgress'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as num).toInt()),
          ) ??
          {},
      masteredWordIds:
          (json['masteredWordIds'] as List<dynamic>?)?.cast<String>() ?? [],
      favoriteWordIds:
          (json['favoriteWordIds'] as List<dynamic>?)?.cast<String>() ?? [],
      lastReviewedMap: rawReviewed != null
          ? rawReviewed.map((k, v) => MapEntry(
                k,
                DateTime.parse(v),
              ))
          : {},
    );
  }
}
