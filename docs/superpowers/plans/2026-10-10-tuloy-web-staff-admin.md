# Tuloy Web (Staff and Admin) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Run Tuloy's Staff and Admin areas in a browser as a Flutter web target of `tuloy_app`, with a desktop layout, and a placeholder for guests.

**Architecture:** Add `web/` to the existing Flutter app. A `ShellRoute` wraps `/staff` and `/admin` and shows a navigation rail when the window is >= 840 px wide (children unchanged, so mobile layout is untouched). The API gains an env-driven CORS allowlist. Edit screens that lose `extra` on browser refresh become id-based.

**Tech Stack:** Flutter 3.47 (stable, `D:\flutter\bin`) / Dart 3.13, Riverpod, go_router, dio; NestJS + Jest + supertest; GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-10-10-tuloy-web-design.md`

## Global Constraints

- Mobile behavior and layout must not change: `flutter analyze` (fails on infos), `flutter test`, and `npm test` in `tuloy-api` stay green after every task.
- Wide layout breakpoint: width >= 840 px.
- No wildcard CORS origin. Default allowlist is localhost origins in non-production only.
- Only add `web/`; do not regenerate or modify `ios/` or `android/`.
- New user-visible strings go in all three ARBs: `lib/l10n/app_en.arb`, `app_fil.arb`, `app_ceb.arb`; regenerate with `flutter gen-l10n`. Reuse existing keys (`adminHome`, `frontDesk`, `roomsAndRates`, `services`, `restaurant`, `payments`, `reports`, `staff`, `loyalty`, `content`, `hotelSettings`, `auditLog`, `reservations`, `tasks`, `leaveRequests`) where they exist.
- Run Flutter as `D:\flutter\bin\flutter` (not on PATH). Work on branch `feat/web-staff-admin`; one commit per task, ending with `Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>`.
- Demo logins (seed): `staff@tuloy.test`, `admin@tuloy.test`, password `ChangeMe123!` (`SEED_PASSWORD`).

## Review Focus

- Browser refresh on any admin edit screen must reopen the same item, never a blank "create new" form.
- A guest signed in on web who types `/staff` or `/admin` in the URL must land on the placeholder, not the staff area.
- A browser on a disallowed origin (including `null`/missing Origin from curl) gets no CORS allow header; a request with no Origin still works.
- Resizing the window across 840 px keeps the user on the same route (no redirect to home).
- API unreachable or CORS-blocked shows a readable "cannot reach server" message, not a raw exception.

## File Structure

- Create `tuloy-api/test/cors.spec.ts` — CORS behavior.
- Modify `tuloy-api/src/app.module.ts` (`setupApp`) — enable CORS from `CORS_ORIGINS`.
- Modify `tuloy-api/.env.example` — document `CORS_ORIGINS`.
- Create `tuloy_app/web/**` — via `flutter create`.
- Create `tuloy_app/lib/core/adaptive.dart` — `isWide`, `AdaptiveShell`, `DataTableView`.
- Create `tuloy_app/lib/features/settings/presentation/web_guest_screen.dart` — guest placeholder.
- Create `tuloy_app/lib/core/find_by_id.dart` — `FindById` widget.
- Modify `tuloy_app/lib/app/router.dart`, `lib/core/api.dart`, `lib/core/config.dart`, the admin/staff screens named in tasks, ARB files, `.github/workflows/ci.yml`, `README.md`.
- Tests: `tuloy_app/test/adaptive_test.dart`, `tuloy_app/test/widget_test.dart` (extend), `tuloy_app/test/find_by_id_test.dart`.

---

### Task 1: API CORS allowlist

**Files:**
- Create: `tuloy-api/test/cors.spec.ts`
- Modify: `tuloy-api/src/app.module.ts:72-78` (`setupApp`), `tuloy-api/.env.example`

**Interfaces:**
- Produces: `setupApp(app)` now also calls `app.enableCors(...)`; env `CORS_ORIGINS` (comma-separated exact origins). If unset and `NODE_ENV !== 'production'`, allowed origins are any `http://localhost:<port>` and `http://127.0.0.1:<port>`; if unset in production, none.

- [ ] **Step 1: Write failing tests** in `cors.spec.ts`, bootstrapped like `test/auth.spec.ts` (`Test.createTestingModule({ imports: [AppModule] })`, `setupApp`, `JOBS=off`). Cases, all `GET /v1/hotels/<any uuid>` or an `OPTIONS` preflight:
  - `CORS_ORIGINS='https://admin.example.com'`: `Origin: https://admin.example.com` → header `access-control-allow-origin` equals that origin; `Origin: https://evil.example.com` → header absent; request with no Origin → no CORS header and normal status (not blocked).
  - `CORS_ORIGINS` unset, `NODE_ENV='test'`: `Origin: http://localhost:51234` → allowed.
  - `NODE_ENV='production'`, `CORS_ORIGINS` unset: `Origin: http://localhost:51234` → header absent.
  - Preflight `OPTIONS` with `Access-Control-Request-Headers: authorization,idempotency-key,content-type` from an allowed origin → `access-control-allow-headers` includes `idempotency-key`.
- [ ] **Step 2: Run** `cd tuloy-api && npx jest test/cors.spec.ts` (needs Postgres from `docker compose up -d`). Expected: FAIL (no CORS headers).
- [ ] **Step 3: Implement** in `setupApp`: `app.enableCors({ origin: (origin, cb) => cb(null, isAllowed(origin)), allowedHeaders: ['Authorization','Content-Type','Idempotency-Key','Accept-Language'], credentials: false })` with a local `isAllowed(origin: string | undefined): boolean` that returns `false` for an undefined origin (no CORS header is added; the request itself is not blocked). Read env at call time, not module load, so tests can change it.
- [ ] **Step 4: Add to `.env.example`**: `# Comma-separated browser origins allowed to call this API (web app). Empty = localhost only in development, none in production` and `CORS_ORIGINS=`.
- [ ] **Step 5: Run** `npx jest test/cors.spec.ts` then `npm test`. Expected: all PASS.
- [ ] **Step 6: Commit** `feat(api): CORS allowlist from CORS_ORIGINS`.

---

### Task 2: Web bootstrap, build in CI

**Files:**
- Create: `tuloy_app/web/**`
- Modify: `tuloy_app/lib/core/config.dart`, `.github/workflows/ci.yml`

**Interfaces:**
- Produces: `flutter build web` succeeds; `apiUrl` default unchanged (`http://localhost:3000/v1` already works for local web).

- [ ] **Step 1:** `cd tuloy_app && D:\flutter\bin\flutter create --platforms=web .` then `git status`. Expected: only `web/` added. If it touched `ios/`, `android/`, `pubspec.yaml` beyond `web`, or `test/widget_test.dart`, `git checkout` those files (README note says the widget test name keeps `flutter create .` safe).
- [ ] **Step 2:** Edit `web/index.html` and `web/manifest.json`: title/name `Tuloy`, theme color `#0F6E6E`, description "Tuloy hotel staff and admin". Replace `web/icons/*` and `web/favicon.png` with resized `assets/logo/tuloy_icon.png` (192 and 512 px; maskable variants may reuse them).
- [ ] **Step 3:** `flutter pub get && flutter analyze && flutter test && flutter build web`. Expected: all succeed. If `flutter_secure_storage`, `mobile_scanner` or `image_picker` fails to compile for web, record the error and stop; fix by upgrading that package to a web-supporting version in `pubspec.yaml`.
- [ ] **Step 4:** Run the app: `flutter run -d chrome` with the API running; sign in as `admin@tuloy.test`. Expected: fails with a cross-origin error before Task 1's CORS is deployed; with `CORS_ORIGINS` unset in dev (Task 1) sign-in works. Confirm the admin home loads.
- [ ] **Step 5:** Add a CI step to the `app` job in `.github/workflows/ci.yml` after `flutter test`: `- run: flutter build web`.
- [ ] **Step 6: Commit** `feat(app): add web target and build it in CI`.

---

### Task 3: Guest placeholder on web

**Files:**
- Create: `tuloy_app/lib/features/settings/presentation/web_guest_screen.dart`
- Modify: `tuloy_app/lib/app/router.dart` (`redirectFor`, route list), ARBs, `tuloy_app/test/widget_test.dart`

**Interfaces:**
- Produces: `redirectFor({required String location, required bool languageChosen, required AsyncValue<User?> auth, bool isWeb = kIsWeb})`; route `/web-guest` → `WebGuestScreen` (const, no args); l10n keys `webGuestTitle`, `webGuestBody`.

- [ ] **Step 1: Write failing tests** in `widget_test.dart` using the existing `go` helper extended with `isWeb`:
  - guest (`_user(const [])`) with `isWeb: true`: `go('/guest')` → `'/web-guest'`; `go('/staff')` → `'/web-guest'`; `go('/admin')` → `'/web-guest'`; `go('/web-guest')` → null; `go('/settings')` → null.
  - guest with `isWeb: false`: `go('/web-guest')` → `'/guest'`; `go('/signin')` → `'/guest'` (unchanged behavior).
  - staff with `isWeb: true`: `go('/signin')` → `'/staff'`; `go('/web-guest')` → `'/staff'`.
  - unauthenticated with `isWeb: true`: `go('/guest')` → `'/signin'`.
- [ ] **Step 2: Run** `flutter test test/widget_test.dart`. Expected: FAIL (`isWeb` not a parameter).
- [ ] **Step 3: Implement** the new parameter. After computing `home`: if `isWeb && role == Role.guest`, return `null` for `/web-guest` and `/settings`, else `'/web-guest'`. `/web-guest` for any other situation falls through to `home`. Pass `isWeb: kIsWeb` default from `package:flutter/foundation.dart`. Add the route outside role subtrees.
- [ ] **Step 4: Implement `WebGuestScreen`** — brand logo, `webGuestTitle`, `webGuestBody`, a Settings button (`context.push('/settings')` for sign-out). Add the two strings to all three ARBs (en: "Guests, please use the Tuloy mobile app" / "Booking and stay features are available in the iOS and Android app. Staff and admins can sign in here."); run `flutter gen-l10n`.
- [ ] **Step 5: Run** `flutter analyze && flutter test`. Expected: PASS.
- [ ] **Step 6: Commit** `feat(app): guest placeholder on web`.

---

### Task 4: Adaptive shell (navigation rail)

**Files:**
- Create: `tuloy_app/lib/core/adaptive.dart`, `tuloy_app/test/adaptive_test.dart`
- Modify: `tuloy_app/lib/app/router.dart` (wrap `/staff` and `/admin` in `ShellRoute`s)

**Interfaces:**
- Produces in `adaptive.dart`:
  - `const double kWideBreakpoint = 840;`
  - `bool isWide(BuildContext context)` (true when `MediaQuery.sizeOf(context).width >= kWideBreakpoint`)
  - `class RailItem { const RailItem(this.icon, this.label, this.path); final IconData icon; final String label; final String path; }`
  - `class AdaptiveShell extends StatelessWidget { const AdaptiveShell({super.key, required this.items, required this.location, required this.child}); final List<RailItem> items; final String location; final Widget child; }` — narrow: returns `child`; wide: `Row[NavigationRail (selectedIndex = item whose path is the longest prefix of location, onDestinationSelected → context.go(path)), VerticalDivider, Expanded(child)]`.

- [ ] **Step 1: Write failing widget tests** in `adaptive_test.dart` (pump `MaterialApp.router` or plain `MaterialApp` with a `GoRouter` containing one `/a` and `/b` route inside an `AdaptiveShell`):
  - width 400: no `NavigationRail` found; child text found.
  - width 1200: `NavigationRail` found with the item labels; tapping label of item 2 navigates to its path.
  - location `/admin/rooms/type` selects the item with path `/admin/rooms` (longest prefix), not `/admin`.
  - resize 1200 → 400 → 1200 keeps the same location.
- [ ] **Step 2: Run** `flutter test test/adaptive_test.dart`. Expected: FAIL (file missing).
- [ ] **Step 3: Implement** the above in `adaptive.dart`.
- [ ] **Step 4: Wire into router.** Staff items (path → existing label key): `/staff` frontDesk, `/staff/reservations` reservations, `/staff/tasks` tasks, `/staff/orders` restaurant, `/staff/inbox` (existing inbox/chat label key; add `inbox` key to ARBs if none exists), `/staff/leave` leaveRequests. Admin items: `/admin` adminHome, `/admin/desk` frontDesk, `/admin/rooms` roomsAndRates, `/admin/services` services, `/admin/restaurant` restaurant, `/admin/payments` payments, `/admin/reports` reports, `/admin/staff` staff, `/admin/loyalty` loyalty, `/admin/content` content, `/admin/hotel` hotelSettings, `/admin/audit` auditLog. Wrap each of the existing top-level `/staff` and `/admin` `GoRoute`s in a `ShellRoute(builder: (c, s, child) => AdaptiveShell(items: ..., location: s.uri.path, child: child), routes: [thatGoRoute])`. Labels come from `AppLocalizations` so build the item lists inside the builder.
- [ ] **Step 5: Run** `flutter analyze && flutter test`, then manually: `flutter run -d chrome`, sign in as admin, widen/narrow the window, click every rail item. Expected: every item opens its screen; narrow shows the existing mobile layout.
- [ ] **Step 6: Commit** `feat(app): navigation rail for staff and admin on wide screens`.

---

### Task 5: Table views on wide screens

**Files:**
- Modify: `tuloy_app/lib/core/adaptive.dart`; `tuloy_app/lib/features/staff/staff_screens.dart` (`ReservationsQueueScreen`); `tuloy_app/lib/features/admin/admin_screens.dart` (`PaymentsScreen`, `AuditScreen`); `tuloy_app/lib/features/admin/admin_people_screens.dart` (`StaffAdminScreen`)
- Test: `tuloy_app/test/adaptive_test.dart`

**Interfaces:**
- Produces: `class DataTableView extends StatelessWidget { const DataTableView({super.key, required this.columns, required this.rows, this.onTap}); final List<String> columns; final List<List<String>> rows; final void Function(int index)? onTap; }` — header row, one row per entry, horizontally scrollable if too narrow, row tap calls `onTap(index)`.
- Consumes: `isWide(context)` from Task 4.

- [ ] **Step 1: Write failing tests**: `DataTableView` shows the column headers and cell texts; tapping the second row calls `onTap(1)`; empty `rows` renders headers only without error; a long cell string does not overflow (no exception in `tester.takeException()`).
- [ ] **Step 2: Run** `flutter test test/adaptive_test.dart`. Expected: FAIL.
- [ ] **Step 3: Implement `DataTableView`** (a `SingleChildScrollView` + `DataTable`, or a `Table`, with `onSelectChanged`/`InkWell` for taps).
- [ ] **Step 4: Use it** in the four screens: when `isWide(context)`, render `DataTableView` from the same already-loaded JSON (same fields the card shows, plus status), keeping the mobile list when narrow. Row tap does what the card tap does today. Pull-to-refresh/pollers stay.
- [ ] **Step 5: Run** `flutter analyze && flutter test`; manually check each of the four screens at 1200 px and 400 px.
- [ ] **Step 6: Commit** `feat(app): table layout for reservations, payments, audit and staff on wide screens`.

---

### Task 6: Refresh-safe edit routes

**Files:**
- Create: `tuloy_app/lib/core/find_by_id.dart`, `tuloy_app/test/find_by_id_test.dart`
- Modify: `tuloy_app/lib/app/router.dart` and the call sites that `context.push(...)` the affected routes in `admin_catalog_screens.dart` and `admin_screens.dart`

**Interfaces:**
- Produces: `class FindById extends ConsumerWidget { const FindById({super.key, required this.listPath, required this.id, required this.builder}); final String listPath; final String id; final Widget Function(BuildContext, J item) builder; }` — watches `getProvider(listPath)`, finds the map whose `'id'` equals `id` in `jsonList(...)`, shows a loader while loading, an error message with retry on failure, and a "not found" message if absent.
- Declare the `/new` routes before the `/:id` routes so `new` is not read as an id. Routes (all under `/admin`): `rooms/type/new` → `RoomTypeEditScreen()`; `rooms/type/:id` → `FindById('/admin/room-types', id, (_, t) => RoomTypeEditScreen(type: t))`; `rooms/:id/rates` → `FindById('/admin/room-types', ...)` → `RatesScreen(type: t)`; `restaurant/:id/menu` → `FindById('/admin/outlets', ...)` → `MenuAdminScreen(outlet: o)`; `services/new` → `ServiceEditScreen()`; `services/:id` → `ServiceEditScreen(id: id)`; `content/new` → `ContentEditScreen()`; `content/:id` → `FindById('/admin/content', ...)` → `ContentEditScreen(item: c)`.

- [ ] **Step 1: Write failing tests** in `find_by_id_test.dart` with a `ProviderScope` override of `getProvider(path)`: item present → builder called with it; id missing → "not found" text; provider error → error text; loading → progress indicator.
- [ ] **Step 2: Run** `flutter test test/find_by_id_test.dart`. Expected: FAIL (file missing).
- [ ] **Step 3: Implement `FindById`.** Reuse the existing error display widget in `lib/core/ui.dart` if there is one.
- [ ] **Step 4: Replace** the `extra`-based routes listed above in `router.dart` and update every `context.push('/admin/rooms/type', extra: t)`-style call to `context.push('/admin/rooms/type/${t['id']}')` (and `/new` for creates). Remove the now-unused `extra` redirects. After a save, the screens already pop back; keep that.
- [ ] **Step 5: Run** `flutter analyze && flutter test`. Then manually for each of the five edit screens: open an item, press browser refresh. Expected: same item reopens.
- [ ] **Step 6: Commit** `fix(app): id-based admin edit routes survive browser refresh`.

---

### Task 7: Photo upload works in the browser

**Files:**
- Modify: `tuloy_app/lib/core/api.dart:` `Api.upload`

**Interfaces:**
- Produces: `Future<String> Api.upload(String folder, List<int> bytes, String ext)` — same signature; body sent as `Uint8List.fromList(bytes)`.

- [ ] **Step 1:** Replace `data: Stream.fromIterable([bytes])` with `data: Uint8List.fromList(bytes)` (import `dart:typed_data`); keep the `Content-Length` and `Content-Type` headers.
- [ ] **Step 2:** `flutter analyze && flutter test`. Expected: PASS.
- [ ] **Step 3:** Manual (needs `docker compose up -d` MinIO): in Chrome as admin, open Rooms & rates → a room type → add a photo. Expected: upload succeeds and the photo key is saved; repeat on an Android emulator or note that mobile is unchanged in behavior (Dio sends `Uint8List` the same way).
- [ ] **Step 4: Commit** `fix(app): send upload body as bytes so it works on web`.

---

### Task 8: Server-unreachable message and docs

**Files:**
- Modify: `tuloy_app/lib/core/api.dart:~100` (where `Failure('NETWORK')` is created), the place that renders a `Failure` message (search `Failure` usages in `lib/core/ui.dart` / `lib/features/auth/presentation/widgets.dart`), ARBs, `README.md`

**Interfaces:**
- Produces: l10n key `cannotReachServer`; `NETWORK` failures render it (all screens that show failure messages).

- [ ] **Step 1: Write a failing test** that a `Failure('NETWORK')` rendered through the shared error widget shows the `cannotReachServer` text, not "NETWORK" or an exception string.
- [ ] **Step 2: Run** `flutter test`. Expected: FAIL.
- [ ] **Step 3: Implement**: add `cannotReachServer` to the three ARBs ("Can't reach the server. Check your connection, or ask your administrator to allow this website."); show it for `NETWORK`.
- [ ] **Step 4: Docs.** Add a "Run on web" section to `README.md`: `flutter run -d chrome` (and `--dart-define=API_URL=...`), `flutter build web` output in `build/web`, `CORS_ORIGINS` for deployed origins, production bucket CORS rule allowing `PUT` from the web origin, the token-storage note, and that guests see a placeholder on web.
- [ ] **Step 5: Final verification:** `flutter analyze && flutter test && flutter build web` and `cd ../tuloy-api && npm test`; manual pass in Chrome as `staff@tuloy.test` (all six rail items) and `admin@tuloy.test` (all twelve) at 1200 px and 400 px; sign in as `guest@tuloy.test` and confirm the placeholder; stop the API and confirm the unreachable message.
- [ ] **Step 6: Commit** `feat(app): unreachable-server message and web docs`.

---

## Self-review notes

- Spec coverage: bootstrap + CI (T2), adaptive shell (T4), table views (T5), deep links (T6), guest placeholder (T3), CORS (T1), upload (T7), errors + docs (T8). The "bulk of the pull requests" grouping in the spec maps to: PR1 = T1+T2, PR2 = T3+T4, PR3 = T5, PR4 = T6, PR5 = T7+T8.
- Known uncertainty: T5 names screens by class; if their field names make a table column unclear, choose the same fields the card shows.
