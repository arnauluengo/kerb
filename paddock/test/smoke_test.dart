import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/main.dart';

void main() {
  test('la app se construye', () {
    expect(const PaddockApp(), isNotNull);
  });
}
