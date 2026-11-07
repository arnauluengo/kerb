import 'package:kerb/domain/rarity.dart';

const Map<String, RarityTier> _tierFromJson = <String, RarityTier>{
  'common': RarityTier.common,
  'uncommon': RarityTier.uncommon,
  'rare': RarityTier.rare,
  'very_rare': RarityTier.veryRare,
  'epic': RarityTier.epic,
  'legendary': RarityTier.legendary,
};

/// Un coche del catálogo. Una generación es una carta: un 991 y un 992 son
/// coches distintos.
class Car {
  const Car({
    required this.id,
    required this.make,
    required this.model,
    required this.yearFrom,
    required this.rarityScore,
    required this.rarity,
    this.generation,
    this.yearTo,
    this.powerHp,
    this.torqueNm,
    this.zero100,
    this.topSpeedKmh,
    this.engine,
    this.productionUnits,
    this.marketPriceEur,
    this.renderPath,
    this.depthPath,
  });

  final String id;
  final String make;
  final String model;
  final String? generation;
  final int yearFrom;
  final int? yearTo;
  final int? powerHp;
  final int? torqueNm;
  final double? zero100;
  final int? topSpeedKmh;
  final String? engine;
  final int? productionUnits;
  final num? marketPriceEur;
  final double rarityScore;
  final RarityTier rarity;
  final String? renderPath;
  final String? depthPath;

  /// Nombre completo para la carta: `911 GT3 RS 992`.
  String get fullName => generation == null ? model : '$model $generation';

  factory Car.fromJson(Map<String, dynamic> json) {
    final tierName = json['rarity_tier'] as String;
    final tier = _tierFromJson[tierName];
    if (tier == null) {
      throw FormatException('Tier de rareza desconocido: $tierName');
    }
    return Car(
      id: json['id'] as String,
      make: json['make'] as String,
      model: json['model'] as String,
      generation: json['generation'] as String?,
      yearFrom: (json['year_from'] as num).toInt(),
      yearTo: (json['year_to'] as num?)?.toInt(),
      powerHp: (json['power_hp'] as num?)?.toInt(),
      torqueNm: (json['torque_nm'] as num?)?.toInt(),
      zero100: (json['zero_100'] as num?)?.toDouble(),
      topSpeedKmh: (json['top_speed_kmh'] as num?)?.toInt(),
      engine: json['engine'] as String?,
      productionUnits: (json['production_units'] as num?)?.toInt(),
      marketPriceEur: json['market_price_eur'] as num?,
      rarityScore: (json['rarity_score'] as num).toDouble(),
      rarity: tier,
      renderPath: json['render_path'] as String?,
      depthPath: json['depth_path'] as String?,
    );
  }
}
