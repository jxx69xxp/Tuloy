# Tuloy — Phases 1–2 (Foundation + Guest booking)

```
tuloy-api/   NestJS + Prisma + PostgreSQL
tuloy_app/   Flutter app: Guest, Staff and Admin areas in one codebase
.github/     CI (API tests + Docker build, Flutter analyze/test/APK)
```

Design: `outputs/tuloy-design.md`. Database: `tuloy-api/prisma/schema.prisma`.

## What works

**Phase 1**
- Register, sign in, sign out, and password reset with a 6-digit code.
- Access token 15 min, refresh token 30 days, rotated on every use. Replaying an old refresh token signs that session out everywhere.
- Roles (Guest / Staff / Admin) and permissions are checked by the API for each hotel. The app routes each role to its own area.
- English, Filipino and Bisaya. The language is chosen on first launch and can be changed in Settings. API errors and content come back in the chosen language.
- Admin can update hotel settings (`PATCH /v1/admin/hotels/:hotelId`), and the change is written to the audit log.

**Phase 2: guest booking**
- Search by dates and guests. The app shows prices per night and in total, including service charge and VAT.
- Reserve holds one physical room for 15 minutes, extended to 30 minutes once checkout opens. The database refuses to sell the same room-night twice.
- Pay the deposit or the full amount through hosted checkout. A webhook confirms the booking, and a repeated webhook is processed only once.
- Bookings list, booking detail, balance payment, cancellation with the policy refund, invoice, My Stay, hotel guide and feedback.
- Notifications for confirmation, cancellation, receipts, refunds and reset codes, by push, email and SMS. They wait in a queue and are retried with backoff. With the default `log` providers they are printed in the API log.
- Holds that run out are released every minute. A payment that arrives after its hold expired still confirms the booking if the room is free; if the room was taken, the guest is refunded automatically.

## Run it

You need Node 22, Docker and Flutter 3.32 or newer.

**1. API**

```bash
cd tuloy-api
cp .env.example .env        # set JWT_SECRET; keep PAYMENT_PROVIDER=mock for now
docker compose up -d        # Postgres
npm install
npx prisma migrate dev --name phase2   # applies the Phase 2 schema changes — commit prisma/migrations
npm run db:seed             # demo hotel, rooms, guide, 3 users (30% deposit, 48 h free cancellation)
npm run dev                 # http://localhost:3000/v1
npm test                    # needs the database running
```

Demo users (password = `SEED_PASSWORD`, default `ChangeMe123!`):
`admin@tuloy.test`, `staff@tuloy.test`, `guest@tuloy.test`.

**2. App**

```bash
cd tuloy_app
flutter create --org com.tuloy --project-name tuloy_app --platforms ios,android .   # only once; keeps existing files
flutter pub get
flutter test
flutter run                                                   # iOS simulator
flutter run --dart-define=API_URL=http://10.0.2.2:3000/v1     # Android emulator
```

On the Android emulator, also set `PUBLIC_API_URL=http://10.0.2.2:3000` in `tuloy-api/.env`. The test checkout page opens from that address, and `localhost` inside the emulator is the emulator itself.

Plain `http://` works on the iOS simulator. On Android, add `android:usesCleartextTraffic="true"` to the debug `AndroidManifest.xml` only. Staging and production must use HTTPS.

## Try a booking (mock payments)

1. Sign in as `guest@tuloy.test`, then tap Find a room, pick dates, choose a room and tap Reserve.
2. On Review and pay, choose the deposit or the full amount. A test checkout page opens; tap **Pay (test)**.
3. Go back to the app. Within about 3 seconds it shows **Booking confirmed** with the room number.
4. The API log shows the confirmation and receipt notifications.

## Going live with PayMongo

1. Set `PAYMENT_PROVIDER=paymongo`, `PAYMONGO_SECRET_KEY` and `PUBLIC_API_URL`, which must be a public HTTPS address.
2. In the PayMongo dashboard, create a webhook for `checkout_session.payment.paid` pointing to `{PUBLIC_API_URL}/v1/webhooks/payments/paymongo`. Put its secret in `PAYMONGO_WEBHOOK_SECRET`.
3. Test with PayMongo test keys first. Before switching to live keys, check the field names in `src/payments/gateway.ts` against PayMongo's current docs.

Notifications: set `EMAIL_PROVIDER=resend`, `SMS_PROVIDER=semaphore` or `PUSH_PROVIDER=fcm`, plus each provider's keys (see `.env.example`). SMS goes only to verified numbers, except reset codes.

## CI

`flutter analyze` fails on lint *infos*. If CI goes red on infos only, change that step in `.github/workflows/ci.yml` to `flutter analyze --no-fatal-infos`.

## Not built yet

- Add-ons at booking (G5): these will be published services, coming in Phase 5.
- In-app push registration: needs a Firebase project (`google-services.json` / `GoogleService-Info.plist`). The API side is ready (`POST /v1/me/push-tokens`).
- Staff approval of bookings, check-in and check-out arrive in Phase 3, which also adds live updates over WebSocket. The app polls for now.
- Retrying a failed refund from an admin screen arrives in Phase 4. For now a failed refund is recorded as a `Refund` row with status `failed` plus an audit entry.
- Redis/BullMQ: the job queue is Postgres for now. Move to Redis when volume needs it.
- Sentry needs a DSN. Add `sentry_flutter` and `@sentry/node` once the project exists.
- The iOS release build needs a macOS CI runner and signing certificates.
- The Bisaya and Filipino text needs review by the hotel's translator (open decision #13).
