---
name: FastAPI Async Worker
description: Use when building async FastAPI endpoints, background tasks, or long-running jobs and worrying about blocking the event loop.
metadata:
  opencode/autoinvoke: false
---

# FastAPI Async Worker

## Cuándo usarla
Al crear endpoints en Python con FastAPI, al añadir tareas en segundo plano, o al depurar lentitud bajo concurrencia.

## Reglas
- `async def` solo si el cuerpo usa `await` de librerías asíncronas. Si llamas a una librería bloqueante, usa `def` (FastAPI lo ejecuta en threadpool) o `run_in_threadpool`.
- Nunca bloquees el event loop: nada de `requests`, `time.sleep`, `psycopg2` síncrono, o I/O de disco pesado dentro de `async def`.
- Cliente HTTP: `httpx.AsyncClient` reutilizado, con timeouts explícitos.
- Base de datos: driver async (`asyncpg`, `SQLAlchemy 2 async`) y pool dimensionado.
- Tareas de fondo cortas: `BackgroundTasks`. Tareas largas o que deben sobrevivir al proceso: cola real (Celery, RQ, Arq).

## Procedimiento
1. Separa capas: router (validación) → servicio (lógica) → repositorio (datos).
2. Declara modelos Pydantic con `response_model` y campos estrictos.
3. Añade timeout y cancelación a toda llamada externa.
4. Para jobs largos: encola, devuelve `202` con id de tarea y endpoint de estado.
5. Prueba con `httpx.AsyncClient` y con carga concurrente (locust/k6) para detectar bloqueos.
6. Mide el event loop con `asyncio` debug y logs de latencia por fase.

## Criterio de terminado
Bajo 100 peticiones concurrentes la latencia p95 se mantiene estable, ninguna llamada bloqueante corre en el loop, y los jobs largos no viven dentro del request.

## Errores comunes
- `async def` con `requests.get`.
- Compartir una sesión de base de datos entre requests.
- `BackgroundTasks` para un proceso de 10 minutos.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y la documentación oficial de FastAPI.
