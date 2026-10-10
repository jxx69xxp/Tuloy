# Tuloy — Compact Implementation Brief

## Goal

Build **Tuloy**, a modern multilingual hotel platform:

- **Tuloy Guest**: Flutter iOS/Android app for guests.
- **Tuloy Staff**: Flutter iOS/Android staff experience (may share the same codebase, separated by role).
- **Tuloy Admin**: secure administrator role within the Flutter app for the initial release. A dedicated web dashboard is deferred.

Build only the Flutter mobile application for the initial release. Use one backend and one source of truth so all booking, payment, service, staff, admin, and analytics data stays synchronized.

## Roles

- **Guest**: create account/login, search availability, book/pay, manage stay, request services, order restaurant food by QR, chat, receive notifications, use Wi-Fi access, provide feedback, earn/redeem loyalty points.
- **Staff**: view/accept bookings (permission-based), guest chat, check-in/out and reservation status updates, fulfill service tasks and restaurant orders.
- **Admin**: manage hotels/rooms/rates/inventory, bookings/payments/refunds, services, staff/leave, restaurant/QR tables, Wi-Fi/POS/payment integrations, marketing content, loyalty, reports, and audit logs.

## Required languages

Initial app languages: **English, Filipino/Tagalog, Cebuano/Bisaya**. Users choose a language and can change it in Settings. Support translated screen text, notifications, receipts, menus, hotel guides, services, and promotions. Preserve original chat messages; optional translation may be added later.

## Mobile-only first release: Flutter scope

Build one Flutter codebase with role-based Guest, Staff, and Admin experiences. Apply **Clean Architecture** and feature-first modules:

```text
lib/core/                         # shared errors, DI, localization, theme, security helpers
lib/features/<feature>/domain/    # pure entities, repository contracts, use cases
lib/features/<feature>/data/      # API/cache DTOs, data sources, repository implementations
lib/features/<feature>/presentation/ # Flutter UI and state (Bloc/Riverpod)
lib/app/                          # app startup, routing, role guards
```

Domain code must not depend on Flutter, Supabase/AWS, payment SDKs, or HTTP. Keep booking/payment/service rules in use cases; data adapters map external data to domain entities; screens only display state and invoke use cases. Unit-test domain use cases independently, then test data adapters and critical widget/integration flows.

### Tuloy Guest

1. Authentication/profile: email/phone login, reset password, notification and language preferences.
2. Booking: date/guest search, room availability, filters, room details/photos/amenities, add-ons, price/policy summary, checkout, confirmation, cancellation rules.
3. Payment: online deposit/full payment, receipt/invoice, payment/refund status. Do not store raw card data; use a payment gateway.
4. My Stay: booking details/status, check-in/out information, invoice, hotel guide, Wi-Fi access, support, feedback.
5. Dynamic services: laundry, room cleaning, dining, airport transfer, wellness, amenities, and hotel-defined extra services. Show price/quote, options, payment method, request form, ETA, and request status.
6. Restaurant QR: scan a signed table QR; show table-confirmed live menu; cart; allergy/special instructions; explicit guest submit; send the order directly to kitchen/POS or staff queue; show preparation/order status.
7. Chat: secure guest-to-staff conversation with booking/service context.
8. Loyalty: points balance/history, rewards, tier, and eligible redemption.
9. Notifications: push, email, and SMS based on event severity/preferences.

### Tuloy Staff

1. Work dashboard: arrivals, departures, pending bookings, unread chats, urgent/assigned service tasks.
2. Booking queue: search/view booking, approve/decline only when allowed, internal notes.
3. Stay updates: check-in, in-house, check-out, cancelled, no-show; keep status history.
4. Service tasks: accept/assign/start/complete/escalate dynamic services, laundry, cleaning, restaurant, transfers.
5. Restaurant queue: QR orders by outlet/table, kitchen order status and correction flow.
6. Guest chat and operational push alerts.

## Tuloy Admin mobile experience (initial release)

1. Dashboard: arrivals/departures, occupancy, pending actions, service load, daily revenue/balance, alerts.
2. Rooms/rates/inventory: hotels, room types, rooms, photos, amenities, rates, inventory blocks/availability.
3. Reservations/payments: calendar/list, confirmations/cancellations, invoices, payment/refund tracking, audit trail.
4. Dynamic service builder: admins can add, edit, publish, pause, price, schedule, and translate any additional hotel service without releasing a new mobile app.
5. Restaurant: outlets, tables, signed QR tokens, menu/items, availability, orders, POS/kitchen integration.
6. Staff/leave: users, roles, departments, task assignment, leave applications/approval.
7. Guest/loyalty: guest data, points ledger, tiers/rewards, authorized adjustments.
8. Marketing/content: promotions, guides, images, notification templates, multilingual content.
9. Analytics: occupancy, income/daily balance, bookings, payments, services, restaurant sales, loyalty, feedback, exports.
10. Settings/integrations: hotel policy/tax, payment gateway, email/SMS/push, Wi-Fi, POS/PMS, roles, webhooks, audit logs.

Do not develop Next.js/web in this phase. Keep the API and database web-ready for a future dashboard only if admins later need complex desktop reporting, bulk edits, or long-form configuration.

## Dynamic service rules

Services are data-driven; no service is hard-coded in Flutter. A service is only publishable when the hotel enters:

- name/category/description/image; property; language translations
- service hours/days, lead time, capacity, ETA, blackout dates
- price model (fixed, per item/person/night, quote), currency, tax/service charge, options/add-ons
- payment method: online, room charge (verified eligible guest only), pay at outlet/delivery, or free
- required guest fields: quantity, schedule, pickup/delivery, notes, attachments, allergies/safety notes
- assigned department/staff, acceptance mode, status steps, cancellation/refund policy
- loyalty earning/redemption eligibility and terms

Store an immutable order snapshot of service/option/price/tax/policy when a guest orders.

## Wi-Fi and QR requirements

- A confirmed/in-house booking creates a time-limited Wi-Fi identity/voucher connected to the reservation. Offer one-tap app/captive-portal login and expire access at checkout. Integrate with the hotel Wi-Fi provider through API, RADIUS, or PMS. Keep QR/manual fallback because silent Wi-Fi join is platform/hardware dependent.
- QR codes must use opaque signed tokens, not guest/payment data. Backend verifies table/outlet/token before showing the menu. The guest must explicitly submit the cart to avoid accidental orders.

## Architecture

- Mobile: Flutter/Dart.
- Backend: modular NestJS/TypeScript REST API + WebSockets for chat/live updates.
- Database: PostgreSQL + Prisma. All hotel-owned entities include `hotel_id` for future multi-property support. Use database transactions and short room holds to prevent duplicate bookings.
- Cache/jobs: Redis/Valkey + BullMQ for availability caching, rate limiting, queued notifications, jobs, retries, reports.
- Storage: S3-compatible object storage for photos, receipts, attachments.
- Payments: Stripe or Philippines-supported gateway (e.g. PayMongo/Xendit); payment gateway webhooks confirm payments server-to-server.
- Notifications: FCM/APNs for push plus email/SMS provider; queued delivery, retries, delivery logs, preferences, opt-out controls.

## Free/low-cost development stack

Use this for prototyping, internal testing, demos, and a small pilot:

- **Supabase Free**: PostgreSQL, Auth, Storage, and Realtime chat.
- **Local Docker + NestJS**: backend development; use a limited free/low-cost serverless/container host only for pilot APIs.
- **Supabase Storage or Cloudflare R2 free allowance**: images and attachments.
- **Firebase Cloud Messaging**: push notifications.
- **Sentry free tier**: error monitoring.
- **Email/SMS sandbox/test mode**: development notifications.

Free tiers are not the final production plan. Before real hotel payments, high-volume bookings, or sensitive guest data, add paid production hosting, backup/restore, monitoring, access controls, email/SMS sender verification, and an incident plan. Payment gateways, SMS, app-store accounts, and domains can still have costs.

## Recommended AWS production setup

- ECS Fargate: containerized NestJS API, workers, scheduled jobs.
- RDS PostgreSQL: transactional database; Multi-AZ/backups for production.
- ElastiCache Redis/Valkey: cache and job queue.
- S3 + CloudFront: images/files/CDN.
- Route 53 + ALB + WAF + ACM: DNS, routing, HTTPS, protection.
- Secrets Manager: secrets/credentials.
- CloudWatch + Sentry: logs, alerts, performance/error monitoring.
- GitHub Actions + ECR + ECS: CI/CD, staging, production release/rollback.

Use separate development, staging, and production environments. Begin as a modular monolith; do not introduce microservices until load/operations justify extracting notifications, reports, or integrations.

## Security/reliability

- RBAC enforced in the backend; secure JWT/refresh token rotation; hashed passwords; MFA for admins later/where required.
- HTTPS, secrets management, validation, rate limiting, audit logs, idempotency keys for booking/payment requests.
- Encrypt sensitive data in transit/at rest; never save raw card data.
- Automated backups, point-in-time recovery, restore tests, monitoring, incident/rollback plan.

## Team

| Role | Ownership |
| --- | --- |
| Product Owner | Vision, scope, hotel policies, backlog, KPI, acceptance decisions. |
| Senior Developer | Architecture, delivery, integrations, code/security standards. |
| Senior Designer | Brand, UX, prototypes, design system, accessibility. |
| Senior QA | Test strategy/automation, booking/payment regression, release sign-off. |
| Senior Marketing | Positioning, launch, content, app stores, acquisition/loyalty campaigns. |
| DevOps | Cloud, CI/CD, environments, observability, backups, security, scale/cost. |

MVP engineering pod: 1–2 Flutter developers, 1 backend developer, and 1 QA engineer, guided by the senior leads.

## Delivery order

1. Foundation: UX/design system, backend/database/auth, localization, environments/CI/CD.
2. Mobile Guest: rooms/availability, booking, payment, confirmation, notifications, My Stay.
3. Mobile Staff: booking queue, stay status, chat, service task queue.
4. Admin mobile: rooms/rates/inventory, reservations/payments, daily dashboard, staff/admin roles.
5. Dynamic services/laundry/cleaning, QR restaurant ordering, email/SMS/push delivery, reporting.
6. Loyalty, Wi-Fi integration, POS/PMS/channel-manager/door-lock integrations, multi-property scaling.

## Definition of MVP-ready

- Guest can register, find available rooms, book/pay, receive confirmation, manage a stay, chat, and request an enabled service.
- Staff can safely operate assigned reservations/tasks and update stay/service status.
- Admin can manage rooms/availability, bookings/payments, dynamic services, daily status, income and basic reports.
- Duplicate booking protection, payment webhooks, notification delivery, RBAC, audit logs, backups, monitoring, and release rollback are verified.

## Instructions for Claude Pro

Use this brief as the source of truth. First produce: (1) user flows and screen inventory, (2) database schema, (3) REST/WebSocket API contract, (4) Clean Architecture Flutter/NestJS project structure, and (5) phased implementation tickets. Do not create a web/Next.js project in this phase. Ask clarification only for unresolved hotel policy/integration decisions; do not remove requirements above.
