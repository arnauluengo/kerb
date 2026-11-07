---
name: Frontend Performance Audit
description: Use when a page or app feels slow, when optimizing images, fonts, and bundles, or when reducing LCP, CLS, and INP.
metadata:
  opencode/autoinvoke: false
---

# Frontend Performance Audit

## Cuándo usarla
Antes de publicar, al recibir quejas de lentitud, o al revisar Core Web Vitals.

## Procedimiento
1. Mide primero: Lighthouse (móvil, throttling 4G), panel Performance, y `web-vitals` en producción. Sin medición no hay optimización.
2. **LCP**: identifica el elemento más grande. Precarga la imagen hero, evita `loading="lazy"` en above-the-fold, sirve AVIF/WebP con `srcset`.
3. **CLS**: reserva dimensiones (`width`/`height` o `aspect-ratio`) en toda imagen, iframe y anuncio. Reserva espacio para fuentes y skeletons.
4. **INP**: reduce JS de arranque, divide por rutas, difiere trabajo no crítico, evita listeners pesados en scroll.
5. Fuentes: `font-display: swap`, subset, `woff2`, preload del peso crítico. Nunca 5 pesos por familia.
6. Bundle: analiza con el visualizer, elimina dependencias por una función, comprueba duplicados entre chunks.
7. Imágenes: tamaños correctos, compresión, CDN, `decoding="async"`.
8. Repite la medición y compara antes/después con números.

## Criterio de terminado
LCP < 2.5 s, CLS < 0.1, INP < 200 ms en móvil emulado, y el informe muestra la mejora con cifras.

## Errores comunes
- Optimizar sin medir.
- Cargar una librería entera para un icono.
- Poner `lazy` en la imagen principal.

## Fuente
Basada en `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) y Core Web Vitals.
