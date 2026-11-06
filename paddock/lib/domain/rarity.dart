import 'package:flutter/material.dart';

/// Tiers de rareza, de más común a más raro.
enum RarityTier { common, uncommon, rare, veryRare, epic, legendary }

/// Cortes de la spec §13: 20 / 40 / 60 / 75 / 90.
RarityTier rarityFromScore(double score) {
  if (score < 20) return RarityTier.common;
  if (score < 40) return RarityTier.uncommon;
  if (score < 60) return RarityTier.rare;
  if (score < 75) return RarityTier.veryRare;
  if (score < 90) return RarityTier.epic;
  return RarityTier.legendary;
}

const Map<RarityTier, Color> _rarityColors = <RarityTier, Color>{
  RarityTier.common: Color(0xFF4ADE80),
  RarityTier.uncommon: Color(0xFF2DD4BF),
  RarityTier.rare: Color(0xFF3B82F6),
  RarityTier.veryRare: Color(0xFF8B5CF6),
  RarityTier.epic: Color(0xFFEC4899),
  RarityTier.legendary: Color(0xFFF5B942),
};

/// Color exacto de cada tier. Es el color del borde de la carta.
Color rarityColor(RarityTier tier) => _rarityColors[tier]!;
