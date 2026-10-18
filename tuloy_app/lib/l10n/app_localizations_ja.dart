// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'ログイン';

  @override
  String get signUp => 'アカウント作成';

  @override
  String get signOut => 'ログアウト';

  @override
  String get noAccount => 'アカウントをお持ちでない方';

  @override
  String get haveAccount => 'アカウントをお持ちの方';

  @override
  String get emailOrPhone => 'メールアドレスまたは電話番号';

  @override
  String get password => 'パスワード';

  @override
  String get passwordHint => '8文字以上';

  @override
  String get fullName => '氏名';

  @override
  String get required => '必須';

  @override
  String get forgotPassword => 'パスワードをお忘れですか？';

  @override
  String get sendCode => 'コードを送信';

  @override
  String get codeSent => 'アカウントが存在する場合、6桁のコードを送信しました。';

  @override
  String get code => '6桁のコード';

  @override
  String get newPassword => '新しいパスワード';

  @override
  String get resetPassword => 'パスワードを再設定';

  @override
  String get passwordChanged => 'パスワードを変更しました。ログインしてください。';

  @override
  String get settings => '設定';

  @override
  String get language => '言語';

  @override
  String get guestHome => 'ようこそ';

  @override
  String get staffHome => 'スタッフ';

  @override
  String get adminHome => '管理者';

  @override
  String get comingSoon => '次のリリースで機能が追加されます。';

  @override
  String get errorGeneric => 'サーバーに接続できません。接続を確認してください。';

  @override
  String get cannotReachServer =>
      'サーバーに接続できません。接続を確認するか、管理者にこのサイトの許可を依頼してください。';

  @override
  String hello(String name) {
    return 'こんにちは、$nameさん';
  }

  @override
  String get retry => '再試行';

  @override
  String get howCanWeHelp => '何かお手伝いできますか？';

  @override
  String get profile => 'プロフィール';

  @override
  String get stays => '宿泊';

  @override
  String get servicesUsed => '利用したサービス';

  @override
  String get paymentHistory => '支払い履歴';

  @override
  String get cardOrEwallet => 'カード / 電子マネー';

  @override
  String get testPayment => 'テスト支払い';

  @override
  String get noneYet => 'まだありません';

  @override
  String get gettingHere => 'アクセス';

  @override
  String get openInMaps => 'マップで開く';

  @override
  String get airportRoute => '空港へのルート';

  @override
  String get personalDetails => '個人情報';

  @override
  String get authTagline => 'ご滞在とすべてのサービスをワンタップで';

  @override
  String get showPassword => 'パスワードを表示';

  @override
  String get hidePassword => 'パスワードを隠す';

  @override
  String get findRoom => '部屋を探す';

  @override
  String get adults => '大人';

  @override
  String get children => '子ども';

  @override
  String get guests => '人数';

  @override
  String nightsCount(String count) {
    return '泊数：$count';
  }

  @override
  String get noRooms => 'この日程に空室はありません。別の日程をお試しください。';

  @override
  String perNight(String price) {
    return '$price / 泊';
  }

  @override
  String roomsLeft(String count) {
    return '残り$count室';
  }

  @override
  String get totalLabel => '合計';

  @override
  String get amenities => '設備';

  @override
  String get policies => '規約';

  @override
  String checkInTime(String time) {
    return 'チェックイン $timeから';
  }

  @override
  String checkOutTime(String time) {
    return 'チェックアウト $timeまで';
  }

  @override
  String get specialRequests => '特別なご要望（任意）';

  @override
  String get reserve => '予約する';

  @override
  String get review => '確認して支払う';

  @override
  String holdTimer(String time) {
    return 'この部屋を$time確保しています';
  }

  @override
  String get holdExpired => '確保期限が切れました。もう一度検索してください。';

  @override
  String get serviceCharge => 'サービス料';

  @override
  String get vat => '付加価値税';

  @override
  String payDeposit(String amount) {
    return 'デポジットを支払う $amount';
  }

  @override
  String payFull(String amount) {
    return '全額を支払う $amount';
  }

  @override
  String payBalance(String amount) {
    return '残額を支払う $amount';
  }

  @override
  String get waitingPayment => '支払いを待っています…';

  @override
  String get waitingPaymentHint => 'ブラウザで支払いを完了してください。このページは自動で更新されます。';

  @override
  String get openPaymentAgain => '支払いページを再度開く';

  @override
  String get bookingConfirmed => '予約が確定しました！';

  @override
  String bookingCode(String code) {
    return '予約番号 $code';
  }

  @override
  String roomNumber(String room) {
    return '$room号室';
  }

  @override
  String get viewBooking => '予約を見る';

  @override
  String get backHome => 'ホームに戻る';

  @override
  String get paymentFailed => 'この予約は確保されていません。請求された場合は返金されます。';

  @override
  String get myBookings => '予約一覧';

  @override
  String get noBookings => '予約はまだありません。';

  @override
  String get statusHold => '支払い待ち';

  @override
  String get statusPending => '保留中';

  @override
  String get statusConfirmed => '確定';

  @override
  String get statusCheckedIn => 'チェックイン済み';

  @override
  String get statusCheckedOut => 'チェックアウト済み';

  @override
  String get statusCancelled => 'キャンセル済み';

  @override
  String get statusNoShow => 'ノーショー';

  @override
  String get statusDeclined => 'お断り';

  @override
  String get statusExpired => '期限切れ';

  @override
  String get cancelBooking => '予約をキャンセル';

  @override
  String cancelConfirm(String refund) {
    return 'この予約をキャンセルしますか？$refundが返金されます。';
  }

  @override
  String get keepBooking => '予約を維持';

  @override
  String get cancelled => '予約をキャンセルしました';

  @override
  String get invoice => '請求書';

  @override
  String get paid => '支払済';

  @override
  String get balance => '残額';

  @override
  String get charges => '料金';

  @override
  String get myStay => 'ご滞在';

  @override
  String get currentStay => 'ご滞在中';

  @override
  String get hotelGuide => 'ホテルガイド';

  @override
  String get feedback => 'フィードバック';

  @override
  String get rateStay => 'ご滞在はいかがでしたか？';

  @override
  String get comment => 'コメント（任意）';

  @override
  String get send => '送信';

  @override
  String get thanksFeedback => 'ご意見ありがとうございます！';

  @override
  String get accept => '承認';

  @override
  String acceptQuote(String amount) {
    return '見積もりを承認 $amount';
  }

  @override
  String get acceptance => '受付方法';

  @override
  String get active => '有効';

  @override
  String get add => '追加';

  @override
  String get addField => '項目を追加';

  @override
  String get addOption => 'オプションを追加';

  @override
  String get addOutlet => '店舗を追加';

  @override
  String get addPhoto => '写真を追加';

  @override
  String get addRoom => '部屋を追加';

  @override
  String get addStaff => 'スタッフを追加';

  @override
  String get addTable => 'テーブルを追加';

  @override
  String get adjustPoints => 'ポイントを調整';

  @override
  String get alerts => 'アラート';

  @override
  String get all => 'すべて';

  @override
  String get allergens => 'アレルゲン';

  @override
  String get allergyNotes => 'アレルギーや特別な指示';

  @override
  String get amount => '金額';

  @override
  String get applyLeave => '休暇を申請';

  @override
  String get approve => '承認';

  @override
  String get approved => '承認済み';

  @override
  String get arrivals => '到着';

  @override
  String get asSoonAsPossible => 'できるだけ早く';

  @override
  String get auditLog => '監査ログ';

  @override
  String get autoAccept => '自動で受け付ける';

  @override
  String get basePrice => '基本料金';

  @override
  String get blocks => '客室ブロック';

  @override
  String get body => '本文';

  @override
  String get cancel => 'キャンセル';

  @override
  String get cancelOrder => '注文をキャンセル';

  @override
  String get cancelRequest => '依頼をキャンセル';

  @override
  String get cancellationPolicy => 'キャンセルポリシー';

  @override
  String get category => 'カテゴリ';

  @override
  String get chargeToRoom => '部屋付けにする';

  @override
  String get chat => 'チャット';

  @override
  String get chatEmpty => 'フロントにメッセージを送ってください。';

  @override
  String get chatWithHotel => 'ホテルとチャット';

  @override
  String get checkInAction => 'チェックイン';

  @override
  String get checkOutAction => 'チェックアウト';

  @override
  String get choices => '選択肢（カンマ区切り）';

  @override
  String get closes => '終了';

  @override
  String get codeLabel => '番号';

  @override
  String get collectedToday => '本日の入金';

  @override
  String get content => 'ガイドとお知らせ';

  @override
  String get copied => 'コピーしました';

  @override
  String get copy => 'コピー';

  @override
  String get copyCsv => 'CSVとしてコピー';

  @override
  String get dates => '日付';

  @override
  String get decline => 'お断り';

  @override
  String get delete => '削除';

  @override
  String get department => '部署';

  @override
  String get departments => '部署';

  @override
  String get departures => '出発';

  @override
  String get depositPercent => 'デポジット %';

  @override
  String get description => '説明';

  @override
  String get draft => '下書き';

  @override
  String get earnPer100 => '₱100あたりのポイント';

  @override
  String earnRate(String points) {
    return '₱100ごとに$pointsポイント貯まります。';
  }

  @override
  String get earnsPoints => 'ポイントが貯まる';

  @override
  String get email => 'メールアドレス';

  @override
  String get emptyResets => '空欄 = 基本料金';

  @override
  String get enterCode => 'コードを入力';

  @override
  String get escalate => 'エスカレーション';

  @override
  String get etaMin => '準備時間（分）';

  @override
  String etaMinutes(String minutes) {
    return '約$minutes分で準備できます';
  }

  @override
  String get failedNotifications => '送信失敗した通知';

  @override
  String get failedRefunds => '失敗した返金';

  @override
  String get fieldKey => '項目キー';

  @override
  String get formFields => 'ゲストの入力項目';

  @override
  String get free => '空室';

  @override
  String get freeCancelHours => '無料キャンセル（チェックイン何時間前まで）';

  @override
  String get frontDesk => 'フロント';

  @override
  String get history => '履歴';

  @override
  String get hotelName => 'ホテル名';

  @override
  String get hotelSettings => 'ホテル設定';

  @override
  String get inHouse => '滞在中';

  @override
  String get inactive => '無効';

  @override
  String get internalNotes => '社内メモ';

  @override
  String get kind => '種類';

  @override
  String get label => 'ラベル';

  @override
  String get lateRefundPercent => '無料期間後の返金 %';

  @override
  String get leadTimeMin => '事前注文（分）';

  @override
  String get leaveRequests => '休暇申請';

  @override
  String get loyalty => 'ポイント';

  @override
  String get markNoShow => 'ノーショーにする';

  @override
  String get maxGuests => '最大人数';

  @override
  String get members => '会員';

  @override
  String get menu => 'メニュー';

  @override
  String get mine => '自分';

  @override
  String get missingToPublish => '公開前に不足している項目';

  @override
  String get myDepartment => '自分の部署';

  @override
  String get myLeave => '自分の休暇';

  @override
  String get myRequests => '自分の依頼';

  @override
  String get name => '名前';

  @override
  String get netToday => '本日の純額';

  @override
  String get network => 'ネットワーク';

  @override
  String get newQr => '新しいQRコード';

  @override
  String get newQrWarning => 'このテーブルの古いコードは使えなくなります。';

  @override
  String nextTier(String points, String tier) {
    return 'あと$pointsポイントで$tier';
  }

  @override
  String get nothingHere => 'まだありません。';

  @override
  String get notFound => '見つかりません。';

  @override
  String get occupancyTonight => '今夜の稼働率';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => '未完了のタスク';

  @override
  String get opens => '開始';

  @override
  String get options => 'オプション';

  @override
  String get orderStatus => 'ご注文';

  @override
  String get pause => '一時停止';

  @override
  String get payAtOutlet => 'テーブル / 店舗で支払う';

  @override
  String get payOnline => 'オンラインで支払う';

  @override
  String get paymentMethod => '支払い';

  @override
  String get payments => '支払いと返金';

  @override
  String get pendingApproval => '承認待ち';

  @override
  String get permissions => '権限';

  @override
  String get photos => '写真';

  @override
  String get points => 'ポイント';

  @override
  String pointsBalance(String points) {
    return '$pointsポイント';
  }

  @override
  String pointsCost(String points) {
    return '$pointsポイント';
  }

  @override
  String get pointsPlusMinus => 'ポイント（+ 追加、− 減算）';

  @override
  String get preferredTime => '希望時間';

  @override
  String get price => '料金';

  @override
  String get priceDelta => '追加料金';

  @override
  String get priceModel => '料金体系';

  @override
  String get priceOnQuote => '料金はお問い合わせ';

  @override
  String pricePerItem(String price) {
    return '1点 $price';
  }

  @override
  String pricePerNight2(String price) {
    return '1泊 $price';
  }

  @override
  String pricePerPerson(String price) {
    return '1人 $price';
  }

  @override
  String get publish => '公開';

  @override
  String get published => '公開中';

  @override
  String get qrCode => 'QRコード';

  @override
  String get rates => '料金';

  @override
  String get reason => '理由';

  @override
  String get redeem => '交換';

  @override
  String get redeemNeedsStay => 'ポイントは確定済みまたは滞在中の予約に使えます。';

  @override
  String get redeemed => 'ご滞在に適用しました';

  @override
  String get refund => '返金';

  @override
  String get refunded => '返金済み';

  @override
  String get refundedToday => '本日の返金';

  @override
  String get reissueWifi => 'Wi-Fiを再発行';

  @override
  String get rejected => '却下';

  @override
  String get removeAccess => 'スタッフ権限を削除';

  @override
  String get reportOccupancy => '稼働率';

  @override
  String get reportRevenue => '売上';

  @override
  String get reports => 'レポート';

  @override
  String get requestStatus => '依頼の状況';

  @override
  String get requireApproval => '支払済みの予約をスタッフが承認する';

  @override
  String get reservation => '予約';

  @override
  String get reservations => '予約';

  @override
  String get restaurant => 'レストラン';

  @override
  String get restaurantOrders => 'レストランの注文';

  @override
  String reviewOrder(String count, String total) {
    return '注文を確認（$count）· $total';
  }

  @override
  String get rewards => '特典';

  @override
  String get role => '役割';

  @override
  String get roomLabel => '部屋';

  @override
  String get roomTypeLabel => '部屋タイプ';

  @override
  String get roomsAndRates => '客室と料金';

  @override
  String get save => '保存';

  @override
  String get saveDraft => '下書き保存';

  @override
  String get saved => '保存しました';

  @override
  String get scanTable => '料理を注文（テーブルのQRを読み取る）';

  @override
  String get scanTableHint => 'テーブルのQRコードにカメラを向けてください。';

  @override
  String get schedule => 'スケジュール';

  @override
  String get searchGuest => '名前、メール、電話、番号で検索';

  @override
  String get sendQuote => '見積もりを送る';

  @override
  String get sendRequest => '依頼を送る';

  @override
  String get serviceBuilder => 'サービス作成';

  @override
  String get services => 'サービス';

  @override
  String get setRate => '日付の料金を設定';

  @override
  String get staff => 'スタッフ';

  @override
  String get staffAndLeave => 'スタッフと休暇';

  @override
  String get staffApproval => '依頼ごとにスタッフが受け付ける';

  @override
  String get status => '状況';

  @override
  String get statusSteps => '状況のステップ';

  @override
  String get submitOrder => '注文を送信';

  @override
  String tableLabel(String table) {
    return 'テーブル $table';
  }

  @override
  String get tasks => 'タスク';

  @override
  String get taxIncluded => '税込み';

  @override
  String get tempPassword => '仮パスワード';

  @override
  String tier(String tier) {
    return 'ランク：$tier';
  }

  @override
  String get title => 'タイトル';

  @override
  String get typeMessage => 'メッセージを入力';

  @override
  String get unassigned => '未割り当て';

  @override
  String get unblock => 'ブロック解除';

  @override
  String get upcoming => '今後';

  @override
  String get username => 'ユーザー名';

  @override
  String get validUntil => '有効期限';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fiモード（portal または psk）';

  @override
  String get wifiPortalHint =>
      'ネットワークに接続するとログイン画面が開きます。上のユーザー名とパスワードを入力してください。';

  @override
  String get wifiQrHint => 'カメラで読み取ると接続できます。';

  @override
  String get wifiSharedPassword => '共通のWi-Fiパスワード（pskモード）';

  @override
  String get action => '操作';

  @override
  String get entity => '対象';

  @override
  String get dateLabel => '日付';

  @override
  String get actor => '実行者';

  @override
  String get navOverview => '概要';

  @override
  String get navCatalog => 'カタログ';

  @override
  String get navFinance => '財務';

  @override
  String get navPeople => '人';

  @override
  String get navSystem => 'システム';

  @override
  String get details => '詳細';

  @override
  String get refresh => '更新';

  @override
  String get needsAttention => '要対応';

  @override
  String get allClear => '対応が必要な項目はありません';

  @override
  String get unreadChats => '未読のチャット';

  @override
  String get myTasks => '自分のタスク';

  @override
  String get search => '検索';

  @override
  String get showMore => 'さらに表示';

  @override
  String get viewLabel => '表示';

  @override
  String get sortedAscending => '昇順';

  @override
  String get sortedDescending => '降順';

  @override
  String sortBy(String column) {
    return '$columnで並べ替え';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown / $total';
  }

  @override
  String get note => 'メモ';

  @override
  String get rooms => '部屋';

  @override
  String get tables => 'テーブル';

  @override
  String get showDetails => '詳細を表示';

  @override
  String get hideDetails => '詳細を隠す';

  @override
  String get selectThread => '会話を選択';

  @override
  String get keyboardShortcuts => 'キーボードショートカット';

  @override
  String get goToPage => 'ページへ移動';

  @override
  String get shortcutSearch => 'このページを検索';

  @override
  String get shortcutClose => 'パネルやダイアログを閉じる';

  @override
  String get shortcutHelp => 'キーボードショートカットを表示';

  @override
  String get shortcutSend => 'メッセージを送信（Shift+Enterで改行）';

  @override
  String get roomBoard => '本日の客室';

  @override
  String get roomOccupied => '滞在中';

  @override
  String get roomDeparting => '本日チェックアウト';

  @override
  String get roomArriving => '本日到着';

  @override
  String get roomReserved => '予約済み';

  @override
  String get roomBlocked => '使用不可';

  @override
  String freeOf(String free, String total) {
    return '$total室中$free室空き';
  }

  @override
  String get todaysArrivals => '本日の到着';

  @override
  String get todaysDepartures => '本日の出発';

  @override
  String get guestList => 'ゲスト一覧';

  @override
  String get team => 'チーム';

  @override
  String get lastStay => '前回の滞在';

  @override
  String get roleAdmin => '管理者';

  @override
  String get notifications => '通知';

  @override
  String get notifBooking => '新しい予約';

  @override
  String get notifPending => '承認が必要な予約';

  @override
  String get notifCancelled => '予約がキャンセルされました';

  @override
  String get notifRequest => '新しいサービス依頼';

  @override
  String get notifOrder => '新しい料理の注文';

  @override
  String get notifMessage => '新しいメッセージ';

  @override
  String staffCancelConfirm(String refund) {
    return 'この予約をキャンセルしますか？キャンセルポリシーに従い、ゲストに$refundが返金されます。';
  }

  @override
  String get phone => '電話';

  @override
  String get appearance => '表示';

  @override
  String get themeSystem => '端末に合わせる';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get roomAvailable => '空室';

  @override
  String get availableOnly => '空室のみ';

  @override
  String get floor => '階';

  @override
  String get allRoomTypes => 'すべての部屋タイプ';

  @override
  String get guestLabel => 'ゲスト';

  @override
  String get rowNo => 'No.';

  @override
  String get employeeId => '社員番号';

  @override
  String get photo => '写真';

  @override
  String get dateFrom => '開始';

  @override
  String get dateTo => '終了';

  @override
  String get leaveType => '休暇の種類';

  @override
  String get leaveVacation => '休暇';

  @override
  String get leaveSick => '病気';

  @override
  String get leaveEmergency => '緊急';

  @override
  String get leaveOther => 'その他';

  @override
  String get submit => '送信';

  @override
  String get cash => '現金';

  @override
  String get card => 'カード';

  @override
  String get arrival => '到着';

  @override
  String get departure => '出発';

  @override
  String get serviceRequests => 'サービス依頼';

  @override
  String get newRequest => '新しい依頼';

  @override
  String get guestBooking => 'ゲストの予約';

  @override
  String bookRoom(String room) {
    return '$room号室を予約';
  }

  @override
  String get bookAndCheckIn => '予約してチェックイン';

  @override
  String get changeBooking => '予約を変更';

  @override
  String get recordPayment => '支払いを記録';

  @override
  String get emailOrPhoneRequired => 'メールアドレスか電話番号を入力してください';

  @override
  String get emailLocked => 'ゲストのログイン用メールアドレスはここでは変更できません。';

  @override
  String get onLeaveToday => '休暇中';

  @override
  String leaveUpcoming(String dates) {
    return '休暇 $dates';
  }

  @override
  String get collapseMenu => 'メニューを閉じる';

  @override
  String get expandMenu => 'メニューを開く';

  @override
  String get roleRestaurant => 'レストランスタッフ';

  @override
  String get next => '次へ';

  @override
  String get payAtDesk => 'お支払いはフロントで行います。';

  @override
  String get notAvailableForDates => 'この部屋タイプはこの日程で満室です。別の日程か部屋をお試しください。';

  @override
  String get byType => 'タイプ別';

  @override
  String get byFloor => '階別';

  @override
  String floorN(String floor) {
    return '$floor階';
  }

  @override
  String get paymentPaid => '支払済';

  @override
  String get paymentDeposit => 'デポジット支払済';

  @override
  String get paymentPartial => '一部支払済';

  @override
  String get paymentUnpaid => '未払い';

  @override
  String get moreLanguages => 'その他の言語';
}
