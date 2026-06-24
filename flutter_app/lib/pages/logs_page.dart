import 'package:flutter/material.dart';
import '../state/app_state.dart';

class LogsPage extends StatefulWidget {
  const LogsPage({super.key});
  @override
  State<LogsPage> createState() => _LogsPageState();
}

class _LogsPageState extends State<LogsPage> {
  String _filter = '';
  bool _autoScroll = true;
  final _scrollCtrl = ScrollController();
  int _lastLogCount = 0;

  @override
  void initState() {
    super.initState();
    appState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    appState.removeListener(_onStateChanged);
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (_autoScroll && appState.logCount > _lastLogCount && _scrollCtrl.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 150), curve: Curves.easeOut);
        }
      });
    }
    _lastLogCount = appState.logCount;
  }

  void _toggleAutoScroll() {
    setState(() => _autoScroll = !_autoScroll);
    appState.log('SYSTEM', 'Auto-scroll: ${_autoScroll ? "ON" : "OFF"}', color: Colors.grey);
  }

  @override
  Widget build(BuildContext context) {
    final logs = _filter.isEmpty
        ? appState.logs
        : appState.logs.where((l) =>
            l.type.toLowerCase().contains(_filter.toLowerCase()) ||
            l.detail.toLowerCase().contains(_filter.toLowerCase())).toList();

    // Reverse for newest-first display
    final displayLogs = logs.reversed.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Logs'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_autoScroll ? Icons.vertical_align_bottom : Icons.pause_circle),
            tooltip: _autoScroll ? 'Auto-scroll ON' : 'Auto-scroll OFF',
            onPressed: _toggleAutoScroll,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear logs',
            onPressed: () {
              appState.clearLogs();
              setState(() { _lastLogCount = 0; });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter ${appState.logCount} events...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _filter.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear), onPressed: () => setState(() => _filter = ''))
                    : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                isDense: true,
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                _chip('ALL', null),
                _chip('SYSTEM', Colors.grey),
                _chip('LIFECYCLE', Colors.purple),
                _chip('COUNTER', Colors.green),
                _chip('TASK', Colors.teal),
                _chip('CONTROL', Colors.indigo),
                _chip('FORM', Colors.blue),
                _chip('GESTURE', Colors.pink),
                _chip('CHIP', Colors.deepOrange),
                _chip('NAV', Colors.purple),
                _chip('KEYBOARD', Colors.cyan),
              ]),
            ),
          ),
          const Divider(),
          Expanded(
            child: displayLogs.isEmpty
                ? Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.terminal, size: 64, color: Theme.of(context).colorScheme.onSurface.withAlpha(40)),
                      const SizedBox(height: 12),
                      Text(_filter.isEmpty ? 'No events yet — interact with the app!' : 'No matching events',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(100))),
                    ]))
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: displayLogs.length,
                    itemExtent: 24,
                    itemBuilder: (_, i) {
                      final l = displayLogs[i];
                      final t = '${l.time.hour.toString().padLeft(2, '0')}:${l.time.minute.toString().padLeft(2, '0')}:${l.time.second.toString().padLeft(2, '0')}.${l.time.millisecond.toString().padLeft(3, '0')}';
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(t, style: TextStyle(fontSize: 10, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface.withAlpha(80))),
                            const SizedBox(width: 4),
                            Semantics(label: 'Event type: ${l.type}',
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                decoration: BoxDecoration(color: l.color.withAlpha(30), borderRadius: BorderRadius.circular(3)),
                                child: Text(l.type, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: l.color, fontFamily: 'monospace')),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(l.detail, style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: Theme.of(context).colorScheme.onSurface),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                            ),
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
    final selected = _filter.toUpperCase() == label.toUpperCase() || (_filter.isEmpty && label == 'ALL');
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Semantics(
        label: 'Filter by $label. Currently ${selected ? "selected" : "not selected"}.',
        child: ActionChip(
          label: Text(label, style: TextStyle(fontSize: 10, color: selected ? Colors.white : null)),
          backgroundColor: selected ? (color ?? Theme.of(context).colorScheme.primary) : null,
          side: selected ? BorderSide.none : null,
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          onPressed: () => setState(() => _filter = label == 'ALL' ? '' : label),
        ),
      ),
    );
  }
}
