import 'package:flutter/material.dart';

/// Custom vector brand icons used when no suitable Material icon exists.
class AppIcons {
  AppIcons._();

  static Widget lightning({double size = 24, Color? color}) {
    final c = color ?? Colors.white;
    return CustomPaint(
      size: Size(size, size),
      painter: _LightningPainter(color: c),
    );
  }
}

class _LightningPainter extends CustomPainter {
  final Color color;

  _LightningPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.54, size.height * 0.08)
      ..lineTo(size.width * 0.12, size.height * 0.58)
      ..lineTo(size.width * 0.42, size.height * 0.58)
      ..lineTo(size.width * 0.38, size.height * 0.92)
      ..lineTo(size.width * 0.92, size.height * 0.42)
      ..lineTo(size.width * 0.58, size.height * 0.42)
      ..close();

    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
