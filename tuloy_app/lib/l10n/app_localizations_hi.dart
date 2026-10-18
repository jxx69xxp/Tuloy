// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'साइन इन करें';

  @override
  String get signUp => 'खाता बनाएं';

  @override
  String get signOut => 'साइन आउट करें';

  @override
  String get noAccount => 'खाता नहीं है?';

  @override
  String get haveAccount => 'पहले से खाता है?';

  @override
  String get emailOrPhone => 'ईमेल या फ़ोन नंबर';

  @override
  String get password => 'पासवर्ड';

  @override
  String get passwordHint => 'कम से कम 8 अक्षर';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get required => 'ज़रूरी';

  @override
  String get forgotPassword => 'पासवर्ड भूल गए?';

  @override
  String get sendCode => 'कोड भेजें';

  @override
  String get codeSent => 'अगर खाता मौजूद है, तो हमने 6 अंकों का कोड भेजा है।';

  @override
  String get code => '6 अंकों का कोड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get resetPassword => 'पासवर्ड रीसेट करें';

  @override
  String get passwordChanged => 'पासवर्ड बदल गया। कृपया साइन इन करें।';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get language => 'भाषा';

  @override
  String get guestHome => 'स्वागत है';

  @override
  String get staffHome => 'स्टाफ़';

  @override
  String get adminHome => 'एडमिन';

  @override
  String get comingSoon => 'अगले रिलीज़ में और सुविधाएँ आएँगी।';

  @override
  String get errorGeneric =>
      'सर्वर से कनेक्ट नहीं हो पा रहा। अपना कनेक्शन जाँचें।';

  @override
  String get cannotReachServer =>
      'सर्वर से कनेक्ट नहीं हो पा रहा। अपना कनेक्शन जाँचें या एडमिन से इस वेबसाइट को अनुमति देने को कहें।';

  @override
  String hello(String name) {
    return 'नमस्ते, $name';
  }

  @override
  String get retry => 'फिर से कोशिश करें';

  @override
  String get howCanWeHelp => 'हम कैसे मदद करें?';

  @override
  String get profile => 'प्रोफ़ाइल';

  @override
  String get stays => 'ठहराव';

  @override
  String get servicesUsed => 'इस्तेमाल की गई सेवाएँ';

  @override
  String get paymentHistory => 'भुगतान इतिहास';

  @override
  String get cardOrEwallet => 'कार्ड / ई-वॉलेट';

  @override
  String get testPayment => 'टेस्ट भुगतान';

  @override
  String get noneYet => 'अभी कुछ नहीं';

  @override
  String get gettingHere => 'यहाँ कैसे पहुँचें';

  @override
  String get openInMaps => 'मैप्स में खोलें';

  @override
  String get airportRoute => 'हवाई अड्डे का रास्ता';

  @override
  String get personalDetails => 'निजी जानकारी';

  @override
  String get authTagline => 'आपका ठहराव और हर सेवा, एक टैप पर';

  @override
  String get showPassword => 'पासवर्ड दिखाएँ';

  @override
  String get hidePassword => 'पासवर्ड छिपाएँ';

  @override
  String get findRoom => 'कमरा खोजें';

  @override
  String get adults => 'वयस्क';

  @override
  String get children => 'बच्चे';

  @override
  String get guests => 'मेहमान';

  @override
  String nightsCount(String count) {
    return 'रातें: $count';
  }

  @override
  String get noRooms =>
      'इन तारीखों पर कोई कमरा उपलब्ध नहीं है। दूसरी तारीखें आज़माएँ।';

  @override
  String perNight(String price) {
    return '$price / रात';
  }

  @override
  String roomsLeft(String count) {
    return 'सिर्फ़ $count बचे हैं';
  }

  @override
  String get totalLabel => 'कुल';

  @override
  String get amenities => 'सुविधाएँ';

  @override
  String get policies => 'नीतियाँ';

  @override
  String checkInTime(String time) {
    return 'चेक-इन $time से';
  }

  @override
  String checkOutTime(String time) {
    return 'चेक-आउट $time तक';
  }

  @override
  String get specialRequests => 'विशेष अनुरोध (वैकल्पिक)';

  @override
  String get reserve => 'आरक्षित करें';

  @override
  String get review => 'जाँचें और भुगतान करें';

  @override
  String holdTimer(String time) {
    return 'हम यह कमरा $time तक आपके लिए रोके हुए हैं';
  }

  @override
  String get holdExpired => 'आरक्षण का समय खत्म हो गया। फिर से खोजें।';

  @override
  String get serviceCharge => 'सेवा शुल्क';

  @override
  String get vat => 'वैट';

  @override
  String payDeposit(String amount) {
    return 'अग्रिम भुगतान $amount';
  }

  @override
  String payFull(String amount) {
    return 'पूरा भुगतान $amount';
  }

  @override
  String payBalance(String amount) {
    return 'बाकी भुगतान $amount';
  }

  @override
  String get waitingPayment => 'भुगतान का इंतज़ार…';

  @override
  String get waitingPaymentHint =>
      'ब्राउज़र में भुगतान पूरा करें। यह पेज अपने आप अपडेट होगा।';

  @override
  String get openPaymentAgain => 'भुगतान पेज फिर से खोलें';

  @override
  String get bookingConfirmed => 'बुकिंग पक्की हो गई!';

  @override
  String bookingCode(String code) {
    return 'बुकिंग $code';
  }

  @override
  String roomNumber(String room) {
    return 'कमरा $room';
  }

  @override
  String get viewBooking => 'बुकिंग देखें';

  @override
  String get backHome => 'होम पर वापस जाएँ';

  @override
  String get paymentFailed =>
      'यह बुकिंग अब रोकी नहीं गई है। अगर पैसे कटे हैं, तो लौटा दिए जाएँगे।';

  @override
  String get myBookings => 'मेरी बुकिंग';

  @override
  String get noBookings => 'अभी कोई बुकिंग नहीं।';

  @override
  String get statusHold => 'भुगतान बाकी';

  @override
  String get statusPending => 'लंबित';

  @override
  String get statusConfirmed => 'पक्की';

  @override
  String get statusCheckedIn => 'चेक-इन हो गया';

  @override
  String get statusCheckedOut => 'चेक-आउट हो गया';

  @override
  String get statusCancelled => 'रद्द';

  @override
  String get statusNoShow => 'नहीं आए';

  @override
  String get statusDeclined => 'अस्वीकृत';

  @override
  String get statusExpired => 'समाप्त';

  @override
  String get cancelBooking => 'बुकिंग रद्द करें';

  @override
  String cancelConfirm(String refund) {
    return 'यह बुकिंग रद्द करें? आपको $refund वापस मिलेंगे।';
  }

  @override
  String get keepBooking => 'बुकिंग रखें';

  @override
  String get cancelled => 'बुकिंग रद्द हो गई';

  @override
  String get invoice => 'बिल';

  @override
  String get paid => 'भुगतान हुआ';

  @override
  String get balance => 'बकाया';

  @override
  String get charges => 'शुल्क';

  @override
  String get myStay => 'मेरा ठहराव';

  @override
  String get currentStay => 'आपका ठहराव';

  @override
  String get hotelGuide => 'होटल गाइड';

  @override
  String get feedback => 'फ़ीडबैक';

  @override
  String get rateStay => 'आपका ठहराव कैसा रहा?';

  @override
  String get comment => 'टिप्पणी (वैकल्पिक)';

  @override
  String get send => 'भेजें';

  @override
  String get thanksFeedback => 'आपके फ़ीडबैक के लिए धन्यवाद!';

  @override
  String get accept => 'स्वीकार करें';

  @override
  String acceptQuote(String amount) {
    return 'कोटेशन स्वीकार करें $amount';
  }

  @override
  String get acceptance => 'स्वीकृति';

  @override
  String get active => 'सक्रिय';

  @override
  String get add => 'जोड़ें';

  @override
  String get addField => 'फ़ील्ड जोड़ें';

  @override
  String get addOption => 'विकल्प जोड़ें';

  @override
  String get addOutlet => 'आउटलेट जोड़ें';

  @override
  String get addPhoto => 'फ़ोटो जोड़ें';

  @override
  String get addRoom => 'कमरा जोड़ें';

  @override
  String get addStaff => 'स्टाफ़ जोड़ें';

  @override
  String get addTable => 'टेबल जोड़ें';

  @override
  String get adjustPoints => 'पॉइंट बदलें';

  @override
  String get alerts => 'सूचनाएँ';

  @override
  String get all => 'सभी';

  @override
  String get allergens => 'एलर्जी के तत्व';

  @override
  String get allergyNotes => 'एलर्जी या विशेष निर्देश';

  @override
  String get amount => 'राशि';

  @override
  String get applyLeave => 'छुट्टी के लिए आवेदन करें';

  @override
  String get approve => 'मंज़ूर करें';

  @override
  String get approved => 'मंज़ूर';

  @override
  String get arrivals => 'आगमन';

  @override
  String get asSoonAsPossible => 'जितना जल्दी हो सके';

  @override
  String get auditLog => 'ऑडिट लॉग';

  @override
  String get autoAccept => 'अपने आप स्वीकार करें';

  @override
  String get basePrice => 'मूल कीमत';

  @override
  String get blocks => 'कमरे ब्लॉक';

  @override
  String get body => 'टेक्स्ट';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get cancelOrder => 'ऑर्डर रद्द करें';

  @override
  String get cancelRequest => 'अनुरोध रद्द करें';

  @override
  String get cancellationPolicy => 'रद्द करने की नीति';

  @override
  String get category => 'श्रेणी';

  @override
  String get chargeToRoom => 'मेरे कमरे के बिल में जोड़ें';

  @override
  String get chat => 'चैट';

  @override
  String get chatEmpty => 'फ़्रंट डेस्क को संदेश भेजें।';

  @override
  String get chatWithHotel => 'होटल से चैट करें';

  @override
  String get checkInAction => 'चेक-इन करें';

  @override
  String get checkOutAction => 'चेक-आउट करें';

  @override
  String get choices => 'विकल्प (कॉमा से अलग करें)';

  @override
  String get closes => 'बंद होता है';

  @override
  String get codeLabel => 'कोड';

  @override
  String get collectedToday => 'आज की वसूली';

  @override
  String get content => 'गाइड और ऑफ़र';

  @override
  String get copied => 'कॉपी हो गया';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get copyCsv => 'CSV के रूप में कॉपी करें';

  @override
  String get dates => 'तारीखें';

  @override
  String get decline => 'अस्वीकार करें';

  @override
  String get delete => 'हटाएँ';

  @override
  String get department => 'विभाग';

  @override
  String get departments => 'विभाग';

  @override
  String get departures => 'प्रस्थान';

  @override
  String get depositPercent => 'अग्रिम %';

  @override
  String get description => 'विवरण';

  @override
  String get draft => 'ड्राफ़्ट';

  @override
  String get earnPer100 => 'हर ₱100 पर पॉइंट';

  @override
  String earnRate(String points) {
    return 'हर ₱100 पर आपको $points पॉइंट मिलते हैं।';
  }

  @override
  String get earnsPoints => 'लॉयल्टी पॉइंट मिलते हैं';

  @override
  String get email => 'ईमेल';

  @override
  String get emptyResets => 'खाली = मूल कीमत';

  @override
  String get enterCode => 'कोड डालें';

  @override
  String get escalate => 'आगे बढ़ाएँ';

  @override
  String get etaMin => 'तैयार होने का समय (मिनट)';

  @override
  String etaMinutes(String minutes) {
    return 'लगभग $minutes मिनट में तैयार';
  }

  @override
  String get failedNotifications => 'विफल सूचनाएँ';

  @override
  String get failedRefunds => 'विफल रिफ़ंड';

  @override
  String get fieldKey => 'फ़ील्ड कुंजी';

  @override
  String get formFields => 'मेहमान फ़ॉर्म के फ़ील्ड';

  @override
  String get free => 'खाली';

  @override
  String get freeCancelHours => 'मुफ़्त रद्दीकरण (चेक-इन से इतने घंटे पहले)';

  @override
  String get frontDesk => 'फ़्रंट डेस्क';

  @override
  String get history => 'इतिहास';

  @override
  String get hotelName => 'होटल का नाम';

  @override
  String get hotelSettings => 'होटल सेटिंग्स';

  @override
  String get inHouse => 'ठहरे हुए';

  @override
  String get inactive => 'निष्क्रिय';

  @override
  String get internalNotes => 'आंतरिक नोट्स';

  @override
  String get kind => 'प्रकार';

  @override
  String get label => 'लेबल';

  @override
  String get lateRefundPercent => 'मुफ़्त अवधि के बाद रिफ़ंड %';

  @override
  String get leadTimeMin => 'पहले से ऑर्डर (मिनट)';

  @override
  String get leaveRequests => 'छुट्टी के अनुरोध';

  @override
  String get loyalty => 'लॉयल्टी पॉइंट';

  @override
  String get markNoShow => 'नहीं आए के रूप में चिह्नित करें';

  @override
  String get maxGuests => 'अधिकतम मेहमान';

  @override
  String get members => 'सदस्य';

  @override
  String get menu => 'मेन्यू';

  @override
  String get mine => 'मेरे';

  @override
  String get missingToPublish => 'प्रकाशित करने से पहले बाकी';

  @override
  String get myDepartment => 'मेरा विभाग';

  @override
  String get myLeave => 'मेरी छुट्टी';

  @override
  String get myRequests => 'मेरे अनुरोध';

  @override
  String get name => 'नाम';

  @override
  String get netToday => 'आज का शुद्ध';

  @override
  String get network => 'नेटवर्क';

  @override
  String get newQr => 'नया QR कोड';

  @override
  String get newQrWarning => 'इस टेबल का पुराना कोड काम करना बंद कर देगा।';

  @override
  String nextTier(String points, String tier) {
    return '$tier तक $points पॉइंट और';
  }

  @override
  String get nothingHere => 'अभी कुछ नहीं।';

  @override
  String get notFound => 'नहीं मिला।';

  @override
  String get occupancyTonight => 'आज रात की ऑक्यूपेंसी';

  @override
  String get ok => 'ठीक है';

  @override
  String get openTasks => 'खुले काम';

  @override
  String get opens => 'खुलता है';

  @override
  String get options => 'विकल्प';

  @override
  String get orderStatus => 'आपका ऑर्डर';

  @override
  String get pause => 'रोकें';

  @override
  String get payAtOutlet => 'टेबल / आउटलेट पर भुगतान करें';

  @override
  String get payOnline => 'ऑनलाइन भुगतान करें';

  @override
  String get paymentMethod => 'भुगतान';

  @override
  String get payments => 'भुगतान और रिफ़ंड';

  @override
  String get pendingApproval => 'लंबित';

  @override
  String get permissions => 'अनुमतियाँ';

  @override
  String get photos => 'फ़ोटो';

  @override
  String get points => 'पॉइंट';

  @override
  String pointsBalance(String points) {
    return '$points पॉइंट';
  }

  @override
  String pointsCost(String points) {
    return '$points पॉइंट';
  }

  @override
  String get pointsPlusMinus => 'पॉइंट (+ जोड़ें, − घटाएँ)';

  @override
  String get preferredTime => 'पसंदीदा समय';

  @override
  String get price => 'कीमत';

  @override
  String get priceDelta => 'अतिरिक्त कीमत';

  @override
  String get priceModel => 'कीमत का तरीका';

  @override
  String get priceOnQuote => 'कीमत अनुरोध पर';

  @override
  String pricePerItem(String price) {
    return '$price प्रति आइटम';
  }

  @override
  String pricePerNight2(String price) {
    return '$price प्रति रात';
  }

  @override
  String pricePerPerson(String price) {
    return '$price प्रति व्यक्ति';
  }

  @override
  String get publish => 'प्रकाशित करें';

  @override
  String get published => 'प्रकाशित';

  @override
  String get qrCode => 'QR कोड';

  @override
  String get rates => 'दरें';

  @override
  String get reason => 'कारण';

  @override
  String get redeem => 'इस्तेमाल करें';

  @override
  String get redeemNeedsStay =>
      'पॉइंट पक्की या मौजूदा बुकिंग पर इस्तेमाल हो सकते हैं।';

  @override
  String get redeemed => 'आपके ठहराव पर लागू हो गया';

  @override
  String get refund => 'रिफ़ंड';

  @override
  String get refunded => 'रिफ़ंड हो गया';

  @override
  String get refundedToday => 'आज रिफ़ंड';

  @override
  String get reissueWifi => 'Wi-Fi दोबारा जारी करें';

  @override
  String get rejected => 'अस्वीकृत';

  @override
  String get removeAccess => 'स्टाफ़ की पहुँच हटाएँ';

  @override
  String get reportOccupancy => 'ऑक्यूपेंसी';

  @override
  String get reportRevenue => 'आय';

  @override
  String get reports => 'रिपोर्ट';

  @override
  String get requestStatus => 'अनुरोध की स्थिति';

  @override
  String get requireApproval => 'हर भुगतान वाली बुकिंग को स्टाफ़ मंज़ूर करे';

  @override
  String get reservation => 'आरक्षण';

  @override
  String get reservations => 'आरक्षण';

  @override
  String get restaurant => 'रेस्टोरेंट';

  @override
  String get restaurantOrders => 'रेस्टोरेंट ऑर्डर';

  @override
  String reviewOrder(String count, String total) {
    return 'ऑर्डर देखें ($count) · $total';
  }

  @override
  String get rewards => 'इनाम';

  @override
  String get role => 'भूमिका';

  @override
  String get roomLabel => 'कमरा';

  @override
  String get roomTypeLabel => 'कमरे का प्रकार';

  @override
  String get roomsAndRates => 'कमरे और दरें';

  @override
  String get save => 'सहेजें';

  @override
  String get saveDraft => 'ड्राफ़्ट सहेजें';

  @override
  String get saved => 'सहेजा गया';

  @override
  String get scanTable => 'खाना ऑर्डर करें (टेबल का QR स्कैन करें)';

  @override
  String get scanTableHint => 'कैमरे को अपनी टेबल के QR कोड की ओर करें।';

  @override
  String get schedule => 'समय-सारणी';

  @override
  String get searchGuest => 'नाम, ईमेल, फ़ोन या कोड से खोजें';

  @override
  String get sendQuote => 'कोटेशन भेजें';

  @override
  String get sendRequest => 'अनुरोध भेजें';

  @override
  String get serviceBuilder => 'सेवा बिल्डर';

  @override
  String get services => 'सेवाएँ';

  @override
  String get setRate => 'तारीखों की कीमत तय करें';

  @override
  String get staff => 'स्टाफ़';

  @override
  String get staffAndLeave => 'स्टाफ़ और छुट्टी';

  @override
  String get staffApproval => 'हर अनुरोध स्टाफ़ स्वीकार करे';

  @override
  String get status => 'स्थिति';

  @override
  String get statusSteps => 'स्थिति के चरण';

  @override
  String get submitOrder => 'ऑर्डर भेजें';

  @override
  String tableLabel(String table) {
    return 'टेबल $table';
  }

  @override
  String get tasks => 'काम';

  @override
  String get taxIncluded => 'कीमत में कर शामिल';

  @override
  String get tempPassword => 'अस्थायी पासवर्ड';

  @override
  String tier(String tier) {
    return 'स्तर: $tier';
  }

  @override
  String get title => 'शीर्षक';

  @override
  String get typeMessage => 'संदेश लिखें';

  @override
  String get unassigned => 'किसी को नहीं सौंपा';

  @override
  String get unblock => 'अनब्लॉक करें';

  @override
  String get upcoming => 'आने वाले';

  @override
  String get username => 'यूज़रनेम';

  @override
  String get validUntil => 'तक मान्य';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi मोड (portal या psk)';

  @override
  String get wifiPortalHint =>
      'नेटवर्क से जुड़ें; लॉगिन पेज खुलेगा। ऊपर दिया यूज़रनेम और पासवर्ड डालें।';

  @override
  String get wifiQrHint => 'जुड़ने के लिए कैमरे से स्कैन करें।';

  @override
  String get wifiSharedPassword => 'साझा Wi-Fi पासवर्ड (psk मोड)';

  @override
  String get action => 'कार्रवाई';

  @override
  String get entity => 'वस्तु';

  @override
  String get dateLabel => 'तारीख';

  @override
  String get actor => 'करने वाला';

  @override
  String get navOverview => 'सारांश';

  @override
  String get navCatalog => 'कैटलॉग';

  @override
  String get navFinance => 'वित्त';

  @override
  String get navPeople => 'लोग';

  @override
  String get navSystem => 'सिस्टम';

  @override
  String get details => 'विवरण';

  @override
  String get refresh => 'रीफ़्रेश करें';

  @override
  String get needsAttention => 'ध्यान देने लायक';

  @override
  String get allClear => 'किसी चीज़ पर ध्यान देने की ज़रूरत नहीं';

  @override
  String get unreadChats => 'बिना पढ़ी चैट';

  @override
  String get myTasks => 'मेरे काम';

  @override
  String get search => 'खोजें';

  @override
  String get showMore => 'और दिखाएँ';

  @override
  String get viewLabel => 'दृश्य';

  @override
  String get sortedAscending => 'बढ़ते क्रम में';

  @override
  String get sortedDescending => 'घटते क्रम में';

  @override
  String sortBy(String column) {
    return '$column के अनुसार क्रम';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$total में से $shown';
  }

  @override
  String get note => 'नोट';

  @override
  String get rooms => 'कमरे';

  @override
  String get tables => 'टेबल';

  @override
  String get showDetails => 'विवरण दिखाएँ';

  @override
  String get hideDetails => 'विवरण छिपाएँ';

  @override
  String get selectThread => 'कोई बातचीत चुनें';

  @override
  String get keyboardShortcuts => 'कीबोर्ड शॉर्टकट';

  @override
  String get goToPage => 'किसी पेज पर जाएँ';

  @override
  String get shortcutSearch => 'इस पेज में खोजें';

  @override
  String get shortcutClose => 'पैनल या डायलॉग बंद करें';

  @override
  String get shortcutHelp => 'कीबोर्ड शॉर्टकट दिखाएँ';

  @override
  String get shortcutSend => 'संदेश भेजें (Shift+Enter: नई पंक्ति)';

  @override
  String get roomBoard => 'आज के कमरे';

  @override
  String get roomOccupied => 'भरा हुआ';

  @override
  String get roomDeparting => 'आज चेक-आउट';

  @override
  String get roomArriving => 'आज आगमन';

  @override
  String get roomReserved => 'आरक्षित';

  @override
  String get roomBlocked => 'ब्लॉक';

  @override
  String freeOf(String free, String total) {
    return '$total में से $free उपलब्ध';
  }

  @override
  String get todaysArrivals => 'आज के आगमन';

  @override
  String get todaysDepartures => 'आज के प्रस्थान';

  @override
  String get guestList => 'मेहमानों की सूची';

  @override
  String get team => 'टीम';

  @override
  String get lastStay => 'पिछला ठहराव';

  @override
  String get roleAdmin => 'एडमिन';

  @override
  String get notifications => 'सूचनाएँ';

  @override
  String get notifBooking => 'नई बुकिंग';

  @override
  String get notifPending => 'बुकिंग को मंज़ूरी चाहिए';

  @override
  String get notifCancelled => 'बुकिंग रद्द';

  @override
  String get notifRequest => 'नया सेवा अनुरोध';

  @override
  String get notifOrder => 'नया खाने का ऑर्डर';

  @override
  String get notifMessage => 'नया संदेश';

  @override
  String staffCancelConfirm(String refund) {
    return 'यह बुकिंग रद्द करें? रद्दीकरण नीति के अनुसार मेहमान को $refund वापस मिलेंगे।';
  }

  @override
  String get phone => 'फ़ोन';

  @override
  String get appearance => 'दिखावट';

  @override
  String get themeSystem => 'डिवाइस के अनुसार';

  @override
  String get themeLight => 'लाइट';

  @override
  String get themeDark => 'डार्क';

  @override
  String get roomAvailable => 'उपलब्ध';

  @override
  String get availableOnly => 'सिर्फ़ उपलब्ध';

  @override
  String get floor => 'मंज़िल';

  @override
  String get allRoomTypes => 'सभी प्रकार के कमरे';

  @override
  String get guestLabel => 'मेहमान';

  @override
  String get rowNo => 'क्रम';

  @override
  String get employeeId => 'कर्मचारी आईडी';

  @override
  String get photo => 'फ़ोटो';

  @override
  String get dateFrom => 'से';

  @override
  String get dateTo => 'तक';

  @override
  String get leaveType => 'छुट्टी का प्रकार';

  @override
  String get leaveVacation => 'छुट्टी';

  @override
  String get leaveSick => 'बीमारी';

  @override
  String get leaveEmergency => 'आपात';

  @override
  String get leaveOther => 'अन्य';

  @override
  String get submit => 'भेजें';

  @override
  String get cash => 'नकद';

  @override
  String get card => 'कार्ड';

  @override
  String get arrival => 'आगमन';

  @override
  String get departure => 'प्रस्थान';

  @override
  String get serviceRequests => 'सेवा अनुरोध';

  @override
  String get newRequest => 'नया अनुरोध';

  @override
  String get guestBooking => 'मेहमान की बुकिंग';

  @override
  String bookRoom(String room) {
    return 'कमरा $room बुक करें';
  }

  @override
  String get bookAndCheckIn => 'बुक करें और चेक-इन करें';

  @override
  String get changeBooking => 'बुकिंग बदलें';

  @override
  String get recordPayment => 'भुगतान दर्ज करें';

  @override
  String get emailOrPhoneRequired => 'ईमेल या फ़ोन नंबर डालें';

  @override
  String get emailLocked => 'मेहमान का साइन-इन ईमेल यहाँ नहीं बदला जा सकता।';

  @override
  String get onLeaveToday => 'छुट्टी पर';

  @override
  String leaveUpcoming(String dates) {
    return 'छुट्टी $dates';
  }

  @override
  String get collapseMenu => 'मेन्यू छोटा करें';

  @override
  String get expandMenu => 'मेन्यू बड़ा करें';

  @override
  String get roleRestaurant => 'रेस्टोरेंट स्टाफ़';

  @override
  String get next => 'आगे';

  @override
  String get payAtDesk => 'मेहमान फ़्रंट डेस्क पर भुगतान करेगा।';

  @override
  String get notAvailableForDates =>
      'इन तारीखों पर इस प्रकार के सभी कमरे भरे हैं। दूसरी तारीखें या दूसरा कमरा आज़माएँ।';

  @override
  String get byType => 'प्रकार के अनुसार';

  @override
  String get byFloor => 'मंज़िल के अनुसार';

  @override
  String floorN(String floor) {
    return 'मंज़िल $floor';
  }

  @override
  String get paymentPaid => 'भुगतान हुआ';

  @override
  String get paymentDeposit => 'अग्रिम भुगतान हुआ';

  @override
  String get paymentPartial => 'आंशिक भुगतान';

  @override
  String get paymentUnpaid => 'भुगतान नहीं हुआ';

  @override
  String get moreLanguages => 'और भाषाएँ';
}
