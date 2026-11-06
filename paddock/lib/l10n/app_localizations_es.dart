// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get scanCta => 'Escanear un coche';

  @override
  String get garageTitle => 'Garaje';

  @override
  String get searchHint => 'Buscar marca o modelo';

  @override
  String get scanFailedFallback =>
      'No he podido identificar el coche. Búscalo a mano.';

  @override
  String get noCarFound => 'No he encontrado un coche.';

  @override
  String get saveToCloud => 'Guardar en la nube';

  @override
  String get searchNoResults => 'No está en el catálogo. Puedes añadirlo.';
}
