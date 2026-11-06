import 'package:flutter/material.dart';
import 'package:paddock/design/tokens.dart';
import 'package:paddock/l10n/app_localizations.dart';

void main() => runApp(const PaddockApp());

class PaddockApp extends StatelessWidget {
  const PaddockApp({super.key, this.locale});

  /// Locale forzado. En producción es `null` y manda el idioma del sistema.
  final Locale? locale;

  @override
  Widget build(BuildContext context) {
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
      home: const HomeScreen(),
    );
  }
}

/// Placeholder de la home. Task 8 la sustituye por el garaje real.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(l.scanCta),
        ),
      ),
    );
  }
}
