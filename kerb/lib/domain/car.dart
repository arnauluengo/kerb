import 'package:kerb/domain/rarity.dart';

const Map<String, RarityTier> _tierFromJson = <String, RarityTier>{
  'uncommon': RarityTier.uncommon,
  'rare': RarityTier.rare,
  'very_rare': RarityTier.veryRare,
  'epic': RarityTier.epic,
  'mythic': RarityTier.mythic,
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
    this.imageUrl,
    this.imageCredit,
    this.imagePage,
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

  /// Foto de Unsplash para las cartas de coches que aún no has avistado.
  /// Null cuando el catálogo todavía no tiene imagen: la carta cae en la
  /// silueta.
  final String? imageUrl;

  /// Nombre del fotógrafo. Unsplash pide atribución: no es opcional.
  final String? imageCredit;

  /// Página del autor en Unsplash, para enlazar la atribución.
  final String? imagePage;

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
      imageUrl: json['image_url'] as String?,
      imagePage: json['image_page'] as String?,
      imageCredit: json['image_credit'] as String?,
    );
  }
}
