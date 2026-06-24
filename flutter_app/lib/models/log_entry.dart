import 'package:flutter/material.dart';

class LogEntry {
  final DateTime time;
  final String type;
  final String detail;
  final Color color;
  LogEntry({required this.time, required this.type, required this.detail, required this.color});
}
