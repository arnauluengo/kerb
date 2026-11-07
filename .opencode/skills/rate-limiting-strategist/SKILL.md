---
name: Rate Limiting Strategist
description: Use when designing or reviewing rate limits, quotas, throttling, brute-force protection, or DoS resilience for APIs and auth endpoints.
metadata:
  opencode/autoinvoke: false
---

# Rate Limiting Strategist

## Cuándo usarla
Antes de exponer login, registro, recuperación de contraseña, búsqueda, IA o cualquier endpoint caro.

## Procedimiento
1. Clasifica endpoints por coste y riesgo: auth, escritura, lectura, IA, uploads.
2. Elige la clave del límite: IP, usuario, token, tenant o combinación; evita bloquear a todos por culpa de uno.
3. Define ventanas y algoritmos: token bucket para ráfagas, sliding window para abuso sostenido.
4. Añade límites por cuenta y por IP en auth; usa backoff exponencial y `Retry-After`.
5. Devuelve `429` con mensaje claro y sin filtrar si la cuenta existe.
6. Mide, alerta y documenta los umbrales; prueba con carga y con ráfagas.

## Criterio de terminado
Cada endpoint sensible tiene límite, respuesta 429 y una prueba que demuestra que el abuso se frena sin afectar al uso normal.

## Errores comunes
- Limitar solo por IP detrás de un proxy.
- Olvidar el coste de la IA o de las consultas pesadas.
- Bloquear para siempre en vez de aplicar ventanas.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP ASVS.
