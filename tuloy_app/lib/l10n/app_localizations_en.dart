// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get chooseLanguage => 'Choose your language';

  @override
  String get continueLabel => 'Continue';

  @override
  String get signIn => 'Sign in';

  @override
  String get signUp => 'Create account';

  @override
  String get signOut => 'Sign out';

  @override
  String get noAccount => 'No account yet? Create one';

  @override
  String get emailOrPhone => 'Email or phone number';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'At least 8 characters';

  @override
  String get fullName => 'Full name';

  @override
  String get required => 'Required';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get sendCode => 'Send code';

  @override
  String get codeSent => 'If an account exists, we sent a 6-digit code.';

  @override
  String get code => '6-digit code';

  @override
  String get newPassword => 'New password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get passwordChanged => 'Password changed. Please sign in.';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get guestHome => 'Welcome';

  @override
  String get staffHome => 'Staff';

  @override
  String get adminHome => 'Admin';

  @override
  String get comingSoon => 'More features arrive in the next release.';

  @override
  String get errorGeneric => 'Can\'t reach the server. Check your connection.';

  @override
  String hello(String name) {
    return 'Hello, $name';
  }

  @override
  String get retry => 'Try again';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get profile => 'Profile';

  @override
  String get stays => 'Stays';

  @override
  String get servicesUsed => 'Services used';

  @override
  String get paymentHistory => 'Payment history';

  @override
  String get cardOrEwallet => 'Card / e-wallet';

  @override
  String get testPayment => 'Test payment';

  @override
  String get noneYet => 'Nothing here yet';

  @override
  String get gettingHere => 'Getting here';

  @override
  String get openInMaps => 'Open in Maps';

  @override
  String get airportRoute => 'Route to the airport';

  @override
  String get personalDetails => 'Personal details';

  @override
  String get authTagline => 'Your stay and every service, one tap away';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get findRoom => 'Find a room';

  @override
  String get adults => 'Adults';

  @override
  String get children => 'Children';

  @override
  String get guests => 'Guests';

  @override
  String nightsCount(String count) {
    return 'Nights: $count';
  }

  @override
  String get noRooms => 'No rooms available for these dates. Try other dates.';

  @override
  String perNight(String price) {
    return '$price / night';
  }

  @override
  String roomsLeft(String count) {
    return 'Only $count left';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get amenities => 'Amenities';

  @override
  String get policies => 'Policies';

  @override
  String checkInTime(String time) {
    return 'Check-in from $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out by $time';
  }

  @override
  String get specialRequests => 'Special requests (optional)';

  @override
  String get reserve => 'Reserve';

  @override
  String get review => 'Review and pay';

  @override
  String holdTimer(String time) {
    return 'We\'re holding this room for $time';
  }

  @override
  String get holdExpired => 'Your hold expired. Please search again.';

  @override
  String get serviceCharge => 'Service charge';

  @override
  String get vat => 'VAT';

  @override
  String payDeposit(String amount) {
    return 'Pay deposit $amount';
  }

  @override
  String payFull(String amount) {
    return 'Pay in full $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Pay balance $amount';
  }

  @override
  String get waitingPayment => 'Waiting for payment…';

  @override
  String get waitingPaymentHint =>
      'Finish paying in the browser. This page updates by itself.';

  @override
  String get openPaymentAgain => 'Open payment page again';

  @override
  String get bookingConfirmed => 'Booking confirmed!';

  @override
  String bookingCode(String code) {
    return 'Booking $code';
  }

  @override
  String roomNumber(String room) {
    return 'Room $room';
  }

  @override
  String get viewBooking => 'View booking';

  @override
  String get backHome => 'Back to home';

  @override
  String get paymentFailed =>
      'This booking is no longer held. If you were charged, it will be refunded.';

  @override
  String get myBookings => 'My bookings';

  @override
  String get noBookings => 'No bookings yet.';

  @override
  String get statusHold => 'Awaiting payment';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get statusCheckedIn => 'Checked in';

  @override
  String get statusCheckedOut => 'Checked out';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusNoShow => 'No-show';

  @override
  String get statusDeclined => 'Declined';

  @override
  String get statusExpired => 'Expired';

  @override
  String get cancelBooking => 'Cancel booking';

  @override
  String cancelConfirm(String refund) {
    return 'Cancel this booking? You will get $refund back.';
  }

  @override
  String get keepBooking => 'Keep booking';

  @override
  String get cancelled => 'Booking cancelled';

  @override
  String get invoice => 'Invoice';

  @override
  String get paid => 'Paid';

  @override
  String get balance => 'Balance';

  @override
  String get charges => 'Charges';

  @override
  String get myStay => 'My stay';

  @override
  String get currentStay => 'Your stay';

  @override
  String get hotelGuide => 'Hotel guide';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateStay => 'How was your stay?';

  @override
  String get comment => 'Comments (optional)';

  @override
  String get send => 'Send';

  @override
  String get thanksFeedback => 'Thank you for your feedback!';

  @override
  String get accept => 'Accept';

  @override
  String acceptQuote(String amount) {
    return 'Accept quote $amount';
  }

  @override
  String get acceptance => 'Acceptance';

  @override
  String get active => 'Active';

  @override
  String get add => 'Add';

  @override
  String get addField => 'Add field';

  @override
  String get addOption => 'Add option';

  @override
  String get addOutlet => 'Add outlet';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get addRoom => 'Add room';

  @override
  String get addStaff => 'Add staff';

  @override
  String get addTable => 'Add table';

  @override
  String get adjustPoints => 'Adjust points';

  @override
  String get alerts => 'Alerts';

  @override
  String get all => 'All';

  @override
  String get allergens => 'Allergens';

  @override
  String get allergyNotes => 'Allergies or special instructions';

  @override
  String get amount => 'Amount';

  @override
  String get applyLeave => 'Apply for leave';

  @override
  String get approve => 'Approve';

  @override
  String get approved => 'Approved';

  @override
  String get arrivals => 'Arrivals';

  @override
  String get asSoonAsPossible => 'As soon as possible';

  @override
  String get auditLog => 'Audit log';

  @override
  String get autoAccept => 'Accept automatically';

  @override
  String get basePrice => 'Base price';

  @override
  String get blocks => 'Room blocks';

  @override
  String get body => 'Text';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancelOrder => 'Cancel order';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get cancellationPolicy => 'Cancellation policy';

  @override
  String get category => 'Category';

  @override
  String get chargeToRoom => 'Charge to my room';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Send a message to the front desk.';

  @override
  String get chatWithHotel => 'Chat with the hotel';

  @override
  String get checkInAction => 'Check in';

  @override
  String get checkOutAction => 'Check out';

  @override
  String get choices => 'Choices (comma-separated)';

  @override
  String get closes => 'Closes';

  @override
  String get codeLabel => 'Code';

  @override
  String get collectedToday => 'Collected today';

  @override
  String get content => 'Guides & promotions';

  @override
  String get copied => 'Copied';

  @override
  String get copy => 'Copy';

  @override
  String get copyCsv => 'Copy as CSV';

  @override
  String get dates => 'Dates';

  @override
  String get decline => 'Decline';

  @override
  String get delete => 'Delete';

  @override
  String get department => 'Department';

  @override
  String get departments => 'Departments';

  @override
  String get departures => 'Departures';

  @override
  String get depositPercent => 'Deposit %';

  @override
  String get description => 'Description';

  @override
  String get draft => 'Draft';

  @override
  String get earnPer100 => 'Points per ₱100';

  @override
  String earnRate(String points) {
    return 'You earn $points point(s) for every ₱100.';
  }

  @override
  String get earnsPoints => 'Earns loyalty points';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'empty = base price';

  @override
  String get enterCode => 'Enter code';

  @override
  String get escalate => 'Escalate';

  @override
  String get etaMin => 'Ready in (minutes)';

  @override
  String etaMinutes(String minutes) {
    return 'Ready in about $minutes min';
  }

  @override
  String get failedNotifications => 'Failed notifications';

  @override
  String get failedRefunds => 'Failed refunds';

  @override
  String get fieldKey => 'Field key';

  @override
  String get formFields => 'Guest form fields';

  @override
  String get free => 'Free';

  @override
  String get freeCancelHours => 'Free cancellation (hours before check-in)';

  @override
  String get frontDesk => 'Front desk';

  @override
  String get history => 'History';

  @override
  String get hotelName => 'Hotel name';

  @override
  String get hotelSettings => 'Hotel settings';

  @override
  String get inHouse => 'In-house';

  @override
  String get inactive => 'inactive';

  @override
  String get internalNotes => 'Internal notes';

  @override
  String get kind => 'Type';

  @override
  String get label => 'Label';

  @override
  String get lateRefundPercent => 'Refund after free period %';

  @override
  String get leadTimeMin => 'Order ahead (minutes)';

  @override
  String get leaveRequests => 'Leave requests';

  @override
  String get loyalty => 'Loyalty points';

  @override
  String get markNoShow => 'Mark no-show';

  @override
  String get maxGuests => 'Max guests';

  @override
  String get members => 'Members';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Mine';

  @override
  String get missingToPublish => 'Missing before publishing';

  @override
  String get myDepartment => 'My department';

  @override
  String get myLeave => 'My leave';

  @override
  String get myRequests => 'My requests';

  @override
  String get name => 'Name';

  @override
  String get netToday => 'Net today';

  @override
  String get network => 'Network';

  @override
  String get newQr => 'New QR code';

  @override
  String get newQrWarning => 'The old code for this table will stop working.';

  @override
  String nextTier(String points, String tier) {
    return '$points more points to $tier';
  }

  @override
  String get nothingHere => 'Nothing here yet.';

  @override
  String get occupancyTonight => 'Occupancy tonight';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Open tasks';

  @override
  String get opens => 'Opens';

  @override
  String get options => 'Options';

  @override
  String get orderStatus => 'Your order';

  @override
  String get pause => 'Pause';

  @override
  String get payAtOutlet => 'Pay at the table / outlet';

  @override
  String get payOnline => 'Pay online';

  @override
  String get paymentMethod => 'Payment';

  @override
  String get payments => 'Payments & refunds';

  @override
  String get pendingApproval => 'Pending';

  @override
  String get permissions => 'Permissions';

  @override
  String get photos => 'Photos';

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
  String get pointsPlusMinus => 'Points (+ add, − remove)';

  @override
  String get preferredTime => 'Preferred time';

  @override
  String get price => 'Price';

  @override
  String get priceDelta => 'Extra price';

  @override
  String get priceModel => 'Price model';

  @override
  String get priceOnQuote => 'Price on request';

  @override
  String pricePerItem(String price) {
    return '$price each';
  }

  @override
  String pricePerNight2(String price) {
    return '$price per night';
  }

  @override
  String pricePerPerson(String price) {
    return '$price per person';
  }

  @override
  String get publish => 'Publish';

  @override
  String get published => 'Published';

  @override
  String get qrCode => 'QR code';

  @override
  String get rates => 'Rates';

  @override
  String get reason => 'Reason';

  @override
  String get redeem => 'Redeem';

  @override
  String get redeemNeedsStay =>
      'Points can be used on a confirmed or current stay.';

  @override
  String get redeemed => 'Applied to your stay';

  @override
  String get refund => 'Refund';

  @override
  String get refunded => 'Refunded';

  @override
  String get refundedToday => 'Refunded today';

  @override
  String get reissueWifi => 'Re-issue Wi-Fi';

  @override
  String get rejected => 'Rejected';

  @override
  String get removeAccess => 'Remove staff access';

  @override
  String get reportOccupancy => 'Occupancy';

  @override
  String get reportRevenue => 'Revenue';

  @override
  String get reports => 'Reports';

  @override
  String get requestStatus => 'Request status';

  @override
  String get requireApproval => 'Staff approve each paid booking';

  @override
  String get reservation => 'Reservation';

  @override
  String get reservations => 'Reservations';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantOrders => 'Restaurant orders';

  @override
  String reviewOrder(String count, String total) {
    return 'Review order ($count) · $total';
  }

  @override
  String get rewards => 'Rewards';

  @override
  String get role => 'Role';

  @override
  String get roomLabel => 'Room';

  @override
  String get roomTypeLabel => 'Room type';

  @override
  String get roomsAndRates => 'Rooms & rates';

  @override
  String get save => 'Save';

  @override
  String get saveDraft => 'Save draft';

  @override
  String get saved => 'Saved';

  @override
  String get scanTable => 'Order food (scan table QR)';

  @override
  String get scanTableHint => 'Point the camera at the QR code on your table.';

  @override
  String get schedule => 'Schedule';

  @override
  String get searchGuest => 'Search name, email, phone or code';

  @override
  String get sendQuote => 'Send quote';

  @override
  String get sendRequest => 'Send request';

  @override
  String get serviceBuilder => 'Service builder';

  @override
  String get services => 'Services';

  @override
  String get setRate => 'Set price for dates';

  @override
  String get staff => 'Staff';

  @override
  String get staffAndLeave => 'Staff & leave';

  @override
  String get staffApproval => 'Staff accepts each request';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Status steps';

  @override
  String get submitOrder => 'Submit order';

  @override
  String tableLabel(String table) {
    return 'Table $table';
  }

  @override
  String get tasks => 'Tasks';

  @override
  String get taxIncluded => 'Price includes tax';

  @override
  String get tempPassword => 'Temporary password';

  @override
  String tier(String tier) {
    return 'Tier: $tier';
  }

  @override
  String get title => 'Title';

  @override
  String get typeMessage => 'Type a message';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get unblock => 'Unblock';

  @override
  String get upcoming => 'Upcoming';

  @override
  String get username => 'Username';

  @override
  String get validUntil => 'Valid until';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Wi-Fi mode (portal or psk)';

  @override
  String get wifiPortalHint =>
      'Join the network; the login page opens. Enter the username and password above.';

  @override
  String get wifiQrHint => 'Scan with your camera to join.';

  @override
  String get wifiSharedPassword => 'Shared Wi-Fi password (psk mode)';

  @override
  String get webGuestTitle => 'Guests, please use the Tuloy mobile app';

  @override
  String get webGuestBody =>
      'Booking and stay features are available in the iOS and Android app. Staff and admins can sign in here.';
}
