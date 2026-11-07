---
name: Web Accessibility A11Y
description: Use when auditing WCAG 2.2 compliance, screen reader support, keyboard navigation, focus order, contrast ratios, or accessible forms and error messages.
metadata:
  opencode/autoinvoke: false
---

# Web Accessibility A11Y

## Cuándo usarla
Antes de publicar cualquier interfaz, al añadir formularios o modales, o si el usuario pide accesibilidad / WCAG.

## Procedimiento
1. Estructura: un `<h1>` por página, jerarquía de encabezados sin saltos, landmarks (`header`, `nav`, `main`, `footer`).
2. Teclado: recorre toda la app con Tab / Shift+Tab / Enter / Esc. El foco debe ser visible y seguir el orden visual. Sin trampas de foco en modales.
3. Semántica: botones para acciones, enlaces para navegación, `<label>` asociado a cada campo. `aria-*` solo cuando el HTML nativo no alcanza.
4. Contraste: 4.5:1 para texto normal, 3:1 para texto grande y componentes. Compruébalo con una herramienta, no a ojo.
5. Imágenes: `alt` descriptivo o `alt=""` para decorativas. Iconos con texto oculto.
6. Formularios: errores asociados al campo (`aria-describedby`), mensajes concretos, sin depender solo del color.
7. Movimiento: respeta `prefers-reduced-motion`; sin parpadeos por encima de 3 Hz.
8. Prueba con un lector de pantalla real (NVDA, VoiceOver, TalkBack).

## Criterio de terminado
Toda la app se opera solo con teclado, el contraste pasa, el lector de pantalla anuncia nombre, rol y estado, y los errores se entienden sin ver la pantalla.

## Errores comunes
- `div` con `onClick` sin rol ni foco.
- Placeholder como única etiqueta.
- `aria-label` contradiciendo el texto visible.

## Fuente
Basada en WCAG 2.2 (niveles A y AA) y `nextlevelbuilder/ui-ux-pro-max-skill`.
