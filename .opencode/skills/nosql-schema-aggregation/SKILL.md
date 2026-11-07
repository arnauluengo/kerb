---
name: NoSQL Schema Aggregation
description: Use when modeling document databases, designing MongoDB collections, writing aggregation pipelines, or fixing slow document queries.
metadata:
  opencode/autoinvoke: false
---

# NoSQL Schema Aggregation

## Cuándo usarla
Al modelar en MongoDB/Firestore/CouchDB, al decidir entre embeber o referenciar, o al optimizar un pipeline de agregación.

## Procedimiento
1. Modela por patrón de lectura: qué pantalla necesita qué documento completo.
2. Embeber cuando el dato se lee siempre junto y no crece sin límite (dirección, configuración). Referenciar cuando crece, cambia mucho o se comparte.
3. Limita el tamaño del documento: si una lista puede superar unos cientos de elementos, sepárala.
4. Evita arrays que crecen indefinidamente (comentarios, eventos); usa colección aparte.
5. Aggregation pipeline: `$match` y `$limit` primero, `$lookup` después, `$project` al final para reducir el documento.
6. Crea índices según el pipeline: `$match` + `$sort` en el mismo orden del índice compuesto.
7. Usa `explain("executionStats")`; vigila `totalDocsExamined` frente a `nReturned`.
8. Consistencia: define qué se duplica y cómo se mantiene sincronizado; documenta la desnormalización.

## Criterio de terminado
Cada consulta de pantalla se resuelve con un índice, ningún documento crece sin límite, y la duplicación está documentada con su estrategia de sincronización.

## Errores comunes
- Modelar como SQL relacional con `$lookup` por todas partes.
- Array de seguidores dentro del usuario.
- `$match` al final del pipeline.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y los patrones de modelado de MongoDB.
