import 'package:flutter/material.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_card.dart';
import 'package:kerb/ui/card/car_silhouette.dart';
import 'package:kerb/ui/widgets/kerb_bits.dart';

/// El garaje: la pantalla que el usuario ve cien veces al día.
///
/// La jerarquía es deliberada: primero cuánto has coleccionado (cifra y valor),
/// después cómo vas del catálogo, y solo entonces las cartas.
class GarageScreen extends StatefulWidget {
  const GarageScreen({
    super.key,
    required this.repository,
    this.currency = Currency.eur,
    this.onAddCar,
  });

  final GarageRepository repository;
  final Currency currency;

  /// Abre el flujo de añadir coche. Hoy lleva al buscador; cuando exista el
  /// escáner, llevará a la cámara.
  final VoidCallback? onAddCar;

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  RarityTier? _filter;

  List<GarageEntry> get _visible {
    final entries = widget.repository.entries;
    if (_filter == null) return entries;
    return entries.where((entry) {
      final car = widget.repository.catalog.byId(entry.carId);
      return car?.rarity == _filter;
    }).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final entries = widget.repository.entries;
    final total = widget.repository.catalog.length;
    final progress = total == 0 ? 0.0 : entries.length / total;

    return Scaffold(
      backgroundColor: KerbColors.navy,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xl,
                  Space.lg,
                  Space.xl,
                  Space.xl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        const KerbWordmark(size: 21),
                        const Spacer(),
                        const Monogram(text: 'K', size: 34),
                      ],
                    ),
                    const SizedBox(height: Space.xxl),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Kicker(l.collection),
                              const SizedBox(height: Space.sm),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerLeft,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      entries.length.toString().padLeft(2, '0'),
                                      style: const TextStyle(
                                        fontFamily: KerbType.mono,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 46,
                                        height: 0.9,
                                        letterSpacing: -2,
                                        color: KerbColors.cream,
                                      ),
                                    ),
                                    const SizedBox(width: Space.sm),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        '/ $total',
                                        style: KerbType.numeral.copyWith(
                                          color: KerbColors.muted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Kicker(l.totalValue),
                              ),
                              const SizedBox(height: Space.sm),
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  formatPrice(
                                        widget.repository.totalValueEur(),
                                        currency: widget.currency,
                                      ) ??
                                      '—',
                                  maxLines: 1,
                                  softWrap: false,
                                  style: const TextStyle(
                                    fontFamily: KerbType.mono,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 22,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                    color: KerbColors.value,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Space.lg),
                    _ProgressBar(progress: progress),
                    const SizedBox(height: Space.sm),
                    Row(
                      children: [
                        Text(
                          '${(progress * 100).toStringAsFixed(1)} %',
                          style: KerbType.numeral.copyWith(
                            fontSize: 11,
                            color: KerbColors.cream,
                          ),
                        ),
                        const SizedBox(width: Space.sm),
                        Kicker(l.catalogProgress),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (entries.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyGarage(onAddCar: widget.onAddCar),
              )
            else ...[
              SliverToBoxAdapter(
                child: _FilterStrip(
                  selected: _filter,
                  onChanged: (tier) => setState(() => _filter = tier),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  Space.xl,
                  Space.lg,
                  Space.xl,
                  140,
                ),
                sliver: SliverGrid(
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 205,
                    mainAxisSpacing: Space.xl,
                    crossAxisSpacing: Space.lg,
                    childAspectRatio: 1 / 1.5,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = _visible[index];
                      final car = widget.repository.catalog.byId(entry.carId);
                      if (car == null) return const SizedBox.shrink();
                      return LayoutBuilder(
                        builder: (context, constraints) => CarCard(
                          car: car,
                          currency: widget.currency,
                          width: constraints.maxWidth,
                          catalogIndex:
                              widget.repository.catalog.all.indexOf(car),
                          catalogTotal: total,
                        ),
                      );
                    },
                    childCount: _visible.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(Radiuses.pill),
      child: Stack(
        children: [
          Container(height: 3, color: KerbColors.hairline),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              height: 3,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [KerbColors.brick, Color(0xFFE0533B)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterStrip extends StatelessWidget {
  const _FilterStrip({required this.selected, required this.onChanged});

  final RarityTier? selected;
  final ValueChanged<RarityTier?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return SizedBox(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: Space.xl),
        children: [
          _FilterChip(
            label: l.filterAll,
            color: KerbColors.cream,
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: Space.sm),
          for (final tier in RarityTier.values) ...[
            _FilterChip(
              label: _label(l, tier),
              color: rarityColor(tier),
              selected: selected == tier,
              onTap: () => onChanged(tier),
            ),
            const SizedBox(width: Space.sm),
          ],
        ],
      ),
    );
  }

  static String _label(AppLocalizations l, RarityTier tier) =>
      switch (tier) {
        RarityTier.uncommon => l.rarityUncommon,
        RarityTier.rare => l.rarityRare,
        RarityTier.veryRare => l.rarityVeryRare,
        RarityTier.epic => l.rarityEpic,
        RarityTier.mythic => l.rarityMythic,
        RarityTier.legendary => l.rarityLegendary,
      };
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: KerbMotion.fast,
        curve: KerbMotion.enter,
        padding: const EdgeInsets.symmetric(
          horizontal: Space.md,
          vertical: Space.xs,
        ),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(Radiuses.pill),
          border: Border.all(
            color: selected ? color.withValues(alpha: 0.6) : KerbColors.hairline,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: KerbType.sans,
            fontWeight: FontWeight.w500,
            fontSize: 9.5,
            letterSpacing: 1.3,
            color: selected ? color : KerbColors.muted,
          ),
        ),
      ),
    );
  }
}

class _EmptyGarage extends StatelessWidget {
  const _EmptyGarage({this.onAddCar});

  final VoidCallback? onAddCar;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(Space.xl, Space.xl, Space.xl, 120),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const _Radar(),
          const SizedBox(height: Space.xl),
          Text(
            l.garageEmptyTitle,
            textAlign: TextAlign.center,
            style: KerbType.section,
          ),
          const SizedBox(height: Space.md),
          Text(
            l.garageEmptyBody,
            textAlign: TextAlign.center,
            style: KerbType.bodyMuted,
          ),
          const SizedBox(height: Space.xl),
          KerbButton(
            label: l.scanCta,
            icon: Icons.camera_alt_outlined,
            onPressed: onAddCar,
          ),
        ],
      ),
    );
  }
}

/// Círculos concéntricos con una silueta dentro: el garaje vacío como un
/// radar encendido, no como una pantalla de error.
class _Radar extends StatelessWidget {
  const _Radar();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          for (final size in [190.0, 138.0, 86.0])
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: KerbColors.hairline),
              ),
            ),
          SizedBox(
            width: 130,
            height: 82,
            child: CarSilhouette(
              color: KerbColors.brick.withValues(alpha: 0.55),
            ),
          ),
        ],
      ),
    );
  }
}
