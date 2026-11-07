---
name: SAST Security Scan
description: Use when reviewing source code for OWASP Top 10 flaws, injection sinks, auth bypasses, unsafe deserialization, or pre-merge security risk.
metadata:
  opencode/autoinvoke: false
---

# SAST Security Scan

## Cuándo usarla
Antes de un merge, release o auditoría; cuando se tocan auth, pagos, uploads, SQL, plantillas o deserialización.

## Procedimiento
1. Identifica el stack, los puntos de entrada (HTTP, CLI, colas, uploads) y los límites de confianza.
2. Ejecuta el escáner disponible: `semgrep --config auto`, `bandit -r .`, `gosec ./...`, `npm audit`, `trivy fs .`.
3. Revisa a mano los sinks peligrosos: SQL concatenado, `eval`, `exec`, `innerHTML`, `pickle`, `yaml.load`, `deserialize`, `path.join` con input.
4. Clasifica cada hallazgo por severidad y explotabilidad; descarta falsos positivos con evidencia.
5. Propón el parche mínimo y un test que reproduzca el fallo.

## Criterio de terminado
Cada hallazgo tiene archivo:línea, severidad, prueba de explotación o razón de descarte, y parche propuesto.

## Errores comunes
- Pegar la salida del escáner sin triage.
- Arreglar el síntoma y no la causa.
- Olvidar dependencias, secretos y configuración de infraestructura.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP Top 10 / ASVS.
