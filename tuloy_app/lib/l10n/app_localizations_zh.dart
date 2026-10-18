// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => '登录';

  @override
  String get signUp => '创建账户';

  @override
  String get signOut => '退出登录';

  @override
  String get noAccount => '还没有账户？';

  @override
  String get haveAccount => '已有账户？';

  @override
  String get emailOrPhone => '邮箱或手机号';

  @override
  String get password => '密码';

  @override
  String get passwordHint => '至少 8 个字符';

  @override
  String get fullName => '姓名';

  @override
  String get required => '必填';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get sendCode => '发送验证码';

  @override
  String get codeSent => '如果账户存在，我们已发送 6 位验证码。';

  @override
  String get code => '6 位验证码';

  @override
  String get newPassword => '新密码';

  @override
  String get resetPassword => '重置密码';

  @override
  String get passwordChanged => '密码已更改，请重新登录。';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get guestHome => '欢迎';

  @override
  String get staffHome => '员工';

  @override
  String get adminHome => '管理员';

  @override
  String get comingSoon => '更多功能将在下个版本推出。';

  @override
  String get errorGeneric => '无法连接服务器，请检查网络。';

  @override
  String get cannotReachServer => '无法连接服务器。请检查网络，或请管理员允许此网站。';

  @override
  String hello(String name) {
    return '你好，$name';
  }

  @override
  String get retry => '重试';

  @override
  String get howCanWeHelp => '需要什么帮助？';

  @override
  String get profile => '个人资料';

  @override
  String get stays => '入住次数';

  @override
  String get servicesUsed => '已用服务';

  @override
  String get paymentHistory => '付款记录';

  @override
  String get cardOrEwallet => '银行卡 / 电子钱包';

  @override
  String get testPayment => '测试付款';

  @override
  String get noneYet => '暂无内容';

  @override
  String get gettingHere => '交通指南';

  @override
  String get openInMaps => '在地图中打开';

  @override
  String get airportRoute => '前往机场的路线';

  @override
  String get personalDetails => '个人信息';

  @override
  String get authTagline => '您的住宿与所有服务，一触即达';

  @override
  String get showPassword => '显示密码';

  @override
  String get hidePassword => '隐藏密码';

  @override
  String get findRoom => '查找房间';

  @override
  String get adults => '成人';

  @override
  String get children => '儿童';

  @override
  String get guests => '住客';

  @override
  String nightsCount(String count) {
    return '晚数：$count';
  }

  @override
  String get noRooms => '这些日期没有空房，请尝试其他日期。';

  @override
  String perNight(String price) {
    return '$price / 晚';
  }

  @override
  String roomsLeft(String count) {
    return '仅剩 $count 间';
  }

  @override
  String get totalLabel => '总计';

  @override
  String get amenities => '设施';

  @override
  String get policies => '政策';

  @override
  String checkInTime(String time) {
    return '$time 起可入住';
  }

  @override
  String checkOutTime(String time) {
    return '请于 $time 前退房';
  }

  @override
  String get specialRequests => '特殊要求（选填）';

  @override
  String get reserve => '预订';

  @override
  String get review => '确认并付款';

  @override
  String holdTimer(String time) {
    return '我们为您保留此房间 $time';
  }

  @override
  String get holdExpired => '保留已过期，请重新搜索。';

  @override
  String get serviceCharge => '服务费';

  @override
  String get vat => '增值税';

  @override
  String payDeposit(String amount) {
    return '支付订金 $amount';
  }

  @override
  String payFull(String amount) {
    return '全额支付 $amount';
  }

  @override
  String payBalance(String amount) {
    return '支付余款 $amount';
  }

  @override
  String get waitingPayment => '等待付款…';

  @override
  String get waitingPaymentHint => '请在浏览器中完成付款，此页面会自动更新。';

  @override
  String get openPaymentAgain => '再次打开付款页面';

  @override
  String get bookingConfirmed => '预订已确认！';

  @override
  String bookingCode(String code) {
    return '预订号 $code';
  }

  @override
  String roomNumber(String room) {
    return '房间 $room';
  }

  @override
  String get viewBooking => '查看预订';

  @override
  String get backHome => '返回首页';

  @override
  String get paymentFailed => '此预订已不再保留。如已扣款，将予以退款。';

  @override
  String get myBookings => '我的预订';

  @override
  String get noBookings => '暂无预订。';

  @override
  String get statusHold => '等待付款';

  @override
  String get statusPending => '待处理';

  @override
  String get statusConfirmed => '已确认';

  @override
  String get statusCheckedIn => '已入住';

  @override
  String get statusCheckedOut => '已退房';

  @override
  String get statusCancelled => '已取消';

  @override
  String get statusNoShow => '未到店';

  @override
  String get statusDeclined => '已拒绝';

  @override
  String get statusExpired => '已过期';

  @override
  String get cancelBooking => '取消预订';

  @override
  String cancelConfirm(String refund) {
    return '取消此预订？您将获得 $refund 退款。';
  }

  @override
  String get keepBooking => '保留预订';

  @override
  String get cancelled => '预订已取消';

  @override
  String get invoice => '账单';

  @override
  String get paid => '已付';

  @override
  String get balance => '余额';

  @override
  String get charges => '费用';

  @override
  String get myStay => '我的住宿';

  @override
  String get currentStay => '您的住宿';

  @override
  String get hotelGuide => '酒店指南';

  @override
  String get feedback => '反馈';

  @override
  String get rateStay => '您的住宿体验如何？';

  @override
  String get comment => '评论（选填）';

  @override
  String get send => '发送';

  @override
  String get thanksFeedback => '感谢您的反馈！';

  @override
  String get accept => '接受';

  @override
  String acceptQuote(String amount) {
    return '接受报价 $amount';
  }

  @override
  String get acceptance => '受理方式';

  @override
  String get active => '启用';

  @override
  String get add => '添加';

  @override
  String get addField => '添加字段';

  @override
  String get addOption => '添加选项';

  @override
  String get addOutlet => '添加餐厅';

  @override
  String get addPhoto => '添加照片';

  @override
  String get addRoom => '添加房间';

  @override
  String get addStaff => '添加员工';

  @override
  String get addTable => '添加餐桌';

  @override
  String get adjustPoints => '调整积分';

  @override
  String get alerts => '提醒';

  @override
  String get all => '全部';

  @override
  String get allergens => '过敏原';

  @override
  String get allergyNotes => '过敏或特殊说明';

  @override
  String get amount => '金额';

  @override
  String get applyLeave => '申请休假';

  @override
  String get approve => '批准';

  @override
  String get approved => '已批准';

  @override
  String get arrivals => '抵达';

  @override
  String get asSoonAsPossible => '尽快';

  @override
  String get auditLog => '审计日志';

  @override
  String get autoAccept => '自动接受';

  @override
  String get basePrice => '基础价格';

  @override
  String get blocks => '房间封锁';

  @override
  String get body => '正文';

  @override
  String get cancel => '取消';

  @override
  String get cancelOrder => '取消订单';

  @override
  String get cancelRequest => '取消请求';

  @override
  String get cancellationPolicy => '取消政策';

  @override
  String get category => '类别';

  @override
  String get chargeToRoom => '记入我的房账';

  @override
  String get chat => '聊天';

  @override
  String get chatEmpty => '给前台发送消息。';

  @override
  String get chatWithHotel => '与酒店聊天';

  @override
  String get checkInAction => '办理入住';

  @override
  String get checkOutAction => '办理退房';

  @override
  String get choices => '选项（用逗号分隔）';

  @override
  String get closes => '结束时间';

  @override
  String get codeLabel => '编号';

  @override
  String get collectedToday => '今日收款';

  @override
  String get content => '指南与优惠';

  @override
  String get copied => '已复制';

  @override
  String get copy => '复制';

  @override
  String get copyCsv => '复制为 CSV';

  @override
  String get dates => '日期';

  @override
  String get decline => '拒绝';

  @override
  String get delete => '删除';

  @override
  String get department => '部门';

  @override
  String get departments => '部门';

  @override
  String get departures => '离店';

  @override
  String get depositPercent => '订金 %';

  @override
  String get description => '描述';

  @override
  String get draft => '草稿';

  @override
  String get earnPer100 => '每 ₱100 积分';

  @override
  String earnRate(String points) {
    return '每消费 ₱100 可获得 $points 积分。';
  }

  @override
  String get earnsPoints => '可获得积分';

  @override
  String get email => '邮箱';

  @override
  String get emptyResets => '留空 = 基础价格';

  @override
  String get enterCode => '输入验证码';

  @override
  String get escalate => '上报';

  @override
  String get etaMin => '准备时间（分钟）';

  @override
  String etaMinutes(String minutes) {
    return '约 $minutes 分钟后就绪';
  }

  @override
  String get failedNotifications => '发送失败的通知';

  @override
  String get failedRefunds => '失败的退款';

  @override
  String get fieldKey => '字段键';

  @override
  String get formFields => '住客表单字段';

  @override
  String get free => '空闲';

  @override
  String get freeCancelHours => '免费取消（入住前小时数）';

  @override
  String get frontDesk => '前台';

  @override
  String get history => '记录';

  @override
  String get hotelName => '酒店名称';

  @override
  String get hotelSettings => '酒店设置';

  @override
  String get inHouse => '在住';

  @override
  String get inactive => '未启用';

  @override
  String get internalNotes => '内部备注';

  @override
  String get kind => '类型';

  @override
  String get label => '标签';

  @override
  String get lateRefundPercent => '免费期后退款 %';

  @override
  String get leadTimeMin => '提前预订（分钟）';

  @override
  String get leaveRequests => '休假申请';

  @override
  String get loyalty => '会员积分';

  @override
  String get markNoShow => '标记为未到店';

  @override
  String get maxGuests => '最多住客';

  @override
  String get members => '会员';

  @override
  String get menu => '菜单';

  @override
  String get mine => '我的';

  @override
  String get missingToPublish => '发布前缺少';

  @override
  String get myDepartment => '我的部门';

  @override
  String get myLeave => '我的休假';

  @override
  String get myRequests => '我的请求';

  @override
  String get name => '姓名';

  @override
  String get netToday => '今日净收入';

  @override
  String get network => '网络';

  @override
  String get newQr => '新二维码';

  @override
  String get newQrWarning => '此餐桌的旧二维码将失效。';

  @override
  String nextTier(String points, String tier) {
    return '再获得 $points 积分升至 $tier';
  }

  @override
  String get nothingHere => '暂无内容。';

  @override
  String get notFound => '未找到。';

  @override
  String get occupancyTonight => '今晚入住率';

  @override
  String get ok => '确定';

  @override
  String get openTasks => '未完成任务';

  @override
  String get opens => '开始时间';

  @override
  String get options => '选项';

  @override
  String get orderStatus => '您的订单';

  @override
  String get pause => '暂停';

  @override
  String get payAtOutlet => '在餐桌 / 餐厅付款';

  @override
  String get payOnline => '在线付款';

  @override
  String get paymentMethod => '付款';

  @override
  String get payments => '付款与退款';

  @override
  String get pendingApproval => '待审批';

  @override
  String get permissions => '权限';

  @override
  String get photos => '照片';

  @override
  String get points => '积分';

  @override
  String pointsBalance(String points) {
    return '$points 积分';
  }

  @override
  String pointsCost(String points) {
    return '$points 积分';
  }

  @override
  String get pointsPlusMinus => '积分（+ 增加，− 扣除）';

  @override
  String get preferredTime => '期望时间';

  @override
  String get price => '价格';

  @override
  String get priceDelta => '加价';

  @override
  String get priceModel => '计价方式';

  @override
  String get priceOnQuote => '价格面议';

  @override
  String pricePerItem(String price) {
    return '每件 $price';
  }

  @override
  String pricePerNight2(String price) {
    return '每晚 $price';
  }

  @override
  String pricePerPerson(String price) {
    return '每人 $price';
  }

  @override
  String get publish => '发布';

  @override
  String get published => '已发布';

  @override
  String get qrCode => '二维码';

  @override
  String get rates => '房价';

  @override
  String get reason => '原因';

  @override
  String get redeem => '兑换';

  @override
  String get redeemNeedsStay => '积分可用于已确认或当前的住宿。';

  @override
  String get redeemed => '已用于您的住宿';

  @override
  String get refund => '退款';

  @override
  String get refunded => '已退款';

  @override
  String get refundedToday => '今日退款';

  @override
  String get reissueWifi => '重新发放 Wi-Fi';

  @override
  String get rejected => '已拒绝';

  @override
  String get removeAccess => '移除员工权限';

  @override
  String get reportOccupancy => '入住率';

  @override
  String get reportRevenue => '收入';

  @override
  String get reports => '报表';

  @override
  String get requestStatus => '请求状态';

  @override
  String get requireApproval => '员工需审批每笔已付款预订';

  @override
  String get reservation => '预订';

  @override
  String get reservations => '预订';

  @override
  String get restaurant => '餐厅';

  @override
  String get restaurantOrders => '餐厅订单';

  @override
  String reviewOrder(String count, String total) {
    return '查看订单（$count）· $total';
  }

  @override
  String get rewards => '奖励';

  @override
  String get role => '角色';

  @override
  String get roomLabel => '房间';

  @override
  String get roomTypeLabel => '房型';

  @override
  String get roomsAndRates => '房间与房价';

  @override
  String get save => '保存';

  @override
  String get saveDraft => '保存草稿';

  @override
  String get saved => '已保存';

  @override
  String get scanTable => '点餐（扫描桌上二维码）';

  @override
  String get scanTableHint => '将相机对准您桌上的二维码。';

  @override
  String get schedule => '时间安排';

  @override
  String get searchGuest => '搜索姓名、邮箱、电话或预订号';

  @override
  String get sendQuote => '发送报价';

  @override
  String get sendRequest => '发送请求';

  @override
  String get serviceBuilder => '服务编辑器';

  @override
  String get services => '服务';

  @override
  String get setRate => '设置日期价格';

  @override
  String get staff => '员工';

  @override
  String get staffAndLeave => '员工与休假';

  @override
  String get staffApproval => '员工需受理每个请求';

  @override
  String get status => '状态';

  @override
  String get statusSteps => '状态步骤';

  @override
  String get submitOrder => '提交订单';

  @override
  String tableLabel(String table) {
    return '餐桌 $table';
  }

  @override
  String get tasks => '任务';

  @override
  String get taxIncluded => '价格含税';

  @override
  String get tempPassword => '临时密码';

  @override
  String tier(String tier) {
    return '等级：$tier';
  }

  @override
  String get title => '标题';

  @override
  String get typeMessage => '输入消息';

  @override
  String get unassigned => '未分配';

  @override
  String get unblock => '解除封锁';

  @override
  String get upcoming => '即将到来';

  @override
  String get username => '用户名';

  @override
  String get validUntil => '有效期至';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi 模式（portal 或 psk）';

  @override
  String get wifiPortalHint => '连接网络后会打开登录页面，请输入上面的用户名和密码。';

  @override
  String get wifiQrHint => '用相机扫描即可连接。';

  @override
  String get wifiSharedPassword => '共享 Wi-Fi 密码（psk 模式）';

  @override
  String get action => '操作';

  @override
  String get entity => '对象';

  @override
  String get dateLabel => '日期';

  @override
  String get actor => '操作人';

  @override
  String get navOverview => '概览';

  @override
  String get navCatalog => '目录';

  @override
  String get navFinance => '财务';

  @override
  String get navPeople => '人员';

  @override
  String get navSystem => '系统';

  @override
  String get details => '详情';

  @override
  String get refresh => '刷新';

  @override
  String get needsAttention => '需要处理';

  @override
  String get allClear => '没有需要处理的事项';

  @override
  String get unreadChats => '未读聊天';

  @override
  String get myTasks => '我的任务';

  @override
  String get search => '搜索';

  @override
  String get showMore => '显示更多';

  @override
  String get viewLabel => '视图';

  @override
  String get sortedAscending => '升序';

  @override
  String get sortedDescending => '降序';

  @override
  String sortBy(String column) {
    return '按 $column 排序';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown / $total';
  }

  @override
  String get note => '备注';

  @override
  String get rooms => '房间';

  @override
  String get tables => '餐桌';

  @override
  String get showDetails => '显示详情';

  @override
  String get hideDetails => '隐藏详情';

  @override
  String get selectThread => '选择一个对话';

  @override
  String get keyboardShortcuts => '键盘快捷键';

  @override
  String get goToPage => '前往页面';

  @override
  String get shortcutSearch => '搜索此页面';

  @override
  String get shortcutClose => '关闭面板或对话框';

  @override
  String get shortcutHelp => '显示键盘快捷键';

  @override
  String get shortcutSend => '发送消息（Shift+Enter 换行）';

  @override
  String get roomBoard => '今日房态';

  @override
  String get roomOccupied => '已入住';

  @override
  String get roomDeparting => '今日退房';

  @override
  String get roomArriving => '今日抵达';

  @override
  String get roomReserved => '已预订';

  @override
  String get roomBlocked => '已封锁';

  @override
  String freeOf(String free, String total) {
    return '$total 间中 $free 间可用';
  }

  @override
  String get todaysArrivals => '今日抵达';

  @override
  String get todaysDepartures => '今日离店';

  @override
  String get guestList => '住客列表';

  @override
  String get team => '团队';

  @override
  String get lastStay => '最近住宿';

  @override
  String get roleAdmin => '管理员';

  @override
  String get notifications => '通知';

  @override
  String get notifBooking => '新预订';

  @override
  String get notifPending => '预订待审批';

  @override
  String get notifCancelled => '预订已取消';

  @override
  String get notifRequest => '新服务请求';

  @override
  String get notifOrder => '新点餐订单';

  @override
  String get notifMessage => '新消息';

  @override
  String staffCancelConfirm(String refund) {
    return '取消此预订？根据取消政策，住客将获得 $refund 退款。';
  }

  @override
  String get phone => '电话';

  @override
  String get appearance => '外观';

  @override
  String get themeSystem => '跟随设备';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get roomAvailable => '可用';

  @override
  String get availableOnly => '仅显示可用';

  @override
  String get floor => '楼层';

  @override
  String get allRoomTypes => '所有房型';

  @override
  String get guestLabel => '住客';

  @override
  String get rowNo => '序号';

  @override
  String get employeeId => '员工编号';

  @override
  String get photo => '照片';

  @override
  String get dateFrom => '从';

  @override
  String get dateTo => '至';

  @override
  String get leaveType => '休假类型';

  @override
  String get leaveVacation => '年假';

  @override
  String get leaveSick => '病假';

  @override
  String get leaveEmergency => '紧急事假';

  @override
  String get leaveOther => '其他';

  @override
  String get submit => '提交';

  @override
  String get cash => '现金';

  @override
  String get card => '银行卡';

  @override
  String get arrival => '抵达';

  @override
  String get departure => '离店';

  @override
  String get serviceRequests => '服务请求';

  @override
  String get newRequest => '新请求';

  @override
  String get guestBooking => '住客的预订';

  @override
  String bookRoom(String room) {
    return '预订房间 $room';
  }

  @override
  String get bookAndCheckIn => '预订并入住';

  @override
  String get changeBooking => '修改预订';

  @override
  String get recordPayment => '记录付款';

  @override
  String get emailOrPhoneRequired => '请输入邮箱或手机号';

  @override
  String get emailLocked => '住客的登录邮箱无法在此更改。';

  @override
  String get onLeaveToday => '休假中';

  @override
  String leaveUpcoming(String dates) {
    return '休假 $dates';
  }

  @override
  String get collapseMenu => '收起菜单';

  @override
  String get expandMenu => '展开菜单';

  @override
  String get roleRestaurant => '餐厅员工';

  @override
  String get next => '下一步';

  @override
  String get payAtDesk => '住客在前台付款。';

  @override
  String get notAvailableForDates => '此房型在这些日期已满，请尝试其他日期或房间。';

  @override
  String get byType => '按房型';

  @override
  String get byFloor => '按楼层';

  @override
  String floorN(String floor) {
    return '$floor 楼';
  }

  @override
  String get paymentPaid => '已付清';

  @override
  String get paymentDeposit => '已付订金';

  @override
  String get paymentPartial => '部分付款';

  @override
  String get paymentUnpaid => '未付款';

  @override
  String get moreLanguages => '更多语言';
}
