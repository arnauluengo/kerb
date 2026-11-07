---
name: AGENTS.md Orchestrator
description: Use when creating or maintaining AGENTS.md, coordinating subagents in OpenCode, or documenting project conventions for agents.
metadata:
  opencode/autoinvoke: false
---

# AGENTS.md Orchestrator

## Cuándo usarla
Al iniciar un proyecto, al añadir un subagente, o cuando un agente repite errores que deberían estar documentados.

## Qué va en AGENTS.md
1. **Comandos**: instalar, test, lint, build, ejecutar. Copiables tal cual.
2. **Arquitectura en 10 líneas**: capas, carpetas, dónde va cada cosa.
3. **Convenciones no obvias**: nombres, patrones, librerías preferidas y prohibidas.
4. **Límites**: qué no tocar sin permiso, qué nunca commitear.
5. **Cómo verificar**: el comando exacto que demuestra que algo funciona.
6. **Delegación**: qué tareas van a subagente y con qué contexto.

## Qué NO va
- Historia del proyecto ni decisiones obsoletas.
- Listas de archivos (envejecen mal).
- Reglas que el linter ya impone.
- Más de 200 líneas: nadie lo lee entero.

## Procedimiento
1. Audita el repo: scripts, configuración, estructura, tests existentes.
2. Escribe secciones cortas con encabezados accionables.
3. Prueba cada comando antes de documentarlo.
4. Cuando aparezca un error repetido, añade la regla que lo previene.
5. Revisa el archivo cuando cambie la arquitectura; borra lo obsoleto.

## Criterio de terminado
Un agente nuevo puede clonar, ejecutar la suite y hacer un cambio correcto sin preguntar nada.

## Errores comunes
- Copiar una plantilla genérica sin adaptarla.
- Documentar comandos que no funcionan.
- Convertirlo en un ensayo.

## Fuente
Basada en `anthropics/skills` (188k★) y la guía de OpenCode para AGENTS.md.
