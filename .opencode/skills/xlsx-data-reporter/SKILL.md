---
name: XLSX Data Reporter
description: Use when generating spreadsheet reports, analyzing data in Excel files, or exporting system data to XLSX with formulas and formatting.
metadata:
  opencode/autoinvoke: false
---

# XLSX Data Reporter

## Cuándo usarla
Cuando hay que entregar datos a alguien no técnico, comparar periodos, o analizar un Excel que aporta el usuario.

## Procedimiento
1. Define la pregunta: qué decisión se toma con esta hoja. Cada pestaña responde a una.
2. Estructura: `Datos` (crudo, una fila por registro, sin celdas combinadas), `Resumen`, `Gráficos`.
3. Cabecera en la fila 1, tipos consistentes, fechas en formato ISO, números sin texto.
4. Separa datos de presentación: los cálculos en columnas/fórmulas, el formato en estilos.
5. Fórmulas en vez de valores calculados a mano cuando el usuario vaya a editar.
6. Formatos: miles, dos decimales para dinero, anchos de columna legibles, fila congelada.
7. Gráficos solo si aclaran; máximo 2 por hoja.
8. Añade una hoja `Notas` con fuente, fecha de extracción y definiciones.

## Análisis de un Excel existente
1. Lee todas las hojas y documenta columnas, tipos y filas.
2. Detecta huecos, duplicados, fechas como texto y totales mezclados con datos.
3. Limpia en una hoja aparte; nunca sobrescribas el original.
4. Reporta los problemas encontrados antes de sacar conclusiones.

## Criterio de terminado
El archivo se abre sin avisos, los totales cuadran con la fuente, y alguien sin contexto entiende qué mirar.

## Errores comunes
- Celdas combinadas en los datos.
- Números guardados como texto.
- Gráficos sin ejes ni unidades.

## Fuente
Basada en `anthropics/skills` (188k★), skill de XLSX.
