// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'เข้าสู่ระบบ';

  @override
  String get signUp => 'สร้างบัญชี';

  @override
  String get signOut => 'ออกจากระบบ';

  @override
  String get noAccount => 'ยังไม่มีบัญชี?';

  @override
  String get haveAccount => 'มีบัญชีอยู่แล้ว?';

  @override
  String get emailOrPhone => 'อีเมลหรือหมายเลขโทรศัพท์';

  @override
  String get password => 'รหัสผ่าน';

  @override
  String get passwordHint => 'อย่างน้อย 8 ตัวอักษร';

  @override
  String get fullName => 'ชื่อ-นามสกุล';

  @override
  String get required => 'จำเป็น';

  @override
  String get forgotPassword => 'ลืมรหัสผ่าน?';

  @override
  String get sendCode => 'ส่งรหัส';

  @override
  String get codeSent => 'หากมีบัญชีนี้ เราได้ส่งรหัส 6 หลักให้แล้ว';

  @override
  String get code => 'รหัส 6 หลัก';

  @override
  String get newPassword => 'รหัสผ่านใหม่';

  @override
  String get resetPassword => 'รีเซ็ตรหัสผ่าน';

  @override
  String get passwordChanged => 'เปลี่ยนรหัสผ่านแล้ว กรุณาเข้าสู่ระบบ';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get language => 'ภาษา';

  @override
  String get guestHome => 'ยินดีต้อนรับ';

  @override
  String get staffHome => 'พนักงาน';

  @override
  String get adminHome => 'ผู้ดูแล';

  @override
  String get comingSoon => 'ฟีเจอร์เพิ่มเติมจะมาในรุ่นถัดไป';

  @override
  String get errorGeneric =>
      'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ ตรวจสอบการเชื่อมต่อของคุณ';

  @override
  String get cannotReachServer =>
      'เชื่อมต่อเซิร์ฟเวอร์ไม่ได้ ตรวจสอบการเชื่อมต่อ หรือขอให้ผู้ดูแลอนุญาตเว็บไซต์นี้';

  @override
  String hello(String name) {
    return 'สวัสดี $name';
  }

  @override
  String get retry => 'ลองอีกครั้ง';

  @override
  String get howCanWeHelp => 'ให้เราช่วยอะไรดี?';

  @override
  String get profile => 'โปรไฟล์';

  @override
  String get stays => 'การเข้าพัก';

  @override
  String get servicesUsed => 'บริการที่ใช้';

  @override
  String get paymentHistory => 'ประวัติการชำระเงิน';

  @override
  String get cardOrEwallet => 'บัตร / อีวอลเล็ต';

  @override
  String get testPayment => 'ชำระเงินทดสอบ';

  @override
  String get noneYet => 'ยังไม่มี';

  @override
  String get gettingHere => 'การเดินทางมาที่นี่';

  @override
  String get openInMaps => 'เปิดในแผนที่';

  @override
  String get airportRoute => 'เส้นทางไปสนามบิน';

  @override
  String get personalDetails => 'ข้อมูลส่วนตัว';

  @override
  String get authTagline => 'การเข้าพักและทุกบริการ ในแตะเดียว';

  @override
  String get showPassword => 'แสดงรหัสผ่าน';

  @override
  String get hidePassword => 'ซ่อนรหัสผ่าน';

  @override
  String get findRoom => 'ค้นหาห้อง';

  @override
  String get adults => 'ผู้ใหญ่';

  @override
  String get children => 'เด็ก';

  @override
  String get guests => 'ผู้เข้าพัก';

  @override
  String nightsCount(String count) {
    return 'จำนวนคืน: $count';
  }

  @override
  String get noRooms => 'ไม่มีห้องว่างในวันที่นี้ ลองวันอื่น';

  @override
  String perNight(String price) {
    return '$price / คืน';
  }

  @override
  String roomsLeft(String count) {
    return 'เหลือ $count';
  }

  @override
  String get totalLabel => 'รวม';

  @override
  String get amenities => 'สิ่งอำนวยความสะดวก';

  @override
  String get policies => 'นโยบาย';

  @override
  String checkInTime(String time) {
    return 'เช็กอินตั้งแต่ $time';
  }

  @override
  String checkOutTime(String time) {
    return 'เช็กเอาต์ภายใน $time';
  }

  @override
  String get specialRequests => 'คำขอพิเศษ (ไม่บังคับ)';

  @override
  String get reserve => 'จอง';

  @override
  String get review => 'ตรวจสอบและชำระเงิน';

  @override
  String holdTimer(String time) {
    return 'เรากันห้องนี้ไว้ให้คุณ $time';
  }

  @override
  String get holdExpired => 'หมดเวลากันห้องแล้ว กรุณาค้นหาอีกครั้ง';

  @override
  String get serviceCharge => 'ค่าบริการ';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'ชำระมัดจำ $amount';
  }

  @override
  String payFull(String amount) {
    return 'ชำระเต็มจำนวน $amount';
  }

  @override
  String payBalance(String amount) {
    return 'ชำระยอดคงเหลือ $amount';
  }

  @override
  String get waitingPayment => 'กำลังรอการชำระเงิน…';

  @override
  String get waitingPaymentHint =>
      'ชำระเงินให้เสร็จในเบราว์เซอร์ หน้านี้จะอัปเดตเอง';

  @override
  String get openPaymentAgain => 'เปิดหน้าชำระเงินอีกครั้ง';

  @override
  String get bookingConfirmed => 'ยืนยันการจองแล้ว!';

  @override
  String bookingCode(String code) {
    return 'การจอง $code';
  }

  @override
  String roomNumber(String room) {
    return 'ห้อง $room';
  }

  @override
  String get viewBooking => 'ดูการจอง';

  @override
  String get backHome => 'กลับหน้าแรก';

  @override
  String get paymentFailed =>
      'การจองนี้ไม่ได้ถูกกันไว้แล้ว หากถูกเรียกเก็บเงิน เราจะคืนเงินให้';

  @override
  String get myBookings => 'การจองของฉัน';

  @override
  String get noBookings => 'ยังไม่มีการจอง';

  @override
  String get statusHold => 'รอชำระเงิน';

  @override
  String get statusPending => 'รอดำเนินการ';

  @override
  String get statusConfirmed => 'ยืนยันแล้ว';

  @override
  String get statusCheckedIn => 'เช็กอินแล้ว';

  @override
  String get statusCheckedOut => 'เช็กเอาต์แล้ว';

  @override
  String get statusCancelled => 'ยกเลิกแล้ว';

  @override
  String get statusNoShow => 'ไม่มาเข้าพัก';

  @override
  String get statusDeclined => 'ถูกปฏิเสธ';

  @override
  String get statusExpired => 'หมดอายุ';

  @override
  String get cancelBooking => 'ยกเลิกการจอง';

  @override
  String cancelConfirm(String refund) {
    return 'ยกเลิกการจองนี้? คุณจะได้รับเงินคืน $refund';
  }

  @override
  String get keepBooking => 'เก็บการจองไว้';

  @override
  String get cancelled => 'ยกเลิกการจองแล้ว';

  @override
  String get invoice => 'ใบแจ้งหนี้';

  @override
  String get paid => 'ชำระแล้ว';

  @override
  String get balance => 'คงเหลือ';

  @override
  String get charges => 'ค่าใช้จ่าย';

  @override
  String get myStay => 'การเข้าพักของฉัน';

  @override
  String get currentStay => 'การเข้าพักของคุณ';

  @override
  String get hotelGuide => 'คู่มือโรงแรม';

  @override
  String get feedback => 'ความคิดเห็น';

  @override
  String get rateStay => 'การเข้าพักของคุณเป็นอย่างไร?';

  @override
  String get comment => 'ความคิดเห็น (ไม่บังคับ)';

  @override
  String get send => 'ส่ง';

  @override
  String get thanksFeedback => 'ขอบคุณสำหรับความคิดเห็น!';

  @override
  String get accept => 'ยอมรับ';

  @override
  String acceptQuote(String amount) {
    return 'ยอมรับใบเสนอราคา $amount';
  }

  @override
  String get acceptance => 'การยอมรับ';

  @override
  String get active => 'ใช้งานอยู่';

  @override
  String get add => 'เพิ่ม';

  @override
  String get addField => 'เพิ่มช่อง';

  @override
  String get addOption => 'เพิ่มตัวเลือก';

  @override
  String get addOutlet => 'เพิ่มจุดบริการ';

  @override
  String get addPhoto => 'เพิ่มรูป';

  @override
  String get addRoom => 'เพิ่มห้อง';

  @override
  String get addStaff => 'เพิ่มพนักงาน';

  @override
  String get addTable => 'เพิ่มโต๊ะ';

  @override
  String get adjustPoints => 'ปรับคะแนน';

  @override
  String get alerts => 'การแจ้งเตือน';

  @override
  String get all => 'ทั้งหมด';

  @override
  String get allergens => 'สารก่อภูมิแพ้';

  @override
  String get allergyNotes => 'อาการแพ้หรือคำแนะนำพิเศษ';

  @override
  String get amount => 'จำนวนเงิน';

  @override
  String get applyLeave => 'ขอลา';

  @override
  String get approve => 'อนุมัติ';

  @override
  String get approved => 'อนุมัติแล้ว';

  @override
  String get arrivals => 'ผู้มาถึง';

  @override
  String get asSoonAsPossible => 'เร็วที่สุด';

  @override
  String get auditLog => 'บันทึกการตรวจสอบ';

  @override
  String get autoAccept => 'ยอมรับอัตโนมัติ';

  @override
  String get basePrice => 'ราคาพื้นฐาน';

  @override
  String get blocks => 'ปิดห้อง';

  @override
  String get body => 'เนื้อหา';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get cancelOrder => 'ยกเลิกออร์เดอร์';

  @override
  String get cancelRequest => 'ยกเลิกคำขอ';

  @override
  String get cancellationPolicy => 'นโยบายการยกเลิก';

  @override
  String get category => 'หมวดหมู่';

  @override
  String get chargeToRoom => 'เรียกเก็บเข้าห้องของฉัน';

  @override
  String get chat => 'แชท';

  @override
  String get chatEmpty => 'ส่งข้อความถึงแผนกต้อนรับ';

  @override
  String get chatWithHotel => 'แชทกับโรงแรม';

  @override
  String get checkInAction => 'เช็กอิน';

  @override
  String get checkOutAction => 'เช็กเอาต์';

  @override
  String get choices => 'ตัวเลือก (คั่นด้วยจุลภาค)';

  @override
  String get closes => 'ปิด';

  @override
  String get codeLabel => 'รหัส';

  @override
  String get collectedToday => 'รับเงินวันนี้';

  @override
  String get content => 'คู่มือและโปรโมชัน';

  @override
  String get copied => 'คัดลอกแล้ว';

  @override
  String get copy => 'คัดลอก';

  @override
  String get copyCsv => 'คัดลอกเป็น CSV';

  @override
  String get dates => 'วันที่';

  @override
  String get decline => 'ปฏิเสธ';

  @override
  String get delete => 'ลบ';

  @override
  String get department => 'แผนก';

  @override
  String get departments => 'แผนก';

  @override
  String get departures => 'ผู้ออก';

  @override
  String get depositPercent => 'มัดจำ %';

  @override
  String get description => 'คำอธิบาย';

  @override
  String get draft => 'ฉบับร่าง';

  @override
  String get earnPer100 => 'คะแนนต่อ ₱100';

  @override
  String earnRate(String points) {
    return 'คุณได้รับ $points คะแนนทุก ₱100';
  }

  @override
  String get earnsPoints => 'ได้รับคะแนนสะสม';

  @override
  String get email => 'อีเมล';

  @override
  String get emptyResets => 'เว้นว่าง = ราคาพื้นฐาน';

  @override
  String get enterCode => 'ใส่รหัส';

  @override
  String get escalate => 'ส่งต่อผู้บังคับบัญชา';

  @override
  String get etaMin => 'พร้อมใน (นาที)';

  @override
  String etaMinutes(String minutes) {
    return 'พร้อมในประมาณ $minutes นาที';
  }

  @override
  String get failedNotifications => 'การแจ้งเตือนที่ล้มเหลว';

  @override
  String get failedRefunds => 'การคืนเงินที่ล้มเหลว';

  @override
  String get fieldKey => 'คีย์ของช่อง';

  @override
  String get formFields => 'ช่องแบบฟอร์มผู้เข้าพัก';

  @override
  String get free => 'ว่าง';

  @override
  String get freeCancelHours => 'ยกเลิกฟรี (ชั่วโมงก่อนเช็กอิน)';

  @override
  String get frontDesk => 'แผนกต้อนรับ';

  @override
  String get history => 'ประวัติ';

  @override
  String get hotelName => 'ชื่อโรงแรม';

  @override
  String get hotelSettings => 'การตั้งค่าโรงแรม';

  @override
  String get inHouse => 'กำลังเข้าพัก';

  @override
  String get inactive => 'ไม่ใช้งาน';

  @override
  String get internalNotes => 'บันทึกภายใน';

  @override
  String get kind => 'ประเภท';

  @override
  String get label => 'ป้ายกำกับ';

  @override
  String get lateRefundPercent => 'คืนเงินหลังพ้นช่วงฟรี %';

  @override
  String get leadTimeMin => 'สั่งล่วงหน้า (นาที)';

  @override
  String get leaveRequests => 'คำขอลา';

  @override
  String get loyalty => 'คะแนนสะสม';

  @override
  String get markNoShow => 'ทำเครื่องหมายไม่มาเข้าพัก';

  @override
  String get maxGuests => 'ผู้เข้าพักสูงสุด';

  @override
  String get members => 'สมาชิก';

  @override
  String get menu => 'เมนู';

  @override
  String get mine => 'ของฉัน';

  @override
  String get missingToPublish => 'ข้อมูลที่ขาดก่อนเผยแพร่';

  @override
  String get myDepartment => 'แผนกของฉัน';

  @override
  String get myLeave => 'การลาของฉัน';

  @override
  String get myRequests => 'คำขอของฉัน';

  @override
  String get name => 'ชื่อ';

  @override
  String get netToday => 'สุทธิวันนี้';

  @override
  String get network => 'เครือข่าย';

  @override
  String get newQr => 'QR โค้ดใหม่';

  @override
  String get newQrWarning => 'รหัสเดิมของโต๊ะนี้จะใช้ไม่ได้อีก';

  @override
  String nextTier(String points, String tier) {
    return 'อีก $points คะแนนถึง $tier';
  }

  @override
  String get nothingHere => 'ยังไม่มีอะไร';

  @override
  String get notFound => 'ไม่พบ';

  @override
  String get occupancyTonight => 'อัตราการเข้าพักคืนนี้';

  @override
  String get ok => 'ตกลง';

  @override
  String get openTasks => 'งานที่ค้างอยู่';

  @override
  String get opens => 'เปิด';

  @override
  String get options => 'ตัวเลือก';

  @override
  String get orderStatus => 'ออร์เดอร์ของคุณ';

  @override
  String get pause => 'หยุดชั่วคราว';

  @override
  String get payAtOutlet => 'ชำระที่เคาน์เตอร์ / จุดบริการ';

  @override
  String get payOnline => 'ชำระออนไลน์';

  @override
  String get paymentMethod => 'การชำระเงิน';

  @override
  String get payments => 'การชำระเงินและการคืนเงิน';

  @override
  String get pendingApproval => 'รอดำเนินการ';

  @override
  String get permissions => 'สิทธิ์';

  @override
  String get photos => 'รูปภาพ';

  @override
  String get points => 'คะแนน';

  @override
  String pointsBalance(String points) {
    return '$points คะแนน';
  }

  @override
  String pointsCost(String points) {
    return '$points คะแนน';
  }

  @override
  String get pointsPlusMinus => 'คะแนน (+ เพิ่ม, − ลด)';

  @override
  String get preferredTime => 'เวลาที่ต้องการ';

  @override
  String get price => 'ราคา';

  @override
  String get priceDelta => 'ราคาเพิ่ม';

  @override
  String get priceModel => 'รูปแบบราคา';

  @override
  String get priceOnQuote => 'ราคาตามใบเสนอ';

  @override
  String pricePerItem(String price) {
    return '$price ต่อชิ้น';
  }

  @override
  String pricePerNight2(String price) {
    return '$price ต่อคืน';
  }

  @override
  String pricePerPerson(String price) {
    return '$price ต่อคน';
  }

  @override
  String get publish => 'เผยแพร่';

  @override
  String get published => 'เผยแพร่แล้ว';

  @override
  String get qrCode => 'QR โค้ด';

  @override
  String get rates => 'อัตราค่าห้อง';

  @override
  String get reason => 'เหตุผล';

  @override
  String get redeem => 'แลก';

  @override
  String get redeemNeedsStay =>
      'ใช้คะแนนได้กับการเข้าพักที่ยืนยันแล้วหรือกำลังเข้าพัก';

  @override
  String get redeemed => 'ใช้กับการเข้าพักของคุณแล้ว';

  @override
  String get refund => 'คืนเงิน';

  @override
  String get refunded => 'คืนเงินแล้ว';

  @override
  String get refundedToday => 'คืนเงินวันนี้';

  @override
  String get reissueWifi => 'ออก Wi-Fi ใหม่';

  @override
  String get rejected => 'ถูกปฏิเสธ';

  @override
  String get removeAccess => 'ยกเลิกสิทธิ์พนักงาน';

  @override
  String get reportOccupancy => 'อัตราการเข้าพัก';

  @override
  String get reportRevenue => 'รายได้';

  @override
  String get reports => 'รายงาน';

  @override
  String get requestStatus => 'สถานะคำขอ';

  @override
  String get requireApproval => 'พนักงานอนุมัติทุกการจองที่ชำระแล้ว';

  @override
  String get reservation => 'การจอง';

  @override
  String get reservations => 'การจอง';

  @override
  String get restaurant => 'ร้านอาหาร';

  @override
  String get restaurantOrders => 'ออร์เดอร์ร้านอาหาร';

  @override
  String reviewOrder(String count, String total) {
    return 'ตรวจสอบออร์เดอร์ ($count) · $total';
  }

  @override
  String get rewards => 'รางวัล';

  @override
  String get role => 'บทบาท';

  @override
  String get roomLabel => 'ห้อง';

  @override
  String get roomTypeLabel => 'ประเภทห้อง';

  @override
  String get roomsAndRates => 'ห้องและราคา';

  @override
  String get save => 'บันทึก';

  @override
  String get saveDraft => 'บันทึกฉบับร่าง';

  @override
  String get saved => 'บันทึกแล้ว';

  @override
  String get scanTable => 'สั่งอาหาร (สแกน QR ที่โต๊ะ)';

  @override
  String get scanTableHint => 'หันกล้องไปที่ QR โค้ดบนโต๊ะของคุณ';

  @override
  String get schedule => 'ตารางเวลา';

  @override
  String get searchGuest => 'ค้นหาด้วยชื่อ อีเมล โทรศัพท์ หรือรหัส';

  @override
  String get sendQuote => 'ส่งใบเสนอราคา';

  @override
  String get sendRequest => 'ส่งคำขอ';

  @override
  String get serviceBuilder => 'ตัวสร้างบริการ';

  @override
  String get services => 'บริการ';

  @override
  String get setRate => 'กำหนดราคาสำหรับวันที่';

  @override
  String get staff => 'พนักงาน';

  @override
  String get staffAndLeave => 'พนักงานและการลา';

  @override
  String get staffApproval => 'พนักงานรับทุกคำขอ';

  @override
  String get status => 'สถานะ';

  @override
  String get statusSteps => 'ขั้นตอนสถานะ';

  @override
  String get submitOrder => 'ส่งออร์เดอร์';

  @override
  String tableLabel(String table) {
    return 'โต๊ะ $table';
  }

  @override
  String get tasks => 'งาน';

  @override
  String get taxIncluded => 'ราคารวมภาษีแล้ว';

  @override
  String get tempPassword => 'รหัสผ่านชั่วคราว';

  @override
  String tier(String tier) {
    return 'ระดับ: $tier';
  }

  @override
  String get title => 'หัวข้อ';

  @override
  String get typeMessage => 'พิมพ์ข้อความ';

  @override
  String get unassigned => 'ยังไม่ได้มอบหมาย';

  @override
  String get unblock => 'เปิดห้อง';

  @override
  String get upcoming => 'กำลังจะมาถึง';

  @override
  String get username => 'ชื่อผู้ใช้';

  @override
  String get validUntil => 'ใช้ได้ถึง';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'โหมด Wi-Fi (portal หรือ psk)';

  @override
  String get wifiPortalHint =>
      'เชื่อมต่อเครือข่าย แล้วหน้าเข้าสู่ระบบจะเปิดขึ้น ใส่ชื่อผู้ใช้และรหัสผ่านด้านบน';

  @override
  String get wifiQrHint => 'สแกนด้วยกล้องเพื่อเชื่อมต่อ';

  @override
  String get wifiSharedPassword => 'รหัสผ่าน Wi-Fi ร่วม (โหมด psk)';

  @override
  String get action => 'การกระทำ';

  @override
  String get entity => 'รายการ';

  @override
  String get dateLabel => 'วันที่';

  @override
  String get actor => 'ผู้ดำเนินการ';

  @override
  String get navOverview => 'ภาพรวม';

  @override
  String get navCatalog => 'แคตตาล็อก';

  @override
  String get navFinance => 'การเงิน';

  @override
  String get navPeople => 'บุคคล';

  @override
  String get navSystem => 'ระบบ';

  @override
  String get details => 'รายละเอียด';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get needsAttention => 'ต้องดำเนินการ';

  @override
  String get allClear => 'ไม่มีอะไรต้องดำเนินการ';

  @override
  String get unreadChats => 'แชทที่ยังไม่อ่าน';

  @override
  String get myTasks => 'งานของฉัน';

  @override
  String get search => 'ค้นหา';

  @override
  String get showMore => 'แสดงเพิ่ม';

  @override
  String get viewLabel => 'มุมมอง';

  @override
  String get sortedAscending => 'เรียงจากน้อยไปมาก';

  @override
  String get sortedDescending => 'เรียงจากมากไปน้อย';

  @override
  String sortBy(String column) {
    return 'เรียงตาม $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown จาก $total';
  }

  @override
  String get note => 'หมายเหตุ';

  @override
  String get rooms => 'ห้อง';

  @override
  String get tables => 'โต๊ะ';

  @override
  String get showDetails => 'แสดงรายละเอียด';

  @override
  String get hideDetails => 'ซ่อนรายละเอียด';

  @override
  String get selectThread => 'เลือกการสนทนา';

  @override
  String get keyboardShortcuts => 'แป้นพิมพ์ลัด';

  @override
  String get goToPage => 'ไปที่หน้า';

  @override
  String get shortcutSearch => 'ค้นหาในหน้านี้';

  @override
  String get shortcutClose => 'ปิดแผงหรือกล่องโต้ตอบ';

  @override
  String get shortcutHelp => 'แสดงแป้นพิมพ์ลัด';

  @override
  String get shortcutSend => 'ส่งข้อความ (Shift+Enter: ขึ้นบรรทัดใหม่)';

  @override
  String get roomBoard => 'ห้องวันนี้';

  @override
  String get roomOccupied => 'มีผู้เข้าพัก';

  @override
  String get roomDeparting => 'เช็กเอาต์วันนี้';

  @override
  String get roomArriving => 'มาถึงวันนี้';

  @override
  String get roomReserved => 'จองแล้ว';

  @override
  String get roomBlocked => 'ปิดอยู่';

  @override
  String freeOf(String free, String total) {
    return 'ว่าง $free จาก $total';
  }

  @override
  String get todaysArrivals => 'ผู้มาถึงวันนี้';

  @override
  String get todaysDepartures => 'ผู้ออกวันนี้';

  @override
  String get guestList => 'รายชื่อผู้เข้าพัก';

  @override
  String get team => 'ทีม';

  @override
  String get lastStay => 'การเข้าพักล่าสุด';

  @override
  String get roleAdmin => 'ผู้ดูแล';

  @override
  String get notifications => 'การแจ้งเตือน';

  @override
  String get notifBooking => 'การจองใหม่';

  @override
  String get notifPending => 'การจองรออนุมัติ';

  @override
  String get notifCancelled => 'การจองถูกยกเลิก';

  @override
  String get notifRequest => 'คำขอบริการใหม่';

  @override
  String get notifOrder => 'ออร์เดอร์อาหารใหม่';

  @override
  String get notifMessage => 'ข้อความใหม่';

  @override
  String staffCancelConfirm(String refund) {
    return 'ยกเลิกการจองนี้? ตามนโยบายการยกเลิก ผู้เข้าพักจะได้รับเงินคืน $refund';
  }

  @override
  String get phone => 'โทรศัพท์';

  @override
  String get appearance => 'รูปลักษณ์';

  @override
  String get themeSystem => 'ตามอุปกรณ์';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String get roomAvailable => 'ว่าง';

  @override
  String get availableOnly => 'เฉพาะห้องว่าง';

  @override
  String get floor => 'ชั้น';

  @override
  String get allRoomTypes => 'ทุกประเภทห้อง';

  @override
  String get guestLabel => 'ผู้เข้าพัก';

  @override
  String get rowNo => 'ลำดับ';

  @override
  String get employeeId => 'รหัสพนักงาน';

  @override
  String get photo => 'รูปภาพ';

  @override
  String get dateFrom => 'ตั้งแต่';

  @override
  String get dateTo => 'ถึง';

  @override
  String get leaveType => 'ประเภทการลา';

  @override
  String get leaveVacation => 'ลาพักร้อน';

  @override
  String get leaveSick => 'ลาป่วย';

  @override
  String get leaveEmergency => 'ลาฉุกเฉิน';

  @override
  String get leaveOther => 'อื่น ๆ';

  @override
  String get submit => 'ส่ง';

  @override
  String get cash => 'เงินสด';

  @override
  String get card => 'บัตร';

  @override
  String get arrival => 'วันมาถึง';

  @override
  String get departure => 'วันออก';

  @override
  String get serviceRequests => 'คำขอบริการ';

  @override
  String get newRequest => 'คำขอใหม่';

  @override
  String get guestBooking => 'การจองของผู้เข้าพัก';

  @override
  String bookRoom(String room) {
    return 'จองห้อง $room';
  }

  @override
  String get bookAndCheckIn => 'จองและเช็กอิน';

  @override
  String get changeBooking => 'เปลี่ยนการจอง';

  @override
  String get recordPayment => 'บันทึกการชำระเงิน';

  @override
  String get emailOrPhoneRequired => 'ใส่อีเมลหรือหมายเลขโทรศัพท์';

  @override
  String get emailLocked =>
      'ไม่สามารถเปลี่ยนอีเมลเข้าสู่ระบบของผู้เข้าพักที่นี่';

  @override
  String get onLeaveToday => 'ลางาน';

  @override
  String leaveUpcoming(String dates) {
    return 'ลา $dates';
  }

  @override
  String get collapseMenu => 'ย่อเมนู';

  @override
  String get expandMenu => 'ขยายเมนู';

  @override
  String get roleRestaurant => 'พนักงานร้านอาหาร';

  @override
  String get next => 'ถัดไป';

  @override
  String get payAtDesk => 'ผู้เข้าพักชำระเงินที่แผนกต้อนรับ';

  @override
  String get notAvailableForDates =>
      'ห้องประเภทนี้เต็มในวันที่เลือก ลองวันอื่นหรือห้องอื่น';

  @override
  String get byType => 'ตามประเภท';

  @override
  String get byFloor => 'ตามชั้น';

  @override
  String floorN(String floor) {
    return 'ชั้น $floor';
  }

  @override
  String get paymentPaid => 'ชำระครบแล้ว';

  @override
  String get paymentDeposit => 'ชำระมัดจำแล้ว';

  @override
  String get paymentPartial => 'ชำระบางส่วน';

  @override
  String get paymentUnpaid => 'ยังไม่ชำระ';

  @override
  String get moreLanguages => 'ภาษาอื่น ๆ';
}
