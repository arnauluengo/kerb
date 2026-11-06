# Paddock v1 (núcleo) — Plan de implementación

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Una app Android instalable donde haces una foto a un coche, la IA propone tres candidatas, eliges una y se guarda como carta cinematográfica en tu garaje, sin registro previo y sin coste de producción.

**Architecture:** Flutter con Riverpod para estado. El catálogo de coches es un JSON que viaja dentro del APK y se refresca desde Supabase. La identificación pasa por una Edge Function de Supabase que llama a Gemini; la clave nunca sale del servidor. Supabase aporta auth anónima, Postgres con RLS y Storage para fotos.

**Tech Stack:** Flutter 3.3x (Dart 3.x), Riverpod, Supabase Flutter SDK, Gemini Flash vía Edge Function (Deno), flutter_map no se usa en v1.

**Spec:** `docs/superpowers/specs/2026-11-06-paddock-design.md`

## Global Constraints

- **Coste de producción 0 €.** Ninguna dependencia de pago. Sin Google Maps, sin Firebase.
- **Android solo en v1.** iOS queda fuera; no se añade configuración de iOS.
- **Español e inglés desde el día 1.** Ninguna cadena visible hardcodeada en un widget; todas pasan por ARB.
- **RLS activo en toda tabla con datos de usuario.** Sin excepción.
- **La clave de Gemini vive solo en la Edge Function.** Nunca en el binario ni en el repo.
- **Coordenadas redondeadas a 3 decimales en el cliente**, antes de cualquier subida.
- **Fotos comprimidas a 1024 px de lado mayor, WebP calidad 80** antes de subir.
- **Ningún paywall ni registro obligatorio.** La app es usable sin cuenta.
- **La IA nunca bloquea:** timeout de 8 s y caída automática al buscador manual.
- **Precios:** formato `100k €`, `1.2M €`, `10M €`. En verde `#4ade80`.
- **Rarezas:** `common #4ade80`, `uncommon #2dd4bf`, `rare #3b82f6`, `veryRare #8b5cf6`, `epic #ec4899`, `legendary #f5b942`.
- **Nombre del paquete:** `app.paddock.mobile`.

## Review Focus

Fallos que la spec implica pero que ningún test de tarea cubre por defecto. Cada uno lleva su test en la tarea que le corresponde.

1. **Sin conexión.** El garaje y el buscador deben abrir y responder con el catálogo embebido. Un usuario en el metro no puede ver una pantalla en blanco.
2. **Cupo de Gemini agotado o respuesta en más de 8 s.** La app cae al buscador manual con un mensaje claro, nunca a un error sin salida.
3. **Foto sin coche** (un perro, una pared). Mensaje "no he encontrado un coche", sin crash y sin crear carta vacía.
4. **Campos nulos en el catálogo.** Un coche sin precio no muestra "null" ni "0 €": no muestra línea de precio.
5. **Privacidad de coordenadas.** Ninguna llamada de red puede llevar latitud/longitud con más de 3 decimales.
6. **Invitado que se registra.** El garaje creado como anónimo sobrevive a la conversión en cuenta real.

---

### Task 1: Entorno, proyecto y primer test

**Files:**
- Create: `paddock/` (proyecto Flutter)
- Create: `paddock/test/smoke_test.dart`
- Create: `.gitignore`

**Interfaces:**
- Produces: proyecto Flutter compilable, `flutter test` verde, `flutter build apk --debug` funciona.

- [ ] **Step 1: Instalar Flutter**

```powershell
Expand-Archive C:\dev\flutter.zip -DestinationPath C:\dev
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\dev\flutter\bin", "User")
```

- [ ] **Step 2: Instalar JDK 17 y Android SDK**

```powershell
winget install --id EclipseAdoptium.Temurin.17.JDK --accept-source-agreements --accept-package-agreements
# cmdline-tools desde https://developer.android.com/studio#command-line-tools-only
# extraer en C:\dev\android-sdk\cmdline-tools\latest
```

- [ ] **Step 3: Aceptar licencias y verificar**

Run: `flutter doctor -v`
Expected: Android toolchain con check verde. Si falla, resolver antes de seguir.

- [ ] **Step 4: Crear el proyecto**

Run: `flutter create --org app.paddock --project-name paddock --platforms android paddock`
Expected: `paddock/android/` existe.

- [ ] **Step 5: Test de humo que falla**

```dart
// paddock/test/smoke_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:paddock/main.dart';

void main() {
  test('la app se construye', () {
    expect(const PaddockApp(), isNotNull);
  });
}
```

- [ ] **Step 6: Ejecutar y ver fallar**

Run: `cd paddock; flutter test`
Expected: FAIL, `PaddockApp` no definido.

- [ ] **Step 7: Implementar el mínimo**

`lib/main.dart` con `class PaddockApp extends StatelessWidget` que devuelve un `MaterialApp` con `home: const SizedBox()`.

- [ ] **Step 8: Verificar y commitear**

Run: `flutter test`
Expected: PASS. Luego `git add -A; git commit -m "chore: scaffold flutter project"`.

---

### Task 2: Tokens de diseño y rarezas

**Files:**
- Create: `paddock/lib/design/tokens.dart`
- Create: `paddock/lib/domain/rarity.dart`
- Test: `paddock/test/domain/rarity_test.dart`

**Interfaces:**
- Produces: `enum RarityTier { common, uncommon, rare, veryRare, epic, legendary }`; `Color rarityColor(RarityTier tier)`; `RarityTier rarityFromScore(double score)`; `const kBg`, `kSurface`, `kGold`, `kPriceGreen`.

- [ ] **Step 1: Test que falla**

```dart
test('los cortes de rareza son los de la spec', () {
  expect(rarityFromScore(0), RarityTier.common);
  expect(rarityFromScore(19.9), RarityTier.common);
  expect(rarityFromScore(20), RarityTier.uncommon);
  expect(rarityFromScore(39.9), RarityTier.uncommon);
  expect(rarityFromScore(40), RarityTier.rare);
  expect(rarityFromScore(60), RarityTier.veryRare);
  expect(rarityFromScore(75), RarityTier.epic);
  expect(rarityFromScore(90), RarityTier.legendary);
  expect(rarityFromScore(100), RarityTier.legendary);
});

test('cada tier tiene su color exacto', () {
  expect(rarityColor(RarityTier.common), const Color(0xFF4ADE80));
  expect(rarityColor(RarityTier.legendary), const Color(0xFFF5B942));
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/domain/rarity_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar** `rarityFromScore(double) -> RarityTier` con cortes `[20,40,60,75,90]`, y el mapa de colores.

- [ ] **Step 4: Verificar.** Run: `flutter test test/domain/rarity_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: rarity tiers and design tokens"`

---

### Task 3: Formato de precio y moneda

**Files:**
- Create: `paddock/lib/domain/money.dart`
- Test: `paddock/test/domain/money_test.dart`

**Interfaces:**
- Produces: `String? formatPrice(num? amountEur, {required Currency currency})` con `enum Currency { eur, usd }` y `const kEurToUsd = 1.08`. Devuelve `null` si `amountEur` es nulo o ≤ 0.

- [ ] **Step 1: Test que falla**

```dart
test('formato compacto en euros', () {
  expect(formatPrice(999, currency: Currency.eur), '999 €');
  expect(formatPrice(8500, currency: Currency.eur), '8.5k €');
  expect(formatPrice(45000, currency: Currency.eur), '45k €');
  expect(formatPrice(100000, currency: Currency.eur), '100k €');
  expect(formatPrice(999999, currency: Currency.eur), '1M €');
  expect(formatPrice(1200000, currency: Currency.eur), '1.2M €');
  expect(formatPrice(10000000, currency: Currency.eur), '10M €');
});

test('en dólares usa el tipo de cambio y el símbolo', () {
  expect(formatPrice(100000, currency: Currency.usd), '108k \$');
});

test('sin precio no inventa nada', () {
  expect(formatPrice(null, currency: Currency.eur), isNull);
  expect(formatPrice(0, currency: Currency.eur), isNull);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/domain/money_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar.** Menos de 1000 → entero. Menos de 1M → dividir por 1000, un decimal si el valor es menor de 10k, recortar `.0`, y si al redondear llega a 1000k promover a M. Desde 1M → dividir por 1e6, un decimal si es menor de 10M.

- [ ] **Step 4: Verificar.** Run: `flutter test test/domain/money_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: compact price formatting"`

---

### Task 4: Internacionalización

**Files:**
- Create: `paddock/l10n/app_es.arb`, `paddock/l10n/app_en.arb`
- Create: `paddock/l10n.yaml`
- Modify: `paddock/pubspec.yaml` (añadir `flutter_localizations`, `generate: true`)
- Test: `paddock/test/l10n_test.dart`

**Interfaces:**
- Produces: `AppLocalizations.of(context)!.scanCta`, `garageTitle`, `searchHint`, `scanFailedFallback`, `noCarFound`, `saveToCloud`.

- [ ] **Step 1: Test que falla**

```dart
testWidgets('la home muestra el CTA traducido', (tester) async {
  await tester.pumpWidget(const PaddockApp(locale: Locale('en')));
  expect(find.text('Scan a car'), findsOneWidget);
  await tester.pumpWidget(const PaddockApp(locale: Locale('es')));
  expect(find.text('Escanear un coche'), findsOneWidget);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/l10n_test.dart`. Expected: FAIL.

- [ ] **Step 3: Añadir los dos ARB** con las seis claves y `flutter gen-l10n`.

- [ ] **Step 4: Verificar.** Run: `flutter test test/l10n_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: es/en localization"`

---

### Task 5: Modelo de coche y catálogo embebido

**Files:**
- Create: `paddock/lib/domain/car.dart`
- Create: `paddock/lib/data/catalog.dart`
- Create: `paddock/assets/catalog.json`
- Test: `paddock/test/data/catalog_test.dart`

**Interfaces:**
- Produces: `class Car { final String id, make, model; final String? generation, engine; final int yearFrom; final int? yearTo, powerHp, topSpeedKmh, productionUnits; final num? marketPriceEur; final double rarityScore; final RarityTier rarity; final String? renderPath, depthPath; }`
- Produces: `Catalog.fromJsonString(String)`, `List<Car> Catalog.search(String query, {int limit = 20})`, `Car? Catalog.byId(String id)`, `int Catalog.length`.

- [ ] **Step 1: Test que falla**

```dart
test('el catálogo embebido carga y busca sin acentos ni mayúsculas', () {
  final cat = Catalog.fromJsonString(rootBundleJson);
  expect(cat.length, greaterThanOrEqualTo(50));
  expect(cat.search('ferrari f40').first.model, 'F40');
  expect(cat.search('CITROEN').isNotEmpty, isTrue); // sin diéresis
  expect(cat.byId('ferrari-f40-1987'), isNotNull);
});

test('un coche sin precio no revienta el parseo', () {
  final car = Car.fromJson({'id': 'x', 'make': 'A', 'model': 'B', 'year_from': 2000,
    'rarity_score': 12, 'rarity_tier': 'common'});
  expect(car.marketPriceEur, isNull);
  expect(car.powerHp, isNull);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/data/catalog_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar.** Normalizar la búsqueda con `toLowerCase()` y sustitución de `áéíóúüñ` por `aeiouun`. Ordenar resultados por coincidencia de prefijo en marca, luego modelo, luego generación.

- [ ] **Step 4: Verificar.** Run: `flutter test test/data/catalog_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: embedded car catalog and search"`

---

### Task 6: Esquema de Supabase y RLS

**Files:**
- Create: `supabase/migrations/0001_init.sql`
- Create: `supabase/migrations/0002_rls.sql`
- Create: `docs/ops/verify-rls.md`

**Interfaces:**
- Produces: tablas `cars`, `profiles`, `entries`, `sightings`, `car_submissions` tal como están en la spec §9, todas con RLS activo.

- [ ] **Step 1: Escribir `0001_init.sql`** copiando el DDL de la spec §9, añadiendo `alter table ... enable row level security;` en cada tabla de usuario.

- [ ] **Step 2: Escribir `0002_rls.sql`** con las políticas: `cars` lectura pública; `entries`/`sightings`/`car_submissions` solo `auth.uid() = user_id` para select/insert/update/delete.

- [ ] **Step 3: Verificar con la clave anónima**

Run (desde `docs/ops/verify-rls.md`, con `curl` y la anon key):
```bash
curl -s "$SUPABASE_URL/rest/v1/entries?select=*" -H "apikey: $ANON" -H "Authorization: Bearer $ANON"
```
Expected: `[]` y nunca filas de otro usuario.

- [ ] **Step 4: Verificar que un insert ajeno falla**

Expected: HTTP 403 o violación de política, no un insert correcto.

- [ ] **Step 5: Commit.** `git commit -m "feat: supabase schema with row level security"`

---

### Task 7: La carta cinematográfica

**Files:**
- Create: `paddock/lib/ui/card/car_card.dart`
- Create: `paddock/lib/ui/card/car_card_shader.dart` (placeholder sin shader en esta tarea)
- Test: `paddock/test/ui/car_card_test.dart`
- Create: `paddock/test/goldens/car_card_legendary.png`

**Interfaces:**
- Consumes: `Car`, `rarityColor`, `formatPrice`.
- Produces: `class CarCard extends StatelessWidget { const CarCard({required Car car, required Currency currency, this.width = 286}); }`

- [ ] **Step 1: Test que falla**

```dart
testWidgets('la carta muestra marca, modelo, precio y borde de rareza', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: CarCard(car: f40, currency: Currency.eur))));
  expect(find.text('FERRARI'), findsOneWidget);
  expect(find.text('F40'), findsOneWidget);
  expect(find.text('1.2M €'), findsOneWidget);
  final box = tester.widget<Container>(find.byKey(const Key('card-border')));
  expect((box.decoration as BoxDecoration).border!.top.color, rarityColor(RarityTier.legendary));
});

testWidgets('sin precio, no hay línea de precio', (tester) async {
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: CarCard(car: carSinPrecio, currency: Currency.eur))));
  expect(find.byKey(const Key('card-price')), findsNothing);
  expect(find.textContaining('null'), findsNothing);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/ui/car_card_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar** la composición de la spec §11: borde 2 px, fondo radial, píldora de rareza, contador `posición / total`, marca en mayúsculas con tracking, modelo condensado, fila de datos, precio verde con glow. El render se dibuja con `Image.network` a `renderPath` y, si es nulo, un `Container` con la foto del usuario o un placeholder "sin render".

- [ ] **Step 4: Verificar.** Run: `flutter test test/ui/car_card_test.dart`. Expected: PASS.

- [ ] **Step 5: Golden test.** Run: `flutter test --update-goldens test/ui/car_card_test.dart` y revisar la imagen a ojo antes de commitear.

- [ ] **Step 6: Commit.** `git commit -m "feat: cinematic car card"`

---

### Task 8: Garaje

**Files:**
- Create: `paddock/lib/data/garage_repository.dart`
- Create: `paddock/lib/ui/garage/garage_screen.dart`
- Test: `paddock/test/ui/garage_test.dart`

**Interfaces:**
- Consumes: `CarCard`, `Catalog`.
- Produces: `class GarageEntry { final String carId; final DateTime firstSeenAt; final int sightingCount; }`; `class GarageRepository { Future<List<GarageEntry>> all(); Future<void> add(String carId); Future<void> addSighting(String carId, {required DateTime takenAt, double? lat, double? lng}); num totalValueEur(); }`

- [ ] **Step 1: Test que falla**

```dart
test('el valor total suma solo coches con precio', () async {
  final repo = GarageRepository.inMemory();
  await repo.add('ferrari-f40-1987');   // 1.2M
  await repo.add('seat-ibiza-2017');     // 12k
  await repo.add('coche-sin-precio');    // null
  expect(repo.totalValueEur(), 1212000);
});

testWidgets('el garaje vacío invita a escanear', (tester) async {
  await tester.pumpWidget(const PaddockApp(initialGarage: []));
  expect(find.text('Scan a car'), findsOneWidget);
  expect(find.byType(CarCard), findsNothing);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/ui/garage_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar** grid de 2 columnas con las cartas, cabecera con valor total formateado, filtro por rareza y estado vacío con el CTA.

- [ ] **Step 4: Verificar.** Run: `flutter test test/ui/garage_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: garage grid with total value"`

---

### Task 9: Buscador

**Files:**
- Create: `paddock/lib/ui/search/search_screen.dart`
- Test: `paddock/test/ui/search_test.dart`

**Interfaces:**
- Consumes: `Catalog.search`, `CarCard`.
- Produces: `class SearchScreen extends StatefulWidget { const SearchScreen({required Catalog catalog}); }`

- [ ] **Step 1: Test que falla**

```dart
testWidgets('buscar sin conexión devuelve resultados del catálogo embebido', (tester) async {
  await tester.pumpWidget(MaterialApp(home: SearchScreen(catalog: offlineCatalog)));
  await tester.enterText(find.byType(TextField), 'golf');
  await tester.pump();
  expect(find.textContaining('Golf'), findsWidgets);
});

testWidgets('una búsqueda sin resultados explica que se puede añadir', (tester) async {
  await tester.pumpWidget(MaterialApp(home: SearchScreen(catalog: offlineCatalog)));
  await tester.enterText(find.byType(TextField), 'zzzz');
  await tester.pump();
  expect(find.text('No está en el catálogo. Puedes añadirlo.'), findsOneWidget);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/ui/search_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar** con debounce de 200 ms, lista de resultados con miniatura y acceso a la ficha completa.

- [ ] **Step 4: Verificar.** Run: `flutter test test/ui/search_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: offline search"`

---

### Task 10: Escanear

**Files:**
- Create: `supabase/functions/identify/index.ts`
- Create: `paddock/lib/data/scan_service.dart`
- Create: `paddock/lib/ui/scan/scan_screen.dart`
- Create: `paddock/lib/ui/scan/confirm_screen.dart`
- Test: `paddock/test/data/scan_service_test.dart`
- Test: `paddock/test/ui/confirm_test.dart`

**Interfaces:**
- Produces: `class CarCandidate { final Car car; final double confidence; }`
- Produces: `class ScanService { Future<List<CarCandidate>> identify(Uint8List jpegOrWebp); }` — lanza `ScanUnavailable` en timeout >8 s, error de red o cupo agotado.
- Produces: `class ScanUnavailable implements Exception { final ScanUnavailableReason reason; }`

- [ ] **Step 1: Test que falla**

```dart
test('devuelve como máximo 3 candidatas ordenadas por confianza', () async {
  final svc = ScanService(client: FakeClient.threeResults());
  final r = await svc.identify(fakePhoto);
  expect(r.length, 3);
  expect(r.first.confidence, greaterThanOrEqualTo(r.last.confidence));
});

test('un timeout lanza ScanUnavailable y no propaga la excepción cruda', () async {
  final svc = ScanService(client: FakeClient.slow(Duration(seconds: 9)));
  expect(() => svc.identify(fakePhoto), throwsA(isA<ScanUnavailable>()));
});

test('una foto sin coche devuelve lista vacía, no un error', () async {
  final svc = ScanService(client: FakeClient.noCar());
  expect(await svc.identify(fakePhoto), isEmpty);
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/data/scan_service_test.dart`. Expected: FAIL.

- [ ] **Step 3: Edge Function.** Recibe `{image_base64}`, llama a Gemini con `responseSchema` pidiendo `{is_car: bool, make, model, year, confidence, alternatives[]}`, cruza contra `cars` con `similarity()` de Postgres y devuelve hasta 3 `{car_id, confidence}`. Sin clave en el cliente.

- [ ] **Step 4: Cliente.** Comprimir a 1024 px WebP q80 antes de enviar. Timeout 8 s.

- [ ] **Step 5: Verificar.** Run: `flutter test test/data/scan_service_test.dart`. Expected: PASS.

- [ ] **Step 6: Pantalla de confirmación.** Tres cartas candidatas con su porcentaje, botón "no es ninguno" que lleva al buscador, y texto de caída cuando `ScanUnavailable`.

- [ ] **Step 7: Test de confirmación**

```dart
testWidgets('sin resultados muestra el camino manual', (tester) async {
  await tester.pumpWidget(MaterialApp(home: ConfirmScreen(candidates: [], onManual: () {})));
  expect(find.text('No he encontrado un coche.'), findsOneWidget);
  expect(find.text('Buscar a mano'), findsOneWidget);
});
```

- [ ] **Step 8: Verificar.** Run: `flutter test test/ui/confirm_test.dart`. Expected: PASS.

- [ ] **Step 9: Commit.** `git commit -m "feat: scan pipeline with manual fallback"`

---

### Task 11: Cuentas

**Files:**
- Create: `paddock/lib/data/auth_repository.dart`
- Create: `paddock/lib/ui/auth/auth_sheet.dart`
- Test: `paddock/test/data/auth_test.dart`

**Interfaces:**
- Produces: `class AuthRepository { Future<void> ensureAnonymous(); Future<void> signInWithGoogle(); Future<void> signInWithEmail(String email, String password); Future<void> linkAnonymousToEmail(String email, String password); bool get isAnonymous; }`

- [ ] **Step 1: Test que falla**

```dart
test('el invitado conserva su garaje al convertirse en cuenta', () async {
  final auth = AuthRepository.fake();
  await auth.ensureAnonymous();
  await garage.add('ferrari-f40-1987');
  await auth.linkAnonymousToEmail('a@b.com', 'secreto123');
  expect(auth.isAnonymous, isFalse);
  expect(await garage.all(), hasLength(1));
});
```

- [ ] **Step 2: Verificar que falla.** Run: `flutter test test/data/auth_test.dart`. Expected: FAIL.

- [ ] **Step 3: Implementar** con `signInAnonymously()` al arrancar y `linkIdentity`/`updateUser` para la conversión.

- [ ] **Step 4: Verificar.** Run: `flutter test test/data/auth_test.dart`. Expected: PASS.

- [ ] **Step 5: Commit.** `git commit -m "feat: anonymous auth with upgrade path"`

---

### Task 12: APK y publicación

**Files:**
- Create: `.github/workflows/release.yml`
- Create: `docs/ops/build-apk.md`
- Create: `README.md`
- Create: `.gitignore` (ampliar)

**Interfaces:**
- Produces: APK firmado en GitHub Releases al empujar un tag `v*`.

- [ ] **Step 1: Generar keystore y guardarla en secrets** (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, `ANDROID_STORE_PASSWORD`).

- [ ] **Step 2: `key.properties` leído desde variables de entorno**, nunca commiteado.

- [ ] **Step 3: Workflow** que en `push: tags: v*` ejecuta `flutter build apk --release --split-per-abi` y sube los APK al release.

- [ ] **Step 4: Verificar**

Run: `git tag v0.1.0; git push origin v0.1.0`
Expected: release con `app-arm64-v8a-release.apk` descargable e instalable.

- [ ] **Step 5: Cron anti-suspensión de Supabase**

Añadir al mismo workflow un `schedule: cron '0 6 */3 * *'` que haga un `select 1` contra Supabase.

- [ ] **Step 6: Commit.** `git commit -m "ci: signed apk release pipeline"`

---

## Self-review

**Cobertura de la spec:**
- §9 modelo de datos → Task 6.
- §10.1 primera vez sin cuenta → Tasks 10, 11.
- §10.2 mismo coche dos veces → Task 8 (`addSighting`, índice único).
- §10.3 buscador → Task 9.
- §11 carta → Task 7.
- §12 2.5D → **no cubierto en este plan**. El shader entra en un plan posterior; esta tarea 7 deja el hueco con `car_card_shader.dart`.
- §13 rareza → Tasks 2 y 5.
- §14 seguridad → Task 6.
- §15 i18n → Task 4.
- §6 0 €, Android solo, sin paywall → Global Constraints.

**Hueco conocido:** el shader 2.5D y la generación por lotes de renders no están en este plan. Van en `2026-11-06-paddock-renders.md`, después de que la carta se vea bien con imagen estática.
