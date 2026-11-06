import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:paddock/data/catalog.dart';
import 'package:paddock/data/garage_repository.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/l10n/app_localizations.dart';
import 'package:paddock/ui/garage/garage_screen.dart';

void main() => runApp(const PaddockApp());

class PaddockApp extends StatelessWidget {
  const PaddockApp({super.key, this.locale, this.repository});

  /// Locale forzado. En producción es `null` y manda el idioma del sistema.
  final Locale? locale;

  /// Garaje inyectado. Solo lo usa `dev_preview.dart` para enseñar la app con
  /// datos sin tener que escanear nada.
  final GarageRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository;

    return MaterialApp(
      title: 'Paddock',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBg,
        colorScheme: const ColorScheme.dark(
          primary: kGold,
          surface: kSurface,
        ),
      ),
      home: repo == null ? const _BootHome() : GarageScreen(repository: repo),
    );
  }
}

/// Carga el catálogo embebido y monta el garaje.
class _BootHome extends StatefulWidget {
  const _BootHome();

  @override
  State<_BootHome> createState() => _BootHomeState();
}

class _BootHomeState extends State<_BootHome> {
  GarageRepository? _repository;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final source = await rootBundle.loadString('assets/catalog.json');
    final catalog = Catalog.fromJsonString(source);
    if (!mounted) return;
    setState(() {
      _repository = GarageRepository(catalog: catalog);
    });
  }

  @override
  Widget build(BuildContext context) {
    final repo = _repository;
    if (repo == null) {
      return const Scaffold(
        backgroundColor: kBg,
        body: Center(child: CircularProgressIndicator(color: kGold)),
      );
    }
    return GarageScreen(repository: repo);
  }
}
