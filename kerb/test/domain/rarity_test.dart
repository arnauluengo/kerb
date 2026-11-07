import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/domain/rarity.dart';

void main() {
  test('no existe el tier common', () {
    expect(RarityTier.values.map((t) => t.name), isNot(contains('common')));
  });

  test('cortes por percentil', () {
    expect(rarityFromPercentile(0.0), RarityTier.uncommon);
    expect(rarityFromPercentile(0.29), RarityTier.uncommon);
    expect(rarityFromPercentile(0.30), RarityTier.rare);
    expect(rarityFromPercentile(0.75), RarityTier.epic);
    expect(rarityFromPercentile(0.90), RarityTier.mythic);
    expect(rarityFromPercentile(0.97), RarityTier.legendary);
    expect(rarityFromPercentile(1.0), RarityTier.legendary);
  });

  test('cada tier tiene su color exacto', () {
    expect(rarityColor(RarityTier.uncommon), const Color(0xFF2DD4BF));
    expect(rarityColor(RarityTier.rare), const Color(0xFF3B82F6));
    expect(rarityColor(RarityTier.veryRare), const Color(0xFF8B5CF6));
    expect(rarityColor(RarityTier.epic), const Color(0xFFEC4899));
    expect(rarityColor(RarityTier.mythic), const Color(0xFFE0533B));
    expect(rarityColor(RarityTier.legendary), const Color(0xFFF5B942));
  });
}
