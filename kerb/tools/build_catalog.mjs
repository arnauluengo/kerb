// Genera kerb/assets/catalog.json a partir de tools/cars_raw.json.
// Calcula la rareza con la fórmula de la spec §13. Ejecutar:
//   node tools/build_catalog.mjs
import { readFileSync, writeFileSync, mkdirSync, existsSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const here = dirname(fileURLToPath(import.meta.url));
const raw = JSON.parse(readFileSync(join(here, 'cars_raw.json'), 'utf8'));
const tiers = JSON.parse(readFileSync(join(here, 'rarity_tiers.json'), 'utf8'));
const CURRENT_YEAR = 2026;

// La fórmula sugiere; la curación decide. Un coche sin tier curado cae en la
// sugerencia de la fórmula y se avisa por consola para que alguien lo revise.
const curated = new Map();
for (const group of tiers.groups) {
  for (const id of group.ids) curated.set(id, group.tier);
}

const clamp = (v, lo = 0, hi = 1) => Math.min(hi, Math.max(lo, v));

// Percentil de precio dentro del catálogo (0 = el más barato, 1 = el más caro).
const priced = raw
  .map((c) => c.market_price_eur)
  .filter((p) => typeof p === 'number' && p > 0)
  .sort((a, b) => a - b);
const pricePercentile = (p) => {
  if (!priced.length) return null;
  const below = priced.filter((x) => x < p).length;
  return priced.length === 1 ? 1 : below / (priced.length - 1);
};

function rarity(car) {
  const parts = [];

  if (typeof car.production_units === 'number' && car.production_units > 0) {
    parts.push([40, clamp(1 - Math.log10(car.production_units) / Math.log10(50000))]);
  }
  if (typeof car.market_price_eur === 'number' && car.market_price_eur > 0) {
    const pct = pricePercentile(car.market_price_eur);
    if (pct !== null) parts.push([25, pct]);
  }
  if (typeof car.power_hp === 'number' && car.power_hp > 0) {
    parts.push([20, clamp(car.power_hp / 1200)]);
  }
  if (typeof car.year_from === 'number') {
    parts.push([15, clamp((CURRENT_YEAR - car.year_from - 5) / 20)]);
  }

  const totalWeight = parts.reduce((s, [w]) => s + w, 0);
  if (totalWeight === 0) return 0;
  const weighted = parts.reduce((s, [w, v]) => s + w * v, 0);
  return (weighted / totalWeight) * 100;
}

// Cortes por percentil del catálogo (spec §16), nunca por puntuación absoluta:
// sin coches comunes, los cortes absolutos aplastarían todo hacia arriba.
function tierFromPercentile(p) {
  if (p < 0.30) return 'uncommon';
  if (p < 0.55) return 'rare';
  if (p < 0.75) return 'very_rare';
  if (p < 0.90) return 'epic';
  if (p < 0.97) return 'mythic';
  return 'legendary';
}

const scores = raw.map((c) => rarity(c)).sort((a, b) => a - b);
const scorePercentile = (score) => {
  if (!scores.length) return 0;
  const below = scores.filter((x) => x < score).length;
  return scores.length === 1 ? 1 : below / (scores.length - 1);
};

const images = existsSync(join(here, 'unsplash_images.json'))
  ? JSON.parse(readFileSync(join(here, 'unsplash_images.json'), 'utf8'))
  : {};

const out = raw.map((car) => {
  const rawScore = rarity(car);
  const score = Number(rawScore.toFixed(2));
  const curatedTier = curated.get(car.id);
  const image = images[car.id];
  const spotted = image && image.status === 'ok' ? image : null;
  const { render_path: _r, depth_path: _d, ...rest } = car;
  return {
    ...rest,
    rarity_score: score,
    rarity_tier: curatedTier ?? tierFromPercentile(scorePercentile(rawScore)),
    rarity_source: curatedTier ? 'curated' : 'formula',
    // Solo para cartas sin avistar: la foto de Unsplash sustituye a la silueta.
    image_url: spotted?.url ?? null,
    image_credit: spotted?.credit ?? null,
    image_page: spotted?.photoPage ?? null,
  };
});

out.sort((a, b) => a.id.localeCompare(b.id));

const uncurated = out.filter((c) => c.rarity_source === 'formula');
if (uncurated.length) {
  console.warn(`AVISO: ${uncurated.length} coche(s) sin tier curado, usando la fórmula:`);
  for (const c of uncurated) console.warn(`  - ${c.id} -> ${c.rarity_tier}`);
}

const dir = join(here, '..', 'assets');
mkdirSync(dir, { recursive: true });
writeFileSync(join(dir, 'catalog.json'), JSON.stringify(out, null, 2) + '\n', 'utf8');

const counts = out.reduce((m, c) => ((m[c.rarity_tier] = (m[c.rarity_tier] || 0) + 1), m), {});
console.log(`catalog.json: ${out.length} coches`);
console.log(counts);
