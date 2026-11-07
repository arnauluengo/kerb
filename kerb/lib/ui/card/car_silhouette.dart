import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Silueta de perfil bajo dibujada a mano. Marcador de posición mientras un
/// coche no tiene render generado.
class CarSilhouette extends StatelessWidget {
  const CarSilhouette({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CarSilhouettePainter(color: color),
      size: Size.infinite,
    );
  }
}

class _CarSilhouettePainter extends CustomPainter {
  const _CarSilhouettePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    final body = Path()
      ..moveTo(w * 0.04, h * 0.70)
      ..cubicTo(w * 0.04, h * 0.58, w * 0.10, h * 0.54, w * 0.20, h * 0.53)
      ..lineTo(w * 0.33, h * 0.51)
      ..cubicTo(w * 0.41, h * 0.30, w * 0.50, h * 0.23, w * 0.60, h * 0.25)
      ..cubicTo(w * 0.70, h * 0.27, w * 0.77, h * 0.38, w * 0.83, h * 0.49)
      ..lineTo(w * 0.93, h * 0.53)
      ..cubicTo(w * 0.97, h * 0.55, w * 0.98, h * 0.62, w * 0.98, h * 0.70)
      ..lineTo(w * 0.04, h * 0.70)
      ..close();

    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawPath(body, Paint()..color = color);

    final cut = Paint()..blendMode = ui.BlendMode.clear;
    canvas.drawCircle(Offset(w * 0.25, h * 0.70), h * 0.13, cut);
    canvas.drawCircle(Offset(w * 0.77, h * 0.70), h * 0.13, cut);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_CarSilhouettePainter oldDelegate) =>
      oldDelegate.color != color;
}
