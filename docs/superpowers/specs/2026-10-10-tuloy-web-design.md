# Tuloy Web (Staff and Admin) — Design

Date: 2026-10-10 · Status: draft for review

## Goal

Run Tuloy's Staff and Admin areas in a browser, as a Flutter web target of the
existing `tuloy_app`, talking to the existing `tuloy-api`. Guests on web see a
placeholder pointing them to the mobile app. Delivered as small pull requests
to `junixpaul/Tuloy`.

Success: a staff or admin user signs in on desktop Chrome and uses every Staff
and Admin screen (including the full admin catalog) with a desktop layout. The
mobile app is unchanged. `flutter analyze`, `flutter test` and the API tests pass.

## Decisions made

- Approach A: add `web/` to `tuloy_app` (no separate web app, no shared-package refactor).
- Phase 1 covers Staff and Admin, including the full admin catalog (rooms, rates,
  blocks, services, restaurant/menu/tables/QR, payments, reports, staff, loyalty,
  content, hotel settings, audit).
- Guest screens are out of scope on web; guests get a placeholder screen.

## Out of scope (phase 1)

Guest web flows, QR scanning on web, WebSocket live updates (polling stays),
httpOnly-cookie auth, a full desktop redesign of every form.

## Design

1. **Web bootstrap.** `flutter create --platforms=web .` in `tuloy_app`; only `web/`
   is added. Manifest and icons come from `assets/logo/`. `API_URL` stays a
   `--dart-define`; add a web-appropriate default in `lib/core/config.dart`.
2. **Adaptive shell** (`lib/core/adaptive.dart`). A `Breakpoints` helper (wide >= 840 px)
   and an `AdaptiveScaffold`: navigation rail when wide, current layout when narrow.
   Staff and Admin home screens become rail destinations.
3. **Table views.** A small `DataTableView` for Reservations, Payments, Audit and
   Staff on wide screens; stacked cards remain on narrow screens.
4. **Deep-link safety.** Routes that pass objects via `extra` (`rooms/type`,
   `services/edit`, `content/edit`, and the guarded `rooms/rates`, `restaurant/menu`)
   lose `extra` on browser refresh. Unguarded edit routes would silently open as
   "create new". Change them to id-based paths that load the item from the API.
5. **Guest placeholder.** In `redirectFor` (`lib/app/router.dart`), when running on
   web and the role is guest, redirect to a "Please use the Tuloy mobile app" screen.
   Pure function; unit-tested.
6. **API CORS.** `tuloy-api/src/main.ts` enables CORS from a `CORS_ORIGINS`
   (comma-separated) allowlist; default is localhost origins in development only.
   No wildcard. Document in `.env.example`.
7. **CI.** Add `flutter build web` to `.github/workflows/ci.yml`.

## Data flow

Unchanged: same `/v1` endpoints, bearer access tokens (15 min), rotating refresh
tokens (30 days). Existing behavior already web-safe: photo upload uses
`readAsBytes()`; CSV export copies to clipboard.

## Errors

Reuse `Failure`. Add an explicit "cannot reach the server" message for web, since
CORS and network failures are indistinguishable to the browser.

## Testing

- Unit: `redirectFor` (guest on web -> placeholder; roles unchanged on mobile); breakpoints.
- Widget: `AdaptiveScaffold` at 400 px and 1200 px.
- API: allowed origin receives CORS headers; disallowed origin does not.
- Manual: API + web in Chrome as `staff@tuloy.test` and `admin@tuloy.test`, every
  screen at desktop width, plus a browser refresh on each edit screen.
- Existing `flutter analyze` / `flutter test` / `npm test` stay green.

## Known limits

- Tokens live in browser storage on web (weaker than mobile secure storage); mitigated
  by short access tokens and refresh rotation. Cookie auth is a possible later API change.
- Large first-load bundle; poor SEO (irrelevant for a staff dashboard).
- No QR scanning on web; no live updates (polling).

## Delivery as PRs

1. Web bootstrap + CORS + CI.
2. Adaptive shell + guest placeholder.
3. Table views for Reservations, Payments, Audit, Staff.
4. Deep-link fixes for admin edit screens.
5. Docs: README "Run on web" section.
