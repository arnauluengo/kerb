---
name: Auth JWT Hardening
description: Use when auditing or implementing JWT authentication, token expiry, refresh flows, signing algorithms, key rotation, or claims validation.
metadata:
  opencode/autoinvoke: false
---

# Auth JWT Hardening

## Cuándo usarla
Al diseñar login, refresh tokens, sesiones móviles, APIs protegidas o al revisar una auditoría de autenticación.

## Procedimiento
1. Verifica que el algoritmo esté fijado en el servidor (`RS256`/`ES256`); rechaza `none` y algoritmos inesperados.
2. Comprueba `iss`, `aud`, `exp`, `nbf`, `iat` y el `sub`; no confíes en claims sin validar.
3. Define expiraciones cortas para el access token (5–15 min) y refresh con rotación y revocación.
4. Revisa el almacenamiento: memoria o almacén seguro; nunca en `localStorage` si hay XSS.
5. Comprueba rotación de claves, `kid`, caché de JWKS y tolerancia de reloj.
6. Añade tests para token expirado, firma inválida, algoritmo cambiado y claims manipulados.

## Criterio de terminado
Cada token se valida con algoritmo y claims explícitos; hay revocación, rotación y tests de los casos hostiles.

## Errores comunes
- Decodificar sin verificar la firma.
- Aceptar el algoritmo que llega en el header.
- Guardar secretos de firma en el cliente.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP ASVS.
