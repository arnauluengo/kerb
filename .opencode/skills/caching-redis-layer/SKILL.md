---
name: Caching Redis Layer
description: Use when adding Redis caching, fixing stale data bugs, designing cache invalidation, or reducing database load.
metadata:
  opencode/autoinvoke: false
---

# Caching Redis Layer

## Cuándo usarla
Cuando la base de datos es el cuello de botella, al añadir caché, o al depurar datos obsoletos.

## Procedimiento
1. Justifica: mide la query y su frecuencia. Si no es lenta ni frecuente, no la caches.
2. Diseña la clave con jerarquía y versión: `v1:user:{id}:garage`, `v1:car:{id}:card`. Prefijo de versión para invalidar en bloque.
3. Elige estrategia:
   - Cache-aside (leer → si falta, consultar → escribir con TTL): la opción por defecto.
   - Write-through si la consistencia importa y la escritura no es crítica.
   - Write-behind solo si puedes tolerar pérdida.
4. TTL siempre. Sin TTL, el dato se queda para siempre. Añade jitter para evitar expiraciones simultáneas.
5. Invalida al escribir, no al leer. Conoce qué claves dependen de qué entidad.
6. Cachea negativos (no existe) con TTL corto para evitar penetración.
7. Protege contra estampida: lock por clave o `stale-while-revalidate`.
8. Observa `hit rate`, latencia de Redis y memoria. Configura `maxmemory-policy allkeys-lru`.
9. Serializa con JSON o MessagePack; documenta el esquema y su versión.

## Criterio de terminado
Hit rate medible, ninguna lectura devuelve datos que la escritura acaba de cambiar, y Redis caído no tumba la app (degradación a base de datos).

## Errores comunes
- Cachear sin TTL.
- Cachear datos personalizados con la misma clave para todos.
- Invalidar a mano y olvidar una ruta.
- Usar Redis como base de datos principal sin persistencia.

## Fuente
Basada en `alirezarezvani/claude-skills` (29k★) y los patrones de caché distribuida.
