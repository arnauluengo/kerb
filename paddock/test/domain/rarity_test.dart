import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/domain/rarity.dart';

void main() {
  test('los cortes de rareza son los de la spec', () {
    expect(rarityFromScore(0), RarityTier.common);
    expect(rarityFromScore(19.9), RarityTier.common);
    expect(rarityFromScore(20), RarityTier.uncommon);
    expect(rarityFromScore(39.9), RarityTier.uncommon);
    expect(rarityFromScore(40), RarityTier.rare);
    expect(rarityFromScore(59.9), RarityTier.rare);
    expect(rarityFromScore(60), RarityTier.veryRare);
    expect(rarityFromScore(74.9), RarityTier.veryRare);
    expect(rarityFromScore(75), RarityTier.epic);
    expect(rarityFromScore(89.9), RarityTier.epic);
    expect(rarityFromScore(90), RarityTier.legendary);
    expect(rarityFromScore(100), RarityTier.legendary);
  });

  test('cada tier tiene su color exacto', () {
    expect(rarityColor(RarityTier.common), const Color(0xFF4ADE80));
    expect(rarityColor(RarityTier.uncommon), const Color(0xFF2DD4BF));
    expect(rarityColor(RarityTier.rare), const Color(0xFF3B82F6));
    expect(rarityColor(RarityTier.veryRare), const Color(0xFF8B5CF6));
    expect(rarityColor(RarityTier.epic), const Color(0xFFEC4899));
    expect(rarityColor(RarityTier.legendary), const Color(0xFFF5B942));
  });
}
