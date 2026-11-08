import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/data/catalog.dart';
import 'package:kerb/domain/car.dart';

void main() {
  late Catalog catalog;

  setUpAll(() {
    catalog = Catalog.fromJsonString(
      File('assets/catalog.json').readAsStringSync(),
    );
  });

  test('el catálogo embebido carga y tiene al menos 50 coches', () {
    expect(catalog.length, greaterThanOrEqualTo(50));
  });

  test('busca sin importar mayúsculas ni acentos', () {
    expect(catalog.search('ferrari f40').first.model, 'F40');
    expect(catalog.search('CITROEN').isNotEmpty, isTrue);
    expect(catalog.search('citroen').isNotEmpty, isTrue);
    expect(catalog.search('911').length, greaterThan(1));
  });

  test('encuentra por id', () {
    final f40 = catalog.byId('ferrari-f40-1987');
    expect(f40, isNotNull);
    expect(f40!.make, 'Ferrari');
    expect(f40.rarity, isNotNull);
  });

  test('un coche sin precio ni potencia no revienta el parseo', () {
    final car = Car.fromJson(const {
      'id': 'x',
      'make': 'A',
      'model': 'B',
      'year_from': 2000,
      'rarity_score': 12,
      'rarity_tier': 'uncommon',
    });
    expect(car.marketPriceEur, isNull);
    expect(car.powerHp, isNull);
    expect(car.generation, isNull);
  });

  test('una búsqueda sin resultados devuelve lista vacía, no null', () {
    expect(catalog.search('zzzzzz'), isEmpty);
  });

  test('el catálogo no contiene rutas de render ni de profundidad', () {
    final raw = File('assets/catalog.json').readAsStringSync();
    expect(raw, isNot(contains('render_path')));
    expect(raw, isNot(contains('depth_path')));
  });

  test('las fotos del catálogo son de Unsplash o no hay', () {
    for (final car in catalog.all) {
      expect(
        car.imageUrl,
        anyOf(
          isNull,
          predicate<String?>((u) => u!.startsWith('https://images.unsplash.com/')),
        ),
        reason: '${car.id} tiene una imagen de un origen no permitido',
      );
      if (car.imageUrl != null) {
        expect(car.imageCredit, isNotNull, reason: '${car.id} sin atribución');
      }
    }
  });
}
