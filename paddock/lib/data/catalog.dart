import 'dart:convert';

import 'package:paddock/domain/car.dart';

/// Catálogo de coches embebido en el APK.
///
/// Vive en memoria: 500 coches son unos cientos de KB y buscar en ellos es más
/// rápido que cualquier base de datos. Cuando no hay red, esto es lo que salva
/// al usuario.
class Catalog {
  Catalog._(this._cars, this._byId);

  final List<Car> _cars;
  final Map<String, Car> _byId;

  factory Catalog.fromJsonString(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    final cars = decoded
        .map((e) => Car.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);
    return Catalog._(cars, {for (final c in cars) c.id: c});
  }

  int get length => _cars.length;

  List<Car> get all => List.unmodifiable(_cars);

  Car? byId(String id) => _byId[id];

  /// Busca por texto libre sobre marca, modelo, generación y año.
  ///
  /// Insensible a mayúsculas y acentos: `citroen` encuentra `Citroën`.
  /// Cada palabra de la consulta debe aparecer en algún campo.
  List<Car> search(String query, {int limit = 20}) {
    final q = _normalize(query.trim());
    if (q.isEmpty) return const <Car>[];

    final tokens = q.split(RegExp(r'\s+'));
    final scored = <_Scored>[];

    for (final car in _cars) {
      final make = _normalize(car.make);
      final model = _normalize(car.model);
      final haystack = _normalize(
        '${car.make} ${car.model} ${car.generation ?? ''} ${car.yearFrom}',
      );

      if (!tokens.every(haystack.contains)) continue;

      var score = 0;
      if (make.startsWith(tokens.first)) score += 100;
      if ('$make $model'.startsWith(q)) score += 50;
      if (model.startsWith(tokens.first)) score += 30;
      if (tokens.length > 1) score += 10;

      scored.add(_Scored(car, score));
    }

    scored.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      return byScore != 0 ? byScore : a.car.id.compareTo(b.car.id);
    });

    return scored.take(limit).map((s) => s.car).toList(growable: false);
  }

  static String _normalize(String value) {
    var out = value.toLowerCase();
    const from = 'áàäâãéèëêíìïîóòöôõúùüûñç';
    const to = 'aaaaaeeeeiiiiooooouuuunc';
    for (var i = 0; i < from.length; i++) {
      out = out.replaceAll(from[i], to[i]);
    }
    return out;
  }
}

class _Scored {
  const _Scored(this.car, this.score);

  final Car car;
  final int score;
}
