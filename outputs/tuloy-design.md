# Tuloy — Design Pack v1

Source of truth: `tuloy-claude-pro-brief.md`. Database schema: `schema.prisma` (same folder).
Scope: Flutter mobile app (Guest / Staff / Admin roles) + NestJS API. No web project this phase.

Contents
1. User flows and screen inventory
2. Database schema (summary — full file is `schema.prisma`)
3. REST / WebSocket API contract
4. Project structure (Flutter + NestJS)
5. Phased implementation tickets
6. Open decisions (hotel policy / integrations)

---

## 1. User flows and screen inventory

### 1.1 Key flows

**Booking (guest)**
Search (dates, guests) → results → room type detail → add-ons → guest details → price & policy summary → `POST /holds` (15-min hold) → pay (gateway sheet) → webhook confirms → Confirmation screen + push/email/SMS.
Hold expires → inventory released → guest sees "Hold expired, search again".
Hotel uses staff approval → reservation `PENDING` → staff approves/declines → guest notified; decline releases nights and refunds.

**Check-in → stay → check-out**
Staff marks `CHECKED_IN` → Wi-Fi credential issued (valid until checkout) → guest My Stay shows Wi-Fi, guide, services, chat → staff marks `CHECKED_OUT` → Wi-Fi revoked, folio closed, invoice sent, loyalty points earned.

**Service request**
Services list (published only) → service detail (price, ETA, hours) → dynamic form (fields from `Service.fields`) → options → payment method → submit (idempotency key) → status timeline (from snapshot `statusSteps`).
Staff: task appears in queue → accept/assign → step updates → complete. QUOTE services: staff sets price → guest accepts/pays → continue.

**Restaurant QR**
Scan QR → `GET /qr/:token` resolves outlet+table (or "Invalid/retired code") → table label shown → menu → cart → allergy notes → review screen → explicit **Submit order** → POS/kitchen or staff queue → live status.
Staff can correct table or cancel with reason.

**Chat**
Guest opens chat from My Stay / a booking / a service request → conversation carries that context → staff sees it in inbox → real-time over WebSocket, push when app is backgrounded.

**Admin: publish a service**
New service (DRAFT) → fill info, translations, schedule, pricing, payment methods, form fields, department, steps, policies, loyalty → **Publish** → API validates required fields → PUBLISHED (appears in guest app without a release). Pause/edit anytime; edits bump version, existing orders keep their snapshot.

### 1.2 Screen inventory

Shared (all roles)
| # | Screen |
|---|---|
| S1 | Splash / language picker (first run) |
| S2 | Sign in (email/phone + password) |
| S3 | Sign up |
| S4 | Forgot / reset password (OTP) |
| S5 | Settings: language, notifications, profile, sign out |
| S6 | Notifications inbox |
| S7 | Chat thread |

Guest
| # | Screen |
|---|---|
| G1 | Home (current stay card, search, services shortcut, promos) |
| G2 | Search (dates, guests) |
| G3 | Results + filters (price, amenities, room type) |
| G4 | Room type detail (photos, amenities, policies) |
| G5 | Add-ons |
| G6 | Guest details |
| G7 | Review & pay (price breakdown, policy, hold timer) |
| G8 | Payment result / confirmation |
| G9 | My bookings (upcoming / past) |
| G10 | Booking detail (status, cancel, invoice) |
| G11 | My Stay (check-in/out info, Wi-Fi, guide, services, chat, feedback) |
| G12 | Wi-Fi access (one-tap connect, QR/manual fallback) |
| G13 | Hotel guide |
| G14 | Services catalog |
| G15 | Service detail + dynamic request form |
| G16 | Service request status timeline |
| G17 | QR scanner |
| G18 | Restaurant menu (table-confirmed) |
| G19 | Cart + allergy notes + review & submit |
| G20 | Order status |
| G21 | Invoice / receipt |
| G22 | Loyalty: balance, tier, history, rewards, redeem |
| G23 | Feedback form |
| G24 | Chat list |

Staff
| # | Screen |
|---|---|
| T1 | Dashboard (arrivals, departures, pending bookings, unread chats, urgent tasks) |
| T2 | Booking queue / search |
| T3 | Booking detail (approve/decline, notes, status history, check-in/out/no-show) |
| T4 | Task queue (mine / department / unassigned) |
| T5 | Task detail (accept, assign, step update, quote, escalate, complete) |
| T6 | Restaurant order queue (by outlet/table) |
| T7 | Order detail (status, table correction, cancel) |
| T8 | Chat inbox |
| T9 | My leave (apply, history) |

Admin (inside the same app, ADMIN role)
| # | Screen |
|---|---|
| A1 | Admin dashboard (occupancy, arrivals/departures, pending, service load, daily revenue/balance, alerts) |
| A2 | Hotel settings (policies, tax, currency, languages) |
| A3 | Room types list / edit (photos, amenities, translations) |
| A4 | Rooms list / edit |
| A5 | Rates calendar (per-date price) |
| A6 | Inventory blocks |
| A7 | Reservations calendar / list |
| A8 | Reservation detail (all staff actions + payments, refunds, invoice, audit) |
| A9 | Payments & refunds list |
| A10 | Services list (draft / published / paused) |
| A11 | Service builder (stepped form + publish checklist) |
| A12 | Outlets & tables (generate / retire QR) |
| A13 | Menu items |
| A14 | Staff users, roles, departments, permissions |
| A15 | Leave approvals |
| A16 | Guests & loyalty (ledger, adjust with reason, rewards, tiers) |
| A17 | Content: guides, promotions, notification templates |
| A18 | Reports (occupancy, revenue, bookings, payments, services, restaurant, loyalty, feedback) + CSV export |
| A19 | Integrations (payment, email/SMS/push, Wi-Fi, POS/PMS, webhooks) |
| A20 | Audit log |

---

## 2. Database schema (summary)

Full Prisma schema: `schema.prisma`. Key decisions:

- **Double-booking guard is a DB constraint.** `RoomNight` has one row per room per night with primary key `(roomId, date)`. Holds, bookings and admin blocks all write there. A second sale of the same night fails at the database, not in app code. Holds carry `holdExpiresAt`; the booking transaction deletes expired holds before inserting.
- **Translations as JSON** `{ en, fil, ceb }` on hotel-authored content (room types, services, menu, guides, templates). Fallback to `Hotel.defaultLocale`. Static UI text lives in Flutter ARB files.
- **Immutable snapshots.** `Reservation.priceSnapshot`, `ServiceRequest.snapshot`, `RestaurantOrder.items` hold price/tax/policy at order time.
- **Idempotency.** `idempotencyKey` is unique on reservations, payments, service requests, restaurant orders. `PaymentProviderEvent (provider, providerEventId)` is unique, so webhooks are processed once.
- **Loyalty is a ledger.** `LoyaltyTransaction` rows are never edited. `LoyaltyAccount.balance` is a cache. Unique `(kind, sourceType, sourceId)` blocks double-earn.
- **Folio.** `InvoiceLine` collects room, service, restaurant room-charge, payments, refunds, redemptions per reservation.
- **QR tokens.** Random opaque token in the QR; only its hash is stored. Retire with `revokedAt`.
- **RBAC.** `Membership(userId, hotelId, role, permissions[])`. Role gates the app area; permission strings gate actions (`booking.approve`, `refund.create`, `loyalty.adjust`, `service.publish` ...). Enforced in the API.
- **Status history.** One `StatusEvent` table for reservations, service requests, restaurant orders.
- **AuditLog** is append-only for every staff/admin mutation and money movement.
- Every hotel-owned row has `hotelId`.

---

## 3. API contract

Base: `/v1`. JSON. Auth: `Authorization: Bearer <access JWT>` (15 min); refresh token (30 days, rotated on every use).
Header `Accept-Language: en|fil|ceb` selects translated content. Header `Idempotency-Key` is **required** on every POST that creates a booking, payment, refund, service request or order.
Errors: `{ "error": { "code": "ROOM_UNAVAILABLE", "message": "...", "details": {} } }` — `message` is localized; `code` is stable.
Pagination: `?cursor=&limit=` → `{ items, nextCursor }`.
Access column: **P** public, **G** guest (own data only), **S** staff (+ permission), **A** admin.

### 3.1 Auth & profile
| Method | Path | Access | Notes |
|---|---|---|---|
| POST | /auth/register | P | email or phone, password, fullName, locale |
| POST | /auth/login | P | → access, refresh, user, memberships |
| POST | /auth/refresh | P | rotates refresh; reuse of an old token revokes the family |
| POST | /auth/logout | G | revokes refresh family |
| POST | /auth/otp/request | P | password reset / verification |
| POST | /auth/password/reset | P | otp + new password |
| GET / PATCH | /me | G | profile, locale, notifyPrefs |
| POST / DELETE | /me/push-tokens | G | FCM/APNs token |

### 3.2 Hotel, rooms, availability
| Method | Path | Access | Notes |
|---|---|---|---|
| GET | /hotels/:hotelId | P | info, policies, locales |
| GET | /hotels/:hotelId/availability | P | `?checkIn&checkOut&adults&children&amenities&maxPrice` → room types with nightly prices and rooms left |
| GET | /room-types/:id | P | detail |
| POST/PATCH/DELETE | /admin/room-types[/:id] | A | |
| POST/PATCH/DELETE | /admin/rooms[/:id] | A | |
| PUT | /admin/room-types/:id/rates | A | `[{date, price}]` |
| POST / DELETE | /admin/inventory-blocks | A | block rooms/dates |

### 3.3 Booking
| Method | Path | Access | Notes |
|---|---|---|---|
| POST | /holds | G | `{hotelId, roomTypeId, checkIn, checkOut, adults, children, addOns}` → `{reservationId, expiresAt, priceSnapshot}`; 409 `ROOM_UNAVAILABLE` |
| POST | /reservations/:id/pay | G | `{type: DEPOSIT|FULL}` → gateway checkout URL / client secret |
| GET | /me/reservations | G | |
| GET | /reservations/:id | G/S | |
| POST | /reservations/:id/cancel | G/S | applies policy; triggers refund if due |
| GET | /staff/reservations | S | `?status&date&q` |
| POST | /staff/reservations/:id/approve · /decline | S `booking.approve` | |
| POST | /staff/reservations/:id/check-in · /check-out · /no-show | S | writes StatusEvent; check-in issues Wi-Fi |
| PATCH | /staff/reservations/:id/notes | S | internal |
| POST | /staff/reservations/:id/move-room | S | reassign RoomNights |

### 3.4 Payments & invoices
| Method | Path | Access | Notes |
|---|---|---|---|
| POST | /webhooks/payments/:provider | P (signature-verified) | only path that marks a payment SUCCEEDED |
| GET | /reservations/:id/invoice | G/S | folio lines + totals; `?format=pdf` |
| GET | /admin/payments | A | filters |
| POST | /admin/payments/:id/refunds | A `refund.create` | `{amount, reason}` |

### 3.5 Services
| Method | Path | Access | Notes |
|---|---|---|---|
| GET | /hotels/:hotelId/services | P | published only, localized |
| GET | /services/:id | P | incl. options, form fields |
| POST | /service-requests | G | `{serviceId, reservationId?, optionIds, answers, scheduledFor, paymentMethod}`; ROOM_CHARGE only with in-house reservation |
| GET | /me/service-requests · /service-requests/:id | G | |
| POST | /service-requests/:id/accept-quote · /cancel | G | |
| GET | /staff/tasks | S | `?scope=mine|department|unassigned&status` |
| POST | /staff/tasks/:id/accept · /assign · /step · /quote · /escalate · /complete | S | `step` must be the next item in the snapshot's statusSteps |
| CRUD | /admin/services[/:id] · /admin/services/:id/options | A | |
| POST | /admin/services/:id/publish · /pause | A `service.publish` | 422 lists missing required fields |

### 3.6 Restaurant
| Method | Path | Access | Notes |
|---|---|---|---|
| GET | /qr/:token | P | → `{outlet, table, menu}`; 404 `QR_INVALID` for unknown/revoked; rate-limited |
| POST | /restaurant-orders | G or anonymous with token | `{token, items[{menuItemId, qty, notes}], allergyNotes, paymentMethod, reservationId?}` |
| GET | /restaurant-orders/:id | G | |
| GET | /staff/restaurant-orders | S | `?outletId&status` |
| POST | /staff/restaurant-orders/:id/status · /move-table · /cancel | S | |
| CRUD | /admin/outlets · /admin/tables · /admin/menu-items | A | |
| POST | /admin/tables/:id/qr | A | issues new token (returns it once), revokes old |

### 3.7 Chat
| Method | Path | Access | Notes |
|---|---|---|---|
| POST | /conversations | G | `{reservationId?, serviceRequestId?}` (returns existing open one if any) |
| GET | /conversations · /conversations/:id/messages | G/S | |
| POST | /conversations/:id/messages | G/S | REST fallback; normally via WS |

### 3.8 Wi-Fi, loyalty, feedback, content, notifications
| Method | Path | Access | Notes |
|---|---|---|---|
| GET | /reservations/:id/wifi | G | credential + connect payload (in-house only) |
| GET | /me/loyalty | G | balance, tier, history |
| GET | /hotels/:hotelId/rewards | P | |
| POST | /me/loyalty/redeem | G | `{rewardId, reservationId}` |
| POST | /admin/loyalty/:accountId/adjust | A `loyalty.adjust` | reason required |
| POST | /feedback | G | |
| GET | /hotels/:hotelId/content | P | `?kind=guide|promotion` |
| CRUD | /admin/content · /admin/notification-templates | A | |
| GET | /me/notifications | G/S | inbox |

### 3.9 Staff ops, reports, settings, audit
| Method | Path | Access |
|---|---|---|
| POST / GET | /me/leave | S |
| GET / POST | /admin/leave · /admin/leave/:id/decide | A |
| CRUD | /admin/staff · /admin/departments | A |
| GET | /staff/dashboard · /admin/dashboard | S / A |
| GET | /admin/reports/:report | A — `occupancy|revenue|bookings|payments|services|restaurant|loyalty|feedback`, `?from&to&format=json|csv` |
| GET / PATCH | /admin/settings · /admin/integrations | A |
| GET | /admin/audit-logs | A |

### 3.10 WebSocket (Socket.IO, namespace `/rt`)
Connect with `auth: { token }`. The server joins rooms automatically: `user:{id}`, and for staff `hotel:{id}:staff`, `dept:{id}`, `outlet:{id}`.

| Direction | Event | Payload |
|---|---|---|
| C→S | `chat.send` | `{conversationId, body, attachments, clientId}` → ack `{message}` |
| C→S | `chat.read` | `{conversationId, messageId}` |
| C→S | `chat.typing` | `{conversationId}` |
| S→C | `chat.message` | `{message}` |
| S→C | `reservation.updated` | `{id, status}` |
| S→C | `payment.updated` | `{id, status, reservationId}` |
| S→C | `service.updated` | `{id, status, eta}` |
| S→C | `task.created` / `task.updated` | staff rooms |
| S→C | `order.created` / `order.updated` | outlet room + guest |
| S→C | `dashboard.changed` | `{counter}` — staff/admin dashboards refetch |

Missed events are recovered by refetching REST on reconnect; no replay log.

---

## 4. Project structure

### 4.1 Flutter (`tuloy_app/`)

```text
lib/
  main.dart
  app/
    app.dart                 # MaterialApp.router, theme, locale
    router.dart              # go_router; role guards (guest/staff/admin shells)
    di.dart                  # Riverpod providers wiring data → domain
  core/
    errors/failure.dart      # Failure types mapped from API error codes
    network/api_client.dart  # dio + auth interceptor (refresh rotation) + Idempotency-Key
    network/realtime.dart    # socket_io_client wrapper
    l10n/                    # app_en.arb, app_fil.arb, app_ceb.arb (gen-l10n)
    theme/                   # design tokens, components
    security/secure_store.dart  # flutter_secure_storage for tokens
    utils/money.dart, dates.dart
  features/
    auth/
      domain/   entities/user.dart · repositories/auth_repository.dart · usecases/sign_in.dart ...
      data/     dto/ · auth_remote_source.dart · auth_repository_impl.dart
      presentation/ sign_in_screen.dart · auth_controller.dart
    booking/      (search, availability, hold, pay, my bookings)
    stay/         (my stay, wifi, guide, invoice, feedback)
    services/     (catalog, dynamic form, request status)
    restaurant/   (qr scan, menu, cart, order status)
    chat/
    loyalty/
    notifications/
    staff/        (dashboard, booking queue, tasks, orders, leave)
    admin/        (rooms, rates, reservations, payments, services builder, outlets, staff, loyalty, content, reports, settings, audit)
test/
  features/<feature>/domain/...   # use-case unit tests (pure Dart)
  features/<feature>/data/...     # adapter tests with mocked dio
integration_test/
  booking_flow_test.dart · qr_order_flow_test.dart · service_request_flow_test.dart
```

Rules
- `domain/` imports only Dart + `core/errors`. No Flutter, dio, Supabase, payment SDKs.
- One use case per business action that has a rule (book, cancel, submit order, redeem). Plain reads call the repository directly through a provider; no pass-through use-case classes.
- State: Riverpod (`AsyncNotifier`). One state manager across the app.
- Dynamic service form: one widget renders `Service.fields` (text, number, select, datetime, location, file, checkbox).
- Packages: `go_router`, `flutter_riverpod`, `dio`, `socket_io_client`, `flutter_secure_storage`, `intl`, `mobile_scanner`, `firebase_messaging`, `cached_network_image`, `sentry_flutter`, payment SDK of the chosen gateway (or WebView checkout).

### 4.2 NestJS (`tuloy-api/`)

```text
src/
  main.ts
  app.module.ts
  common/
    auth/            # JWT guard, @Roles, @Perm('refund.create') guard, current-user decorator
    hotel-scope/     # resolves hotelId from route/membership; every query filters by it
    idempotency/     # interceptor: Idempotency-Key → stored response replay (Redis, 24 h)
    i18n/            # pick(json, locale) with defaultLocale fallback; localized error messages
    audit/           # AuditService.log(); interceptor on staff/admin routes
    prisma/          # PrismaService
    errors/          # AppError(code) → HTTP mapping
  modules/
    auth/        controller · service · dto
    hotels/      rooms, room types, rates, blocks
    booking/
      domain/        pricing.ts · cancellation-policy.ts · status-transitions.ts   # pure, unit-tested
      booking.service.ts   # hold / confirm / cancel inside Prisma transactions
      booking.controller.ts · staff-booking.controller.ts
    payments/    gateway adapter (one per provider) · webhook controller · refunds
    invoices/
    services/    domain/publish-rules.ts · domain/order-snapshot.ts · catalog · requests · tasks
    restaurant/  qr · menu · orders · pos adapter
    chat/        gateway (Socket.IO) · service
    loyalty/     domain/earn-redeem.ts · ledger service
    wifi/        provider adapter (API / RADIUS / manual)
    notifications/ dispatcher (event → channels by prefs/severity) · BullMQ processors · providers
    staff/       departments · leave
    reports/
    content/
    admin-settings/
  jobs/          # BullMQ: expire-holds, send-notification, wifi-expire, nightly-reports, loyalty-expire
prisma/
  schema.prisma · migrations/ · seed.ts
test/
  booking.e2e-spec.ts  (concurrent hold → exactly one wins)
  payments-webhook.e2e-spec.ts (duplicate event processed once)
docker-compose.yml   # postgres, redis
```

Rules
- Modular monolith. A module = controller + service + Prisma. A `domain/` folder exists only where there are real rules (booking, payments, services, loyalty); everything else stays plain CRUD.
- Booking, payment, and refund writes run in one `prisma.$transaction` with status checks.
- External systems sit behind one adapter interface each: payment gateway, Wi-Fi, POS, SMS, email.

---

## 5. Phased implementation tickets

Size: S ≤ 2 days, M ≤ 1 week, L ≤ 2 weeks. "AC" = acceptance criteria.

### Phase 1 — Foundation
| ID | Ticket | Size | AC |
|---|---|---|---|
| F-1 | Design system + Figma prototype for G1–G11, T1–T5, A1, A7, A11 | L | Approved by PO; tokens exported |
| F-2 | NestJS skeleton, docker-compose (Postgres, Redis), Prisma schema + first migration + seed | M | `docker compose up` + `npm run seed` gives a working hotel with rooms |
| F-3 | Auth: register/login/refresh rotation/logout/OTP reset, RBAC guards | M | Refresh reuse revokes family (test); permission guard test |
| F-4 | Common: hotel scope, idempotency interceptor, audit interceptor, error codes, i18n picker | M | Replayed POST returns identical response |
| F-5 | Flutter skeleton: router + role shells, Riverpod, dio client with refresh, secure storage, Sentry | M | Sign in as each role lands in its shell |
| F-6 | Localization: ARB en/fil/ceb, language picker, `Accept-Language` header | S | Switching language updates UI and API content |
| F-7 | CI: GitHub Actions (lint, test, build APK/IPA, API image) + dev/staging envs | M | PR blocked on red tests |

### Phase 2 — Guest booking
| ID | Ticket | Size | AC |
|---|---|---|---|
| B-1 | Availability endpoint + pricing (RoomRate fallback to base price, tax, service charge) | M | Unit tests for pricing |
| B-2 | Hold + expiry job | M | 20 concurrent holds for the last room → exactly 1 succeeds (e2e) |
| B-3 | Payment adapter (chosen gateway), pay endpoint, signed webhook, PaymentProviderEvent dedupe | L | Duplicate webhook processed once; reservation CONFIRMED only via webhook |
| B-4 | Flutter G2–G8 search → pay → confirmation | L | Integration test against staging API |
| B-5 | My bookings + detail + cancel with policy and refund | M | Refund amount follows policy test table |
| B-6 | Notifications dispatcher: push (FCM), email, SMS sandbox; templates; delivery log; retries | M | Booking confirmation reaches all enabled channels |
| B-7 | My Stay + invoice (folio) + hotel guide + feedback | M | |

### Phase 3 — Staff operations
| ID | Ticket | Size | AC |
|---|---|---|---|
| T-1 | Staff dashboard (T1) + `dashboard.changed` WS refresh | M | |
| T-2 | Booking queue, approve/decline (permission), notes | M | Decline releases nights and triggers refund |
| T-3 | Check-in / check-out / no-show + StatusEvent history | S | Invalid transitions rejected |
| T-4 | Chat: WS gateway, conversations with context, push when backgrounded, guest + staff UI | L | Messages delivered live; history persists; original text kept |
| T-5 | Leave apply (staff) | S | |

### Phase 4 — Admin mobile
| ID | Ticket | Size | AC |
|---|---|---|---|
| A-1 | Room types, rooms, photos upload (S3/Supabase Storage) | M | |
| A-2 | Rates calendar + inventory blocks | M | Block makes rooms unavailable in search |
| A-3 | Reservations calendar/list + detail with payments, refunds, audit | M | Refund requires `refund.create` |
| A-4 | Admin dashboard: occupancy, arrivals/departures, daily revenue/balance | M | Numbers match report query |
| A-5 | Staff users, roles, departments, permissions; leave approvals | M | |
| A-6 | Audit log viewer | S | |

### Phase 5 — Services, restaurant, reporting
| ID | Ticket | Size | AC |
|---|---|---|---|
| S-1 | Service builder (A10–A11) + publish validation | L | Publishing with any missing required field returns 422 listing it |
| S-2 | Guest catalog + dynamic form renderer + request + status timeline | L | New service appears in app without release |
| S-3 | Staff task queue: accept/assign/step/quote/escalate/complete | M | Steps follow snapshot order |
| S-4 | Room charge eligibility + folio lines for services | S | Rejected without in-house reservation |
| R-1 | Outlets, tables, QR issue/retire, menu items | M | Retired token → `QR_INVALID` |
| R-2 | Guest QR scan → menu → cart → explicit submit → status | L | No order is created without the submit tap |
| R-3 | Staff restaurant queue + table correction + cancel | M | |
| R-4 | POS/kitchen adapter (if a POS is chosen) else staff queue only | M | |
| P-1 | Reports + CSV export (A18) | M | |

### Phase 6 — Loyalty, Wi-Fi, integrations, scale
| ID | Ticket | Size | AC |
|---|---|---|---|
| L-1 | Loyalty ledger: earn on checkout/completed paid service, reverse on refund, redeem, admin adjust | M | No double earn (unique constraint test) |
| L-2 | Rewards + tiers UI | M | |
| W-1 | Wi-Fi credential on check-in, revoke on checkout, provider adapter, QR/manual fallback | M | Access ends at checkout time |
| I-1 | PMS / channel manager / door lock adapters (per chosen vendors) | L each | |
| I-2 | Multi-property: hotel switcher for staff/admin, per-hotel config | M | |
| O-1 | AWS production (ECS, RDS Multi-AZ, ElastiCache, S3+CloudFront, WAF, Secrets Manager), backups + restore test, rollback runbook | L | Restore drill passes |

**MVP release gate** = Phases 1–4 + S-1…S-4 + O-1, plus: double-booking e2e, webhook dedupe, notification delivery, RBAC tests, audit logs, backups, monitoring, rollback verified.

---

## 6. Open decisions (needed before the related ticket starts)

| # | Decision | Blocks |
|---|---|---|
| 1 | Payment gateway (PayMongo / Xendit / Stripe) and methods (card, GCash, Maya, bank) | B-3 |
| 2 | Instant confirmation or staff approval for bookings (per room type?) | B-3, T-2 |
| 3 | Deposit %, cancellation windows, refund rules, no-show charge | B-5 |
| 4 | Hold duration (default used here: 15 min) | B-2 |
| 5 | Single hotel or several at launch | I-2 |
| 6 | Staff roles and approval limits (who can refund, how much) | A-5 |
| 7 | Services at launch and which need staff approval | S-1 |
| 8 | Restaurant: dine-in QR only, or also room delivery / table reservation; pay now, room charge, or both | R-2 |
| 9 | POS / kitchen display vendor, if any | R-4 |
| 10 | Wi-Fi equipment/provider and integration type (API / RADIUS / PMS) | W-1 |
| 11 | Loyalty earn rate, redemption value, expiry, tiers | L-1 |
| 12 | Email/SMS providers and sender identities | B-6 |
| 13 | Who writes and approves fil/ceb translations | F-6 |
| 14 | Guest ID capture at check-in required? (privacy/retention rules) | T-3 |
