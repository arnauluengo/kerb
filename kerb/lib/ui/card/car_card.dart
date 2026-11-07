import 'package:flutter/material.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/car.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_silhouette.dart';

/// La carta de colección. Composición cerrada en la spec §11.
///
/// Todo se mide en función del ancho: la misma carta tiene que verse bien en
/// una rejilla de dos columnas y a pantalla completa. El truco del diseño es la
/// jerarquía: la rareza manda en el color, el modelo manda en el tamaño y el
/// dinero es lo único verde de la pantalla.
class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    required this.currency,
    this.width = 286,
    this.catalogIndex,
    this.catalogTotal,
  });

  static const double _designWidth = 286;

  final Car car;
  final Currency currency;
  final double width;

  /// Posición 0-based en el catálogo. Si es null, no se dibuja el contador.
  final int? catalogIndex;
  final int? catalogTotal;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final accent = rarityColor(car.rarity);
    final price = formatPrice(car.marketPriceEur, currency: currency);
    final scale = (width / _designWidth).clamp(0.55, 1.4);
    double s(double value) => value * scale;

    return SizedBox(
      width: width,
      height: width * 1.5,
      child: Container(
        key: const Key('card-border'),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Radiuses.card),
          border: Border.all(color: accent, width: 2),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF232833), KerbColors.asphalt, Color(0xFF111214)],
            stops: [0, 0.55, 1],
          ),
          boxShadow: [
            BoxShadow(
              color: KerbColors.shadow,
              blurRadius: 30,
              offset: const Offset(0, 16),
            ),
            BoxShadow(
              color: accent.withValues(alpha: 0.18),
              blurRadius: 34,
              spreadRadius: -8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radiuses.card - 2),
          child: Stack(
            children: [
              // Brillo de rareza que entra desde arriba, como la luz de una
              // vitrina. Muy sutil: si se nota, está mal.
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.65),
                      radius: 1.05,
                      colors: [
                        accent.withValues(alpha: 0.20),
                        accent.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: _CornerMarksPainter(color: KerbColors.cream),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(s(16), s(13), s(16), s(15)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: _RarityPill(
                            accent: accent,
                            label: _rarityLabel(l, car.rarity),
                            scale: scale,
                          ),
                        ),
                        if (catalogIndex != null && catalogTotal != null) ...[
                          SizedBox(width: s(4)),
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${_pad(catalogIndex! + 1)} / '
                                '${_pad(catalogTotal!)}',
                                style: TextStyle(
                                  fontFamily: KerbType.mono,
                                  fontSize: s(9),
                                  letterSpacing: 1,
                                  color: KerbColors.muted,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: s(4)),
                    Expanded(
                      child: _RenderArea(
                        car: car,
                        accent: accent,
                        scale: scale,
                      ),
                    ),
                    SizedBox(height: s(4)),
                    Row(
                      children: [
                        Container(
                          width: s(4),
                          height: s(4),
                          decoration: BoxDecoration(
                            color: accent,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                        SizedBox(width: s(6)),
                        Expanded(
                          child: Text(
                            car.make.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: KerbType.sans,
                              fontWeight: FontWeight.w500,
                              fontSize: s(9.5),
                              letterSpacing: s(2.2),
                              color: KerbColors.muted,
                            ),
                          ),
                        ),
                        if (car.productionUnits != null)
                          Text(
                            '${_compactUnits(car.productionUnits!)} UDS',
                            style: TextStyle(
                              fontFamily: KerbType.mono,
                              fontSize: s(8),
                              letterSpacing: 0.4,
                              color: KerbColors.muted.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: s(3)),
                    Text(
                      car.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: KerbType.display,
                        fontWeight: FontWeight.w700,
                        fontSize: s(34),
                        height: 0.94,
                        letterSpacing: 0.2,
                        color: KerbColors.cream,
                      ),
                    ),
                    SizedBox(height: s(5)),
                    Text(
                      _specLine(car),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: KerbType.mono,
                        fontSize: s(9),
                        letterSpacing: 0.4,
                        color: KerbColors.muted,
                      ),
                    ),
                    SizedBox(height: s(9)),
                    Container(height: 1, color: KerbColors.hairline),
                    SizedBox(height: s(9)),
                    if (price != null)
                      Column(
                        key: const Key('card-price'),
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            price,
                            style: TextStyle(
                              fontFamily: KerbType.mono,
                              fontWeight: FontWeight.w500,
                              fontSize: s(20),
                              letterSpacing: -0.4,
                              color: KerbColors.value,
                              shadows: const [
                                Shadow(color: Color(0x664ADE80), blurRadius: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: s(2)),
                          Text(
                            l.marketValue.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: KerbType.sans,
                              fontSize: s(8),
                              letterSpacing: s(1.7),
                              color: KerbColors.muted,
                            ),
                          ),
                        ],
                      )
                    else
                      SizedBox(height: s(40)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _pad(int n) => n.toString().padLeft(3, '0');

  /// 39.000 unidades se lee peor que "39K". En una carta, gana el espacio.
  static String _compactUnits(int units) {
    if (units >= 1000) {
      final k = units / 1000;
      return k >= 10 ? '${k.round()}K' : '${k.toStringAsFixed(1)}K';
    }
    return '$units';
  }

  static String _specLine(Car car) {
    final parts = <String>[
      '${car.yearFrom}',
      if (car.powerHp != null) '${car.powerHp} CV',
      if (car.topSpeedKmh != null) '${car.topSpeedKmh} KM/H',
    ];
    return parts.join('  ·  ');
  }

  static String _rarityLabel(AppLocalizations l, RarityTier tier) =>
      switch (tier) {
        RarityTier.uncommon => l.rarityUncommon,
        RarityTier.rare => l.rarityRare,
        RarityTier.veryRare => l.rarityVeryRare,
        RarityTier.epic => l.rarityEpic,
        RarityTier.mythic => l.rarityMythic,
        RarityTier.legendary => l.rarityLegendary,
      };
}

/// Marcas de encuadre en las cuatro esquinas. Es el detalle que separa una
/// carta de una caja: parece una ficha de museo, no un widget.
class _CornerMarksPainter extends CustomPainter {
  const _CornerMarksPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.16)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const inset = 7.0;
    const len = 10.0;

    void corner(double x, double y, double dx, double dy) {
      canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
      canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
    }

    corner(inset, inset, len, len);
    corner(size.width - inset, inset, -len, len);
    corner(inset, size.height - inset, len, -len);
    corner(size.width - inset, size.height - inset, -len, -len);
  }

  @override
  bool shouldRepaint(_CornerMarksPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _RarityPill extends StatelessWidget {
  const _RarityPill({
    required this.accent,
    required this.label,
    required this.scale,
  });

  final Color accent;
  final String label;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8 * scale, vertical: 3.5 * scale),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Radiuses.chip),
        border: Border.all(color: accent.withValues(alpha: 0.34), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 4.5 * scale,
            height: 4.5 * scale,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: accent, blurRadius: 6)],
            ),
          ),
          SizedBox(width: 5.5 * scale),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: KerbType.sans,
                fontWeight: FontWeight.w600,
                fontSize: 8.5 * scale,
                letterSpacing: 1.4 * scale,
                color: accent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RenderArea extends StatelessWidget {
  const _RenderArea({
    required this.car,
    required this.accent,
    required this.scale,
  });

  final Car car;
  final Color accent;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Halo de rareza detrás del coche.
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  accent.withValues(alpha: 0.18),
                  accent.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6 * scale),
          child: CarSilhouette(
            key: const Key('card-render-placeholder'),
            color: accent,
          ),
        ),
      ],
    );
  }
}
