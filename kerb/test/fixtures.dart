import 'package:kerb/domain/car.dart';
import 'package:kerb/domain/rarity.dart';

const f40 = Car(
  id: 'ferrari-f40-1987',
  make: 'Ferrari',
  model: 'F40',
  yearFrom: 1987,
  yearTo: 1992,
  powerHp: 478,
  torqueNm: 577,
  zero100: 4.1,
  topSpeedKmh: 324,
  engine: '2.9 V8 biturbo',
  productionUnits: 1311,
  marketPriceEur: 1200000,
  rarityScore: 95,
  rarity: RarityTier.legendary,
);

const carSinPrecio = Car(
  id: 'lancia-delta-hf-1987',
  make: 'Lancia',
  model: 'Delta',
  generation: 'HF Integrale',
  yearFrom: 1987,
  powerHp: 150,
  topSpeedKmh: 215,
  rarityScore: 12,
  rarity: RarityTier.uncommon,
);

/// Coche con foto de Unsplash en el catálogo: así se ve una carta todavía no
/// avistada.
const carConFoto = Car(
  id: 'porsche-911-carrera-1984',
  make: 'Porsche',
  model: '911',
  generation: 'Carrera',
  yearFrom: 1984,
  rarityScore: 60,
  rarity: RarityTier.epic,
  imageUrl: 'https://images.unsplash.com/photo-fake?w=1000',
  imageCredit: 'Fotógrafo',
);
