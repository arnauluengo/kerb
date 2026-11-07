import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kerb/design/tokens.dart';

void main() {
  test('paleta Kerb', () {
    expect(KerbColors.navy, const Color(0xFF14233B));
    expect(KerbColors.cream, const Color(0xFFEDE6D6));
    expect(KerbColors.asphalt, const Color(0xFF1A1B1E));
    expect(KerbColors.brick, const Color(0xFFC2402A));
    expect(KerbColors.muted, const Color(0xFF8C93A3));
    expect(KerbColors.value, const Color(0xFF4ADE80));
  });

  test('los tokens heredados apuntan a la paleta Kerb', () {
    expect(kBg, KerbColors.navy);
    expect(kSurface, KerbColors.asphalt);
    expect(kText, KerbColors.cream);
    expect(kTextMuted, KerbColors.muted);
    expect(kPriceGreen, KerbColors.value);
  });
}
