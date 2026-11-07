# Paddock — Documento de diseño

> **SUSTITUIDO.** Este documento describe Paddock, la versión anterior del producto.
> El diseño vigente es `2026-11-07-kerb-design.md`. Se conserva solo como histórico.

**Fecha:** 2026-11-06
**Estado:** obsoleto — sustituido por Kerb
**Autor:** Arnau (producto) + agente (técnico)

---

## 1. Intención

Paddock es una app móvil gratuita de coleccionismo de coches. Haces una foto a un coche que ves por la calle, una IA lo identifica, y nace una carta de colección que se guarda en tu garaje. Un modelo de coche equivale a una carta. Dentro de esa carta viven todas las fotos que hayas hecho de ese coche, con su fecha y su zona.

La app es, por encima de todo, un **álbum de recuerdos bien diseñado**, no un juego competitivo. La rareza y el valor existen para dar peso a la colección, no para convertirla en un marcador.

**Por qué ahora:** las apps de este nicho tienen dos problemas crónicos y ninguno resuelto: la IA identifica mal, y el muro de pago llega antes de la primera foto. Paddock ataca los dos.

---

## 2. Evidencia: qué dicen las reseñas del mercado

Investigación sobre CarSpotter (3,9★, 425 reseñas), Carspot (4,3★, 197), Carspotter Collect Cars (2,0★, 105), CarSnap (4,2★, 207), MotorDex y CarSpotting de MotorTrend.

**Quejas dominantes, por frecuencia:**

1. **La IA falla.** Presente en todas. "Le di una foto clara de un McLaren 720S y dijo Toyota Prius." "Pagani Zonda → Mercedes otro modelo."
2. **Muro de pago antes de usar.** Carspotter Collect Cars: 62 de 105 reseñas son 1★, casi todas por esto. CarSnap: un coche gratis al día.
3. **Faltan modelos.** "No está el Ram", "no está el Maruti de India". La solución que piden todos: poder añadirlo.
4. **No se puede guardar el mismo coche dos veces.** Un usuario vio tres 911 GT3 y solo pudo guardar dos.
5. **Login roto.** Sin Google Sign-In, o "olvidé la contraseña" que no hace nada y se pierde la colección.
6. **Rarezas incoherentes.** "Apollo IE como común", "M3 raro pero M2 exótico".

**Lo que más se elogia:** UI + generosidad del plan gratis. Literal, en Carspot: *"la mejor UI y el mejor set de funciones gratis, pero la IA es malísima"*.

**Conclusión de producto:** el que gane este nicho no gana por tener la mejor IA. Gana por **no bloquear nunca al usuario** y por verse mejor que los demás. La IA es un acelerador, jamás una puerta.

---

## 3. Objetivos

- Que un usuario nuevo haga su primera foto y vea su primera carta **sin registrarse y sin pagar**.
- Que la identificación nunca sea un callejón sin salida: 3 candidatas, corrección manual y alta de coche nuevo.
- Que el garaje se sienta como una colección coherente, no como un collage de fotos.
- Que la app entera funcione con **0 € de coste de producción**.
- Que se pueda instalar desde GitHub sin pasar por Google Play.

## 4. No objetivos (v1)

- Feed social, mapa de avistamientos, leaderboard, retos, badges, amigos, comentarios.
- Interior del coche en el render.
- 360° real en todos los coches.
- Versión web.
- Monetización de cualquier tipo salvo donaciones opcionales.

## 5. Anti-objetivos

Cosas que, si aparecen, significan que hemos fallado aunque la app funcione:

- Un paywall o límite de escaneos que corte la primera sesión.
- Un registro obligatorio antes de poder usar la app.
- Una única respuesta de la IA sin alternativas.
- Una lista de rarezas que la comunidad pueda desmontar con dos ejemplos.
- Un garaje donde las cartas no se parezcan entre sí.

---

## 6. Restricciones

| Restricción | Consecuencia |
|---|---|
| 0 € de coste de producción | Todo en capa gratis. Supabase free, Gemini free, jsDelivr, OpenStreetMap. |
| El dueño no programa | El agente escribe el 100% del código. Documentación y pasos deben ser explícitos. |
| Repositorio público en GitHub | Nada de secretos en el código. Claves en variables de entorno / secrets. |
| Distribución por APK en GitHub Releases | Sin dependencia de Play Store en v1. |
| Español e inglés desde el día 1 | Toda cadena de UI pasa por i18n. Nada hardcodeado. |
| Móvil de gama media | 60 fps en scroll de garaje. Fotos comprimidas antes de subir. |

---

## 7. Decisiones cerradas

| # | Decisión | Motivo |
|---|---|---|
| D1 | **Flutter** para Android e iOS | Un solo código, compilación local gratis e ilimitada, control total del dibujo de la carta. |
| D2 | **Supabase** para auth, base de datos y fotos | Todo en uno, capa gratis generosa, Postgres real con RLS. |
| D3 | **Gemini Flash** para visión | Capa gratis utilizable, buena lectura de coches, salida JSON estructurada. |
| D4 | **Un modelo = una carta**, varias fotos dentro | Evita el bug de duplicados y mantiene la colección legible. |
| D5 | **Rareza = fórmula + ajuste manual** | Automático donde acierta, humano donde importa. |
| D6 | **Catálogo propio en JSON**, semilla desde Wikidata + curación | Gratis, verificable, sin dependencia de API de pago. |
| D7 | **2.5D en todos, 360° solo en raros/legendarios** | Coherencia barata donde no importa, espectáculo donde sí. |
| D8 | **Estilo cinematográfico** (oscuro, borde de rareza, precio verde) | Elegido por el dueño sobre editorial y arcade. |
| D9 | **Modo invitado primero** | Ataca la queja nº2 del mercado. |
| D10 | **Nombre: Paddock** | Elegido por el dueño. |

### 7.1 Decisiones tomadas tras la revisión del builder

| # | Decisión | Motivo |
|---|---|---|
| D11 | **Solo 2.5D en v1. Nada de 360.** | Un mapa de profundidad no genera un giro completo. El 360 falso con IA tiembla y es exactamente el efecto "esto lo ha hecho una IA" que queremos evitar. |
| D12 | **Invitado = cuenta anónima de Supabase**, convertida con `linkIdentity`. | Evita construir un motor de sincronización local→nube. Las cuentas anónimas inactivas 30 días se borran por cron. |
| D13 | **La carta es por generación**, no por modelo. | Un 991 y un 992 son cartas distintas. Es lo que piden explícitamente en las reseñas. |
| D14 | **Android solo en v1.** | iOS exige Mac + 99 $/año. Flutter mantiene la puerta abierta sin coste. |
| D15 | **Gemini devuelve texto libre; el cruce con el catálogo lo hace la Edge Function.** | A escala de catálogo el modelo no puede devolver nuestros slugs. El "%" es la puntuación del cruce difuso, y se muestra como tal. |
| D16 | **Catálogo dentro del APK y actualizable desde Supabase.** | Buscador y salida manual funcionan sin internet; el catálogo crece sin publicar versión. |
| D17 | **Rareza con datos incompletos:** se renormalizan los pesos disponibles. | Nunca inventar. Si falta el precio, la carta no muestra precio. |
| D18 | **Precio congelado con fecha visible** (`valor 2026`) y tipo de cambio fijo en el catálogo. | Sin API de divisas ni precios que envejecen en silencio. |
| D19 | **Coche de la comunidad sin render:** la carta usa la foto del usuario con estilo "sin render". | No se bloquea el alta por no tener render todavía. |
| D20 | **`001 / 500` = posición en el catálogo / total del catálogo.** | Es el único número que significa algo estable en una carta coleccionable. |

---

## 8. Arquitectura

```
┌─────────────────────────────┐
│  App Flutter (Android/iOS)  │
│  ├─ Garaje (local + sync)   │
│  ├─ Escáner (cámara)        │
│  ├─ Carta (2.5D shader)     │
│  └─ Buscador                │
└──────────┬──────────────────┘
           │
     ┌─────┴──────┐
     │            │
┌────▼─────┐  ┌───▼──────────┐
│ Supabase │  │ Gemini Flash │
│ Auth     │  │ visión       │
│ Postgres │  └──────────────┘
│ Storage  │
└──────────┘
     │
┌────▼──────────────────────┐
│ jsDelivr (CDN gratis)     │
│ renders + mapas de prof.  │
│ servidos desde el repo    │
└───────────────────────────┘
```

**Renders:** se generan una vez en local, se commitean a `assets/renders/<car-id>.webp` y `assets/depth/<car-id>.png`. La app los pide a jsDelivr por URL, no van dentro del APK (si no, el APK pesaría cientos de MB).

**Identificación:** la foto se comprime en el dispositivo (~1024 px, WebP q80) y se envía a una Edge Function de Supabase que llama a Gemini. La clave de Gemini nunca vive en la app.

---

## 9. Modelo de datos

```sql
-- Catálogo global, lectura pública
create table cars (
  id              text primary key,          -- slug: 'ferrari-f40-1987'
  make            text not null,
  model           text not null,
  generation      text,
  year_from       int  not null,
  year_to         int,
  power_hp        int,
  torque_nm       int,
  zero_100        numeric(4,1),
  top_speed_kmh   int,
  engine          text,
  production_units int,
  market_price_eur numeric(12,2),
  rarity_score    numeric(5,2) not null,
  rarity_tier     text not null check (rarity_tier in
                    ('common','uncommon','rare','very_rare','epic','legendary')),
  render_path     text,
  depth_path      text,
  is_360          boolean default false,
  created_at      timestamptz default now()
);

-- Perfil
create table profiles (
  id         uuid primary key references auth.users on delete cascade,
  username   text unique,
  currency   text not null default 'EUR' check (currency in ('EUR','USD')),
  locale     text not null default 'es',
  created_at timestamptz default now()
);

-- Garaje: una fila por usuario+coche
create table entries (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references profiles on delete cascade,
  car_id        text not null references cars,
  first_seen_at timestamptz not null default now(),
  notes         text,
  is_public     boolean not null default false,
  unique (user_id, car_id)
);

-- Avistamientos: N fotos por entrada
create table sightings (
  id          uuid primary key default gen_random_uuid(),
  entry_id    uuid not null references entries on delete cascade,
  user_id     uuid not null references profiles on delete cascade,
  photo_path  text not null,
  taken_at    timestamptz not null default now(),
  lat_round   numeric(6,3),   -- redondeado a ~500 m
  lng_round   numeric(6,3),
  is_public   boolean not null default false
);

-- Coche creado por la comunidad (pendiente de revisión)
create table car_submissions (
  id         uuid primary key default gen_random_uuid(),
  user_id    uuid not null references profiles on delete cascade,
  payload    jsonb not null,
  status     text not null default 'pending',
  created_at timestamptz default now()
);
```

**RLS obligatorio en todas las tablas con datos de usuario.** `cars` es lectura pública y escritura solo por service role. `entries` y `sightings`: el usuario solo ve y escribe lo suyo. `car_submissions`: el usuario ve las suyas, escribe las suyas.

**Coordenadas:** nunca se guarda la posición exacta. Se redondea a 3 decimales (~110 m de latitud, ~500 m de precisión práctica) en el cliente, antes de subir. El valor exacto no llega nunca al servidor.

---

## 10. Flujos

### 10.1 Primera vez (sin cuenta)

1. Splash → Home con garaje vacío y un único botón grande: **Escanear**.
2. Cámara. Foto.
3. Compresión local. Envío a la Edge Function.
4. Gemini devuelve `{candidates: [{car_id, confidence}], raw: {...}}`.
5. **Pantalla de confirmación** con las 3 mejores candidatas, cada una con su carta miniatura y su % de confianza.
6. El usuario elige, o pulsa "no es ninguno" → buscador manual.
7. Carta creada. Animación de revelado.
8. "Guarda esto en la nube" → registro opcional (Google o email).

**Regla dura:** si la Edge Function falla, tarda más de 8 s o el cupo de Gemini está agotado, la app cae automáticamente al buscador manual con un mensaje claro. Nunca un error sin salida.

### 10.2 Volver a ver el mismo coche

Escaneas → la IA devuelve un `car_id` que ya está en tu garaje → no se crea carta nueva: se abre la carta existente y se añade un avistamiento nuevo con su foto, fecha y zona.

### 10.3 Buscador

Texto libre sobre marca/modelo. Resultados con carta miniatura. Se puede abrir la ficha completa sin tener el coche en el garaje.

---

## 11. La carta (cerrada)

**Composición**, de arriba abajo:

1. **Borde exterior de 2 px** del color de la rareza, con un halo interior muy sutil del mismo color.
2. **Fondo** radial oscuro (`#1b1d22 → #050506`).
3. **Render del coche** centrado, ocupando el 55% superior, con un halo del color de la rareza detrás.
4. **Píldora de rareza** arriba a la izquierda (punto luminoso + texto en mayúsculas).
5. **Contador** arriba a la derecha (`001 / 500`).
6. **Nombre**: marca en mayúsculas pequeñas con tracking ancho; modelo en tipografía condensada grande.
7. **Fila de datos**: año · CV · velocidad punta, en monoespaciada pequeña.
8. **Precio** en verde (`#4ade80`), monoespaciada bold, con glow suave, y etiqueta "Valor de mercado" debajo.

**Colores de rareza:**

| Tier | Color |
|---|---|
| Común | `#4ade80` |
| Poco común | `#2dd4bf` |
| Raro | `#3b82f6` |
| Muy raro | `#8b5cf6` |
| Épico | `#ec4899` |
| Legendario | `#f5b942` |

**Formato de precio:** `100k €`, `1.2M €`, `10M €`. Un decimal solo si aporta. Moneda según `profiles.currency`.

**Interacción:** al tocar la carta se abre a pantalla completa; se desliza el dedo y el coche se inclina ±25° con parallax. Al deslizar hacia arriba, aparecen tus fotos de ese coche, la más reciente primero.

---

## 12. El render 2.5D

- Un render por coche, encuadre fijo: **tres cuartos delantero**, cámara a la altura del capó, fondo neutro oscuro.
- Mapa de profundidad generado con **Depth Anything V2** en local, una sola vez.
- En la app: shader que desplaza los vértices de un plano según el mapa de profundidad, con la inclinación del dedo. Funciona en Flutter con Impeller.
- **No hay giro de 360° en v1.** El coche se inclina y gira ±25°, lo justo para que se sienta sólido. El campo `is_360` queda en el esquema como reserva, siempre en `false`.

**Coste:** cero en producción. La generación es un proceso por lotes que se ejecuta en local y cuyo resultado se commitea.

**Por qué no 360:** un mapa de profundidad reconstruye volumen desde un punto de vista, no la parte de atrás del coche. Generar las vistas restantes con IA produce un giro que tiembla, y un giro que tiembla es peor que no girar. Se revisará cuando exista una fuente de modelos 3D con licencia abierta y calidad homogénea.

---

## 13. Rareza y precio

**Fórmula** (0–100), pesos iniciales:

```
score = 40 * f_unidades + 25 * f_precio + 20 * f_potencia + 15 * f_edad
```

- `f_unidades`: 1 − log10(units)/log10(50000), acotado a [0,1].
- `f_precio`: normalizado sobre el percentil del catálogo.
- `f_potencia`: normalizado sobre 1200 CV.
- `f_edad`: 1 para coches de más de 25 años, decayendo hasta 0 en los de menos de 5.

**Cortes:** 0–20 común · 20–40 poco común · 40–60 raro · 60–75 muy raro · 75–90 épico · 90–100 legendario.

**Ajuste manual:** cada coche puede llevar un `rarity_override` en el JSON de catálogo. Documentado con el motivo. Sin motivo, no hay override.

---

## 14. Seguridad y privacidad

- **RLS en todas las tablas de usuario.** Sin excepción. Es la fase que no se salta.
- La clave de Gemini vive solo en la Edge Function, nunca en el binario.
- Fotos: bucket privado por defecto. URL firmada para mostrarlas.
- Coordenadas redondeadas en el cliente. La posición exacta no se sube nunca.
- Cuentas: borrado de cuenta debe borrar fotos y datos (derecho al olvido, RGPD).
- Sin analytics de terceros en v1. Si se añade, será opt-in.

---

## 15. Internacionalización

- Español e inglés desde el día 1. Ficheros ARB en Flutter.
- Ninguna cadena hardcodeada en widgets.
- Moneda y formato de número dependen de `profiles.currency`, no del idioma del sistema.
- Los nombres de coche y marca no se traducen.

---

## 16. Lo que queda al builder

Decisiones que este documento no cierra y que un builder competente puede resolver solo:

- Estructura exacta de carpetas Flutter y gestor de estado (recomendado: Riverpod).
- Diseño de la pantalla de Home y de la barra inferior.
- Tipografía concreta (candidatas: una condensada para el modelo, una mono para datos).
- Animación de revelado de carta.
- Cómo se pagina el buscador.
- Formato exacto del JSON de catálogo.
- Estrategia de caché de imágenes en el dispositivo.

Si alguna de estas cambia lo que ve el usuario de forma sustancial, se consulta antes.

---

## 17. Riesgos abiertos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| Cupo de Gemini free (cientos/día) | Alto con éxito | Caché por hash de imagen, modo manual siempre disponible, clave propia opcional |
| 1 GB de Storage | Medio | Compresión a ~120 KB, borrado de fotos huérfanas |
| Supabase free se duerme a los 7 días | Alto | Cron de GitHub Actions cada 3 días |
| Derechos sobre renders de coches reales | Medio | Uso identificativo, retirada por coche si hay reclamación |
| Rarezas discutibles | Medio | Fórmula pública + overrides documentados |
| Flutter + Android SDK no instalados | Bajo | Instalación única, documentada paso a paso |
