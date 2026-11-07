---
name: Conventional Commits Enforcer
description: Use when writing commit messages, preparing a release changelog, or standardizing Git history across contributors.
metadata:
  opencode/autoinvoke: false
---

# Conventional Commits Enforcer

## Formato
```
<tipo>(<ámbito opcional>): <descripción en imperativo, minúscula, sin punto>

[cuerpo opcional: por qué, no qué]

[footer: BREAKING CHANGE: ..., Closes #123]
```

## Tipos
- `feat`: funcionalidad nueva para el usuario.
- `fix`: corrección de un bug.
- `refactor`: cambio de estructura sin cambiar comportamiento.
- `perf`: mejora de rendimiento.
- `test`: tests.
- `docs`: documentación.
- `build`: sistema de build o dependencias.
- `ci`: pipelines.
- `chore`: mantenimiento sin impacto en producto.
- `style`: formato, sin cambio de lógica.

## Procedimiento
1. Antes de commitear, revisa `git diff --staged`. Un commit = un cambio lógico.
2. Elige el tipo por el **efecto**, no por el archivo tocado.
3. La descripción completa: "Añade", no "Añadido" ni "Añadiendo". ≤ 72 caracteres.
4. En el cuerpo explica el porqué y el impacto; el qué ya está en el diff.
5. Breaking change: `feat(config)!:` o footer `BREAKING CHANGE:`.
6. Referencia el issue cuando exista.
7. Configura `commitlint` + `husky` para que el CI y el hook lo verifiquen.

## Criterio de terminado
`git log --oneline` se lee como un changelog; el mensaje responde a "qué cambia para el usuario" y el release se puede generar automáticamente.

## Errores comunes
- `fix` para todo.
- "cambios", "wip", "update".
- Mezclar refactor y feature en un commit.

## Fuente
Basada en Conventional Commits 1.0.0 y `ComposioHQ/awesome-claude-skills` (79k★).
