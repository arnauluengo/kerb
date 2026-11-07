---
name: Tailwind Modular Architecture
description: Use when structuring Tailwind CSS projects, splitting components, tuning tailwind.config, or removing duplicated utility classes and arbitrary values.
metadata:
  opencode/autoinvoke: false
---

# Tailwind Modular Architecture

## Cuándo usarla
Al iniciar un proyecto con Tailwind, cuando el HTML acumula 40 clases, o cuando el config crece sin criterio.

## Procedimiento
1. Define tokens en el config o en `@theme`: color, espaciado, radios, sombras, tipografía. Nada de valores arbitrarios repetidos (`text-[13px]`, `bg-[#1a1b1e]`) más de dos veces.
2. Nombra los colores por función (`surface`, `surface-raised`, `accent`, `danger`), no por tono (`gray-800`, `purple-500`).
3. Extrae componentes cuando el mismo bloque de clases aparece 3 veces: `@layer components` o componente React/Vue con props.
4. Deja las utilidades para layout y ajustes locales; los componentes para apariencia repetida.
5. Evita `@apply` masivo: acopla el CSS al framework y rompe la trazabilidad.
6. Ordena las clases con el plugin de Prettier para Tailwind.
7. Verifica que el CSS final no incluya clases muertas: purga por contenido y revisa el bundle.

## Criterio de terminado
Un cambio de paleta se hace en un solo archivo; no hay clases arbitrarias duplicadas; el bundle CSS no crece sin justificación.

## Errores comunes
- Mezclar `dark:` en 300 sitios en vez de tokens semánticos.
- Un `tailwind.config` con 80 colores.
- Crear un componente por cada `div`.

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y la guía de Tailwind CSS v4.
