import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/data/catalog.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_card.dart';
import 'package:kerb/ui/shell/app_shell.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

/// Los tres tamaños que de verdad tiene un Android: móvil pequeño, móvil
/// corriente y tablet/ventana estrecha. Si aquí no desborda, no desborda.
void main() {
  late Catalog catalog;
  late GarageRepository repository;

  setUpAll(() {
    catalog = Catalog.fromJsonString(
      File('assets/catalog.json').readAsStringSync(),
    );
  });

  Future<void> _pump(
    WidgetTester tester,
    Size size, {
    int cars = 6,
  }) async {
    await tester.binding.setSurfaceSize(size);
    repository = GarageRepository(catalog: catalog);
    for (final car in catalog.all.take(cars)) {
      await repository.add(car.id);
    }
    await tester.pumpWidget(_wrap(AppShell(repository: repository)));
    await tester.pumpAndSettle();
  }

  for (final size in const [Size(320, 568), Size(393, 851), Size(430, 932)]) {
    testWidgets('el garaje cabe en ${size.width}x${size.height}',
        (tester) async {
      await _pump(tester, size);

      expect(find.byType(CarCard), findsAtLeastNWidgets(2));
      expect(find.text('06'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('la barra inferior cabe en ${size.width} px', (tester) async {
      await _pump(tester, size);

      expect(find.byKey(const Key('scan-action')), findsOneWidget);
      expect(find.text('GARAJE'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('buscar y perfil caben en ${size.width} px', (tester) async {
      await _pump(tester, size);

      await tester.tap(find.text('BUSCAR'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'ferrari');
      await tester.pump(const Duration(milliseconds: 260));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('PERFIL'));
      await tester.pumpAndSettle();
      expect(find.text('Invitado'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('el garaje vacío cabe en 320 px', (tester) async {
    await _pump(tester, const Size(320, 568), cars: 0);

    expect(find.text('Escanear un coche'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('añadir desde el buscador lleva al garaje', (tester) async {
    await _pump(tester, const Size(393, 851), cars: 2);
    final before = repository.entries.length;

    await tester.tap(find.text('BUSCAR'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'f40');
    await tester.pump(const Duration(milliseconds: 260));
    await tester.pumpAndSettle();
    await tester.tap(find.text('F40').first);
    await tester.pumpAndSettle();

    expect(repository.entries.length, greaterThan(before));
    expect(tester.takeException(), isNull);
  });
}
