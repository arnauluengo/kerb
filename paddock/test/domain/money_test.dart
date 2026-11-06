import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/domain/money.dart';

void main() {
  test('formato compacto en euros', () {
    expect(formatPrice(999, currency: Currency.eur), '999 €');
    expect(formatPrice(8500, currency: Currency.eur), '8.5k €');
    expect(formatPrice(45000, currency: Currency.eur), '45k €');
    expect(formatPrice(100000, currency: Currency.eur), '100k €');
    expect(formatPrice(999999, currency: Currency.eur), '1M €');
    expect(formatPrice(1200000, currency: Currency.eur), '1.2M €');
    expect(formatPrice(10000000, currency: Currency.eur), '10M €');
  });

  test('en dólares usa el tipo de cambio y el símbolo', () {
    expect(formatPrice(100000, currency: Currency.usd), '108k \$');
    expect(formatPrice(1000000, currency: Currency.usd), '1.1M \$');
  });

  test('sin precio no inventa nada', () {
    expect(formatPrice(null, currency: Currency.eur), isNull);
    expect(formatPrice(0, currency: Currency.eur), isNull);
    expect(formatPrice(-5, currency: Currency.eur), isNull);
  });

  test('el límite entre euros y miles no produce 1000 €', () {
    expect(formatPrice(999.6, currency: Currency.eur), '1k €');
    expect(formatPrice(1000, currency: Currency.eur), '1k €');
  });
}
