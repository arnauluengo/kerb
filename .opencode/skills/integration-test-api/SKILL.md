---
name: Integration Test API
description: Use when testing API endpoints end-to-end against a real or ephemeral database, or when mocking the DB in tests hides real bugs.
metadata:
  opencode/autoinvoke: false
---

# Integration Test API

## Cuándo usarla
Al probar handlers HTTP completos, middleware, validación y persistencia juntos. Es la capa entre unitario y E2E.

## Principio
Prueba contra infraestructura real y efímera (contenedor, SQLite en memoria, base de test). Mockear la base de datos valida tus mocks, no tu SQL.

## Procedimiento
1. Levanta una base de datos de test (Testcontainers, docker compose, servicio del CI) y migra el esquema al inicio.
2. Cada test: transacción con rollback o truncado de tablas. Nunca compartas estado.
3. Llama a la API por HTTP real (supertest, httpx, RestAssured), no a la función del handler.
4. Cubre: autenticación, autorización, validación, conflicto, paginación, y camino feliz.
5. Verifica el **efecto en la base de datos**, no solo el código de respuesta.
6. Comprueba contratos: forma del JSON, códigos, cabeceras.
7. Incluye casos de concurrencia donde importe (dos escrituras simultáneas, doble submit).
8. Mide el tiempo de la suite; si tarda demasiado, separa los lentos con una etiqueta.

## Criterio de terminado
La suite arranca desde cero con un comando, no depende de datos previos, y detecta una regresión real en SQL, permisos o contrato.

## Errores comunes
- Mockear el repositorio y llamarlo integración.
- Tests que comparten una base de datos sucia.
- Probar solo el 200 y olvidar 401/403/422.

## Fuente
Basada en `obra/superpowers` (313k★) y prácticas de testing de APIs.
