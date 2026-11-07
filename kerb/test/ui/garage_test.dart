import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/data/catalog.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_card.dart';
import 'package:kerb/ui/garage/garage_screen.dart';

late Catalog catalog;

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

void main() {
  setUpAll(() {
    catalog = Catalog.fromJsonString(
      File('assets/catalog.json').readAsStringSync(),
    );
  });

  test('el valor total suma solo coches con precio', () async {
    final repo = GarageRepository(catalog: catalog);
    await repo.add('ferrari-f40-1987');
    await repo.add('no-existe');

    expect(repo.totalValueEur(), 1200000);
  });

  test('volver a ver el mismo coche no duplica la carta', () async {
    final repo = GarageRepository(catalog: catalog);
    await repo.add('ferrari-f40-1987');
    await repo.add('ferrari-f40-1987');

    expect(repo.entries, hasLength(1));
    expect(repo.entries.first.sightingCount, 2);
  });

  testWidgets('el garaje vacío invita a escanear', (tester) async {
    final repo = GarageRepository(catalog: catalog);
    await tester.pumpWidget(_wrap(GarageScreen(repository: repo)));
    await tester.pumpAndSettle();

    expect(find.text('Escanear un coche'), findsOneWidget);
    expect(find.byType(CarCard), findsNothing);
  });

  testWidgets('el garaje con coches muestra cartas y el valor total',
      (tester) async {
    final repo = GarageRepository(catalog: catalog);
    await repo.add('ferrari-f40-1987');

    await tester.pumpWidget(_wrap(GarageScreen(repository: repo)));
    await tester.pumpAndSettle();

    expect(find.byType(CarCard), findsOneWidget);
    expect(find.text('1.2M €'), findsWidgets);
    expect(find.text('Escanear un coche'), findsNothing);
  });
}
