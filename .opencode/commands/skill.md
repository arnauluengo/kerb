---
description: Carga una skill del catálogo (.opencode/skills) y la aplica a la tarea indicada
---

Carga la skill indicada con la herramienta `skill` y aplícala a la tarea.

Entrada recibida:

$ARGUMENTS

Pasos obligatorios:

1. Si la entrada está vacía, lee `.opencode/skills/README.md` y muestra el índice agrupado por bloques, con el identificador entre backticks. Detente ahí.
2. Toma la **primera palabra** de la entrada como identificador de la skill. Todo lo que venga después es la tarea.
3. Comprueba que existe `.opencode/skills/<id>/SKILL.md`. Si no existe, lista los identificadores válidos del README y detente.
4. Carga la skill con la herramienta `skill` usando ese identificador.
5. Ejecuta su procedimiento sobre la tarea. Si no hay tarea, pregunta qué hay que hacer.
6. No des el trabajo por terminado hasta cumplir el apartado "Criterio de terminado" de la skill.
