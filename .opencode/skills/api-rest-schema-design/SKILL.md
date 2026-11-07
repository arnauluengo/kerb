---
name: API REST Schema Design
description: Use when designing REST endpoints, naming routes, choosing HTTP verbs and status codes, versioning an API, or reviewing an inconsistent API surface.
metadata:
  opencode/autoinvoke: false
---

# API REST Schema Design

## Cuándo usarla
Al crear una API, al añadir recursos, o al revisar una API con rutas incoherentes (`/getUser`, `/user_create`).

## Reglas
- Recursos en plural y sustantivos: `/cars`, `/cars/{id}/photos`. Nada de verbos en la ruta.
- Verbos HTTP por intención: `GET` leer, `POST` crear, `PUT` reemplazar, `PATCH` modificar, `DELETE` borrar.
- Códigos: `200` ok, `201` creado + `Location`, `204` sin cuerpo, `400` validación, `401` sin autenticar, `403` sin permiso, `404` no existe, `409` conflicto, `422` semántica inválida, `429` límite, `5xx` fallo del servidor.
- Paginación por cursor preferida a offset para listas grandes; `limit` con máximo y por defecto.
- Filtros y orden como query params; nunca como rutas nuevas.
- Errores con forma estable: `{ "error": { "code", "message", "details" } }`.
- Versionado explícito (`/v1`) o por cabecera; la versión no se cambia por capricho.

## Procedimiento
1. Lista los recursos y sus relaciones.
2. Diseña las rutas y la forma de cada respuesta antes de escribir el handler.
3. Define el contrato con OpenAPI y genera el cliente.
4. Revisa idempotencia: `PUT`, `DELETE` y `POST` con clave de idempotencia.
5. Documenta errores por endpoint, no solo el camino feliz.

## Criterio de terminado
Un cliente puede adivinar la ruta de un recurso nuevo; cada error tiene código y mensaje; el contrato está versionado.

## Errores comunes
- Devolver `200` con `{ success: false }`.
- Meter acciones en la URL (`/cars/scan` puede ser válido como subrecurso de acción, pero no por defecto).
- Cambiar la forma de respuesta en cada endpoint.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y la guía REST de Microsoft/Google.
