---
name: CORS Headers Check
description: Use when configuring or reviewing CORS policies, credentialed requests, preflight responses, or cross-origin data exposure.
metadata:
  opencode/autoinvoke: false
---

# CORS Headers Check

## Cuándo usarla
Al conectar frontend y API en dominios distintos, al permitir cookies o al revisar una fuga de datos entre orígenes.

## Procedimiento
1. Lista los orígenes legítimos por entorno (local, staging, producción).
2. Comprueba `Access-Control-Allow-Origin`: nunca `*` con credenciales; refleja solo orígenes de la lista.
3. Revisa `Allow-Credentials`, `Allow-Methods`, `Allow-Headers`, `Expose-Headers` y `Max-Age`.
4. Verifica que el preflight `OPTIONS` no ejecute lógica de negocio ni omita autenticación.
5. Prueba con `curl -H "Origin: https://evil.example"` y confirma que no devuelve el origen reflejado.
6. Documenta la política y añade un test de integración.

## Criterio de terminado
Solo los orígenes permitidos reciben cabeceras CORS; un origen ajeno no puede leer respuestas con credenciales.

## Errores comunes
- Reflejar cualquier `Origin`.
- Poner `*` y `credentials: true`.
- Confundir CORS con autenticación.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP Cheat Sheet de CORS.
