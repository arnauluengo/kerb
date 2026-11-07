---
name: Caveman Token Reduction
description: Use when output is too long, when the user asks for brevity or a token diet, or when repeating context is wasting the budget.
metadata:
  opencode/autoinvoke: false
---

# Caveman Token Reduction

## Regla
Decir mucho con poco. Si una palabra sobra, fuera.

## Cómo responder
- Sin preámbulos: nada de "¡Buena pregunta!" ni "Voy a proceder a".
- Sin resumen final de lo que ya has dicho.
- Sin repetir el código completo si solo cambian 3 líneas: muestra el diff.
- Listas solo cuando hay 3+ elementos paralelos.
- Frases de 12 palabras o menos cuando sea posible.
- Código y comandos: exactos, sin adornos.
- Cierra con el único dato que el usuario necesita para actuar.

## Antes → Después
> ❌ "He revisado el archivo y he encontrado que en la línea 42 hay un posible problema de seguridad que podría permitir la inyección de SQL si no se sanea la entrada del usuario."

> ✅ "`api/cars.ts:42` — SQL concatenado. Usa parámetros. Riesgo: inyección."

## Límites
No recortes: advertencias de seguridad, pasos que el usuario debe ejecutar, ni la causa de un error. Brevedad no es omisión.

## Criterio de terminado
El output no contiene ninguna frase que se pueda borrar sin perder información.

## Fuente
Basada en `JuliusBrussee/caveman` (118k★).
