// Busca y descarga una foto de Unsplash para cada coche del catálogo.
//
//   $env:UNSPLASH_ACCESS_KEY = "tu-app-id"      # o en tools/.env.local
//   node tools/fetch_unsplash.mjs            # todas las que falten
//   node tools/fetch_unsplash.mjs --demo     # key demo: 50 peticiones/hora
//   node tools/fetch_unsplash.mjs --dry      # solo busca, no descarga
//
// Escribe `tools/unsplash_images.json` (cache reanudable) y, si se descarga,
// los JPG en `tools/catalog_photos/`. `build_catalog.mjs` fusiona el cache en
// `assets/catalog.json`. La key NUNCA se guarda en el repo: solo por entorno.
import { readFileSync, writeFileSync, existsSync, mkdirSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const root = join(here, '..');
const RAW = join(here, 'cars_raw.json');
const CACHE = join(here, 'unsplash_images.json');
const PHOTOS = join(here, 'catalog_photos');
const ENV = join(here, '.env.local');

/// La key puede venir del entorno o de `tools/.env.local`, que está ignorado
/// por git. Así no hace falta escribirla en un chat ni commitearla.
function readEnvFile() {
  if (!existsSync(ENV)) return null;
  const line = readFileSync(ENV, 'utf8')
    .split('\n')
    .map((l) => l.trim())
    .find((l) => l.startsWith('UNSPLASH_ACCESS_KEY='));
  return line?.split('=').slice(1).join('=').trim().replace(/^["']|["']$/g, '') ?? null;
}

const accessKey = process.env.UNSPLASH_ACCESS_KEY ?? readEnvFile();
const args = new Set(process.argv.slice(2));
const demo = args.has('--demo');
const dry = args.has('--dry');
// Con key de producción sobra con 1,2 s; con la demo hay que ir a 75 s.
const throttleMs = Number(process.env.UNSPLASH_THROTTLE_MS ?? (demo ? 75_000 : 1_200));

if (!accessKey) {
  console.error(
    'Falta UNSPLASH_ACCESS_KEY. Crea una app en https://unsplash.com/developers y ' +
      'ponla en el entorno o en kerb/tools/.env.local como ' +
      'UNSPLASH_ACCESS_KEY=xxxx (ese archivo está ignorado por git).',
  );
  process.exit(1);
}

const cars = JSON.parse(readFileSync(RAW, 'utf8'));
const cache = existsSync(CACHE) ? JSON.parse(readFileSync(CACHE, 'utf8')) : {};
const picksPath = join(here, 'unsplash_picks.json');
const picks = existsSync(picksPath)
  ? JSON.parse(readFileSync(picksPath, 'utf8'))
  : {};
if (!dry && !existsSync(PHOTOS)) mkdirSync(PHOTOS, { recursive: true });

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

async function get(path, params) {
  const url = `https://api.unsplash.com/${path}?${new URLSearchParams(params)}`;
  const res = await fetch(url, {
    headers: {
      Authorization: `Client-ID ${accessKey}`,
      'Accept-Version': 'v1',
    },
  });
  if (res.status === 429) {
    const wait = Number(res.headers.get('x-ratelimit-reset') ?? 0);
    console.warn(`  límite de peticiones; esperando hasta ${new Date(wait * 1000)}`);
    await sleep(Math.max(1_000, wait * 1000 - Date.now() / 1000));
    return get(path, params);
  }
  if (!res.ok) throw new Error(`${res.status} ${await res.text()}`);
  return res.json();
}

/// Convierte la respuesta de la API en la entrada del cache. La URL de la carta
/// se construye sobre `urls.raw`, que es lo único que permite fijar el recorte
/// 3:2 que necesita la carta. `images.unsplash.com` se sirve sin key: una vez
/// guardada la URL, la app la carga sin gastar llamadas a la API.
function entryFrom(photo, query) {
  return {
    status: 'ok',
    id: photo.id,
    query,
    url: `${photo.urls.raw}&w=1000&h=667&fit=crop&crop=entropy&q=80&fm=jpg`,
    download: `${photo.urls.raw}&w=1000&h=667&fit=crop&crop=entropy&q=85&fm=jpg`,
    photoPage: photo.links.html,
    credit: photo.user?.name ?? null,
    creditLink: photo.user?.links?.html ?? null,
    width: photo.width,
    height: photo.height,
  };
}

let resolved = 0;

/// Guarda la entrada en el cache y baja el JPG a `tools/catalog_photos/`. La
/// copia local es la que se subirá a R2: la app no puede depender de Unsplash
/// para enseñar un catálogo que además tiene que funcionar sin conexión.
async function store(carId, entry) {
  cache[carId] = entry;
  if (dry) return;
  const file = join(PHOTOS, `${carId}.jpg`);
  if (existsSync(file)) return;
  const res = await fetch(entry.download);
  if (res.ok) {
    writeFileSync(file, Buffer.from(await res.arrayBuffer()));
  } else {
    console.warn(`${carId}: descarga ${res.status}`);
  }
}

// 1) Curación: coche → id de foto elegido a mano. Un/search no sirve para
//    modelos concretos (buscas "190E Evo II" y te sale cualquier Mercedes),
//    así que los importantes se fijan uno a uno.
for (const [carId, photoId] of Object.entries(picks)) {
  if (carId.startsWith('_')) continue;
  if (cache[carId]?.status === 'ok' && cache[carId].id === photoId) continue;
  if (!cars.some((c) => c.id === carId)) {
    console.warn(`${carId}: no está en el catálogo`);
    continue;
  }
  try {
    const photo = await get(`photos/${photoId}`, {});
    await store(carId, entryFrom(photo, `pick:${photoId}`));
    resolved++;
    console.log(`${carId.padEnd(34)} pick  ${cache[carId].credit ?? ''}`);
  } catch (error) {
    console.warn(`${carId}: ${error.message}`);
  }
  writeFileSync(CACHE, `${JSON.stringify(cache, null, 2)}\n`);
  await sleep(throttleMs);
}

let done = 0;
let missing = 0;

/// De más específica a más genérica. Un catálogo de coches raros suele tener
/// resultados pobres: si no hay forma de clavar el modelo, se prefiere una foto
/// de la marca antes que ninguna.
function queries(car) {
  const model = car.model.trim();
  return [
    `${car.make} ${model}`,
    `${car.make} ${model.split(' ')[0]}`,
    `${car.make} ${car.generation ?? ''}`.trim(),
    `${car.make} sports car`,
  ].filter((q, i, all) => q.length > 4 && all.indexOf(q) === i);
}

function pick(photos) {
  // Se busca un plano horizontal y grande: la carta recorta en 3:2.
  const scored = photos.map((p) => {
    const landscape = p.width > p.height;
    const big = Math.min(p.width, 2400) / 2400;
    return { p, score: (landscape ? 2 : 0) + big + (p.height >= 1000 ? 0.5 : 0) };
  });
  scored.sort((a, b) => b.score - a.score);
  return scored[0]?.p ?? null;
}

for (const car of cars) {
  if (cache[car.id]?.status === 'ok') continue;

  let photo = null;
  let usedQuery = null;
  try {
    for (const q of queries(car)) {
      const data = await get('search/photos', {
        query: q,
        per_page: 8,
        orientation: 'landscape',
        content_filter: 'high',
        client_id: accessKey,
      });
      const found = pick(data.results ?? []);
      if (found) {
        photo = found;
        usedQuery = q;
        break;
      }
      await sleep(throttleMs);
    }
  } catch (error) {
    console.warn(`${car.id}: ${error.message}`);
  }

  if (!photo) {
    missing++;
    cache[car.id] = { status: 'not_found', tried: queries(car) };
  } else {
    await store(car.id, entryFrom(photo, usedQuery));
    done++;
  }

  writeFileSync(CACHE, `${JSON.stringify(cache, null, 2)}\n`);
  console.log(
    `${car.id.padEnd(34)} ${cache[car.id].status}${
      usedQuery ? `  ← "${usedQuery}"  ${cache[car.id].credit ?? ''}` : ''
    }`,
  );
  await sleep(throttleMs);
}

console.log(
  `\ncurados: ${resolved}  nuevos: ${done}  sin foto: ${missing}  total: ${cars.length}`,
);
