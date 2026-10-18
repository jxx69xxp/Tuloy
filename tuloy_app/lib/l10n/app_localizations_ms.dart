// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malay (`ms`).
class AppLocalizationsMs extends AppLocalizations {
  AppLocalizationsMs([String locale = 'ms']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Log masuk';

  @override
  String get signUp => 'Cipta akaun';

  @override
  String get signOut => 'Log keluar';

  @override
  String get noAccount => 'Belum ada akaun?';

  @override
  String get haveAccount => 'Sudah ada akaun?';

  @override
  String get emailOrPhone => 'E-mel atau nombor telefon';

  @override
  String get password => 'Kata laluan';

  @override
  String get passwordHint => 'Sekurang-kurangnya 8 aksara';

  @override
  String get fullName => 'Nama penuh';

  @override
  String get required => 'Wajib';

  @override
  String get forgotPassword => 'Lupa kata laluan?';

  @override
  String get sendCode => 'Hantar kod';

  @override
  String get codeSent => 'Jika akaun wujud, kami telah menghantar kod 6 digit.';

  @override
  String get code => 'Kod 6 digit';

  @override
  String get newPassword => 'Kata laluan baharu';

  @override
  String get resetPassword => 'Tetapkan semula kata laluan';

  @override
  String get passwordChanged => 'Kata laluan ditukar. Sila log masuk.';

  @override
  String get settings => 'Tetapan';

  @override
  String get language => 'Bahasa';

  @override
  String get guestHome => 'Selamat datang';

  @override
  String get staffHome => 'Kakitangan';

  @override
  String get adminHome => 'Pentadbir';

  @override
  String get comingSoon => 'Lebih banyak ciri dalam keluaran akan datang.';

  @override
  String get errorGeneric =>
      'Tidak dapat menghubungi pelayan. Semak sambungan anda.';

  @override
  String get cannotReachServer =>
      'Tidak dapat menghubungi pelayan. Semak sambungan anda, atau minta pentadbir membenarkan laman ini.';

  @override
  String hello(String name) {
    return 'Helo, $name';
  }

  @override
  String get retry => 'Cuba lagi';

  @override
  String get howCanWeHelp => 'Apa yang boleh kami bantu?';

  @override
  String get profile => 'Profil';

  @override
  String get stays => 'Penginapan';

  @override
  String get servicesUsed => 'Perkhidmatan digunakan';

  @override
  String get paymentHistory => 'Sejarah pembayaran';

  @override
  String get cardOrEwallet => 'Kad / e-dompet';

  @override
  String get testPayment => 'Pembayaran ujian';

  @override
  String get noneYet => 'Belum ada';

  @override
  String get gettingHere => 'Cara ke sini';

  @override
  String get openInMaps => 'Buka dalam Peta';

  @override
  String get airportRoute => 'Laluan ke lapangan terbang';

  @override
  String get personalDetails => 'Butiran peribadi';

  @override
  String get authTagline =>
      'Penginapan dan semua perkhidmatan, dengan satu sentuhan';

  @override
  String get showPassword => 'Tunjuk kata laluan';

  @override
  String get hidePassword => 'Sembunyi kata laluan';

  @override
  String get findRoom => 'Cari bilik';

  @override
  String get adults => 'Dewasa';

  @override
  String get children => 'Kanak-kanak';

  @override
  String get guests => 'Tetamu';

  @override
  String nightsCount(String count) {
    return 'Malam: $count';
  }

  @override
  String get noRooms => 'Tiada bilik kosong pada tarikh ini. Cuba tarikh lain.';

  @override
  String perNight(String price) {
    return '$price / malam';
  }

  @override
  String roomsLeft(String count) {
    return 'Tinggal $count';
  }

  @override
  String get totalLabel => 'Jumlah';

  @override
  String get amenities => 'Kemudahan';

  @override
  String get policies => 'Polisi';

  @override
  String checkInTime(String time) {
    return 'Daftar masuk dari $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Daftar keluar sebelum $time';
  }

  @override
  String get specialRequests => 'Permintaan khas (pilihan)';

  @override
  String get reserve => 'Tempah';

  @override
  String get review => 'Semak dan bayar';

  @override
  String holdTimer(String time) {
    return 'Kami menahan bilik ini untuk anda selama $time';
  }

  @override
  String get holdExpired => 'Masa tahanan tamat. Sila cari semula.';

  @override
  String get serviceCharge => 'Caj perkhidmatan';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'Bayar deposit $amount';
  }

  @override
  String payFull(String amount) {
    return 'Bayar penuh $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Bayar baki $amount';
  }

  @override
  String get waitingPayment => 'Menunggu pembayaran…';

  @override
  String get waitingPaymentHint =>
      'Selesaikan pembayaran dalam pelayar. Halaman ini dikemas kini sendiri.';

  @override
  String get openPaymentAgain => 'Buka halaman pembayaran semula';

  @override
  String get bookingConfirmed => 'Tempahan disahkan!';

  @override
  String bookingCode(String code) {
    return 'Tempahan $code';
  }

  @override
  String roomNumber(String room) {
    return 'Bilik $room';
  }

  @override
  String get viewBooking => 'Lihat tempahan';

  @override
  String get backHome => 'Kembali ke laman utama';

  @override
  String get paymentFailed =>
      'Tempahan ini tidak lagi ditahan. Jika anda telah dicaj, wang akan dikembalikan.';

  @override
  String get myBookings => 'Tempahan saya';

  @override
  String get noBookings => 'Belum ada tempahan.';

  @override
  String get statusHold => 'Menunggu pembayaran';

  @override
  String get statusPending => 'Belum selesai';

  @override
  String get statusConfirmed => 'Disahkan';

  @override
  String get statusCheckedIn => 'Sudah daftar masuk';

  @override
  String get statusCheckedOut => 'Sudah daftar keluar';

  @override
  String get statusCancelled => 'Dibatalkan';

  @override
  String get statusNoShow => 'Tidak hadir';

  @override
  String get statusDeclined => 'Ditolak';

  @override
  String get statusExpired => 'Tamat tempoh';

  @override
  String get cancelBooking => 'Batalkan tempahan';

  @override
  String cancelConfirm(String refund) {
    return 'Batalkan tempahan ini? Anda akan menerima $refund semula.';
  }

  @override
  String get keepBooking => 'Kekalkan tempahan';

  @override
  String get cancelled => 'Tempahan dibatalkan';

  @override
  String get invoice => 'Invois';

  @override
  String get paid => 'Dibayar';

  @override
  String get balance => 'Baki';

  @override
  String get charges => 'Caj';

  @override
  String get myStay => 'Penginapan saya';

  @override
  String get currentStay => 'Penginapan anda';

  @override
  String get hotelGuide => 'Panduan hotel';

  @override
  String get feedback => 'Maklum balas';

  @override
  String get rateStay => 'Bagaimana penginapan anda?';

  @override
  String get comment => 'Ulasan (pilihan)';

  @override
  String get send => 'Hantar';

  @override
  String get thanksFeedback => 'Terima kasih atas maklum balas anda!';

  @override
  String get accept => 'Terima';

  @override
  String acceptQuote(String amount) {
    return 'Terima sebut harga $amount';
  }

  @override
  String get acceptance => 'Penerimaan';

  @override
  String get active => 'Aktif';

  @override
  String get add => 'Tambah';

  @override
  String get addField => 'Tambah medan';

  @override
  String get addOption => 'Tambah pilihan';

  @override
  String get addOutlet => 'Tambah outlet';

  @override
  String get addPhoto => 'Tambah foto';

  @override
  String get addRoom => 'Tambah bilik';

  @override
  String get addStaff => 'Tambah kakitangan';

  @override
  String get addTable => 'Tambah meja';

  @override
  String get adjustPoints => 'Laraskan mata';

  @override
  String get alerts => 'Amaran';

  @override
  String get all => 'Semua';

  @override
  String get allergens => 'Alergen';

  @override
  String get allergyNotes => 'Alahan atau arahan khas';

  @override
  String get amount => 'Amaun';

  @override
  String get applyLeave => 'Mohon cuti';

  @override
  String get approve => 'Luluskan';

  @override
  String get approved => 'Diluluskan';

  @override
  String get arrivals => 'Ketibaan';

  @override
  String get asSoonAsPossible => 'Secepat mungkin';

  @override
  String get auditLog => 'Log audit';

  @override
  String get autoAccept => 'Terima secara automatik';

  @override
  String get basePrice => 'Harga asas';

  @override
  String get blocks => 'Sekatan bilik';

  @override
  String get body => 'Teks';

  @override
  String get cancel => 'Batal';

  @override
  String get cancelOrder => 'Batalkan pesanan';

  @override
  String get cancelRequest => 'Batalkan permintaan';

  @override
  String get cancellationPolicy => 'Polisi pembatalan';

  @override
  String get category => 'Kategori';

  @override
  String get chargeToRoom => 'Caj ke bilik saya';

  @override
  String get chat => 'Sembang';

  @override
  String get chatEmpty => 'Hantar mesej kepada kaunter depan.';

  @override
  String get chatWithHotel => 'Sembang dengan hotel';

  @override
  String get checkInAction => 'Daftar masuk';

  @override
  String get checkOutAction => 'Daftar keluar';

  @override
  String get choices => 'Pilihan (pisahkan dengan koma)';

  @override
  String get closes => 'Tutup';

  @override
  String get codeLabel => 'Kod';

  @override
  String get collectedToday => 'Dikutip hari ini';

  @override
  String get content => 'Panduan & promosi';

  @override
  String get copied => 'Disalin';

  @override
  String get copy => 'Salin';

  @override
  String get copyCsv => 'Salin sebagai CSV';

  @override
  String get dates => 'Tarikh';

  @override
  String get decline => 'Tolak';

  @override
  String get delete => 'Padam';

  @override
  String get department => 'Jabatan';

  @override
  String get departments => 'Jabatan';

  @override
  String get departures => 'Pelepasan';

  @override
  String get depositPercent => 'Deposit %';

  @override
  String get description => 'Penerangan';

  @override
  String get draft => 'Draf';

  @override
  String get earnPer100 => 'Mata setiap ₱100';

  @override
  String earnRate(String points) {
    return 'Anda memperoleh $points mata bagi setiap ₱100.';
  }

  @override
  String get earnsPoints => 'Memperoleh mata kesetiaan';

  @override
  String get email => 'E-mel';

  @override
  String get emptyResets => 'kosong = harga asas';

  @override
  String get enterCode => 'Masukkan kod';

  @override
  String get escalate => 'Naikkan ke penyelia';

  @override
  String get etaMin => 'Sedia dalam (minit)';

  @override
  String etaMinutes(String minutes) {
    return 'Sedia dalam kira-kira $minutes minit';
  }

  @override
  String get failedNotifications => 'Pemberitahuan gagal';

  @override
  String get failedRefunds => 'Bayaran balik gagal';

  @override
  String get fieldKey => 'Kunci medan';

  @override
  String get formFields => 'Medan borang tetamu';

  @override
  String get free => 'Kosong';

  @override
  String get freeCancelHours => 'Pembatalan percuma (jam sebelum daftar masuk)';

  @override
  String get frontDesk => 'Kaunter depan';

  @override
  String get history => 'Sejarah';

  @override
  String get hotelName => 'Nama hotel';

  @override
  String get hotelSettings => 'Tetapan hotel';

  @override
  String get inHouse => 'Sedang menginap';

  @override
  String get inactive => 'tidak aktif';

  @override
  String get internalNotes => 'Nota dalaman';

  @override
  String get kind => 'Jenis';

  @override
  String get label => 'Label';

  @override
  String get lateRefundPercent => 'Bayaran balik selepas tempoh percuma %';

  @override
  String get leadTimeMin => 'Tempah awal (minit)';

  @override
  String get leaveRequests => 'Permohonan cuti';

  @override
  String get loyalty => 'Mata kesetiaan';

  @override
  String get markNoShow => 'Tandakan tidak hadir';

  @override
  String get maxGuests => 'Maks. tetamu';

  @override
  String get members => 'Ahli';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Milik saya';

  @override
  String get missingToPublish => 'Belum lengkap untuk diterbitkan';

  @override
  String get myDepartment => 'Jabatan saya';

  @override
  String get myLeave => 'Cuti saya';

  @override
  String get myRequests => 'Permintaan saya';

  @override
  String get name => 'Nama';

  @override
  String get netToday => 'Bersih hari ini';

  @override
  String get network => 'Rangkaian';

  @override
  String get newQr => 'Kod QR baharu';

  @override
  String get newQrWarning => 'Kod lama meja ini tidak akan berfungsi lagi.';

  @override
  String nextTier(String points, String tier) {
    return '$points mata lagi ke $tier';
  }

  @override
  String get nothingHere => 'Belum ada apa-apa.';

  @override
  String get notFound => 'Tidak dijumpai.';

  @override
  String get occupancyTonight => 'Penghunian malam ini';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Tugas terbuka';

  @override
  String get opens => 'Buka';

  @override
  String get options => 'Pilihan';

  @override
  String get orderStatus => 'Pesanan anda';

  @override
  String get pause => 'Jeda';

  @override
  String get payAtOutlet => 'Bayar di kaunter / outlet';

  @override
  String get payOnline => 'Bayar dalam talian';

  @override
  String get paymentMethod => 'Pembayaran';

  @override
  String get payments => 'Pembayaran & bayaran balik';

  @override
  String get pendingApproval => 'Belum selesai';

  @override
  String get permissions => 'Kebenaran';

  @override
  String get photos => 'Foto';

  @override
  String get points => 'Mata';

  @override
  String pointsBalance(String points) {
    return '$points mata';
  }

  @override
  String pointsCost(String points) {
    return '$points mata';
  }

  @override
  String get pointsPlusMinus => 'Mata (+ tambah, − tolak)';

  @override
  String get preferredTime => 'Masa pilihan';

  @override
  String get price => 'Harga';

  @override
  String get priceDelta => 'Harga tambahan';

  @override
  String get priceModel => 'Model harga';

  @override
  String get priceOnQuote => 'Harga mengikut sebut harga';

  @override
  String pricePerItem(String price) {
    return '$price setiap item';
  }

  @override
  String pricePerNight2(String price) {
    return '$price semalam';
  }

  @override
  String pricePerPerson(String price) {
    return '$price seorang';
  }

  @override
  String get publish => 'Terbitkan';

  @override
  String get published => 'Diterbitkan';

  @override
  String get qrCode => 'Kod QR';

  @override
  String get rates => 'Kadar';

  @override
  String get reason => 'Sebab';

  @override
  String get redeem => 'Tebus';

  @override
  String get redeemNeedsStay =>
      'Mata boleh digunakan pada penginapan yang disahkan atau sedang berlangsung.';

  @override
  String get redeemed => 'Digunakan pada penginapan anda';

  @override
  String get refund => 'Bayaran balik';

  @override
  String get refunded => 'Dibayar balik';

  @override
  String get refundedToday => 'Dibayar balik hari ini';

  @override
  String get reissueWifi => 'Keluarkan semula Wi-Fi';

  @override
  String get rejected => 'Ditolak';

  @override
  String get removeAccess => 'Buang akses kakitangan';

  @override
  String get reportOccupancy => 'Penghunian';

  @override
  String get reportRevenue => 'Hasil';

  @override
  String get reports => 'Laporan';

  @override
  String get requestStatus => 'Status permintaan';

  @override
  String get requireApproval =>
      'Kakitangan meluluskan setiap tempahan berbayar';

  @override
  String get reservation => 'Tempahan';

  @override
  String get reservations => 'Tempahan';

  @override
  String get restaurant => 'Restoran';

  @override
  String get restaurantOrders => 'Pesanan restoran';

  @override
  String reviewOrder(String count, String total) {
    return 'Semak pesanan ($count) · $total';
  }

  @override
  String get rewards => 'Ganjaran';

  @override
  String get role => 'Peranan';

  @override
  String get roomLabel => 'Bilik';

  @override
  String get roomTypeLabel => 'Jenis bilik';

  @override
  String get roomsAndRates => 'Bilik & kadar';

  @override
  String get save => 'Simpan';

  @override
  String get saveDraft => 'Simpan draf';

  @override
  String get saved => 'Disimpan';

  @override
  String get scanTable => 'Pesan makanan (imbas QR meja)';

  @override
  String get scanTableHint => 'Halakan kamera ke kod QR di meja anda.';

  @override
  String get schedule => 'Jadual';

  @override
  String get searchGuest => 'Cari nama, e-mel, telefon atau kod';

  @override
  String get sendQuote => 'Hantar sebut harga';

  @override
  String get sendRequest => 'Hantar permintaan';

  @override
  String get serviceBuilder => 'Pembina perkhidmatan';

  @override
  String get services => 'Perkhidmatan';

  @override
  String get setRate => 'Tetapkan harga untuk tarikh';

  @override
  String get staff => 'Kakitangan';

  @override
  String get staffAndLeave => 'Kakitangan & cuti';

  @override
  String get staffApproval => 'Kakitangan menerima setiap permintaan';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Langkah status';

  @override
  String get submitOrder => 'Hantar pesanan';

  @override
  String tableLabel(String table) {
    return 'Meja $table';
  }

  @override
  String get tasks => 'Tugas';

  @override
  String get taxIncluded => 'Harga termasuk cukai';

  @override
  String get tempPassword => 'Kata laluan sementara';

  @override
  String tier(String tier) {
    return 'Tahap: $tier';
  }

  @override
  String get title => 'Tajuk';

  @override
  String get typeMessage => 'Taip mesej';

  @override
  String get unassigned => 'Belum ditugaskan';

  @override
  String get unblock => 'Nyahsekat';

  @override
  String get upcoming => 'Akan datang';

  @override
  String get username => 'Nama pengguna';

  @override
  String get validUntil => 'Sah sehingga';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Mod Wi-Fi (portal atau psk)';

  @override
  String get wifiPortalHint =>
      'Sambung ke rangkaian; halaman log masuk akan dibuka. Masukkan nama pengguna dan kata laluan di atas.';

  @override
  String get wifiQrHint => 'Imbas dengan kamera untuk menyambung.';

  @override
  String get wifiSharedPassword => 'Kata laluan Wi-Fi kongsi (mod psk)';

  @override
  String get action => 'Tindakan';

  @override
  String get entity => 'Objek';

  @override
  String get dateLabel => 'Tarikh';

  @override
  String get actor => 'Pelaku';

  @override
  String get navOverview => 'Gambaran keseluruhan';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navFinance => 'Kewangan';

  @override
  String get navPeople => 'Orang';

  @override
  String get navSystem => 'Sistem';

  @override
  String get details => 'Butiran';

  @override
  String get refresh => 'Muat semula';

  @override
  String get needsAttention => 'Perlu perhatian';

  @override
  String get allClear => 'Tiada apa yang perlu diurus';

  @override
  String get unreadChats => 'Sembang belum dibaca';

  @override
  String get myTasks => 'Tugas saya';

  @override
  String get search => 'Cari';

  @override
  String get showMore => 'Tunjuk lagi';

  @override
  String get viewLabel => 'Paparan';

  @override
  String get sortedAscending => 'Isih menaik';

  @override
  String get sortedDescending => 'Isih menurun';

  @override
  String sortBy(String column) {
    return 'Isih mengikut $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown daripada $total';
  }

  @override
  String get note => 'Nota';

  @override
  String get rooms => 'Bilik';

  @override
  String get tables => 'Meja';

  @override
  String get showDetails => 'Tunjuk butiran';

  @override
  String get hideDetails => 'Sembunyi butiran';

  @override
  String get selectThread => 'Pilih perbualan';

  @override
  String get keyboardShortcuts => 'Pintasan papan kekunci';

  @override
  String get goToPage => 'Pergi ke halaman';

  @override
  String get shortcutSearch => 'Cari di halaman ini';

  @override
  String get shortcutClose => 'Tutup panel atau dialog';

  @override
  String get shortcutHelp => 'Tunjuk pintasan papan kekunci';

  @override
  String get shortcutSend => 'Hantar mesej (Shift+Enter: baris baharu)';

  @override
  String get roomBoard => 'Bilik hari ini';

  @override
  String get roomOccupied => 'Berpenghuni';

  @override
  String get roomDeparting => 'Daftar keluar hari ini';

  @override
  String get roomArriving => 'Tiba hari ini';

  @override
  String get roomReserved => 'Ditempah';

  @override
  String get roomBlocked => 'Disekat';

  @override
  String freeOf(String free, String total) {
    return '$free daripada $total kosong';
  }

  @override
  String get todaysArrivals => 'Ketibaan hari ini';

  @override
  String get todaysDepartures => 'Pelepasan hari ini';

  @override
  String get guestList => 'Senarai tetamu';

  @override
  String get team => 'Pasukan';

  @override
  String get lastStay => 'Penginapan terakhir';

  @override
  String get roleAdmin => 'Pentadbir';

  @override
  String get notifications => 'Pemberitahuan';

  @override
  String get notifBooking => 'Tempahan baharu';

  @override
  String get notifPending => 'Tempahan perlu kelulusan';

  @override
  String get notifCancelled => 'Tempahan dibatalkan';

  @override
  String get notifRequest => 'Permintaan perkhidmatan baharu';

  @override
  String get notifOrder => 'Pesanan makanan baharu';

  @override
  String get notifMessage => 'Mesej baharu';

  @override
  String staffCancelConfirm(String refund) {
    return 'Batalkan tempahan ini? Mengikut polisi pembatalan, tetamu menerima $refund semula.';
  }

  @override
  String get phone => 'Telefon';

  @override
  String get appearance => 'Penampilan';

  @override
  String get themeSystem => 'Ikut peranti';

  @override
  String get themeLight => 'Cerah';

  @override
  String get themeDark => 'Gelap';

  @override
  String get roomAvailable => 'Kosong';

  @override
  String get availableOnly => 'Bilik kosong sahaja';

  @override
  String get floor => 'Tingkat';

  @override
  String get allRoomTypes => 'Semua jenis bilik';

  @override
  String get guestLabel => 'Tetamu';

  @override
  String get rowNo => 'No.';

  @override
  String get employeeId => 'ID pekerja';

  @override
  String get photo => 'Foto';

  @override
  String get dateFrom => 'Dari';

  @override
  String get dateTo => 'Hingga';

  @override
  String get leaveType => 'Jenis cuti';

  @override
  String get leaveVacation => 'Cuti rehat';

  @override
  String get leaveSick => 'Cuti sakit';

  @override
  String get leaveEmergency => 'Kecemasan';

  @override
  String get leaveOther => 'Lain-lain';

  @override
  String get submit => 'Hantar';

  @override
  String get cash => 'Tunai';

  @override
  String get card => 'Kad';

  @override
  String get arrival => 'Ketibaan';

  @override
  String get departure => 'Pelepasan';

  @override
  String get serviceRequests => 'Permintaan perkhidmatan';

  @override
  String get newRequest => 'Permintaan baharu';

  @override
  String get guestBooking => 'Tempahan tetamu';

  @override
  String bookRoom(String room) {
    return 'Tempah bilik $room';
  }

  @override
  String get bookAndCheckIn => 'Tempah dan daftar masuk';

  @override
  String get changeBooking => 'Tukar tempahan';

  @override
  String get recordPayment => 'Rekod pembayaran';

  @override
  String get emailOrPhoneRequired => 'Masukkan e-mel atau nombor telefon';

  @override
  String get emailLocked =>
      'E-mel log masuk tetamu tidak boleh ditukar di sini.';

  @override
  String get onLeaveToday => 'Sedang bercuti';

  @override
  String leaveUpcoming(String dates) {
    return 'Cuti $dates';
  }

  @override
  String get collapseMenu => 'Kecilkan menu';

  @override
  String get expandMenu => 'Kembangkan menu';

  @override
  String get roleRestaurant => 'Kakitangan restoran';

  @override
  String get next => 'Seterusnya';

  @override
  String get payAtDesk => 'Tetamu membayar di kaunter depan.';

  @override
  String get notAvailableForDates =>
      'Jenis bilik ini penuh pada tarikh tersebut. Cuba tarikh atau bilik lain.';

  @override
  String get byType => 'Mengikut jenis';

  @override
  String get byFloor => 'Mengikut tingkat';

  @override
  String floorN(String floor) {
    return 'Tingkat $floor';
  }

  @override
  String get paymentPaid => 'Dibayar penuh';

  @override
  String get paymentDeposit => 'Deposit dibayar';

  @override
  String get paymentPartial => 'Dibayar sebahagian';

  @override
  String get paymentUnpaid => 'Belum dibayar';

  @override
  String get moreLanguages => 'Bahasa lain';
}
