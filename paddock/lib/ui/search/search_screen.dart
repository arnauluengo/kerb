import 'dart:async';

import 'package:flutter/material.dart';
import 'package:paddock/data/catalog.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/domain/car.dart';
import 'package:paddock/domain/money.dart';
import 'package:paddock/domain/rarity.dart';
import 'package:paddock/l10n/app_localizations.dart';
import 'package:paddock/ui/card/car_silhouette.dart';

/// Buscador manual. Es la red de seguridad del escáner: si la IA falla, aquí se
/// encuentra el coche igual. Funciona sin conexión porque el catálogo viaja
/// dentro del APK.
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    super.key,
    required this.catalog,
    this.currency = Currency.eur,
    this.onSelected,
  });

  final Catalog catalog;
  final Currency currency;
  final ValueChanged<Car>? onSelected;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _debounceDelay = Duration(milliseconds: 200);

  String _query = '';
  List<Car> _results = const <Car>[];
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(_debounceDelay, () {
      if (!mounted) return;
      setState(() {
        _query = value.trim();
        _results = _query.isEmpty ? const <Car>[] : widget.catalog.search(_query);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, 0),
              child: Text(
                l.searchTitle,
                style: const TextStyle(
                  fontFamily: 'BarlowCondensed',
                  fontWeight: FontWeight.w700,
                  fontSize: 32,
                  height: 1,
                  color: kText,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, Space.sm),
              child: TextField(
                autofocus: true,
                onChanged: _onChanged,
                cursorColor: kGold,
                style: const TextStyle(
                  fontFamily: 'Barlow',
                  fontSize: 15,
                  color: kText,
                ),
                decoration: InputDecoration(
                  hintText: l.searchHint,
                  hintStyle: const TextStyle(
                    fontFamily: 'Barlow',
                    fontSize: 15,
                    color: kTextMuted,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 20, color: kTextMuted),
                  filled: true,
                  fillColor: kSurface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: kSurfaceHigh),
                  ),
                ),
              ),
            ),
            Expanded(child: _body(l)),
          ],
        ),
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    if (_query.isEmpty) return const SizedBox.shrink();

    if (_results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Space.xxl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l.searchNoResults,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Barlow',
                  fontSize: 14,
                  height: 1.4,
                  color: kTextMuted,
                ),
              ),
              const SizedBox(height: Space.lg),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: kGold,
                  side: BorderSide(color: kGold.withValues(alpha: 0.4)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: Space.xl,
                    vertical: Space.md,
                  ),
                ),
                child: Text(
                  l.addManually,
                  style: const TextStyle(
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(Space.xl, Space.sm, Space.xl, Space.xxl),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: Space.sm),
      itemBuilder: (context, index) {
        final car = _results[index];
        final accent = rarityColor(car.rarity);
        final price = formatPrice(car.marketPriceEur, currency: widget.currency);

        return ListTile(
          onTap: () => widget.onSelected?.call(car),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          tileColor: kSurface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: Space.md,
            vertical: Space.xs,
          ),
          leading: SizedBox(
            width: 48,
            height: 30,
            child: CarSilhouette(color: accent.withValues(alpha: 0.55)),
          ),
          title: Text(
            car.fullName,
            style: const TextStyle(
              fontFamily: 'BarlowCondensed',
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: kText,
            ),
          ),
          subtitle: Text(
            '${car.make} · ${car.yearFrom}',
            style: const TextStyle(
              fontFamily: 'Barlow',
              fontSize: 11,
              color: kTextMuted,
            ),
          ),
          trailing: price == null
              ? null
              : Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 12,
                    color: kPriceGreen,
                  ),
                ),
        );
      },
    );
  }
}
