---
name: CI CD GitHub Actions
description: Use when creating or fixing GitHub Actions workflows, adding build/test/deploy pipelines, or securing CI secrets and permissions.
metadata:
  opencode/autoinvoke: false
---

# CI CD GitHub Actions

## Cuándo usarla
Al añadir integración continua, al preparar releases, o al depurar un workflow que falla solo en CI.

## Estructura mínima de un pipeline
1. **Checkout** con `fetch-depth` suficiente (1 por defecto; 0 si necesitas tags).
2. **Setup** del runtime con versión fijada y caché de dependencias.
3. **Lint + typecheck** (rápido, falla primero).
4. **Tests** con reporte de cobertura.
5. **Build** del artefacto.
6. **Deploy** solo en `main` o en tag, protegido por environment.

## Reglas
- Fija las versiones de las actions por SHA, no por tag móvil (`@v4` puede cambiar).
- `permissions:` explícitas y mínimas en cada workflow (`contents: read` por defecto).
- Secretos en `secrets.*` o environments, nunca en el YAML. Nunca los imprimas (`echo`).
- `concurrency` para cancelar ejecuciones obsoletas de la misma rama.
- Caché: `actions/cache` o la caché nativa del setup, con clave basada en el lockfile.
- Matriz solo si aporta (`os`, versión de runtime); cada combinación cuesta minutos.
- Artefactos con retención corta y nombre que incluya el commit.
- `timeout-minutes` en cada job para no colgar la cola.

## Procedimiento
1. Escribe el workflow para que falle igual que en local (`npm ci`, no `npm install`).
2. Ejecuta en una rama y revisa los logs completos del primer fallo.
3. Añade rama protegida: requiere CI verde y revisión.
4. Documenta cómo reproducir el pipeline en local.

## Criterio de terminado
Un push a una rama ejecuta lint, tests y build en menos de 10 minutos; un fallo es reproducible en local; ningún secreto aparece en logs.

## Errores comunes
- Instalar dependencias sin lockfile.
- `permissions: write-all`.
- Deploy con `push` a cualquier rama.
- Secretos en variables de entorno impresas por error.

## Fuente
Basada en `ComposioHQ/awesome-claude-skills` (79k★) y el hardening oficial de GitHub Actions.
