import { PrismaClient, Role } from '@prisma/client';
import { randomBytes } from 'node:crypto';
import { hashPassword, sha256 } from '../src/auth/password';

/** Must match HOTEL_ID in the Flutter app (lib/core/config.dart). */
export const DEMO_HOTEL_ID = 'b6a7c0de-1d2e-4f3a-9b8c-7d6e5f4a3b21';

const prisma = new PrismaClient();

async function main() {
  const password = await hashPassword(process.env.SEED_PASSWORD ?? 'ChangeMe123!');

  // Demo terms (open decision #3). Re-running the seed resets them.
  const policies = {
    checkIn: '14:00',
    checkOut: '12:00',
    freeCancelHours: 48,
    lateCancelRefundPercent: 0,
    depositPercent: 30,
    requireApproval: false, // true = staff confirm each paid booking
    loyalty: {
      earnPer100: 1,
      pointValue: 1,
      maxRedeemPercent: 50,
      tiers: [
        { name: 'member', min: 0 },
        { name: 'silver', min: 1000 },
        { name: 'gold', min: 5000 },
      ],
    },
    cancellation: {
      en: 'Free cancellation up to 48 hours before check-in. After that, payments are non-refundable.',
      fil: 'Libreng pagkansela hanggang 48 oras bago mag-check-in. Pagkatapos nito, hindi na maibabalik ang bayad.',
      ceb: 'Libre ang pagkansela hangtod 48 ka oras sa dili pa mo-check-in. Human niana, dili na mabalik ang bayad.',
    },
  };
  const integrations = { wifi: { ssid: 'Tuloy-Guest', mode: 'portal' } };
  const location = { address: 'Osmeña Boulevard, Cebu City, 6000 Cebu', latitude: 10.3157, longitude: 123.8854 };
  const hotel = await prisma.hotel.upsert({
    where: { id: DEMO_HOTEL_ID },
    update: { policies, integrations, ...location },
    create: { id: DEMO_HOTEL_ID, name: 'Tuloy Demo Hotel', policies, integrations, ...location },
  });

  if ((await prisma.department.count({ where: { hotelId: hotel.id } })) === 0) {
    await prisma.department.createMany({
      data: ['Front Office', 'Housekeeping', 'Food & Beverage'].map((name) => ({ hotelId: hotel.id, name })),
    });
  }
  const frontOffice = await prisma.department.findFirstOrThrow({ where: { hotelId: hotel.id, name: 'Front Office' } });
  const housekeeping = await prisma.department.findFirstOrThrow({ where: { hotelId: hotel.id, name: 'Housekeeping' } });

  const users: { email: string; fullName: string; role: Role; permissions: string[]; departmentId?: string }[] = [
    { email: 'admin@tuloy.test', fullName: 'Ana Admin', role: 'ADMIN', permissions: [] },
    { email: 'staff@tuloy.test', fullName: 'Sam Staff', role: 'STAFF', permissions: ['booking.approve'], departmentId: frontOffice.id },
    { email: 'house@tuloy.test', fullName: 'Hana Housekeeping', role: 'STAFF', permissions: [], departmentId: housekeeping.id },
    { email: 'guest@tuloy.test', fullName: 'Gina Guest', role: 'GUEST', permissions: [] },
  ];
  for (const { role, permissions, departmentId, ...u } of users) {
    const user = await prisma.user.upsert({ where: { email: u.email }, update: {}, create: { ...u, passwordHash: password } });
    await prisma.membership.upsert({
      where: { userId_hotelId: { userId: user.id, hotelId: hotel.id } },
      update: {},
      create: { userId: user.id, hotelId: hotel.id, role, permissions, departmentId },
    });
  }

  const roomTypes = [
    { name: { en: 'Deluxe Queen', fil: 'Deluxe Queen', ceb: 'Deluxe Queen' }, maxGuests: 2, basePrice: 3500, numbers: ['201', '202', '203'] },
    { name: { en: 'Family Suite', fil: 'Family Suite', ceb: 'Family Suite' }, maxGuests: 4, basePrice: 6200, numbers: ['301', '302'] },
  ];
  if ((await prisma.roomType.count({ where: { hotelId: hotel.id } })) === 0) {
    for (const { numbers, ...rt } of roomTypes) {
      await prisma.roomType.create({
        data: {
          ...rt,
          hotelId: hotel.id,
          description: { en: '', fil: '', ceb: '' },
          amenities: ['wifi', 'aircon', 'tv'],
          rooms: { create: numbers.map((number) => ({ number, hotelId: hotel.id })) },
        },
      });
    }
  }
  if ((await prisma.contentItem.count({ where: { hotelId: hotel.id, kind: 'guide' } })) === 0) {
    const guide = [
      {
        title: { en: 'Front desk & Wi-Fi', fil: 'Front desk at Wi-Fi', ceb: 'Front desk ug Wi-Fi' },
        body: {
          en: 'The front desk is open 24 hours. Dial 0 from your room phone. Wi-Fi details are on your key card sleeve.',
          fil: 'Bukas ang front desk nang 24 oras. I-dial ang 0 sa telepono ng kuwarto. Nasa lalagyan ng key card ang Wi-Fi.',
          ceb: 'Abli ang front desk 24 oras. I-dial ang 0 sa telepono sa kwarto. Naa sa sudlanan sa key card ang Wi-Fi.',
        },
      },
      {
        title: { en: 'Breakfast', fil: 'Almusal', ceb: 'Pamahaw' },
        body: {
          en: 'Served 6:30–10:00 at the lobby restaurant.',
          fil: 'Inihahain mula 6:30–10:00 sa restawran sa lobby.',
          ceb: 'Gi-serve gikan 6:30–10:00 sa restawran sa lobby.',
        },
      },
      {
        title: { en: 'Pool', fil: 'Swimming pool', ceb: 'Swimming pool' },
        body: {
          en: 'Open 7:00–21:00. Towels at the pool desk.',
          fil: 'Bukas 7:00–21:00. May tuwalya sa pool desk.',
          ceb: 'Abli 7:00–21:00. Naay tualya sa pool desk.',
        },
      },
    ];
    await prisma.contentItem.createMany({
      data: guide.map((g) => ({ ...g, hotelId: hotel.id, kind: 'guide', publishedAt: new Date() })),
    });
  }

  if ((await prisma.loyaltyReward.count({ where: { hotelId: hotel.id } })) === 0) {
    await prisma.loyaltyReward.createMany({
      data: [
        { hotelId: hotel.id, name: { en: '₱200 off your stay', fil: '₱200 bawas sa pananatili', ceb: '₱200 kubos sa pagpuyo' }, points: 200, value: 200 },
        { hotelId: hotel.id, name: { en: '₱500 off your stay', fil: '₱500 bawas sa pananatili', ceb: '₱500 kubos sa pagpuyo' }, points: 450, value: 500 },
      ],
    });
  }

  if ((await prisma.service.count({ where: { hotelId: hotel.id } })) === 0) {
    await prisma.service.create({
      data: {
        hotelId: hotel.id,
        category: 'laundry',
        status: 'PUBLISHED',
        name: { en: 'Laundry (wash & fold)', fil: 'Labada (laba at tiklop)', ceb: 'Labada (laba ug pilo)' },
        description: {
          en: 'Picked up from your room, returned within 24 hours. Price per kilo.',
          fil: 'Kukunin sa kuwarto, ibabalik sa loob ng 24 oras. Presyo kada kilo.',
          ceb: 'Kuhaon sa kwarto, ibalik sulod sa 24 oras. Presyo matag kilo.',
        },
        schedule: { days: [1, 2, 3, 4, 5, 6, 7], from: '07:00', to: '20:00' },
        leadTimeMin: 30,
        etaMin: 1440,
        priceModel: 'PER_ITEM',
        basePrice: 120,
        currency: 'PHP',
        taxIncluded: true,
        paymentMethods: ['ROOM_CHARGE', 'ONLINE'],
        fields: [
          { key: 'quantity', type: 'number', required: true, label: { en: 'Kilos', fil: 'Kilo', ceb: 'Kilo' } },
          { key: 'notes', type: 'text', label: { en: 'Instructions', fil: 'Tagubilin', ceb: 'Instruksyon' } },
        ],
        departmentId: housekeeping.id,
        acceptanceMode: 'AUTO',
        statusSteps: ['requested', 'accepted', 'picked_up', 'processing', 'delivered', 'completed'],
        cancellationPolicy: {
          en: 'Free to cancel before pickup.',
          fil: 'Libreng kanselahin bago kunin.',
          ceb: 'Libre ang pagkansela sa dili pa kuhaon.',
        },
        loyaltyEarn: true,
        options: {
          create: [
            { name: { en: 'Express (same day)', fil: 'Express (parehong araw)', ceb: 'Express (parehas nga adlaw)' }, priceDelta: 60 },
            { name: { en: 'Ironing', fil: 'Plantsa', ceb: 'Plantsa' }, priceDelta: 40 },
          ],
        },
      },
    });
  }

  if ((await prisma.service.count({ where: { hotelId: hotel.id, category: 'airport' } })) === 0) {
    const frontOffice = await prisma.department.findFirstOrThrow({ where: { hotelId: hotel.id, name: 'Front Office' } });
    await prisma.service.create({
      data: {
        hotelId: hotel.id,
        category: 'airport',
        status: 'PUBLISHED',
        name: { en: 'Airport transfer', fil: 'Sundo sa airport', ceb: 'Sundo sa airport' },
        description: {
          en: 'Private car between the hotel and Mactan-Cebu International Airport.',
          fil: 'Pribadong sasakyan mula hotel papuntang Mactan-Cebu International Airport at pabalik.',
          ceb: 'Pribadong sakyanan tali sa hotel ug Mactan-Cebu International Airport.',
        },
        schedule: { days: [1, 2, 3, 4, 5, 6, 7], from: '04:00', to: '23:00' },
        leadTimeMin: 180,
        etaMin: 45,
        priceModel: 'FIXED',
        basePrice: 850,
        currency: 'PHP',
        taxIncluded: true,
        paymentMethods: ['ROOM_CHARGE', 'ONLINE'],
        fields: [
          { key: 'flight', type: 'text', required: true, label: { en: 'Flight number', fil: 'Numero ng flight', ceb: 'Numero sa flight' } },
          { key: 'passengers', type: 'number', required: true, label: { en: 'Passengers', fil: 'Pasahero', ceb: 'Pasahero' } },
        ],
        departmentId: frontOffice.id,
        acceptanceMode: 'AUTO',
        statusSteps: ['requested', 'accepted', 'driver_assigned', 'completed'],
        cancellationPolicy: {
          en: 'Free to cancel up to 3 hours before pickup.',
          fil: 'Libreng kanselahin hanggang 3 oras bago sunduin.',
          ceb: 'Libre ang pagkansela hangtod 3 ka oras sa dili pa sundon.',
        },
        loyaltyEarn: true,
      },
    });
  }

  if ((await prisma.outlet.count({ where: { hotelId: hotel.id } })) === 0) {
    const outlet = await prisma.outlet.create({
      data: {
        hotelId: hotel.id,
        name: { en: 'Lobby Restaurant', fil: 'Restawran sa Lobby', ceb: 'Restawran sa Lobby' },
        schedule: { days: [1, 2, 3, 4, 5, 6, 7], from: '06:30', to: '22:00' },
        tables: { create: ['T1', 'T2', 'T3'].map((label) => ({ label })) },
        items: {
          create: [
            { category: { en: 'Mains', fil: 'Ulam', ceb: 'Sud-an' }, name: { en: 'Chicken adobo', fil: 'Adobong manok', ceb: 'Adobong manok' }, price: 320, allergens: ['soy'] },
            { category: { en: 'Mains', fil: 'Ulam', ceb: 'Sud-an' }, name: { en: 'Pancit canton', fil: 'Pansit canton', ceb: 'Pansit canton' }, price: 280, allergens: ['gluten', 'soy'] },
            { category: { en: 'Drinks', fil: 'Inumin', ceb: 'Ilimnon' }, name: { en: 'Calamansi juice', fil: 'Katas ng kalamansi', ceb: 'Duga sa kalamansi' }, price: 90, allergens: [] },
          ],
        },
      },
      include: { tables: true },
    });
    // Tokens are only shown here; the DB keeps the hash. Re-issue from Admin › Restaurant if lost.
    for (const table of outlet.tables) {
      const token = randomBytes(24).toString('base64url');
      await prisma.tableQrToken.create({ data: { tableId: table.id, tokenHash: sha256(token) } });
      console.log(`Table ${table.label} QR: tuloy://table/${token}`);
    }
  }

  console.log(`Seeded ${hotel.name} (${hotel.id})`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
