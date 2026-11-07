---
name: Anti AI Design Bias
description: Use when a UI looks generic or templated, when choosing a color palette, gradient, hero layout, or icon style, or when the user says the design feels like AI slop.
metadata:
  opencode/autoinvoke: false
---

# Anti AI Design Bias

## Cuándo usarla
Al empezar cualquier pantalla nueva, al revisar un diseño que "no se siente bien", o cuando el usuario pide algo menos genérico.

## Sesgos prohibidos por defecto
- Degradado morado/violeta a azul como color principal.
- Fondo `#0a0a0a` + tarjetas `#111` + acento neón sin motivo.
- Tres tarjetas iguales con icono, título y párrafo de relleno.
- Emojis haciendo de iconografía.
- `border-radius: 16px` en todo y sombra difusa en todo.
- Texto centrado en bloques largos.
- Ilustraciones de personas abstractas o "blobs".

## Procedimiento
1. Pide o define el brief: quién lo usa, qué debe sentir, qué referencia real existe.
2. Elige **una** dirección visual y nómbrala (editorial, industrial, editorial cálido, brutalista, cinematográfico).
3. Deriva la paleta de una fuente concreta (una foto, una marca, un material), no del gusto del modelo.
4. Limita a: 1 color dominante, 1 de acento, 2 neutros, 1 de estado.
5. Usa escala tipográfica con contraste real (salto mínimo de 1.5×), no 14/16/18.
6. Justifica cada decisión visual en una frase. Si no puedes, elimínala.
7. Comprueba contraste y jerarquía antes de dar por buena la pantalla.

## Criterio de terminado
Puedes describir el diseño en tres adjetivos concretos y ninguna decisión visual es un default del modelo.

## Errores comunes
- "Moderno y limpio" como dirección (no es una dirección).
- Añadir degradados para tapar una jerarquía mala.
- Copiar el patrón SaaS genérico sin adaptarlo al dominio.

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y crítica de patrones generativos.
