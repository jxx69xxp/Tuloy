# Tuloy

Hotel app for guests, staff and admins: book a room, request services, order food by scanning the table QR, chat with the hotel, earn loyalty points and get Wi-Fi access.

```
tuloy_app/   Flutter app: Guest, Staff and Admin areas in one codebase
```

Design and API contract: `outputs/tuloy-design.md`. Database: `tuloy-api/prisma/schema.prisma`.

## Features

**Guests**
- Register, sign in and reset a password with a 6-digit code. English, Filipino and Bisaya.
- Home: search card (dates, guests), rooms and rates, hotel services, and a map of the hotel.
- Booking: rooms are held for 15 minutes (30 once checkout opens). Pay the deposit or the full amount through hosted checkout. Bookings list, cancellation with the policy refund, invoice, My Stay, hotel guide and feedback.
- Services: catalog, request form, status timeline, room charge while checked in. Airport transfers show a map and a route to the airport.
- Restaurant: scan the table QR, then menu, cart and an explicit submit.
- Chat with the hotel from the concierge button ("How can we help?").
- Profile: details, points and tier, stays, services used, payment history, language, sign out.
- Loyalty rewards, and Wi-Fi credentials while checked in.

**Staff**
- Dashboard, booking queue (approve or decline), check-in, check-out and no-show.
- Service task queue, restaurant order queue, guest chat inbox, leave requests.

**Admin**
- Hotel settings (including address and map location), rooms and rates, services, outlets, tables and QR codes.
- Reservations, payments and refunds, staff and roles, reports with CSV export, audit log.

**Platform**
- Access token 15 min, refresh token 30 days, rotated on every use. Replaying an old refresh token signs that session out everywhere.
- Roles and permissions are checked by the API for each hotel.
- The database refuses to sell the same room-night twice. A webhook confirms payments, and a repeated webhook is processed only once.
- Notifications (push, email, SMS) wait in a queue and retry with backoff. With the default `log` providers they print to the API log.

## Run it

You need Node 22, Docker, Flutter 3.32 or newer, and Xcode (iOS) or Android Studio.

**1. API**

```bash
cd tuloy-api
cp .env.example .env        # set JWT_SECRET and DATA_KEY; keep PAYMENT_PROVIDER=mock for now
docker compose up -d        # Postgres + MinIO
npm install
npx prisma migrate dev      # applies all migrations
npm run db:seed             # demo hotel, rooms, services, menu, guide, 3 users
npm run dev                 # http://localhost:3000/v1
npm test                    # needs the database running
```

Demo users (password = `SEED_PASSWORD`, default `ChangeMe123!`):
`admin@tuloy.test`, `staff@tuloy.test`, `guest@tuloy.test`.

**2. App**

```bash
cd tuloy_app
flutter pub get
flutter test
flutter run                                                   # iOS simulator
flutter run --dart-define=API_URL=http://10.0.2.2:3000/v1     # Android emulator
```

`API_URL` and `HOTEL_ID` are set with `--dart-define`; defaults are in `lib/core/config.dart`.

On the Android emulator, also set `PUBLIC_API_URL=http://10.0.2.2:3000` in `tuloy-api/.env`. The test checkout page opens from that address, and `localhost` inside the emulator is the emulator itself.

Plain `http://` works on the iOS simulator. On Android, add `android:usesCleartextTraffic="true"` to the debug `AndroidManifest.xml` only. Staging and production must use HTTPS.

If `pod install` fails with `Encoding::CompatibilityError`, add `export LANG=en_US.UTF-8` to your shell profile.

## Try a booking (mock payments)

1. Sign in as `guest@tuloy.test`, tap **Find a room**, pick dates, choose a room and tap **Reserve**.
2. On Review and pay, choose the deposit or the full amount. A test checkout page opens; tap **Pay (test)**.
3. Go back to the app. Within about 3 seconds it shows **Booking confirmed** with the room number.
4. The API log shows the confirmation and receipt notifications.

## Going live with PayMongo

1. Set `PAYMENT_PROVIDER=paymongo`, `PAYMONGO_SECRET_KEY` and `PUBLIC_API_URL`, which must be a public HTTPS address.
2. In the PayMongo dashboard, create a webhook for `checkout_session.payment.paid` pointing to `{PUBLIC_API_URL}/v1/webhooks/payments/paymongo`. Put its secret in `PAYMONGO_WEBHOOK_SECRET`.
3. Test with PayMongo test keys first. Before switching to live keys, check the field names in `src/payments/gateway.ts` against PayMongo's current docs.

Notifications: set `EMAIL_PROVIDER=resend`, `SMS_PROVIDER=semaphore` or `PUSH_PROVIDER=fcm`, plus each provider's keys (see `.env.example`). SMS goes only to verified numbers, except reset codes.

## Run on web

Staff and admins can use the app in a browser. Guests see a placeholder that points them to the mobile app.

```bash
cd tuloy_app
flutter run -d chrome
flutter run -d chrome --dart-define=API_URL=https://api.example.com/v1
flutter build web          # output in tuloy_app/build/web
```

- **HTTPS required.** Serve the web build over HTTPS (or from `localhost` while developing). Token storage on web uses the browser's Web Crypto API (`crypto.subtle`), which browsers only provide in secure contexts. Over plain HTTP on any other host the app cannot store a session, so sign-in will not work.
- **CORS.** Set `CORS_ORIGINS` in the API environment to the web app's origins, comma-separated, exact and without a trailing slash (for example `https://staff.example.com`). `localhost` origins are allowed automatically, but only outside production.
- **Photo upload.** In production, add a CORS rule to the object storage bucket (S3 or R2) that allows `PUT` from the web origin. Uploads go straight to the bucket.
- **Token storage.** On web, tokens live in browser storage, which is weaker than the secure storage used on mobile. Short 15-minute access tokens and rotating refresh tokens limit the damage.
- **Layout.** Staff and admin get a navigation rail at widths of 840 px and up, and the usual bottom navigation below that.
- **Not on web.** QR scanning (use the mobile app). Chat and queues refresh by polling.

## Design

- Theme and shared visuals: `tuloy_app/lib/app/theme.dart` (teal `#0F6E6E`, amber `#F4B860`, arch-shaped cards, bordered fields with the label inside).
- Logo sources: `tuloy_app/assets/logo/` (`tuloy_icon.svg`, `tuloy_logo.svg`).
- Maps: `tuloy_app/lib/core/map.dart` draws OpenStreetMap tiles and opens Apple Maps (iOS) or Google Maps on tap.

## CI

`flutter analyze` fails on lint *infos*. If CI goes red on infos only, change that step in `.github/workflows/ci.yml` to `flutter analyze --no-fatal-infos`.

## Not built yet

- Room and service photos: the app shows gradient placeholders (`RoomArt`). Admin photo upload and serving photo URLs are still to do.
- Live updates: there is no WebSocket yet, so chat and queues refresh by polling.
- Web: guest screens (guests see a placeholder) and QR scanning are not available. Chat and queues poll, as on mobile.
- In-app push registration: needs a Firebase project (`google-services.json` / `GoogleService-Info.plist`). The API side is ready (`POST /v1/me/push-tokens`).
- Saved cards: checkout is hosted by PayMongo, so the app shows payment history but not card brand or last digits.
- Airport directions use the destination "airport", so the maps app picks the nearest one. Store the airport per hotel if that guesses wrong.
- OpenStreetMap tiles are fine for light use. Move to a tile provider with an API key if traffic grows.
- Redis/BullMQ: the job queue is Postgres for now. Move to Redis when volume needs it.
- Sentry needs a DSN. Add `sentry_flutter` and `@sentry/node` once the project exists.
- The iOS release build needs a macOS CI runner and signing certificates.
- The Bisaya and Filipino text needs review by the hotel's translator (open decision #13).
