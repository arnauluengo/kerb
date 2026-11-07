---
name: DOCX README Generator
description: Use when converting specs, notes, or Word documents into clean Markdown documentation, or when writing a README that actually helps.
metadata:
  opencode/autoinvoke: false
---

# DOCX README Generator

## Cuándo usarla
Al documentar un proyecto, al convertir un `.docx` a Markdown, o cuando el README existente no permite empezar.

## Estructura de README
1. **Qué es** — una frase.
2. **Por qué existe** — el problema que resuelve.
3. **Requisitos** — versión de runtime, dependencias del sistema.
4. **Instalación** — comandos copiables, en orden.
5. **Ejecución** — cómo arrancar en local.
6. **Tests** — comando y qué cubren.
7. **Estructura** — solo las carpetas que importan.
8. **Configuración** — variables de entorno con valor de ejemplo, nunca reales.
9. **Estado** — qué funciona, qué no, qué viene.
10. **Licencia**.

## Conversión desde DOCX
1. Extrae el texto con estructura (`pandoc -t markdown`, o el skill de docx de `anthropics/skills`).
2. Reconstruye: títulos, listas, tablas y bloques de código.
3. Elimina formato de Word: negritas decorativas, colores, índices manuales.
4. Verifica enlaces y rutas de archivo.
5. Añade numeración a los pasos que dependen del orden.

## Reglas
- Comandos en bloques de código con el lenguaje.
- Sin capturas que caduquen; si hacen falta, imágenes versionadas.
- Sin marketing: enlace a la web si existe.
- Un README no repite los comentarios del código.

## Criterio de terminado
Alguien que no conoce el repo lo clona, ejecuta dos comandos y ve la app funcionando, sin preguntar nada.

## Errores comunes
- Instrucciones sin versión de runtime.
- Variables de entorno con valores reales.
- Secciones "TODO" que nunca se completan.

## Fuente
Basada en `anthropics/skills` (188k★) y `writing-for-agents`.
