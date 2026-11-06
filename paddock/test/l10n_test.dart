import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/main.dart';

void main() {
  testWidgets('la home muestra el CTA traducido', (tester) async {
    await tester.pumpWidget(const PaddockApp(locale: Locale('en')));
    await tester.pumpAndSettle();
    expect(find.text('Scan a car'), findsOneWidget);

    await tester.pumpWidget(const PaddockApp(locale: Locale('es')));
    await tester.pumpAndSettle();
    expect(find.text('Escanear un coche'), findsOneWidget);
  });
}
