import 'dart:math';
import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final Point<double> start;
  final double width;
  final Color color;

  DottedDivider({@required this.start, @required this.width, this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _TimelinePainter(
          start: this.start, width: this.width, color: this.color),
      child: SizedBox(width: this.width),
    );
  }
}

class _TimelinePainter extends CustomPainter {
  final Point<double> start;
  final double width;
  final Color color;

  _TimelinePainter({
    @required this.start,
    @required this.width,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const dotGap = 8.0;

    final paint = Paint();
    paint.color = this.color ?? Colors.black;

    double dx = 1.0;
    for (int numberOfDots = width ~/ dotGap + 1;
        numberOfDots > 0;
        numberOfDots--) {
      canvas.drawCircle(Offset(start.x + dx, start.y), 1.0, paint);
      dx += dotGap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
