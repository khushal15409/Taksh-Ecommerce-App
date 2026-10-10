import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Taksh logo that "drives in" like a delivery truck: it rolls in from the
/// left with a small overshoot, then keeps a gentle road-bump bob and tilt
/// while a dashed road line scrolls beneath it.
///
/// Animations are skipped when the system asks to reduce motion.
class AnimatedTakshLogo extends StatefulWidget {
  final String asset;
  final double width;
  final double height;
  final Widget? fallback;

  const AnimatedTakshLogo({
    super.key,
    required this.asset,
    this.width = 118,
    this.height = 48,
    this.fallback,
  });

  @override
  State<AnimatedTakshLogo> createState() => _AnimatedTakshLogoState();
}

class _AnimatedTakshLogoState extends State<AnimatedTakshLogo>
    with TickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
  );
  late final AnimationController _loop = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else {
      _enter.forward();
      _loop.repeat();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    _loop.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      widget.asset,
      width: widget.width,
      height: widget.height,
      fit: BoxFit.contain,
      alignment: Alignment.centerLeft,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stack) =>
          widget.fallback ?? const SizedBox.shrink(),
    );

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: Listenable.merge([_enter, _loop]),
          builder: (context, child) {
            final arrive = Curves.easeOutBack.transform(_enter.value);
            final dx = (1 - arrive) * -(widget.width + 24);
            // Bumpier while rolling in, calmer once parked.
            final settled = Curves.easeIn.transform(
              ((_enter.value - 0.75) / 0.25).clamp(0.0, 1.0),
            );
            final amplitude = 3.0 - 1.6 * settled;
            final phase = _loop.value * 2 * math.pi;
            final bob = math.sin(phase) * amplitude;
            final tilt = math.sin(phase * 2) * 0.01 * (1.2 - settled * 0.6);

            return Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 3,
                  child: CustomPaint(
                    painter: _RoadPainter(
                      progress: _loop.value,
                      opacity: 0.55 - 0.25 * settled,
                    ),
                  ),
                ),
                Positioned.fill(
                  bottom: 3,
                  child: Transform.translate(
                    offset: Offset(dx, bob),
                    child: Transform.rotate(
                      angle: tilt,
                      alignment: Alignment.bottomCenter,
                      child: child,
                    ),
                  ),
                ),
              ],
            );
          },
          child: image,
        ),
      ),
    );
  }
}

/// Dashed road line that scrolls to the left.
class _RoadPainter extends CustomPainter {
  final double progress;
  final double opacity;

  _RoadPainter({required this.progress, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    const dash = 9.0;
    const gap = 7.0;
    const step = dash + gap;
    final paint = Paint()
      ..color = const Color(0xFF2B2B2B).withOpacity(opacity.clamp(0.0, 1.0))
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2;
    final y = size.height / 2;
    var x = -progress * step;
    while (x < size.width) {
      final x1 = math.max(0.0, x);
      final x2 = math.min(size.width, x + dash);
      if (x2 > x1) canvas.drawLine(Offset(x1, y), Offset(x2, y), paint);
      x += step;
    }
  }

  @override
  bool shouldRepaint(covariant _RoadPainter old) =>
      old.progress != progress || old.opacity != opacity;
}
