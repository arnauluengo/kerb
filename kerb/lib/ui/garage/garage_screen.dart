import 'package:flutter/material.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_card.dart';

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
    return entries.where((e) {
      final car = widget.repository.catalog.byId(e.carId);
      return car?.rarity == _filter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final entries = widget.repository.entries;
    final total = formatPrice(
      widget.repository.totalValueEur(),
      currency: widget.currency,
    );

    return Scaffold(
      backgroundColor: kBg,
      floatingActionButton: entries.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: widget.onAddCar,
              backgroundColor: kGold,
              foregroundColor: kBg,
              child: const Icon(Icons.add),
            ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      l.garageTitle,
                      style: const TextStyle(
                        fontFamily: 'BarlowCondensed',
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        height: 1,
                        color: kText,
                      ),
                    ),
                  ),
                  if (total != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          l.marketValue.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Barlow',
                            fontSize: 8.5,
                            letterSpacing: 1.6,
                            color: kTextMuted,
                          ),
                        ),
                        Text(
                          total,
                          style: const TextStyle(
                            fontFamily: 'JetBrainsMono',
                            fontWeight: FontWeight.w500,
                            fontSize: 17,
                            color: kPriceGreen,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            if (entries.isNotEmpty) ...[
              const SizedBox(height: Space.lg),
              _RarityFilter(
                selected: _filter,
                available: entries
                    .map((e) => widget.repository.catalog.byId(e.carId)?.rarity)
                    .whereType<RarityTier>()
                    .toSet(),
                onChanged: (tier) => setState(() => _filter = tier),
              ),
              const SizedBox(height: Space.md),
            ],
            Expanded(
              child: entries.isEmpty
                  ? _EmptyGarage(l: l, onScan: widget.onAddCar)
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        Space.xl,
                        Space.xs,
                        Space.xl,
                        Space.xxl,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.5,
                        mainAxisSpacing: Space.lg,
                        crossAxisSpacing: Space.lg,
                      ),
                      itemCount: _visible.length,
                      itemBuilder: (context, index) {
                        final entry = _visible[index];
                        final car = widget.repository.catalog.byId(entry.carId);
                        if (car == null) return const SizedBox.shrink();
                        return LayoutBuilder(
                          builder: (context, constraints) => Align(
                            alignment: Alignment.topCenter,
                            child: CarCard(
                              car: car,
                              currency: widget.currency,
                              width: constraints.maxWidth,
                              catalogIndex: index,
                              catalogTotal: _visible.length,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyGarage extends StatelessWidget {
  const _EmptyGarage({required this.l, this.onScan});

  final AppLocalizations l;
  final VoidCallback? onScan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 44,
              color: kTextMuted.withValues(alpha: 0.5),
            ),
            const SizedBox(height: Space.xl),
            Text(
              l.garageEmptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'BarlowCondensed',
                fontWeight: FontWeight.w700,
                fontSize: 26,
                height: 1.1,
                color: kText,
              ),
            ),
            const SizedBox(height: Space.sm),
            Text(
              l.garageEmptyBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Barlow',
                fontSize: 14,
                height: 1.4,
                color: kTextMuted,
              ),
            ),
            const SizedBox(height: Space.xl),
            FilledButton.icon(
              onPressed: onScan,
              style: FilledButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: kBg,
                padding: const EdgeInsets.symmetric(
                  horizontal: Space.xl,
                  vertical: Space.lg,
                ),
              ),
              icon: const Icon(Icons.camera_alt_outlined, size: 20),
              label: Text(
                l.scanCta,
                style: const TextStyle(
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RarityFilter extends StatelessWidget {
  const _RarityFilter({
    required this.selected,
    required this.available,
    required this.onChanged,
  });

  final RarityTier? selected;
  final Set<RarityTier> available;
  final ValueChanged<RarityTier?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final tiers = RarityTier.values.where(available.contains).toList();

    return SizedBox(
      height: 30,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: Space.xl),
        children: [
          _Chip(
            label: l.filterAll,
            color: kText,
            selected: selected == null,
            onTap: () => onChanged(null),
          ),
          for (final tier in tiers)
            _Chip(
              label: _label(l, tier),
              color: rarityColor(tier),
              selected: selected == tier,
              onTap: () => onChanged(selected == tier ? null : tier),
            ),
        ],
      ),
    );
  }

  static String _label(AppLocalizations l, RarityTier tier) => switch (tier) {
        RarityTier.common => l.rarityCommon,
        RarityTier.uncommon => l.rarityUncommon,
        RarityTier.rare => l.rarityRare,
        RarityTier.veryRare => l.rarityVeryRare,
        RarityTier.epic => l.rarityEpic,
        RarityTier.legendary => l.rarityLegendary,
      };
}

class _Chip extends StatelessWidget {
  const _Chip({
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
    return Padding(
      padding: const EdgeInsets.only(right: Space.sm),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.14) : kSurface,
            borderRadius: BorderRadius.circular(Radiuses.pill),
            border: Border.all(
              color: selected ? color.withValues(alpha: 0.55) : kSurfaceHigh,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w500,
              fontSize: 9,
              letterSpacing: 1.1,
              color: selected ? color : kTextMuted,
            ),
          ),
        ),
      ),
    );
  }
}
