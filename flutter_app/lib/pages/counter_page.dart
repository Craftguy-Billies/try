import '../state/app_state.dart';
import 'package:flutter/material.dart';
import '../state/app_state.dart';

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
            RepaintBoundary(
              child: Icon(Icons.touch_app, size: 64, color: cs.primary.withAlpha(120)),
            ),
            const SizedBox(height: 16),
            Text('Tap Count', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: cs.onSurface.withAlpha(150))),
            const SizedBox(height: 8),
            RepaintBoundary(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                child: Text('${appState.counter}',
                  key: ValueKey('counter_${appState.counter}'),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold, color: cs.primary),
                ),
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
            OutlinedButton(
              onPressed: () => _confirmReset(context),
              child: const Text('Reset'),
            ),
            const SizedBox(height: 24),
            _buildGesturePad(context),
          ],
        ),
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset Counter?'),
        content: Text('Counter will go from ${appState.counter} back to 0.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { appState.resetCounter(); Navigator.pop(ctx); },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Widget _buildGesturePad(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return RepaintBoundary(
      child: GestureDetector(
        onTap: () => appState.increment(),
        onDoubleTap: () {
          appState.increment();
          appState.increment();
          appState.log('GESTURE', 'Double-tap on gesture pad (+2)', color: Colors.pink);
        },
        onLongPressStart: (_) => appState.log('GESTURE', 'Long-press started on gesture pad', color: Colors.pink),
        onLongPressEnd: (_) => appState.log('GESTURE', 'Long-press ended on gesture pad', color: Colors.pink),
        onLongPress: () {
          appState.log('GESTURE', 'Long-press → resetting counter', color: Colors.pink);
          _confirmReset(context);
        },
        child: Semantics(
          label: 'Gesture pad. Tap to increment. Double tap to increment by two. Long press to reset.',
          button: true,
          child: Container(
            width: 200, height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [cs.primaryContainer, cs.secondaryContainer],
              ),
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
