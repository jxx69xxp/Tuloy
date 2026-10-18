// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class AppLocalizationsFil extends AppLocalizations {
  AppLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Mag-sign in';

  @override
  String get signUp => 'Gumawa ng account';

  @override
  String get signOut => 'Mag-sign out';

  @override
  String get noAccount => 'Wala pang account?';

  @override
  String get haveAccount => 'May account na?';

  @override
  String get emailOrPhone => 'Email o numero ng telepono';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Hindi bababa sa 8 karakter';

  @override
  String get fullName => 'Buong pangalan';

  @override
  String get required => 'Kailangan';

  @override
  String get forgotPassword => 'Nakalimutan ang password?';

  @override
  String get sendCode => 'Ipadala ang code';

  @override
  String get codeSent => 'Kung may account, nagpadala kami ng 6-digit na code.';

  @override
  String get code => '6-digit na code';

  @override
  String get newPassword => 'Bagong password';

  @override
  String get resetPassword => 'I-reset ang password';

  @override
  String get passwordChanged => 'Napalitan na ang password. Mag-sign in.';

  @override
  String get settings => 'Mga Setting';

  @override
  String get language => 'Wika';

  @override
  String get guestHome => 'Maligayang pagdating';

  @override
  String get staffHome => 'Staff';

  @override
  String get adminHome => 'Admin';

  @override
  String get comingSoon =>
      'Darating ang iba pang feature sa susunod na release.';

  @override
  String get errorGeneric => 'Hindi maabot ang server. Suriin ang koneksyon.';

  @override
  String get cannotReachServer =>
      'Hindi maabot ang server. Suriin ang koneksyon, o hilingin sa administrator na payagan ang website na ito.';

  @override
  String hello(String name) {
    return 'Kumusta, $name';
  }

  @override
  String get retry => 'Subukan muli';

  @override
  String get howCanWeHelp => 'Paano kami makatutulong?';

  @override
  String get profile => 'Profile';

  @override
  String get stays => 'Pananatili';

  @override
  String get servicesUsed => 'Mga serbisyong nagamit';

  @override
  String get paymentHistory => 'Kasaysayan ng bayad';

  @override
  String get cardOrEwallet => 'Card / e-wallet';

  @override
  String get testPayment => 'Pagsubok na bayad';

  @override
  String get noneYet => 'Wala pa rito';

  @override
  String get gettingHere => 'Paano pumunta';

  @override
  String get openInMaps => 'Buksan sa Maps';

  @override
  String get airportRoute => 'Ruta papuntang airport';

  @override
  String get personalDetails => 'Personal na detalye';

  @override
  String get authTagline =>
      'Ang iyong pananatili at bawat serbisyo, isang tap lang';

  @override
  String get showPassword => 'Ipakita ang password';

  @override
  String get hidePassword => 'Itago ang password';

  @override
  String get findRoom => 'Maghanap ng kuwarto';

  @override
  String get adults => 'Matatanda';

  @override
  String get children => 'Bata';

  @override
  String get guests => 'Bisita';

  @override
  String nightsCount(String count) {
    return 'Gabi: $count';
  }

  @override
  String get noRooms =>
      'Walang bakanteng kuwarto sa mga petsang ito. Subukan ang ibang petsa.';

  @override
  String perNight(String price) {
    return '$price / gabi';
  }

  @override
  String roomsLeft(String count) {
    return '$count na lang ang natitira';
  }

  @override
  String get totalLabel => 'Kabuuan';

  @override
  String get amenities => 'Mga amenity';

  @override
  String get policies => 'Mga patakaran';

  @override
  String checkInTime(String time) {
    return 'Check-in simula $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out bago mag-$time';
  }

  @override
  String get specialRequests => 'Espesyal na kahilingan (opsyonal)';

  @override
  String get reserve => 'I-reserve';

  @override
  String get review => 'Suriin at magbayad';

  @override
  String holdTimer(String time) {
    return 'Nakareserba ang kuwarto sa loob ng $time';
  }

  @override
  String get holdExpired => 'Nag-expire na ang hold. Maghanap muli.';

  @override
  String get serviceCharge => 'Service charge';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'Magbayad ng deposito $amount';
  }

  @override
  String payFull(String amount) {
    return 'Bayaran nang buo $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Bayaran ang balanse $amount';
  }

  @override
  String get waitingPayment => 'Hinihintay ang bayad…';

  @override
  String get waitingPaymentHint =>
      'Tapusin ang pagbabayad sa browser. Kusang mag-a-update ang page na ito.';

  @override
  String get openPaymentAgain => 'Buksan muli ang payment page';

  @override
  String get bookingConfirmed => 'Kumpirmado ang booking!';

  @override
  String bookingCode(String code) {
    return 'Booking $code';
  }

  @override
  String roomNumber(String room) {
    return 'Kuwarto $room';
  }

  @override
  String get viewBooking => 'Tingnan ang booking';

  @override
  String get backHome => 'Bumalik sa home';

  @override
  String get paymentFailed =>
      'Hindi na nakareserba ang booking na ito. Kung nasingil ka, ibabalik ang bayad.';

  @override
  String get myBookings => 'Aking mga booking';

  @override
  String get noBookings => 'Wala pang booking.';

  @override
  String get statusHold => 'Hinihintay ang bayad';

  @override
  String get statusPending => 'Nakabinbin';

  @override
  String get statusConfirmed => 'Kumpirmado';

  @override
  String get statusCheckedIn => 'Naka-check-in';

  @override
  String get statusCheckedOut => 'Naka-check-out';

  @override
  String get statusCancelled => 'Kinansela';

  @override
  String get statusNoShow => 'Hindi dumating';

  @override
  String get statusDeclined => 'Tinanggihan';

  @override
  String get statusExpired => 'Expired';

  @override
  String get cancelBooking => 'Kanselahin ang booking';

  @override
  String cancelConfirm(String refund) {
    return 'Kanselahin ang booking? Maibabalik sa iyo ang $refund.';
  }

  @override
  String get keepBooking => 'Panatilihin';

  @override
  String get cancelled => 'Nakansela ang booking';

  @override
  String get invoice => 'Invoice';

  @override
  String get paid => 'Nabayaran';

  @override
  String get balance => 'Balanse';

  @override
  String get charges => 'Mga singil';

  @override
  String get myStay => 'Aking pananatili';

  @override
  String get currentStay => 'Ang iyong pananatili';

  @override
  String get hotelGuide => 'Gabay ng hotel';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateStay => 'Kumusta ang iyong pananatili?';

  @override
  String get comment => 'Komento (opsyonal)';

  @override
  String get send => 'Ipadala';

  @override
  String get thanksFeedback => 'Salamat sa iyong feedback!';

  @override
  String get accept => 'Tanggapin';

  @override
  String acceptQuote(String amount) {
    return 'Tanggapin ang quote $amount';
  }

  @override
  String get acceptance => 'Pagtanggap';

  @override
  String get active => 'Aktibo';

  @override
  String get add => 'Magdagdag';

  @override
  String get addField => 'Magdagdag ng field';

  @override
  String get addOption => 'Magdagdag ng opsyon';

  @override
  String get addOutlet => 'Magdagdag ng outlet';

  @override
  String get addPhoto => 'Magdagdag ng larawan';

  @override
  String get addRoom => 'Magdagdag ng kuwarto';

  @override
  String get addStaff => 'Magdagdag ng staff';

  @override
  String get addTable => 'Magdagdag ng mesa';

  @override
  String get adjustPoints => 'I-adjust ang points';

  @override
  String get alerts => 'Mga alerto';

  @override
  String get all => 'Lahat';

  @override
  String get allergens => 'Mga allergen';

  @override
  String get allergyNotes => 'Allergy o espesyal na tagubilin';

  @override
  String get amount => 'Halaga';

  @override
  String get applyLeave => 'Mag-apply ng leave';

  @override
  String get approve => 'Aprubahan';

  @override
  String get approved => 'Naaprubahan';

  @override
  String get arrivals => 'Darating';

  @override
  String get asSoonAsPossible => 'Sa lalong madaling panahon';

  @override
  String get auditLog => 'Audit log';

  @override
  String get autoAccept => 'Awtomatikong tanggapin';

  @override
  String get basePrice => 'Batayang presyo';

  @override
  String get blocks => 'Mga block ng kuwarto';

  @override
  String get body => 'Teksto';

  @override
  String get cancel => 'Kanselahin';

  @override
  String get cancelOrder => 'Kanselahin ang order';

  @override
  String get cancelRequest => 'Kanselahin ang request';

  @override
  String get cancellationPolicy => 'Patakaran sa pagkansela';

  @override
  String get category => 'Kategorya';

  @override
  String get chargeToRoom => 'I-charge sa aking kuwarto';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Magpadala ng mensahe sa front desk.';

  @override
  String get chatWithHotel => 'Makipag-chat sa hotel';

  @override
  String get checkInAction => 'I-check in';

  @override
  String get checkOutAction => 'I-check out';

  @override
  String get choices => 'Mga pagpipilian (hiwalay sa kuwit)';

  @override
  String get closes => 'Sarado ng';

  @override
  String get codeLabel => 'Code';

  @override
  String get collectedToday => 'Nakolekta ngayon';

  @override
  String get content => 'Gabay at promosyon';

  @override
  String get copied => 'Nakopya';

  @override
  String get copy => 'Kopyahin';

  @override
  String get copyCsv => 'Kopyahin bilang CSV';

  @override
  String get dates => 'Mga petsa';

  @override
  String get decline => 'Tanggihan';

  @override
  String get delete => 'Burahin';

  @override
  String get department => 'Departamento';

  @override
  String get departments => 'Mga departamento';

  @override
  String get departures => 'Aalis';

  @override
  String get depositPercent => 'Deposito %';

  @override
  String get description => 'Paglalarawan';

  @override
  String get draft => 'Draft';

  @override
  String get earnPer100 => 'Points kada ₱100';

  @override
  String earnRate(String points) {
    return 'Kumikita ka ng $points point(s) kada ₱100.';
  }

  @override
  String get earnsPoints => 'May loyalty points';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'walang laman = batayang presyo';

  @override
  String get enterCode => 'Ilagay ang code';

  @override
  String get escalate => 'I-escalate';

  @override
  String get etaMin => 'Handa sa loob ng (minuto)';

  @override
  String etaMinutes(String minutes) {
    return 'Handa sa loob ng mga $minutes minuto';
  }

  @override
  String get failedNotifications => 'Bigong notification';

  @override
  String get failedRefunds => 'Bigong refund';

  @override
  String get fieldKey => 'Field key';

  @override
  String get formFields => 'Mga field ng form';

  @override
  String get free => 'Libre';

  @override
  String get freeCancelHours => 'Libreng pagkansela (oras bago check-in)';

  @override
  String get frontDesk => 'Front desk';

  @override
  String get history => 'Kasaysayan';

  @override
  String get hotelName => 'Pangalan ng hotel';

  @override
  String get hotelSettings => 'Mga setting ng hotel';

  @override
  String get inHouse => 'Nasa hotel';

  @override
  String get inactive => 'hindi aktibo';

  @override
  String get internalNotes => 'Panloob na tala';

  @override
  String get kind => 'Uri';

  @override
  String get label => 'Label';

  @override
  String get lateRefundPercent => 'Refund pagkatapos ng libreng panahon %';

  @override
  String get leadTimeMin => 'Mag-order nang maaga (minuto)';

  @override
  String get leaveRequests => 'Mga kahilingan sa leave';

  @override
  String get loyalty => 'Loyalty points';

  @override
  String get markNoShow => 'Markahan na hindi dumating';

  @override
  String get maxGuests => 'Pinakamaraming bisita';

  @override
  String get members => 'Mga miyembro';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Akin';

  @override
  String get missingToPublish => 'Kulang bago i-publish';

  @override
  String get myDepartment => 'Aking departamento';

  @override
  String get myLeave => 'Aking leave';

  @override
  String get myRequests => 'Aking mga request';

  @override
  String get name => 'Pangalan';

  @override
  String get netToday => 'Net ngayon';

  @override
  String get network => 'Network';

  @override
  String get newQr => 'Bagong QR code';

  @override
  String get newQrWarning => 'Hindi na gagana ang lumang code ng mesang ito.';

  @override
  String nextTier(String points, String tier) {
    return '$points pang points para sa $tier';
  }

  @override
  String get nothingHere => 'Wala pa rito.';

  @override
  String get notFound => 'Hindi nahanap.';

  @override
  String get occupancyTonight => 'Okupado ngayong gabi';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Bukas na gawain';

  @override
  String get opens => 'Bukas mula';

  @override
  String get options => 'Mga opsyon';

  @override
  String get orderStatus => 'Ang iyong order';

  @override
  String get pause => 'I-pause';

  @override
  String get payAtOutlet => 'Magbayad sa mesa / outlet';

  @override
  String get payOnline => 'Magbayad online';

  @override
  String get paymentMethod => 'Pagbabayad';

  @override
  String get payments => 'Mga bayad at refund';

  @override
  String get pendingApproval => 'Nakabinbin';

  @override
  String get permissions => 'Mga pahintulot';

  @override
  String get photos => 'Mga larawan';

  @override
  String get points => 'Points';

  @override
  String pointsBalance(String points) {
    return '$points points';
  }

  @override
  String pointsCost(String points) {
    return '$points points';
  }

  @override
  String get pointsPlusMinus => 'Points (+ dagdag, − bawas)';

  @override
  String get preferredTime => 'Gustong oras';

  @override
  String get price => 'Presyo';

  @override
  String get priceDelta => 'Dagdag na presyo';

  @override
  String get priceModel => 'Uri ng presyo';

  @override
  String get priceOnQuote => 'Presyo kapag hiniling';

  @override
  String pricePerItem(String price) {
    return '$price bawat isa';
  }

  @override
  String pricePerNight2(String price) {
    return '$price kada gabi';
  }

  @override
  String pricePerPerson(String price) {
    return '$price kada tao';
  }

  @override
  String get publish => 'I-publish';

  @override
  String get published => 'Na-publish';

  @override
  String get qrCode => 'QR code';

  @override
  String get rates => 'Mga presyo';

  @override
  String get reason => 'Dahilan';

  @override
  String get redeem => 'Gamitin';

  @override
  String get redeemNeedsStay =>
      'Magagamit ang points sa kumpirmado o kasalukuyang pananatili.';

  @override
  String get redeemed => 'Nailapat sa iyong pananatili';

  @override
  String get refund => 'Refund';

  @override
  String get refunded => 'Na-refund';

  @override
  String get refundedToday => 'Na-refund ngayon';

  @override
  String get reissueWifi => 'Mag-isyu muli ng Wi-Fi';

  @override
  String get rejected => 'Tinanggihan';

  @override
  String get removeAccess => 'Alisin ang staff access';

  @override
  String get reportOccupancy => 'Okupasyon';

  @override
  String get reportRevenue => 'Kita';

  @override
  String get reports => 'Mga ulat';

  @override
  String get requestStatus => 'Status ng request';

  @override
  String get requireApproval =>
      'Inaaprubahan ng staff ang bawat bayad na booking';

  @override
  String get reservation => 'Reserbasyon';

  @override
  String get reservations => 'Mga reserbasyon';

  @override
  String get restaurant => 'Restawran';

  @override
  String get restaurantOrders => 'Mga order sa restawran';

  @override
  String reviewOrder(String count, String total) {
    return 'Suriin ang order ($count) · $total';
  }

  @override
  String get rewards => 'Mga gantimpala';

  @override
  String get role => 'Tungkulin';

  @override
  String get roomLabel => 'Kuwarto';

  @override
  String get roomTypeLabel => 'Uri ng kuwarto';

  @override
  String get roomsAndRates => 'Mga kuwarto at presyo';

  @override
  String get save => 'I-save';

  @override
  String get saveDraft => 'I-save ang draft';

  @override
  String get saved => 'Na-save';

  @override
  String get scanTable => 'Mag-order ng pagkain (i-scan ang QR)';

  @override
  String get scanTableHint => 'Itutok ang camera sa QR code sa iyong mesa.';

  @override
  String get schedule => 'Iskedyul';

  @override
  String get searchGuest => 'Hanapin ang pangalan, email, telepono o code';

  @override
  String get sendQuote => 'Ipadala ang quote';

  @override
  String get sendRequest => 'Ipadala ang request';

  @override
  String get serviceBuilder => 'Gumawa ng serbisyo';

  @override
  String get services => 'Mga serbisyo';

  @override
  String get setRate => 'Itakda ang presyo sa mga petsa';

  @override
  String get staff => 'Staff';

  @override
  String get staffAndLeave => 'Staff at leave';

  @override
  String get staffApproval => 'Tinatanggap ng staff ang bawat request';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Mga hakbang ng status';

  @override
  String get submitOrder => 'Ipadala ang order';

  @override
  String tableLabel(String table) {
    return 'Mesa $table';
  }

  @override
  String get tasks => 'Mga gawain';

  @override
  String get taxIncluded => 'Kasama na ang buwis';

  @override
  String get tempPassword => 'Pansamantalang password';

  @override
  String tier(String tier) {
    return 'Antas: $tier';
  }

  @override
  String get title => 'Pamagat';

  @override
  String get typeMessage => 'Mag-type ng mensahe';

  @override
  String get unassigned => 'Walang naka-assign';

  @override
  String get unblock => 'Alisin ang block';

  @override
  String get upcoming => 'Paparating';

  @override
  String get username => 'Username';

  @override
  String get validUntil => 'Valid hanggang';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi mode (portal o psk)';

  @override
  String get wifiPortalHint =>
      'Kumonekta sa network; magbubukas ang login page. Ilagay ang username at password sa itaas.';

  @override
  String get wifiQrHint => 'I-scan gamit ang camera para kumonekta.';

  @override
  String get wifiSharedPassword => 'Shared na Wi-Fi password (psk mode)';

  @override
  String get webGuestTitle => 'Mga bisita, gamitin po ang Tuloy mobile app';

  @override
  String get webGuestBody =>
      'Ang pag-book at mga feature ng pananatili ay available sa iOS at Android app. Dito maaaring mag-sign in ang mga staff at admin.';

  @override
  String get action => 'Aksyon';

  @override
  String get entity => 'Entidad';

  @override
  String get dateLabel => 'Petsa';

  @override
  String get actor => 'Gumawa';

  @override
  String get navOverview => 'Pangkalahatan';

  @override
  String get navCatalog => 'Katalogo';

  @override
  String get navFinance => 'Pananalapi';

  @override
  String get navPeople => 'Mga tao';

  @override
  String get navSystem => 'Sistema';

  @override
  String get details => 'Mga detalye';

  @override
  String get refresh => 'I-refresh';

  @override
  String get needsAttention => 'Kailangang asikasuhin';

  @override
  String get allClear => 'Walang kailangang asikasuhin';

  @override
  String get unreadChats => 'Hindi pa nababasang chat';

  @override
  String get myTasks => 'Mga gawain ko';

  @override
  String get search => 'Maghanap';

  @override
  String get showMore => 'Ipakita pa';

  @override
  String get viewLabel => 'Tingnan';

  @override
  String get sortedAscending => 'Nakaayos pataas';

  @override
  String get sortedDescending => 'Nakaayos pababa';

  @override
  String sortBy(String column) {
    return 'Ayusin ayon sa $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown sa $total';
  }

  @override
  String get note => 'Tala';

  @override
  String get rooms => 'Mga kuwarto';

  @override
  String get tables => 'Mga mesa';

  @override
  String get showDetails => 'Ipakita ang detalye';

  @override
  String get hideDetails => 'Itago ang detalye';

  @override
  String get selectThread => 'Pumili ng usapan';

  @override
  String get keyboardShortcuts => 'Mga keyboard shortcut';

  @override
  String get goToPage => 'Pumunta sa pahina';

  @override
  String get shortcutSearch => 'Maghanap sa pahinang ito';

  @override
  String get shortcutClose => 'Isara ang panel o dialog';

  @override
  String get shortcutHelp => 'Ipakita ang mga keyboard shortcut';

  @override
  String get shortcutSend => 'Ipadala ang mensahe (Shift+Enter: bagong linya)';

  @override
  String get roomBoard => 'Mga kuwarto ngayon';

  @override
  String get roomOccupied => 'May nakatira';

  @override
  String get roomDeparting => 'Magche-check out';

  @override
  String get roomArriving => 'Darating';

  @override
  String get roomReserved => 'Naka-reserve';

  @override
  String get roomBlocked => 'Naka-block';

  @override
  String freeOf(String free, String total) {
    return '$free sa $total bakante';
  }

  @override
  String get todaysArrivals => 'Darating ngayon';

  @override
  String get todaysDepartures => 'Aalis ngayon';

  @override
  String get guestList => 'Listahan ng bisita';

  @override
  String get team => 'Mga kasamahan';

  @override
  String get lastStay => 'Huling pananatili';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get notifications => 'Mga abiso';

  @override
  String get notifBooking => 'Bagong booking';

  @override
  String get notifPending => 'Booking na kailangang aprubahan';

  @override
  String get notifCancelled => 'Kinanselang booking';

  @override
  String get notifRequest => 'Bagong service request';

  @override
  String get notifOrder => 'Bagong order ng pagkain';

  @override
  String get notifMessage => 'Bagong mensahe';

  @override
  String staffCancelConfirm(String refund) {
    return 'Kanselahin ang booking na ito? Ibabalik sa bisita ang $refund, ayon sa patakaran sa pagkansela.';
  }

  @override
  String get phone => 'Telepono';

  @override
  String get appearance => 'Itsura';

  @override
  String get themeSystem => 'Sundan ang device';

  @override
  String get themeLight => 'Maliwanag';

  @override
  String get themeDark => 'Madilim';

  @override
  String get roomAvailable => 'Bakante';

  @override
  String get availableOnly => 'Bakante lang';

  @override
  String get floor => 'Palapag';

  @override
  String get allRoomTypes => 'Lahat ng uri ng kuwarto';

  @override
  String get guestLabel => 'Bisita';

  @override
  String get rowNo => 'Blg.';

  @override
  String get employeeId => 'Employee ID';

  @override
  String get photo => 'Larawan';

  @override
  String get dateFrom => 'Mula';

  @override
  String get dateTo => 'Hanggang';

  @override
  String get leaveType => 'Uri ng leave';

  @override
  String get leaveVacation => 'Bakasyon';

  @override
  String get leaveSick => 'May sakit';

  @override
  String get leaveEmergency => 'Emergency';

  @override
  String get leaveOther => 'Iba pa';

  @override
  String get submit => 'Ipasa';

  @override
  String get cash => 'Cash';

  @override
  String get card => 'Card';

  @override
  String get arrival => 'Pagdating';

  @override
  String get departure => 'Pag-alis';

  @override
  String get serviceRequests => 'Mga service request';

  @override
  String get newRequest => 'Bagong request';

  @override
  String get guestBooking => 'Booking ng bisita';

  @override
  String bookRoom(String room) {
    return 'I-book ang kuwarto $room';
  }

  @override
  String get bookAndCheckIn => 'I-book at i-check in';

  @override
  String get changeBooking => 'Baguhin ang booking';

  @override
  String get recordPayment => 'Itala ang bayad';

  @override
  String get emailOrPhoneRequired => 'Maglagay ng email o numero ng telepono';

  @override
  String get emailLocked =>
      'Hindi mababago dito ang email na pang-sign in ng bisita.';

  @override
  String get onLeaveToday => 'Naka-leave';

  @override
  String leaveUpcoming(String dates) {
    return 'Leave $dates';
  }

  @override
  String get collapseMenu => 'Itago ang menu';

  @override
  String get expandMenu => 'Ipakita ang menu';

  @override
  String get roleRestaurant => 'Restaurant staff';

  @override
  String get next => 'Susunod';
}
