import 'package:flutter/material.dart';
import 'package:paddock/data/garage_repository.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/domain/money.dart';
import 'package:paddock/l10n/app_localizations.dart';
import 'package:paddock/ui/garage/garage_screen.dart';
import 'package:paddock/ui/search/search_screen.dart';

/// Contenedor de la app: garaje y buscador con una barra inferior.
class AppShell extends StatefulWidget {
  const AppShell({
    super.key,
    required this.repository,
    this.currency = Currency.eur,
  });

  final GarageRepository repository;
  final Currency currency;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _openSearch() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchScreen(
          catalog: widget.repository.catalog,
          currency: widget.currency,
          onSelected: (car) async {
            await widget.repository.add(car.id);
            if (!mounted) return;
            Navigator.of(context).pop();
            setState(() => _index = 0);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: _index == 0
          ? GarageScreen(
              repository: widget.repository,
              currency: widget.currency,
              onAddCar: _openSearch,
            )
          : SearchScreen(
              catalog: widget.repository.catalog,
              currency: widget.currency,
              onSelected: (car) async {
                await widget.repository.add(car.id);
                if (!mounted) return;
                setState(() => _index = 0);
              },
            ),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Container(
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(top: BorderSide(color: kSurfaceHigh)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              _Item(
                icon: Icons.garage_outlined,
                label: l.garageTitle,
                selected: index == 0,
                onTap: () => onChanged(0),
              ),
              _Item(
                icon: Icons.search,
                label: l.searchTitle,
                selected: index == 1,
                onTap: () => onChanged(1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? kGold : kTextMuted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(
              label.toUpperCase(),
              style: TextStyle(
                fontFamily: 'Barlow',
                fontWeight: FontWeight.w500,
                fontSize: 8.5,
                letterSpacing: 1.2,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
