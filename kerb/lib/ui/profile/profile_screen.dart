import 'package:flutter/material.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/widgets/kerb_bits.dart';

/// Perfil y progreso. Es la pantalla que convierte una lista de fotos en una
/// colección: sin porcentaje y sin desglose por rareza, un garaje no se siente
/// como algo que se pueda completar.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    required this.repository,
    this.currency = Currency.eur,
  });

  final GarageRepository repository;
  final Currency currency;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final catalog = repository.catalog;
    final entries = repository.entries;
    final total = catalog.length;
    final completion = total == 0 ? 0.0 : entries.length / total;

    final ownership = <RarityTier, int>{
      for (final tier in RarityTier.values) tier: 0,
    };
    for (final entry in entries) {
      final car = catalog.byId(entry.carId);
      if (car == null) continue;
      ownership[car.rarity] = (ownership[car.rarity] ?? 0) + 1;
    }
    final maxOwned = ownership.values.fold<int>(1, (a, b) => b > a ? b : a);

    return Scaffold(
      backgroundColor: KerbColors.navy,
      body: SafeArea(
        bottom: false,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(Space.xl, Space.lg, Space.xl, 140),
          children: [
            Row(
              children: [
                const KerbWordmark(size: 21),
                const Spacer(),
                Kicker(l.profileTitle),
              ],
            ),
            const SizedBox(height: Space.xxl),
            Row(
              children: [
                const Monogram(text: 'K', size: 74, filled: true),
                const SizedBox(width: Space.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.guest, style: KerbType.section),
                      const SizedBox(height: Space.xs),
                      Text(
                        '${l.memberSince.toUpperCase()} 2026',
                        style: KerbType.label,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Space.xxl),
            _StatsCard(
              cars: entries.length,
              total: total,
              value:
                  formatPrice(repository.totalValueEur(), currency: currency) ??
                      '—',
              completion: completion,
              labels: (
                cars: l.cars,
                value: l.totalValue,
                catalog: l.catalogProgress,
              ),
            ),
            const SizedBox(height: Space.xxl),
            SizedBox(
              height: 14,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Kicker(l.rarityTitle),
              ),
            ),
            const SizedBox(height: Space.md),
            for (final tier in RarityTier.values.reversed)
              _RarityRow(
                tier: tier,
                label: _label(l, tier),
                owned: ownership[tier] ?? 0,
                maxOwned: maxOwned,
              ),
            const SizedBox(height: Space.xxl),
            _DonationCard(
              title: l.donate,
              body: l.donateBody,
              action: l.donate,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l.donateBody),
                  backgroundColor: KerbColors.asphalt,
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            ),
            const SizedBox(height: Space.xxl),
            Kicker(l.settingsTitle),
            const SizedBox(height: Space.sm),
            _SettingRow(
              icon: Icons.euro_rounded,
              label: l.currencyLabel,
              value: currency == Currency.eur ? 'EUR' : 'USD',
            ),
            const Hairline(),
            _SettingRow(
              icon: Icons.cake_outlined,
              label: l.ageLabel,
              value: '14+',
            ),
            const SizedBox(height: Space.xxl),
            Center(
              child: Text(
                'KERB 1.0.0',
                style: KerbType.label.copyWith(
                  color: KerbColors.muted.withValues(alpha: 0.5),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _label(AppLocalizations l, RarityTier tier) => switch (tier) {
        RarityTier.uncommon => l.rarityUncommon,
        RarityTier.rare => l.rarityRare,
        RarityTier.veryRare => l.rarityVeryRare,
        RarityTier.epic => l.rarityEpic,
        RarityTier.mythic => l.rarityMythic,
        RarityTier.legendary => l.rarityLegendary,
      };
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.cars,
    required this.total,
    required this.value,
    required this.completion,
    required this.labels,
  });

  final int cars;
  final int total;
  final String value;
  final double completion;
  final ({String cars, String value, String catalog}) labels;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: Space.lg,
        horizontal: Space.sm,
      ),
      decoration: BoxDecoration(
        color: KerbColors.asphalt,
        borderRadius: BorderRadius.circular(Radiuses.card),
        border: Border.all(color: KerbColors.hairline),
      ),
      child: Row(
        children: [
          _Stat(
            value: cars.toString().padLeft(2, '0'),
            label: labels.cars,
          ),
          const _StatDivider(),
          _Stat(
            value: value,
            label: labels.value,
            color: KerbColors.value,
            size: 17,
          ),
          const _StatDivider(),
          _Stat(
            value: '${(completion * 100).toStringAsFixed(1)}%',
            label: labels.catalog,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({
    required this.value,
    required this.label,
    this.color = KerbColors.cream,
    this.size = 22,
  });

  final String value;
  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: KerbType.mono,
                fontWeight: FontWeight.w500,
                fontSize: size,
                height: 1,
                letterSpacing: -0.6,
                color: color,
              ),
            ),
          ),
          const SizedBox(height: Space.sm),
          FittedBox(fit: BoxFit.scaleDown, child: Kicker(label)),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 30,
        color: KerbColors.hairline,
      );
}

class _RarityRow extends StatelessWidget {
  const _RarityRow({
    required this.tier,
    required this.label,
    required this.owned,
    required this.maxOwned,
  });

  final RarityTier tier;
  final String label;
  final int owned;
  final int maxOwned;

  @override
  Widget build(BuildContext context) {
    final accent = rarityColor(tier);
    final factor = (owned / maxOwned).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.sm),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
          ),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: KerbType.sans,
                fontWeight: FontWeight.w500,
                fontSize: 10,
                letterSpacing: 1.5,
                color: KerbColors.cream,
              ),
            ),
          ),
          SizedBox(
            width: 64,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Radiuses.pill),
              child: Stack(
                children: [
                  Container(height: 3, color: KerbColors.hairline),
                  FractionallySizedBox(
                    widthFactor: factor,
                    child: Container(height: 3, color: accent),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 34,
            child: Text(
              owned.toString().padLeft(2, '0'),
              textAlign: TextAlign.right,
              style: KerbType.numeral.copyWith(fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonationCard extends StatelessWidget {
  const _DonationCard({
    required this.title,
    required this.body,
    required this.action,
    required this.onTap,
  });

  final String title;
  final String body;
  final String action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Space.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radiuses.card),
        border: Border.all(color: KerbColors.brick.withValues(alpha: 0.35)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A1B1C), KerbColors.asphalt],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: KerbType.title),
          const SizedBox(height: Space.sm),
          Text(body, style: KerbType.bodyMuted),
          const SizedBox(height: Space.lg),
          KerbButton(label: action, onPressed: onTap),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Space.md),
      child: Row(
        children: [
          Icon(icon, size: 18, color: KerbColors.muted),
          const SizedBox(width: Space.md),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: KerbType.sans,
                fontSize: 14,
                color: KerbColors.cream,
              ),
            ),
          ),
          Text(
            value,
            style: KerbType.numeral.copyWith(
              fontSize: 12,
              color: KerbColors.muted,
            ),
          ),
          const SizedBox(width: Space.xs),
          const Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: KerbColors.muted,
          ),
        ],
      ),
    );
  }
}
