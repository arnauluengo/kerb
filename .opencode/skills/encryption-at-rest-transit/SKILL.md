---
name: Encryption at Rest and in Transit
description: Use when reviewing password hashing, secrets storage, TLS configuration, encryption at rest, or key management.
metadata:
  opencode/autoinvoke: false
---

# Encryption at Rest and in Transit

## Cuándo usarla
Al guardar contraseñas, tokens, datos personales o ficheros; al configurar HTTPS, bases de datos o backups.

## Procedimiento
1. Contraseñas: `argon2id` (preferido) o `bcrypt` con coste adecuado; nunca SHA-256 simple ni cifrado reversible.
2. Secretos de aplicación: gestor de secretos o variables de entorno; no en el repo ni en la base de datos en claro.
3. Tránsito: TLS 1.2+ (ideal 1.3), HSTS, certificados válidos y redirección desde HTTP.
4. Reposo: cifrado del volumen, backups cifrados y claves separadas de los datos.
5. Rotación de claves y separación por entorno; documenta quién puede descifrar.
6. Verifica con `openssl s_client`, `testssl.sh` y una prueba de que un hash no se puede revertir.

## Criterio de terminado
Contraseñas con hash fuerte, TLS moderno, backups cifrados y claves fuera del código.

## Errores comunes
- Guardar contraseñas con SHA/MD5.
- Cifrar con una clave hardcodeada.
- Confundir hash con cifrado.

## Fuente
Basada en `trailofbits/skills` (8.0k★) y OWASP Cryptographic Storage Cheat Sheet.
