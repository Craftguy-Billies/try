import 'package:flutter/material.dart';
import '../state/app_state.dart';
import '../models/todo_item.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  String? _error;
  bool _adding = false;

  @override
  void initState() {
    super.initState();
    appState.addListener(_onAppStateChanged);
  }

  void _onAppStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    appState.removeListener(_onAppStateChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_adding) return;
    final text = _controller.text.trim();
    if (text.isEmpty) {
      setState(() => _error = 'Task cannot be empty');
      appState.log('TASK', 'Add validation failed: empty input', color: Colors.red);
      return;
    }
    if (text.length > 200) {
      setState(() => _error = 'Max 200 characters');
      appState.log('TASK', 'Add validation failed: too long (${text.length} chars)', color: Colors.red);
      return;
    }
    setState(() => _adding = true);
    final ok = appState.addTask(text);
    if (ok) {
      _controller.clear();
      setState(() => _error = null);
      _focusNode.unfocus();
    }
    setState(() => _adding = false);
  }

  void _confirmDelete(TodoItem t) {
    appState.log('TASK', 'Delete dialog opened for: "${t.title}"', color: Colors.grey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('"${t.title}" will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () {
              appState.log('TASK', 'Delete cancelled for: "${t.title}"', color: Colors.grey);
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _performDelete(t);
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _performDelete(TodoItem t) {
    final removed = appState.removeTask(t.id);
    if (removed && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Deleted "${t.title}"'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              appState.addTask(t.title);
              appState.log('TASK', 'UNDO: Restored "${t.title}"', color: Colors.green);
            },
          ),
        ),
      );
    }
  }

  void _confirmClearDone() {
    final count = appState.doneTaskCount;
    if (count == 0) return;
    appState.log('TASK', 'Clear-done dialog opened ($count tasks)', color: Colors.grey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Done Tasks?'),
        content: Text('$count completed task(s) will be removed. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              appState.log('TASK', 'Clear-done cancelled', color: Colors.grey);
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final cleared = appState.clearDoneTasks();
              Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Cleared $cleared done task(s)'), behavior: SnackBarBehavior.floating),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Clear All Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasks = appState.tasks;
    final doneCount = appState.doneTaskCount;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        actions: [
          if (doneCount > 0)
            TextButton.icon(
              onPressed: _confirmClearDone,
              icon: const Icon(Icons.auto_delete, size: 18),
              label: Text('Clear $doneCount'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: 'What needs doing? (max 200 chars)',
                      errorText: _error,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.edit_note),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _controller.clear(); setState(() => _error = null); })
                          : null,
                    ),
                    textInputAction: TextInputAction.done,
                    maxLength: 200,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _adding ? null : _addTask,
                  child: _adding ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 72, color: cs.onSurface.withAlpha(60)),
                        const SizedBox(height: 12),
                        Text('No tasks yet — add one above!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: cs.onSurface.withAlpha(120))),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: tasks.length,
                    itemExtent: 64,
                    itemBuilder: (_, i) {
                      final t = tasks[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        child: ListTile(
                          dense: true,
                          leading: Checkbox(
                            value: t.done,
                            onChanged: (_) => appState.toggleTask(t.id),
                            semanticLabel: 'Mark "${t.title}" as ${t.done ? "pending" : "done"}',
                          ),
                          title: Text(t.title, style: TextStyle(
                            decoration: t.done ? TextDecoration.lineThrough : null,
                            color: t.done ? cs.onSurface.withAlpha(120) : null,
                          ), maxLines: 1, overflow: TextOverflow.ellipsis),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, size: 20),
                            tooltip: 'Delete "${t.title}"',
                            onPressed: () => _confirmDelete(t),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          if (tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('$doneCount/${tasks.length} done · ${tasks.length - doneCount} remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withAlpha(120))),
            ),
        ],
      ),
    );
  }
}
