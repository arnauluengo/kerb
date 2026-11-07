---
name: Git Monorepo Workspace
description: Use when working with multiple apps in one repo, managing branches and stashes, or isolating a risky change in a worktree.
metadata:
  opencode/autoinvoke: false
---

# Git Monorepo Workspace

## Cuándo usarla
En repos con varias apps o paquetes, al cambiar de tarea con trabajo a medias, o cuando hay que probar algo sin ensuciar la rama actual.

## Reglas
- Una rama por tarea: `feat/scan-flow`, `fix/login-otp`. Nunca trabajar en `main`.
- Antes de empezar: `git status` limpio o trabajo guardado explícitamente.
- Commits pequeños y con intención (ver `conventional-commits-enforcer`).
- `git stash` es temporal, no almacenamiento: nómbralo (`git stash push -m "wip: card animation"`) y vacíalo pronto.
- Riesgo o tarea larga: `git worktree add ../kerb-scan feat/scan-flow` y trabaja ahí. Un worktree por tarea, sin copiar el repo.
- Rebase para actualizar tu rama; merge para integrar. No reescribas ramas compartidas.
- Antes de cambiar de rama: `git fetch` y comprueba si hay dependencias desinstaladas o migraciones pendientes.

## Procedimiento en monorepo
1. Identifica el paquete afectado y ejecuta solo sus tests: `npm test -w apps/mobile`.
2. Revisa si el cambio toca contratos compartidos (`packages/shared`).
3. Actualiza las dependencias internas con el gestor de workspaces, no a mano.
4. Ejecuta el pipeline completo antes de abrir PR si cambias la raíz.

## Recuperación
- `git reflog` para deshacer un reset.
- `git stash list` para localizar trabajo guardado.
- `git worktree list` para saber qué copias existen; elimínalas con `git worktree remove`.

## Criterio de terminado
Cada tarea vive en su rama o worktree, no hay stash huérfanos, y `main` siempre se puede desplegar.

## Errores comunes
- Clonar el repo tres veces por tarea.
- Ramas de vida larga que divergen sin fin.
- Stashes sin nombre que se pierden.

## Fuente
Basada en `obra/superpowers` (313k★), `using-git-worktrees`, y prácticas de monorepo.
