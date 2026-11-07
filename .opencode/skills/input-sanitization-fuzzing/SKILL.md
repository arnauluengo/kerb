---
name: Input Sanitization and Fuzzing
description: Use when validating request payloads, query params, file uploads, or template inputs and testing SQL injection, XSS, command injection, or path traversal.
metadata:
  opencode/autoinvoke: false
---

# Input Sanitization and Fuzzing

## Cuándo usarla
En cualquier endpoint que reciba texto, JSON, ficheros, nombres de ruta o plantillas; antes de exponer una API a Internet.

## Procedimiento
1. Define el contrato de entrada con un esquema estricto (Zod, Pydantic, JSON Schema) y rechaza campos desconocidos.
2. Valida tipo, longitud, rango, formato y codificación; normaliza antes de comparar.
3. Usa consultas parametrizadas y escapa la salida según el contexto (HTML, atributo, JS, URL, SQL).
4. Para ficheros: valida MIME real, extensión, tamaño, nombre y ruta; guarda fuera del webroot.
5. Fuzzea con payloads de SQLi, XSS, command injection, path traversal y JSON malformado.
6. Añade tests de regresión con los payloads que fallaron.

## Criterio de terminado
Todo input tiene esquema, límite y prueba negativa; los payloads de ataque devuelven 400/403 sin ejecutar nada.

## Errores comunes
- Confiar en el `Content-Type` del cliente.
- Escapar una vez y reutilizar el dato en otro contexto.
- Concatenar SQL o comandos de shell.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP Top 10 (A03: Injection).
