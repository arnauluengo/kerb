---
name: Dark Mode Native Toggle
description: Use when implementing light and dark themes, adding a theme toggle, or fixing hardcoded colors that break in dark mode.
metadata:
  opencode/autoinvoke: false
---

# Dark Mode Native Toggle

## Cuándo usarla
Al añadir tema oscuro/claro, al detectar colores que no cambian, o al decidir si el producto debe tener modo claro.

## Procedimiento
1. Decide si el producto necesita ambos modos. Si la marca es oscura por identidad (apps cinematográficas, terminales), documenta que solo hay oscuro y no añadas un toggle vacío.
2. Define tokens semánticos (`surface`, `surface-raised`, `text`, `text-muted`, `border`, `accent`) y resuelve sus valores por tema.
3. Implementa el tema con una clase en `html` (`class="dark"`) o `data-theme`, no con media queries dispersas.
4. Inicializa antes del primer pintado para evitar el flash blanco: script inline que lea `localStorage` o `prefers-color-scheme`.
5. Toggle de tres estados: sistema / claro / oscuro. Persiste la elección y escucha cambios del sistema.
6. Revisa: contraste, imágenes con transparencia, sombras (en oscuro se sustituyen por bordes o elevación de superficie), y estados de foco.
7. No inviertas colores con `filter: invert()`.

## Criterio de terminado
Cambiar de tema no recarga ni parpadea, todos los textos pasan contraste en ambos modos, y no queda ningún color hardcodeado fuera de los tokens.

## Errores comunes
- `#fff` y `#000` literales por todo el código.
- Oscuro que es solo "gris muy oscuro con texto blanco puro" (deslumbra: usa `#e6e6e6`).
- Olvidar el tema en modales y toasts (portales fuera del árbol).

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y WCAG 1.4.3 / 1.4.11.
