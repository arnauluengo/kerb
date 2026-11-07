---
name: Data Migration Safe Rollback
description: Use when writing database migrations, altering schemas on live data, or designing a rollback plan without data loss.
metadata:
  opencode/autoinvoke: false
---

# Data Migration Safe Rollback

## Cuándo usarla
Antes de tocar el esquema en producción, al renombrar columnas, o al cambiar el tipo de un campo con datos.

## Regla de oro
Toda migración debe poder aplicarse y revertirse sin perder datos, y debe funcionar con la versión anterior del código todavía desplegada.

## Procedimiento (patrón expand/contract)
1. **Expand**: añade la estructura nueva sin romper la vieja (columna nueva nullable, tabla nueva, índice nuevo).
2. Despliega código que escriba en ambas y lea de la vieja.
3. **Backfill**: rellena datos por lotes, idempotente, con pausa y métrica de progreso.
4. Cambia la lectura a la nueva y verifica.
5. **Contract**: elimina la vieja en una migración posterior, cuando ya nada la usa.

## Reglas por operación
- Añadir columna: nullable o con `DEFAULT` no volátil.
- Renombrar: no lo hagas de golpe; añade nueva, copia, cambia código, borra vieja.
- Cambiar tipo: nueva columna + backfill + swap, no `ALTER TYPE` sobre tabla grande en caliente.
- Borrar: nunca en el mismo release que deja de usarse.
- Índices en tablas grandes: `CREATE INDEX CONCURRENTLY` (Postgres).
- Migraciones de datos: siempre con `WHERE` por lotes y transacción por lote.

## Rollback
Escribe el `down` real, pruébalo en una copia con datos de producción, y documenta qué se pierde si es irreversible (marcarlo explícitamente).

## Criterio de terminado
La migración se ha probado hacia delante y hacia atrás sobre una copia con volumen real, y el despliegue no requiere parada.

## Errores comunes
- `down` vacío o que solo lanza un error.
- Migración que bloquea la tabla 20 minutos.
- Backfill no idempotente que duplica filas al reintentar.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y el patrón expand/contract de migraciones.
