import 'dart:math';
import 'package:flutter/material.dart';

class ConfettiWidget extends StatefulWidget {
  final bool trigger;
  final Widget child;
  final int particleCount;
  const ConfettiWidget({super.key, required this.trigger, required this.child, this.particleCount = 40});

  @override
  State<ConfettiWidget> createState() => _ConfettiWidgetState();
}

class _ConfettiWidgetState extends State<ConfettiWidget> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  List<_Particle> _particles = [];
  final _rng = Random();

  static const _colors = [
    Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECB71), Color(0xFF45B7D1),
    Color(0xFF9B59B6), Color(0xFFE67E22), Color(0xFF1ABC9C), Color(0xFFE84393),
    Color(0xFF00CEC9), Color(0xFFFD79A8), Color(0xFF6C5CE7), Color(0xFFFDCB6E),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
  }

  @override
  void didUpdateWidget(ConfettiWidget old) {
    super.didUpdateWidget(old);
    if (widget.trigger && !old.trigger) {
      _explode();
    }
  }

  void _explode() {
    final size = MediaQuery.of(context).size;
    _particles = List.generate(widget.particleCount, (_) => _Particle(
      x: _rng.nextDouble() * size.width,
      y: _rng.nextDouble() * size.height * 0.4,
      color: _colors[_rng.nextInt(_colors.length)],
      radius: 3 + _rng.nextDouble() * 6,
      vx: (_rng.nextDouble() - 0.5) * 400,
      vy: -200 - _rng.nextDouble() * 300,
      rotation: _rng.nextDouble() * pi * 2,
      rotationSpeed: (_rng.nextDouble() - 0.5) * 8,
    ));
    _ctrl.reset();
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(particles: _particles, progress: _ctrl.value),
          ),
        ),
      ],
    );
  }
}

class _Particle {
  final double x, y, vx, vy, radius, rotation, rotationSpeed;
  final Color color;
  _Particle({required this.x, required this.y, required this.vx, required this.vy, required this.radius, required this.color, required this.rotation, required this.rotationSpeed});
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress; // 0→1
  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final dt = 1 / 60;
    for (final p in particles) {
      final t = progress;
      final px = p.x + p.vx * t * dt * 60;
      final py = p.y + p.vy * t * dt * 60 + 0.5 * 600 * t * t;
      final alpha = (1 - t).clamp(0.0, 1.0);
      final scale = 1.0 - t * 0.7;

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation + p.rotationSpeed * t);
      canvas.scale(scale);
      canvas.drawCircle(Offset.zero, p.radius, Paint()..color = p.color.withAlpha((255 * alpha).toInt()));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.progress != progress;
}
