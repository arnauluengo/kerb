---
name: Microservices Event Driven
description: Use when designing asynchronous messaging between services, choosing between queues and event streams, or fixing duplicate and out-of-order message handling.
metadata:
  opencode/autoinvoke: false
---

# Microservices Event Driven

## Cuándo usarla
Al separar servicios, al añadir procesamiento asíncrono, o al depurar mensajes perdidos o duplicados.

## Decisión primero
- **Comando** (haz esto): cola de trabajo, un consumidor, RabbitMQ/SQS. Si falla, reintentar.
- **Evento** (esto pasó): stream de eventos, varios consumidores, Kafka/Redis Streams. Si falla, se puede reproducir.
No uses eventos para pedir acciones ni comandos para notificar hechos.

## Procedimiento
1. Nombra eventos en pasado y dominio: `CarScanned`, `CardCreated`, `PhotoUploaded`.
2. Define el contrato del mensaje: `eventId`, `type`, `version`, `occurredAt`, `correlationId`, `payload`.
3. Idempotencia obligatoria en el consumidor: guarda `eventId` procesados, o haz la operación naturalmente idempotente.
4. Orden: si importa, usa clave de partición (p. ej. `carId`) y procesa en serie por clave. Si no, diseña para desorden.
5. Entrega: asume al menos una vez. Nunca exactamente una sin transacciones distribuidas.
6. Reintentos con backoff exponencial y **dead letter queue** con alerta. Nada de reintentar para siempre.
7. Outbox pattern para publicar de forma fiable junto a la transacción de base de datos.
8. Trazabilidad: propaga `correlationId` y registra el ciclo de vida del mensaje.
9. Versiona eventos; los consumidores ignoran campos desconocidos.

## Criterio de terminado
Un mensaje duplicado no produce efecto doble, un fallo acaba en DLQ con alerta, y se puede reconstruir el estado reproduciendo eventos.

## Errores comunes
- Consumidor no idempotente.
- Reintentos infinitos que bloquean la cola.
- Cambiar el esquema del evento sin versionar.
- Usar Kafka como base de datos.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y patrones de mensajería (outbox, DLQ, saga).
