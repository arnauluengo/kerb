---
name: Cypress E2E Automation
description: Use when writing end-to-end browser tests, testing real user flows, or fixing flaky Cypress/Playwright suites.
metadata:
  opencode/autoinvoke: false
---

# Cypress E2E Automation

## Cuándo usarla
Para flujos críticos de usuario: registro, login, crear una carta, escanear, pagar un cosmético. No para cada detalle.

## Procedimiento
1. Elige 5–10 flujos de negocio que, si se rompen, rompen el producto.
2. Prepara estado con API o seeds, no navegando por la UI para llegar al punto de partida.
3. Escribe selectores estables: `data-testid` o roles accesibles. Nunca clases CSS ni rutas de `div > div`.
4. Un test = un recorrido con una intención. Evita tests de 40 pasos.
5. Espera por condición (`cy.intercept` + `cy.wait('@alias')`), nunca `cy.wait(3000)`.
6. Aísla datos por test; cada test crea lo que necesita y lo limpia.
7. Captura de red y errores de consola: falla el test si hay `console.error` o 5xx inesperado.
8. Grabación de vídeo y screenshots solo en fallo, para depurar.

## Contra el flakiness
- Nada de dependencias entre tests.
- Nada de esperas fijas.
- Datos deterministas (fechas, ids, nombres).
- Reintentos configurados solo para el CI, y con alerta si un test necesita reintentos.

## Criterio de terminado
La suite pasa 10 veces seguidas en local y en CI sin reintentos, y un fallo indica un problema real del producto.

## Errores comunes
- Testear la implementación de la UI (clases, estructura).
- Usar la UI para preparar el estado.
- Tests que dependen del orden de ejecución.

## Fuente
Basada en `ComposioHQ/awesome-claude-skills` (79k★) y las buenas prácticas de Cypress/Playwright.
