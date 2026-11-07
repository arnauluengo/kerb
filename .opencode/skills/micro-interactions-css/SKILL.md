---
name: Micro Interactions CSS
description: Use when adding hover, focus, press, loading, or transition states to a UI, or when animations feel janky, slow, or inconsistent.
metadata:
  opencode/autoinvoke: false
---

# Micro Interactions CSS

## Cuándo usarla
Al pulir una interfaz, al añadir feedback a botones y tarjetas, o cuando las animaciones se sienten artificiales.

## Reglas base
- Duración: 120–200 ms para cambios de estado, 200–300 ms para entradas, nunca más de 400 ms en interacción directa.
- Easing: `ease-out` al entrar, `ease-in` al salir, `cubic-bezier(0.2, 0, 0, 1)` para movimiento con peso.
- Anima solo `transform` y `opacity`. Nada de `width`, `height`, `top`, `left`, `box-shadow` en bucles.
- Todo estado interactivo tiene cuatro caras: reposo, hover, focus visible y activo. Más deshabilitado y cargando.

## Procedimiento
1. Inventaria las interacciones existentes y elimina animaciones decorativas sin propósito.
2. Define las curvas y duraciones como tokens (`--ease-out`, `--dur-fast`).
3. Añade `:focus-visible` con anillo claro y contraste suficiente; no elimines el outline sin sustituto.
4. Implementa estados de carga con skeleton o spinner estable (sin saltos de layout).
5. Respeta `prefers-reduced-motion`: reduce a cambios instantáneos o fundidos cortos.
6. Mide con DevTools: sin repintados en cascada, sin CLS, 60 fps en el dispositivo objetivo.

## Criterio de terminado
Cada elemento interactivo responde en menos de 200 ms, el foco es visible, y con movimiento reducido la app sigue siendo usable.

## Errores comunes
- `transition: all 0.3s`.
- Animar sombras que provocan repintados.
- Confundir "más animación" con "más calidad".

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y principios de Material Motion / Apple HIG.
