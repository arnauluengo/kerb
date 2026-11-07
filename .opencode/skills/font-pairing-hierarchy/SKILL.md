---
name: Font Pairing Hierarchy
description: Use when choosing typefaces, defining a type scale, fixing cramped or inconsistent typography, or pairing display, body, and monospace fonts.
metadata:
  opencode/autoinvoke: false
---

# Font Pairing Hierarchy

## Cuándo usarla
Al definir la identidad tipográfica de un producto o al revisar una interfaz con tipografía incoherente.

## Reglas
- Máximo **dos** familias por producto, tres si hay código: display, texto y mono.
- El contraste viene del tamaño y el peso, no de acumular familias.
- Cuerpo de texto: 16–18 px, altura de línea 1.4–1.6, medida de 45–75 caracteres.
- Títulos: altura de línea 1.0–1.2, tracking negativo ligero solo en tamaños grandes.
- Escala con salto real: 12 / 14 / 16 / 20 / 26 / 34 / 46 / 62 (≈1.3×).
- Números tabulares para tablas y datos; `font-variant-numeric: tabular-nums`.
- Carga: máximo 2 pesos por familia, `font-display: swap`, subset y preload del peso crítico.

## Procedimiento
1. Escribe las tres funciones tipográficas del producto (marca, lectura, dato).
2. Elige familias por criterio: legibilidad en pantalla, cobertura de idioma, licencia.
3. Define la escala como tokens, no como tamaños sueltos.
4. Aplica y revisa en 320 px y 1440 px.
5. Verifica CLS y peso de fuentes en el build.

## Criterio de terminado
La pantalla se lee sin esfuerzo, hay 3–4 niveles jerárquicos claros y no se descarga ninguna fuente que no se use.

## Errores comunes
- Dos sans-serif casi idénticas.
- Títulos gigantes con texto minúsculo.
- Fuentes decorativas en cuerpo de texto.

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y tipografía editorial aplicada a producto.
