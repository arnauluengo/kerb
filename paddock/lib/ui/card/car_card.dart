import 'package:flutter/material.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/domain/car.dart';
import 'package:paddock/domain/money.dart';
import 'package:paddock/domain/rarity.dart';
import 'package:paddock/l10n/app_localizations.dart';
import 'package:paddock/ui/card/car_silhouette.dart';

/// La carta de colección. Composición cerrada en la spec §11.
///
/// Todo se mide en función del ancho: la misma carta tiene que verse bien en
/// una rejilla de dos columnas y a pantalla completa.
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
          gradient: const RadialGradient(
            center: Alignment(0, -0.45),
            radius: 1.15,
            colors: [Color(0xFF1B1D22), Color(0xFF050506)],
          ),
          boxShadow: [
            BoxShadow(
              color: accent.withValues(alpha: 0.16),
              blurRadius: 26,
              spreadRadius: -4,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Radiuses.card - 2),
          child: Padding(
            padding: EdgeInsets.fromLTRB(s(16), s(14), s(16), s(16)),
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
                            '${_pad(catalogIndex! + 1)} / ${_pad(catalogTotal!)}',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: s(9.5),
                              letterSpacing: 0.6,
                              color: kTextMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: s(6)),
                Expanded(child: _RenderArea(car: car, accent: accent, scale: scale)),
                SizedBox(height: s(8)),
                Text(
                  car.make.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w500,
                    fontSize: s(10),
                    letterSpacing: s(2.4),
                    color: kTextMuted,
                  ),
                ),
                SizedBox(height: s(2)),
                Text(
                  car.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'BarlowCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: s(34),
                    height: 0.98,
                    letterSpacing: 0.2,
                    color: kText,
                  ),
                ),
                SizedBox(height: s(6)),
                Text(
                  _specLine(car),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: s(10),
                    letterSpacing: 0.3,
                    color: kTextMuted,
                  ),
                ),
                SizedBox(height: s(12)),
                if (price != null)
                  Column(
                    key: const Key('card-price'),
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w500,
                          fontSize: s(21),
                          letterSpacing: -0.4,
                          color: kPriceGreen,
                          shadows: const [
                            Shadow(color: Color(0x734ADE80), blurRadius: 14),
                          ],
                        ),
                      ),
                      SizedBox(height: s(2)),
                      Text(
                        l.marketValue.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Barlow',
                          fontSize: s(8.5),
                          letterSpacing: s(1.6),
                          color: kTextMuted,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(height: s(44)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _pad(int n) => n.toString().padLeft(3, '0');

  static String _specLine(Car car) {
    final parts = <String>[
      '${car.yearFrom}',
      if (car.powerHp != null) '${car.powerHp} CV',
      if (car.topSpeedKmh != null) '${car.topSpeedKmh} km/h',
    ];
    return parts.join('  ·  ');
  }

  static String _rarityLabel(AppLocalizations l, RarityTier tier) => switch (tier) {
        RarityTier.common => l.rarityCommon,
        RarityTier.uncommon => l.rarityUncommon,
        RarityTier.rare => l.rarityRare,
        RarityTier.veryRare => l.rarityVeryRare,
        RarityTier.epic => l.rarityEpic,
        RarityTier.legendary => l.rarityLegendary,
      };
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
      padding: EdgeInsets.symmetric(horizontal: 9 * scale, vertical: 4 * scale),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Radiuses.pill),
        border: Border.all(color: accent.withValues(alpha: 0.32), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5 * scale,
            height: 5 * scale,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: accent, blurRadius: 6)],
            ),
          ),
          SizedBox(width: 6 * scale),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w500,
                fontSize: 8.5 * scale,
                letterSpacing: 1.3 * scale,
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
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [accent.withValues(alpha: 0.20), accent.withValues(alpha: 0.0)],
            ),
          ),
        ),
        if (car.renderPath != null)
          Image.network(
            car.renderPath!,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => _placeholder(context),
          )
        else
          _placeholder(context),
      ],
    );
  }

  Widget _placeholder(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Column(
      key: const Key('card-render-placeholder'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: CarSilhouette(color: accent.withValues(alpha: 0.38)),
        ),
        SizedBox(height: 6 * scale),
        Text(
          l.noRender.toUpperCase(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Barlow',
            fontSize: 8 * scale,
            letterSpacing: 1.4 * scale,
            color: kTextMuted,
          ),
        ),
      ],
    );
  }
}
