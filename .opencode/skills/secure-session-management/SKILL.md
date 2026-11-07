---
name: Secure Session Management
description: Use when configuring cookies, session storage, logout, CSRF protection, or session fixation and rotation.
metadata:
  opencode/autoinvoke: false
---

# Secure Session Management

## Cuándo usarla
Al implementar login web, paneles, cookies de sesión o al revisar por qué un usuario sigue dentro después de cerrar sesión.

## Procedimiento
1. Usa cookies `HttpOnly`, `Secure` y `SameSite=Lax` o `Strict`; `None` solo si hay una razón y con `Secure`.
2. Rota el ID de sesión al autenticar y al elevar privilegios.
3. Define caducidad absoluta y por inactividad; invalida en servidor al cerrar sesión.
4. Protege contra CSRF con token sincronizado o `SameSite` + verificación de origen.
5. Guarda sesiones en servidor o en un almacén seguro; nunca en `localStorage` para tokens de larga vida.
6. Prueba fijación de sesión, robo de cookie, logout y expiración.

## Criterio de terminado
La cookie cumple los atributos, la sesión rota al entrar y al salir, y hay pruebas de fijación y CSRF.

## Errores comunes
- Cookie sin `HttpOnly`.
- Logout que solo borra el token del cliente.
- Sesión eterna.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP Session Management Cheat Sheet.
