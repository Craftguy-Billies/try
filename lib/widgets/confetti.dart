import 'dart:math' as math;
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  final bool animate;
  final int particleCount;
  final double spread;
  final Duration duration;
  final Widget? child;

  const ConfettiWidget({
    super.key,
    required this.animate,
    this.particleCount = 30,
    this.spread = 120,
    this.duration = const Duration(milliseconds: 1200),
    this.child,
  });

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _progress;
  final _random = math.Random();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _progress = CurvedAnimation(
      parent: _ctrl,
      curve: Curves.easeOut,
    );
    if (widget.animate) _ctrl.forward();
  }

  @override
  void didUpdateWidget(covariant ConfettiWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !oldWidget.animate) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        final opacity = (1.0 - _progress.value).clamp(0.0, 1.0);
        if (opacity <= 0) return widget.child ?? const SizedBox.shrink();

        return Stack(
          children: [
            if (widget.child != null) widget.child!,
            IgnorePointer(
              child: CustomPaint(
                size: Size.infinite,
                painter: _ConfettiPainter(
                  progress: _progress.value,
                  particleCount: widget.particleCount,
                  spread: widget.spread,
                  random: _random,
                  opacity: opacity,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  final double progress;
  final int particleCount;
  final double spread;
  final math.Random random;
  final double opacity;

  _ConfettiPainter({
    required this.progress,
    required this.particleCount,
    required this.spread,
    required this.random,
    required this.opacity,
  });

  static const _colors = [
    Color(0xFFE91E63),
    Color(0xFF2196F3),
    Color(0xFF4CAF50),
    Color(0xFFFFC107),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF3F51B5),
    Color(0xFF8BC34A),
    Color(0xFFFFEB3B),
    Color(0xFFF44336),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < particleCount; i++) {
      _drawParticle(canvas, center, i);
    }
  }

  void _drawParticle(Canvas canvas, Offset origin, int seed) {
    final color = _colors[seed % _colors.length];
    final angle = (seed / particleCount) * math.pi * 2 +
        random.nextDouble() * 0.5;
    final distance = spread * progress + random.nextDouble() * 40;
    final dx = math.cos(angle) * distance;
    final dy = math.sin(angle) * distance - progress * 60 * (0.5 + random.nextDouble() * 0.5);

    final x = origin.dx + dx;
    final y = origin.dy + dy;
    final rotation = random.nextDouble() * math.pi * 2 * progress;

    final particleSize =
        4.0 + random.nextDouble() * 8.0;
    final currentOpacity =
        (opacity * (1.0 - progress * 0.6)).clamp(0.05, 1.0);

    final paint = Paint()
      ..color = color.withAlpha((255 * currentOpacity).round())
      ..style = PaintingStyle.fill;

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);

    final shapeType = seed % 3;
    switch (shapeType) {
      case 0:
        canvas.drawCircle(Offset.zero, particleSize / 2, paint);
        break;
      case 1:
        canvas.drawRect(
          Rect.fromCenter(
              center: Offset.zero,
              width: particleSize,
              height: particleSize * 0.6),
          paint,
        );
        break;
      case 2:
        final path = Path()
          ..moveTo(0, -particleSize / 2)
          ..lineTo(particleSize / 2, particleSize / 2)
          ..lineTo(-particleSize / 2, particleSize / 2)
          ..close();
        canvas.drawPath(path, paint);
        break;
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return progress != oldDelegate.progress ||
        opacity != oldDelegate.opacity;
  }
}
