/// Override at build/run time:
///   flutter run --dart-define=API_URL=http://10.0.2.2:3000/v1   (Android emulator)
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000/v1');

/// Single hotel in the first release. Matches DEMO_HOTEL_ID in tuloy-api/prisma/seed.ts.
const hotelId = String.fromEnvironment('HOTEL_ID', defaultValue: 'b6a7c0de-1d2e-4f3a-9b8c-7d6e5f4a3b21');

const supportedLanguages = {'en': 'English', 'fil': 'Filipino', 'ceb': 'Bisaya'};
