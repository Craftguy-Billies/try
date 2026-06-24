import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../state/app_state.dart';

enum RState { idle, waiting, ready, tapped, result }

class ReactionPage extends StatefulWidget {
  const ReactionPage({super.key});
  @override
  State<ReactionPage> createState() => _ReactionPageState();
}

class _ReactionPageState extends State<ReactionPage> {
  RState _state = RState.idle;
  int _reactionMs = 0;
  final List<int> _history = [];
  Timer? _timer;
  int _startTime = 0;
  final _rng = Random();
  int _bestMs = 0;
  int _totalMs = 0;
  int _tries = 0;
  int _tooEarly = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    _cancelTimer();
    setState(() => _state = RState.waiting);
    appState.log('REACT', 'Waiting... (random delay)', color: Colors.orange);

    final delay = 1200 + _rng.nextInt(2800);
    _timer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _startTime = DateTime.now().millisecondsSinceEpoch;
      setState(() => _state = RState.ready);
      appState.log('REACT', 'TAP NOW! (green)', color: Colors.green);
    });
  }

  void _tap() {
    switch (_state) {
      case RState.idle:
        _start();
        break;
      case RState.waiting:
        _cancelTimer();
        _tooEarly++;
        setState(() => _state = RState.result);
        _reactionMs = -1;
        appState.log('REACT', 'Too early! (#$_tooEarly premature taps)', color: Colors.red);
        _autoRestart();
        break;
      case RState.ready:
        _cancelTimer();
        final elapsed = DateTime.now().millisecondsSinceEpoch - _startTime;
        _reactionMs = elapsed;
        _history.insert(0, elapsed);
        if (_history.length > 50) _history.removeLast();
        _tries++;
        _totalMs += elapsed;
        _bestMs = _bestMs == 0 ? elapsed : min(_bestMs, elapsed);
        setState(() => _state = RState.result);
        appState.log('REACT', '${elapsed}ms ${_rating(elapsed)} (avg: ${(_totalMs / _tries).toInt()}ms best: ${_bestMs}ms)', color: _reactionColor(elapsed));
        _autoRestart();
        break;
      case RState.tapped:
      case RState.result:
        _start();
        break;
    }
  }

  void _autoRestart() {
    _timer = Timer(const Duration(milliseconds: 2000), () {
      if (mounted) _start();
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
    _timer = null;
  }

  String _rating(int ms) {
    if (ms <= 150) return '⚡️ INSANE!';
    if (ms <= 200) return '🔥 Great!';
    if (ms <= 280) return '👌 Nice!';
    if (ms <= 400) return '👍 Average';
    return '🐢 Slow';
  }

  Color _reactionColor(int ms) {
    if (ms <= 150) return const Color(0xFFFFD700);
    if (ms <= 200) return Colors.green;
    if (ms <= 280) return Colors.lightGreen;
    if (ms <= 400) return Colors.orange;
    return Colors.red;
  }

  Color get _screenColor {
    switch (_state) {
      case RState.idle: return const Color(0xFF2C3E50);
      case RState.waiting: return const Color(0xFFC0392B);
      case RState.ready: return const Color(0xFF27AE60);
      case RState.tapped:
      case RState.result:
        if (_reactionMs == -1) return const Color(0xFFC0392B);
        return _reactionColor(_reactionMs);
    }
  }

  String get _label {
    switch (_state) {
      case RState.idle: return 'Tap to Start';
      case RState.waiting: return 'Wait for Green...';
      case RState.ready: return 'TAP NOW!';
      case RState.tapped:
      case RState.result:
        if (_reactionMs == -1) return 'Too Early! 😤';
        return '$_reactionMs ms';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Reaction Time'), centerTitle: true,
        actions: [_tries > 0 ? IconButton(icon: const Icon(Icons.refresh), tooltip: 'Reset stats', onPressed: () { setState(() { _history.clear(); _bestMs = 0; _totalMs = 0; _tries = 0; _tooEarly = 0; _state = RState.idle; _cancelTimer(); }); appState.log('REACT', 'Stats reset', color: Colors.grey); }) : const SizedBox()],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _tap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                color: _screenColor,
                child: Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    AnimatedSwitcher(duration: const Duration(milliseconds: 200),
                      child: Text(_label, key: ValueKey(_label),
                        style: const TextStyle(fontSize: 42, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_state == RState.result && _reactionMs >= 0)
                      Text(_rating(_reactionMs), style: const TextStyle(fontSize: 18, color: Colors.white70)),
                    if (_state == RState.result && _reactionMs == -1)
                      const Text('Wait for green next time!', style: TextStyle(fontSize: 16, color: Colors.white54)),
                  ]),
                ),
              ),
            ),
          ),
          _buildStats(cs),
        ],
      ),
    );
  }

  Widget _buildStats(ColorScheme cs) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: cs.surface,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          _statCard('Tries', '$_tries', cs),
          _statCard('Best', _bestMs > 0 ? '${_bestMs}ms' : '—', cs),
          _statCard('Avg', _tries > 0 ? '${(_totalMs / _tries).toInt()}ms' : '—', cs),
          _statCard('Early', '$_tooEarly', cs),
        ]),
        if (_history.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Recent:', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: cs.onSurface.withAlpha(120))),
          const SizedBox(height: 4),
          SizedBox(
            height: 32,
            child: ListView.builder(scrollDirection: Axis.horizontal, itemCount: _history.length,
              itemBuilder: (_, i) {
                final ms = _history[i];
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: _reactionColor(ms).withAlpha(40), borderRadius: BorderRadius.circular(6)),
                  child: Text('${ms}ms', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _reactionColor(ms))),
                );
              },
            ),
          ),
        ],
      ]),
    );
  }

  Widget _statCard(String label, String value, ColorScheme cs) {
    return Column(children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: cs.primary)),
      Text(label, style: TextStyle(fontSize: 11, color: cs.onSurface.withAlpha(120))),
    ]);
  }
}
