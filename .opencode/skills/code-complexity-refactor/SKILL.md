---
name: Code Complexity Refactor
description: Use when a function is too long or deeply nested, when cyclomatic complexity is high, or when a module is hard to test.
metadata:
  opencode/autoinvoke: false
---

# Code Complexity Refactor

## Cuándo usarla
Funciones de más de 40 líneas, más de 3 niveles de anidación, o más de 10 ramas. También cuando cuesta escribir un test.

## Diagnóstico
- Mide: `eslint complexity`, `radon cc`, `gocyclo`, `phpmetrics`. Objetivo: complejidad ciclomática ≤ 10 por función.
- Cuenta los motivos por los que una función cambia. Si son varios, tiene varias responsabilidades.

## Técnicas, en orden de preferencia
1. **Guard clauses**: invierte las condiciones y sal pronto. Elimina el `else`.
2. **Extraer función**: nombra el bloque por lo que hace. Si el nombre es malo, el bloque está mal delimitado.
3. **Tabla de decisión**: sustituye cadenas de `if/else` o `switch` por un mapa de datos → comportamiento.
4. **Objeto de parámetros**: 4+ parámetros sueltos pasan a un objeto con nombres.
5. **Early return de errores**: valida al principio y olvídate.
6. **Polimorfismo** solo si hay variantes reales que crecen.

## Procedimiento seguro
1. Asegura tests que cubran el comportamiento actual. Si no existen, escríbelos primero.
2. Refactoriza en pasos pequeños, ejecutando tests tras cada uno.
3. No cambies comportamiento y estructura en el mismo paso.
4. Compara el diff: si es enorme, divide.

## Criterio de terminado
Cada función tiene una responsabilidad, complejidad ≤ 10, anidación ≤ 3, y los tests siguen verdes sin haber cambiado.

## Errores comunes
- Trocear en 15 funciones de 3 líneas sin nombres útiles.
- Refactorizar y arreglar un bug a la vez.
- Introducir una abstracción nueva para un solo uso.

## Fuente
Basada en `multica-ai/andrej-karpathy-skills` (230k★) y *Refactoring* de Martin Fowler.
