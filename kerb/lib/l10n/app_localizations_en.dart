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
  String get scan => 'Scan';

  @override
  String get garageTitle => 'Garage';

  @override
  String get searchTitle => 'Search';

  @override
  String get profileTitle => 'Profile';

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
  String get notSpotted => 'Not spotted';

  @override
  String get collection => 'Collection';

  @override
  String get totalValue => 'Total value';

  @override
  String get cars => 'Cars';

  @override
  String get sightings => 'Sightings';

  @override
  String get catalogProgress => 'Of the catalog';

  @override
  String get rarityTitle => 'Rarity';

  @override
  String get account => 'Account';

  @override
  String get currencyLabel => 'Currency';

  @override
  String get ageLabel => 'Age';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get donate => 'Support Kerb';

  @override
  String get donateBody =>
      'Kerb is free and ad-free. If you enjoy it, buy me a coffee.';

  @override
  String get memberSince => 'Member since';

  @override
  String get guest => 'Guest';

  @override
  String get searchEmptyTitle => 'Search 500 cars';

  @override
  String get searchEmptyBody => 'Make, model or year. Works offline.';

  @override
  String get rarityUncommon => 'UNCOMMON';

  @override
  String get rarityRare => 'RARE';

  @override
  String get rarityVeryRare => 'VERY RARE';

  @override
  String get rarityEpic => 'EPIC';

  @override
  String get rarityMythic => 'MYTHIC';

  @override
  String get rarityLegendary => 'LEGENDARY';

  @override
  String get garageEmptyTitle => 'Your garage is empty';

  @override
  String get garageEmptyBody =>
      'Photograph a car you see on the street and your collection begins.';

  @override
  String get filterAll => 'All';

  @override
  String get addManually => 'Add manually';
}
