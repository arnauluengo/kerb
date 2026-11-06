// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get scanCta => 'Scan a car';

  @override
  String get garageTitle => 'Garage';

  @override
  String get searchHint => 'Search make or model';

  @override
  String get scanFailedFallback =>
      'I couldn\'t identify the car. Search manually.';

  @override
  String get noCarFound => 'I couldn\'t find a car.';

  @override
  String get saveToCloud => 'Save to the cloud';

  @override
  String get searchNoResults => 'Not in the catalog. You can add it.';

  @override
  String get marketValue => 'Market value';

  @override
  String get noRender => 'No render yet';

  @override
  String get rarityCommon => 'COMMON';

  @override
  String get rarityUncommon => 'UNCOMMON';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityVeryRare => 'VERY RARE';

  @override
  String get rarityEpic => 'EPIC';

  @override
  String get rarityLegendary => 'LEGENDARY';

  @override
  String get garageEmptyTitle => 'Your garage is empty';

  @override
  String get garageEmptyBody =>
      'Photograph a car you see on the street and your collection begins.';

  @override
  String get filterAll => 'ALL';
}
