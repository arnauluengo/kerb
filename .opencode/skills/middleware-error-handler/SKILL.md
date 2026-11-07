---
name: Middleware Error Handler
description: Use when centralizing exception handling, standardizing API error responses, or stopping errors from leaking stack traces to clients.
metadata:
  opencode/autoinvoke: false
---

# Middleware Error Handler

## Cuándo usarla
Al montar una API nueva, al encontrar respuestas de error distintas en cada endpoint, o al ver stack traces en producción.

## Procedimiento
1. Define una jerarquía de errores de dominio: `ValidationError`, `AuthError`, `NotFoundError`, `ConflictError`, `RateLimitError`, `ExternalServiceError`.
2. Cada error lleva: código estable, mensaje para el usuario, `details` opcionales y `httpStatus`.
3. Un único middleware captura todo y formatea:
   ```json
   { "error": { "code": "CAR_NOT_FOUND", "message": "No existe esa carta", "requestId": "..." } }
   ```
4. Los errores inesperados se registran con stack y contexto completo, y al cliente le llega un mensaje genérico + `requestId`.
5. Nunca devuelvas el mensaje de la base de datos, rutas del sistema ni stack traces.
6. Distingue errores operacionales (esperados, se registran como warn) de errores de programación (se registran como error y alertan).
7. Cubre los bordes: 404 de ruta, 405, JSON malformado, timeout, payload demasiado grande, cancelación del cliente.
8. Añade el `requestId` a todos los logs y a la respuesta para poder correlacionar.

## Criterio de terminado
Todos los endpoints devuelven la misma forma de error, un fallo de base de datos no filtra detalles, y cada error se puede buscar por `requestId` en los logs.

## Errores comunes
- `catch` que devuelve `500` con `err.message`.
- Formas de error distintas por endpoint.
- Tragarse la excepción y devolver `200`.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y el patrón de error middleware de Express/FastAPI.
