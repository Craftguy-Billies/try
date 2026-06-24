import 'package:flutter/material.dart';
import '../state/app_state.dart';

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Controls'), centerTitle: true),
      body: ListenableBuilder(
        listenable: appState,
        builder: (context, _) => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'Slider — ${appState.sliderValue.toInt()}%', Icons.tune, [
            Slider(
              value: appState.sliderValue,
              min: 0, max: 100, divisions: 100,
              label: '${appState.sliderValue.toInt()}%',
              onChanged: (v) => appState.setSlider(v),
              onChangeStart: (_) => appState.log('CONTROL', 'Slider drag started', color: Colors.indigo),
              onChangeEnd: (v) => appState.commitSlider(v),
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Toggles', Icons.toggle_on, [
            Semantics(
              label: 'Enable notifications toggle. Currently ${appState.switchNotifications ? "on" : "off"}.',
              child: SwitchListTile(
                title: const Text('Enable Notifications'),
                subtitle: const Text('Receive push notifications'),
                value: appState.switchNotifications,
                onChanged: (v) => appState.toggleNotifications(v),
              ),
            ),
            Semantics(
              label: 'Vibration toggle. Currently ${appState.switchVibration ? "on" : "off"}.',
              child: SwitchListTile(
                title: const Text('Haptic Vibration'),
                subtitle: const Text('Vibrate on interactions'),
                value: appState.switchVibration,
                onChanged: (v) => appState.toggleVibration(v),
              ),
            ),
          ]),
          const SizedBox(height: 16),
          _section(context, 'Rating — ${appState.rating.toInt()}/5', Icons.star, [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final filled = i < appState.rating.toInt();
                  return Semantics(
                    label: 'Rate ${i + 1} out of 5',
                    button: true,
                    child: IconButton(
                      icon: Icon(filled ? Icons.star : Icons.star_border,
                        color: filled ? Colors.amber : cs.onSurface.withAlpha(80), size: 40),
                      onPressed: () => appState.setRating(i + 1.0),
                    ),
                  );
                }),
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
                ActionChip(
                  avatar: const Icon(Icons.thumb_up, size: 16),
                  label: const Text('Like'),
                  onPressed: () => appState.log('CHIP', 'Like pressed', color: Colors.blue),
                ),
                ActionChip(
                  avatar: const Icon(Icons.favorite, size: 16),
                  label: const Text('Love'),
                  onPressed: () => appState.log('CHIP', 'Love pressed', color: Colors.red),
                ),
                FilterChip(
                  label: const Text('Urgent'),
                  selected: false,
                  onSelected: (v) => appState.log('CHIP', 'Urgent filter: $v', color: Colors.deepOrange),
                ),
                InputChip(
                  label: const Text('Dismiss me'),
                  onDeleted: () => appState.log('CHIP', 'Chip dismissed', color: Colors.grey),
                ),
                ActionChip(
                  avatar: const Icon(Icons.share, size: 16),
                  label: const Text('Share'),
                  onPressed: () => appState.log('CHIP', 'Share pressed', color: Colors.blue),
                ),
                ActionChip(
                  avatar: const Icon(Icons.bookmark, size: 16),
                  label: const Text('Bookmark'),
                  onPressed: () => appState.log('CHIP', 'Bookmark pressed', color: Colors.teal),
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 80),
        ],
        ),      // closes ListView
      ),        // closes ListenableBuilder
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
