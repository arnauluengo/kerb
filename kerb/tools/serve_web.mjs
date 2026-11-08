// Servidor estático mínimo para ver la build web sin depender de Flutter.
//   node tools/serve_web.mjs [puerto]
// Sirve build/web y sirve cualquier ruta a index.html (la app es SPA).
import { createServer } from 'node:http';
import { readFile } from 'node:fs/promises';
import { dirname, extname, join, normalize, resolve } from 'node:path';
import { fileURLToPath } from 'node:url';

const root = resolve(dirname(fileURLToPath(import.meta.url)), '..', 'build', 'web');
const port = Number(process.argv[2] ?? 8080);

const mime = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.wasm': 'application/wasm',
  '.css': 'text/css; charset=utf-8',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.png': 'image/png',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.map': 'application/json',
};

createServer(async (req, res) => {
  const url = decodeURIComponent((req.url ?? '/').split('?')[0]);
  let path = normalize(join(root, url));
  if (!path.startsWith(root)) {
    res.writeHead(403).end('forbidden');
    return;
  }

  try {
    let body = await readFile(path);
    if (extname(path) === '') body = await readFile(join(root, 'index.html'));
    const ext = extname(path);
    res.writeHead(200, {
      'content-type': ext === '' ? mime['.html'] : (mime[ext] ?? 'application/octet-stream'),
      'cache-control': 'no-store',
    });
    res.end(body);
  } catch {
    const html = await readFile(join(root, 'index.html'));
    res.writeHead(200, { 'content-type': mime['.html'], 'cache-control': 'no-store' });
    res.end(html);
  }
}).listen(port, () => console.log(`Kerb web: http://localhost:${port}`));
