/// Moneda de presentación. Se elige al crear el perfil.
enum Currency { eur, usd }

/// Tipo de cambio fijo del catálogo. Se actualiza con cada release del catálogo,
/// nunca en caliente: un precio que cambia solo es un precio en el que no se
/// puede confiar.
const double kEurToUsd = 1.08;

String _trimZero(String value) =>
    value.endsWith('.0') ? value.substring(0, value.length - 2) : value;

/// Formatea un precio dado en euros a la moneda del perfil.
///
/// `100k €`, `1.2M €`, `10M €`. Devuelve `null` cuando no hay precio: la carta
/// simplemente no muestra la línea de precio.
String? formatPrice(num? amountEur, {required Currency currency}) {
  if (amountEur == null || amountEur <= 0) return null;

  final amount = amountEur.toDouble() *
      (currency == Currency.usd ? kEurToUsd : 1.0);
  final symbol = currency == Currency.usd ? '\$' : '€';

  if (amount < 1000) {
    final rounded = amount.round();
    if (rounded < 1000) return '$rounded $symbol';
  }

  if (amount < 1000000) {
    final thousands = amount / 1000;
    if (thousands < 10) {
      return '${_trimZero(thousands.toStringAsFixed(1))}k $symbol';
    }
    final rounded = thousands.round();
    if (rounded < 1000) return '${rounded}k $symbol';
  }

  final millions = amount / 1000000;
  final text =
      millions < 10 ? _trimZero(millions.toStringAsFixed(1)) : millions.round().toString();
  return '${text}M $symbol';
}
