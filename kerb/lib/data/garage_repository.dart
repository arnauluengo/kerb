import 'package:kerb/data/catalog.dart';

/// Una carta del garaje. Una fila por coche, por muchas fotos que tenga.
class GarageEntry {
  const GarageEntry({
    required this.carId,
    required this.firstSeenAt,
    this.sightingCount = 1,
    this.lastLat,
    this.lastLng,
  });

  final String carId;
  final DateTime firstSeenAt;
  final int sightingCount;

  /// Coordenadas redondeadas a 3 decimales. Nunca se guarda ni se envía nada
  /// más preciso: la posición exacta no sale del dispositivo.
  final double? lastLat;
  final double? lastLng;

  GarageEntry copyWith({
    DateTime? firstSeenAt,
    int? sightingCount,
    double? lastLat,
    double? lastLng,
  }) =>
      GarageEntry(
        carId: carId,
        firstSeenAt: firstSeenAt ?? this.firstSeenAt,
        sightingCount: sightingCount ?? this.sightingCount,
        lastLat: lastLat ?? this.lastLat,
        lastLng: lastLng ?? this.lastLng,
      );
}

/// Redondeo de privacidad: ~110 m de latitud, suficiente para "zona".
double? roundCoordinate(double? value) =>
    value == null ? null : double.parse(value.toStringAsFixed(3));

class GarageRepository {
  GarageRepository({required this.catalog, List<GarageEntry>? initial})
      : _entries = [...?initial];

  final Catalog catalog;
  final List<GarageEntry> _entries;

  List<GarageEntry> get entries => List.unmodifiable(_entries);

  bool contains(String carId) => _entries.any((e) => e.carId == carId);

  /// Añade un coche. Si ya está, no duplica la carta: suma un avistamiento.
  Future<void> add(String carId) async {
    await addSighting(carId, takenAt: DateTime.now());
  }

  Future<void> addSighting(
    String carId, {
    required DateTime takenAt,
    double? lat,
    double? lng,
  }) async {
    final index = _entries.indexWhere((e) => e.carId == carId);
    final roundedLat = roundCoordinate(lat);
    final roundedLng = roundCoordinate(lng);

    if (index == -1) {
      _entries.add(
        GarageEntry(
          carId: carId,
          firstSeenAt: takenAt,
          lastLat: roundedLat,
          lastLng: roundedLng,
        ),
      );
      return;
    }

    final current = _entries[index];
    _entries[index] = current.copyWith(
      sightingCount: current.sightingCount + 1,
      lastLat: roundedLat,
      lastLng: roundedLng,
    );
  }

  Future<void> remove(String carId) async {
    _entries.removeWhere((e) => e.carId == carId);
  }

  /// Valor total del garaje en euros. Un coche sin precio suma cero, nunca
  /// revienta la suma.
  num totalValueEur() => _entries.fold<num>(
        0,
        (sum, entry) => sum + (catalog.byId(entry.carId)?.marketPriceEur ?? 0),
      );
}
