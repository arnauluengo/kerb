import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/data/catalog.dart';
import 'package:paddock/domain/car.dart';

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
      'rarity_tier': 'common',
    });
    expect(car.marketPriceEur, isNull);
    expect(car.powerHp, isNull);
    expect(car.generation, isNull);
  });

  test('una búsqueda sin resultados devuelve lista vacía, no null', () {
    expect(catalog.search('zzzzzz'), isEmpty);
  });
}
