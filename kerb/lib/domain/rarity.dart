import 'package:flutter/material.dart';

/// Tiers de rareza, de menos a más raro.
///
/// No existe `common`: el catálogo solo admite deportivos, exóticos y clásicos,
/// así que la escala empieza en "poco común".
enum RarityTier { uncommon, rare, veryRare, epic, mythic, legendary }

/// Traduce un percentil del catálogo (0–1) a su tier.
///
/// Los cortes son por percentil, no por puntuación absoluta: con un catálogo
/// sin coches comunes, los cortes absolutos aplastarían todo hacia arriba.
RarityTier rarityFromPercentile(double percentile) {
  if (percentile < 0.30) return RarityTier.uncommon;
  if (percentile < 0.55) return RarityTier.rare;
  if (percentile < 0.75) return RarityTier.veryRare;
  if (percentile < 0.90) return RarityTier.epic;
  if (percentile < 0.97) return RarityTier.mythic;
  return RarityTier.legendary;
}

const Map<RarityTier, Color> _rarityColors = <RarityTier, Color>{
  RarityTier.uncommon: Color(0xFF2DD4BF),
  RarityTier.rare: Color(0xFF3B82F6),
  RarityTier.veryRare: Color(0xFF8B5CF6),
  RarityTier.epic: Color(0xFFEC4899),
  RarityTier.mythic: Color(0xFFE0533B),
  RarityTier.legendary: Color(0xFFF5B942),
};

/// Color exacto de cada tier. Es el color del borde de la carta.
Color rarityColor(RarityTier tier) => _rarityColors[tier]!;
