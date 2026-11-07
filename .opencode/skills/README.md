# Catálogo de skills — 50 capacidades

Skills de proyecto para OpenCode. 47 viven aquí; 3 se reutilizan de tu entorno global y **no** se duplican.

## Cómo se invocan

**1. Comando de barra (recomendado)**

```
/skill <id> <tarea>
```

Ejemplos:

```
/skill sast-security-scan revisa src/api
/skill anti-ai-design-bias pule la pantalla del garaje
/skill tdd-superpowers implementa el flujo de escaneo
```

Sin argumentos, `/skill` imprime este índice. El comando está en `.opencode/commands/skill.md`.

**2. Petición en lenguaje natural**

```
Usa la skill sast-security-scan para revisar src/api
```

El agente la carga con la herramienta `skill`. Menos fiable que `/skill`: depende de que reconozca el id.

**3. Carga explícita interna**

El agente llama a la herramienta `skill` con el id. Es lo que hace `/skill` por dentro.

> Ojo con `@`: en OpenCode sirve para mencionar archivos y agentes, no skills. Si escribes `@sast-security-scan` sin que exista un archivo o agente con ese nombre, no se cargará nada. Usa `/skill`.

> Las 47 skills llevan `metadata.opencode/autoinvoke: false` para no inflar el catálogo del modelo en cada sesión. Se cargan solo cuando se piden.

## Índice

### Bloque 1 — Seguridad (1–10)

| # | ID | Para qué |
|---|---|---|
| 1 | `sast-security-scan` | Fallos OWASP Top 10, sinks peligrosos, riesgo pre-merge |
| 2 | `secret-leak-detection` | Claves y tokens expuestos en árbol, diff e historial |
| 3 | `auth-jwt-hardening` | Algoritmos, claims, expiración, rotación |
| 4 | `input-sanitization-fuzzing` | Esquemas de entrada, SQLi, XSS, path traversal |
| 5 | `rbac-permission-verifier` | Matriz rol × acción × recurso, IDOR |
| 6 | `dependency-vulnerability-audit` | CVEs en lockfiles, imágenes y SBOM |
| 7 | `cors-headers-check` | Orígenes permitidos, preflight, credenciales |
| 8 | `rate-limiting-strategist` | Cuotas, throttling, brute force, 429 |
| 9 | `secure-session-management` | Cookies, rotación, CSRF, logout |
| 10 | `encryption-at-rest-transit` | Argon2/bcrypt, TLS, backups cifrados |

### Bloque 2 — Frontend y UI/UX (11–20)

| # | ID | Para qué |
|---|---|---|
| 11 | `ui-ux-pro-max` | **Ya existe en tu entorno global** — paletas, tipografía, jerarquía |
| 12 | `anti-ai-design-bias` | Elimina degradados morados y clichés de IA |
| 13 | `tailwind-modular-architecture` | Tokens, componentes, config limpio |
| 14 | `responsive-breakpoint-audit` | 320–1440 px, overflow, touch targets |
| 15 | `micro-interactions-css` | Hover, foco, duraciones, `prefers-reduced-motion` |
| 16 | `web-accessibility-a11y` | WCAG 2.2, teclado, lector de pantalla, contraste |
| 17 | `shadcn-custom-theming` | Tokens CSS sobre primitivas Radix |
| 18 | `font-pairing-hierarchy` | Escala tipográfica, parejas, carga de fuentes |
| 19 | `dark-mode-native-toggle` | Temas por tokens, sin flash, persistencia |
| 20 | `frontend-performance-audit` | LCP, CLS, INP, imágenes, bundle |

### Bloque 3 — Backend y APIs (21–30)

| # | ID | Para qué |
|---|---|---|
| 21 | `api-rest-schema-design` | Rutas, verbos, códigos, errores, versionado |
| 22 | `graphql-query-optimization` | N+1, DataLoader, profundidad y coste |
| 23 | `database-sql-indexing` | Índices, `EXPLAIN`, consultas lentas |
| 24 | `nosql-schema-aggregation` | Embeber vs referenciar, pipelines |
| 25 | `fastapi-async-worker` | Endpoints async, tareas en background |
| 26 | `nodejs-event-loop-safety` | Bloqueos, streams, fugas de memoria |
| 27 | `middleware-error-handler` | Errores centralizados y respuesta uniforme |
| 28 | `caching-redis-layer` | Claves, TTL, invalidación, estampida |
| 29 | `data-migration-safe-rollback` | Expand/contract, backfill, `down` real |
| 30 | `microservices-event-driven` | Colas, eventos, idempotencia, DLQ |

### Bloque 4 — Metodología, calidad y testing (31–40)

| # | ID | Para qué |
|---|---|---|
| 31 | `tdd-superpowers` | Red-green-refactor estricto |
| 32 | `karpathy-clean-code` | Simplicidad, regla de tres, diffs pequeños |
| 33 | `jest-unit-test-generator` | Tests unitarios, mocks, async |
| 34 | `cypress-e2e-automation` | Flujos E2E estables, sin flakiness |
| 35 | `integration-test-api` | API contra base de datos efímera |
| 36 | `systematic-debugging` | **Ya existe en superpowers** — aislamiento científico del fallo |
| 37 | `code-complexity-refactor` | Complejidad ciclomática, anidación, guard clauses |
| 38 | `ci-cd-github-actions` | Pipelines, permisos, secretos, caché |
| 39 | `conventional-commits-enforcer` | Mensajes que generan changelog |
| 40 | `verification-before-completion` | **Ya existe en superpowers** — compilar y verificar antes de declarar terminado |

### Bloque 5 — Automatización y productividad (41–50)

| # | ID | Para qué |
|---|---|---|
| 41 | `caveman-token-reduction` | Respuestas mínimas sin perder información |
| 42 | `agents-md-orchestrator` | Mantener AGENTS.md útil para subagentes |
| 43 | `saas-tool-connector` | Integraciones externas aisladas y resilientes |
| 44 | `pdf-spec-parser` | Requisitos verificables desde PDF |
| 45 | `xlsx-data-reporter` | Hojas de cálculo limpias y análisis |
| 46 | `docx-readme-generator` | Documentación Markdown útil |
| 47 | `pptx-architecture-deck` | Slides de arquitectura, una idea por slide |
| 48 | `ubiquitous-language-glossary` | Un nombre por concepto, en código y datos |
| 49 | `cli-tools-auto-installer` | Bootstrap idempotente de binarios |
| 50 | `git-monorepo-workspace` | Ramas, stashes y worktrees aislados |

## Skills reutilizadas

| ID | Ubicación canónica |
|---|---|
| `ui-ux-pro-max` | Catálogo de skills del entorno |
| `systematic-debugging` | `~/.config/opencode/superpowers/skills/systematic-debugging` |
| `verification-before-completion` | `~/.config/opencode/superpowers/skills/verification-before-completion` |

Si algún día quieres una versión propia, crea la carpeta aquí con el mismo id: el ámbito de proyecto tiene prioridad sobre el global.

## Fuentes

Las skills son playbooks operativos derivados de:

- `obra/superpowers` (313k★) — metodología y TDD
- `anthropics/skills` (188k★) — documentos y estructura
- `multica-ai/andrej-karpathy-skills` (230k★) — simplicidad y depuración
- `nextlevelbuilder/ui-ux-pro-max-skill` (146k★) — diseño
- `ComposioHQ/awesome-claude-skills` (79k★) — automatización SaaS y CI
- `JuliusBrussee/caveman` (118k★) — concisión
- `trailofbits/skills` (8k★) — seguridad
- `alirezarezvani/claude-skills` (29k★) — backend y APIs

## Estado

Estas skills están escritas pero **no validadas** con el ciclo de `writing-skills` (escenario de presión → comportamiento base → comprobar que la skill corrige el fallo). Si una no cambia el comportamiento del agente, reescribe su `description` antes que su cuerpo: es el disparador.
