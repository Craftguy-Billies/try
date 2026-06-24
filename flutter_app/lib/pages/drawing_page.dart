import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../state/app_state.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});
  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<_Stroke> _strokes = [];
  final List<List<_Stroke>> _undoStack = [];
  Color _color = Colors.black;
  double _strokeWidth = 3.0;
  Offset? _lastPoint;

  static const _palette = [
    Colors.black, Colors.red, Colors.blue, Colors.green, Colors.orange,
    Colors.purple, Colors.teal, Colors.pink, Colors.brown, Colors.indigo,
    Colors.yellow, Colors.cyan,
  ];

  void _onPanStart(DragStartDetails d) {
    _lastPoint = d.localPosition;
    _strokes.add(_Stroke(color: _color, width: _strokeWidth, points: [_lastPoint!]));
    setState(() {});
    _logStroke();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    if (_lastPoint == null || _strokes.isEmpty) return;
    final newPoint = d.localPosition;
    if ((newPoint - _lastPoint!).distance > 1.5) {
      _strokes.last.points.add(newPoint);
      _lastPoint = newPoint;
      setState(() {});
    }
  }

  void _onPanEnd(DragEndDetails _) {
    _lastPoint = null;
    if (_strokes.isNotEmpty && _strokes.last.points.length > 1) {
      _undoStack.clear();
    }
  }

  void _undo() {
    if (_strokes.isEmpty) return;
    _logOp('undo');
    _undoStack.add(List.from(_strokes));
    _strokes.removeLast();
    setState(() {});
  }

  void _clear() {
    if (_strokes.isEmpty) return;
    appState.log('DRAW', 'Clear canvas dialog opened', color: Colors.grey);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Canvas?'),
        content: Text('${_strokes.length} stroke(s) will be erased.'),
        actions: [
          TextButton(onPressed: () { appState.log('DRAW', 'Clear cancelled', color: Colors.grey); Navigator.pop(ctx); }, child: const Text('Cancel')),
          FilledButton(onPressed: () { Navigator.pop(ctx); _doClear(); }, style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error), child: const Text('Clear All')),
        ],
      ),
    );
  }

  void _doClear() {
    final count = _strokes.length;
    _undoStack.add(List.from(_strokes));
    _strokes.clear();
    setState(() {});
    appState.log('DRAW', 'Canvas cleared ($count strokes)', color: Colors.red);
  }

  void _redo() {
    if (_undoStack.isEmpty) return;
    _logOp('redo');
    _strokes.clear();
    _strokes.addAll(_undoStack.removeLast());
    setState(() {});
  }

  void _logOp(String op) => appState.log('DRAW', '${op.toUpperCase()}: ${_strokes.length} strokes', color: Colors.deepPurpleAccent);
  void _logStroke() => appState.log('DRAW', 'Stroke #${_strokes.length} (${_color.value.toRadixString(16)} w:${_strokeWidth.toStringAsFixed(1)})', color: Colors.deepPurpleAccent);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sketch Canvas'),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.undo, color: _strokes.isEmpty ? Colors.grey : null), tooltip: 'Undo last stroke', onPressed: _strokes.isEmpty ? null : _undo),
          IconButton(icon: Icon(Icons.redo, color: _undoStack.isEmpty ? Colors.grey : null), tooltip: 'Redo', onPressed: _undoStack.isEmpty ? null : _redo),
          IconButton(icon: const Icon(Icons.delete_sweep), tooltip: 'Clear canvas', onPressed: _strokes.isEmpty ? null : _clear),
        ],
      ),
      body: Column(
        children: [
          _buildToolbar(),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.outline.withAlpha(60)), borderRadius: BorderRadius.circular(8), color: Colors.white),
                child: GestureDetector(
                  onPanStart: _onPanStart,
                  onPanUpdate: _onPanUpdate,
                  onPanEnd: _onPanEnd,
                  child: CustomPaint(
                    painter: _DrawingPainter(strokes: _strokes),
                    size: Size.infinite,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(children: [
        Text('Width:', style: Theme.of(context).textTheme.bodySmall),
        Slider(value: _strokeWidth, min: 1, max: 20, divisions: 19, label: '${_strokeWidth.toInt()}px',
          onChanged: (v) => setState(() => _strokeWidth = v),
          onChangeEnd: (v) => appState.log('DRAW', 'Width: ${v.toInt()}px', color: Colors.deepPurpleAccent),
        ),
        ...List.generate(_palette.length, (i) {
          final c = _palette[i];
          final selected = _color.value == c.value;
          return GestureDetector(
            onTap: () { setState(() => _color = c); appState.log('DRAW', 'Color: #${c.value.toRadixString(16).padLeft(8, '0')}', color: Colors.deepPurpleAccent); },
            child: Semantics(label: 'Color ${i + 1}', button: true,
              child: Container(
                width: 28, height: 28, margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: c, shape: BoxShape.circle,
                  border: Border.all(color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300, width: selected ? 3 : 1),
                  boxShadow: selected ? [BoxShadow(color: c.withAlpha(80), blurRadius: 6)] : null,
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        Chip(label: Text('${_strokes.length} strokes', style: const TextStyle(fontSize: 11))),
      ]),
    );
  }
}

class _Stroke {
  final Color color;
  final double width;
  final List<Offset> points;
  _Stroke({required this.color, required this.width, required this.points});
}

class _DrawingPainter extends CustomPainter {
  final List<_Stroke> strokes;
  _DrawingPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    for (final s in strokes) {
      if (s.points.length < 2) {
        if (s.points.length == 1) canvas.drawCircle(s.points[0], s.width / 2, Paint()..color = s.color..style = PaintingStyle.fill);
        continue;
      }
      final paint = Paint()..color = s.color..strokeWidth = s.width..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round..style = PaintingStyle.stroke;
      final path = Path()..moveTo(s.points[0].dx, s.points[0].dy);
      for (int i = 1; i < s.points.length; i++) path.lineTo(s.points[i].dx, s.points[i].dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _DrawingPainter old) => old.strokes != strokes;
}
