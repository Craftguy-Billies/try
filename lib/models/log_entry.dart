import 'package:flutter/material.dart';

class LogEntry {
  final DateTime timestamp;
  final String category;
  final String message;
  final Color color;
  final Map<String, dynamic>? detail;

  const LogEntry({
    required this.timestamp,
    required this.category,
    required this.message,
    this.color = Colors.grey,
    this.detail,
  });

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    final s = timestamp.second.toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'category': category,
        'message': message,
        'color': color.value.toString(),
        'detail': detail,
      };
}
