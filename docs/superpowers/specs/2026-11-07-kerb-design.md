# Kerb — Documento de diseño

**Fecha:** 2026-11-07
**Estado:** pendiente de aprobación del propietario
**Sustituye a:** `2026-11-06-paddock-design.md`
**Autor:** Arnau (producto) + agente (técnico)

---

## 1. Qué es Kerb

Kerb es una app Android de caza y colección de coches especiales. Ves un deportivo, un exótico o un clásico por la calle, le haces una foto con la cámara, la app te propone tres candidatas, tú confirmas, y esa foto se convierte en una carta de tu garaje. Una carta por modelo **y generación**. Dentro de la carta viven todas las fotos que hayas hecho de ese coche.

Tiene capa social —feed, amigos, leaderboards— pero la colección es tuya y se ve primero.

**Repo:** `https://github.com/arnauluengo/kerb`
**Package:** `app.kerb.mobile`
**Distribución v1:** APK en GitHub Releases.

---

## 2. Qué cambia respecto a Paddock

| Antes (Paddock) | Ahora (Kerb) |
|---|---|
| Cualquier coche, incluidos comunes | Solo deportivos, exóticos y clásicos. Nunca coches comunes |
| Invitado sin cuenta | Cuenta obligatoria desde el inicio |
| Renders de catálogo generados | **Cero renders.** La carta se construye con tu foto |
| Rareza: común → legendario (6) | Poco común → legendario (6, sin `common`) |
| Solo garaje local | Garaje, feed, amigos, leaderboards |
| Donaciones | Donaciones + cosméticos de pago |
| Ubicación a 500 m | Exacta para el dueño, 200 m para el resto |
| Nombre Paddock | Nombre Kerb |

---

## 3. Marca

**Paleta**

| Rol | Hex |
|---|---|
| Navy (fondo de app, cabeceras) | `#14233B` |
| Cream (texto principal) | `#EDE6D6` |
| Asphalt (tarjetas, superficies) | `#1A1B1E` |
| Brick (acento, acciones) | `#C2402A` |
| Texto secundario | `#8C93A3` |
| Éxito / valor | `#4ADE80` |

**Logo:** solo el coche, sin wordmark. Vectorial, dibujado a mano en SVG. Se usa en el icono de la app, splash y cabeceras. El nombre "Kerb" se compone con tipografía, nunca dentro del logo.

**Tipografía:** el modelo de la carta va en una condensada. El logo no lleva texto. Los datos numéricos en monoespaciada. El resto, una sans neutra. Candidatas: `Barlow Condensed`, `Archivo Narrow`, `JetBrains Mono`.

**Tema:** solo oscuro. No hay modo claro y no habrá toggle vacío.

---

## 4. Objetivos

1. Que abrir la app y cazar un coche tarde menos de 20 segundos.
2. Que la identificación nunca sea un callejón sin salida: 3 candidatas, corrección manual y alta de coche nuevo.
3. Que el garaje se sienta como una colección, no como un carrete de fotos.
4. Coste de producción **0 €** para el propietario.
5. Instalable desde GitHub sin pasar por Play Store.

## 5. No objetivos (v1)

- Mapa de avistamientos.
- Push notifications (v2).
- Interior del coche, 360°, renders.
- Web.
- Algoritmo de feed con machine learning.

## 6. Anti-objetivos

- Anuncios. Ni uno.
- Paywall o límite de escaneos.
- Pedir dinero para algo esencial.
- Que la IA sea la única forma de identificar un coche.
- Fotos que no haya hecho el usuario.
- Un leaderboard que se pueda comprar con dinero (solo se paga **ver** el de amigos, no subir puestos).

---

## 7. Restricciones

| Restricción | Consecuencia |
|---|---|
| 0 € de coste de producción | Supabase free, Cloudflare R2 free, IA gratuita con fallback, GitHub Actions |
| El propietario no programa | El agente escribe el 100% del código |
| Repo público | Cero secretos y cero datos personales en el repo. Ni el correo del admin |
| APK fuera de Play Store | Stripe para pagos. Play Billing solo si algún día se publica |
| Móvil de gama media | 60 fps en scroll de garaje. Fotos comprimidas antes de subir |
| El propietario no tiene el PC encendido | Nada de tareas locales. Todo en GitHub Actions o cron del servidor |
| Español e inglés desde el día 1 | Toda cadena pasa por i18n |

---

## 8. Decisiones cerradas

| # | Decisión | Motivo |
|---|---|---|
| D1 | Flutter, solo Android en v1 | Sin Mac ni 99 $/año. iOS queda abierto |
| D2 | Supabase: auth, Postgres, Edge Functions | Capa gratis, RLS real |
| D3 | Fotos en **Cloudflare R2** desde el inicio | 10 GB gratis y egreso gratis. Supabase da 1 GB y migrar después duele |
| D4 | Carta por modelo **y generación** | Un 991 y un 992 son cartas distintas |
| D5 | **Cero renders.** Carta = tu mejor foto | Evita derechos de autor y 500 imágenes que nadie ha hecho |
| D6 | 2.5D sobre **tu foto**, no sobre un render | Paralaje del usuario, no un coche inventado |
| D7 | Catálogo de 500 coches, semilla Wikidata + curación | Verificable y gratis |
| D8 | Solo deportivos, exóticos y clásicos | Decisión de producto. No hay Ibizas nunca |
| D9 | Cualquiera propone coche, el dueño aprueba | Escala sin trabajo previo del dueño |
| D10 | Rareza automática, sin ajuste manual del dueño en la fórmula | La comunidad propone, el dueño aprueba la corrección |
| D11 | 6 tiers sin `common`: Poco común, Raro, Muy raro, Épico, Mítico, Legendario | Si no hay comunes, la escala no puede empezar en común |
| D12 | Login obligatorio: email OTP, Google, GitHub. Apple después | Decisión del dueño |
| D13 | Onboarding con perfil público/privado, notificaciones, ubicación y tipos de coche | Privacidad declarada al entrar, no escondida en ajustes |
| D14 | Ubicación exacta para el dueño, 200 m para el resto | Privacidad útil sin perder el "dónde lo vi" |
| D15 | La **primera foto de una carta** solo con cámara. Fotos adicionales sí desde galería | Crear una carta exige prueba de avistamiento; ampliar una existente no permite inventarse un coche |
| D16 | El feed ordena con SQL, sin ML | Un algoritmo de verdad cuesta dinero; uno de reglas no |
| D17 | Leaderboards: 3 métricas × 2 periodos, global gratis, amigos de pago único | Ingreso simbólico sin paywall de la función principal |
| D18 | Cosméticos: fondos, marcos de logo, portada con tu foto, reversos, insignias | No afectan a la colección |
| D19 | Pagos y donaciones con Stripe | Un solo proveedor, sin comisión de tienda |
| D20 | Panel de admin oculto, solo para el propietario y anónimo | El dueño modera sin aparecer |
| D21 | Monedas: tipos de cambio congelados del BCE, actualizados a diario | Sin API de pago ni precios que envejecen en silencio |
| D22 | Fase 1: garaje, escaneo, catálogo, carta, perfil, login, onboarding | Lanzar antes |
| D23 | Fase 2: feed, amigos, leaderboards, cosméticos, pagos | Todo lo social junto |
| D24 | Sin push en v1 | Menos permisos, menos infraestructura |
| D25 | Copias de seguridad en GitHub Actions → R2, semanales y cifradas | Gratis y sin el PC encendido |
| D26 | Edad declarada al registrarse, mínimo **14** en la UE, editable en ajustes | Sin pedir documento. Compras solo 18+ |
| D27 | Cuenta obligatoria, sin modo invitado | Decisión del dueño; se asume la fricción |
| D28 | Borrado de cuenta desde la app, con fotos y datos | RGPD, no negociable |
| D29 | **Sin difuminado, ni automático ni opcional.** Las fotos se suben tal cual | Decisión del dueño. Se avisa en los términos y antes de publicar |
| D31 | R2 con **tope duro de 9,5 GB**. Al alcanzarlo se bloquean las subidas | Evitar cualquier cargo. 10 GB es el límite gratis |
| D32 | Cuotas por usuario y rate limiting en toda subida | Evitar que una cuenta llene el almacenamiento o genere coste |
| D30 | Todo el trabajo pesado corre en GitHub o en servidores, nunca en el PC | El propietario no tiene el PC encendido |

---

## 9. Arquitectura

```
┌──────────────────────────────────────────┐
│  App Flutter (Android)                   │
│  ├─ Garaje (Drift + sync)                │
│  ├─ Escáner (cámara + cola offline)      │
│  ├─ Carta (2.5D sobre foto)              │
│  ├─ Feed / amigos / leaderboard          │
│  └─ Ajustes / cosméticos                 │
└───────────────┬──────────────────────────┘
                │
   ┌────────────┴─────────────┐
   │                          │
┌──▼──────────────────┐  ┌────▼─────────────────┐
│ Supabase            │  │ Cloudflare R2        │
│ Auth (OTP/GitHub)   │  │ fotos originales     │
│ Postgres + RLS      │  │ miniaturas           │
│ Edge Functions      │  │ backups cifrados     │
└──┬───────────────┬──┘  └──────────────────────┘
   │               │
┌──▼──────────┐  ┌─▼──────────────────────────┐
│ Adaptador   │  │ Stripe                     │
│ de visión   │  │ cosméticos + donaciones    │
│ CF → OR →   │  └────────────────────────────┘
│ Mistral     │
└─────────────┘
```

**Regla de oro:** la app nunca habla directamente con el proveedor de IA. Habla con una Edge Function, que elige proveedor, aplica cuota y devuelve candidatas. Si todos fallan, responde `manual_only` y la app abre el buscador.

**Regla de plata:** toda tarea programada vive en GitHub Actions o en `pg_cron`. Nada depende de que el propietario tenga un ordenador encendido.

---

## 10. Fases

### Fase 1 — El garaje (lanzamiento)

Login, onboarding, catálogo, escaneo, carta, garaje, perfil, valor total, porcentaje de colección, borrado de cuenta, panel de admin mínimo (aprobar coches y correcciones).

**Criterio de salida:** un amigo instala el APK, se registra, caza un coche, ve su carta y la comparte. Sin feed.

### Fase 2 — Lo social y el dinero

Feed global con amigos primero, likes y comentarios, amigos (usuario + QR), leaderboards, cosméticos, Stripe, reportes y bloqueos.

**Criterio de salida:** dos usuarios se añaden, ven el feed del otro y aparecen en el leaderboard.

---

## 11. Autenticación y onboarding

**Métodos:** email con código OTP (6 dígitos, 10 min de validez), Google, GitHub. Apple cuando exista iOS. Sin contraseña en ningún caso.

**Transición SignUp ↔ SignIn:** una rueda que ocupa la pantalla entera, gira 220°, y al terminar deja el otro formulario. 700 ms, `ease-in-out`. Respeta `prefers-reduced-motion` con un fundido.

**Onboarding, 4 pasos, todo saltable menos el primero:**

1. Nombre de usuario (único, 3–20, `[a-z0-9_]`).
2. Perfil público o privado. Por defecto **privado**.
3. Notificaciones (se pueden activar en v2, se guarda la preferencia).
4. Ubicación: exacta solo para ti, 200 m para el resto. Se explica en una frase, sin jerga.
5. Tipos de coche preferidos (multi-selección): deportivos, exóticos, clásicos, hipercoches, rally, JDM. Solo afecta a recomendaciones del feed.
6. Moneda (lista corta: EUR, USD, GBP, MXN, ARS, CLP, COP, CHF, JPY, BRL). Editable después.
7. Edad declarada. Obligatoria. Si es menor de **14**, error: "Debes tener al menos 14 años" y no se puede continuar hasta corregirla. Sin verificación documental. Editable en ajustes.

---

## 12. Catálogo

- **500 coches** en el lanzamiento, solo deportivos, exóticos y clásicos. Ni un coche común, en ninguna versión futura.
- Una carta por modelo **y generación**. Mismo modelo y misma generación con distinta versión comercial = misma carta (Golf GTI y Golf no aplica: ninguno de los dos entra).
- Campos mínimos: marca, modelo, generación, año desde/hasta, CV, precio de mercado, unidades producidas (si se conoce), rareza.
- **Cualquiera propone** un coche nuevo. Queda en `car_submissions` con estado `pending`. El dueño aprueba o rechaza desde el panel. Al aprobar, se crea la fila en `cars` y se recalcula la rareza.
- Si un escaneo no coincide con nada del catálogo, la app lo dice explícitamente ("no hemos podido identificar este coche, dinos cuál es") y ofrece proponerlo. Nunca inventa.
- El catálogo vive en el APK como JSON de respaldo y en Supabase como fuente de verdad. El buscador funciona sin internet.
- **Sin fotos de catálogo.** Una carta que no tienes se muestra con silueta plana y el texto "sin avistar".

---

## 13. Escaneo e identificación

1. Cámara en pantalla completa, encuadre guiado, disparo con obturador.
2. La foto se comprime en el dispositivo: 1024 px lado mayor, WebP q80 (~120 KB).
3. Se envía a `POST /identify` con la imagen y el contexto (ubicación redondeada, hora).
4. La Edge Function prueba proveedores **en orden**: Cloudflare Workers AI → OpenRouter → Mistral. Timeout 6 s por proveedor, 12 s total.
5. Devuelve hasta 3 candidatas con `car_id` y confianza, o `manual_only`.
6. Pantalla de confirmación: tres cartas en abanico, cada una con su % de confianza. Botón "no es ninguno" siempre visible.
7. Si hay `car_id` en el garaje, no se crea carta: se añade un avistamiento a la existente.
8. Revelado de 1,2 s, vibración háptica, sonido opcional (desactivado por defecto).
9. Las correcciones del usuario se guardan en `identification_corrections`. **La IA no aprende sola.**

**Fallback manual:** buscador por marca/modelo con fuzzy matching local. Si no está, proponer coche.

**Offline:** la foto se guarda en cola local (Drift) con coordenadas y hora exactas del disparo. Al recuperar conexión, se procesan en orden FIFO y se resuelven una a una. La cola nunca se pierde, ni al cerrar la app.

---

## 14. Fotos, privacidad y cuotas

**Origen de la foto**

- **Primera foto de una carta: solo cámara.** `image_picker` con `ImageSource.camera` y comprobación de que el fichero viene de una captura reciente (timestamp + ruta de caché de la app).
- **Fotos adicionales de una carta que ya existe: cámara o galería.** No permite inventarse un coche, solo ampliar uno ya confirmado.
- Límite honesto, escrito en la doc y en la UI: **una foto de una pantalla no se puede detectar**. Se cubre con reportes de la comunidad.

**Difuminado**

- No existe. Ni automático, ni opcional, ni en el feed. La foto se sube como se tomó.
- Antes de publicar en el feed, un aviso de una línea: "Tu foto puede incluir matrículas o personas. Se publicará tal cual." con opción de cancelar.
- Los términos de uso lo dicen explícitamente.

**Ubicación**

- La exacta se guarda en `sightings` y solo la lee el dueño por RLS.
- El resto ve `sightings_public`, con coordenadas redondeadas a 200 m.
- Al compartir una carta como imagen, no se incluye ubicación.

**Almacenamiento y cuotas**

| Límite | Valor | Dónde se aplica |
|---|---|---|
| Tamaño por archivo | 1,5 MB | Edge Function antes de firmar la subida |
| Fotos por usuario | 1.000 | Contador en `profiles.photo_count` |
| Subidas por usuario | 30/hora, 200/día | Rate limit en la Edge Function |
| Tope global del bucket | **9,5 GB** | Comprobación antes de firmar + alerta a 8 GB |
| Retención de huérfanas | Borrado a los 7 días | Cron diario |

El tope global se comprueba contra la suma real de tamaños en `storage_usage`, que actualiza un cron cada hora consultando la API de R2. Si la suma supera 9,5 GB, la Edge Function responde `storage_full` y la app muestra: "El almacenamiento está lleno. Tus fotos siguen en tu móvil." **Ninguna subida puede generar un cargo**: si Cloudflare llegara a facturar algo, el sistema ya ha dejado de subir antes.

**Rutas:** `users/<uuid>/<sighting-uuid>.webp`, no adivinables. Acceso por URL firmada de 5 minutos emitida por una Edge Function que comprueba permisos.

**Borrado de cuenta:** se borran perfil, entradas, avistamientos, fotos en R2, comentarios, likes, amistades y compras (salvo el registro contable que exige Stripe).

---

## 15. La carta

**Composición, de arriba abajo:**

1. Borde de 2 px del color de la rareza, con halo interior sutil.
2. Fondo navy→asphalt radial.
3. **Tu foto** del coche, encuadre 4:3, con viñeteado y un halo del color de la rareza detrás.
4. Píldora de rareza arriba a la izquierda.
5. Contador `NNN / 500` arriba a la derecha (posición en el catálogo / total).
6. Marca en versalitas con tracking ancho; modelo en condensada grande, crema.
7. Fila de datos: año · CV · unidades, en monoespaciada `#8C93A3`.
8. Valor de mercado en verde, con etiqueta "valor 2026" y la moneda del perfil.
9. Si la carta no tiene foto propia: silueta plana y "sin avistar".

**Colores de rareza**

| Tier | Color |
|---|---|
| Poco común | `#2DD4BF` |
| Raro | `#3B82F6` |
| Muy raro | `#8B5CF6` |
| Épico | `#EC4899` |
| Mítico | `#E0533B` |
| Legendario | `#F5B942` |

**Interacción:** al tocar, la carta se abre a pantalla completa y la foto se inclina ±18° con paralaje (2.5D sobre la foto, mapa de profundidad generado en el dispositivo una vez y cacheado). Al deslizar hacia arriba aparecen todas tus fotos de ese coche, la más reciente primero, con fecha y zona.

**Compartir:** genera un PNG de la carta con marca de agua discreta y un enlace `kerb.app/c/<id>`. Sin datos de ubicación en la imagen.

---

## 16. Rareza

**Fórmula** (0–100):

```
score = 40·f_unidades + 25·f_precio + 20·f_potencia + 15·f_edad
```

- `f_unidades = 1 − log10(units)/log10(50000)`, acotado [0,1].
- `f_precio`: percentil del coche dentro del catálogo.
- `f_potencia`: normalizado sobre 1200 CV.
- `f_edad`: 1 si tiene más de 25 años, decae a 0 en los de menos de 5.
- Si falta un dato, se **renormalizan** los pesos disponibles. Nunca se inventa.
- Si faltan dos o más, la carta queda en `pending_rarity` y no muestra tier hasta completarse.

**Cortes por percentil del catálogo**, no por valor absoluto. Con un catálogo sin coches comunes, los cortes absolutos aplastarían todo hacia arriba:

| Tier | Percentil |
|---|---|
| Poco común | 0–30 |
| Raro | 30–55 |
| Muy raro | 55–75 |
| Épico | 75–90 |
| Mítico | 90–97 |
| Legendario | 97–100 |

**Correcciones:** cualquier usuario puede proponer un cambio de rareza con motivo. Entra en `rarity_corrections` con estado `pending`. El dueño aprueba o rechaza. Si aprueba, se aplica un `override` documentado con el motivo y el autor. El cálculo se versiona (`formula_version`) para poder recalcular todo el catálogo sin perder historia.

---

## 17. Garaje y perfil

- **Garaje:** grid de cartas, orden por rareza / reciente / valor. Filtros por marca, tier y tipo. Funciona **offline** con la copia local.
- **Valor total del garaje** en la moneda del perfil, visible en el perfil público si el perfil es público.
- **Porcentaje de colección:** `cartas / 500`, con desglose por tier.
- **Perfil:** nombre, foto, portada, fondo, marco del logo, insignias, valor total, número de coches, porcentaje, antigüedad, leaderboard. Público o privado según onboarding.
- **Amigos:** se añaden por nombre de usuario o por QR. Solicitud → aceptar/rechazar. Se puede eliminar y bloquear.
- **Reportar y bloquear** desde cualquier carta, comentario o perfil. Obligatorio en fase 2.

---

## 18. Feed

**Alcance:** global, con los amigos primero. Likes y comentarios.

**Orden (SQL, sin ML):**

```
score = 0.45·es_amigo + 0.25·recencia + 0.20·rareza + 0.10·afinidad_tipo
```

- `es_amigo`: 1 si hay amistad aceptada.
- `recencia`: decae exponencial con vida media de 48 h.
- `rareza`: tier de la carta normalizado.
- `afinidad_tipo`: intersección con los tipos preferidos del onboarding.
- Paginación por cursor. Se recalcula al leer, con caché de 5 minutos.

**Coste:** cero. Es una consulta y un índice, no un modelo.

Si algún día se quiere ranking personalizado de verdad, se hace con datos propios en Postgres (no con un servicio externo) y se decide entonces. No entra en v1 ni v2.

**Privacidad:** solo se publica lo que el usuario marca explícitamente. Un perfil privado no aparece en el feed de desconocidos; solo sus amigos ven sus publicaciones.

---

## 19. Leaderboards

**Seis tableros:** valor de colección, número de coches, puntuación de rareza. Cada uno en versión **mensual** e **histórica**.

- **Globales:** gratis para todos.
- **Entre amigos:** se desbloquean con un **pago único simbólico** (precio a fijar, orientativo 1,99 €). Se paga por desbloquear la vista, no por posición. Nadie compra puestos.
- Se calculan con una vista materializada refrescada cada hora por `pg_cron`. No hay proceso en el PC.
- Empate: gana quien llegó antes a esa cifra (`updated_at`).
- El mensual se reinicia el día 1 a las 00:00 UTC y guarda el histórico del mes anterior.

**Nota para el futuro:** un desbloqueo de función es un bien digital. Si Kerb entra en Play Store, tendrá que pasar por Play Billing. Con APK y Stripe ahora, no hay problema.

---

## 20. Cosméticos y pagos

**Catálogo de cosméticos:**

| Producto | Efecto |
|---|---|
| Fondo de perfil | Imagen o degradado detrás del avatar |
| Marco del logo | Borde animado o estático alrededor del logo |
| Portada | Foto de tu colección como cabecera del perfil |
| Reverso de carta | Diseño de la cara trasera al girar una carta |
| Insignia | Distintivo junto al nombre (temporadas, hitos, compra) |

- Ninguno da ventaja en rareza, valor o leaderboard.
- Se compran con Stripe Checkout (una vez o packs). Sin suscripción en v1.
- Inventario en `user_cosmetics`. Se aplican desde ajustes.
- **Donaciones:** enlace de Stripe Payment Link. Sin donación mínima de 1 € porque las comisiones se lo comen; se sugiere 3 €.

---

## 21. Panel de administración

- Solo para la cuenta del propietario. **El correo no se escribe en el repo**: se marca el rol en la tabla `admins` desde el panel de Supabase.
- Acceso oculto: ajustes → mantener pulsado el número de versión 5 s. Sin enlace, sin mención en la UI, sin documentación pública.
- Funciones: aprobar/rechazar coches propuestos, aprobar/rechazar correcciones de rareza, revisar reportes, banear cuentas, ver métricas básicas.
- Todo lo que hace el admin queda en `admin_actions` con fecha y motivo. Anónimo para los usuarios, trazable para el propietario.
- No hay ninguna insignia ni marca de "admin" visible.

---

## 22. Modelo de datos

```sql
-- Catálogo
create table cars (
  id text primary key,                    -- 'ferrari-f40-1987'
  make text not null,
  model text not null,
  generation text,
  year_from int not null,
  year_to int,
  power_hp int,
  production_units int,
  market_price_eur numeric(12,2),
  rarity_score numeric(5,2),
  rarity_tier text check (rarity_tier in
    ('uncommon','rare','very_rare','epic','mythic','legendary')),
  formula_version int not null default 1,
  created_at timestamptz default now()
);

-- Perfiles
create table profiles (
  id uuid primary key references auth.users on delete cascade,
  username text unique not null,
  currency text not null default 'EUR',
  age_declared int,
  is_public boolean not null default false,
  locale text not null default 'es',
  preferred_types text[] default '{}',
  cover_url text,
  background_id text,
  logo_frame_id text,
  created_at timestamptz default now()
);

-- Garaje
create table entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  car_id text not null references cars,
  first_seen_at timestamptz not null default now(),
  unique (user_id, car_id)
);

-- Avistamientos. Coordenadas exactas: solo el dueño
create table sightings (
  id uuid primary key default gen_random_uuid(),
  entry_id uuid not null references entries on delete cascade,
  user_id uuid not null references profiles on delete cascade,
  photo_path text not null,
  thumb_path text,
  taken_at timestamptz not null,
  lat_exact numeric(9,6),
  lng_exact numeric(9,6),
  lat_round numeric(6,3),                 -- 200 m
  lng_round numeric(6,3),
  is_public boolean not null default false
);

create view sightings_public as
  select id, entry_id, user_id, thumb_path, taken_at, lat_round, lng_round
  from sightings where is_public;

-- Social (fase 2)
create table friendships (
  id uuid primary key default gen_random_uuid(),
  requester uuid not null references profiles on delete cascade,
  addressee uuid not null references profiles on delete cascade,
  status text not null default 'pending'
    check (status in ('pending','accepted','blocked')),
  created_at timestamptz default now(),
  unique (requester, addressee)
);

create table posts (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  entry_id uuid references entries on delete cascade,
  caption text,
  created_at timestamptz default now()
);

create table post_likes (
  post_id uuid references posts on delete cascade,
  user_id uuid references profiles on delete cascade,
  created_at timestamptz default now(),
  primary key (post_id, user_id)
);

create table post_comments (
  id uuid primary key default gen_random_uuid(),
  post_id uuid not null references posts on delete cascade,
  user_id uuid not null references profiles on delete cascade,
  body text not null check (char_length(body) <= 500),
  created_at timestamptz default now()
);

-- Moderación y propuestas
create table car_submissions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  payload jsonb not null,
  status text not null default 'pending'
    check (status in ('pending','approved','rejected')),
  reviewed_by uuid references profiles,
  review_note text,
  created_at timestamptz default now()
);

create table rarity_corrections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  car_id text not null references cars,
  proposed_tier text not null,
  reason text not null,
  status text not null default 'pending',
  created_at timestamptz default now()
);

create table identification_corrections (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles on delete cascade,
  photo_hash text not null,
  predicted jsonb,
  chosen_car_id text references cars,
  created_at timestamptz default now()
);

create table reports (
  id uuid primary key default gen_random_uuid(),
  reporter uuid not null references profiles on delete cascade,
  target_type text not null check (target_type in ('post','comment','profile','sighting')),
  target_id uuid not null,
  reason text not null,
  status text not null default 'open',
  created_at timestamptz default now()
);

create table admins (
  user_id uuid primary key references profiles on delete cascade,
  created_at timestamptz default now()
);

create table admin_actions (
  id uuid primary key default gen_random_uuid(),
  admin_id uuid not null references profiles,
  action text not null,
  target_id text,
  note text,
  created_at timestamptz default now()
);

-- Compras y cosméticos (fase 2)
create table cosmetics (
  id text primary key,
  kind text not null check (kind in ('background','logo_frame','cover','card_back','badge')),
  price_eur numeric(6,2) not null,
  is_active boolean not null default true
);

create table user_cosmetics (
  user_id uuid not null references profiles on delete cascade,
  cosmetic_id text not null references cosmetics,
  acquired_at timestamptz default now(),
  primary key (user_id, cosmetic_id)
);

create table purchases (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references profiles on delete cascade,
  stripe_session_id text unique not null,
  product text not null,
  amount_eur numeric(6,2) not null,
  status text not null default 'paid',
  created_at timestamptz default now()
);
```

**RLS:** activo en todas las tablas de usuario. `cars` y `cosmetics`: lectura pública, escritura solo service role. `sightings`: el dueño lee todo lo suyo; el resto solo `sightings_public`. `admins`: lectura solo del propio registro (para que la app sepa si mostrar el panel), escritura por service role.

---

## 23. Seguridad y RGPD

- RLS en todas las tablas, sin excepción. Es la fase que no se salta.
- Claves de IA, Stripe y R2 solo en Supabase Secrets. La app lleva únicamente la `anon key`.
- Fotos en bucket privado, acceso por URL firmada de 5 minutos.
- Coordenadas exactas aisladas en `sightings`, nunca en la vista pública.
- Borrado de cuenta desde la app: borra datos, fotos y sesiones. Confirmación escrita.
- Política de privacidad y términos publicados en GitHub Pages, enlazados en la app.
- Sin analytics de terceros. Métricas propias y agregadas.
- Edad: el usuario la declara al registrarse y puede cambiarla en ajustes. Mínimo **14** (edad de consentimiento digital en España). Por debajo, error y no se puede continuar. Las compras exigen 18+. **No hay verificación documental**: se dice en los términos.
- **Riesgo asumido:** se guardan matrículas y caras sin difuminar, y no se ofrece difuminado. Al publicar en el feed se avisa una vez: "Tu foto puede incluir matrículas o personas. Se publicará tal cual." Publicar es decisión del usuario.

---

## 24. Costes y límites gratuitos

| Servicio | Gratis | Límite que nos afecta |
|---|---|---|
| Supabase | 500 MB DB, 1 GB storage, 50k MAU | Se duerme a los 7 días sin uso → cron cada 3 días |
| Cloudflare R2 | 10 GB, egreso gratis | **Tope propio de 9,5 GB** (D31). Requiere método de pago, sin cargo dentro del plan |
| Cloudflare Workers AI | 10.000 neuronas/día | Primera opción de visión |
| OpenRouter | ~50 req/día | Segunda opción |
| Mistral | ~1.000 M tokens/mes | Tercera opción |
| GitHub Actions | 2.000 min/mes (privado) | Backups, cron de despertar, recálculo |
| Stripe | Sin cuota fija | 1,5 % + 0,25 € por transacción europea |
| GitHub Pages | Gratis | Legal |

**Vías de escape si el catálogo crece:** de 500 a 2.000 coches no cambia nada. Lo que se llena primero son las fotos: 9,5 GB de R2 dan para ~75.000 fotos a 120 KB. Al llegar ahí se para la subida; no se paga nada.

---

## 25. Copias de seguridad

Sin PC encendido, sin servidor propio:

1. GitHub Actions, domingo 03:00 UTC.
2. `pg_dump` de Supabase con la cadena de conexión en un secret.
3. Cifrado con `age` y clave pública guardada en el repo; la privada, en el gestor de contraseñas del propietario.
4. Subida a `r2://kerb-backups/db/YYYY-MM-DD.sql.age`.
5. Retención: 8 semanales + 12 mensuales.
6. Cada trimestre, una restauración de prueba en un proyecto Supabase temporal.

**Lo que esto no cubre:** pérdida de datos entre domingos (hasta 7 días). Supabase free no tiene PITR. Se acepta y se documenta.

---

## 26. Idiomas y monedas

- Español e inglés desde el día 1, con ficheros ARB. Cero cadenas hardcodeadas.
- Monedas: se guardan los tipos del BCE congelados en `fx_rates` (EUR base), actualizados a diario por un workflow de GitHub que llama a una fuente gratuita sin clave (Frankfurter, datos del BCE).
- El precio del catálogo se guarda en EUR y se convierte al mostrar. La fecha del tipo se muestra en el detalle.
- Si el workflow falla, se usa el último tipo guardado y se avisa en el detalle ("tipo de cambio del 3 nov").

---

## 27. Riesgos abiertos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cupo de IA gratis | Alto con éxito | 3 proveedores en cascada + buscador manual siempre |
| 500 coches son mucho trabajo de datos | Alto | Semilla Wikidata + curación por lotes + propuestas de la comunidad |
| Cámara obligatoria y cuenta obligatoria | Medio (fricción) | Onboarding de 4 pasos, OTP sin contraseña. Se asume |
| Fotos sin difuminar | Medio (legal) | Aviso al publicar + reportes + borrado rápido |
| Edad autodeclarada | Medio (legal) | Términos claros, compras 18+, sin promoción a menores |
| Leaderboard de amigos de pago | Bajo | Es opcional; el global es gratis |
| Supabase free se duerme | Alto | Cron cada 3 días + workflow de backup |
| Backup con hasta 7 días de pérdida | Medio | Aceptado y documentado |
| Stripe exige cuenta de negocio | Bajo | Se abre como autónomo o cuenta individual |
| Play Store en el futuro | Medio | Migrar cosméticos a Play Billing antes de publicar allí |

---

## 28. Lo que queda al builder

- Estructura de carpetas Flutter y gestor de estado (recomendado: Riverpod).
- Diseño exacto de Home y barra inferior.
- Tipografía definitiva entre las candidatas.
- Animación de revelado (dentro del 1,2 s fijado).
- Formato del JSON de catálogo y del fichero de tipos de cambio.
- Estrategia de caché de imágenes en el dispositivo.
- Precio exacto del desbloqueo de leaderboard de amigos.

Si alguna cambia lo que ve el usuario de forma sustancial, se consulta antes.
