---
name: Node.js Event Loop Safety
description: Use when auditing Node.js or TypeScript backends for blocking code, memory leaks, stream handling, or event loop starvation.
metadata:
  opencode/autoinvoke: false
---

# Node.js Event Loop Safety

## Cuándo usarla
Cuando un servicio Node va lento, consume CPU sin tráfico, acumula memoria, o al revisar código que procesa ficheros y datos grandes.

## Señales de bloqueo
- Bucles `for` sobre arrays de miles de elementos dentro de un handler.
- `JSON.parse`/`JSON.stringify` de payloads enormes.
- `fs.readFileSync`, `crypto` síncrono, `bcrypt` síncrono, `zlib` síncrono.
- Regex catastróficas (`(a+)+$`).
- `await` dentro de un bucle que podría ser `Promise.all`.
- Cálculo pesado (imágenes, PDF, vídeo) en el proceso principal.

## Procedimiento
1. Mide el lag del loop: `perf_hooks.monitorEventLoopDelay()` o `--prof` + `clinic doctor`.
2. Localiza el tramo bloqueante con el flame graph; identifica la función concreta.
3. Mueve el trabajo pesado a `worker_threads`, a un proceso aparte o a una cola.
4. Sustituye APIs síncronas por sus versiones `async`; para CPU usa el thread pool.
5. Paraleliza I/O con `Promise.all`/`allSettled`, con límite de concurrencia (`p-limit`).
6. Streams: usa `pipeline()` con backpressure, nunca acumules un fichero entero en memoria.
7. Revisa fugas: listeners que no se quitan, timers sin `clear`, cachés sin límite.
8. Verifica con carga sostenida y observa RSS y lag del loop.

## Criterio de terminado
El lag p99 del event loop se mantiene bajo decenas de ms con carga real, la memoria es estable durante una hora, y ningún handler hace trabajo síncrono pesado.

## Errores comunes
- Añadir `await` secuencial en un bucle de 500 elementos.
- `readFileSync` en un endpoint.
- Caché en `Map` global sin política de expulsión.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y la guía de Node.js sobre el event loop.
