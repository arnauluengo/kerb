import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/main.dart';

void main() {
  testWidgets('la app arranca y se llama Kerb', (tester) async {
    // La app carga el catálogo en `initState`; basta con montar el primer
    // frame para comprobar el nombre y que el árbol construye.
    await tester.pumpWidget(const KerbApp());

    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.title, 'Kerb');
    expect(find.byType(KerbApp), findsOneWidget);
  });
}
