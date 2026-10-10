// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Cebuano (`ceb`).
class AppLocalizationsCeb extends AppLocalizations {
  AppLocalizationsCeb([String locale = 'ceb']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get chooseLanguage => 'Pilia ang imong pinulongan';

  @override
  String get continueLabel => 'Padayon';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Paghimo og account';

  @override
  String get signOut => 'Sign out';

  @override
  String get noAccount => 'Wala pay account? Paghimo';

  @override
  String get emailOrPhone => 'Email o numero sa telepono';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Labing menos 8 ka karakter';

  @override
  String get fullName => 'Tibuok nga ngalan';

  @override
  String get required => 'Gikinahanglan';

  @override
  String get forgotPassword => 'Nakalimtan ang password?';

  @override
  String get sendCode => 'Ipadala ang code';

  @override
  String get codeSent => 'Kung naay account, nagpadala mi og 6-digit nga code.';

  @override
  String get code => '6-digit nga code';

  @override
  String get newPassword => 'Bag-ong password';

  @override
  String get resetPassword => 'I-reset ang password';

  @override
  String get passwordChanged => 'Nausab na ang password. Palihug sign in.';

  @override
  String get settings => 'Mga Setting';

  @override
  String get language => 'Pinulongan';

  @override
  String get guestHome => 'Maayong pag-abot';

  @override
  String get staffHome => 'Staff';

  @override
  String get adminHome => 'Admin';

  @override
  String get comingSoon => 'Moabot ang uban pang feature sa sunod nga release.';

  @override
  String get errorGeneric => 'Dili maabot ang server. Susiha ang koneksyon.';

  @override
  String get cannotReachServer =>
      'Dili maabot ang server. Susiha ang koneksyon, o pangayoa ang administrator nga tugotan kini nga website.';

  @override
  String hello(String name) {
    return 'Kumusta, $name';
  }

  @override
  String get retry => 'Sulayi pag-usab';

  @override
  String get howCanWeHelp => 'Unsaon namo pagtabang?';

  @override
  String get profile => 'Profile';

  @override
  String get stays => 'Pagpuyo';

  @override
  String get servicesUsed => 'Mga serbisyo nga nagamit';

  @override
  String get paymentHistory => 'Kasaysayan sa bayad';

  @override
  String get cardOrEwallet => 'Card / e-wallet';

  @override
  String get testPayment => 'Pagsulay nga bayad';

  @override
  String get noneYet => 'Wala pay sulod';

  @override
  String get gettingHere => 'Unsaon pag-adto';

  @override
  String get openInMaps => 'Ablihi sa Maps';

  @override
  String get airportRoute => 'Ruta paingon sa airport';

  @override
  String get personalDetails => 'Personal nga detalye';

  @override
  String get authTagline => 'Imong pagpuyo ug matag serbisyo, usa ka tap ra';

  @override
  String get showPassword => 'Ipakita ang password';

  @override
  String get hidePassword => 'Tagoa ang password';

  @override
  String get findRoom => 'Pangita og kwarto';

  @override
  String get adults => 'Hamtong';

  @override
  String get children => 'Bata';

  @override
  String get guests => 'Bisita';

  @override
  String nightsCount(String count) {
    return 'Gabii: $count';
  }

  @override
  String get noRooms =>
      'Walay bakante nga kwarto niining mga petsa. Sulayi ang lain nga petsa.';

  @override
  String perNight(String price) {
    return '$price / gabii';
  }

  @override
  String roomsLeft(String count) {
    return '$count na lang ang nabilin';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get amenities => 'Mga amenity';

  @override
  String get policies => 'Mga palisiya';

  @override
  String checkInTime(String time) {
    return 'Check-in sugod $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out sa dili pa $time';
  }

  @override
  String get specialRequests => 'Espesyal nga hangyo (opsyonal)';

  @override
  String get reserve => 'Pag-reserve';

  @override
  String get review => 'Susiha ug bayri';

  @override
  String holdTimer(String time) {
    return 'Gi-hold ang kwarto sulod sa $time';
  }

  @override
  String get holdExpired => 'Na-expire na ang hold. Pangita pag-usab.';

  @override
  String get serviceCharge => 'Service charge';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'Bayri ang deposito $amount';
  }

  @override
  String payFull(String amount) {
    return 'Bayri tanan $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Bayri ang balanse $amount';
  }

  @override
  String get waitingPayment => 'Naghulat sa bayad…';

  @override
  String get waitingPaymentHint =>
      'Humana ang pagbayad sa browser. Kusa ning mo-update kini nga page.';

  @override
  String get openPaymentAgain => 'Ablihi pag-usab ang payment page';

  @override
  String get bookingConfirmed => 'Kumpirmado ang booking!';

  @override
  String bookingCode(String code) {
    return 'Booking $code';
  }

  @override
  String roomNumber(String room) {
    return 'Kwarto $room';
  }

  @override
  String get viewBooking => 'Tan-awa ang booking';

  @override
  String get backHome => 'Balik sa home';

  @override
  String get paymentFailed =>
      'Dili na gi-hold kini nga booking. Kung nasingil ka, ibalik ang bayad.';

  @override
  String get myBookings => 'Akong mga booking';

  @override
  String get noBookings => 'Wala pay booking.';

  @override
  String get statusHold => 'Naghulat sa bayad';

  @override
  String get statusPending => 'Naghulat';

  @override
  String get statusConfirmed => 'Kumpirmado';

  @override
  String get statusCheckedIn => 'Naka-check-in';

  @override
  String get statusCheckedOut => 'Naka-check-out';

  @override
  String get statusCancelled => 'Gikansela';

  @override
  String get statusNoShow => 'Wala niabot';

  @override
  String get statusDeclined => 'Gibalibaran';

  @override
  String get statusExpired => 'Expired';

  @override
  String get cancelBooking => 'Kanselaha ang booking';

  @override
  String cancelConfirm(String refund) {
    return 'Kanselahon ang booking? Mabalik nimo ang $refund.';
  }

  @override
  String get keepBooking => 'Ipadayon';

  @override
  String get cancelled => 'Nakansela ang booking';

  @override
  String get invoice => 'Invoice';

  @override
  String get paid => 'Nabayran';

  @override
  String get balance => 'Balanse';

  @override
  String get charges => 'Mga singil';

  @override
  String get myStay => 'Akong pagpuyo';

  @override
  String get currentStay => 'Imong pagpuyo';

  @override
  String get hotelGuide => 'Giya sa hotel';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateStay => 'Kumusta imong pagpuyo?';

  @override
  String get comment => 'Komento (opsyonal)';

  @override
  String get send => 'Ipadala';

  @override
  String get thanksFeedback => 'Salamat sa imong feedback!';

  @override
  String get accept => 'Dawata';

  @override
  String acceptQuote(String amount) {
    return 'Dawata ang quote $amount';
  }

  @override
  String get acceptance => 'Pagdawat';

  @override
  String get active => 'Aktibo';

  @override
  String get add => 'Idugang';

  @override
  String get addField => 'Idugang ang field';

  @override
  String get addOption => 'Idugang ang opsyon';

  @override
  String get addOutlet => 'Idugang ang outlet';

  @override
  String get addPhoto => 'Idugang ang litrato';

  @override
  String get addRoom => 'Idugang ang kwarto';

  @override
  String get addStaff => 'Idugang ang staff';

  @override
  String get addTable => 'Idugang ang lamesa';

  @override
  String get adjustPoints => 'I-adjust ang points';

  @override
  String get alerts => 'Mga alerto';

  @override
  String get all => 'Tanan';

  @override
  String get allergens => 'Mga allergen';

  @override
  String get allergyNotes => 'Allergy o espesyal nga instruksyon';

  @override
  String get amount => 'Kantidad';

  @override
  String get applyLeave => 'Pag-apply og leave';

  @override
  String get approve => 'Aprobahi';

  @override
  String get approved => 'Naaprobahan';

  @override
  String get arrivals => 'Moabot';

  @override
  String get asSoonAsPossible => 'Sa labing dali nga panahon';

  @override
  String get auditLog => 'Audit log';

  @override
  String get autoAccept => 'Awtomatikong dawaton';

  @override
  String get basePrice => 'Base nga presyo';

  @override
  String get blocks => 'Mga block sa kwarto';

  @override
  String get body => 'Teksto';

  @override
  String get cancel => 'Kanselahon';

  @override
  String get cancelOrder => 'Kanselaha ang order';

  @override
  String get cancelRequest => 'Kanselaha ang request';

  @override
  String get cancellationPolicy => 'Palisiya sa pagkansela';

  @override
  String get category => 'Kategorya';

  @override
  String get chargeToRoom => 'I-charge sa akong kwarto';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Pagpadala og mensahe sa front desk.';

  @override
  String get chatWithHotel => 'Makig-chat sa hotel';

  @override
  String get checkInAction => 'I-check in';

  @override
  String get checkOutAction => 'I-check out';

  @override
  String get choices => 'Mga pilian (gibulag sa koma)';

  @override
  String get closes => 'Magsira';

  @override
  String get codeLabel => 'Code';

  @override
  String get collectedToday => 'Nakolekta karon';

  @override
  String get content => 'Giya ug promosyon';

  @override
  String get copied => 'Nakopya';

  @override
  String get copy => 'Kopyaha';

  @override
  String get copyCsv => 'Kopyaha isip CSV';

  @override
  String get dates => 'Mga petsa';

  @override
  String get decline => 'Balibari';

  @override
  String get delete => 'Papasa';

  @override
  String get department => 'Departamento';

  @override
  String get departments => 'Mga departamento';

  @override
  String get departures => 'Mobiya';

  @override
  String get depositPercent => 'Deposito %';

  @override
  String get description => 'Paghulagway';

  @override
  String get draft => 'Draft';

  @override
  String get earnPer100 => 'Points matag ₱100';

  @override
  String earnRate(String points) {
    return 'Makakuha ka og $points point(s) matag ₱100.';
  }

  @override
  String get earnsPoints => 'Adunay loyalty points';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'walay sulod = base nga presyo';

  @override
  String get enterCode => 'Isulod ang code';

  @override
  String get escalate => 'I-escalate';

  @override
  String get etaMin => 'Andam sulod sa (minuto)';

  @override
  String etaMinutes(String minutes) {
    return 'Andam sulod sa mga $minutes minutos';
  }

  @override
  String get failedNotifications => 'Napakyas nga notification';

  @override
  String get failedRefunds => 'Napakyas nga refund';

  @override
  String get fieldKey => 'Field key';

  @override
  String get formFields => 'Mga field sa form';

  @override
  String get free => 'Libre';

  @override
  String get freeCancelHours =>
      'Libre nga pagkansela (oras sa dili pa check-in)';

  @override
  String get frontDesk => 'Front desk';

  @override
  String get history => 'Kasaysayan';

  @override
  String get hotelName => 'Ngalan sa hotel';

  @override
  String get hotelSettings => 'Mga setting sa hotel';

  @override
  String get inHouse => 'Naa sa hotel';

  @override
  String get inactive => 'dili aktibo';

  @override
  String get internalNotes => 'Sulod nga nota';

  @override
  String get kind => 'Klase';

  @override
  String get label => 'Label';

  @override
  String get lateRefundPercent => 'Refund human sa libre nga panahon %';

  @override
  String get leadTimeMin => 'Pag-order daan (minuto)';

  @override
  String get leaveRequests => 'Mga hangyo sa leave';

  @override
  String get loyalty => 'Loyalty points';

  @override
  String get markNoShow => 'Markahi nga wala niabot';

  @override
  String get maxGuests => 'Pinakadaghan nga bisita';

  @override
  String get members => 'Mga miyembro';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Ako';

  @override
  String get missingToPublish => 'Kulang sa dili pa i-publish';

  @override
  String get myDepartment => 'Akong departamento';

  @override
  String get myLeave => 'Akong leave';

  @override
  String get myRequests => 'Akong mga request';

  @override
  String get name => 'Ngalan';

  @override
  String get netToday => 'Net karon';

  @override
  String get network => 'Network';

  @override
  String get newQr => 'Bag-ong QR code';

  @override
  String get newQrWarning => 'Dili na mogana ang daan nga code niining lamesa.';

  @override
  String nextTier(String points, String tier) {
    return '$points pa ka points para sa $tier';
  }

  @override
  String get nothingHere => 'Wala pay sulod.';

  @override
  String get notFound => 'Wala makit-i.';

  @override
  String get occupancyTonight => 'Okupado karong gabii';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Bukas nga buluhaton';

  @override
  String get opens => 'Moabli';

  @override
  String get options => 'Mga opsyon';

  @override
  String get orderStatus => 'Imong order';

  @override
  String get pause => 'I-pause';

  @override
  String get payAtOutlet => 'Bayad sa lamesa / outlet';

  @override
  String get payOnline => 'Bayad online';

  @override
  String get paymentMethod => 'Pagbayad';

  @override
  String get payments => 'Mga bayad ug refund';

  @override
  String get pendingApproval => 'Naghulat';

  @override
  String get permissions => 'Mga pagtugot';

  @override
  String get photos => 'Mga litrato';

  @override
  String get points => 'Points';

  @override
  String pointsBalance(String points) {
    return '$points ka points';
  }

  @override
  String pointsCost(String points) {
    return '$points ka points';
  }

  @override
  String get pointsPlusMinus => 'Points (+ dugang, − kuha)';

  @override
  String get preferredTime => 'Gusto nga oras';

  @override
  String get price => 'Presyo';

  @override
  String get priceDelta => 'Dugang nga presyo';

  @override
  String get priceModel => 'Klase sa presyo';

  @override
  String get priceOnQuote => 'Presyo kung hangyoon';

  @override
  String pricePerItem(String price) {
    return '$price matag usa';
  }

  @override
  String pricePerNight2(String price) {
    return '$price matag gabii';
  }

  @override
  String pricePerPerson(String price) {
    return '$price matag tawo';
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
  String get reason => 'Rason';

  @override
  String get redeem => 'Gamita';

  @override
  String get redeemNeedsStay =>
      'Magamit ang points sa kumpirmado o karon nga pagpuyo.';

  @override
  String get redeemed => 'Na-apply sa imong pagpuyo';

  @override
  String get refund => 'Refund';

  @override
  String get refunded => 'Na-refund';

  @override
  String get refundedToday => 'Na-refund karon';

  @override
  String get reissueWifi => 'I-isyu pag-usab ang Wi-Fi';

  @override
  String get rejected => 'Gibalibaran';

  @override
  String get removeAccess => 'Kuhaa ang staff access';

  @override
  String get reportOccupancy => 'Okupasyon';

  @override
  String get reportRevenue => 'Kita';

  @override
  String get reports => 'Mga taho';

  @override
  String get requestStatus => 'Status sa request';

  @override
  String get requireApproval =>
      'Aprobahan sa staff ang matag bayad nga booking';

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
    return 'Susiha ang order ($count) · $total';
  }

  @override
  String get rewards => 'Mga ganti';

  @override
  String get role => 'Papel';

  @override
  String get roomLabel => 'Kwarto';

  @override
  String get roomTypeLabel => 'Klase sa kwarto';

  @override
  String get roomsAndRates => 'Mga kwarto ug presyo';

  @override
  String get save => 'I-save';

  @override
  String get saveDraft => 'I-save ang draft';

  @override
  String get saved => 'Na-save';

  @override
  String get scanTable => 'Pag-order og pagkaon (i-scan ang QR)';

  @override
  String get scanTableHint => 'Itumong ang camera sa QR code sa imong lamesa.';

  @override
  String get schedule => 'Iskedyul';

  @override
  String get searchGuest => 'Pangitaa ang ngalan, email, telepono o code';

  @override
  String get sendQuote => 'Ipadala ang quote';

  @override
  String get sendRequest => 'Ipadala ang request';

  @override
  String get serviceBuilder => 'Paghimo og serbisyo';

  @override
  String get services => 'Mga serbisyo';

  @override
  String get setRate => 'Itakda ang presyo sa mga petsa';

  @override
  String get staff => 'Staff';

  @override
  String get staffAndLeave => 'Staff ug leave';

  @override
  String get staffApproval => 'Dawaton sa staff ang matag request';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Mga lakang sa status';

  @override
  String get submitOrder => 'Ipadala ang order';

  @override
  String tableLabel(String table) {
    return 'Lamesa $table';
  }

  @override
  String get tasks => 'Mga buluhaton';

  @override
  String get taxIncluded => 'Apil na ang buhis';

  @override
  String get tempPassword => 'Temporaryong password';

  @override
  String tier(String tier) {
    return 'Ang-ang: $tier';
  }

  @override
  String get title => 'Titulo';

  @override
  String get typeMessage => 'Pag-type og mensahe';

  @override
  String get unassigned => 'Walay naka-assign';

  @override
  String get unblock => 'Kuhaa ang block';

  @override
  String get upcoming => 'Moabot pa';

  @override
  String get username => 'Username';

  @override
  String get validUntil => 'Valid hangtod';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi mode (portal o psk)';

  @override
  String get wifiPortalHint =>
      'Konektar sa network; moabli ang login page. Isulod ang username ug password sa ibabaw.';

  @override
  String get wifiQrHint => 'I-scan gamit ang camera aron makakonektar.';

  @override
  String get wifiSharedPassword => 'Shared nga Wi-Fi password (psk mode)';

  @override
  String get webGuestTitle => 'Mga bisita, palihog gamita ang Tuloy mobile app';

  @override
  String get webGuestBody =>
      'Ang pag-book ug mga feature sa pagpuyo anaa sa iOS ug Android app. Dinhi makasulod ang mga staff ug admin.';

  @override
  String get action => 'Aksyon';

  @override
  String get entity => 'Entidad';

  @override
  String get dateLabel => 'Petsa';

  @override
  String get actor => 'Nagbuhat';
}
