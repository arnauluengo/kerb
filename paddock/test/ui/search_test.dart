import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/data/catalog.dart';
import 'package:paddock/l10n/app_localizations.dart';
import 'package:paddock/ui/search/search_screen.dart';

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

  testWidgets('buscar sin conexión devuelve resultados del catálogo embebido',
      (tester) async {
    await tester.pumpWidget(_wrap(SearchScreen(catalog: catalog)));
    await tester.enterText(find.byType(TextField), 'golf');
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.textContaining('Golf'), findsWidgets);
  });

  testWidgets('una búsqueda sin resultados explica que se puede añadir',
      (tester) async {
    await tester.pumpWidget(_wrap(SearchScreen(catalog: catalog)));
    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(find.text('No está en el catálogo. Puedes añadirlo.'), findsOneWidget);
    expect(find.text('Añadir a mano'), findsOneWidget);
  });

  testWidgets('sin texto no muestra resultados ni el mensaje de vacío',
      (tester) async {
    await tester.pumpWidget(_wrap(SearchScreen(catalog: catalog)));
    await tester.pumpAndSettle();

    expect(find.text('No está en el catálogo. Puedes añadirlo.'), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });
}
