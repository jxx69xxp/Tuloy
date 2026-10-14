## Summary
First full import of Tuloy: the Flutter hotel app (`tuloy_app/`) and the NestJS API (`tuloy-api/`), including the new design.

**App**
- Tuloy logo, iOS/Android launcher icons, branded native launch screen + Flutter splash
- New theme: warm sand surfaces, teal brand, amber highlights, arch-shaped cards, modern bordered fields (label inside, no notch)
- Guest home in an Agoda/Trivago style: dusk header, floating search card, category row, "Rooms & rates" and "Services" carousels, "Getting here" map
- Concierge button → "How can we help?" sheet (chat with the hotel, services, order food, my requests)
- Guest profile replaces Settings: details, points/tier, stays, services used, payment history, map, language, sign out
- Airport/transport services show a map and a "Route to the airport" link
- Sign-in / sign-up redesigned (arched doorway hero + hotel service icons), password show/hide
- `mobile_scanner` 6 → 7 so the app builds for arm64 iOS simulators (MLKit had no arm64-simulator slice)
- New strings in en / fil / ceb

**API**
- Migration `hotel_location`: `Hotel.address`, `latitude`, `longitude` (returned by `GET /hotels/:id`, editable by admins)
- `GET /me/payments`: guest's booking and service payments (no card data; checkout is hosted by PayMongo)
- Seed: demo hotel location (Cebu City) and an "Airport transfer" service

## Notes
- Room/service images are gradient placeholders (`RoomArt`) until the API serves photos.
- Maps use OpenStreetMap tiles (fine for light use) and open Apple/Google Maps on tap.
- Airport directions use the destination "airport"; store the airport per hotel if the maps app guesses wrong.

## Test plan
- [ ] `cd tuloy-api && npx prisma migrate dev && npm run db:seed`
- [ ] `cd tuloy_app && flutter test` (includes `test/map_test.dart`)
- [ ] Run on an iOS simulator: splash → sign in → home → concierge sheet → profile → service detail (airport)
- [ ] Check Android launch screen and dark mode (not yet verified)

🤖 Generated with [Claude Code](https://claude.com/claude-code)
