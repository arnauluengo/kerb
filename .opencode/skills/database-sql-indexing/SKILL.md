---
name: Database SQL Indexing
description: Use when designing relational schemas, writing migrations, speeding up slow queries, or reviewing indexes in PostgreSQL or MySQL.
metadata:
  opencode/autoinvoke: false
---

# Database SQL Indexing

## Cuándo usarla
Al modelar tablas, al añadir consultas nuevas, o cuando una query tarda más de lo aceptable.

## Procedimiento
1. Parte del acceso, no del diagrama: lista las consultas reales con su frecuencia y su filtro.
2. Indexa las columnas de `WHERE`, `JOIN`, `ORDER BY` y `GROUP BY` en ese orden de prioridad.
3. Índices compuestos: la columna de igualdad primero, luego rango, luego orden. La regla del prefijo izquierdo decide si sirve.
4. Evita indexar columnas de baja cardinalidad solas (booleanos); usa índices parciales.
5. Mide con `EXPLAIN (ANALYZE, BUFFERS)`. Busca `Seq Scan` en tablas grandes y `Nested Loop` con muchas filas.
6. Revisa escrituras: cada índice encarece `INSERT`/`UPDATE`. Elimina índices sin uso (`pg_stat_user_indexes`).
7. Cuidado con funciones sobre columnas indexadas (`WHERE lower(email) = ...` necesita índice funcional).
8. Tipos correctos: `uuid` vs `text`, `timestamptz` para tiempo, `numeric` para dinero.

## Criterio de terminado
Las consultas críticas usan índice, el plan está documentado, y no hay índices duplicados ni sin uso.

## Errores comunes
- Indexar todo "por si acaso".
- `SELECT *` en tablas anchas.
- Índice compuesto en el orden equivocado.
- Usar `float` para dinero.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y documentación de PostgreSQL.
