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
  id: 'seat-ibiza-fr-2017',
  make: 'Seat',
  model: 'Ibiza',
  generation: 'FR 1.5 TSI',
  yearFrom: 2017,
  powerHp: 150,
  topSpeedKmh: 215,
  rarityScore: 12,
  rarity: RarityTier.common,
);
