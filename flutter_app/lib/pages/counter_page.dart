import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../state/app_state.dart';
import '../widgets/confetti.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  bool _confettiTrigger = false;
  int _lastCounter = 0;

  void _onChange() {
    final c = appState.counter;
    // Trigger confetti on multiples of 10 (and 5 for extra fun every 5th)
    if (c > 0 && c % 10 == 0 && c != _lastCounter) {
      setState(() => _confettiTrigger = true);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) setState(() => _confettiTrigger = false);
      });
      HapticFeedback.heavyImpact();
    } else if (c > 0 && c % 5 == 0 && c != _lastCounter) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }
    _lastCounter = c;
  }

  void _increment() { appState.increment(); _onChange(); }
  void _decrement() { appState.decrement(); _onChange(); }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Counter?'),
        content: Text('Counter will go from ${appState.counter} back to 0.'),
        actions: [
          TextButton(onPressed: () { appState.log('COUNTER', 'Reset cancelled', color: Colors.grey); Navigator.pop(ctx); }, child: const Text('Cancel')),
          FilledButton(
            onPressed: () { appState.resetCounter(); _lastCounter = 0; Navigator.pop(ctx); },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter'), centerTitle: true),
      body: ConfettiWidget(
        trigger: _confettiTrigger,
        particleCount: 50,
        child: ListenableBuilder(
          listenable: appState,
          builder: (context, _) => Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(height: 24),
              _milestoneBadge(cs),
              const SizedBox(height: 16),
              RepaintBoundary(
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 100),
                  scale: appState.counter > 0 && appState.counter % 10 == 0 ? 1.35 : 1.0,
                  curve: Curves.elasticOut,
                  child: Text('${appState.counter}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 72,
                      color: appState.counter > 0 && appState.counter % 5 == 0 ? cs.primary : cs.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              _actionButtons(cs),
              const SizedBox(height: 12),
              OutlinedButton(onPressed: () => _confirmReset(context), child: const Text('Reset')),
              const SizedBox(height: 24),
              _buildGesturePad(context),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _milestoneBadge(ColorScheme cs) {
    final c = appState.counter;
    if (c == 0) return const SizedBox(height: 28);
    if (c % 10 == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(20)),
        child: Text('🎉 MILESTONE! $c 🎉', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      );
    }
    if (c % 5 == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(16)),
        child: Text('🔥 Keep going! • $c', style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w600, fontSize: 13)),
      );
    }
    return const SizedBox(height: 28);
  }

  Widget _actionButtons(ColorScheme cs) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      _btn('Decrement', Icons.remove, _decrement, cs, true),
      const SizedBox(width: 16),
      _btn('Increment', Icons.add, _increment, cs, false),
    ]);
  }

  Widget _btn(String label, IconData icon, VoidCallback onTap, ColorScheme cs, bool tonal) {
    final btn = tonal
        ? FilledButton.tonalIcon(onPressed: onTap, icon: Icon(icon), label: Text(label))
        : FilledButton.icon(onPressed: onTap, icon: Icon(icon), label: Text(label));
    return btn;
  }

  Widget _buildGesturePad(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: _increment,
        onDoubleTap: () {
          appState.increment(); _onChange();
          appState.increment(); _onChange();
          appState.log('GESTURE', 'Double-tap on gesture pad (+2)', color: Colors.pink);
        },
        onLongPressStart: (_) => appState.log('GESTURE', 'Long-press started on gesture pad', color: Colors.pink),
        onLongPressEnd: (_) => appState.log('GESTURE', 'Long-press ended on gesture pad', color: Colors.pink),
        onLongPress: () { appState.log('GESTURE', 'Long-press → resetting counter', color: Colors.pink); _confirmReset(context); },
        child: Semantics(
          label: 'Gesture pad. Tap to increment. Double tap to increment by two. Long press to reset.',
          button: true,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 200, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(colors: [cs.primaryContainer, cs.secondaryContainer]),
              boxShadow: appState.counter > 0 && appState.counter % 10 == 0 ? [BoxShadow(color: cs.primary.withAlpha(60), blurRadius: 16, spreadRadius: 1)] : null,
            ),
            child: Center(
              child: Text('🖐 Tap · Double-tap · Long-press',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: cs.onPrimaryContainer)),
            ),
          ),
        ),
      ),
    );
  }
}
