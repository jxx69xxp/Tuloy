# Product

<!-- impeccable:product-schema 1 -->

## Platform

web

## Users

- **Front desk staff** at reception: check guests in and out, approve bookings, answer guest chat, handle walk-up questions, often with a guest standing at the counter.
- **Floor staff** (housekeeping, food and beverage) moving around the property on a tablet: work service tasks and restaurant orders.
- **Managers and admins** on a back-office laptop: rooms and rates, services, staff and roles, payments and refunds, reports, audit log.
- **Guests** use the mobile app (book, request services, order food by table QR, chat, loyalty, Wi-Fi). Guests who sign in on the web are sent to the mobile app.

Staff use the app across all shifts, including night shift in a dim lobby.

## Product Purpose

Tuloy runs the guest side and the operations side of a hotel in one system: a guest books and asks for things in the app, and staff see and act on it in the same place. Success is a front desk that knows, at a glance, what is happening in the hotel today and what needs action, without switching tools.

## Positioning

Open decision: whether Tuloy is sold to many small and budget hotels in the Philippines or built for one hotel or group. Work must not assume either. The demo hotel, Lunhaw Suites Davao, is fictional.

## Operating Context

- One Flutter codebase: guest mobile app (iOS, Android) and the staff and admin web app. The staff web layout applies from 840 px wide; narrower screens get the mobile layout.
- The front desk shares one PC; sessions belong to individual staff accounts with roles and permissions checked by the API per hotel.
- Languages: English, Filipino and Bisaya (Cebuano). Prices in PHP.
- Daily rhythm: arrivals from the check-in time (14:00 in the demo), departures by check-out (12:00), service requests and restaurant orders throughout, guest chat at any hour.

## Capabilities and Constraints

- Staff: front desk overview (today's numbers, room board, needs-attention list, arrivals and departures), reservations queue with approve, decline, check-in, check-out, no-show and cancel with the policy refund, service tasks, restaurant orders, guest chat inbox, guest list, team directory, leave requests, notifications.
- Admin: hotel settings, rooms and rates, services, outlets, tables and QR codes, payments and refunds, staff and roles, reports with CSV export, audit log, content, loyalty.
- Data arrives by polling (15 to 20 seconds); there is no live push to the web app yet.
- Payments go through hosted checkout; staff never handle card data.

## Brand Commitments

- Filipino warmth: the product feels local and hospitable, not like a generic Western SaaS tool.
- The Tuloy name and current logo are not binding for the staff app.

## Evidence on Hand

- Seeded demo data: one hotel, 22 rooms in four room types, services, menu, guide content and four demo users (`tuloy-api/prisma/seed.ts`).
- No real customers, testimonials, metrics or photography. Room and service photos are not served yet; the app uses generated placeholder art. Do not invent any of these.

## Product Principles

1. Today first: the front desk opens on what is happening now and what needs action.
2. One place to act: anything a guest asks for shows up where staff can resolve it, without switching tools.
3. Glanceable under pressure: readable from a step back, at the counter, mid-conversation, on any shift.
4. Local by default: three languages, PHP, Philippine hotel practice.

## Accessibility & Inclusion

- Staff read the screen in bright daytime lobbies and dim night shifts; contrast must hold in both themes.
- Keyboard use on the desk PC (shortcuts exist: quick jump, table search, chat send) and touch on tablets; touch targets must suit tablets.
