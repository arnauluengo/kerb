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
  String get scan => 'Escanear';

  @override
  String get garageTitle => 'Garaje';

  @override
  String get searchTitle => 'Buscar';

  @override
  String get profileTitle => 'Perfil';

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

  @override
  String get marketValue => 'Valor de mercado';

  @override
  String get notSpotted => 'Sin avistar';

  @override
  String get collection => 'Colección';

  @override
  String get totalValue => 'Valor total';

  @override
  String get cars => 'Coches';

  @override
  String get sightings => 'Avistamientos';

  @override
  String get catalogProgress => 'Del catálogo';

  @override
  String get rarityTitle => 'Rareza';

  @override
  String get account => 'Cuenta';

  @override
  String get currencyLabel => 'Moneda';

  @override
  String get ageLabel => 'Edad';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get donate => 'Apoyar Kerb';

  @override
  String get donateBody =>
      'Kerb es gratis y sin anuncios. Si te gusta, invítame a un café.';

  @override
  String get memberSince => 'Miembro desde';

  @override
  String get searchEmptyTitle => 'Busca entre 500 coches';

  @override
  String get searchEmptyBody => 'Marca, modelo o año. Funciona sin conexión.';

  @override
  String get rarityUncommon => 'POCO COMÚN';

  @override
  String get rarityRare => 'RARO';

  @override
  String get rarityVeryRare => 'MUY RARO';

  @override
  String get rarityEpic => 'ÉPICO';

  @override
  String get rarityMythic => 'MÍTICO';

  @override
  String get rarityLegendary => 'LEGENDARIO';

  @override
  String get garageEmptyTitle => 'Tu garaje está vacío';

  @override
  String get garageEmptyBody =>
      'Haz una foto a un coche que veas por la calle y empezará tu colección.';

  @override
  String get filterAll => 'Todas';

  @override
  String get addManually => 'Añadir a mano';
}
