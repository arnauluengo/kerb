---
name: shadcn Custom Theming
description: Use when customizing shadcn/ui components, wiring design tokens into Radix primitives, or adapting the component layer to a custom brand.
metadata:
  opencode/autoinvoke: false
---

# shadcn Custom Theming

## Cuándo usarla
Al instalar shadcn/ui en un proyecto, al aplicar una marca propia, o cuando los componentes se ven "de serie".

## Procedimiento
1. Instala los componentes con la CLI y mantenlos en `components/ui` como código propio, no como dependencia opaca.
2. Define los tokens en `globals.css` con variables CSS en `:root` y `.dark`: `--background`, `--foreground`, `--primary`, `--primary-foreground`, `--muted`, `--border`, `--ring`, `--radius`.
3. Traduce la marca a intención, no a hex suelto: cada token debe responder "¿para qué sirve?".
4. Ajusta `--radius` y la escala de espaciado en un único sitio; no parchees componente por componente.
5. Extiende con `class-variance-authority` para variantes nuevas (`size`, `tone`) en vez de duplicar componentes.
6. Revisa estados que shadcn no cubre: carga, vacío, error, deshabilitado con motivo.
7. Comprueba contraste de `--primary-foreground` sobre `--primary` en claro y oscuro.

## Criterio de terminado
Cambiar la marca entera se hace editando variables CSS; ningún componente tiene colores hardcodeados; todas las variantes tienen sus estados.

## Errores comunes
- Sobrescribir con `!important` desde fuera.
- Añadir un color nuevo por cada pantalla.
- Olvidar el anillo de foco (`--ring`).

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y la arquitectura de shadcn/ui sobre Radix.
