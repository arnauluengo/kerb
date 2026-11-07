import 'package:flutter/material.dart';

/// Paleta de Kerb. Tema oscuro único, sin variante clara.
///
/// La dirección es editorial-automovilística: azul marino profundo de fondo,
/// cartas en asfalto con filete de crema, y el ladrillo como única nota de
/// color fuerte. Nada de degradados de arcoíris ni de cristal esmerilado: el
/// lujo aquí se hace con tipografía, aire y precisión.
abstract final class KerbColors {
  /// Fondo profundo de la app.
  static const Color navy = Color(0xFF14233B);

  /// Texto principal. Nunca blanco puro: el crema evita el brillo de pantalla.
  static const Color cream = Color(0xFFEDE6D6);

  /// Superficie de las cartas. Casi negro, con una pizca de azul.
  static const Color asphalt = Color(0xFF1A1B1E);

  /// Acento. Acciones primarias, rarezas altas, el sello de Kerb.
  static const Color brick = Color(0xFFC2402A);

  /// Texto secundario y metadatos.
  static const Color muted = Color(0xFF8C93A3);

  /// Valor monetario. Verde solo para dinero.
  static const Color value = Color(0xFF4ADE80);

  // --- Derivados de la paleta ------------------------------------------------

  /// Fondo más profundo que el marino, para pozos y degradados.
  static const Color ink = Color(0xFF0C1524);

  /// Superficie elevada (hojas, píldoras, barra inferior).
  static const Color raised = Color(0xFF1D2E48);

  /// Superficie aún más elevada (estados pulsados, controles).
  static const Color raisedHigh = Color(0xFF273A59);

  /// Filete de 1 px. El crema rebajado en vez de gris: mantiene la calidez.
  static const Color hairline = Color(0x24EDE6D6);

  /// Filete de énfasis para focos y bordes activos.
  static const Color hairlineStrong = Color(0x59EDE6D6);

  /// Ladrillo translúcido para fondos de etiqueta.
  static const Color brickWash = Color(0x2EC2402A);

  /// Crema rebajado, para texto sobre superficies claras o deshabilitado.
  static const Color creamDim = Color(0x99EDE6D6);

  /// Sombra de las cartas. Cálida, nunca gris azulada.
  static const Color shadow = Color(0x8C000000);
}

/// Tokens heredados. Se mantienen como alias para no romper el código que aún
/// los usa; apuntan todos a la paleta Kerb. Código nuevo: usa [KerbColors].
const Color kBg = KerbColors.navy;
const Color kSurface = KerbColors.asphalt;
const Color kSurfaceHigh = KerbColors.raised;
const Color kText = KerbColors.cream;
const Color kTextMuted = KerbColors.muted;
const Color kPriceGreen = KerbColors.value;
const Color kGold = KerbColors.brick;
const Color kPlaceholderBorder = KerbColors.hairline;

/// Escala de espaciado. Todo el layout usa estos valores; nada de números
/// sueltos en los widgets.
abstract final class Space {
  static const double xxs = 2;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
  static const double huge = 64;
}

/// Radios de esquina.
abstract final class Radiuses {
  static const double chip = 8;
  static const double card = 18;
  static const double sheet = 28;
  static const double pill = 999;
}

/// Curvas de animación. Una sola familia para que la app se sienta de una pieza.
abstract final class KerbMotion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration normal = Duration(milliseconds: 260);
  static const Duration slow = Duration(milliseconds: 420);
  static const Duration reveal = Duration(milliseconds: 1200);

  static const Curve enter = Curves.easeOutCubic;
  static const Curve exit = Curves.easeInCubic;
  static const Curve spring = Curves.easeOutBack;
}

/// Tipografía. Barlow para leer, Barlow Condensed para titular, JetBrains Mono
/// para cifras. El mono no es decorativo: precios, contadores y años alinean en
/// columna, como en una ficha técnica.
abstract final class KerbType {
  static const String sans = 'Barlow';
  static const String display = 'BarlowCondensed';
  static const String mono = 'JetBrainsMono';

  /// Cifra o placa grande. El gesto tipográfico de la carta.
  static const TextStyle hero = TextStyle(
    fontFamily: display,
    fontWeight: FontWeight.w700,
    fontSize: 52,
    height: 0.9,
    letterSpacing: 0.2,
    color: KerbColors.cream,
  );

  /// Titular de pantalla.
  static const TextStyle section = TextStyle(
    fontFamily: display,
    fontWeight: FontWeight.w700,
    fontSize: 34,
    height: 0.95,
    letterSpacing: 0.3,
    color: KerbColors.cream,
  );

  /// Título de bloque.
  static const TextStyle title = TextStyle(
    fontFamily: display,
    fontWeight: FontWeight.w600,
    fontSize: 22,
    height: 1.05,
    letterSpacing: 0.4,
    color: KerbColors.cream,
  );

  /// Cuerpo.
  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
    color: KerbColors.cream,
  );

  /// Cuerpo secundario.
  static const TextStyle bodyMuted = TextStyle(
    fontFamily: sans,
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 1.4,
    color: KerbColors.muted,
  );

  /// Etiqueta de sección: mayúsculas, muy espaciada, pequeña.
  static const TextStyle label = TextStyle(
    fontFamily: sans,
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 1.2,
    letterSpacing: 2,
    color: KerbColors.muted,
  );

  /// Cifra en monoespaciada.
  static const TextStyle numeral = TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w500,
    fontSize: 15,
    height: 1.1,
    letterSpacing: 0.4,
    color: KerbColors.cream,
  );

  /// Cifra grande (valor del garaje).
  static const TextStyle numeralLarge = TextStyle(
    fontFamily: mono,
    fontWeight: FontWeight.w500,
    fontSize: 30,
    height: 1,
    letterSpacing: -0.5,
    color: KerbColors.cream,
  );
}

/// Sombras. Una sola receta: sombra amplia y difusa que separa la carta del
/// fondo sin dibujar un borde duro.
abstract final class KerbShadows {
  static const List<BoxShadow> card = <BoxShadow>[
    BoxShadow(color: KerbColors.shadow, blurRadius: 28, offset: Offset(0, 14)),
  ];

  static const List<BoxShadow> raised = <BoxShadow>[
    BoxShadow(color: KerbColors.shadow, blurRadius: 40, offset: Offset(0, 20)),
  ];
}
