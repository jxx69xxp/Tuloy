import { AcceptanceMode, PaymentMethod, Prisma, PriceModel, PrismaClient, Role } from '@prisma/client';
import { randomBytes } from 'node:crypto';
import { hashPassword, sha256 } from '../src/auth/password';

/** Must match HOTEL_ID in the Flutter app (lib/core/config.dart). */
export const DEMO_HOTEL_ID = 'b6a7c0de-1d2e-4f3a-9b8c-7d6e5f4a3b21';

/*
 * Demo property: "Lunhaw Suites Davao", a FICTIONAL budget city inn in Poblacion, Davao City.
 * Loosely inspired by a real Davao budget inn (see reports/); every rate, menu, service and promo is invented
 * or scaled from comparable Davao prices. No real street address, phone number, email or person.
 * Filipino (fil) and Bisaya (ceb) copy is simple machine-level wording: needs native-speaker review.
 *
 * Idempotent: rows are matched by their English name/title (or a previous seed's name via `was`)
 * and updated in place, so re-running never duplicates and older demo data is migrated forward.
 */

const prisma = new PrismaClient();

type L10n = { en: string; fil: string; ceb: string };
const L = (en: string, fil: string, ceb: string): L10n => ({ en, fil, ceb });
const byEn = (field: string, en: string, was?: string) => ({
  OR: [en, ...(was ? [was] : [])].map((v) => ({ [field]: { path: ['en'], equals: v } })),
});
const EVERY_DAY = [1, 2, 3, 4, 5, 6, 7];

async function main() {
  const password = await hashPassword(process.env.SEED_PASSWORD ?? 'ChangeMe123!');

  // Demo terms (open decision #3). Re-running the seed resets them.
  // The inn charges a token deposit; the app models deposits as a percent, so 30% (~₱300 on a single night).
  const policies = {
    checkIn: '14:00',
    checkOut: '12:00',
    freeCancelHours: 24,
    lateCancelRefundPercent: 50,
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
    cancellation: L(
      'Free cancellation up to 24 hours before check-in. After that, 50% of the payment is refunded. No-shows are not refunded.',
      'Libreng pagkansela hanggang 24 oras bago mag-check-in. Pagkatapos nito, 50% ng bayad ang ibabalik. Walang refund kapag hindi sumipot.',
      'Libre ang pagkansela hangtod 24 ka oras sa dili pa mo-check-in. Human niana, 50% sa bayad ang ibalik. Walay refund kung dili mosipot.',
    ),
  };
  const integrations = { wifi: { ssid: 'Lunhaw-Guest', mode: 'portal' } };
  // Approximate Poblacion pin near the city centre; deliberately not any real property's location.
  const profile = { name: 'Lunhaw Suites Davao', timezone: 'Asia/Manila', address: 'Poblacion District, Davao City, 8000 Davao del Sur', latitude: 7.0712, longitude: 125.6085 };
  const hotel = await prisma.hotel.upsert({
    where: { id: DEMO_HOTEL_ID },
    update: { ...profile, policies, integrations },
    create: { id: DEMO_HOTEL_ID, ...profile, policies, integrations },
  });

  const dept: Record<string, string> = {};
  for (const name of ['Front Office', 'Housekeeping', 'Food & Beverage']) {
    const d = (await prisma.department.findFirst({ where: { hotelId: hotel.id, name } })) ?? (await prisma.department.create({ data: { hotelId: hotel.id, name } }));
    dept[name] = d.id;
  }

  const users: { email: string; fullName: string; role: Role; permissions: string[]; departmentId?: string; employeeNo?: string }[] = [
    { email: 'admin@tuloy.test', fullName: 'Ana Admin', role: 'ADMIN', permissions: [], employeeNo: 'LSD-001' },
    { email: 'staff@tuloy.test', fullName: 'Sam Staff', role: 'STAFF', permissions: ['booking.approve'], departmentId: dept['Front Office'], employeeNo: 'LSD-014' },
    { email: 'house@tuloy.test', fullName: 'Hana Housekeeping', role: 'STAFF', permissions: [], departmentId: dept['Housekeeping'], employeeNo: 'LSD-027' },
    { email: 'resto@tuloy.test', fullName: 'Rico Restaurant', role: 'RESTAURANT', permissions: [], departmentId: dept['Food & Beverage'], employeeNo: 'LSD-033' },
    { email: 'guest@tuloy.test', fullName: 'Gina Guest', role: 'GUEST', permissions: [] },
  ];
  for (const { role, permissions, departmentId, employeeNo, ...u } of users) {
    const user = await prisma.user.upsert({ where: { email: u.email }, update: {}, create: { ...u, passwordHash: password } });
    await prisma.membership.upsert({
      where: { userId_hotelId: { userId: user.id, hotelId: hotel.id } },
      update: { employeeNo },
      create: { userId: user.id, hotelId: hotel.id, role, permissions, departmentId, employeeNo },
    });
  }

  // ── Rooms: 22 rooms. Floor 1 is the lobby and café. ──
  const baseAmenities = ['wifi', 'aircon', 'tv', 'streaming', 'private_bathroom', 'hot_shower', 'bidet', 'desk'];
  const roomTypes = [
    {
      was: 'Deluxe Queen',
      name: L('Standard Double', 'Standard Double', 'Standard Double'),
      description: L(
        '15 sqm room with one double bed, air conditioning, a private bathroom with shower and bidet, a 32" smart TV with streaming and a work desk. Non-smoking.',
        '15 sqm na kuwarto na may isang double bed, aircon, sariling banyo na may shower at bidet, 32" smart TV na may streaming at mesa. Bawal manigarilyo.',
        '15 sqm nga kwarto nga adunay usa ka double bed, aircon, kaugalingong banyo nga adunay shower ug bidet, 32" smart TV nga adunay streaming ug lamesa. Dili pwede manigarilyo.',
      ),
      maxGuests: 2,
      basePrice: 1290,
      amenities: baseAmenities,
      floor: '2',
      numbers: ['201', '202', '203', '204', '205', '206', '207', '208', '209', '210'],
    },
    {
      name: L('Family Suite', 'Family Suite', 'Family Suite'),
      description: L(
        '24 sqm suite with one double and one single bed for up to 4 guests. Air conditioning, private bathroom, smart TV, desk and a mini fridge. Non-smoking.',
        '24 sqm na suite na may isang double at isang single bed para sa hanggang 4 na bisita. May aircon, sariling banyo, smart TV, mesa at maliit na ref. Bawal manigarilyo.',
        '24 sqm nga suite nga adunay usa ka double ug usa ka single bed para hangtod 4 ka bisita. Adunay aircon, kaugalingong banyo, smart TV, lamesa ug gamay nga ref. Dili pwede manigarilyo.',
      ),
      maxGuests: 4,
      basePrice: 2290,
      amenities: [...baseAmenities, 'mini_fridge'],
      floor: '3',
      numbers: ['301', '302'],
    },
    {
      name: L('Deluxe Twin', 'Deluxe Twin', 'Deluxe Twin'),
      description: L(
        '18 sqm room with two single beds, air conditioning, a private bathroom with shower and bidet, a smart TV and a desk. Good for friends or colleagues. Non-smoking.',
        '18 sqm na kuwarto na may dalawang single bed, aircon, sariling banyo na may shower at bidet, smart TV at mesa. Bagay sa magkaibigan o magkatrabaho. Bawal manigarilyo.',
        '18 sqm nga kwarto nga adunay duha ka single bed, aircon, kaugalingong banyo nga adunay shower ug bidet, smart TV ug lamesa. Maayo para sa managhigala o magkauban sa trabaho. Dili pwede manigarilyo.',
      ),
      maxGuests: 2,
      basePrice: 1590,
      amenities: baseAmenities,
      floor: '3',
      numbers: ['303', '304', '305', '306'],
    },
    {
      name: L('Standard Single', 'Standard Single', 'Standard Single'),
      description: L(
        '12 sqm room with one single bed for a solo traveller. Air conditioning, private bathroom with shower and bidet, smart TV with streaming. Non-smoking.',
        '12 sqm na kuwarto na may isang single bed para sa nag-iisang biyahero. May aircon, sariling banyo na may shower at bidet, smart TV na may streaming. Bawal manigarilyo.',
        '12 sqm nga kwarto nga adunay usa ka single bed para sa nag-inusarang biyahero. Adunay aircon, kaugalingong banyo nga adunay shower ug bidet, smart TV nga adunay streaming. Dili pwede manigarilyo.',
      ),
      maxGuests: 1,
      basePrice: 990,
      amenities: baseAmenities,
      floor: '4',
      numbers: ['401', '402', '403', '404', '405', '406'],
    },
  ];
  for (const { was, numbers, floor, ...rt } of roomTypes) {
    const found = await prisma.roomType.findFirst({ where: { hotelId: hotel.id, ...byEn('name', rt.name.en, was) } });
    const saved = found
      ? await prisma.roomType.update({ where: { id: found.id }, data: { ...rt, active: true } })
      : await prisma.roomType.create({ data: { ...rt, hotelId: hotel.id } });
    for (const number of numbers) {
      await prisma.room.upsert({
        where: { hotelId_number: { hotelId: hotel.id, number } },
        update: { roomTypeId: saved.id, floor, active: true },
        create: { hotelId: hotel.id, roomTypeId: saved.id, number, floor },
      });
    }
  }

  // ── Services ──
  type ServiceSeed = {
    was?: string;
    category: string;
    name: L10n;
    description: L10n;
    schedule: { days: number[]; from: string; to: string };
    leadTimeMin: number;
    etaMin: number;
    priceModel: PriceModel;
    basePrice: number | null;
    paymentMethods: PaymentMethod[];
    fields: { key: string; type: string; required?: boolean; label: L10n; options?: { value: string; label: L10n }[] }[];
    department: string;
    acceptanceMode: AcceptanceMode;
    statusSteps: string[];
    cancellationPolicy: L10n;
    options?: { name: L10n; priceDelta: number }[];
  };
  const pay: PaymentMethod[] = ['ROOM_CHARGE', 'ONLINE'];
  const notes = { key: 'notes', type: 'text', label: L('Notes', 'Tala', 'Nota') };
  const when = { key: 'when', type: 'datetime', required: true, label: L('Preferred date and time', 'Gustong petsa at oras', 'Gusto nga petsa ug oras') };
  const freeBefore = (hours: number) =>
    L(`Free to cancel up to ${hours} hours before.`, `Libreng kanselahin hanggang ${hours} oras bago.`, `Libre ang pagkansela hangtod ${hours} ka oras sa dili pa.`);
  const freeBeforeStart = L('Free to cancel before staff start.', 'Libreng kanselahin bago magsimula ang staff.', 'Libre ang pagkansela sa dili pa magsugod ang staff.');
  const airportFields = [
    { key: 'flight', type: 'text', required: true, label: L('Flight number', 'Numero ng flight', 'Numero sa flight') },
    { key: 'arrival', type: 'datetime', required: true, label: L('Arrival time', 'Oras ng pagdating', 'Oras sa pag-abot') },
    { key: 'persons', type: 'number', required: true, label: L('Passengers', 'Pasahero', 'Pasahero') },
  ];
  const services: ServiceSeed[] = [
    {
      was: 'Airport transfer',
      category: 'airport',
      name: L('Airport pickup (sedan)', 'Sundo sa airport (sedan)', 'Sundo sa airport (sedan)'),
      description: L(
        'Private sedan for up to 3 guests from Francisco Bangoy International Airport (DVO), about 10 km and 25 to 40 minutes away. Price per trip.',
        'Pribadong sedan para sa hanggang 3 bisita mula sa Francisco Bangoy International Airport (DVO), mga 10 km at 25 hanggang 40 minuto. Presyo kada biyahe.',
        'Pribadong sedan para hangtod 3 ka bisita gikan sa Francisco Bangoy International Airport (DVO), mga 10 km ug 25 hangtod 40 minutos. Presyo matag biyahe.',
      ),
      schedule: { days: EVERY_DAY, from: '04:00', to: '23:00' },
      leadTimeMin: 180,
      etaMin: 40,
      priceModel: 'FIXED',
      basePrice: 900,
      paymentMethods: pay,
      fields: airportFields,
      department: 'Front Office',
      acceptanceMode: 'AUTO',
      statusSteps: ['requested', 'accepted', 'driver_assigned', 'completed'],
      cancellationPolicy: freeBefore(3),
    },
    {
      category: 'airport',
      name: L('Airport pickup (van)', 'Sundo sa airport (van)', 'Sundo sa airport (van)'),
      description: L(
        'Private van for up to 10 guests with luggage from DVO airport to the hotel. Price per trip.',
        'Pribadong van para sa hanggang 10 bisita at bagahe mula DVO airport papunta sa hotel. Presyo kada biyahe.',
        'Pribadong van para hangtod 10 ka bisita ug bagahe gikan sa DVO airport padulong sa hotel. Presyo matag biyahe.',
      ),
      schedule: { days: EVERY_DAY, from: '04:00', to: '23:00' },
      leadTimeMin: 360,
      etaMin: 40,
      priceModel: 'FIXED',
      basePrice: 1800,
      paymentMethods: pay,
      fields: airportFields,
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'driver_assigned', 'completed'],
      cancellationPolicy: freeBefore(6),
    },
    {
      category: 'stay',
      name: L('Early check-in or late check-out', 'Maagang check-in o late check-out', 'Sayo nga check-in o late check-out'),
      description: L(
        'Arrive before 14:00 or stay past 12:00. ₱150 per hour, up to 3 hours, subject to room availability.',
        'Dumating bago 14:00 o manatili lampas 12:00. ₱150 kada oras, hanggang 3 oras, depende sa bakanteng kuwarto.',
        'Moabot sa dili pa 14:00 o magpabilin lapas 12:00. ₱150 matag oras, hangtod 3 ka oras, depende kung naay bakante nga kwarto.',
      ),
      schedule: { days: EVERY_DAY, from: '06:00', to: '22:00' },
      leadTimeMin: 60,
      etaMin: 30,
      priceModel: 'PER_ITEM',
      basePrice: 150,
      paymentMethods: pay,
      fields: [
        {
          key: 'kind',
          type: 'select',
          required: true,
          label: L('Request', 'Hiling', 'Hangyo'),
          options: [
            { value: 'early', label: L('Early check-in', 'Maagang check-in', 'Sayo nga check-in') },
            { value: 'late', label: L('Late check-out', 'Late check-out', 'Late check-out') },
          ],
        },
        { key: 'quantity', type: 'number', required: true, label: L('Hours (max 3)', 'Oras (hanggang 3)', 'Oras (hangtod 3)') },
      ],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'completed'],
      cancellationPolicy: freeBeforeStart,
    },
    {
      category: 'stay',
      name: L('Stay extension (up to 12 hours)', 'Extension ng pananatili (hanggang 12 oras)', 'Extension sa pagpuyo (hangtod 12 ka oras)'),
      description: L(
        'Keep your room for up to 12 more hours. Usually half the nightly rate; the front desk confirms the price for your room.',
        'Manatili sa kuwarto nang hanggang 12 oras pa. Karaniwang kalahati ng presyo kada gabi; kukumpirmahin ng front desk ang presyo.',
        'Magpabilin sa kwarto hangtod 12 ka oras pa. Kasagaran katunga sa presyo matag gabii; ang front desk ang mokumpirma sa presyo.',
      ),
      schedule: { days: EVERY_DAY, from: '06:00', to: '22:00' },
      leadTimeMin: 60,
      etaMin: 30,
      priceModel: 'QUOTE',
      basePrice: null,
      paymentMethods: pay,
      fields: [{ key: 'hours', type: 'number', required: true, label: L('Extra hours', 'Dagdag na oras', 'Dugang nga oras') }, notes],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'quoted', 'accepted', 'completed'],
      cancellationPolicy: freeBeforeStart,
    },
    {
      was: 'Laundry (wash & fold)',
      category: 'laundry',
      name: L('Laundry (wash, dry & fold)', 'Labada (laba, patuyo at tiklop)', 'Labada (laba, pauga ug pilo)'),
      description: L(
        'Picked up from your room and returned within 24 hours. ₱50 per kilo, 3 kilo minimum.',
        'Kukunin sa kuwarto at ibabalik sa loob ng 24 oras. ₱50 kada kilo, minimum na 3 kilo.',
        'Kuhaon sa kwarto ug ibalik sulod sa 24 oras. ₱50 matag kilo, minimum nga 3 ka kilo.',
      ),
      schedule: { days: EVERY_DAY, from: '07:00', to: '20:00' },
      leadTimeMin: 30,
      etaMin: 1440,
      priceModel: 'PER_ITEM',
      basePrice: 50,
      paymentMethods: pay,
      fields: [{ key: 'quantity', type: 'number', required: true, label: L('Kilos (min 3)', 'Kilo (min 3)', 'Kilo (min 3)') }, notes],
      department: 'Housekeeping',
      acceptanceMode: 'AUTO',
      statusSteps: ['requested', 'accepted', 'picked_up', 'processing', 'delivered', 'completed'],
      cancellationPolicy: L('Free to cancel before pickup.', 'Libreng kanselahin bago kunin.', 'Libre ang pagkansela sa dili pa kuhaon.'),
      options: [{ name: L('Same-day express', 'Express (parehong araw)', 'Express (parehas nga adlaw)'), priceDelta: 20 }],
    },
    {
      category: 'laundry',
      name: L('Ironing', 'Plantsa', 'Plantsa'),
      description: L('Shirts, trousers or dresses pressed and returned to your room. Price per piece.', 'Pinaplantsa ang damit at ibinabalik sa kuwarto. Presyo kada piraso.', 'Plantsahon ang sinina ug ibalik sa kwarto. Presyo matag piraso.'),
      schedule: { days: EVERY_DAY, from: '07:00', to: '20:00' },
      leadTimeMin: 30,
      etaMin: 180,
      priceModel: 'PER_ITEM',
      basePrice: 30,
      paymentMethods: pay,
      fields: [{ key: 'quantity', type: 'number', required: true, label: L('Pieces', 'Piraso', 'Piraso') }, notes],
      department: 'Housekeeping',
      acceptanceMode: 'AUTO',
      statusSteps: ['requested', 'accepted', 'picked_up', 'delivered', 'completed'],
      cancellationPolicy: L('Free to cancel before pickup.', 'Libreng kanselahin bago kunin.', 'Libre ang pagkansela sa dili pa kuhaon.'),
    },
    {
      category: 'housekeeping',
      name: L('Extra bed with linens', 'Dagdag na kama na may kumot', 'Dugang nga higdaanan nga adunay habol'),
      description: L('A folding bed with fresh linens and a pillow. Price per night of your stay.', 'Folding bed na may malinis na kumot at unan. Presyo kada gabi ng pananatili.', 'Folding bed nga adunay limpyo nga habol ug unlan. Presyo matag gabii sa pagpuyo.'),
      schedule: { days: EVERY_DAY, from: '08:00', to: '21:00' },
      leadTimeMin: 60,
      etaMin: 60,
      priceModel: 'PER_NIGHT',
      basePrice: 400,
      paymentMethods: pay,
      fields: [notes],
      department: 'Housekeeping',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'delivered', 'completed'],
      cancellationPolicy: freeBeforeStart,
    },
    {
      category: 'housekeeping',
      name: L('Extra towel set', 'Dagdag na tuwalya', 'Dugang nga tualya'),
      description: L('One bath towel and one hand towel delivered to your room.', 'Isang bath towel at isang hand towel na ihahatid sa kuwarto.', 'Usa ka bath towel ug usa ka hand towel nga ihatod sa kwarto.'),
      schedule: { days: EVERY_DAY, from: '07:00', to: '22:00' },
      leadTimeMin: 0,
      etaMin: 20,
      priceModel: 'FIXED',
      basePrice: 80,
      paymentMethods: pay,
      fields: [notes],
      department: 'Housekeeping',
      acceptanceMode: 'AUTO',
      statusSteps: ['requested', 'accepted', 'delivered', 'completed'],
      cancellationPolicy: freeBeforeStart,
    },
    {
      category: 'wellness',
      name: L('In-room massage (60 min)', 'Masahe sa kuwarto (60 min)', 'Masahe sa kwarto (60 min)'),
      description: L(
        'Traditional hilot or Swedish massage in your room by a partner therapist. Book at least 2 hours ahead.',
        'Hilot o Swedish na masahe sa kuwarto mula sa partner therapist. Mag-book nang 2 oras bago.',
        'Hilot o Swedish nga masahe sa kwarto gikan sa partner therapist. Pag-book 2 ka oras sa dili pa.',
      ),
      schedule: { days: EVERY_DAY, from: '10:00', to: '22:00' },
      leadTimeMin: 120,
      etaMin: 60,
      priceModel: 'FIXED',
      basePrice: 600,
      paymentMethods: pay,
      fields: [when, notes],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'therapist_assigned', 'completed'],
      cancellationPolicy: freeBefore(2),
      options: [{ name: L('Extend to 90 min', 'Gawing 90 min', 'Himoong 90 min'), priceDelta: 300 }],
    },
    {
      category: 'tour',
      name: L('Half-day city tour', 'Half-day na city tour', 'Half-day nga city tour'),
      description: L(
        'Van with driver for up to 10 guests, about 4 hours: San Pedro Cathedral, People\'s Park, Museo Dabawenyo and a pasalubong stop. Price per van.',
        'Van na may driver para sa hanggang 10 bisita, mga 4 na oras: San Pedro Cathedral, People\'s Park, Museo Dabawenyo at pasalubong. Presyo kada van.',
        'Van nga adunay driver para hangtod 10 ka bisita, mga 4 ka oras: San Pedro Cathedral, People\'s Park, Museo Dabawenyo ug pasalubong. Presyo matag van.',
      ),
      schedule: { days: EVERY_DAY, from: '08:00', to: '14:00' },
      leadTimeMin: 1440,
      etaMin: 240,
      priceModel: 'FIXED',
      basePrice: 2900,
      paymentMethods: pay,
      fields: [when, { key: 'persons', type: 'number', required: true, label: L('Guests', 'Bisita', 'Bisita') }],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'driver_assigned', 'completed'],
      cancellationPolicy: freeBefore(24),
    },
    {
      category: 'tour',
      name: L('Samal Island day trip', 'Day trip sa Samal Island', 'Day trip sa Samal Island'),
      description: L(
        'Land transfer to Sasa Wharf, ferry to Samal, beach day and lunch, back by 17:00. Price per person.',
        'Sakay papuntang Sasa Wharf, ferry papuntang Samal, araw sa beach at tanghalian, balik bago 17:00. Presyo kada tao.',
        'Sakay padulong sa Sasa Wharf, ferry padulong sa Samal, adlaw sa baybayon ug paniudto, balik sa dili pa 17:00. Presyo matag tawo.',
      ),
      schedule: { days: EVERY_DAY, from: '07:00', to: '09:00' },
      leadTimeMin: 1440,
      etaMin: 600,
      priceModel: 'PER_PERSON',
      basePrice: 1900,
      paymentMethods: pay,
      fields: [when, { key: 'persons', type: 'number', required: true, label: L('Guests', 'Bisita', 'Bisita') }],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'completed'],
      cancellationPolicy: freeBefore(24),
    },
    {
      category: 'transport',
      name: L('Scooter rental', 'Paupa ng scooter', 'Abang sa scooter'),
      description: L(
        '125cc scooter with two helmets. ₱500 per day. A valid driver\'s license is required.',
        '125cc na scooter na may dalawang helmet. ₱500 kada araw. Kailangan ng valid na lisensya.',
        '125cc nga scooter nga adunay duha ka helmet. ₱500 matag adlaw. Kinahanglan og valid nga lisensya.',
      ),
      schedule: { days: EVERY_DAY, from: '07:00', to: '18:00' },
      leadTimeMin: 120,
      etaMin: 30,
      priceModel: 'PER_ITEM',
      basePrice: 500,
      paymentMethods: pay,
      fields: [
        { key: 'quantity', type: 'number', required: true, label: L('Days', 'Araw', 'Adlaw') },
        { key: 'license', type: 'checkbox', required: true, label: L('I have a valid driver\'s license', 'May valid akong lisensya', 'Naa koy valid nga lisensya') },
      ],
      department: 'Front Office',
      acceptanceMode: 'STAFF_APPROVAL',
      statusSteps: ['requested', 'accepted', 'handed_over', 'returned', 'completed'],
      cancellationPolicy: freeBeforeStart,
    },
  ];
  for (const { was, department, options = [], fields, ...s } of services) {
    const data = {
      ...s,
      fields: fields as Prisma.InputJsonValue,
      status: 'PUBLISHED' as const,
      currency: 'PHP',
      taxIncluded: true,
      departmentId: dept[department],
      loyaltyEarn: true,
    };
    const found = await prisma.service.findFirst({ where: { hotelId: hotel.id, ...byEn('name', s.name.en, was) } });
    if (found) {
      await prisma.service.update({ where: { id: found.id }, data: { ...data, options: { deleteMany: {}, create: options } } });
    } else {
      await prisma.service.create({ data: { ...data, hotelId: hotel.id, options: { create: options } } });
    }
  }

  // ── Lobby café (QR ordering) ──
  const outletData = {
    name: L('Kapehan sa Lunhaw (lobby café)', 'Kapehan sa Lunhaw (café sa lobby)', 'Kapehan sa Lunhaw (café sa lobby)'),
    schedule: { days: EVERY_DAY, from: '06:00', to: '22:00' },
  };
  const existingOutlet = await prisma.outlet.findFirst({ where: { hotelId: hotel.id } });
  const outlet = existingOutlet
    ? await prisma.outlet.update({ where: { id: existingOutlet.id }, data: outletData })
    : await prisma.outlet.create({ data: { ...outletData, hotelId: hotel.id } });

  for (const label of ['T1', 'T2', 'T3', 'T4', 'T5', 'T6']) {
    if (await prisma.restaurantTable.findFirst({ where: { outletId: outlet.id, label } })) continue;
    const table = await prisma.restaurantTable.create({ data: { outletId: outlet.id, label } });
    // Tokens are only shown here; the DB keeps the hash. Re-issue from Admin › Restaurant if lost.
    const token = randomBytes(24).toString('base64url');
    await prisma.tableQrToken.create({ data: { tableId: table.id, tokenHash: sha256(token) } });
    console.log(`Table ${table.label} QR: tuloy://table/${token}`);
  }

  const cat = {
    breakfast: L('Breakfast (silog)', 'Almusal (silog)', 'Pamahaw (silog)'),
    rice: L('Rice meals', 'Kanin at ulam', 'Kan-on ug sud-an'),
    snacks: L('Noodles & snacks', 'Pansit at meryenda', 'Pansit ug meryenda'),
    drinks: L('Drinks', 'Inumin', 'Ilimnon'),
  };
  const menu: { category: L10n; name: L10n; price: number; allergens: string[]; description?: L10n }[] = [
    { category: cat.breakfast, name: L('Tapsilog', 'Tapsilog', 'Tapsilog'), price: 185, allergens: ['soy', 'egg'], description: L('Beef tapa, garlic rice and egg.', 'Tapang baka, sinangag at itlog.', 'Tapang baka, sinangag ug itlog.') },
    { category: cat.breakfast, name: L('Longsilog', 'Longsilog', 'Longsilog'), price: 165, allergens: ['egg'], description: L('Sweet pork longganisa, garlic rice and egg.', 'Matamis na longganisa, sinangag at itlog.', 'Tam-is nga longganisa, sinangag ug itlog.') },
    { category: cat.breakfast, name: L('Tocilog', 'Tocilog', 'Tocilog'), price: 165, allergens: ['egg'], description: L('Pork tocino, garlic rice and egg.', 'Tocino, sinangag at itlog.', 'Tocino, sinangag ug itlog.') },
    { category: cat.breakfast, name: L('Bangsilog', 'Bangsilog', 'Bangsilog'), price: 195, allergens: ['fish', 'egg'], description: L('Fried marinated milkfish, garlic rice and egg.', 'Pritong daing na bangus, sinangag at itlog.', 'Prito nga daing nga bangus, sinangag ug itlog.') },
    { category: cat.rice, name: L('Grilled tuna panga', 'Inihaw na panga ng tuna', 'Sinugbang panga sa tuna'), price: 340, allergens: ['fish', 'soy'], description: L('Davao-style grilled tuna jaw with rice and soy-calamansi dip.', 'Inihaw na panga ng tuna, may kanin at toyo-kalamansi.', 'Sinugbang panga sa tuna, adunay kan-on ug toyo-kalamansi.') },
    { category: cat.rice, name: L('Pork humba', 'Humbang baboy', 'Humbang baboy'), price: 210, allergens: ['soy'] },
    { category: cat.rice, name: L('Chicken adobo', 'Adobong manok', 'Adobong manok'), price: 195, allergens: ['soy'] },
    { category: cat.rice, name: L('Sinigang na baboy', 'Sinigang na baboy', 'Sinigang nga baboy'), price: 250, allergens: [] },
    { category: cat.rice, name: L('Extra rice', 'Dagdag na kanin', 'Dugang nga kan-on'), price: 25, allergens: [] },
    { category: cat.snacks, name: L('Pancit canton', 'Pansit canton', 'Pansit canton'), price: 180, allergens: ['gluten', 'soy', 'shellfish'] },
    { category: cat.snacks, name: L('Lumpiang shanghai (8 pcs)', 'Lumpiang shanghai (8 piraso)', 'Lumpiang shanghai (8 ka buok)'), price: 140, allergens: ['gluten'] },
    { category: cat.snacks, name: L('Siomai (6 pcs)', 'Siomai (6 piraso)', 'Siomai (6 ka buok)'), price: 110, allergens: ['gluten', 'soy', 'shellfish'] },
    { category: cat.snacks, name: L('Clubhouse sandwich', 'Clubhouse sandwich', 'Clubhouse sandwich'), price: 175, allergens: ['gluten', 'egg', 'dairy'] },
    { category: cat.snacks, name: L('Fries', 'Fries', 'Fries'), price: 95, allergens: [] },
    { category: cat.drinks, name: L('Brewed coffee', 'Brewed na kape', 'Brewed nga kape'), price: 80, allergens: [] },
    { category: cat.drinks, name: L('Iced tea', 'Iced tea', 'Iced tea'), price: 60, allergens: [] },
    { category: cat.drinks, name: L('Calamansi juice', 'Katas ng kalamansi', 'Duga sa kalamansi'), price: 70, allergens: [] },
    { category: cat.drinks, name: L('Soft drink', 'Softdrinks', 'Softdrinks'), price: 55, allergens: [] },
    { category: cat.drinks, name: L('Bottled water', 'Bottled water', 'Bottled water'), price: 30, allergens: [] },
    { category: cat.drinks, name: L('Mango shake', 'Mango shake', 'Mango shake'), price: 120, allergens: ['dairy'] },
    { category: cat.drinks, name: L('Durian shake', 'Durian shake', 'Durian shake'), price: 150, allergens: ['dairy'], description: L('A Davao favourite. Enjoy it here: durian is not allowed in rooms.', 'Paborito sa Davao. Dito lang inumin: bawal ang durian sa kuwarto.', 'Paborito sa Davao. Diri lang imna: dili pwede ang durian sa kwarto.') },
    { category: cat.drinks, name: L('Local beer', 'Lokal na beer', 'Lokal nga beer'), price: 95, allergens: ['gluten'], description: L('Not sold from 01:00 to 08:00 (Davao City Liquor Code).', 'Hindi ibinebenta mula 01:00 hanggang 08:00 (Liquor Code ng Davao City).', 'Dili ibaligya gikan 01:00 hangtod 08:00 (Liquor Code sa Davao City).') },
  ];
  for (const item of menu) {
    const found = await prisma.menuItem.findFirst({ where: { outletId: outlet.id, ...byEn('name', item.name.en) } });
    const data = { ...item, description: item.description ?? Prisma.DbNull, available: true };
    if (found) await prisma.menuItem.update({ where: { id: found.id }, data });
    else await prisma.menuItem.create({ data: { ...data, outletId: outlet.id } });
  }

  // ── Hotel guide and promotions (G13) ──
  const guide: { title: L10n; body: L10n }[] = [
    {
      title: L('Welcome & house rules', 'Maligayang pagdating at mga patakaran', 'Maayong pag-abot ug mga lagda'),
      body: L(
        'Welcome to Lunhaw Suites Davao. The front desk on the ground floor is open 24 hours; dial 0 from your room phone. Check-in from 14:00, check-out by 12:00. All rooms are non-smoking. No pets. Durian is not allowed in rooms. A refundable deposit is collected at check-in and returned after a quick room check.',
        'Maligayang pagdating sa Lunhaw Suites Davao. Bukas ang front desk sa ground floor nang 24 oras; i-dial ang 0 sa telepono ng kuwarto. Check-in mula 14:00, check-out bago 12:00. Bawal manigarilyo sa lahat ng kuwarto. Bawal ang alagang hayop. Bawal ang durian sa kuwarto. May deposito sa check-in na ibabalik pagkatapos suriin ang kuwarto.',
        'Maayong pag-abot sa Lunhaw Suites Davao. Abli ang front desk sa ground floor 24 oras; i-dial ang 0 sa telepono sa kwarto. Check-in gikan 14:00, check-out sa dili pa 12:00. Dili pwede manigarilyo sa tanang kwarto. Dili pwede ang binuhi nga hayop. Dili pwede ang durian sa kwarto. Adunay deposito sa check-in nga ibalik human susihon ang kwarto.',
      ),
    },
    {
      title: L('Wi-Fi & TV help', 'Tulong sa Wi-Fi at TV', 'Tabang sa Wi-Fi ug TV'),
      body: L(
        'Join the "Lunhaw-Guest" network; your login is in the app after check-in. If the signal is weak, try the lobby or ask the front desk to restart the router on your floor. The smart TV has streaming apps: sign in with your own account and sign out before you leave.',
        'Kumonekta sa "Lunhaw-Guest"; nasa app ang login pagkatapos mag-check-in. Kung mahina ang signal, subukan sa lobby o ipa-restart sa front desk ang router sa inyong palapag. May streaming apps ang smart TV: gamitin ang sariling account at mag-sign out bago umalis.',
        'Konektar sa "Lunhaw-Guest"; naa sa app ang login human sa check-in. Kung huyang ang signal, sulayi sa lobby o ipa-restart sa front desk ang router sa inyong andana. Adunay streaming apps ang smart TV: gamita ang kaugalingong account ug pag-sign out sa dili pa mobiya.',
      ),
    },
    {
      title: L('Quiet hours & mosquito repellent', 'Oras ng katahimikan at panlaban sa lamok', 'Oras sa kahilom ug pangontra sa lamok'),
      body: L(
        'Quiet hours are 22:00 to 07:00. Please keep doors closed and voices low in the hallways. Mosquito repellent is free at the front desk; ask housekeeping if you see any pests.',
        'Ang oras ng katahimikan ay 22:00 hanggang 07:00. Isara ang pinto at hinaan ang boses sa pasilyo. Libre ang panlaban sa lamok sa front desk; sabihan ang housekeeping kung may peste.',
        'Ang oras sa kahilom kay 22:00 hangtod 07:00. Isira ang pultahan ug hinayi ang tingog sa pasilyo. Libre ang pangontra sa lamok sa front desk; ingna ang housekeeping kung naay peste.',
      ),
    },
    {
      title: L('Emergency: dial 911', 'Emergency: i-dial ang 911', 'Emergency: i-dial ang 911'),
      body: L(
        'For police, fire or medical emergencies, dial 911 (Davao City Central 911) from any mobile network. Then call the front desk (dial 0) so staff can guide responders to your room. Fire exits are at both ends of every floor.',
        'Para sa pulis, sunog o medikal na emergency, i-dial ang 911 (Davao City Central 911) mula sa anumang network. Pagkatapos, tawagan ang front desk (i-dial ang 0) para gabayan ng staff ang rescuer. Nasa magkabilang dulo ng bawat palapag ang fire exit.',
        'Para sa pulis, sunog o medikal nga emergency, i-dial ang 911 (Davao City Central 911) gikan sa bisan unsang network. Dayon tawgi ang front desk (i-dial ang 0) aron giyahan sa staff ang rescuer. Naa sa duha ka tumoy sa matag andana ang fire exit.',
      ),
    },
    {
      title: L('Davao City smoking & liquor rules', 'Patakaran sa paninigarilyo at alak sa Davao', 'Lagda sa pagpanigarilyo ug ilimnon sa Davao'),
      body: L(
        'Davao City strictly enforces its anti-smoking ordinance: smoking (including vapes) is only allowed in designated areas, and fines start at ₱1,000 and rise to ₱5,000 with possible jail time for repeat offences. Under the city Liquor Code, alcohol is not sold from 01:00 to 08:00 and drinking in public places is not allowed. Use the hotel\'s designated smoking area by the parking lot.',
        'Mahigpit ang Davao City sa anti-smoking ordinance: sa itinalagang lugar lang puwedeng manigarilyo (kasama ang vape), at ang multa ay mula ₱1,000 hanggang ₱5,000 at posibleng kulong kapag inulit. Ayon sa Liquor Code, walang bentahan ng alak mula 01:00 hanggang 08:00 at bawal uminom sa pampublikong lugar. Gamitin ang smoking area ng hotel sa tabi ng paradahan.',
        'Estrikto ang Davao City sa anti-smoking ordinance: sa gitudlo nga lugar lang pwede manigarilyo (apil ang vape), ug ang multa gikan ₱1,000 hangtod ₱5,000 ug posible nga priso kung balikon. Sumala sa Liquor Code, walay baligya sa ilimnon gikan 01:00 hangtod 08:00 ug dili pwede moinom sa publiko nga lugar. Gamita ang smoking area sa hotel tupad sa parkinganan.',
      ),
    },
    {
      title: L('Getting here from DVO airport', 'Paano pumunta mula DVO airport', 'Unsaon pag-abot gikan sa DVO airport'),
      body: L(
        'Francisco Bangoy International Airport (DVO) is about 10 km away, 25 to 40 minutes by car depending on traffic. A Grab or metered taxi costs roughly ₱100 to ₱250. Ask the driver for Poblacion, near Bankerohan. You can also book our airport pickup in the app.',
        'Mga 10 km ang Francisco Bangoy International Airport (DVO), 25 hanggang 40 minuto sakay ng kotse depende sa trapiko. Mga ₱100 hanggang ₱250 ang Grab o metered taxi. Sabihin sa driver: Poblacion, malapit sa Bankerohan. Puwede ring mag-book ng sundo sa app.',
        'Mga 10 km ang Francisco Bangoy International Airport (DVO), 25 hangtod 40 minutos sakay sa awto depende sa trapiko. Mga ₱100 hangtod ₱250 ang Grab o metered taxi. Ingna ang driver: Poblacion, duol sa Bankerohan. Pwede pud mag-book og sundo sa app.',
      ),
    },
    {
      title: L('Nearby on foot', 'Malapit na lakarin', 'Duol nga malakaw'),
      body: L(
        'Within a 10-minute walk: Bankerohan Public Market (try durian and pomelo, but enjoy them outside the hotel), St. Jude Thaddeus Parish, the Philippine Eagle sculpture and People\'s Park with its durian-shaped dome. San Pedro Cathedral, the city\'s oldest church, is about 1.5 km away. In the evening, take a short ride to Roxas Night Market for street food.',
        'Sa loob ng 10 minutong lakad: Bankerohan Public Market (tikman ang durian at pomelo, pero sa labas ng hotel), St. Jude Thaddeus Parish, ang eskultura ng Philippine Eagle at People\'s Park. Mga 1.5 km ang San Pedro Cathedral, ang pinakamatandang simbahan sa lungsod. Sa gabi, sumakay papuntang Roxas Night Market para sa street food.',
        'Sulod sa 10 minutos nga lakaw: Bankerohan Public Market (tilawi ang durian ug pomelo, pero sa gawas sa hotel), St. Jude Thaddeus Parish, ang eskultura sa Philippine Eagle ug People\'s Park. Mga 1.5 km ang San Pedro Cathedral, ang pinakakaraan nga simbahan sa siyudad. Sa gabii, sakay padulong sa Roxas Night Market para sa street food.',
      ),
    },
    {
      title: L('Day trips', 'Mga day trip', 'Mga day trip'),
      body: L(
        'Philippine Eagle Center and Malagos Garden Resort in Calinan, Eden Nature Park (about an hour\'s drive), Crocodile Park, and Jack\'s Ridge for the city view. Samal Island is about 10 minutes by ferry from Sasa Wharf. Check current ferry schedules before you go, or book our Samal day trip.',
        'Philippine Eagle Center at Malagos Garden Resort sa Calinan, Eden Nature Park (mga isang oras na biyahe), Crocodile Park, at Jack\'s Ridge para sa tanawin ng lungsod. Mga 10 minuto ang ferry papuntang Samal Island mula Sasa Wharf. Tingnan ang schedule ng ferry bago umalis, o i-book ang aming Samal day trip.',
        'Philippine Eagle Center ug Malagos Garden Resort sa Calinan, Eden Nature Park (mga usa ka oras nga biyahe), Crocodile Park, ug Jack\'s Ridge para sa talan-awon sa siyudad. Mga 10 minutos ang ferry padulong sa Samal Island gikan sa Sasa Wharf. Tan-awa ang schedule sa ferry sa dili pa mobiya, o i-book ang among Samal day trip.',
      ),
    },
    {
      title: L('Kadayawan festival notice', 'Paalala sa Kadayawan', 'Pahibalo sa Kadayawan'),
      body: L(
        'Davao celebrates Kadayawan every August. Expect road closures and heavy traffic downtown, especially on the grand parade weekend in mid-August. Allow extra time for airport trips.',
        'Ipinagdiriwang ng Davao ang Kadayawan tuwing Agosto. Asahan ang sarado na kalsada at matinding trapiko sa downtown, lalo na sa weekend ng parada sa kalagitnaan ng Agosto. Maglaan ng dagdag na oras papuntang airport.',
        'Gisaulog sa Davao ang Kadayawan matag Agosto. Pagpaabot og sirado nga dalan ug grabe nga trapiko sa downtown, labi na sa weekend sa parada sa tunga-tunga sa Agosto. Paghatag og dugang nga oras padulong sa airport.',
      ),
    },
  ];
  const promotions: { title: L10n; body: L10n; expiresAt?: Date }[] = [
    {
      title: L('Kadayawan Stay: 15% off', 'Kadayawan Stay: 15% diskwento', 'Kadayawan Stay: 15% hapsay'),
      body: L(
        '15% off overnight stays from August 1 to 31, minimum 2 nights. Show this offer at the front desk when you check in.',
        '15% diskwento sa overnight stay mula Agosto 1 hanggang 31, minimum na 2 gabi. Ipakita ang alok na ito sa front desk pag-check-in.',
        '15% hapsay sa overnight nga pagpuyo gikan Agosto 1 hangtod 31, minimum nga 2 ka gabii. Ipakita kini nga tanyag sa front desk sa pag-check-in.',
      ),
      expiresAt: new Date('2027-09-01T00:00:00+08:00'),
    },
    {
      title: L('Stay 3, Save More', 'Stay 3, Save More', 'Stay 3, Save More'),
      body: L('10% off stays of 3 nights or more, any room type.', '10% diskwento sa pananatili nang 3 gabi o higit pa, anumang kuwarto.', '10% hapsay sa pagpuyo nga 3 ka gabii o labaw pa, bisan unsang kwarto.'),
    },
    {
      title: L('Day Use Saver: 6 hours for ₱499', 'Day Use Saver: 6 oras sa ₱499', 'Day Use Saver: 6 ka oras sa ₱499'),
      body: L('Rest between flights or meetings: a 6-hour room block for ₱499, weekdays 09:00 to 17:00. Ask the front desk.', 'Magpahinga sa pagitan ng flight o meeting: 6 na oras na kuwarto sa ₱499, weekdays 09:00 hanggang 17:00. Magtanong sa front desk.', 'Pahulay tali sa flight o meeting: 6 ka oras nga kwarto sa ₱499, weekdays 09:00 hangtod 17:00. Pangutana sa front desk.'),
    },
    {
      title: L('Samal Escape: ₱200 off', 'Samal Escape: ₱200 bawas', 'Samal Escape: ₱200 kubos'),
      body: L('₱200 off the Samal Island day trip when you book it with your room.', '₱200 bawas sa Samal Island day trip kapag kasama sa booking ng kuwarto.', '₱200 kubos sa Samal Island day trip kung iapil sa booking sa kwarto.'),
    },
  ];
  // Retire the previous demo's guide items (no FKs point at content).
  await prisma.contentItem.deleteMany({ where: { hotelId: hotel.id, kind: 'guide', OR: ['Front desk & Wi-Fi', 'Breakfast', 'Pool'].map((v) => ({ title: { path: ['en'], equals: v } })) } });
  const content: { kind: string; title: L10n; body: L10n; expiresAt?: Date }[] = [...guide.map((g) => ({ ...g, kind: 'guide' })),...promotions.map((p) => ({ ...p, kind: 'promotion' }))];
  for (const [i, c] of content.entries()) {
    // Spaced publish times keep the listed order (the API sorts by publishedAt).
    const data = { ...c, expiresAt: c.expiresAt ?? null, publishedAt: new Date(Date.UTC(2026, 0, 1, 0, i)) };
    const found = await prisma.contentItem.findFirst({ where: { hotelId: hotel.id, kind: c.kind, ...byEn('title', c.title.en) } });
    if (found) await prisma.contentItem.update({ where: { id: found.id }, data });
    else await prisma.contentItem.create({ data: { ...data, hotelId: hotel.id } });
  }

  // ── Loyalty rewards (1 point per ₱100 spent; see policies.loyalty) ──
  const rewards = [
    { name: L('₱200 off your stay', '₱200 bawas sa pananatili', '₱200 kubos sa pagpuyo'), points: 200, value: 200 },
    { name: L('₱500 off your stay', '₱500 bawas sa pananatili', '₱500 kubos sa pagpuyo'), points: 450, value: 500 },
    { name: L('One Standard Double night (₱1,290 off)', 'Isang gabi sa Standard Double (₱1,290 bawas)', 'Usa ka gabii sa Standard Double (₱1,290 kubos)'), points: 1100, value: 1290 },
  ];
  for (const r of rewards) {
    const found = await prisma.loyaltyReward.findFirst({ where: { hotelId: hotel.id, ...byEn('name', r.name.en) } });
    if (found) await prisma.loyaltyReward.update({ where: { id: found.id }, data: { ...r, active: true } });
    else await prisma.loyaltyReward.create({ data: { ...r, hotelId: hotel.id } });
  }

  console.log(`Seeded ${hotel.name} (${hotel.id})`);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
