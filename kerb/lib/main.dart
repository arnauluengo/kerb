import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kerb/data/catalog.dart';
import 'package:kerb/data/garage_repository.dart';
import 'package:kerb/design/tokens.dart';
import 'package:kerb/l10n/app_localizations.dart';
import 'package:kerb/ui/shell/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: KerbColors.navy,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const KerbApp());
}

class KerbApp extends StatelessWidget {
  const KerbApp({super.key, this.locale, this.repository});

  /// Locale forzado. En producción es `null` y manda el idioma del sistema.
  final Locale? locale;

  /// Garaje inyectado. Solo lo usa `dev_preview.dart` para enseñar la app con
  /// datos sin tener que escanear nada.
  final GarageRepository? repository;

  @override
  Widget build(BuildContext context) {
    final repo = repository;

    return MaterialApp(
      title: 'Kerb',
      debugShowCheckedModeBanner: false,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: _theme(),
      // En el navegador de escritorio la app se dibuja como un móvil. En un
      // teléfono real este límite no se alcanza nunca.
      builder: (context, child) => ColoredBox(
        color: KerbColors.ink,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: ClipRect(child: child!),
          ),
        ),
      ),
      home: repo == null ? const _BootHome() : AppShell(repository: repo),
    );
  }

  static ThemeData _theme() {
    const scheme = ColorScheme.dark(
      primary: KerbColors.brick,
      onPrimary: KerbColors.cream,
      primaryContainer: KerbColors.brickWash,
      onPrimaryContainer: KerbColors.cream,
      secondary: KerbColors.value,
      onSecondary: KerbColors.ink,
      surface: KerbColors.asphalt,
      onSurface: KerbColors.cream,
      surfaceContainerHighest: KerbColors.raised,
      outline: KerbColors.hairlineStrong,
      error: KerbColors.brick,
      onError: KerbColors.cream,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: KerbType.sans,
      scaffoldBackgroundColor: KerbColors.navy,
      canvasColor: KerbColors.navy,
      colorScheme: scheme,
      splashColor: KerbColors.brickWash,
      highlightColor: Colors.transparent,
      dividerColor: KerbColors.hairline,
      textTheme: const TextTheme(
        bodyLarge: KerbType.body,
        bodyMedium: KerbType.body,
        bodySmall: KerbType.bodyMuted,
        titleLarge: KerbType.title,
        titleMedium: KerbType.title,
        labelLarge: KerbType.label,
      ).apply(bodyColor: KerbColors.cream, displayColor: KerbColors.cream),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: KerbColors.raised,
        contentTextStyle: TextStyle(
          fontFamily: KerbType.sans,
          fontSize: 13,
          color: KerbColors.cream,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: FadeForwardsPageTransitionsBuilder(),
        },
      ),
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
        backgroundColor: KerbColors.navy,
        body: Center(
          child: CircularProgressIndicator(
            color: KerbColors.brick,
            strokeWidth: 2,
          ),
        ),
      );
    }
    return AppShell(repository: repo);
  }
}
