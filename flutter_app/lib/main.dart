import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const TrialHostApp());
}

// =====================================================================
// APP ROOT — Material 3 + Dark/Light Theme
// =====================================================================
class TrialHostApp extends StatelessWidget {
  const TrialHostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrialHost Flutter',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.white.withAlpha(20)),
          ),
        ),
      ),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.black.withAlpha(15)),
          ),
        ),
      ),
      home: const MainShell(),
    );
  }
}

// =====================================================================
// EVENT LOGGING SYSTEM
// =====================================================================
class LogEntry {
  final DateTime time;
  final String type;
  final String detail;
  final Color color;
  LogEntry({required this.time, required this.type, required this.detail, required this.color});
}

class AppState extends ChangeNotifier {
  final List<LogEntry> _logs = [];
  UnmodifiableListView<LogEntry> get logs => UnmodifiableListView(_logs);

  void log(String type, String detail, {Color? color}) {
    _logs.add(LogEntry(
      time: DateTime.now(),
      type: type,
      detail: detail,
      color: color ?? Colors.blue,
    ));
    if (_logs.length > 2000) _logs.removeRange(0, _logs.length - 2000);
    notifyListeners();
  }

  void clearLogs() { _logs.clear(); notifyListeners(); }

  // --- Counter ---
  int _counter = 0;
  int get counter => _counter;
  void increment() { _counter++; log('COUNTER', 'Incremented → $_counter', color: Colors.green); notifyListeners(); }
  void decrement() { if (_counter > 0) _counter--; log('COUNTER', 'Decremented → $_counter', color: Colors.orange); notifyListeners(); }
  void resetCounter() { _counter = 0; log('COUNTER', 'Reset to 0', color: Colors.red); notifyListeners(); }

  // --- Tasks ---
  final List<TodoItem> _tasks = [];
  UnmodifiableListView<TodoItem> get tasks => UnmodifiableListView(_tasks);
  void addTask(String title) {
    final t = TodoItem(id: DateTime.now().millisecondsSinceEpoch.toString(), title: title);
    _tasks.add(t);
    log('TASK', 'Added: "$title"', color: Colors.teal);
    notifyListeners();
  }
  void toggleTask(String id) {
    final t = _tasks.firstWhere((t) => t.id == id);
    t.done = !t.done;
    log('TASK', 'Toggled: "${t.title}" → ${t.done ? "DONE" : "PENDING"}', color: t.done ? Colors.green : Colors.orange);
    notifyListeners();
  }
  void removeTask(String id) {
    final t = _tasks.firstWhere((t) => t.id == id);
    log('TASK', 'Removed: "${t.title}"', color: Colors.red);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
  void clearDoneTasks() {
    final count = _tasks.where((t) => t.done).length;
    _tasks.removeWhere((t) => t.done);
    log('TASK', 'Cleared $count done tasks', color: Colors.red);
    notifyListeners();
  }

  // --- Controls ---
  double _sliderValue = 50;
  double get sliderValue => _sliderValue;
  void setSlider(double v) { _sliderValue = v; notifyListeners(); }

  bool _switchNotifications = true;
  bool get switchNotifications => _switchNotifications;
  void toggleNotifications(bool v) { _switchNotifications = v; log('CONTROL', 'Notifications: $v', color: Colors.indigo); notifyListeners(); }

  bool _switchDarkMode = false;
  bool get switchDarkMode => _switchDarkMode;
  void toggleDarkMode(bool v) { _switchDarkMode = v; log('CONTROL', 'Dark mode preference: $v', color: Colors.indigo); notifyListeners(); }

  double _rating = 3;
  double get rating => _rating;
  void setRating(double v) { _rating = v; log('CONTROL', 'Rating set to ${v.toInt()}/5', color: Colors.amber); notifyListeners(); }

  String _selectedFruit = 'Apple';
  String get selectedFruit => _selectedFruit;
  void setFruit(String? v) { if (v != null) { _selectedFruit = v; log('CONTROL', 'Selected: $v', color: Colors.indigo); notifyListeners(); } }

  String _textInput = '';
  String get textInput => _textInput;
  void setTextInput(String v) { _textInput = v; notifyListeners(); }

  // --- Form ---
  bool _agreedToTerms = false;
  bool get agreedToTerms => _agreedToTerms;
  void setAgreedToTerms(bool v) { _agreedToTerms = v; notifyListeners(); }
}

class TodoItem {
  final String id;
  String title;
  bool done;
  TodoItem({required this.id, required this.title, this.done = false});
}

// Global app state (simple inherited approach)
final AppState appState = AppState();

// =====================================================================
// MAIN SHELL — Bottom Navigation
// =====================================================================
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  static const _tabs = <Widget>[
    CounterPage(),
    TasksPage(),
    ControlsPage(),
    FormPage(),
    LogsPage(),
  ];

  @override
  void initState() {
    super.initState();
    appState.addListener(() { if (mounted) setState(() {}); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 200), child: _tabs[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) {
          appState.log('NAV', 'Switched to tab ${['Counter','Tasks','Controls','Form','Logs'][i]}', color: Colors.purple);
          setState(() => _tab = i);
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.plus_one), label: 'Counter'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'Controls'),
          NavigationDestination(icon: Icon(Icons.assignment), label: 'Form'),
          NavigationDestination(icon: Icon(Icons.terminal), label: 'Logs'),
        ],
      ),
    );
  }
}

// =====================================================================
// PAGE 1: COUNTER
// =====================================================================
class CounterPage extends StatelessWidget {
  const CounterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 64, color: cs.primary.withAlpha(120)),
            const SizedBox(height: 16),
            Text('Tap Count', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.onSurface.withAlpha(150))),
            const SizedBox(height: 8),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Text('${appState.counter}',
                key: ValueKey(appState.counter),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton.tonalIcon(
                  onPressed: () => appState.decrement(),
                  icon: const Icon(Icons.remove),
                  label: const Text('Decrement'),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => appState.increment(),
                  icon: const Icon(Icons.add),
                  label: const Text('Increment'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: () => appState.resetCounter(), child: const Text('Reset')),
            const SizedBox(height: 24),
            _buildGesturePad(context),
          ],
        ),
      ),
    );
  }

  Widget _buildGesturePad(BuildContext context) {
    return GestureDetector(
      onTap: () => appState.increment(),
      onDoubleTap: () { appState.increment(); appState.increment(); appState.log('GESTURE', 'Double-tap on gesture pad', color: Colors.pink); },
      onLongPress: () { appState.resetCounter(); appState.log('GESTURE', 'Long-press → reset', color: Colors.pink); },
      child: Container(
        width: 200, height: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer]),
        ),
        child: Center(
          child: Text('🖐 Tap · Double-tap · Long-press',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
        ),
      ),
    );
  }
}

// =====================================================================
// PAGE 2: TASKS (TODO LIST)
// =====================================================================
class TasksPage extends StatefulWidget {
  const TasksPage({super.key});
  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _controller = TextEditingController();
  String? _error;

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) { setState(() => _error = 'Task cannot be empty'); return; }
    if (text.length > 80) { setState(() => _error = 'Max 80 characters'); return; }
    appState.addTask(text);
    _controller.clear();
    setState(() => _error = null);
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final tasks = appState.tasks;
    final doneCount = tasks.where((t) => t.done).length;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        actions: [
          if (doneCount > 0)
            TextButton.icon(
              onPressed: () => _confirmClearDone(context),
              icon: const Icon(Icons.auto_delete, size: 18),
              label: Text('Clear $doneCount done'),
            ),
        ],
      ),
      body: Column(
        children: [
          // Input row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'What needs doing?',
                      errorText: _error,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.edit_note),
                      suffixIcon: _controller.text.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear), onPressed: () { _controller.clear(); setState(() => _error = null); })
                          : null,
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (_) => setState(() => _error = null),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _addTask, child: const Text('Add')),
              ],
            ),
          ),
          // Task list
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
                    itemBuilder: (_, i) {
                      final t = tasks[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: Checkbox(
                            value: t.done,
                            onChanged: (_) => appState.toggleTask(t.id),
                          ),
                          title: Text(t.title, style: TextStyle(
                            decoration: t.done ? TextDecoration.lineThrough : null,
                            color: t.done ? cs.onSurface.withAlpha(120) : null,
                          )),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _confirmDelete(context, t),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          // Stats
          if (tasks.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text('${doneCount}/${tasks.length} done · ${tasks.length - doneCount} remaining',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onSurface.withAlpha(120))),
            ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TodoItem t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task?'),
        content: Text('"${t.title}" will be permanently removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { appState.removeTask(t.id); Navigator.pop(ctx); },
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _confirmClearDone(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Done Tasks?'),
        content: Text('${appState.tasks.where((t) => t.done).length} completed tasks will be removed.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () { appState.clearDoneTasks(); Navigator.pop(ctx); }, child: const Text('Clear All Done')),
        ],
      ),
    );
  }
}

// =====================================================================
// PAGE 3: CONTROLS (Sliders, Switches, Dropdowns, etc.)
// =====================================================================
class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Controls'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'Slider — ${appState.sliderValue.toInt()}%', Icons.tune, [
            Slider(value: appState.sliderValue, min: 0, max: 100, divisions: 100, label: '${appState.sliderValue.toInt()}%',
              onChanged: (v) => appState.setSlider(v),
              onChangeEnd: (v) => appState.log('CONTROL', 'Slider final: ${v.toInt()}%', color: Colors.indigo)),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Switches', Icons.toggle_on, [
            SwitchListTile(
              title: const Text('Enable Notifications'),
              subtitle: const Text('Receive push notifications'),
              value: appState.switchNotifications,
              onChanged: (v) => appState.toggleNotifications(v),
            ),
            SwitchListTile(
              title: const Text('Dark Mode Preference'),
              subtitle: const Text('Use dark color scheme'),
              value: appState.switchDarkMode,
              onChanged: (v) => appState.toggleDarkMode(v),
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Rating — ${appState.rating.toInt()}/5', Icons.star, [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) => IconButton(
                  icon: Icon(i < appState.rating.toInt() ? Icons.star : Icons.star_border,
                    color: i < appState.rating.toInt() ? Colors.amber : cs.onSurface.withAlpha(80), size: 40),
                  onPressed: () => appState.setRating(i + 1.0),
                )),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Dropdown', Icons.arrow_drop_down_circle, [
            Padding(
              padding: const EdgeInsets.all(12),
              child: DropdownButtonFormField<String>(
                value: appState.selectedFruit,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Favorite Fruit'),
                items: ['Apple', 'Banana', 'Cherry', 'Dragon Fruit', 'Elderberry', 'Fig', 'Grape']
                    .map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => appState.setFruit(v),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Chips', Icons.category, [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(spacing: 8, runSpacing: 4, children: [
                ActionChip(label: const Text('👍 Like'), avatar: const Icon(Icons.thumb_up, size: 16),
                  onPressed: () => appState.log('CHIP', 'Like pressed', color: Colors.blue)),
                ActionChip(label: const Text('❤️ Love'), avatar: const Icon(Icons.favorite, size: 16),
                  onPressed: () => appState.log('CHIP', 'Love pressed', color: Colors.red)),
                FilterChip(label: const Text('Urgent'), selected: false,
                  onSelected: (v) => appState.log('CHIP', 'Urgent filter: $v', color: Colors.deepOrange)),
                InputChip(label: const Text('Dismiss me'), onDeleted: () => appState.log('CHIP', 'Chip dismissed', color: Colors.grey)),
              ]),
            ),
          ]),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title, IconData icon, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(children: [
                Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleSmall),
              ]),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// PAGE 4: FORM (with validation, edge cases)
// =====================================================================
class FormPage extends StatefulWidget {
  const FormPage({super.key});
  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _submitted = false;
  String? _selectedGender;

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose(); _phoneCtrl.dispose(); _bioCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      setState(() => _submitted = true);
      appState.log('FORM', 'Form submitted! Name: ${_nameCtrl.text}, Email: ${_emailCtrl.text}', color: Colors.green);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('✅ Form submitted successfully!'), behavior: SnackBarBehavior.floating,
          action: SnackBarAction(label: 'OK', onPressed: () {}), duration: const Duration(seconds: 3)),
      );
    } else {
      appState.log('FORM', 'Validation failed', color: Colors.red);
    }
  }

  void _reset() {
    setState(() {
      _formKey.currentState!.reset();
      _nameCtrl.clear(); _emailCtrl.clear(); _phoneCtrl.clear(); _bioCtrl.clear();
      _selectedGender = null; _submitted = false;
    });
    appState.log('FORM', 'Form reset', color: Colors.orange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Form'), centerTitle: true,
        actions: [IconButton(icon: const Icon(Icons.refresh), tooltip: 'Reset', onPressed: _reset)]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_submitted)
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(children: [
                      Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 12),
                      const Expanded(child: Text('Form submitted! Check logs for details.', style: TextStyle(fontWeight: FontWeight.w600))),
                    ]),
                  ),
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name *', hintText: 'John Doe', prefixIcon: Icon(Icons.person), border: OutlineInputBorder()),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Name is required';
                  if (v.trim().length < 2) return 'Name must be at least 2 characters';
                  if (v.trim().length > 50) return 'Name must be under 50 characters';
                  if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(v.trim())) return 'Only letters, spaces, and hyphens';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(labelText: 'Email *', hintText: 'john@example.com', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Email is required';
                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v.trim())) return 'Enter a valid email address';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneCtrl,
                decoration: const InputDecoration(labelText: 'Phone (optional)', hintText: '+1 555-0123', prefixIcon: Icon(Icons.phone), border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (v) {
                  if (v != null && v.trim().isNotEmpty && !RegExp(r'^[\+\d\s\-\(\)]{7,20}$').hasMatch(v.trim())) return 'Enter a valid phone number';
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender', prefixIcon: Icon(Icons.people), border: OutlineInputBorder()),
                items: ['Male', 'Female', 'Non-binary', 'Prefer not to say']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGender = v),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(labelText: 'Bio (max 200 chars)', hintText: 'Tell us about yourself...', prefixIcon: Icon(Icons.edit), border: OutlineInputBorder(), alignLabelWithHint: true),
                maxLines: 3, maxLength: 200,
                validator: (v) {
                  if (v != null && v.length > 200) return 'Bio must be under 200 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: appState.agreedToTerms,
                onChanged: (v) => appState.setAgreedToTerms(v ?? false),
                title: const Text('I agree to the Terms & Conditions *'),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              if (!appState.agreedToTerms && _submitted)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('You must agree to the terms', style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 12)),
                ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
                style: FilledButton.styleFrom(padding: const EdgeInsets.all(16)),
              ),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _reset, child: const Text('Reset Form')),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// PAGE 5: LOGS (Debug Event Log)
// =====================================================================
class LogsPage extends StatefulWidget {
  const LogsPage({super.key});
  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String _filter = '';
  bool _autoScroll = true;
  final _scrollCtrl = ScrollController();

  @override
  void dispose() { _scrollCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final logs = _filter.isEmpty
        ? appState.logs
        : appState.logs.where((l) =>
            l.type.toLowerCase().contains(_filter.toLowerCase()) ||
            l.detail.toLowerCase().contains(_filter.toLowerCase())).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Logs'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(_autoScroll ? Icons.vertical_align_bottom : Icons.pause_circle), tooltip: 'Auto-scroll', onPressed: () => setState(() => _autoScroll = !_autoScroll)),
          IconButton(icon: const Icon(Icons.delete_sweep), tooltip: 'Clear', onPressed: () { appState.clearLogs(); setState(() {}); }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter ${appState.logs.length} events...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _filter.isNotEmpty ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _filter = '')) : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _chip('ALL', null),
                _chip('COUNTER', Colors.green),
                _chip('TASK', Colors.teal),
                _chip('CONTROL', Colors.indigo),
                _chip('FORM', Colors.blue),
                _chip('NAV', Colors.purple),
                _chip('GESTURE', Colors.pink),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: logs.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.terminal, size: 64, color: Theme.of(context).colorScheme.onSurface.withAlpha(40)),
                      const SizedBox(height: 12),
                      Text(_filter.isEmpty ? 'No events yet — interact with the app!' : 'No matching events',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withAlpha(100))),
                    ]))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: logs.length,
                    itemBuilder: (_, i) {
                      final l = logs[i];
                      final t = '${l.time.hour.toString().padLeft(2,'0')}:${l.time.minute.toString().padLeft(2,'0')}:${l.time.second.toString().padLeft(2,'0')}.${l.time.millisecond.toString().padLeft(3,'0')}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t, style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface.withAlpha(100))),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(color: l.color.withAlpha(30), borderRadius: BorderRadius.circular(4)),
                              child: Text(l.type, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: l.color, fontFamily: 'monospace')),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(l.detail, style: TextStyle(fontSize: 12, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface))),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, Color? color) {
    final selected = _filter.toUpperCase() == label || (_filter.isEmpty && label == 'ALL');
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: selected ? Colors.white : null)),
        backgroundColor: selected ? (color ?? Theme.of(context).colorScheme.primary) : null,
        side: selected ? BorderSide.none : null,
        onPressed: () => setState(() => _filter = label == 'ALL' ? '' : label),
      ),
    );
  }
}
