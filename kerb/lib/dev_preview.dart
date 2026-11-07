// Punto de entrada SOLO para desarrollo: abre la app con un garaje de ejemplo
// para poder ver el diseño sin escanear nada. No se compila en el APK.
//
//   flutter run -d web-server -t lib/dev_preview.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:kerb/data/catalog.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/main.dart';

const _demoCars = <String>[
  'ferrari-f40-1987',
  'porsche-911-gt3-rs-992-2022',
  'lamborghini-countach-lp400-1974',
  'bmw-m3-e30-1986',
  'mercedes-190e-evo-ii-1990',
  'subaru-impreza-22b-1998',
  'seat-ibiza-fr-2017',
  'mazda-mx-5-na-1989',
];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final catalog = Catalog.fromJsonString(
    await rootBundle.loadString('assets/catalog.json'),
  );
  final repository = GarageRepository(catalog: catalog);
  for (final id in _demoCars) {
    await repository.add(id);
  }
  runApp(KerbApp(repository: repository));
}
