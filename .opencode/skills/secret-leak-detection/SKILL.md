---
name: Secret Leak Detection
description: Use when scanning a repository, diff, logs, or CI output for exposed API keys, tokens, passwords, private keys, or credentials before commit or release.
metadata:
  opencode/autoinvoke: false
---

# Secret Leak Detection

## Cuándo usarla
Antes de cada commit, al revisar un repo heredado, al publicar un repo público y al investigar una filtración.

## Procedimiento
1. Escanea el árbol y el historial: `gitleaks detect --source . --redact`, `trufflehog filesystem . --only-verified`.
2. Revisa también `.env`, `.env.*`, `docker-compose`, CI, logs, tests y fixtures.
3. Comprueba el historial (`git log -p --all`) si el secreto pudo estar commiteado antes.
4. Si hay un secreto real: revócalo primero, rota la credencial y limpia el historial con `git filter-repo`.
5. Añade el patrón a `.gitignore`, al pre-commit hook y a la documentación de variables de entorno.

## Criterio de terminado
No queda ningún secreto vivo en el árbol ni en el historial; la credencial está rotada y el escaneo pasa en CI.

## Errores comunes
- Borrar el archivo y dejarlo en el historial.
- Añadir el secreto a `.gitignore` después de haberlo commiteado.
- Pegar el secreto en un issue, chat o log de CI.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y prácticas de `gitleaks`/`trufflehog`.
