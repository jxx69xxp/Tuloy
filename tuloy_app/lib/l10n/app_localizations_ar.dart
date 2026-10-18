// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get emailOrPhone => 'البريد الإلكتروني أو رقم الهاتف';

  @override
  String get password => 'كلمة المرور';

  @override
  String get passwordHint => '8 أحرف على الأقل';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get required => 'مطلوب';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get sendCode => 'إرسال الرمز';

  @override
  String get codeSent => 'إذا كان الحساب موجودًا، فقد أرسلنا رمزًا من 6 أرقام.';

  @override
  String get code => 'رمز من 6 أرقام';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get resetPassword => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordChanged => 'تم تغيير كلمة المرور. يرجى تسجيل الدخول.';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get guestHome => 'أهلًا بك';

  @override
  String get staffHome => 'الموظفون';

  @override
  String get adminHome => 'الإدارة';

  @override
  String get comingSoon => 'ستتوفر ميزات أخرى في الإصدار القادم.';

  @override
  String get errorGeneric => 'تعذّر الاتصال بالخادم. تحقق من اتصالك.';

  @override
  String get cannotReachServer =>
      'تعذّر الاتصال بالخادم. تحقق من اتصالك أو اطلب من المسؤول السماح بهذا الموقع.';

  @override
  String hello(String name) {
    return 'مرحبًا، $name';
  }

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get howCanWeHelp => 'كيف يمكننا مساعدتك؟';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get stays => 'الإقامات';

  @override
  String get servicesUsed => 'الخدمات المستخدمة';

  @override
  String get paymentHistory => 'سجل المدفوعات';

  @override
  String get cardOrEwallet => 'بطاقة / محفظة إلكترونية';

  @override
  String get testPayment => 'دفعة تجريبية';

  @override
  String get noneYet => 'لا شيء بعد';

  @override
  String get gettingHere => 'كيفية الوصول';

  @override
  String get openInMaps => 'فتح في الخرائط';

  @override
  String get airportRoute => 'الطريق إلى المطار';

  @override
  String get personalDetails => 'البيانات الشخصية';

  @override
  String get authTagline => 'إقامتك وكل الخدمات بلمسة واحدة';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get findRoom => 'ابحث عن غرفة';

  @override
  String get adults => 'البالغون';

  @override
  String get children => 'الأطفال';

  @override
  String get guests => 'الضيوف';

  @override
  String nightsCount(String count) {
    return 'عدد الليالي: $count';
  }

  @override
  String get noRooms => 'لا توجد غرف متاحة في هذه التواريخ. جرّب تواريخ أخرى.';

  @override
  String perNight(String price) {
    return '$price / الليلة';
  }

  @override
  String roomsLeft(String count) {
    return 'تبقّى $count فقط';
  }

  @override
  String get totalLabel => 'الإجمالي';

  @override
  String get amenities => 'المرافق';

  @override
  String get policies => 'السياسات';

  @override
  String checkInTime(String time) {
    return 'تسجيل الوصول من $time';
  }

  @override
  String checkOutTime(String time) {
    return 'تسجيل المغادرة قبل $time';
  }

  @override
  String get specialRequests => 'طلبات خاصة (اختياري)';

  @override
  String get reserve => 'احجز';

  @override
  String get review => 'المراجعة والدفع';

  @override
  String holdTimer(String time) {
    return 'نحجز هذه الغرفة لك لمدة $time';
  }

  @override
  String get holdExpired => 'انتهت مدة الحجز المؤقت. يرجى البحث مرة أخرى.';

  @override
  String get serviceCharge => 'رسوم الخدمة';

  @override
  String get vat => 'ضريبة القيمة المضافة';

  @override
  String payDeposit(String amount) {
    return 'ادفع العربون $amount';
  }

  @override
  String payFull(String amount) {
    return 'ادفع كامل المبلغ $amount';
  }

  @override
  String payBalance(String amount) {
    return 'ادفع الرصيد $amount';
  }

  @override
  String get waitingPayment => 'بانتظار الدفع…';

  @override
  String get waitingPaymentHint =>
      'أكمل الدفع في المتصفح. ستتحدّث هذه الصفحة تلقائيًا.';

  @override
  String get openPaymentAgain => 'فتح صفحة الدفع مرة أخرى';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز!';

  @override
  String bookingCode(String code) {
    return 'الحجز $code';
  }

  @override
  String roomNumber(String room) {
    return 'الغرفة $room';
  }

  @override
  String get viewBooking => 'عرض الحجز';

  @override
  String get backHome => 'العودة إلى الرئيسية';

  @override
  String get paymentFailed =>
      'لم يعد هذا الحجز محجوزًا. إذا خُصم منك مبلغ فسيُردّ إليك.';

  @override
  String get myBookings => 'حجوزاتي';

  @override
  String get noBookings => 'لا توجد حجوزات بعد.';

  @override
  String get statusHold => 'بانتظار الدفع';

  @override
  String get statusPending => 'قيد الانتظار';

  @override
  String get statusConfirmed => 'مؤكد';

  @override
  String get statusCheckedIn => 'تم تسجيل الوصول';

  @override
  String get statusCheckedOut => 'تم تسجيل المغادرة';

  @override
  String get statusCancelled => 'ملغى';

  @override
  String get statusNoShow => 'لم يحضر';

  @override
  String get statusDeclined => 'مرفوض';

  @override
  String get statusExpired => 'منتهي';

  @override
  String get cancelBooking => 'إلغاء الحجز';

  @override
  String cancelConfirm(String refund) {
    return 'هل تريد إلغاء هذا الحجز؟ سيُردّ إليك $refund.';
  }

  @override
  String get keepBooking => 'الإبقاء على الحجز';

  @override
  String get cancelled => 'تم إلغاء الحجز';

  @override
  String get invoice => 'الفاتورة';

  @override
  String get paid => 'المدفوع';

  @override
  String get balance => 'الرصيد';

  @override
  String get charges => 'الرسوم';

  @override
  String get myStay => 'إقامتي';

  @override
  String get currentStay => 'إقامتك';

  @override
  String get hotelGuide => 'دليل الفندق';

  @override
  String get feedback => 'الملاحظات';

  @override
  String get rateStay => 'كيف كانت إقامتك؟';

  @override
  String get comment => 'تعليقات (اختياري)';

  @override
  String get send => 'إرسال';

  @override
  String get thanksFeedback => 'شكرًا لملاحظاتك!';

  @override
  String get accept => 'قبول';

  @override
  String acceptQuote(String amount) {
    return 'قبول عرض السعر $amount';
  }

  @override
  String get acceptance => 'القبول';

  @override
  String get active => 'نشط';

  @override
  String get add => 'إضافة';

  @override
  String get addField => 'إضافة حقل';

  @override
  String get addOption => 'إضافة خيار';

  @override
  String get addOutlet => 'إضافة منفذ';

  @override
  String get addPhoto => 'إضافة صورة';

  @override
  String get addRoom => 'إضافة غرفة';

  @override
  String get addStaff => 'إضافة موظف';

  @override
  String get addTable => 'إضافة طاولة';

  @override
  String get adjustPoints => 'تعديل النقاط';

  @override
  String get alerts => 'تنبيهات';

  @override
  String get all => 'الكل';

  @override
  String get allergens => 'مسببات الحساسية';

  @override
  String get allergyNotes => 'حساسية أو تعليمات خاصة';

  @override
  String get amount => 'المبلغ';

  @override
  String get applyLeave => 'طلب إجازة';

  @override
  String get approve => 'موافقة';

  @override
  String get approved => 'تمت الموافقة';

  @override
  String get arrivals => 'الوصول';

  @override
  String get asSoonAsPossible => 'في أقرب وقت';

  @override
  String get auditLog => 'سجل التدقيق';

  @override
  String get autoAccept => 'قبول تلقائي';

  @override
  String get basePrice => 'السعر الأساسي';

  @override
  String get blocks => 'حجب الغرف';

  @override
  String get body => 'النص';

  @override
  String get cancel => 'إلغاء';

  @override
  String get cancelOrder => 'إلغاء الطلب';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get cancellationPolicy => 'سياسة الإلغاء';

  @override
  String get category => 'الفئة';

  @override
  String get chargeToRoom => 'إضافة إلى حساب غرفتي';

  @override
  String get chat => 'الدردشة';

  @override
  String get chatEmpty => 'أرسل رسالة إلى الاستقبال.';

  @override
  String get chatWithHotel => 'الدردشة مع الفندق';

  @override
  String get checkInAction => 'تسجيل الوصول';

  @override
  String get checkOutAction => 'تسجيل المغادرة';

  @override
  String get choices => 'الخيارات (مفصولة بفواصل)';

  @override
  String get closes => 'يغلق';

  @override
  String get codeLabel => 'الرمز';

  @override
  String get collectedToday => 'المحصّل اليوم';

  @override
  String get content => 'الأدلة والعروض';

  @override
  String get copied => 'تم النسخ';

  @override
  String get copy => 'نسخ';

  @override
  String get copyCsv => 'نسخ بصيغة CSV';

  @override
  String get dates => 'التواريخ';

  @override
  String get decline => 'رفض';

  @override
  String get delete => 'حذف';

  @override
  String get department => 'القسم';

  @override
  String get departments => 'الأقسام';

  @override
  String get departures => 'المغادرة';

  @override
  String get depositPercent => 'العربون %';

  @override
  String get description => 'الوصف';

  @override
  String get draft => 'مسودة';

  @override
  String get earnPer100 => 'النقاط لكل ₱100';

  @override
  String earnRate(String points) {
    return 'تكسب $points نقطة لكل ₱100.';
  }

  @override
  String get earnsPoints => 'يمنح نقاط الولاء';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emptyResets => 'فارغ = السعر الأساسي';

  @override
  String get enterCode => 'أدخل الرمز';

  @override
  String get escalate => 'تصعيد';

  @override
  String get etaMin => 'جاهز خلال (دقائق)';

  @override
  String etaMinutes(String minutes) {
    return 'جاهز خلال $minutes دقيقة تقريبًا';
  }

  @override
  String get failedNotifications => 'إشعارات لم تُرسل';

  @override
  String get failedRefunds => 'مبالغ مستردة فشلت';

  @override
  String get fieldKey => 'مفتاح الحقل';

  @override
  String get formFields => 'حقول نموذج الضيف';

  @override
  String get free => 'متاحة';

  @override
  String get freeCancelHours => 'إلغاء مجاني (ساعات قبل الوصول)';

  @override
  String get frontDesk => 'الاستقبال';

  @override
  String get history => 'السجل';

  @override
  String get hotelName => 'اسم الفندق';

  @override
  String get hotelSettings => 'إعدادات الفندق';

  @override
  String get inHouse => 'المقيمون';

  @override
  String get inactive => 'غير نشط';

  @override
  String get internalNotes => 'ملاحظات داخلية';

  @override
  String get kind => 'النوع';

  @override
  String get label => 'التسمية';

  @override
  String get lateRefundPercent => 'الاسترداد بعد الفترة المجانية %';

  @override
  String get leadTimeMin => 'الطلب المسبق (دقائق)';

  @override
  String get leaveRequests => 'طلبات الإجازة';

  @override
  String get loyalty => 'نقاط الولاء';

  @override
  String get markNoShow => 'تسجيل عدم الحضور';

  @override
  String get maxGuests => 'الحد الأقصى للضيوف';

  @override
  String get members => 'الأعضاء';

  @override
  String get menu => 'القائمة';

  @override
  String get mine => 'الخاصة بي';

  @override
  String get missingToPublish => 'ناقص قبل النشر';

  @override
  String get myDepartment => 'قسمي';

  @override
  String get myLeave => 'إجازاتي';

  @override
  String get myRequests => 'طلباتي';

  @override
  String get name => 'الاسم';

  @override
  String get netToday => 'الصافي اليوم';

  @override
  String get network => 'الشبكة';

  @override
  String get newQr => 'رمز QR جديد';

  @override
  String get newQrWarning => 'سيتوقف الرمز القديم لهذه الطاولة عن العمل.';

  @override
  String nextTier(String points, String tier) {
    return '$points نقطة إضافية للوصول إلى $tier';
  }

  @override
  String get nothingHere => 'لا شيء بعد.';

  @override
  String get notFound => 'غير موجود.';

  @override
  String get occupancyTonight => 'نسبة الإشغال الليلة';

  @override
  String get ok => 'موافق';

  @override
  String get openTasks => 'مهام مفتوحة';

  @override
  String get opens => 'يفتح';

  @override
  String get options => 'الخيارات';

  @override
  String get orderStatus => 'طلبك';

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get payAtOutlet => 'الدفع على الطاولة / في المنفذ';

  @override
  String get payOnline => 'الدفع عبر الإنترنت';

  @override
  String get paymentMethod => 'الدفع';

  @override
  String get payments => 'المدفوعات والمبالغ المستردة';

  @override
  String get pendingApproval => 'بانتظار الموافقة';

  @override
  String get permissions => 'الصلاحيات';

  @override
  String get photos => 'الصور';

  @override
  String get points => 'النقاط';

  @override
  String pointsBalance(String points) {
    return '$points نقطة';
  }

  @override
  String pointsCost(String points) {
    return '$points نقطة';
  }

  @override
  String get pointsPlusMinus => 'النقاط (+ إضافة، − خصم)';

  @override
  String get preferredTime => 'الوقت المفضل';

  @override
  String get price => 'السعر';

  @override
  String get priceDelta => 'سعر إضافي';

  @override
  String get priceModel => 'نموذج التسعير';

  @override
  String get priceOnQuote => 'السعر عند الطلب';

  @override
  String pricePerItem(String price) {
    return '$price للقطعة';
  }

  @override
  String pricePerNight2(String price) {
    return '$price لليلة';
  }

  @override
  String pricePerPerson(String price) {
    return '$price للشخص';
  }

  @override
  String get publish => 'نشر';

  @override
  String get published => 'منشور';

  @override
  String get qrCode => 'رمز QR';

  @override
  String get rates => 'الأسعار';

  @override
  String get reason => 'السبب';

  @override
  String get redeem => 'استبدال';

  @override
  String get redeemNeedsStay => 'يمكن استخدام النقاط في إقامة مؤكدة أو حالية.';

  @override
  String get redeemed => 'تم تطبيقها على إقامتك';

  @override
  String get refund => 'استرداد';

  @override
  String get refunded => 'تم الاسترداد';

  @override
  String get refundedToday => 'المسترد اليوم';

  @override
  String get reissueWifi => 'إعادة إصدار Wi-Fi';

  @override
  String get rejected => 'مرفوض';

  @override
  String get removeAccess => 'إزالة صلاحية الموظف';

  @override
  String get reportOccupancy => 'الإشغال';

  @override
  String get reportRevenue => 'الإيرادات';

  @override
  String get reports => 'التقارير';

  @override
  String get requestStatus => 'حالة الطلب';

  @override
  String get requireApproval => 'يوافق الموظفون على كل حجز مدفوع';

  @override
  String get reservation => 'الحجز';

  @override
  String get reservations => 'الحجوزات';

  @override
  String get restaurant => 'المطعم';

  @override
  String get restaurantOrders => 'طلبات المطعم';

  @override
  String reviewOrder(String count, String total) {
    return 'مراجعة الطلب ($count) · $total';
  }

  @override
  String get rewards => 'المكافآت';

  @override
  String get role => 'الدور';

  @override
  String get roomLabel => 'الغرفة';

  @override
  String get roomTypeLabel => 'نوع الغرفة';

  @override
  String get roomsAndRates => 'الغرف والأسعار';

  @override
  String get save => 'حفظ';

  @override
  String get saveDraft => 'حفظ المسودة';

  @override
  String get saved => 'تم الحفظ';

  @override
  String get scanTable => 'اطلب طعامًا (امسح رمز QR على الطاولة)';

  @override
  String get scanTableHint => 'وجّه الكاميرا نحو رمز QR على طاولتك.';

  @override
  String get schedule => 'المواعيد';

  @override
  String get searchGuest => 'ابحث بالاسم أو البريد أو الهاتف أو الرمز';

  @override
  String get sendQuote => 'إرسال عرض السعر';

  @override
  String get sendRequest => 'إرسال الطلب';

  @override
  String get serviceBuilder => 'منشئ الخدمات';

  @override
  String get services => 'الخدمات';

  @override
  String get setRate => 'تحديد السعر لتواريخ';

  @override
  String get staff => 'الموظفون';

  @override
  String get staffAndLeave => 'الموظفون والإجازات';

  @override
  String get staffApproval => 'يقبل الموظفون كل طلب';

  @override
  String get status => 'الحالة';

  @override
  String get statusSteps => 'مراحل الحالة';

  @override
  String get submitOrder => 'إرسال الطلب';

  @override
  String tableLabel(String table) {
    return 'الطاولة $table';
  }

  @override
  String get tasks => 'المهام';

  @override
  String get taxIncluded => 'السعر شامل الضريبة';

  @override
  String get tempPassword => 'كلمة مرور مؤقتة';

  @override
  String tier(String tier) {
    return 'المستوى: $tier';
  }

  @override
  String get title => 'العنوان';

  @override
  String get typeMessage => 'اكتب رسالة';

  @override
  String get unassigned => 'غير مسندة';

  @override
  String get unblock => 'إلغاء الحجب';

  @override
  String get upcoming => 'القادمة';

  @override
  String get username => 'اسم المستخدم';

  @override
  String get validUntil => 'صالح حتى';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'وضع Wi-Fi (portal أو psk)';

  @override
  String get wifiPortalHint =>
      'اتصل بالشبكة وستفتح صفحة الدخول. أدخل اسم المستخدم وكلمة المرور أعلاه.';

  @override
  String get wifiQrHint => 'امسح بالكاميرا للاتصال.';

  @override
  String get wifiSharedPassword => 'كلمة مرور Wi-Fi المشتركة (وضع psk)';

  @override
  String get action => 'الإجراء';

  @override
  String get entity => 'العنصر';

  @override
  String get dateLabel => 'التاريخ';

  @override
  String get actor => 'المنفّذ';

  @override
  String get navOverview => 'نظرة عامة';

  @override
  String get navCatalog => 'الكتالوج';

  @override
  String get navFinance => 'المالية';

  @override
  String get navPeople => 'الأشخاص';

  @override
  String get navSystem => 'النظام';

  @override
  String get details => 'التفاصيل';

  @override
  String get refresh => 'تحديث';

  @override
  String get needsAttention => 'يحتاج إلى متابعة';

  @override
  String get allClear => 'لا شيء يحتاج إلى متابعة';

  @override
  String get unreadChats => 'محادثات غير مقروءة';

  @override
  String get myTasks => 'مهامي';

  @override
  String get search => 'بحث';

  @override
  String get showMore => 'عرض المزيد';

  @override
  String get viewLabel => 'العرض';

  @override
  String get sortedAscending => 'ترتيب تصاعدي';

  @override
  String get sortedDescending => 'ترتيب تنازلي';

  @override
  String sortBy(String column) {
    return 'ترتيب حسب $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown من $total';
  }

  @override
  String get note => 'ملاحظة';

  @override
  String get rooms => 'الغرف';

  @override
  String get tables => 'الطاولات';

  @override
  String get showDetails => 'عرض التفاصيل';

  @override
  String get hideDetails => 'إخفاء التفاصيل';

  @override
  String get selectThread => 'اختر محادثة';

  @override
  String get keyboardShortcuts => 'اختصارات لوحة المفاتيح';

  @override
  String get goToPage => 'الانتقال إلى صفحة';

  @override
  String get shortcutSearch => 'البحث في هذه الصفحة';

  @override
  String get shortcutClose => 'إغلاق لوحة أو نافذة';

  @override
  String get shortcutHelp => 'عرض اختصارات لوحة المفاتيح';

  @override
  String get shortcutSend => 'إرسال رسالة (Shift+Enter: سطر جديد)';

  @override
  String get roomBoard => 'الغرف اليوم';

  @override
  String get roomOccupied => 'مشغولة';

  @override
  String get roomDeparting => 'مغادرة اليوم';

  @override
  String get roomArriving => 'وصول اليوم';

  @override
  String get roomReserved => 'محجوزة';

  @override
  String get roomBlocked => 'محجوبة';

  @override
  String freeOf(String free, String total) {
    return '$free من $total متاحة';
  }

  @override
  String get todaysArrivals => 'وصول اليوم';

  @override
  String get todaysDepartures => 'مغادرة اليوم';

  @override
  String get guestList => 'قائمة الضيوف';

  @override
  String get team => 'الفريق';

  @override
  String get lastStay => 'آخر إقامة';

  @override
  String get roleAdmin => 'مسؤول';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notifBooking => 'حجز جديد';

  @override
  String get notifPending => 'حجز يحتاج إلى موافقة';

  @override
  String get notifCancelled => 'تم إلغاء الحجز';

  @override
  String get notifRequest => 'طلب خدمة جديد';

  @override
  String get notifOrder => 'طلب طعام جديد';

  @override
  String get notifMessage => 'رسالة جديدة';

  @override
  String staffCancelConfirm(String refund) {
    return 'هل تريد إلغاء هذا الحجز؟ وفق سياسة الإلغاء سيستردّ الضيف $refund.';
  }

  @override
  String get phone => 'الهاتف';

  @override
  String get appearance => 'المظهر';

  @override
  String get themeSystem => 'حسب الجهاز';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get roomAvailable => 'متاحة';

  @override
  String get availableOnly => 'المتاحة فقط';

  @override
  String get floor => 'الطابق';

  @override
  String get allRoomTypes => 'كل أنواع الغرف';

  @override
  String get guestLabel => 'الضيف';

  @override
  String get rowNo => 'رقم';

  @override
  String get employeeId => 'رقم الموظف';

  @override
  String get photo => 'الصورة';

  @override
  String get dateFrom => 'من';

  @override
  String get dateTo => 'إلى';

  @override
  String get leaveType => 'نوع الإجازة';

  @override
  String get leaveVacation => 'إجازة سنوية';

  @override
  String get leaveSick => 'مرضية';

  @override
  String get leaveEmergency => 'طارئة';

  @override
  String get leaveOther => 'أخرى';

  @override
  String get submit => 'إرسال';

  @override
  String get cash => 'نقدًا';

  @override
  String get card => 'بطاقة';

  @override
  String get arrival => 'الوصول';

  @override
  String get departure => 'المغادرة';

  @override
  String get serviceRequests => 'طلبات الخدمة';

  @override
  String get newRequest => 'طلب جديد';

  @override
  String get guestBooking => 'حجز الضيف';

  @override
  String bookRoom(String room) {
    return 'حجز الغرفة $room';
  }

  @override
  String get bookAndCheckIn => 'الحجز وتسجيل الوصول';

  @override
  String get changeBooking => 'تعديل الحجز';

  @override
  String get recordPayment => 'تسجيل دفعة';

  @override
  String get emailOrPhoneRequired => 'أدخل بريدًا إلكترونيًا أو رقم هاتف';

  @override
  String get emailLocked => 'لا يمكن تغيير بريد تسجيل دخول الضيف من هنا.';

  @override
  String get onLeaveToday => 'في إجازة';

  @override
  String leaveUpcoming(String dates) {
    return 'إجازة $dates';
  }

  @override
  String get collapseMenu => 'طي القائمة';

  @override
  String get expandMenu => 'توسيع القائمة';

  @override
  String get roleRestaurant => 'موظف مطعم';

  @override
  String get next => 'التالي';

  @override
  String get payAtDesk => 'يدفع الضيف في الاستقبال.';

  @override
  String get notAvailableForDates =>
      'هذا النوع من الغرف ممتلئ في هذه التواريخ. جرّب تواريخ أخرى أو غرفة أخرى.';

  @override
  String get byType => 'حسب النوع';

  @override
  String get byFloor => 'حسب الطابق';

  @override
  String floorN(String floor) {
    return 'الطابق $floor';
  }

  @override
  String get paymentPaid => 'مدفوع';

  @override
  String get paymentDeposit => 'تم دفع العربون';

  @override
  String get paymentPartial => 'مدفوع جزئيًا';

  @override
  String get paymentUnpaid => 'غير مدفوع';

  @override
  String get moreLanguages => 'لغات أخرى';
}
