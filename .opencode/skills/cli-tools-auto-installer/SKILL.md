---
name: CLI Tools Auto Installer
description: Use when a required binary is missing, when setting up a developer machine, or when writing a bootstrap script for a project.
metadata:
  opencode/autoinvoke: false
---

# CLI Tools Auto Installer

## Cuándo usarla
Al detectar `command not found`, al incorporar a alguien al proyecto, o al escribir un script de arranque.

## Procedimiento
1. Enumera las herramientas por rol: runtime, gestor de paquetes, base de datos, contenedores, linters, CLIs del cloud.
2. Por cada una anota: comando de comprobación, versión mínima, método de instalación por sistema operativo, y si es opcional.
3. Escribe un script **idempotente**: comprobar → instalar si falta → verificar versión.
4. Pregunta antes de instalar. No instales globalmente sin permiso.
5. Prefiere version managers (`asdf`, `mise`, `nvm`, `pyenv`) a instalaciones globales.
6. En Windows: `winget`; macOS: `brew`; Linux: gestor de la distro. Documenta los tres.
7. Falla con un mensaje que diga exactamente qué instalar y por qué.
8. Añade un modo `--check` que solo diagnostica y no modifica nada.

## Plantilla
```
for tool in git node docker; do
  command -v "$tool" >/dev/null || echo "FALTA: $tool"
done
```

## Criterio de terminado
El script se puede ejecutar dos veces sin efectos secundarios, informa de lo que falta con instrucciones, y una máquina limpia queda lista en una pasada.

## Errores comunes
- `sudo` silencioso.
- Instalar versiones sin fijar.
- Sobrescribir configuración del usuario.

## Fuente
Basada en `ComposioHQ/awesome-claude-skills` (79k★) y prácticas de bootstrap reproducible.
