---
name: Karpathy Clean Code
description: Use when code feels over-engineered, when deciding how much abstraction to add, or when reviewing AI-generated code for unnecessary cleverness.
metadata:
  opencode/autoinvoke: false
---

# Karpathy Clean Code

## Principios
- **Simplicidad primero.** La solución más aburrida que funciona es la correcta hasta que se demuestre lo contrario.
- **No abstraigas con un solo caso de uso.** La regla de tres: tres repeticiones antes de extraer.
- **Legibilidad sobre ingenio.** Si necesitas un comentario para explicar la línea, reescribe la línea.
- **Cambios pequeños y verificables.** Un commit que no puedes describir en una frase es demasiado grande.
- **Entiende antes de tocar.** Lee el código que rodea tu cambio; no asumas.
- **Errores explícitos.** Falla rápido y con contexto, no devuelvas `null` silencioso.
- **Sin código muerto.** Si no se usa, se borra. El control de versiones ya lo guarda.

## Procedimiento de revisión
1. Lee el diff completo antes de opinar.
2. Marca: ¿qué se puede borrar?, ¿qué se puede simplificar?, ¿qué está duplicado?
3. Comprueba nombres: ¿dicen lo que hacen?
4. Comprueba el manejo de errores en cada borde.
5. Comprueba que el cambio no introduce estado global ni efectos ocultos.
6. Propón el diff mínimo; no reescribas el archivo entero.

## Señales de alarma
- Función de 120 líneas con 5 niveles de anidación.
- Interfaz con una sola implementación y sin plan de otra.
- `try/catch` que se traga el error.
- Configuración para casos que no existen.
- Comentarios que repiten lo que dice el código.

## Criterio de terminado
El código se entiende sin explicación externa, no hay abstracciones con un solo uso, y el diff es lo más pequeño posible.

## Fuente
Basada en `multica-ai/andrej-karpathy-skills` (230k★), derivada de las observaciones de Karpathy sobre fallos de LLM al programar.
