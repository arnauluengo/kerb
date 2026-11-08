import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kerb/data/catalog.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/car.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_silhouette.dart';
import 'package:kerb/ui/widgets/kerb_bits.dart';

/// Buscador manual. Es la red de seguridad del escáner: si la IA falla, aquí se
/// encuentra el coche igual. Funciona sin conexión porque el catálogo viaja
/// dentro del APK.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.catalog,
    this.currency = Currency.eur,
    this.onSelected,
    this.isOwned,
  });

  final Catalog catalog;
  final Currency currency;
  final ValueChanged<Car>? onSelected;

  /// Dice si el coche ya está en el garaje. Los que no llevan la foto de
  /// Unsplash del catálogo; los que sí se dejan en silueta porque su foto real
  /// es la del avistamiento.
  final bool Function(String carId)? isOwned;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _debounceDelay = Duration(milliseconds: 200);
  static const _suggestions = <String>[
    'Ferrari',
    'Porsche',
    'Lamborghini',
    'BMW',
  ];

  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<Car> _results = const <Car>[];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, () => _run(value));
  }

  void _run(String value) {
    if (!mounted) return;
    setState(() {
      _query = value.trim();
      _results = _query.isEmpty ? const <Car>[] : widget.catalog.search(_query);
    });
  }

  void _suggest(String value) {
    _controller.text = value;
    _controller.selection = TextSelection.collapsed(offset: value.length);
    _debounce?.cancel();
    _run(value);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: KerbColors.navy,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.xl,
                Space.lg,
                Space.xl,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const KerbWordmark(size: 21),
                      const Spacer(),
                      Kicker('${widget.catalog.length} ${l.cars}'),
                    ],
                  ),
                  const SizedBox(height: Space.xl),
                  Text(l.searchTitle, style: KerbType.section),
                  const SizedBox(height: Space.lg),
                  _SearchField(
                    controller: _controller,
                    hint: l.searchHint,
                    onChanged: _onChanged,
                    onClear: () {
                      _controller.clear();
                      _run('');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: Space.lg),
            Expanded(child: _body(l)),
          ],
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    if (_query.isEmpty) {
      return _SearchIdle(
        title: l.searchEmptyTitle,
        body: l.searchEmptyBody,
        suggestions: _suggestions,
        onSuggestion: _suggest,
      );
    }

    if (_results.isEmpty) {
      return _NoResults(label: l.searchNoResults, action: l.addManually);
    }

    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        Space.xl,
        Space.sm,
        Space.xl,
        140,
      ),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
      itemBuilder: (context, index) => _ResultRow(
        car: _results[index],
        currency: widget.currency,
        owned: widget.isOwned?.call(_results[index].id) ?? false,
        onTap: () => widget.onSelected?.call(_results[index]),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.hint,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: KerbColors.asphalt,
        borderRadius: BorderRadius.circular(Radiuses.card),
        border: Border.all(color: KerbColors.hairline),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        cursorColor: KerbColors.brick,
        style: const TextStyle(
          fontFamily: KerbType.sans,
          fontSize: 15,
          color: KerbColors.cream,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(
            fontFamily: KerbType.sans,
            fontSize: 15,
            color: KerbColors.muted,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: KerbColors.muted,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, _) => value.text.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: KerbColors.muted,
                    ),
                  ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

class _SearchIdle extends StatelessWidget {
  const _SearchIdle({
    required this.title,
    required this.body,
    required this.suggestions,
    required this.onSuggestion,
  });

  final String title;
  final String body;
  final List<String> suggestions;
  final ValueChanged<String> onSuggestion;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, 140),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 92,
                child: CarSilhouette(
                  color: KerbColors.cream.withValues(alpha: 0.18),
                ),
              ),
            ),
          ),
          const SizedBox(height: Space.xl),
          Text(title, style: KerbType.title),
          const SizedBox(height: Space.sm),
          Text(body, style: KerbType.bodyMuted),
          const SizedBox(height: Space.xl),
          Wrap(
            spacing: Space.sm,
            runSpacing: Space.sm,
            children: [
              for (final suggestion in suggestions)
                GestureDetector(
                  onTap: () => onSuggestion(suggestion),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Space.md,
                      vertical: Space.sm,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Radiuses.pill),
                      border: Border.all(color: KerbColors.hairline),
                    ),
                    child: Text(
                      suggestion,
                      style: const TextStyle(
                        fontFamily: KerbType.sans,
                        fontSize: 12,
                        color: KerbColors.cream,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults({required this.label, required this.action});

  final String label;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(Space.xxl, 0, Space.xxl, 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 120,
              height: 74,
              child: CarSilhouette(
                color: KerbColors.cream.withValues(alpha: 0.14),
              ),
            ),
            const SizedBox(height: Space.xl),
            Text(
              label,
              textAlign: TextAlign.center,
              style: KerbType.bodyMuted,
            ),
            const SizedBox(height: Space.lg),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded, size: 16),
              label: Text(
                action,
                style: const TextStyle(
                  fontFamily: KerbType.sans,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: KerbColors.cream,
                side: const BorderSide(color: KerbColors.hairlineStrong),
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: Space.xl),
                shape: const StadiumBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.car,
    required this.currency,
    required this.owned,
    required this.onTap,
  });

  final Car car;
  final Currency currency;
  final bool owned;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = rarityColor(car.rarity);
    final price = formatPrice(car.marketPriceEur, currency: currency);
    final photo = !owned ? car.imageUrl : null;

    return Material(
      color: KerbColors.asphalt,
      borderRadius: BorderRadius.circular(Radiuses.card),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radiuses.card),
        child: Container(
          padding: const EdgeInsets.all(Space.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Radiuses.card),
            border: Border.all(color: KerbColors.hairline),
          ),
          child: Row(
            children: [
              Container(
                width: 58,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(Radiuses.chip),
                  border: Border.all(color: accent.withValues(alpha: 0.25)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Radiuses.chip - 2),
                  child: photo == null
                      ? Padding(
                          padding: const EdgeInsets.all(5),
                          child: CarSilhouette(color: accent),
                        )
                      : Image.network(
                          photo,
                          fit: BoxFit.cover,
                          width: 58,
                          height: 44,
                          errorBuilder: (_, _, _) => Padding(
                            padding: const EdgeInsets.all(5),
                            child: CarSilhouette(color: accent),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: Space.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      car.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: KerbType.display,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        height: 1.05,
                        color: KerbColors.cream,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${car.make.toUpperCase()} · ${car.yearFrom}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: KerbType.mono,
                        fontSize: 9,
                        letterSpacing: 0.5,
                        color: KerbColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: Space.sm),
              if (price != null)
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: KerbType.mono,
                    fontSize: 12,
                    color: KerbColors.value,
                  ),
                ),
              const SizedBox(width: Space.xs),
              Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: KerbColors.muted.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
