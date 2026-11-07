---
name: SaaS Tool Connector
description: Use when integrating an external SaaS API (Slack, Notion, Linear, GitHub, Jira, Google), choosing an integration approach, or automating a workflow across tools.
metadata:
  opencode/autoinvoke: false
---

# SaaS Tool Connector

## Cuándo usarla
Cuando hay que conectar la app con un servicio externo, automatizar un flujo entre herramientas, o diseñar una integración de terceros.

## Decisión primero
| Necesidad | Enfoque |
|---|---|
| Leer o escribir datos puntualmente | Llamada directa a la API REST del servicio |
| Automatizar flujos entre apps | Orquestador (Composio, n8n, Zapier) |
| Eventos en tiempo real | Webhooks entrantes |
| Acceso de usuario a su cuenta | OAuth 2.0 con PKCE |

## Procedimiento
1. Lee la documentación oficial del servicio: autenticación, límites de tasa, paginación, webhooks.
2. Define el contrato interno: qué datos entran, qué salen, qué pasa si falla.
3. Gestiona credenciales fuera del código (secret manager). Nunca en el repo.
4. Implementa adaptador aislado: `integrations/<servicio>.ts` con una interfaz propia. El resto del código no importa el SDK.
5. Maneja: timeout, 429 con `Retry-After`, 5xx con backoff, y errores de negocio diferenciados.
6. Idempotencia en escrituras: clave de idempotencia o comprobación previa.
7. Webhooks: verifica firma, responde 2xx rápido y procesa en cola.
8. Registra cada llamada con correlación y métrica de latencia.
9. Escribe tests contra un mock del contrato (MSW, nock), no contra el servicio real.

## Criterio de terminado
El servicio externo se puede caer sin tumbar la app, las credenciales están fuera del código, y la integración tiene tests de fallo.

## Errores comunes
- Llamar al SDK desde toda la base de código.
- Ignorar los límites de tasa y recibir 429 en cascada.
- No verificar la firma de los webhooks.

## Fuente
Basada en `ComposioHQ/awesome-claude-skills` (79k★) y el modelo de integraciones de Composio.
