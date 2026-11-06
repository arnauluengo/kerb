import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/domain/car.dart';
import 'package:paddock/domain/money.dart';
import 'package:paddock/domain/rarity.dart';
import 'package:paddock/l10n/app_localizations.dart';

/// La carta de colección. Composición cerrada en la spec §11.
class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.car,
    required this.currency,
    this.width = 286,
    this.catalogIndex,
    this.catalogTotal,
  });

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
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RarityPill(tier: car.rarity, accent: accent, label: _rarityLabel(l, car.rarity)),
                    if (catalogIndex != null && catalogTotal != null)
                      Text(
                        '${_pad(catalogIndex! + 1)} / ${_pad(catalogTotal!)}',
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontSize: 9.5,
                          letterSpacing: 0.6,
                          color: kTextMuted,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Expanded(child: _RenderArea(car: car, accent: accent)),
                const SizedBox(height: 8),
                Text(
                  car.make.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                    letterSpacing: 2.4,
                    color: kTextMuted,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  car.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'BarlowCondensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 34,
                    height: 0.98,
                    letterSpacing: 0.2,
                    color: kText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _specLine(car),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 10,
                    letterSpacing: 0.3,
                    color: kTextMuted,
                  ),
                ),
                const SizedBox(height: 12),
                if (price != null)
                  Column(
                    key: const Key('card-price'),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontFamily: 'JetBrainsMono',
                          fontWeight: FontWeight.w500,
                          fontSize: 21,
                          letterSpacing: -0.4,
                          color: kPriceGreen,
                          shadows: [
                            Shadow(color: Color(0x734ADE80), blurRadius: 14),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l.marketValue.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'Barlow',
                          fontSize: 8.5,
                          letterSpacing: 1.6,
                          color: kTextMuted,
                        ),
                      ),
                    ],
                  )
                else
                  const SizedBox(height: 44),
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
    required this.tier,
    required this.accent,
    required this.label,
  });

  final RarityTier tier;
  final Color accent;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(Radiuses.pill),
        border: Border.all(color: accent.withValues(alpha: 0.32), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: accent,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: accent, blurRadius: 6)],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
              fontSize: 8.5,
              letterSpacing: 1.3,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

class _RenderArea extends StatelessWidget {
  const _RenderArea({required this.car, required this.accent});

  final Car car;
  final Color accent;

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
            errorBuilder: (_, __, ___) => _placeholder(context),
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
          child: CustomPaint(
            painter: _CarSilhouettePainter(color: accent.withValues(alpha: 0.38)),
            size: Size.infinite,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          l.noRender.toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Barlow',
            fontSize: 8,
            letterSpacing: 1.4,
            color: kTextMuted,
          ),
        ),
      ],
    );
  }
}

/// Silueta de perfil bajo, dibujada a mano. Es un marcador de posición: cuando
/// el lote de renders exista, esto no se ve nunca.
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
