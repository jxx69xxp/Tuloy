// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get signUp => 'Tạo tài khoản';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String get noAccount => 'Chưa có tài khoản?';

  @override
  String get haveAccount => 'Đã có tài khoản?';

  @override
  String get emailOrPhone => 'Email hoặc số điện thoại';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => 'Ít nhất 8 ký tự';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get required => 'Bắt buộc';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get sendCode => 'Gửi mã';

  @override
  String get codeSent => 'Nếu tài khoản tồn tại, chúng tôi đã gửi mã 6 chữ số.';

  @override
  String get code => 'Mã 6 chữ số';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get resetPassword => 'Đặt lại mật khẩu';

  @override
  String get passwordChanged => 'Đã đổi mật khẩu. Vui lòng đăng nhập.';

  @override
  String get settings => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get guestHome => 'Chào mừng';

  @override
  String get staffHome => 'Nhân viên';

  @override
  String get adminHome => 'Quản trị';

  @override
  String get comingSoon => 'Các tính năng khác sẽ có trong bản phát hành tới.';

  @override
  String get errorGeneric => 'Không thể kết nối máy chủ. Hãy kiểm tra kết nối.';

  @override
  String get cannotReachServer =>
      'Không thể kết nối máy chủ. Hãy kiểm tra kết nối, hoặc nhờ quản trị viên cho phép trang này.';

  @override
  String hello(String name) {
    return 'Xin chào, $name';
  }

  @override
  String get retry => 'Thử lại';

  @override
  String get howCanWeHelp => 'Chúng tôi có thể giúp gì?';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get stays => 'Lưu trú';

  @override
  String get servicesUsed => 'Dịch vụ đã dùng';

  @override
  String get paymentHistory => 'Lịch sử thanh toán';

  @override
  String get cardOrEwallet => 'Thẻ / ví điện tử';

  @override
  String get testPayment => 'Thanh toán thử';

  @override
  String get noneYet => 'Chưa có';

  @override
  String get gettingHere => 'Đường đến đây';

  @override
  String get openInMaps => 'Mở trong Bản đồ';

  @override
  String get airportRoute => 'Đường đến sân bay';

  @override
  String get personalDetails => 'Thông tin cá nhân';

  @override
  String get authTagline => 'Lưu trú và mọi dịch vụ, chỉ một chạm';

  @override
  String get showPassword => 'Hiện mật khẩu';

  @override
  String get hidePassword => 'Ẩn mật khẩu';

  @override
  String get findRoom => 'Tìm phòng';

  @override
  String get adults => 'Người lớn';

  @override
  String get children => 'Trẻ em';

  @override
  String get guests => 'Khách';

  @override
  String nightsCount(String count) {
    return 'Số đêm: $count';
  }

  @override
  String get noRooms =>
      'Không còn phòng trong những ngày này. Hãy thử ngày khác.';

  @override
  String perNight(String price) {
    return '$price / đêm';
  }

  @override
  String roomsLeft(String count) {
    return 'Còn $count';
  }

  @override
  String get totalLabel => 'Tổng cộng';

  @override
  String get amenities => 'Tiện nghi';

  @override
  String get policies => 'Chính sách';

  @override
  String checkInTime(String time) {
    return 'Nhận phòng từ $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Trả phòng trước $time';
  }

  @override
  String get specialRequests => 'Yêu cầu đặc biệt (không bắt buộc)';

  @override
  String get reserve => 'Đặt phòng';

  @override
  String get review => 'Xem lại và thanh toán';

  @override
  String holdTimer(String time) {
    return 'Chúng tôi giữ phòng cho bạn trong $time';
  }

  @override
  String get holdExpired => 'Hết thời gian giữ phòng. Vui lòng tìm lại.';

  @override
  String get serviceCharge => 'Phí dịch vụ';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'Đặt cọc $amount';
  }

  @override
  String payFull(String amount) {
    return 'Thanh toán đủ $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Thanh toán phần còn lại $amount';
  }

  @override
  String get waitingPayment => 'Đang chờ thanh toán…';

  @override
  String get waitingPaymentHint =>
      'Hoàn tất thanh toán trong trình duyệt. Trang này tự cập nhật.';

  @override
  String get openPaymentAgain => 'Mở lại trang thanh toán';

  @override
  String get bookingConfirmed => 'Đã xác nhận đặt phòng!';

  @override
  String bookingCode(String code) {
    return 'Đặt phòng $code';
  }

  @override
  String roomNumber(String room) {
    return 'Phòng $room';
  }

  @override
  String get viewBooking => 'Xem đặt phòng';

  @override
  String get backHome => 'Về trang chủ';

  @override
  String get paymentFailed =>
      'Đặt phòng này không còn được giữ. Nếu bạn đã bị trừ tiền, khoản đó sẽ được hoàn lại.';

  @override
  String get myBookings => 'Đặt phòng của tôi';

  @override
  String get noBookings => 'Chưa có đặt phòng nào.';

  @override
  String get statusHold => 'Chờ thanh toán';

  @override
  String get statusPending => 'Đang chờ';

  @override
  String get statusConfirmed => 'Đã xác nhận';

  @override
  String get statusCheckedIn => 'Đã nhận phòng';

  @override
  String get statusCheckedOut => 'Đã trả phòng';

  @override
  String get statusCancelled => 'Đã hủy';

  @override
  String get statusNoShow => 'Không đến';

  @override
  String get statusDeclined => 'Bị từ chối';

  @override
  String get statusExpired => 'Hết hạn';

  @override
  String get cancelBooking => 'Hủy đặt phòng';

  @override
  String cancelConfirm(String refund) {
    return 'Hủy đặt phòng này? Bạn sẽ được hoàn $refund.';
  }

  @override
  String get keepBooking => 'Giữ đặt phòng';

  @override
  String get cancelled => 'Đã hủy đặt phòng';

  @override
  String get invoice => 'Hóa đơn';

  @override
  String get paid => 'Đã trả';

  @override
  String get balance => 'Còn lại';

  @override
  String get charges => 'Các khoản phí';

  @override
  String get myStay => 'Kỳ lưu trú của tôi';

  @override
  String get currentStay => 'Kỳ lưu trú của bạn';

  @override
  String get hotelGuide => 'Hướng dẫn khách sạn';

  @override
  String get feedback => 'Góp ý';

  @override
  String get rateStay => 'Kỳ lưu trú của bạn thế nào?';

  @override
  String get comment => 'Bình luận (không bắt buộc)';

  @override
  String get send => 'Gửi';

  @override
  String get thanksFeedback => 'Cảm ơn góp ý của bạn!';

  @override
  String get accept => 'Chấp nhận';

  @override
  String acceptQuote(String amount) {
    return 'Chấp nhận báo giá $amount';
  }

  @override
  String get acceptance => 'Chấp nhận';

  @override
  String get active => 'Đang hoạt động';

  @override
  String get add => 'Thêm';

  @override
  String get addField => 'Thêm trường';

  @override
  String get addOption => 'Thêm tùy chọn';

  @override
  String get addOutlet => 'Thêm điểm bán';

  @override
  String get addPhoto => 'Thêm ảnh';

  @override
  String get addRoom => 'Thêm phòng';

  @override
  String get addStaff => 'Thêm nhân viên';

  @override
  String get addTable => 'Thêm bàn';

  @override
  String get adjustPoints => 'Điều chỉnh điểm';

  @override
  String get alerts => 'Cảnh báo';

  @override
  String get all => 'Tất cả';

  @override
  String get allergens => 'Chất gây dị ứng';

  @override
  String get allergyNotes => 'Dị ứng hoặc hướng dẫn đặc biệt';

  @override
  String get amount => 'Số tiền';

  @override
  String get applyLeave => 'Xin nghỉ phép';

  @override
  String get approve => 'Duyệt';

  @override
  String get approved => 'Đã duyệt';

  @override
  String get arrivals => 'Khách đến';

  @override
  String get asSoonAsPossible => 'Càng sớm càng tốt';

  @override
  String get auditLog => 'Nhật ký kiểm tra';

  @override
  String get autoAccept => 'Tự động chấp nhận';

  @override
  String get basePrice => 'Giá cơ bản';

  @override
  String get blocks => 'Khóa phòng';

  @override
  String get body => 'Nội dung';

  @override
  String get cancel => 'Hủy';

  @override
  String get cancelOrder => 'Hủy đơn';

  @override
  String get cancelRequest => 'Hủy yêu cầu';

  @override
  String get cancellationPolicy => 'Chính sách hủy';

  @override
  String get category => 'Danh mục';

  @override
  String get chargeToRoom => 'Tính vào phòng của tôi';

  @override
  String get chat => 'Trò chuyện';

  @override
  String get chatEmpty => 'Nhắn tin cho lễ tân.';

  @override
  String get chatWithHotel => 'Trò chuyện với khách sạn';

  @override
  String get checkInAction => 'Nhận phòng';

  @override
  String get checkOutAction => 'Trả phòng';

  @override
  String get choices => 'Lựa chọn (phân cách bằng dấu phẩy)';

  @override
  String get closes => 'Đóng cửa';

  @override
  String get codeLabel => 'Mã';

  @override
  String get collectedToday => 'Đã thu hôm nay';

  @override
  String get content => 'Hướng dẫn & khuyến mãi';

  @override
  String get copied => 'Đã sao chép';

  @override
  String get copy => 'Sao chép';

  @override
  String get copyCsv => 'Sao chép dạng CSV';

  @override
  String get dates => 'Ngày';

  @override
  String get decline => 'Từ chối';

  @override
  String get delete => 'Xóa';

  @override
  String get department => 'Bộ phận';

  @override
  String get departments => 'Bộ phận';

  @override
  String get departures => 'Khách đi';

  @override
  String get depositPercent => 'Đặt cọc %';

  @override
  String get description => 'Mô tả';

  @override
  String get draft => 'Bản nháp';

  @override
  String get earnPer100 => 'Điểm cho mỗi ₱100';

  @override
  String earnRate(String points) {
    return 'Bạn nhận $points điểm cho mỗi ₱100.';
  }

  @override
  String get earnsPoints => 'Tích điểm thành viên';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'để trống = giá cơ bản';

  @override
  String get enterCode => 'Nhập mã';

  @override
  String get escalate => 'Chuyển cấp trên';

  @override
  String get etaMin => 'Sẵn sàng sau (phút)';

  @override
  String etaMinutes(String minutes) {
    return 'Sẵn sàng sau khoảng $minutes phút';
  }

  @override
  String get failedNotifications => 'Thông báo thất bại';

  @override
  String get failedRefunds => 'Hoàn tiền thất bại';

  @override
  String get fieldKey => 'Khóa trường';

  @override
  String get formFields => 'Trường biểu mẫu cho khách';

  @override
  String get free => 'Trống';

  @override
  String get freeCancelHours => 'Hủy miễn phí (giờ trước khi nhận phòng)';

  @override
  String get frontDesk => 'Lễ tân';

  @override
  String get history => 'Lịch sử';

  @override
  String get hotelName => 'Tên khách sạn';

  @override
  String get hotelSettings => 'Cài đặt khách sạn';

  @override
  String get inHouse => 'Đang lưu trú';

  @override
  String get inactive => 'không hoạt động';

  @override
  String get internalNotes => 'Ghi chú nội bộ';

  @override
  String get kind => 'Loại';

  @override
  String get label => 'Nhãn';

  @override
  String get lateRefundPercent => 'Hoàn tiền sau thời hạn miễn phí %';

  @override
  String get leadTimeMin => 'Đặt trước (phút)';

  @override
  String get leaveRequests => 'Đơn nghỉ phép';

  @override
  String get loyalty => 'Điểm thành viên';

  @override
  String get markNoShow => 'Đánh dấu không đến';

  @override
  String get maxGuests => 'Số khách tối đa';

  @override
  String get members => 'Thành viên';

  @override
  String get menu => 'Thực đơn';

  @override
  String get mine => 'Của tôi';

  @override
  String get missingToPublish => 'Còn thiếu để xuất bản';

  @override
  String get myDepartment => 'Bộ phận của tôi';

  @override
  String get myLeave => 'Nghỉ phép của tôi';

  @override
  String get myRequests => 'Yêu cầu của tôi';

  @override
  String get name => 'Tên';

  @override
  String get netToday => 'Thực thu hôm nay';

  @override
  String get network => 'Mạng';

  @override
  String get newQr => 'Mã QR mới';

  @override
  String get newQrWarning => 'Mã cũ của bàn này sẽ không dùng được nữa.';

  @override
  String nextTier(String points, String tier) {
    return 'Còn $points điểm để lên $tier';
  }

  @override
  String get nothingHere => 'Chưa có gì.';

  @override
  String get notFound => 'Không tìm thấy.';

  @override
  String get occupancyTonight => 'Công suất phòng tối nay';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Việc đang mở';

  @override
  String get opens => 'Mở cửa';

  @override
  String get options => 'Tùy chọn';

  @override
  String get orderStatus => 'Đơn của bạn';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get payAtOutlet => 'Thanh toán tại quầy / điểm bán';

  @override
  String get payOnline => 'Thanh toán trực tuyến';

  @override
  String get paymentMethod => 'Thanh toán';

  @override
  String get payments => 'Thanh toán & hoàn tiền';

  @override
  String get pendingApproval => 'Đang chờ';

  @override
  String get permissions => 'Quyền';

  @override
  String get photos => 'Ảnh';

  @override
  String get points => 'Điểm';

  @override
  String pointsBalance(String points) {
    return '$points điểm';
  }

  @override
  String pointsCost(String points) {
    return '$points điểm';
  }

  @override
  String get pointsPlusMinus => 'Điểm (+ cộng, − trừ)';

  @override
  String get preferredTime => 'Thời gian mong muốn';

  @override
  String get price => 'Giá';

  @override
  String get priceDelta => 'Phụ thu';

  @override
  String get priceModel => 'Cách tính giá';

  @override
  String get priceOnQuote => 'Giá theo báo giá';

  @override
  String pricePerItem(String price) {
    return '$price mỗi món';
  }

  @override
  String pricePerNight2(String price) {
    return '$price mỗi đêm';
  }

  @override
  String pricePerPerson(String price) {
    return '$price mỗi người';
  }

  @override
  String get publish => 'Xuất bản';

  @override
  String get published => 'Đã xuất bản';

  @override
  String get qrCode => 'Mã QR';

  @override
  String get rates => 'Giá phòng';

  @override
  String get reason => 'Lý do';

  @override
  String get redeem => 'Đổi điểm';

  @override
  String get redeemNeedsStay =>
      'Điểm dùng được cho kỳ lưu trú đã xác nhận hoặc đang diễn ra.';

  @override
  String get redeemed => 'Đã áp dụng cho kỳ lưu trú';

  @override
  String get refund => 'Hoàn tiền';

  @override
  String get refunded => 'Đã hoàn tiền';

  @override
  String get refundedToday => 'Đã hoàn hôm nay';

  @override
  String get reissueWifi => 'Cấp lại Wi-Fi';

  @override
  String get rejected => 'Bị từ chối';

  @override
  String get removeAccess => 'Thu hồi quyền nhân viên';

  @override
  String get reportOccupancy => 'Công suất phòng';

  @override
  String get reportRevenue => 'Doanh thu';

  @override
  String get reports => 'Báo cáo';

  @override
  String get requestStatus => 'Trạng thái yêu cầu';

  @override
  String get requireApproval => 'Nhân viên duyệt mọi đặt phòng đã thanh toán';

  @override
  String get reservation => 'Đặt chỗ';

  @override
  String get reservations => 'Đặt chỗ';

  @override
  String get restaurant => 'Nhà hàng';

  @override
  String get restaurantOrders => 'Đơn nhà hàng';

  @override
  String reviewOrder(String count, String total) {
    return 'Xem lại đơn ($count) · $total';
  }

  @override
  String get rewards => 'Phần thưởng';

  @override
  String get role => 'Vai trò';

  @override
  String get roomLabel => 'Phòng';

  @override
  String get roomTypeLabel => 'Loại phòng';

  @override
  String get roomsAndRates => 'Phòng & giá';

  @override
  String get save => 'Lưu';

  @override
  String get saveDraft => 'Lưu nháp';

  @override
  String get saved => 'Đã lưu';

  @override
  String get scanTable => 'Gọi món (quét QR tại bàn)';

  @override
  String get scanTableHint => 'Hướng camera vào mã QR trên bàn.';

  @override
  String get schedule => 'Lịch';

  @override
  String get searchGuest => 'Tìm theo tên, email, điện thoại hoặc mã';

  @override
  String get sendQuote => 'Gửi báo giá';

  @override
  String get sendRequest => 'Gửi yêu cầu';

  @override
  String get serviceBuilder => 'Trình tạo dịch vụ';

  @override
  String get services => 'Dịch vụ';

  @override
  String get setRate => 'Đặt giá cho ngày';

  @override
  String get staff => 'Nhân viên';

  @override
  String get staffAndLeave => 'Nhân viên & nghỉ phép';

  @override
  String get staffApproval => 'Nhân viên chấp nhận từng yêu cầu';

  @override
  String get status => 'Trạng thái';

  @override
  String get statusSteps => 'Các bước trạng thái';

  @override
  String get submitOrder => 'Gửi đơn';

  @override
  String tableLabel(String table) {
    return 'Bàn $table';
  }

  @override
  String get tasks => 'Công việc';

  @override
  String get taxIncluded => 'Giá đã gồm thuế';

  @override
  String get tempPassword => 'Mật khẩu tạm';

  @override
  String tier(String tier) {
    return 'Hạng: $tier';
  }

  @override
  String get title => 'Tiêu đề';

  @override
  String get typeMessage => 'Nhập tin nhắn';

  @override
  String get unassigned => 'Chưa giao';

  @override
  String get unblock => 'Mở khóa';

  @override
  String get upcoming => 'Sắp tới';

  @override
  String get username => 'Tên người dùng';

  @override
  String get validUntil => 'Hiệu lực đến';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Chế độ Wi-Fi (portal hoặc psk)';

  @override
  String get wifiPortalHint =>
      'Kết nối mạng; trang đăng nhập sẽ mở ra. Nhập tên người dùng và mật khẩu ở trên.';

  @override
  String get wifiQrHint => 'Quét bằng camera để kết nối.';

  @override
  String get wifiSharedPassword => 'Mật khẩu Wi-Fi chung (chế độ psk)';

  @override
  String get action => 'Hành động';

  @override
  String get entity => 'Đối tượng';

  @override
  String get dateLabel => 'Ngày';

  @override
  String get actor => 'Người thực hiện';

  @override
  String get navOverview => 'Tổng quan';

  @override
  String get navCatalog => 'Danh mục';

  @override
  String get navFinance => 'Tài chính';

  @override
  String get navPeople => 'Con người';

  @override
  String get navSystem => 'Hệ thống';

  @override
  String get details => 'Chi tiết';

  @override
  String get refresh => 'Làm mới';

  @override
  String get needsAttention => 'Cần xử lý';

  @override
  String get allClear => 'Không có gì cần xử lý';

  @override
  String get unreadChats => 'Tin nhắn chưa đọc';

  @override
  String get myTasks => 'Việc của tôi';

  @override
  String get search => 'Tìm kiếm';

  @override
  String get showMore => 'Xem thêm';

  @override
  String get viewLabel => 'Hiển thị';

  @override
  String get sortedAscending => 'Sắp xếp tăng dần';

  @override
  String get sortedDescending => 'Sắp xếp giảm dần';

  @override
  String sortBy(String column) {
    return 'Sắp xếp theo $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown trên $total';
  }

  @override
  String get note => 'Ghi chú';

  @override
  String get rooms => 'Phòng';

  @override
  String get tables => 'Bàn';

  @override
  String get showDetails => 'Hiện chi tiết';

  @override
  String get hideDetails => 'Ẩn chi tiết';

  @override
  String get selectThread => 'Chọn cuộc trò chuyện';

  @override
  String get keyboardShortcuts => 'Phím tắt';

  @override
  String get goToPage => 'Đi đến trang';

  @override
  String get shortcutSearch => 'Tìm trên trang này';

  @override
  String get shortcutClose => 'Đóng bảng hoặc hộp thoại';

  @override
  String get shortcutHelp => 'Hiện phím tắt';

  @override
  String get shortcutSend => 'Gửi tin nhắn (Shift+Enter: xuống dòng)';

  @override
  String get roomBoard => 'Phòng hôm nay';

  @override
  String get roomOccupied => 'Có khách';

  @override
  String get roomDeparting => 'Trả phòng hôm nay';

  @override
  String get roomArriving => 'Đến hôm nay';

  @override
  String get roomReserved => 'Đã đặt';

  @override
  String get roomBlocked => 'Đã khóa';

  @override
  String freeOf(String free, String total) {
    return '$free / $total còn trống';
  }

  @override
  String get todaysArrivals => 'Khách đến hôm nay';

  @override
  String get todaysDepartures => 'Khách đi hôm nay';

  @override
  String get guestList => 'Danh sách khách';

  @override
  String get team => 'Đội ngũ';

  @override
  String get lastStay => 'Lần lưu trú gần nhất';

  @override
  String get roleAdmin => 'Quản trị';

  @override
  String get notifications => 'Thông báo';

  @override
  String get notifBooking => 'Đặt phòng mới';

  @override
  String get notifPending => 'Đặt phòng cần duyệt';

  @override
  String get notifCancelled => 'Đặt phòng bị hủy';

  @override
  String get notifRequest => 'Yêu cầu dịch vụ mới';

  @override
  String get notifOrder => 'Đơn đồ ăn mới';

  @override
  String get notifMessage => 'Tin nhắn mới';

  @override
  String staffCancelConfirm(String refund) {
    return 'Hủy đặt phòng này? Theo chính sách hủy, khách được hoàn $refund.';
  }

  @override
  String get phone => 'Điện thoại';

  @override
  String get appearance => 'Giao diện';

  @override
  String get themeSystem => 'Theo thiết bị';

  @override
  String get themeLight => 'Sáng';

  @override
  String get themeDark => 'Tối';

  @override
  String get roomAvailable => 'Còn trống';

  @override
  String get availableOnly => 'Chỉ phòng trống';

  @override
  String get floor => 'Tầng';

  @override
  String get allRoomTypes => 'Tất cả loại phòng';

  @override
  String get guestLabel => 'Khách';

  @override
  String get rowNo => 'STT';

  @override
  String get employeeId => 'Mã nhân viên';

  @override
  String get photo => 'Ảnh';

  @override
  String get dateFrom => 'Từ';

  @override
  String get dateTo => 'Đến';

  @override
  String get leaveType => 'Loại nghỉ phép';

  @override
  String get leaveVacation => 'Nghỉ mát';

  @override
  String get leaveSick => 'Ốm';

  @override
  String get leaveEmergency => 'Khẩn cấp';

  @override
  String get leaveOther => 'Khác';

  @override
  String get submit => 'Gửi';

  @override
  String get cash => 'Tiền mặt';

  @override
  String get card => 'Thẻ';

  @override
  String get arrival => 'Ngày đến';

  @override
  String get departure => 'Ngày đi';

  @override
  String get serviceRequests => 'Yêu cầu dịch vụ';

  @override
  String get newRequest => 'Yêu cầu mới';

  @override
  String get guestBooking => 'Đặt phòng của khách';

  @override
  String bookRoom(String room) {
    return 'Đặt phòng $room';
  }

  @override
  String get bookAndCheckIn => 'Đặt và nhận phòng';

  @override
  String get changeBooking => 'Thay đổi đặt phòng';

  @override
  String get recordPayment => 'Ghi nhận thanh toán';

  @override
  String get emailOrPhoneRequired => 'Nhập email hoặc số điện thoại';

  @override
  String get emailLocked => 'Không thể đổi email đăng nhập của khách tại đây.';

  @override
  String get onLeaveToday => 'Đang nghỉ phép';

  @override
  String leaveUpcoming(String dates) {
    return 'Nghỉ phép $dates';
  }

  @override
  String get collapseMenu => 'Thu gọn menu';

  @override
  String get expandMenu => 'Mở rộng menu';

  @override
  String get roleRestaurant => 'Nhân viên nhà hàng';

  @override
  String get next => 'Tiếp';

  @override
  String get payAtDesk => 'Khách thanh toán tại quầy lễ tân.';

  @override
  String get notAvailableForDates =>
      'Loại phòng này đã kín vào những ngày đó. Hãy thử ngày hoặc phòng khác.';

  @override
  String get byType => 'Theo loại';

  @override
  String get byFloor => 'Theo tầng';

  @override
  String floorN(String floor) {
    return 'Tầng $floor';
  }

  @override
  String get paymentPaid => 'Đã thanh toán';

  @override
  String get paymentDeposit => 'Đã đặt cọc';

  @override
  String get paymentPartial => 'Đã trả một phần';

  @override
  String get paymentUnpaid => 'Chưa thanh toán';

  @override
  String get moreLanguages => 'Ngôn ngữ khác';
}
