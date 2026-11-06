import 'package:flutter/material.dart';

void main() => runApp(const PaddockApp());

class PaddockApp extends StatelessWidget {
  const PaddockApp({super.key, this.locale});

  final Locale? locale;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
      home: const SizedBox(),
    );
  }
}
