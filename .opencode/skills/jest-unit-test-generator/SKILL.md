---
name: Jest Unit Test Generator
description: Use when writing unit tests with Jest or Vitest, creating mocks, testing async code, or raising coverage on untested modules.
metadata:
  opencode/autoinvoke: false
---

# Jest Unit Test Generator

## Cuándo usarla
Al cubrir un módulo nuevo, al añadir casos borde, o al refactorizar con red de seguridad.

## Estructura
```
describe('nombreDelModulo', () => {
  describe('cuando el input es válido', () => {
    it('devuelve la carta normalizada', () => { ... });
  });
  describe('cuando falta la foto', () => {
    it('lanza ValidationError con código PHOTO_REQUIRED', () => { ... });
  });
});
```

## Procedimiento
1. Lee el módulo y enumera sus salidas: valores, efectos, errores.
2. Cubre: camino feliz, límites (0, 1, máximo, negativo), tipos inválidos, errores de dependencias, y asincronía.
3. Aísla dependencias externas con `jest.mock` en el borde, no en el núcleo.
4. Para tiempo usa `jest.useFakeTimers()`; para aleatoriedad, inyecta una fuente.
5. Async: `await expect(fn()).rejects.toThrow(...)`; nunca dejes promesas sin resolver.
6. Snapshots solo para estructuras estables y pequeñas; nunca para HTML grande.
7. Comprueba la cobertura del módulo, no la global: busca ramas sin cubrir con `--coverage`.

## Higiene
- Un `expect` principal por test, con intención clara.
- Sin lógica en el test (`if`, bucles) salvo `it.each`.
- Sin dependencia de orden entre tests ni estado compartido mutable.
- Limpia mocks en `afterEach`.

## Criterio de terminado
Cada rama relevante tiene un test, los mocks son mínimos y nombrados, y la suite corre en menos de 10 s por módulo.

## Errores comunes
- Testear implementación en vez de comportamiento.
- Mockear el propio módulo bajo test.
- `toBeTruthy()` en lugar de una aserción concreta.

## Fuente
Basada en `obra/superpowers` (313k★) y la documentación de Jest/Vitest.
