---
name: GraphQL Query Optimization
description: Use when designing or reviewing GraphQL schemas, fixing N+1 resolver problems, or protecting an API from expensive deep queries.
metadata:
  opencode/autoinvoke: false
---

# GraphQL Query Optimization

## Cuándo usarla
Al construir un servidor GraphQL, al ver resolvers lentos, o al exponer GraphQL a clientes no confiables.

## Procedimiento
1. Modela por consumo: tipos que el cliente necesita, no espejo de la base de datos.
2. Resuelve N+1 con DataLoader o batching por campo; un resolver por campo no debe emitir una query por fila.
3. Limita profundidad (`maxDepth` 7–10) y complejidad (coste por campo + coste por lista con `first`).
4. Desactiva introspección en producción si el esquema es privado; mantenla si es público por DX.
5. Paginación con connection spec (`edges`/`pageInfo`), con límite máximo de `first`.
6. Persisted queries o allowlist en producción para clientes móviles.
7. Cachea a nivel de campo cuando el dato lo permita; usa `@defer`/`@stream` solo si el cliente lo soporta.
8. Instrumenta: tiempo y coste por operación, nombres de operación obligatorios.

## Criterio de terminado
Ninguna consulta legítima supera el presupuesto de coste, no hay N+1 en los caminos principales, y una query maliciosa se rechaza antes de tocar la base de datos.

## Errores comunes
- Un resolver que hace `SELECT` dentro de un bucle.
- Aceptar `first: 100000`.
- Exponer el esquema completo con introspección y sin límites.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y la especificación GraphQL + prácticas de DataLoader.
