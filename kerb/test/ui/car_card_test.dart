import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/domain/money.dart';
import 'package:kerb/domain/rarity.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/card/car_card.dart';

import '../fixtures.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('la carta muestra marca, modelo, precio y borde de rareza',
      (tester) async {
    await tester.pumpWidget(_wrap(CarCard(car: f40, currency: Currency.eur)));
    await tester.pumpAndSettle();

    expect(find.text('FERRARI'), findsOneWidget);
    expect(find.text('F40'), findsOneWidget);
    expect(find.text('1.2M €'), findsOneWidget);
    expect(find.text('LEGENDARIO'), findsOneWidget);

    final box = tester.widget<Container>(find.byKey(const Key('card-border')));
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.border!.top.color, rarityColor(RarityTier.legendary));
    expect(decoration.border!.top.width, 2);
  });

  testWidgets('sin precio no hay línea de precio ni aparece null',
      (tester) async {
    await tester.pumpWidget(
      _wrap(CarCard(car: carSinPrecio, currency: Currency.eur)),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('card-price')), findsNothing);
    expect(find.textContaining('null'), findsNothing);
    expect(find.text('POCO COMÚN'), findsOneWidget);
  });

  testWidgets('la carta sin render no rompe y lo dice', (tester) async {
    await tester.pumpWidget(_wrap(CarCard(car: f40, currency: Currency.eur)));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('card-render-placeholder')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('una carta sin avistar avisa y cae en la silueta si la foto falla',
      (tester) async {
    await tester.pumpWidget(
      _wrap(const CarCard(car: carConFoto, currency: Currency.eur, spotted: false)),
    );
    await tester.pumpAndSettle();

    expect(find.text('SIN AVISTAR'), findsOneWidget);
    expect(find.byKey(const Key('card-render-placeholder')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el contador usa índice y total del catálogo', (tester) async {
    await tester.pumpWidget(
      _wrap(CarCard(car: f40, currency: Currency.eur, catalogIndex: 0, catalogTotal: 80)),
    );
    await tester.pumpAndSettle();

    expect(find.text('001 / 080'), findsOneWidget);
  });

  testWidgets('la carta aguanta el ancho de una celda de rejilla sin desbordar',
      (tester) async {
    await tester.pumpWidget(
      _wrap(CarCard(
        car: f40,
        currency: Currency.eur,
        width: 150,
        catalogIndex: 0,
        catalogTotal: 80,
      )),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
