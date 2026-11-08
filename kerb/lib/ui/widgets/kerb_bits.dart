import 'package:flutter/material.dart';
import 'package:kerb/design/tokens.dart';

/// Marca de Kerb. Un cuadrado de ladrillo y la palabra en condensada, muy
/// espaciada. Sin icono de coche: el nombre ya lo dice.
class KerbWordmark extends StatelessWidget {
  const KerbWordmark({super.key, this.size = 22, this.color = KerbColors.cream});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size * 0.30,
          height: size * 0.30,
          decoration: BoxDecoration(
            color: KerbColors.brick,
            borderRadius: BorderRadius.circular(size * 0.045),
          ),
        ),
        SizedBox(width: size * 0.26),
        Text(
          'KERB',
          style: TextStyle(
            fontFamily: KerbType.display,
            fontWeight: FontWeight.w700,
            fontSize: size,
            height: 1,
            letterSpacing: size * 0.19,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Etiqueta de sección: mayúsculas pequeñas y muy espaciadas.
class Kicker extends StatelessWidget {
  const Kicker(this.text, {super.key, this.color = KerbColors.muted});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: KerbType.label.copyWith(color: color),
    );
  }
}

/// Filete horizontal de 1 px.
class Hairline extends StatelessWidget {
  const Hairline({super.key, this.color = KerbColors.hairline, this.height = 1});

  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) =>
      Container(height: height, color: color);
}

/// Monograma circular. Sustituye al avatar mientras no hay cuentas.
class Monogram extends StatelessWidget {
  const Monogram({
    super.key,
    required this.text,
    this.size = 36,
    this.filled = false,
  });

  final String text;
  final double size;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? KerbColors.brick : KerbColors.raised,
        border: Border.all(color: KerbColors.hairlineStrong, width: 1),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: KerbType.display,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.44,
          height: 1,
          color: KerbColors.cream,
        ),
      ),
    );
  }
}

/// Botón primario: píldora de ladrillo. Uno por pantalla, como mucho.
class KerbButton extends StatelessWidget {
  const KerbButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final button = FilledButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon, size: 18),
      label: Text(
        label,
        style: const TextStyle(
          fontFamily: KerbType.sans,
          fontWeight: FontWeight.w600,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
      ),
      style: FilledButton.styleFrom(
        backgroundColor: KerbColors.brick,
        foregroundColor: KerbColors.cream,
        disabledBackgroundColor: KerbColors.raised,
        disabledForegroundColor: KerbColors.muted,
        minimumSize: const Size(0, 52),
        padding: const EdgeInsets.symmetric(horizontal: Space.xl),
        shape: const StadiumBorder(),
        elevation: 0,
      ),
    );
    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
