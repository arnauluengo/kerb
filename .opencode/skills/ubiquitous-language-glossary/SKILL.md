---
name: Ubiquitous Language Glossary
description: Use when starting a new codebase, when the same concept has multiple names, or before naming models, tables, and API fields.
metadata:
  opencode/autoinvoke: false
---

# Ubiquitous Language Glossary

## Cuándo usarla
Al empezar un proyecto, al detectar que "coche", "vehículo", "car" y "vehicle" conviven en el código, o antes de diseñar la base de datos.

## Procedimiento
1. Recoge términos de: conversaciones con el usuario, documentos, UI, nombres de tablas y de clases.
2. Detectar sinónimos y homónimos. Cada concepto tiene **un** nombre y un significado.
3. Por cada término define:
   - Nombre canónico (en el idioma que use el dominio).
   - Definición en una frase.
   - Qué **no** es (para evitar solapamientos).
   - Dónde aparece: modelo, tabla, endpoint, UI.
   - Ejemplo y contraejemplo.
4. Marca los términos del dominio frente a los técnicos genéricos.
5. Documenta las relaciones entre términos (un `Coche` tiene varias `Foto`, cada `Coche` pertenece a una `Generación`).
6. Añade el glosario al repo (`GLOSSARY.md`) y enlázalo desde AGENTS.md.
7. Cuando el nombre canónico cambie, renómbralo en código y datos en el mismo cambio.

## Criterio de terminado
Existe una única palabra por concepto en código, base de datos, API y UI; un recién llegado entiende el dominio leyendo el glosario.

## Errores comunes
- Glosario solo de negocio, desconectado del código.
- Definiciones circulares.
- Dejar sinónimos "por compatibilidad" indefinidamente.

## Fuente
Basada en `obra/superpowers` (313k★), `domain-modeling`, y Domain-Driven Design.
