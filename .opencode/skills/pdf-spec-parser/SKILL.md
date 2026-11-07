---
name: PDF Spec Parser
description: Use when extracting requirements from a PDF, technical spec, contract, or research paper into structured, actionable notes.
metadata:
  opencode/autoinvoke: false
---

# PDF Spec Parser

## Cuándo usarla
Cuando el usuario aporta un PDF con requisitos, un pliego, un manual o un paper y hay que convertirlo en trabajo ejecutable.

## Procedimiento
1. Extrae el texto conservando estructura: `pdftotext -layout`, o el parser del skill de documentos de `anthropics/skills`. Si el PDF es escaneado, OCR primero.
2. Construye un índice con números de página para poder citar.
3. Separa por tipo: requisito funcional, requisito no funcional, restricción, decisión tomada, pregunta abierta.
4. Por cada requisito: id, texto literal, página, interpretación, criterio de aceptación.
5. Marca ambigüedades y contradicciones en una sección aparte. No las resuelvas tú: pregunta.
6. Detecta dependencias entre requisitos y agrupa en bloques implementables.
7. Guarda el resultado en Markdown versionado, con enlace a la fuente y fecha.

## Formato de salida
```markdown
## RF-01 — Escaneo de coche
- Fuente: p. 12
- Requisito: "La app debe identificar el coche a partir de una foto"
- Criterio: 3 candidatas en < 5 s; si falla, entrada manual
- Depende de: RF-03 (catálogo)
```

## Criterio de terminado
Cada requisito es verificable, cita su página, y no queda ninguna ambigüedad sin listar como pregunta abierta.

## Errores comunes
- Resumir el PDF en lugar de extraer requisitos.
- Inventar criterios que el documento no dice.
- Perder la trazabilidad a la fuente.

## Fuente
Basada en `anthropics/skills` (188k★), skills de documentos (pdf/docx/xlsx/pptx).
