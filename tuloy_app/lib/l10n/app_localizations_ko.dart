// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => '로그인';

  @override
  String get signUp => '계정 만들기';

  @override
  String get signOut => '로그아웃';

  @override
  String get noAccount => '계정이 없으신가요?';

  @override
  String get haveAccount => '이미 계정이 있으신가요?';

  @override
  String get emailOrPhone => '이메일 또는 전화번호';

  @override
  String get password => '비밀번호';

  @override
  String get passwordHint => '8자 이상';

  @override
  String get fullName => '이름';

  @override
  String get required => '필수';

  @override
  String get forgotPassword => '비밀번호를 잊으셨나요?';

  @override
  String get sendCode => '코드 보내기';

  @override
  String get codeSent => '계정이 있으면 6자리 코드를 보냈습니다.';

  @override
  String get code => '6자리 코드';

  @override
  String get newPassword => '새 비밀번호';

  @override
  String get resetPassword => '비밀번호 재설정';

  @override
  String get passwordChanged => '비밀번호가 변경되었습니다. 로그인해 주세요.';

  @override
  String get settings => '설정';

  @override
  String get language => '언어';

  @override
  String get guestHome => '환영합니다';

  @override
  String get staffHome => '직원';

  @override
  String get adminHome => '관리자';

  @override
  String get comingSoon => '다음 버전에서 더 많은 기능이 추가됩니다.';

  @override
  String get errorGeneric => '서버에 연결할 수 없습니다. 인터넷 연결을 확인하세요.';

  @override
  String get cannotReachServer =>
      '서버에 연결할 수 없습니다. 연결을 확인하거나 관리자에게 이 웹사이트 허용을 요청하세요.';

  @override
  String hello(String name) {
    return '안녕하세요, $name님';
  }

  @override
  String get retry => '다시 시도';

  @override
  String get howCanWeHelp => '무엇을 도와드릴까요?';

  @override
  String get profile => '프로필';

  @override
  String get stays => '숙박';

  @override
  String get servicesUsed => '이용한 서비스';

  @override
  String get paymentHistory => '결제 내역';

  @override
  String get cardOrEwallet => '카드 / 전자지갑';

  @override
  String get testPayment => '테스트 결제';

  @override
  String get noneYet => '아직 없습니다';

  @override
  String get gettingHere => '오시는 길';

  @override
  String get openInMaps => '지도에서 열기';

  @override
  String get airportRoute => '공항 가는 길';

  @override
  String get personalDetails => '개인 정보';

  @override
  String get authTagline => '숙박과 모든 서비스를 한 번에';

  @override
  String get showPassword => '비밀번호 보기';

  @override
  String get hidePassword => '비밀번호 숨기기';

  @override
  String get findRoom => '객실 찾기';

  @override
  String get adults => '성인';

  @override
  String get children => '어린이';

  @override
  String get guests => '투숙객';

  @override
  String nightsCount(String count) {
    return '박 수: $count';
  }

  @override
  String get noRooms => '이 날짜에는 빈 객실이 없습니다. 다른 날짜를 선택하세요.';

  @override
  String perNight(String price) {
    return '$price / 박';
  }

  @override
  String roomsLeft(String count) {
    return '$count개 남음';
  }

  @override
  String get totalLabel => '합계';

  @override
  String get amenities => '편의시설';

  @override
  String get policies => '정책';

  @override
  String checkInTime(String time) {
    return '체크인 $time부터';
  }

  @override
  String checkOutTime(String time) {
    return '체크아웃 $time까지';
  }

  @override
  String get specialRequests => '특별 요청 (선택)';

  @override
  String get reserve => '예약';

  @override
  String get review => '확인 후 결제';

  @override
  String holdTimer(String time) {
    return '이 객실을 $time 동안 보류하고 있습니다';
  }

  @override
  String get holdExpired => '보류 시간이 끝났습니다. 다시 검색해 주세요.';

  @override
  String get serviceCharge => '봉사료';

  @override
  String get vat => '부가가치세';

  @override
  String payDeposit(String amount) {
    return '예약금 결제 $amount';
  }

  @override
  String payFull(String amount) {
    return '전액 결제 $amount';
  }

  @override
  String payBalance(String amount) {
    return '잔액 결제 $amount';
  }

  @override
  String get waitingPayment => '결제를 기다리는 중…';

  @override
  String get waitingPaymentHint => '브라우저에서 결제를 완료하세요. 이 페이지는 자동으로 업데이트됩니다.';

  @override
  String get openPaymentAgain => '결제 페이지 다시 열기';

  @override
  String get bookingConfirmed => '예약이 확정되었습니다!';

  @override
  String bookingCode(String code) {
    return '예약 번호 $code';
  }

  @override
  String roomNumber(String room) {
    return '$room호';
  }

  @override
  String get viewBooking => '예약 보기';

  @override
  String get backHome => '홈으로';

  @override
  String get paymentFailed => '이 예약은 더 이상 보류되지 않습니다. 결제되었다면 환불됩니다.';

  @override
  String get myBookings => '내 예약';

  @override
  String get noBookings => '아직 예약이 없습니다.';

  @override
  String get statusHold => '결제 대기';

  @override
  String get statusPending => '대기 중';

  @override
  String get statusConfirmed => '확정';

  @override
  String get statusCheckedIn => '체크인 완료';

  @override
  String get statusCheckedOut => '체크아웃 완료';

  @override
  String get statusCancelled => '취소됨';

  @override
  String get statusNoShow => '노쇼';

  @override
  String get statusDeclined => '거절됨';

  @override
  String get statusExpired => '만료됨';

  @override
  String get cancelBooking => '예약 취소';

  @override
  String cancelConfirm(String refund) {
    return '이 예약을 취소할까요? $refund이(가) 환불됩니다.';
  }

  @override
  String get keepBooking => '예약 유지';

  @override
  String get cancelled => '예약이 취소되었습니다';

  @override
  String get invoice => '청구서';

  @override
  String get paid => '결제 완료';

  @override
  String get balance => '잔액';

  @override
  String get charges => '요금';

  @override
  String get myStay => '내 숙박';

  @override
  String get currentStay => '현재 숙박';

  @override
  String get hotelGuide => '호텔 안내';

  @override
  String get feedback => '의견';

  @override
  String get rateStay => '숙박은 어떠셨나요?';

  @override
  String get comment => '의견 (선택)';

  @override
  String get send => '보내기';

  @override
  String get thanksFeedback => '의견을 주셔서 감사합니다!';

  @override
  String get accept => '수락';

  @override
  String acceptQuote(String amount) {
    return '견적 수락 $amount';
  }

  @override
  String get acceptance => '접수 방식';

  @override
  String get active => '사용';

  @override
  String get add => '추가';

  @override
  String get addField => '항목 추가';

  @override
  String get addOption => '옵션 추가';

  @override
  String get addOutlet => '매장 추가';

  @override
  String get addPhoto => '사진 추가';

  @override
  String get addRoom => '객실 추가';

  @override
  String get addStaff => '직원 추가';

  @override
  String get addTable => '테이블 추가';

  @override
  String get adjustPoints => '포인트 조정';

  @override
  String get alerts => '알림';

  @override
  String get all => '전체';

  @override
  String get allergens => '알레르기 유발 성분';

  @override
  String get allergyNotes => '알레르기 또는 특별 요청';

  @override
  String get amount => '금액';

  @override
  String get applyLeave => '휴가 신청';

  @override
  String get approve => '승인';

  @override
  String get approved => '승인됨';

  @override
  String get arrivals => '도착';

  @override
  String get asSoonAsPossible => '가능한 빨리';

  @override
  String get auditLog => '감사 기록';

  @override
  String get autoAccept => '자동 수락';

  @override
  String get basePrice => '기본 가격';

  @override
  String get blocks => '객실 차단';

  @override
  String get body => '본문';

  @override
  String get cancel => '취소';

  @override
  String get cancelOrder => '주문 취소';

  @override
  String get cancelRequest => '요청 취소';

  @override
  String get cancellationPolicy => '취소 정책';

  @override
  String get category => '분류';

  @override
  String get chargeToRoom => '객실 요금에 추가';

  @override
  String get chat => '채팅';

  @override
  String get chatEmpty => '프런트에 메시지를 보내세요.';

  @override
  String get chatWithHotel => '호텔과 채팅';

  @override
  String get checkInAction => '체크인';

  @override
  String get checkOutAction => '체크아웃';

  @override
  String get choices => '선택지 (쉼표로 구분)';

  @override
  String get closes => '종료';

  @override
  String get codeLabel => '번호';

  @override
  String get collectedToday => '오늘 수납';

  @override
  String get content => '안내 및 프로모션';

  @override
  String get copied => '복사됨';

  @override
  String get copy => '복사';

  @override
  String get copyCsv => 'CSV로 복사';

  @override
  String get dates => '날짜';

  @override
  String get decline => '거절';

  @override
  String get delete => '삭제';

  @override
  String get department => '부서';

  @override
  String get departments => '부서';

  @override
  String get departures => '출발';

  @override
  String get depositPercent => '예약금 %';

  @override
  String get description => '설명';

  @override
  String get draft => '초안';

  @override
  String get earnPer100 => '₱100당 포인트';

  @override
  String earnRate(String points) {
    return '₱100마다 $points포인트가 적립됩니다.';
  }

  @override
  String get earnsPoints => '포인트 적립';

  @override
  String get email => '이메일';

  @override
  String get emptyResets => '비우면 = 기본 가격';

  @override
  String get enterCode => '코드 입력';

  @override
  String get escalate => '상부 보고';

  @override
  String get etaMin => '준비 시간 (분)';

  @override
  String etaMinutes(String minutes) {
    return '약 $minutes분 후 준비';
  }

  @override
  String get failedNotifications => '실패한 알림';

  @override
  String get failedRefunds => '실패한 환불';

  @override
  String get fieldKey => '항목 키';

  @override
  String get formFields => '고객 입력 항목';

  @override
  String get free => '빈 객실';

  @override
  String get freeCancelHours => '무료 취소 (체크인 전 시간)';

  @override
  String get frontDesk => '프런트';

  @override
  String get history => '기록';

  @override
  String get hotelName => '호텔 이름';

  @override
  String get hotelSettings => '호텔 설정';

  @override
  String get inHouse => '투숙 중';

  @override
  String get inactive => '비활성';

  @override
  String get internalNotes => '내부 메모';

  @override
  String get kind => '유형';

  @override
  String get label => '라벨';

  @override
  String get lateRefundPercent => '무료 기간 이후 환불 %';

  @override
  String get leadTimeMin => '사전 주문 (분)';

  @override
  String get leaveRequests => '휴가 신청';

  @override
  String get loyalty => '멤버십 포인트';

  @override
  String get markNoShow => '노쇼 처리';

  @override
  String get maxGuests => '최대 인원';

  @override
  String get members => '회원';

  @override
  String get menu => '메뉴';

  @override
  String get mine => '내 것';

  @override
  String get missingToPublish => '게시 전 누락 항목';

  @override
  String get myDepartment => '내 부서';

  @override
  String get myLeave => '내 휴가';

  @override
  String get myRequests => '내 요청';

  @override
  String get name => '이름';

  @override
  String get netToday => '오늘 순액';

  @override
  String get network => '네트워크';

  @override
  String get newQr => '새 QR 코드';

  @override
  String get newQrWarning => '이 테이블의 이전 코드는 더 이상 작동하지 않습니다.';

  @override
  String nextTier(String points, String tier) {
    return '$tier까지 $points포인트 남음';
  }

  @override
  String get nothingHere => '아직 없습니다.';

  @override
  String get notFound => '찾을 수 없습니다.';

  @override
  String get occupancyTonight => '오늘 밤 점유율';

  @override
  String get ok => '확인';

  @override
  String get openTasks => '진행 중인 작업';

  @override
  String get opens => '시작';

  @override
  String get options => '옵션';

  @override
  String get orderStatus => '주문 내역';

  @override
  String get pause => '일시 중지';

  @override
  String get payAtOutlet => '테이블 / 매장에서 결제';

  @override
  String get payOnline => '온라인 결제';

  @override
  String get paymentMethod => '결제';

  @override
  String get payments => '결제 및 환불';

  @override
  String get pendingApproval => '승인 대기';

  @override
  String get permissions => '권한';

  @override
  String get photos => '사진';

  @override
  String get points => '포인트';

  @override
  String pointsBalance(String points) {
    return '$points 포인트';
  }

  @override
  String pointsCost(String points) {
    return '$points 포인트';
  }

  @override
  String get pointsPlusMinus => '포인트 (+ 추가, − 차감)';

  @override
  String get preferredTime => '희망 시간';

  @override
  String get price => '가격';

  @override
  String get priceDelta => '추가 요금';

  @override
  String get priceModel => '요금 방식';

  @override
  String get priceOnQuote => '가격 문의';

  @override
  String pricePerItem(String price) {
    return '개당 $price';
  }

  @override
  String pricePerNight2(String price) {
    return '1박 $price';
  }

  @override
  String pricePerPerson(String price) {
    return '1인 $price';
  }

  @override
  String get publish => '게시';

  @override
  String get published => '게시됨';

  @override
  String get qrCode => 'QR 코드';

  @override
  String get rates => '요금';

  @override
  String get reason => '사유';

  @override
  String get redeem => '사용';

  @override
  String get redeemNeedsStay => '포인트는 확정되었거나 진행 중인 숙박에 사용할 수 있습니다.';

  @override
  String get redeemed => '숙박에 적용되었습니다';

  @override
  String get refund => '환불';

  @override
  String get refunded => '환불됨';

  @override
  String get refundedToday => '오늘 환불';

  @override
  String get reissueWifi => 'Wi-Fi 재발급';

  @override
  String get rejected => '반려됨';

  @override
  String get removeAccess => '직원 권한 삭제';

  @override
  String get reportOccupancy => '점유율';

  @override
  String get reportRevenue => '매출';

  @override
  String get reports => '보고서';

  @override
  String get requestStatus => '요청 상태';

  @override
  String get requireApproval => '결제된 예약을 직원이 승인';

  @override
  String get reservation => '예약';

  @override
  String get reservations => '예약';

  @override
  String get restaurant => '레스토랑';

  @override
  String get restaurantOrders => '레스토랑 주문';

  @override
  String reviewOrder(String count, String total) {
    return '주문 확인 ($count) · $total';
  }

  @override
  String get rewards => '리워드';

  @override
  String get role => '역할';

  @override
  String get roomLabel => '객실';

  @override
  String get roomTypeLabel => '객실 유형';

  @override
  String get roomsAndRates => '객실 및 요금';

  @override
  String get save => '저장';

  @override
  String get saveDraft => '초안 저장';

  @override
  String get saved => '저장되었습니다';

  @override
  String get scanTable => '음식 주문 (테이블 QR 스캔)';

  @override
  String get scanTableHint => '테이블의 QR 코드에 카메라를 맞추세요.';

  @override
  String get schedule => '일정';

  @override
  String get searchGuest => '이름, 이메일, 전화번호 또는 번호 검색';

  @override
  String get sendQuote => '견적 보내기';

  @override
  String get sendRequest => '요청 보내기';

  @override
  String get serviceBuilder => '서비스 편집기';

  @override
  String get services => '서비스';

  @override
  String get setRate => '날짜별 가격 설정';

  @override
  String get staff => '직원';

  @override
  String get staffAndLeave => '직원 및 휴가';

  @override
  String get staffApproval => '직원이 요청마다 접수';

  @override
  String get status => '상태';

  @override
  String get statusSteps => '상태 단계';

  @override
  String get submitOrder => '주문하기';

  @override
  String tableLabel(String table) {
    return '테이블 $table';
  }

  @override
  String get tasks => '작업';

  @override
  String get taxIncluded => '세금 포함 가격';

  @override
  String get tempPassword => '임시 비밀번호';

  @override
  String tier(String tier) {
    return '등급: $tier';
  }

  @override
  String get title => '제목';

  @override
  String get typeMessage => '메시지 입력';

  @override
  String get unassigned => '미배정';

  @override
  String get unblock => '차단 해제';

  @override
  String get upcoming => '예정';

  @override
  String get username => '사용자 이름';

  @override
  String get validUntil => '유효 기간';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi 모드 (portal 또는 psk)';

  @override
  String get wifiPortalHint =>
      '네트워크에 연결하면 로그인 페이지가 열립니다. 위의 사용자 이름과 비밀번호를 입력하세요.';

  @override
  String get wifiQrHint => '카메라로 스캔하면 연결됩니다.';

  @override
  String get wifiSharedPassword => '공용 Wi-Fi 비밀번호 (psk 모드)';

  @override
  String get action => '작업';

  @override
  String get entity => '대상';

  @override
  String get dateLabel => '날짜';

  @override
  String get actor => '수행자';

  @override
  String get navOverview => '개요';

  @override
  String get navCatalog => '카탈로그';

  @override
  String get navFinance => '재무';

  @override
  String get navPeople => '인원';

  @override
  String get navSystem => '시스템';

  @override
  String get details => '상세';

  @override
  String get refresh => '새로고침';

  @override
  String get needsAttention => '처리 필요';

  @override
  String get allClear => '처리할 항목이 없습니다';

  @override
  String get unreadChats => '읽지 않은 채팅';

  @override
  String get myTasks => '내 작업';

  @override
  String get search => '검색';

  @override
  String get showMore => '더 보기';

  @override
  String get viewLabel => '보기';

  @override
  String get sortedAscending => '오름차순';

  @override
  String get sortedDescending => '내림차순';

  @override
  String sortBy(String column) {
    return '$column 기준 정렬';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown / $total';
  }

  @override
  String get note => '메모';

  @override
  String get rooms => '객실';

  @override
  String get tables => '테이블';

  @override
  String get showDetails => '상세 보기';

  @override
  String get hideDetails => '상세 숨기기';

  @override
  String get selectThread => '대화를 선택하세요';

  @override
  String get keyboardShortcuts => '키보드 단축키';

  @override
  String get goToPage => '페이지로 이동';

  @override
  String get shortcutSearch => '이 페이지 검색';

  @override
  String get shortcutClose => '패널 또는 대화상자 닫기';

  @override
  String get shortcutHelp => '키보드 단축키 보기';

  @override
  String get shortcutSend => '메시지 보내기 (Shift+Enter: 줄바꿈)';

  @override
  String get roomBoard => '오늘의 객실';

  @override
  String get roomOccupied => '투숙 중';

  @override
  String get roomDeparting => '오늘 체크아웃';

  @override
  String get roomArriving => '오늘 도착';

  @override
  String get roomReserved => '예약됨';

  @override
  String get roomBlocked => '사용 불가';

  @override
  String freeOf(String free, String total) {
    return '$total개 중 $free개 이용 가능';
  }

  @override
  String get todaysArrivals => '오늘 도착';

  @override
  String get todaysDepartures => '오늘 출발';

  @override
  String get guestList => '고객 목록';

  @override
  String get team => '팀';

  @override
  String get lastStay => '최근 숙박';

  @override
  String get roleAdmin => '관리자';

  @override
  String get notifications => '알림';

  @override
  String get notifBooking => '새 예약';

  @override
  String get notifPending => '승인이 필요한 예약';

  @override
  String get notifCancelled => '예약 취소됨';

  @override
  String get notifRequest => '새 서비스 요청';

  @override
  String get notifOrder => '새 음식 주문';

  @override
  String get notifMessage => '새 메시지';

  @override
  String staffCancelConfirm(String refund) {
    return '이 예약을 취소할까요? 취소 정책에 따라 고객에게 $refund이(가) 환불됩니다.';
  }

  @override
  String get phone => '전화';

  @override
  String get appearance => '화면 모드';

  @override
  String get themeSystem => '기기 설정 따르기';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get roomAvailable => '이용 가능';

  @override
  String get availableOnly => '이용 가능만';

  @override
  String get floor => '층';

  @override
  String get allRoomTypes => '모든 객실 유형';

  @override
  String get guestLabel => '고객';

  @override
  String get rowNo => '번호';

  @override
  String get employeeId => '사번';

  @override
  String get photo => '사진';

  @override
  String get dateFrom => '시작';

  @override
  String get dateTo => '종료';

  @override
  String get leaveType => '휴가 유형';

  @override
  String get leaveVacation => '연차';

  @override
  String get leaveSick => '병가';

  @override
  String get leaveEmergency => '긴급';

  @override
  String get leaveOther => '기타';

  @override
  String get submit => '제출';

  @override
  String get cash => '현금';

  @override
  String get card => '카드';

  @override
  String get arrival => '도착';

  @override
  String get departure => '출발';

  @override
  String get serviceRequests => '서비스 요청';

  @override
  String get newRequest => '새 요청';

  @override
  String get guestBooking => '고객의 예약';

  @override
  String bookRoom(String room) {
    return '$room호 예약';
  }

  @override
  String get bookAndCheckIn => '예약 후 체크인';

  @override
  String get changeBooking => '예약 변경';

  @override
  String get recordPayment => '결제 기록';

  @override
  String get emailOrPhoneRequired => '이메일 또는 전화번호를 입력하세요';

  @override
  String get emailLocked => '고객의 로그인 이메일은 여기에서 변경할 수 없습니다.';

  @override
  String get onLeaveToday => '휴가 중';

  @override
  String leaveUpcoming(String dates) {
    return '휴가 $dates';
  }

  @override
  String get collapseMenu => '메뉴 접기';

  @override
  String get expandMenu => '메뉴 펼치기';

  @override
  String get roleRestaurant => '레스토랑 직원';

  @override
  String get next => '다음';

  @override
  String get payAtDesk => '고객은 프런트에서 결제합니다.';

  @override
  String get notAvailableForDates => '이 객실 유형은 해당 날짜에 만실입니다. 다른 날짜나 객실을 선택하세요.';

  @override
  String get byType => '유형별';

  @override
  String get byFloor => '층별';

  @override
  String floorN(String floor) {
    return '$floor층';
  }

  @override
  String get paymentPaid => '결제 완료';

  @override
  String get paymentDeposit => '예약금 결제';

  @override
  String get paymentPartial => '일부 결제';

  @override
  String get paymentUnpaid => '미결제';

  @override
  String get moreLanguages => '다른 언어';
}
