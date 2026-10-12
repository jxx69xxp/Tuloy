import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ceb.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fil.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ceb'),
    Locale('en'),
    Locale('fil'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Tuloy'**
  String get appTitle;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get chooseLanguage;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get signUp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'No account yet? Create one'**
  String get noAccount;

  /// No description provided for @emailOrPhone.
  ///
  /// In en, this message translates to:
  /// **'Email or phone number'**
  String get emailOrPhone;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'At least 8 characters'**
  String get passwordHint;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @sendCode.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCode;

  /// No description provided for @codeSent.
  ///
  /// In en, this message translates to:
  /// **'If an account exists, we sent a 6-digit code.'**
  String get codeSent;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'6-digit code'**
  String get code;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed. Please sign in.'**
  String get passwordChanged;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @guestHome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get guestHome;

  /// No description provided for @staffHome.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffHome;

  /// No description provided for @adminHome.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get adminHome;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'More features arrive in the next release.'**
  String get comingSoon;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection.'**
  String get errorGeneric;

  /// No description provided for @cannotReachServer.
  ///
  /// In en, this message translates to:
  /// **'Can\'t reach the server. Check your connection, or ask your administrator to allow this website.'**
  String get cannotReachServer;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}'**
  String hello(String name);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get retry;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @stays.
  ///
  /// In en, this message translates to:
  /// **'Stays'**
  String get stays;

  /// No description provided for @servicesUsed.
  ///
  /// In en, this message translates to:
  /// **'Services used'**
  String get servicesUsed;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment history'**
  String get paymentHistory;

  /// No description provided for @cardOrEwallet.
  ///
  /// In en, this message translates to:
  /// **'Card / e-wallet'**
  String get cardOrEwallet;

  /// No description provided for @testPayment.
  ///
  /// In en, this message translates to:
  /// **'Test payment'**
  String get testPayment;

  /// No description provided for @noneYet.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet'**
  String get noneYet;

  /// No description provided for @gettingHere.
  ///
  /// In en, this message translates to:
  /// **'Getting here'**
  String get gettingHere;

  /// No description provided for @openInMaps.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get openInMaps;

  /// No description provided for @airportRoute.
  ///
  /// In en, this message translates to:
  /// **'Route to the airport'**
  String get airportRoute;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal details'**
  String get personalDetails;

  /// No description provided for @authTagline.
  ///
  /// In en, this message translates to:
  /// **'Your stay and every service, one tap away'**
  String get authTagline;

  /// No description provided for @showPassword.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get hidePassword;

  /// No description provided for @findRoom.
  ///
  /// In en, this message translates to:
  /// **'Find a room'**
  String get findRoom;

  /// No description provided for @adults.
  ///
  /// In en, this message translates to:
  /// **'Adults'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In en, this message translates to:
  /// **'Children'**
  String get children;

  /// No description provided for @guests.
  ///
  /// In en, this message translates to:
  /// **'Guests'**
  String get guests;

  /// No description provided for @nightsCount.
  ///
  /// In en, this message translates to:
  /// **'Nights: {count}'**
  String nightsCount(String count);

  /// No description provided for @noRooms.
  ///
  /// In en, this message translates to:
  /// **'No rooms available for these dates. Try other dates.'**
  String get noRooms;

  /// No description provided for @perNight.
  ///
  /// In en, this message translates to:
  /// **'{price} / night'**
  String perNight(String price);

  /// No description provided for @roomsLeft.
  ///
  /// In en, this message translates to:
  /// **'Only {count} left'**
  String roomsLeft(String count);

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @amenities.
  ///
  /// In en, this message translates to:
  /// **'Amenities'**
  String get amenities;

  /// No description provided for @policies.
  ///
  /// In en, this message translates to:
  /// **'Policies'**
  String get policies;

  /// No description provided for @checkInTime.
  ///
  /// In en, this message translates to:
  /// **'Check-in from {time}'**
  String checkInTime(String time);

  /// No description provided for @checkOutTime.
  ///
  /// In en, this message translates to:
  /// **'Check-out by {time}'**
  String checkOutTime(String time);

  /// No description provided for @specialRequests.
  ///
  /// In en, this message translates to:
  /// **'Special requests (optional)'**
  String get specialRequests;

  /// No description provided for @reserve.
  ///
  /// In en, this message translates to:
  /// **'Reserve'**
  String get reserve;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review and pay'**
  String get review;

  /// No description provided for @holdTimer.
  ///
  /// In en, this message translates to:
  /// **'We\'re holding this room for {time}'**
  String holdTimer(String time);

  /// No description provided for @holdExpired.
  ///
  /// In en, this message translates to:
  /// **'Your hold expired. Please search again.'**
  String get holdExpired;

  /// No description provided for @serviceCharge.
  ///
  /// In en, this message translates to:
  /// **'Service charge'**
  String get serviceCharge;

  /// No description provided for @vat.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get vat;

  /// No description provided for @payDeposit.
  ///
  /// In en, this message translates to:
  /// **'Pay deposit {amount}'**
  String payDeposit(String amount);

  /// No description provided for @payFull.
  ///
  /// In en, this message translates to:
  /// **'Pay in full {amount}'**
  String payFull(String amount);

  /// No description provided for @payBalance.
  ///
  /// In en, this message translates to:
  /// **'Pay balance {amount}'**
  String payBalance(String amount);

  /// No description provided for @waitingPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting for payment…'**
  String get waitingPayment;

  /// No description provided for @waitingPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Finish paying in the browser. This page updates by itself.'**
  String get waitingPaymentHint;

  /// No description provided for @openPaymentAgain.
  ///
  /// In en, this message translates to:
  /// **'Open payment page again'**
  String get openPaymentAgain;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmed!'**
  String get bookingConfirmed;

  /// No description provided for @bookingCode.
  ///
  /// In en, this message translates to:
  /// **'Booking {code}'**
  String bookingCode(String code);

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room {room}'**
  String roomNumber(String room);

  /// No description provided for @viewBooking.
  ///
  /// In en, this message translates to:
  /// **'View booking'**
  String get viewBooking;

  /// No description provided for @backHome.
  ///
  /// In en, this message translates to:
  /// **'Back to home'**
  String get backHome;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'This booking is no longer held. If you were charged, it will be refunded.'**
  String get paymentFailed;

  /// No description provided for @myBookings.
  ///
  /// In en, this message translates to:
  /// **'My bookings'**
  String get myBookings;

  /// No description provided for @noBookings.
  ///
  /// In en, this message translates to:
  /// **'No bookings yet.'**
  String get noBookings;

  /// No description provided for @statusHold.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment'**
  String get statusHold;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @statusCheckedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked in'**
  String get statusCheckedIn;

  /// No description provided for @statusCheckedOut.
  ///
  /// In en, this message translates to:
  /// **'Checked out'**
  String get statusCheckedOut;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusNoShow.
  ///
  /// In en, this message translates to:
  /// **'No-show'**
  String get statusNoShow;

  /// No description provided for @statusDeclined.
  ///
  /// In en, this message translates to:
  /// **'Declined'**
  String get statusDeclined;

  /// No description provided for @statusExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get statusExpired;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel booking'**
  String get cancelBooking;

  /// No description provided for @cancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this booking? You will get {refund} back.'**
  String cancelConfirm(String refund);

  /// No description provided for @keepBooking.
  ///
  /// In en, this message translates to:
  /// **'Keep booking'**
  String get keepBooking;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Booking cancelled'**
  String get cancelled;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get invoice;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @charges.
  ///
  /// In en, this message translates to:
  /// **'Charges'**
  String get charges;

  /// No description provided for @myStay.
  ///
  /// In en, this message translates to:
  /// **'My stay'**
  String get myStay;

  /// No description provided for @currentStay.
  ///
  /// In en, this message translates to:
  /// **'Your stay'**
  String get currentStay;

  /// No description provided for @hotelGuide.
  ///
  /// In en, this message translates to:
  /// **'Hotel guide'**
  String get hotelGuide;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rateStay.
  ///
  /// In en, this message translates to:
  /// **'How was your stay?'**
  String get rateStay;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comments (optional)'**
  String get comment;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @thanksFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thanksFeedback;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @acceptQuote.
  ///
  /// In en, this message translates to:
  /// **'Accept quote {amount}'**
  String acceptQuote(String amount);

  /// No description provided for @acceptance.
  ///
  /// In en, this message translates to:
  /// **'Acceptance'**
  String get acceptance;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addField.
  ///
  /// In en, this message translates to:
  /// **'Add field'**
  String get addField;

  /// No description provided for @addOption.
  ///
  /// In en, this message translates to:
  /// **'Add option'**
  String get addOption;

  /// No description provided for @addOutlet.
  ///
  /// In en, this message translates to:
  /// **'Add outlet'**
  String get addOutlet;

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add photo'**
  String get addPhoto;

  /// No description provided for @addRoom.
  ///
  /// In en, this message translates to:
  /// **'Add room'**
  String get addRoom;

  /// No description provided for @addStaff.
  ///
  /// In en, this message translates to:
  /// **'Add staff'**
  String get addStaff;

  /// No description provided for @addTable.
  ///
  /// In en, this message translates to:
  /// **'Add table'**
  String get addTable;

  /// No description provided for @adjustPoints.
  ///
  /// In en, this message translates to:
  /// **'Adjust points'**
  String get adjustPoints;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @allergens.
  ///
  /// In en, this message translates to:
  /// **'Allergens'**
  String get allergens;

  /// No description provided for @allergyNotes.
  ///
  /// In en, this message translates to:
  /// **'Allergies or special instructions'**
  String get allergyNotes;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @applyLeave.
  ///
  /// In en, this message translates to:
  /// **'Apply for leave'**
  String get applyLeave;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @arrivals.
  ///
  /// In en, this message translates to:
  /// **'Arrivals'**
  String get arrivals;

  /// No description provided for @asSoonAsPossible.
  ///
  /// In en, this message translates to:
  /// **'As soon as possible'**
  String get asSoonAsPossible;

  /// No description provided for @auditLog.
  ///
  /// In en, this message translates to:
  /// **'Audit log'**
  String get auditLog;

  /// No description provided for @autoAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept automatically'**
  String get autoAccept;

  /// No description provided for @basePrice.
  ///
  /// In en, this message translates to:
  /// **'Base price'**
  String get basePrice;

  /// No description provided for @blocks.
  ///
  /// In en, this message translates to:
  /// **'Room blocks'**
  String get blocks;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get body;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel order'**
  String get cancelOrder;

  /// No description provided for @cancelRequest.
  ///
  /// In en, this message translates to:
  /// **'Cancel request'**
  String get cancelRequest;

  /// No description provided for @cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation policy'**
  String get cancellationPolicy;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @chargeToRoom.
  ///
  /// In en, this message translates to:
  /// **'Charge to my room'**
  String get chargeToRoom;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @chatEmpty.
  ///
  /// In en, this message translates to:
  /// **'Send a message to the front desk.'**
  String get chatEmpty;

  /// No description provided for @chatWithHotel.
  ///
  /// In en, this message translates to:
  /// **'Chat with the hotel'**
  String get chatWithHotel;

  /// No description provided for @checkInAction.
  ///
  /// In en, this message translates to:
  /// **'Check in'**
  String get checkInAction;

  /// No description provided for @checkOutAction.
  ///
  /// In en, this message translates to:
  /// **'Check out'**
  String get checkOutAction;

  /// No description provided for @choices.
  ///
  /// In en, this message translates to:
  /// **'Choices (comma-separated)'**
  String get choices;

  /// No description provided for @closes.
  ///
  /// In en, this message translates to:
  /// **'Closes'**
  String get closes;

  /// No description provided for @codeLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get codeLabel;

  /// No description provided for @collectedToday.
  ///
  /// In en, this message translates to:
  /// **'Collected today'**
  String get collectedToday;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Guides & promotions'**
  String get content;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @copyCsv.
  ///
  /// In en, this message translates to:
  /// **'Copy as CSV'**
  String get copyCsv;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @decline.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get decline;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'Departments'**
  String get departments;

  /// No description provided for @departures.
  ///
  /// In en, this message translates to:
  /// **'Departures'**
  String get departures;

  /// No description provided for @depositPercent.
  ///
  /// In en, this message translates to:
  /// **'Deposit %'**
  String get depositPercent;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @earnPer100.
  ///
  /// In en, this message translates to:
  /// **'Points per ₱100'**
  String get earnPer100;

  /// No description provided for @earnRate.
  ///
  /// In en, this message translates to:
  /// **'You earn {points} point(s) for every ₱100.'**
  String earnRate(String points);

  /// No description provided for @earnsPoints.
  ///
  /// In en, this message translates to:
  /// **'Earns loyalty points'**
  String get earnsPoints;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emptyResets.
  ///
  /// In en, this message translates to:
  /// **'empty = base price'**
  String get emptyResets;

  /// No description provided for @enterCode.
  ///
  /// In en, this message translates to:
  /// **'Enter code'**
  String get enterCode;

  /// No description provided for @escalate.
  ///
  /// In en, this message translates to:
  /// **'Escalate'**
  String get escalate;

  /// No description provided for @etaMin.
  ///
  /// In en, this message translates to:
  /// **'Ready in (minutes)'**
  String get etaMin;

  /// No description provided for @etaMinutes.
  ///
  /// In en, this message translates to:
  /// **'Ready in about {minutes} min'**
  String etaMinutes(String minutes);

  /// No description provided for @failedNotifications.
  ///
  /// In en, this message translates to:
  /// **'Failed notifications'**
  String get failedNotifications;

  /// No description provided for @failedRefunds.
  ///
  /// In en, this message translates to:
  /// **'Failed refunds'**
  String get failedRefunds;

  /// No description provided for @fieldKey.
  ///
  /// In en, this message translates to:
  /// **'Field key'**
  String get fieldKey;

  /// No description provided for @formFields.
  ///
  /// In en, this message translates to:
  /// **'Guest form fields'**
  String get formFields;

  /// No description provided for @free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get free;

  /// No description provided for @freeCancelHours.
  ///
  /// In en, this message translates to:
  /// **'Free cancellation (hours before check-in)'**
  String get freeCancelHours;

  /// No description provided for @frontDesk.
  ///
  /// In en, this message translates to:
  /// **'Front desk'**
  String get frontDesk;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @hotelName.
  ///
  /// In en, this message translates to:
  /// **'Hotel name'**
  String get hotelName;

  /// No description provided for @hotelSettings.
  ///
  /// In en, this message translates to:
  /// **'Hotel settings'**
  String get hotelSettings;

  /// No description provided for @inHouse.
  ///
  /// In en, this message translates to:
  /// **'In-house'**
  String get inHouse;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get inactive;

  /// No description provided for @internalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal notes'**
  String get internalNotes;

  /// No description provided for @kind.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get kind;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @lateRefundPercent.
  ///
  /// In en, this message translates to:
  /// **'Refund after free period %'**
  String get lateRefundPercent;

  /// No description provided for @leadTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Order ahead (minutes)'**
  String get leadTimeMin;

  /// No description provided for @leaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Leave requests'**
  String get leaveRequests;

  /// No description provided for @loyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty points'**
  String get loyalty;

  /// No description provided for @markNoShow.
  ///
  /// In en, this message translates to:
  /// **'Mark no-show'**
  String get markNoShow;

  /// No description provided for @maxGuests.
  ///
  /// In en, this message translates to:
  /// **'Max guests'**
  String get maxGuests;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @menu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// No description provided for @mine.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get mine;

  /// No description provided for @missingToPublish.
  ///
  /// In en, this message translates to:
  /// **'Missing before publishing'**
  String get missingToPublish;

  /// No description provided for @myDepartment.
  ///
  /// In en, this message translates to:
  /// **'My department'**
  String get myDepartment;

  /// No description provided for @myLeave.
  ///
  /// In en, this message translates to:
  /// **'My leave'**
  String get myLeave;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'My requests'**
  String get myRequests;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @netToday.
  ///
  /// In en, this message translates to:
  /// **'Net today'**
  String get netToday;

  /// No description provided for @network.
  ///
  /// In en, this message translates to:
  /// **'Network'**
  String get network;

  /// No description provided for @newQr.
  ///
  /// In en, this message translates to:
  /// **'New QR code'**
  String get newQr;

  /// No description provided for @newQrWarning.
  ///
  /// In en, this message translates to:
  /// **'The old code for this table will stop working.'**
  String get newQrWarning;

  /// No description provided for @nextTier.
  ///
  /// In en, this message translates to:
  /// **'{points} more points to {tier}'**
  String nextTier(String points, String tier);

  /// No description provided for @nothingHere.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet.'**
  String get nothingHere;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found.'**
  String get notFound;

  /// No description provided for @occupancyTonight.
  ///
  /// In en, this message translates to:
  /// **'Occupancy tonight'**
  String get occupancyTonight;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @openTasks.
  ///
  /// In en, this message translates to:
  /// **'Open tasks'**
  String get openTasks;

  /// No description provided for @opens.
  ///
  /// In en, this message translates to:
  /// **'Opens'**
  String get opens;

  /// No description provided for @options.
  ///
  /// In en, this message translates to:
  /// **'Options'**
  String get options;

  /// No description provided for @orderStatus.
  ///
  /// In en, this message translates to:
  /// **'Your order'**
  String get orderStatus;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @payAtOutlet.
  ///
  /// In en, this message translates to:
  /// **'Pay at the table / outlet'**
  String get payAtOutlet;

  /// No description provided for @payOnline.
  ///
  /// In en, this message translates to:
  /// **'Pay online'**
  String get payOnline;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentMethod;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'Payments & refunds'**
  String get payments;

  /// No description provided for @pendingApproval.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pendingApproval;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photos;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @pointsBalance.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String pointsBalance(String points);

  /// No description provided for @pointsCost.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String pointsCost(String points);

  /// No description provided for @pointsPlusMinus.
  ///
  /// In en, this message translates to:
  /// **'Points (+ add, − remove)'**
  String get pointsPlusMinus;

  /// No description provided for @preferredTime.
  ///
  /// In en, this message translates to:
  /// **'Preferred time'**
  String get preferredTime;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @priceDelta.
  ///
  /// In en, this message translates to:
  /// **'Extra price'**
  String get priceDelta;

  /// No description provided for @priceModel.
  ///
  /// In en, this message translates to:
  /// **'Price model'**
  String get priceModel;

  /// No description provided for @priceOnQuote.
  ///
  /// In en, this message translates to:
  /// **'Price on request'**
  String get priceOnQuote;

  /// No description provided for @pricePerItem.
  ///
  /// In en, this message translates to:
  /// **'{price} each'**
  String pricePerItem(String price);

  /// No description provided for @pricePerNight2.
  ///
  /// In en, this message translates to:
  /// **'{price} per night'**
  String pricePerNight2(String price);

  /// No description provided for @pricePerPerson.
  ///
  /// In en, this message translates to:
  /// **'{price} per person'**
  String pricePerPerson(String price);

  /// No description provided for @publish.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publish;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @qrCode.
  ///
  /// In en, this message translates to:
  /// **'QR code'**
  String get qrCode;

  /// No description provided for @rates.
  ///
  /// In en, this message translates to:
  /// **'Rates'**
  String get rates;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @redeemNeedsStay.
  ///
  /// In en, this message translates to:
  /// **'Points can be used on a confirmed or current stay.'**
  String get redeemNeedsStay;

  /// No description provided for @redeemed.
  ///
  /// In en, this message translates to:
  /// **'Applied to your stay'**
  String get redeemed;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @refunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get refunded;

  /// No description provided for @refundedToday.
  ///
  /// In en, this message translates to:
  /// **'Refunded today'**
  String get refundedToday;

  /// No description provided for @reissueWifi.
  ///
  /// In en, this message translates to:
  /// **'Re-issue Wi-Fi'**
  String get reissueWifi;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @removeAccess.
  ///
  /// In en, this message translates to:
  /// **'Remove staff access'**
  String get removeAccess;

  /// No description provided for @reportOccupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get reportOccupancy;

  /// No description provided for @reportRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportRevenue;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @requestStatus.
  ///
  /// In en, this message translates to:
  /// **'Request status'**
  String get requestStatus;

  /// No description provided for @requireApproval.
  ///
  /// In en, this message translates to:
  /// **'Staff approve each paid booking'**
  String get requireApproval;

  /// No description provided for @reservation.
  ///
  /// In en, this message translates to:
  /// **'Reservation'**
  String get reservation;

  /// No description provided for @reservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get reservations;

  /// No description provided for @restaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurant;

  /// No description provided for @restaurantOrders.
  ///
  /// In en, this message translates to:
  /// **'Restaurant orders'**
  String get restaurantOrders;

  /// No description provided for @reviewOrder.
  ///
  /// In en, this message translates to:
  /// **'Review order ({count}) · {total}'**
  String reviewOrder(String count, String total);

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @roomLabel.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get roomLabel;

  /// No description provided for @roomTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Room type'**
  String get roomTypeLabel;

  /// No description provided for @roomsAndRates.
  ///
  /// In en, this message translates to:
  /// **'Rooms & rates'**
  String get roomsAndRates;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @saveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get saveDraft;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @scanTable.
  ///
  /// In en, this message translates to:
  /// **'Order food (scan table QR)'**
  String get scanTable;

  /// No description provided for @scanTableHint.
  ///
  /// In en, this message translates to:
  /// **'Point the camera at the QR code on your table.'**
  String get scanTableHint;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @searchGuest.
  ///
  /// In en, this message translates to:
  /// **'Search name, email, phone or code'**
  String get searchGuest;

  /// No description provided for @sendQuote.
  ///
  /// In en, this message translates to:
  /// **'Send quote'**
  String get sendQuote;

  /// No description provided for @sendRequest.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get sendRequest;

  /// No description provided for @serviceBuilder.
  ///
  /// In en, this message translates to:
  /// **'Service builder'**
  String get serviceBuilder;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @setRate.
  ///
  /// In en, this message translates to:
  /// **'Set price for dates'**
  String get setRate;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @staffAndLeave.
  ///
  /// In en, this message translates to:
  /// **'Staff & leave'**
  String get staffAndLeave;

  /// No description provided for @staffApproval.
  ///
  /// In en, this message translates to:
  /// **'Staff accepts each request'**
  String get staffApproval;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @statusSteps.
  ///
  /// In en, this message translates to:
  /// **'Status steps'**
  String get statusSteps;

  /// No description provided for @submitOrder.
  ///
  /// In en, this message translates to:
  /// **'Submit order'**
  String get submitOrder;

  /// No description provided for @tableLabel.
  ///
  /// In en, this message translates to:
  /// **'Table {table}'**
  String tableLabel(String table);

  /// No description provided for @tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// No description provided for @taxIncluded.
  ///
  /// In en, this message translates to:
  /// **'Price includes tax'**
  String get taxIncluded;

  /// No description provided for @tempPassword.
  ///
  /// In en, this message translates to:
  /// **'Temporary password'**
  String get tempPassword;

  /// No description provided for @tier.
  ///
  /// In en, this message translates to:
  /// **'Tier: {tier}'**
  String tier(String tier);

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message'**
  String get typeMessage;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @unblock.
  ///
  /// In en, this message translates to:
  /// **'Unblock'**
  String get unblock;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @validUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get validUntil;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wifi;

  /// No description provided for @wifiMode.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi mode (portal or psk)'**
  String get wifiMode;

  /// No description provided for @wifiPortalHint.
  ///
  /// In en, this message translates to:
  /// **'Join the network; the login page opens. Enter the username and password above.'**
  String get wifiPortalHint;

  /// No description provided for @wifiQrHint.
  ///
  /// In en, this message translates to:
  /// **'Scan with your camera to join.'**
  String get wifiQrHint;

  /// No description provided for @wifiSharedPassword.
  ///
  /// In en, this message translates to:
  /// **'Shared Wi-Fi password (psk mode)'**
  String get wifiSharedPassword;

  /// No description provided for @webGuestTitle.
  ///
  /// In en, this message translates to:
  /// **'Guests, please use the Tuloy mobile app'**
  String get webGuestTitle;

  /// No description provided for @webGuestBody.
  ///
  /// In en, this message translates to:
  /// **'Booking and stay features are available in the iOS and Android app. Staff and admins can sign in here.'**
  String get webGuestBody;

  /// No description provided for @action.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action;

  /// No description provided for @entity.
  ///
  /// In en, this message translates to:
  /// **'Entity'**
  String get entity;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @actor.
  ///
  /// In en, this message translates to:
  /// **'Actor'**
  String get actor;

  /// No description provided for @navOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get navOverview;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @navPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get navPeople;

  /// No description provided for @navSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get navSystem;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @needsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get needsAttention;

  /// No description provided for @allClear.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs attention'**
  String get allClear;

  /// No description provided for @unreadChats.
  ///
  /// In en, this message translates to:
  /// **'Unread chats'**
  String get unreadChats;

  /// No description provided for @myTasks.
  ///
  /// In en, this message translates to:
  /// **'My tasks'**
  String get myTasks;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @viewLabel.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get viewLabel;

  /// No description provided for @sortedAscending.
  ///
  /// In en, this message translates to:
  /// **'Sorted ascending'**
  String get sortedAscending;

  /// No description provided for @sortedDescending.
  ///
  /// In en, this message translates to:
  /// **'Sorted descending'**
  String get sortedDescending;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by {column}'**
  String sortBy(String column);

  /// No description provided for @rowsShown.
  ///
  /// In en, this message translates to:
  /// **'{shown} of {total}'**
  String rowsShown(int shown, int total);

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get rooms;

  /// No description provided for @tables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get tables;

  /// No description provided for @showDetails.
  ///
  /// In en, this message translates to:
  /// **'Show details'**
  String get showDetails;

  /// No description provided for @hideDetails.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get hideDetails;

  /// No description provided for @selectThread.
  ///
  /// In en, this message translates to:
  /// **'Select a conversation'**
  String get selectThread;

  /// No description provided for @keyboardShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get keyboardShortcuts;

  /// No description provided for @goToPage.
  ///
  /// In en, this message translates to:
  /// **'Go to a page'**
  String get goToPage;

  /// No description provided for @shortcutSearch.
  ///
  /// In en, this message translates to:
  /// **'Search this page'**
  String get shortcutSearch;

  /// No description provided for @shortcutClose.
  ///
  /// In en, this message translates to:
  /// **'Close a panel or dialog'**
  String get shortcutClose;

  /// No description provided for @shortcutHelp.
  ///
  /// In en, this message translates to:
  /// **'Show keyboard shortcuts'**
  String get shortcutHelp;

  /// No description provided for @shortcutSend.
  ///
  /// In en, this message translates to:
  /// **'Send a chat message (Shift+Enter: new line)'**
  String get shortcutSend;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ceb', 'en', 'fil'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ceb':
      return AppLocalizationsCeb();
    case 'en':
      return AppLocalizationsEn();
    case 'fil':
      return AppLocalizationsFil();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
