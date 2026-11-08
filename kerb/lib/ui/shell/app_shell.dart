import 'package:flutter/material.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/car.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/garage/garage_screen.dart';
import 'package:kerb/ui/profile/profile_screen.dart';
import 'package:kerb/ui/search/search_screen.dart';

/// Contenedor de la app: garaje, buscador y perfil, con el escáner siempre a
/// un toque en el extremo de la barra.
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

  Future<void> _addCar(Car car) async {
    await widget.repository.add(car.id);
    if (!mounted) return;
    setState(() => _index = 0);
  }

  void _openAddFlow() {
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
      backgroundColor: KerbColors.navy,
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          GarageScreen(
            repository: widget.repository,
            currency: widget.currency,
            onAddCar: _openAddFlow,
          ),
          SearchScreen(
            catalog: widget.repository.catalog,
            currency: widget.currency,
            isOwned: widget.repository.contains,
            onSelected: _addCar,
          ),
          ProfileScreen(
            repository: widget.repository,
            currency: widget.currency,
          ),
        ],
      ),
      bottomNavigationBar: _BottomBar(
        index: _index,
        onChanged: (i) => setState(() => _index = i),
        onScan: _openAddFlow,
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.index,
    required this.onChanged,
    required this.onScan,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // En un móvil de 320 px no cabe la palabra ESCANEAR: el icono solo
          // sigue siendo inequívoco y la barra respira.
          final compact = constraints.maxWidth < 350;

          return Container(
            margin: const EdgeInsets.fromLTRB(Space.lg, 0, Space.lg, Space.md),
            padding: const EdgeInsets.all(Space.xs),
            height: 68,
            decoration: BoxDecoration(
              color: KerbColors.raised,
              borderRadius: BorderRadius.circular(Radiuses.pill),
              border: Border.all(color: KerbColors.hairline),
              boxShadow: KerbShadows.raised,
            ),
            child: Row(
              children: [
                _Item(
                  icon: Icons.garage_outlined,
                  activeIcon: Icons.garage_rounded,
                  label: l.garageTitle,
                  selected: index == 0,
                  onTap: () => onChanged(0),
                ),
                _Item(
                  icon: Icons.search_rounded,
                  activeIcon: Icons.search_rounded,
                  label: l.searchTitle,
                  selected: index == 1,
                  onTap: () => onChanged(1),
                ),
                _Item(
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: l.profileTitle,
                  selected: index == 2,
                  onTap: () => onChanged(2),
                ),
                const SizedBox(width: Space.sm),
                _ScanButton(
                  label: compact ? null : l.scan,
                  onTap: onScan,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? KerbColors.cream : KerbColors.muted;
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(Radiuses.pill),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(selected ? activeIcon : icon, size: 20, color: color),
            const SizedBox(height: 3),
            SizedBox(
              width: 58,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label.toUpperCase(),
                  maxLines: 1,
                  softWrap: false,
                  style: TextStyle(
                    fontFamily: KerbType.sans,
                    fontWeight: FontWeight.w500,
                    fontSize: 8.5,
                    letterSpacing: 1.2,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// El escáner es la acción que define la app: por eso no es un icono más de la
/// barra, sino una pastilla de ladrillo dentro de ella.
class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onTap, this.label});

  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key('scan-action'),
      onTap: onTap,
      child: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: label == null ? Space.md : Space.lg,
        ),
        decoration: BoxDecoration(
          color: KerbColors.brick,
          borderRadius: BorderRadius.circular(Radiuses.pill),
          boxShadow: [
            BoxShadow(
              color: KerbColors.brick.withValues(alpha: 0.40),
              blurRadius: 18,
              spreadRadius: -4,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.center_focus_strong_rounded,
              size: 19,
              color: KerbColors.cream,
            ),
            if (label != null) ...[
              const SizedBox(width: Space.sm),
              Text(
                label!.toUpperCase(),
                style: const TextStyle(
                  fontFamily: KerbType.sans,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                  letterSpacing: 1.3,
                  color: KerbColors.cream,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
