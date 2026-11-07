---
name: Responsive Breakpoint Audit
description: Use when checking a UI across mobile, tablet, and desktop widths, fixing overflow, touch targets, or layout bugs at different breakpoints.
metadata:
  opencode/autoinvoke: false
---

# Responsive Breakpoint Audit

## Cuándo usarla
Antes de entregar cualquier pantalla, al recibir quejas de "se rompe en el móvil", o al añadir un layout nuevo.

## Procedimiento
1. Fija los anchos de prueba: 320, 375, 390, 768, 1024, 1440 px. En Flutter, usa los tamaños lógicos equivalentes.
2. Recorre cada pantalla en esos anchos y anota: overflow horizontal, texto cortado, elementos solapados, imágenes deformadas.
3. Comprueba los objetivos táctiles: mínimo 44×44 px (iOS) / 48×48 dp (Android) y separación entre ellos.
4. Verifica el zoom de texto (hasta 200 %) y el modo horizontal donde aplique.
5. Comprueba unidades: `rem`/`em` para texto, `dvh` en vez de `vh` en móvil, `min()`/`clamp()` para tipografía fluida.
6. Revisa las safe areas (notch, barra de gestos) y el teclado virtual sobre formularios.
7. Arregla de dentro hacia fuera: contenedor → grid → componente → texto.

## Criterio de terminado
Ninguna pantalla produce scroll horizontal involuntario en 320 px; todos los controles son alcanzables con el pulgar y el texto no se corta.

## Errores comunes
- Probar solo en el tamaño del portátil.
- Arreglar el síntoma con `overflow: hidden`.
- Usar media queries en píxeles para todo ignorando el zoom.

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y WCAG 2.2 (reflow, target size).
