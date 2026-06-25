import 'package:flutter/material.dart';

class VocabItem {
  final String id;
  final String french;
  final String english;
  final String category;
  final String? example;
  final String? gender; // 'm' or 'f' for nouns
  final String? ipa; // IPA pronunciation guide
  int level; // SRS level 0-5
  DateTime? nextReview;
  int correctCount;
  int incorrectCount;
  int streak; // consecutive correct answers

  VocabItem({
    required this.id,
    required this.french,
    required this.english,
    required this.category,
    this.example,
    this.gender,
    this.ipa,
    this.level = 0,
    this.nextReview,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.streak = 0,
  });

  // SRS intervals in hours: level 0=immediate, 1=4h, 2=24h, 3=72h, 4=168h, 5=720h
  static const _intervals = [0, 4, 24, 72, 168, 720];

  void recordCorrect() {
    correctCount++;
    streak++;
    if (level < 5) level++;
    nextReview = DateTime.now().add(Duration(hours: _intervals[level]));
  }

  void recordIncorrect() {
    incorrectCount++;
    streak = 0;
    level = (level - 1).clamp(0, 5);
    nextReview = DateTime.now().add(const Duration(hours: 1));
  }

  bool get isDue => nextReview == null || DateTime.now().isAfter(nextReview!);

  double get mastery => (correctCount + incorrectCount) == 0
      ? 0
      : correctCount / (correctCount + incorrectCount);

  Color get levelColor {
    switch (level) {
      case 0: return Colors.grey;
      case 1: return Colors.red.shade300;
      case 2: return Colors.orange;
      case 3: return Colors.amber;
      case 4: return Colors.lightGreen;
      case 5: return Colors.green;
      default: return Colors.grey;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'french': french, 'english': english, 'category': category,
    'example': example, 'gender': gender, 'ipa': ipa, 'level': level,
    'correctCount': correctCount, 'incorrectCount': incorrectCount,
    'streak': streak, 'nextReview': nextReview?.toIso8601String(),
  };

  factory VocabItem.fromJson(Map<String, dynamic> json) => VocabItem(
    id: json['id'], french: json['french'], english: json['english'],
    category: json['category'], example: json['example'],
    gender: json['gender'], ipa: json['ipa'], level: json['level'] ?? 0,
    correctCount: json['correctCount'] ?? 0,
    incorrectCount: json['incorrectCount'] ?? 0,
    streak: json['streak'] ?? 0,
    nextReview: json['nextReview'] != null ? DateTime.parse(json['nextReview']) : null,
  );
}
