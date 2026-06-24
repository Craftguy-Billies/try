class TodoItem {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  TodoItem({
    required this.id,
    required this.title,
    this.done = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  TodoItem copyWith({String? title, bool? done}) {
    return TodoItem(
      id: id,
      title: title ?? this.title,
      done: done ?? this.done,
      createdAt: createdAt,
    );
  }
}
