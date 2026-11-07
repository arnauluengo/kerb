---
name: TDD Superpowers
description: Use when implementing any feature or bugfix test-first, when the user says red-green-refactor, or when a change needs a failing test before code.
metadata:
  opencode/autoinvoke: false
---

# TDD Superpowers

## Cuándo usarla
Siempre que se escriba lógica nueva o se arregle un bug. No es opcional para código de producción.

## El ciclo
1. **RED** — Escribe un test que falle por la razón correcta. Ejecútalo y lee el fallo. Si pasa a la primera, el test no prueba nada nuevo.
2. **GREEN** — Escribe el código mínimo que hace pasar ese test. Nada de generalizar por adelantado.
3. **REFACTOR** — Limpia duplicación y nombres con los tests en verde. Vuelve a ejecutarlos.

## Reglas
- Un test a la vez. Un comportamiento por test.
- El nombre del test describe el comportamiento, no el método: `devuelve 404 si la carta no existe`.
- Testea el comportamiento observable, no la implementación. Si renombras una función privada, el test no debe romperse.
- Los tests deben ser rápidos, deterministas y aislados. Sin red, sin reloj real, sin orden entre tests.
- Mocks solo en los bordes (I/O, tiempo, terceros). No mockees lo que estás probando.
- Un bug se arregla escribiendo primero el test que lo reproduce.

## Procedimiento
1. Enumera los casos: camino feliz, bordes, errores, permisos.
2. Escribe el primero y ejecútalo para verlo fallar.
3. Implementa lo mínimo.
4. Repite hasta cubrir los casos.
5. Refactoriza y ejecuta la suite completa.

## Criterio de terminado
Existe un test que falla sin el cambio y pasa con él; la suite completa está en verde; no hay tests comentados ni `skip`.

## Errores comunes
- Escribir el código y luego "los tests".
- Tests que afirman sobre detalles internos.
- Test que pasa aunque se rompa la lógica (aserción vacía o `expect(true)`).

## Fuente
Basada en `obra/superpowers` (313k★), skill `test-driven-development`.
