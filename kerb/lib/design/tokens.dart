import 'package:flutter/material.dart';

/// Fondo de la app: casi negro, no negro puro.
const Color kBg = Color(0xFF0A0A0B);

/// Superficie de las cartas y hojas.
const Color kSurface = Color(0xFF141518);

/// Superficie elevada (píldoras, chips).
const Color kSurfaceHigh = Color(0xFF1E2025);

/// Texto principal.
const Color kText = Color(0xFFF5F5F7);

/// Texto secundario.
const Color kTextMuted = Color(0xFF8A8D96);

/// Precio. Verde, siempre.
const Color kPriceGreen = Color(0xFF4ADE80);

/// Oro de los detalles de marca.
const Color kGold = Color(0xFFF5B942);

/// Borde de una carta sin render generado.
const Color kPlaceholderBorder = Color(0xFF2A2C33);

/// Escala de espaciado. Todo el layout usa estos valores.
abstract final class Space {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Radios de esquina.
abstract final class Radiuses {
  static const double card = 18;
  static const double pill = 999;
}
