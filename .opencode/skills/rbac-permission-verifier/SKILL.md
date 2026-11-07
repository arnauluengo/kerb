---
name: RBAC Permission Verifier
description: Use when reviewing role-based access control, permission matrices, tenant isolation, admin endpoints, or authorization bypass risk.
metadata:
  opencode/autoinvoke: false
---

# RBAC Permission Verifier

## Cuándo usarla
Al añadir roles, paneles de administración, equipos, multi-tenant o cualquier recurso que no deba ver todo el mundo.

## Procedimiento
1. Enumera sujetos (anónimo, usuario, admin, servicio) y recursos (propio, de otro, global).
2. Construye la matriz rol × acción × recurso y marca cada celda allow/deny.
3. Verifica que la autorización se aplique en el servidor, no solo en la UI.
4. Prueba el acceso directo por ID (IDOR), el cambio de tenant y la escalada de rol.
5. Comprueba que los listados filtren por propietario y que los errores no revelen existencia.
6. Documenta la matriz y añade tests de denegación.

## Criterio de terminado
Cada celda de la matriz tiene una prueba; ningún usuario puede leer o modificar un recurso ajeno cambiando un ID.

## Errores comunes
- Ocultar el botón y dejar el endpoint abierto.
- Comprobar el rol en el cliente.
- Olvidar el tenant en las consultas.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP ASVS (control de acceso).
