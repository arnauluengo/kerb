import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// Silueta de perfil de un deportivo, dibujada a mano.
///
/// No pretende ser un coche concreto: es la ausencia de foto. Se dibuja como
/// una lámina técnica —relleno translúcido, contorno nítido y una sombra de
/// suelo— para que una carta sin avistar siga pareciendo intencionada.
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

    // Proporciones: morro bajo, parabrisas muy tumbado, techo corto y cola
    // alta. Es la silueta de un coche de los 80-90, no de una berlina.
    final body = Path()
      ..moveTo(w * 0.03, h * 0.76)
      ..lineTo(w * 0.03, h * 0.60)
      ..cubicTo(w * 0.05, h * 0.55, w * 0.13, h * 0.53, w * 0.22, h * 0.52)
      ..lineTo(w * 0.30, h * 0.50)
      ..cubicTo(w * 0.38, h * 0.31, w * 0.44, h * 0.26, w * 0.53, h * 0.26)
      ..cubicTo(w * 0.62, h * 0.26, w * 0.68, h * 0.36, w * 0.74, h * 0.45)
      ..lineTo(w * 0.86, h * 0.48)
      ..cubicTo(w * 0.93, h * 0.49, w * 0.97, h * 0.53, w * 0.97, h * 0.60)
      ..lineTo(w * 0.97, h * 0.76)
      ..close();

    // Sombra de suelo: una elipse difusa que asienta el coche.
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.80),
        width: w * 0.86,
        height: h * 0.09,
      ),
      Paint()
        ..color = color.withValues(alpha: 0.10)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );

    // Relleno translúcido, de arriba abajo.
    canvas.drawPath(
      body,
      Paint()
        ..shader = ui.Gradient.linear(
          Offset(0, h * 0.24),
          Offset(0, h * 0.78),
          [
            color.withValues(alpha: 0.30),
            color.withValues(alpha: 0.08),
          ],
        ),
    );

    // Contorno nítido.
    canvas.drawPath(
      body,
      Paint()
        ..color = color.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..strokeJoin = StrokeJoin.round,
    );

    // Cavidades de las ruedas: se recortan para que se lea "coche" y no "cuña".
    canvas.saveLayer(Offset.zero & size, Paint());
    final cut = Paint()..blendMode = ui.BlendMode.clear;
    canvas.drawCircle(Offset(w * 0.23, h * 0.76), h * 0.115, cut);
    canvas.drawCircle(Offset(w * 0.79, h * 0.76), h * 0.115, cut);
    canvas.restore();

    // Llantas: dos aros finos, sin radios. Menos ruido.
    final rim = Paint()
      ..color = color.withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;
    canvas.drawCircle(Offset(w * 0.23, h * 0.76), h * 0.072, rim);
    canvas.drawCircle(Offset(w * 0.79, h * 0.76), h * 0.072, rim);

    // Detalles: línea de cintura y salida de escape.
    final detail = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(w * 0.08, h * 0.59),
      Offset(w * 0.30, h * 0.56),
      detail,
    );
    canvas.drawLine(
      Offset(w * 0.74, h * 0.52),
      Offset(w * 0.94, h * 0.56),
      detail,
    );
    canvas.drawCircle(Offset(w * 0.93, h * 0.70), h * 0.018, detail);
  }

  @override
  bool shouldRepaint(_CarSilhouettePainter oldDelegate) =>
      oldDelegate.color != color;
}
