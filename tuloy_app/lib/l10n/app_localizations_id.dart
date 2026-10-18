// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Buat akun';

  @override
  String get signOut => 'Keluar';

  @override
  String get noAccount => 'Belum punya akun?';

  @override
  String get haveAccount => 'Sudah punya akun?';

  @override
  String get emailOrPhone => 'Email atau nomor telepon';

  @override
  String get password => 'Kata sandi';

  @override
  String get passwordHint => 'Minimal 8 karakter';

  @override
  String get fullName => 'Nama lengkap';

  @override
  String get required => 'Wajib diisi';

  @override
  String get forgotPassword => 'Lupa kata sandi?';

  @override
  String get sendCode => 'Kirim kode';

  @override
  String get codeSent => 'Jika akun ada, kami telah mengirim kode 6 digit.';

  @override
  String get code => 'Kode 6 digit';

  @override
  String get newPassword => 'Kata sandi baru';

  @override
  String get resetPassword => 'Atur ulang kata sandi';

  @override
  String get passwordChanged => 'Kata sandi diubah. Silakan masuk.';

  @override
  String get settings => 'Pengaturan';

  @override
  String get language => 'Bahasa';

  @override
  String get guestHome => 'Selamat datang';

  @override
  String get staffHome => 'Staf';

  @override
  String get adminHome => 'Admin';

  @override
  String get comingSoon => 'Fitur lain hadir di rilis berikutnya.';

  @override
  String get errorGeneric =>
      'Tidak dapat terhubung ke server. Periksa koneksi Anda.';

  @override
  String get cannotReachServer =>
      'Tidak dapat terhubung ke server. Periksa koneksi Anda, atau minta admin mengizinkan situs ini.';

  @override
  String hello(String name) {
    return 'Halo, $name';
  }

  @override
  String get retry => 'Coba lagi';

  @override
  String get howCanWeHelp => 'Ada yang bisa kami bantu?';

  @override
  String get profile => 'Profil';

  @override
  String get stays => 'Menginap';

  @override
  String get servicesUsed => 'Layanan yang dipakai';

  @override
  String get paymentHistory => 'Riwayat pembayaran';

  @override
  String get cardOrEwallet => 'Kartu / dompet digital';

  @override
  String get testPayment => 'Pembayaran uji';

  @override
  String get noneYet => 'Belum ada';

  @override
  String get gettingHere => 'Cara ke sini';

  @override
  String get openInMaps => 'Buka di Peta';

  @override
  String get airportRoute => 'Rute ke bandara';

  @override
  String get personalDetails => 'Data pribadi';

  @override
  String get authTagline => 'Menginap dan semua layanan, cukup sekali ketuk';

  @override
  String get showPassword => 'Tampilkan kata sandi';

  @override
  String get hidePassword => 'Sembunyikan kata sandi';

  @override
  String get findRoom => 'Cari kamar';

  @override
  String get adults => 'Dewasa';

  @override
  String get children => 'Anak';

  @override
  String get guests => 'Tamu';

  @override
  String nightsCount(String count) {
    return 'Malam: $count';
  }

  @override
  String get noRooms =>
      'Tidak ada kamar tersedia pada tanggal ini. Coba tanggal lain.';

  @override
  String perNight(String price) {
    return '$price / malam';
  }

  @override
  String roomsLeft(String count) {
    return 'Tinggal $count';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get amenities => 'Fasilitas';

  @override
  String get policies => 'Kebijakan';

  @override
  String checkInTime(String time) {
    return 'Check-in mulai $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out paling lambat $time';
  }

  @override
  String get specialRequests => 'Permintaan khusus (opsional)';

  @override
  String get reserve => 'Pesan';

  @override
  String get review => 'Tinjau dan bayar';

  @override
  String holdTimer(String time) {
    return 'Kamar ini kami tahan untuk Anda selama $time';
  }

  @override
  String get holdExpired => 'Waktu penahanan habis. Silakan cari lagi.';

  @override
  String get serviceCharge => 'Biaya layanan';

  @override
  String get vat => 'PPN';

  @override
  String payDeposit(String amount) {
    return 'Bayar uang muka $amount';
  }

  @override
  String payFull(String amount) {
    return 'Bayar lunas $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Bayar sisa $amount';
  }

  @override
  String get waitingPayment => 'Menunggu pembayaran…';

  @override
  String get waitingPaymentHint =>
      'Selesaikan pembayaran di browser. Halaman ini diperbarui otomatis.';

  @override
  String get openPaymentAgain => 'Buka halaman pembayaran lagi';

  @override
  String get bookingConfirmed => 'Pemesanan dikonfirmasi!';

  @override
  String bookingCode(String code) {
    return 'Pemesanan $code';
  }

  @override
  String roomNumber(String room) {
    return 'Kamar $room';
  }

  @override
  String get viewBooking => 'Lihat pemesanan';

  @override
  String get backHome => 'Kembali ke beranda';

  @override
  String get paymentFailed =>
      'Pemesanan ini tidak lagi ditahan. Jika Anda sudah ditagih, dana akan dikembalikan.';

  @override
  String get myBookings => 'Pemesanan saya';

  @override
  String get noBookings => 'Belum ada pemesanan.';

  @override
  String get statusHold => 'Menunggu pembayaran';

  @override
  String get statusPending => 'Tertunda';

  @override
  String get statusConfirmed => 'Dikonfirmasi';

  @override
  String get statusCheckedIn => 'Sudah check-in';

  @override
  String get statusCheckedOut => 'Sudah check-out';

  @override
  String get statusCancelled => 'Dibatalkan';

  @override
  String get statusNoShow => 'Tidak datang';

  @override
  String get statusDeclined => 'Ditolak';

  @override
  String get statusExpired => 'Kedaluwarsa';

  @override
  String get cancelBooking => 'Batalkan pemesanan';

  @override
  String cancelConfirm(String refund) {
    return 'Batalkan pemesanan ini? Anda akan menerima $refund kembali.';
  }

  @override
  String get keepBooking => 'Pertahankan pemesanan';

  @override
  String get cancelled => 'Pemesanan dibatalkan';

  @override
  String get invoice => 'Tagihan';

  @override
  String get paid => 'Dibayar';

  @override
  String get balance => 'Sisa';

  @override
  String get charges => 'Biaya';

  @override
  String get myStay => 'Menginap saya';

  @override
  String get currentStay => 'Menginap Anda';

  @override
  String get hotelGuide => 'Panduan hotel';

  @override
  String get feedback => 'Ulasan';

  @override
  String get rateStay => 'Bagaimana menginap Anda?';

  @override
  String get comment => 'Komentar (opsional)';

  @override
  String get send => 'Kirim';

  @override
  String get thanksFeedback => 'Terima kasih atas ulasan Anda!';

  @override
  String get accept => 'Terima';

  @override
  String acceptQuote(String amount) {
    return 'Terima penawaran $amount';
  }

  @override
  String get acceptance => 'Penerimaan';

  @override
  String get active => 'Aktif';

  @override
  String get add => 'Tambah';

  @override
  String get addField => 'Tambah kolom';

  @override
  String get addOption => 'Tambah opsi';

  @override
  String get addOutlet => 'Tambah outlet';

  @override
  String get addPhoto => 'Tambah foto';

  @override
  String get addRoom => 'Tambah kamar';

  @override
  String get addStaff => 'Tambah staf';

  @override
  String get addTable => 'Tambah meja';

  @override
  String get adjustPoints => 'Ubah poin';

  @override
  String get alerts => 'Peringatan';

  @override
  String get all => 'Semua';

  @override
  String get allergens => 'Alergen';

  @override
  String get allergyNotes => 'Alergi atau instruksi khusus';

  @override
  String get amount => 'Jumlah';

  @override
  String get applyLeave => 'Ajukan cuti';

  @override
  String get approve => 'Setujui';

  @override
  String get approved => 'Disetujui';

  @override
  String get arrivals => 'Kedatangan';

  @override
  String get asSoonAsPossible => 'Secepatnya';

  @override
  String get auditLog => 'Log audit';

  @override
  String get autoAccept => 'Terima otomatis';

  @override
  String get basePrice => 'Harga dasar';

  @override
  String get blocks => 'Blokir kamar';

  @override
  String get body => 'Teks';

  @override
  String get cancel => 'Batal';

  @override
  String get cancelOrder => 'Batalkan pesanan';

  @override
  String get cancelRequest => 'Batalkan permintaan';

  @override
  String get cancellationPolicy => 'Kebijakan pembatalan';

  @override
  String get category => 'Kategori';

  @override
  String get chargeToRoom => 'Tagihkan ke kamar saya';

  @override
  String get chat => 'Obrolan';

  @override
  String get chatEmpty => 'Kirim pesan ke resepsionis.';

  @override
  String get chatWithHotel => 'Obrolan dengan hotel';

  @override
  String get checkInAction => 'Check-in';

  @override
  String get checkOutAction => 'Check-out';

  @override
  String get choices => 'Pilihan (pisahkan dengan koma)';

  @override
  String get closes => 'Tutup';

  @override
  String get codeLabel => 'Kode';

  @override
  String get collectedToday => 'Diterima hari ini';

  @override
  String get content => 'Panduan & promo';

  @override
  String get copied => 'Disalin';

  @override
  String get copy => 'Salin';

  @override
  String get copyCsv => 'Salin sebagai CSV';

  @override
  String get dates => 'Tanggal';

  @override
  String get decline => 'Tolak';

  @override
  String get delete => 'Hapus';

  @override
  String get department => 'Departemen';

  @override
  String get departments => 'Departemen';

  @override
  String get departures => 'Keberangkatan';

  @override
  String get depositPercent => 'Uang muka %';

  @override
  String get description => 'Deskripsi';

  @override
  String get draft => 'Draf';

  @override
  String get earnPer100 => 'Poin per ₱100';

  @override
  String earnRate(String points) {
    return 'Anda mendapat $points poin untuk setiap ₱100.';
  }

  @override
  String get earnsPoints => 'Mendapat poin loyalitas';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'kosong = harga dasar';

  @override
  String get enterCode => 'Masukkan kode';

  @override
  String get escalate => 'Eskalasi';

  @override
  String get etaMin => 'Siap dalam (menit)';

  @override
  String etaMinutes(String minutes) {
    return 'Siap dalam sekitar $minutes menit';
  }

  @override
  String get failedNotifications => 'Notifikasi gagal';

  @override
  String get failedRefunds => 'Pengembalian dana gagal';

  @override
  String get fieldKey => 'Kunci kolom';

  @override
  String get formFields => 'Kolom formulir tamu';

  @override
  String get free => 'Kosong';

  @override
  String get freeCancelHours => 'Pembatalan gratis (jam sebelum check-in)';

  @override
  String get frontDesk => 'Resepsionis';

  @override
  String get history => 'Riwayat';

  @override
  String get hotelName => 'Nama hotel';

  @override
  String get hotelSettings => 'Pengaturan hotel';

  @override
  String get inHouse => 'Sedang menginap';

  @override
  String get inactive => 'nonaktif';

  @override
  String get internalNotes => 'Catatan internal';

  @override
  String get kind => 'Jenis';

  @override
  String get label => 'Label';

  @override
  String get lateRefundPercent => 'Pengembalian setelah masa gratis %';

  @override
  String get leadTimeMin => 'Pesan di muka (menit)';

  @override
  String get leaveRequests => 'Pengajuan cuti';

  @override
  String get loyalty => 'Poin loyalitas';

  @override
  String get markNoShow => 'Tandai tidak datang';

  @override
  String get maxGuests => 'Maks. tamu';

  @override
  String get members => 'Anggota';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Milik saya';

  @override
  String get missingToPublish => 'Belum lengkap untuk diterbitkan';

  @override
  String get myDepartment => 'Departemen saya';

  @override
  String get myLeave => 'Cuti saya';

  @override
  String get myRequests => 'Permintaan saya';

  @override
  String get name => 'Nama';

  @override
  String get netToday => 'Bersih hari ini';

  @override
  String get network => 'Jaringan';

  @override
  String get newQr => 'Kode QR baru';

  @override
  String get newQrWarning => 'Kode lama meja ini tidak akan berfungsi lagi.';

  @override
  String nextTier(String points, String tier) {
    return '$points poin lagi untuk $tier';
  }

  @override
  String get nothingHere => 'Belum ada.';

  @override
  String get notFound => 'Tidak ditemukan.';

  @override
  String get occupancyTonight => 'Okupansi malam ini';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Tugas terbuka';

  @override
  String get opens => 'Buka';

  @override
  String get options => 'Opsi';

  @override
  String get orderStatus => 'Pesanan Anda';

  @override
  String get pause => 'Jeda';

  @override
  String get payAtOutlet => 'Bayar di meja / outlet';

  @override
  String get payOnline => 'Bayar online';

  @override
  String get paymentMethod => 'Pembayaran';

  @override
  String get payments => 'Pembayaran & pengembalian dana';

  @override
  String get pendingApproval => 'Tertunda';

  @override
  String get permissions => 'Izin';

  @override
  String get photos => 'Foto';

  @override
  String get points => 'Poin';

  @override
  String pointsBalance(String points) {
    return '$points poin';
  }

  @override
  String pointsCost(String points) {
    return '$points poin';
  }

  @override
  String get pointsPlusMinus => 'Poin (+ tambah, − kurangi)';

  @override
  String get preferredTime => 'Waktu pilihan';

  @override
  String get price => 'Harga';

  @override
  String get priceDelta => 'Harga tambahan';

  @override
  String get priceModel => 'Model harga';

  @override
  String get priceOnQuote => 'Harga sesuai permintaan';

  @override
  String pricePerItem(String price) {
    return '$price per item';
  }

  @override
  String pricePerNight2(String price) {
    return '$price per malam';
  }

  @override
  String pricePerPerson(String price) {
    return '$price per orang';
  }

  @override
  String get publish => 'Terbitkan';

  @override
  String get published => 'Diterbitkan';

  @override
  String get qrCode => 'Kode QR';

  @override
  String get rates => 'Tarif';

  @override
  String get reason => 'Alasan';

  @override
  String get redeem => 'Tukar';

  @override
  String get redeemNeedsStay =>
      'Poin dapat dipakai pada menginap yang dikonfirmasi atau sedang berlangsung.';

  @override
  String get redeemed => 'Diterapkan pada menginap Anda';

  @override
  String get refund => 'Pengembalian dana';

  @override
  String get refunded => 'Dikembalikan';

  @override
  String get refundedToday => 'Dikembalikan hari ini';

  @override
  String get reissueWifi => 'Terbitkan ulang Wi-Fi';

  @override
  String get rejected => 'Ditolak';

  @override
  String get removeAccess => 'Hapus akses staf';

  @override
  String get reportOccupancy => 'Okupansi';

  @override
  String get reportRevenue => 'Pendapatan';

  @override
  String get reports => 'Laporan';

  @override
  String get requestStatus => 'Status permintaan';

  @override
  String get requireApproval => 'Staf menyetujui setiap pemesanan yang dibayar';

  @override
  String get reservation => 'Reservasi';

  @override
  String get reservations => 'Reservasi';

  @override
  String get restaurant => 'Restoran';

  @override
  String get restaurantOrders => 'Pesanan restoran';

  @override
  String reviewOrder(String count, String total) {
    return 'Tinjau pesanan ($count) · $total';
  }

  @override
  String get rewards => 'Hadiah';

  @override
  String get role => 'Peran';

  @override
  String get roomLabel => 'Kamar';

  @override
  String get roomTypeLabel => 'Tipe kamar';

  @override
  String get roomsAndRates => 'Kamar & tarif';

  @override
  String get save => 'Simpan';

  @override
  String get saveDraft => 'Simpan draf';

  @override
  String get saved => 'Tersimpan';

  @override
  String get scanTable => 'Pesan makanan (pindai QR meja)';

  @override
  String get scanTableHint => 'Arahkan kamera ke kode QR di meja Anda.';

  @override
  String get schedule => 'Jadwal';

  @override
  String get searchGuest => 'Cari nama, email, telepon, atau kode';

  @override
  String get sendQuote => 'Kirim penawaran';

  @override
  String get sendRequest => 'Kirim permintaan';

  @override
  String get serviceBuilder => 'Penyusun layanan';

  @override
  String get services => 'Layanan';

  @override
  String get setRate => 'Atur harga untuk tanggal';

  @override
  String get staff => 'Staf';

  @override
  String get staffAndLeave => 'Staf & cuti';

  @override
  String get staffApproval => 'Staf menerima setiap permintaan';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Tahap status';

  @override
  String get submitOrder => 'Kirim pesanan';

  @override
  String tableLabel(String table) {
    return 'Meja $table';
  }

  @override
  String get tasks => 'Tugas';

  @override
  String get taxIncluded => 'Harga termasuk pajak';

  @override
  String get tempPassword => 'Kata sandi sementara';

  @override
  String tier(String tier) {
    return 'Tingkat: $tier';
  }

  @override
  String get title => 'Judul';

  @override
  String get typeMessage => 'Ketik pesan';

  @override
  String get unassigned => 'Belum ditugaskan';

  @override
  String get unblock => 'Buka blokir';

  @override
  String get upcoming => 'Akan datang';

  @override
  String get username => 'Nama pengguna';

  @override
  String get validUntil => 'Berlaku sampai';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Mode Wi-Fi (portal atau psk)';

  @override
  String get wifiPortalHint =>
      'Sambungkan ke jaringan; halaman login akan terbuka. Masukkan nama pengguna dan kata sandi di atas.';

  @override
  String get wifiQrHint => 'Pindai dengan kamera untuk tersambung.';

  @override
  String get wifiSharedPassword => 'Kata sandi Wi-Fi bersama (mode psk)';

  @override
  String get action => 'Tindakan';

  @override
  String get entity => 'Objek';

  @override
  String get dateLabel => 'Tanggal';

  @override
  String get actor => 'Pelaku';

  @override
  String get navOverview => 'Ringkasan';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navFinance => 'Keuangan';

  @override
  String get navPeople => 'Orang';

  @override
  String get navSystem => 'Sistem';

  @override
  String get details => 'Detail';

  @override
  String get refresh => 'Muat ulang';

  @override
  String get needsAttention => 'Perlu ditangani';

  @override
  String get allClear => 'Tidak ada yang perlu ditangani';

  @override
  String get unreadChats => 'Obrolan belum dibaca';

  @override
  String get myTasks => 'Tugas saya';

  @override
  String get search => 'Cari';

  @override
  String get showMore => 'Tampilkan lagi';

  @override
  String get viewLabel => 'Tampilan';

  @override
  String get sortedAscending => 'Urutan naik';

  @override
  String get sortedDescending => 'Urutan turun';

  @override
  String sortBy(String column) {
    return 'Urutkan menurut $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown dari $total';
  }

  @override
  String get note => 'Catatan';

  @override
  String get rooms => 'Kamar';

  @override
  String get tables => 'Meja';

  @override
  String get showDetails => 'Tampilkan detail';

  @override
  String get hideDetails => 'Sembunyikan detail';

  @override
  String get selectThread => 'Pilih percakapan';

  @override
  String get keyboardShortcuts => 'Pintasan keyboard';

  @override
  String get goToPage => 'Buka halaman';

  @override
  String get shortcutSearch => 'Cari di halaman ini';

  @override
  String get shortcutClose => 'Tutup panel atau dialog';

  @override
  String get shortcutHelp => 'Tampilkan pintasan keyboard';

  @override
  String get shortcutSend => 'Kirim pesan (Shift+Enter: baris baru)';

  @override
  String get roomBoard => 'Kamar hari ini';

  @override
  String get roomOccupied => 'Terisi';

  @override
  String get roomDeparting => 'Check-out hari ini';

  @override
  String get roomArriving => 'Datang hari ini';

  @override
  String get roomReserved => 'Dipesan';

  @override
  String get roomBlocked => 'Diblokir';

  @override
  String freeOf(String free, String total) {
    return '$free dari $total tersedia';
  }

  @override
  String get todaysArrivals => 'Kedatangan hari ini';

  @override
  String get todaysDepartures => 'Keberangkatan hari ini';

  @override
  String get guestList => 'Daftar tamu';

  @override
  String get team => 'Tim';

  @override
  String get lastStay => 'Menginap terakhir';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get notifications => 'Notifikasi';

  @override
  String get notifBooking => 'Pemesanan baru';

  @override
  String get notifPending => 'Pemesanan perlu disetujui';

  @override
  String get notifCancelled => 'Pemesanan dibatalkan';

  @override
  String get notifRequest => 'Permintaan layanan baru';

  @override
  String get notifOrder => 'Pesanan makanan baru';

  @override
  String get notifMessage => 'Pesan baru';

  @override
  String staffCancelConfirm(String refund) {
    return 'Batalkan pemesanan ini? Sesuai kebijakan pembatalan, tamu menerima $refund kembali.';
  }

  @override
  String get phone => 'Telepon';

  @override
  String get appearance => 'Tampilan';

  @override
  String get themeSystem => 'Ikuti perangkat';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get roomAvailable => 'Tersedia';

  @override
  String get availableOnly => 'Hanya yang tersedia';

  @override
  String get floor => 'Lantai';

  @override
  String get allRoomTypes => 'Semua tipe kamar';

  @override
  String get guestLabel => 'Tamu';

  @override
  String get rowNo => 'No.';

  @override
  String get employeeId => 'ID karyawan';

  @override
  String get photo => 'Foto';

  @override
  String get dateFrom => 'Dari';

  @override
  String get dateTo => 'Sampai';

  @override
  String get leaveType => 'Jenis cuti';

  @override
  String get leaveVacation => 'Liburan';

  @override
  String get leaveSick => 'Sakit';

  @override
  String get leaveEmergency => 'Darurat';

  @override
  String get leaveOther => 'Lainnya';

  @override
  String get submit => 'Kirim';

  @override
  String get cash => 'Tunai';

  @override
  String get card => 'Kartu';

  @override
  String get arrival => 'Kedatangan';

  @override
  String get departure => 'Keberangkatan';

  @override
  String get serviceRequests => 'Permintaan layanan';

  @override
  String get newRequest => 'Permintaan baru';

  @override
  String get guestBooking => 'Pemesanan tamu';

  @override
  String bookRoom(String room) {
    return 'Pesan kamar $room';
  }

  @override
  String get bookAndCheckIn => 'Pesan dan check-in';

  @override
  String get changeBooking => 'Ubah pemesanan';

  @override
  String get recordPayment => 'Catat pembayaran';

  @override
  String get emailOrPhoneRequired => 'Masukkan email atau nomor telepon';

  @override
  String get emailLocked => 'Email login tamu tidak dapat diubah di sini.';

  @override
  String get onLeaveToday => 'Sedang cuti';

  @override
  String leaveUpcoming(String dates) {
    return 'Cuti $dates';
  }

  @override
  String get collapseMenu => 'Ciutkan menu';

  @override
  String get expandMenu => 'Lebarkan menu';

  @override
  String get roleRestaurant => 'Staf restoran';

  @override
  String get next => 'Berikutnya';

  @override
  String get payAtDesk => 'Tamu membayar di resepsionis.';

  @override
  String get notAvailableForDates =>
      'Tipe kamar ini penuh pada tanggal tersebut. Coba tanggal lain atau kamar lain.';

  @override
  String get byType => 'Menurut tipe';

  @override
  String get byFloor => 'Menurut lantai';

  @override
  String floorN(String floor) {
    return 'Lantai $floor';
  }

  @override
  String get paymentPaid => 'Lunas';

  @override
  String get paymentDeposit => 'Uang muka dibayar';

  @override
  String get paymentPartial => 'Dibayar sebagian';

  @override
  String get paymentUnpaid => 'Belum dibayar';

  @override
  String get moreLanguages => 'Bahasa lain';
}
