// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Anmelden';

  @override
  String get signUp => 'Konto erstellen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get noAccount => 'Noch kein Konto?';

  @override
  String get haveAccount => 'Schon ein Konto?';

  @override
  String get emailOrPhone => 'E-Mail oder Telefonnummer';

  @override
  String get password => 'Passwort';

  @override
  String get passwordHint => 'Mindestens 8 Zeichen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get required => 'Pflichtfeld';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get sendCode => 'Code senden';

  @override
  String get codeSent =>
      'Falls ein Konto existiert, haben wir einen 6-stelligen Code gesendet.';

  @override
  String get code => '6-stelliger Code';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get passwordChanged => 'Passwort geändert. Bitte melden Sie sich an.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get language => 'Sprache';

  @override
  String get guestHome => 'Willkommen';

  @override
  String get staffHome => 'Personal';

  @override
  String get adminHome => 'Verwaltung';

  @override
  String get comingSoon => 'Weitere Funktionen folgen im nächsten Release.';

  @override
  String get errorGeneric =>
      'Server nicht erreichbar. Prüfen Sie Ihre Verbindung.';

  @override
  String get cannotReachServer =>
      'Server nicht erreichbar. Prüfen Sie Ihre Verbindung oder bitten Sie den Administrator, diese Website zuzulassen.';

  @override
  String hello(String name) {
    return 'Hallo, $name';
  }

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get howCanWeHelp => 'Wie können wir helfen?';

  @override
  String get profile => 'Profil';

  @override
  String get stays => 'Aufenthalte';

  @override
  String get servicesUsed => 'Genutzte Services';

  @override
  String get paymentHistory => 'Zahlungsverlauf';

  @override
  String get cardOrEwallet => 'Karte / E-Wallet';

  @override
  String get testPayment => 'Testzahlung';

  @override
  String get noneYet => 'Noch nichts vorhanden';

  @override
  String get gettingHere => 'Anreise';

  @override
  String get openInMaps => 'In Karten öffnen';

  @override
  String get airportRoute => 'Route zum Flughafen';

  @override
  String get personalDetails => 'Persönliche Daten';

  @override
  String get authTagline =>
      'Ihr Aufenthalt und alle Services, mit einem Tippen';

  @override
  String get showPassword => 'Passwort anzeigen';

  @override
  String get hidePassword => 'Passwort verbergen';

  @override
  String get findRoom => 'Zimmer finden';

  @override
  String get adults => 'Erwachsene';

  @override
  String get children => 'Kinder';

  @override
  String get guests => 'Gäste';

  @override
  String nightsCount(String count) {
    return 'Nächte: $count';
  }

  @override
  String get noRooms =>
      'Für diese Daten sind keine Zimmer frei. Versuchen Sie andere Daten.';

  @override
  String perNight(String price) {
    return '$price / Nacht';
  }

  @override
  String roomsLeft(String count) {
    return 'Nur noch $count frei';
  }

  @override
  String get totalLabel => 'Gesamt';

  @override
  String get amenities => 'Ausstattung';

  @override
  String get policies => 'Richtlinien';

  @override
  String checkInTime(String time) {
    return 'Check-in ab $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out bis $time';
  }

  @override
  String get specialRequests => 'Besondere Wünsche (optional)';

  @override
  String get reserve => 'Reservieren';

  @override
  String get review => 'Prüfen und bezahlen';

  @override
  String holdTimer(String time) {
    return 'Wir halten dieses Zimmer für $time für Sie frei';
  }

  @override
  String get holdExpired =>
      'Die Reservierungsfrist ist abgelaufen. Bitte erneut suchen.';

  @override
  String get serviceCharge => 'Servicegebühr';

  @override
  String get vat => 'MwSt.';

  @override
  String payDeposit(String amount) {
    return 'Anzahlung zahlen $amount';
  }

  @override
  String payFull(String amount) {
    return 'Vollständig zahlen $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Restbetrag zahlen $amount';
  }

  @override
  String get waitingPayment => 'Warten auf Zahlung…';

  @override
  String get waitingPaymentHint =>
      'Schließen Sie die Zahlung im Browser ab. Diese Seite aktualisiert sich selbst.';

  @override
  String get openPaymentAgain => 'Zahlungsseite erneut öffnen';

  @override
  String get bookingConfirmed => 'Buchung bestätigt!';

  @override
  String bookingCode(String code) {
    return 'Buchung $code';
  }

  @override
  String roomNumber(String room) {
    return 'Zimmer $room';
  }

  @override
  String get viewBooking => 'Buchung ansehen';

  @override
  String get backHome => 'Zur Startseite';

  @override
  String get paymentFailed =>
      'Diese Buchung ist nicht mehr reserviert. Falls Sie belastet wurden, erhalten Sie eine Erstattung.';

  @override
  String get myBookings => 'Meine Buchungen';

  @override
  String get noBookings => 'Noch keine Buchungen.';

  @override
  String get statusHold => 'Zahlung ausstehend';

  @override
  String get statusPending => 'Ausstehend';

  @override
  String get statusConfirmed => 'Bestätigt';

  @override
  String get statusCheckedIn => 'Eingecheckt';

  @override
  String get statusCheckedOut => 'Ausgecheckt';

  @override
  String get statusCancelled => 'Storniert';

  @override
  String get statusNoShow => 'Nicht erschienen';

  @override
  String get statusDeclined => 'Abgelehnt';

  @override
  String get statusExpired => 'Abgelaufen';

  @override
  String get cancelBooking => 'Buchung stornieren';

  @override
  String cancelConfirm(String refund) {
    return 'Diese Buchung stornieren? Sie erhalten $refund zurück.';
  }

  @override
  String get keepBooking => 'Buchung behalten';

  @override
  String get cancelled => 'Buchung storniert';

  @override
  String get invoice => 'Rechnung';

  @override
  String get paid => 'Bezahlt';

  @override
  String get balance => 'Restbetrag';

  @override
  String get charges => 'Kosten';

  @override
  String get myStay => 'Mein Aufenthalt';

  @override
  String get currentStay => 'Ihr Aufenthalt';

  @override
  String get hotelGuide => 'Hotelinfo';

  @override
  String get feedback => 'Feedback';

  @override
  String get rateStay => 'Wie war Ihr Aufenthalt?';

  @override
  String get comment => 'Kommentar (optional)';

  @override
  String get send => 'Senden';

  @override
  String get thanksFeedback => 'Danke für Ihr Feedback!';

  @override
  String get accept => 'Annehmen';

  @override
  String acceptQuote(String amount) {
    return 'Angebot annehmen $amount';
  }

  @override
  String get acceptance => 'Annahme';

  @override
  String get active => 'Aktiv';

  @override
  String get add => 'Hinzufügen';

  @override
  String get addField => 'Feld hinzufügen';

  @override
  String get addOption => 'Option hinzufügen';

  @override
  String get addOutlet => 'Verkaufsstelle hinzufügen';

  @override
  String get addPhoto => 'Foto hinzufügen';

  @override
  String get addRoom => 'Zimmer hinzufügen';

  @override
  String get addStaff => 'Mitarbeiter hinzufügen';

  @override
  String get addTable => 'Tisch hinzufügen';

  @override
  String get adjustPoints => 'Punkte anpassen';

  @override
  String get alerts => 'Hinweise';

  @override
  String get all => 'Alle';

  @override
  String get allergens => 'Allergene';

  @override
  String get allergyNotes => 'Allergien oder besondere Hinweise';

  @override
  String get amount => 'Betrag';

  @override
  String get applyLeave => 'Urlaub beantragen';

  @override
  String get approve => 'Genehmigen';

  @override
  String get approved => 'Genehmigt';

  @override
  String get arrivals => 'Anreisen';

  @override
  String get asSoonAsPossible => 'So bald wie möglich';

  @override
  String get auditLog => 'Prüfprotokoll';

  @override
  String get autoAccept => 'Automatisch annehmen';

  @override
  String get basePrice => 'Grundpreis';

  @override
  String get blocks => 'Zimmersperren';

  @override
  String get body => 'Text';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancelOrder => 'Bestellung stornieren';

  @override
  String get cancelRequest => 'Anfrage stornieren';

  @override
  String get cancellationPolicy => 'Stornobedingungen';

  @override
  String get category => 'Kategorie';

  @override
  String get chargeToRoom => 'Auf mein Zimmer buchen';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Schreiben Sie der Rezeption.';

  @override
  String get chatWithHotel => 'Mit dem Hotel chatten';

  @override
  String get checkInAction => 'Einchecken';

  @override
  String get checkOutAction => 'Auschecken';

  @override
  String get choices => 'Auswahl (durch Kommas getrennt)';

  @override
  String get closes => 'Schließt';

  @override
  String get codeLabel => 'Code';

  @override
  String get collectedToday => 'Heute kassiert';

  @override
  String get content => 'Infos und Angebote';

  @override
  String get copied => 'Kopiert';

  @override
  String get copy => 'Kopieren';

  @override
  String get copyCsv => 'Als CSV kopieren';

  @override
  String get dates => 'Daten';

  @override
  String get decline => 'Ablehnen';

  @override
  String get delete => 'Löschen';

  @override
  String get department => 'Abteilung';

  @override
  String get departments => 'Abteilungen';

  @override
  String get departures => 'Abreisen';

  @override
  String get depositPercent => 'Anzahlung %';

  @override
  String get description => 'Beschreibung';

  @override
  String get draft => 'Entwurf';

  @override
  String get earnPer100 => 'Punkte pro ₱100';

  @override
  String earnRate(String points) {
    return 'Sie erhalten $points Punkt(e) pro ₱100.';
  }

  @override
  String get earnsPoints => 'Sammelt Treuepunkte';

  @override
  String get email => 'E-Mail';

  @override
  String get emptyResets => 'leer = Grundpreis';

  @override
  String get enterCode => 'Code eingeben';

  @override
  String get escalate => 'Eskalieren';

  @override
  String get etaMin => 'Fertig in (Minuten)';

  @override
  String etaMinutes(String minutes) {
    return 'Fertig in etwa $minutes Min.';
  }

  @override
  String get failedNotifications => 'Fehlgeschlagene Benachrichtigungen';

  @override
  String get failedRefunds => 'Fehlgeschlagene Erstattungen';

  @override
  String get fieldKey => 'Feldschlüssel';

  @override
  String get formFields => 'Formularfelder für Gäste';

  @override
  String get free => 'Frei';

  @override
  String get freeCancelHours => 'Kostenlose Stornierung (Stunden vor Check-in)';

  @override
  String get frontDesk => 'Rezeption';

  @override
  String get history => 'Verlauf';

  @override
  String get hotelName => 'Hotelname';

  @override
  String get hotelSettings => 'Hoteleinstellungen';

  @override
  String get inHouse => 'Im Haus';

  @override
  String get inactive => 'inaktiv';

  @override
  String get internalNotes => 'Interne Notizen';

  @override
  String get kind => 'Art';

  @override
  String get label => 'Bezeichnung';

  @override
  String get lateRefundPercent => 'Erstattung nach Gratisfrist %';

  @override
  String get leadTimeMin => 'Vorbestellzeit (Minuten)';

  @override
  String get leaveRequests => 'Urlaubsanträge';

  @override
  String get loyalty => 'Treuepunkte';

  @override
  String get markNoShow => 'Als nicht erschienen markieren';

  @override
  String get maxGuests => 'Max. Gäste';

  @override
  String get members => 'Mitglieder';

  @override
  String get menu => 'Speisekarte';

  @override
  String get mine => 'Meine';

  @override
  String get missingToPublish => 'Fehlt vor der Veröffentlichung';

  @override
  String get myDepartment => 'Meine Abteilung';

  @override
  String get myLeave => 'Mein Urlaub';

  @override
  String get myRequests => 'Meine Anfragen';

  @override
  String get name => 'Name';

  @override
  String get netToday => 'Netto heute';

  @override
  String get network => 'Netzwerk';

  @override
  String get newQr => 'Neuer QR-Code';

  @override
  String get newQrWarning =>
      'Der alte Code dieses Tisches funktioniert dann nicht mehr.';

  @override
  String nextTier(String points, String tier) {
    return 'Noch $points Punkte bis $tier';
  }

  @override
  String get nothingHere => 'Noch nichts vorhanden.';

  @override
  String get notFound => 'Nicht gefunden.';

  @override
  String get occupancyTonight => 'Belegung heute Nacht';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Offene Aufgaben';

  @override
  String get opens => 'Öffnet';

  @override
  String get options => 'Optionen';

  @override
  String get orderStatus => 'Ihre Bestellung';

  @override
  String get pause => 'Pausieren';

  @override
  String get payAtOutlet => 'Am Tisch / an der Verkaufsstelle zahlen';

  @override
  String get payOnline => 'Online zahlen';

  @override
  String get paymentMethod => 'Zahlung';

  @override
  String get payments => 'Zahlungen und Erstattungen';

  @override
  String get pendingApproval => 'Ausstehend';

  @override
  String get permissions => 'Berechtigungen';

  @override
  String get photos => 'Fotos';

  @override
  String get points => 'Punkte';

  @override
  String pointsBalance(String points) {
    return '$points Punkte';
  }

  @override
  String pointsCost(String points) {
    return '$points Punkte';
  }

  @override
  String get pointsPlusMinus => 'Punkte (+ hinzufügen, − abziehen)';

  @override
  String get preferredTime => 'Wunschzeit';

  @override
  String get price => 'Preis';

  @override
  String get priceDelta => 'Aufpreis';

  @override
  String get priceModel => 'Preismodell';

  @override
  String get priceOnQuote => 'Preis auf Anfrage';

  @override
  String pricePerItem(String price) {
    return '$price pro Stück';
  }

  @override
  String pricePerNight2(String price) {
    return '$price pro Nacht';
  }

  @override
  String pricePerPerson(String price) {
    return '$price pro Person';
  }

  @override
  String get publish => 'Veröffentlichen';

  @override
  String get published => 'Veröffentlicht';

  @override
  String get qrCode => 'QR-Code';

  @override
  String get rates => 'Preise';

  @override
  String get reason => 'Grund';

  @override
  String get redeem => 'Einlösen';

  @override
  String get redeemNeedsStay =>
      'Punkte können bei einem bestätigten oder laufenden Aufenthalt eingelöst werden.';

  @override
  String get redeemed => 'Auf Ihren Aufenthalt angerechnet';

  @override
  String get refund => 'Erstattung';

  @override
  String get refunded => 'Erstattet';

  @override
  String get refundedToday => 'Heute erstattet';

  @override
  String get reissueWifi => 'WLAN neu ausstellen';

  @override
  String get rejected => 'Abgelehnt';

  @override
  String get removeAccess => 'Mitarbeiterzugang entfernen';

  @override
  String get reportOccupancy => 'Belegung';

  @override
  String get reportRevenue => 'Umsatz';

  @override
  String get reports => 'Berichte';

  @override
  String get requestStatus => 'Status der Anfrage';

  @override
  String get requireApproval => 'Personal bestätigt jede bezahlte Buchung';

  @override
  String get reservation => 'Reservierung';

  @override
  String get reservations => 'Reservierungen';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantOrders => 'Restaurantbestellungen';

  @override
  String reviewOrder(String count, String total) {
    return 'Bestellung prüfen ($count) · $total';
  }

  @override
  String get rewards => 'Prämien';

  @override
  String get role => 'Rolle';

  @override
  String get roomLabel => 'Zimmer';

  @override
  String get roomTypeLabel => 'Zimmertyp';

  @override
  String get roomsAndRates => 'Zimmer und Preise';

  @override
  String get save => 'Speichern';

  @override
  String get saveDraft => 'Entwurf speichern';

  @override
  String get saved => 'Gespeichert';

  @override
  String get scanTable => 'Essen bestellen (Tisch-QR scannen)';

  @override
  String get scanTableHint =>
      'Richten Sie die Kamera auf den QR-Code auf Ihrem Tisch.';

  @override
  String get schedule => 'Zeitplan';

  @override
  String get searchGuest => 'Name, E-Mail, Telefon oder Code suchen';

  @override
  String get sendQuote => 'Angebot senden';

  @override
  String get sendRequest => 'Anfrage senden';

  @override
  String get serviceBuilder => 'Service-Editor';

  @override
  String get services => 'Services';

  @override
  String get setRate => 'Preis für Daten festlegen';

  @override
  String get staff => 'Personal';

  @override
  String get staffAndLeave => 'Personal und Urlaub';

  @override
  String get staffApproval => 'Personal nimmt jede Anfrage an';

  @override
  String get status => 'Status';

  @override
  String get statusSteps => 'Statusschritte';

  @override
  String get submitOrder => 'Bestellung absenden';

  @override
  String tableLabel(String table) {
    return 'Tisch $table';
  }

  @override
  String get tasks => 'Aufgaben';

  @override
  String get taxIncluded => 'Preis inkl. Steuern';

  @override
  String get tempPassword => 'Temporäres Passwort';

  @override
  String tier(String tier) {
    return 'Stufe: $tier';
  }

  @override
  String get title => 'Titel';

  @override
  String get typeMessage => 'Nachricht schreiben';

  @override
  String get unassigned => 'Nicht zugewiesen';

  @override
  String get unblock => 'Freigeben';

  @override
  String get upcoming => 'Bevorstehend';

  @override
  String get username => 'Benutzername';

  @override
  String get validUntil => 'Gültig bis';

  @override
  String get wifi => 'WLAN';

  @override
  String get wifiMode => 'WLAN-Modus (portal oder psk)';

  @override
  String get wifiPortalHint =>
      'Verbinden Sie sich mit dem Netzwerk; die Anmeldeseite öffnet sich. Geben Sie oben Benutzername und Passwort ein.';

  @override
  String get wifiQrHint => 'Mit der Kamera scannen, um sich zu verbinden.';

  @override
  String get wifiSharedPassword => 'Gemeinsames WLAN-Passwort (psk-Modus)';

  @override
  String get action => 'Aktion';

  @override
  String get entity => 'Objekt';

  @override
  String get dateLabel => 'Datum';

  @override
  String get actor => 'Ausgeführt von';

  @override
  String get navOverview => 'Übersicht';

  @override
  String get navCatalog => 'Katalog';

  @override
  String get navFinance => 'Finanzen';

  @override
  String get navPeople => 'Personen';

  @override
  String get navSystem => 'System';

  @override
  String get details => 'Details';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get needsAttention => 'Erfordert Aufmerksamkeit';

  @override
  String get allClear => 'Nichts zu erledigen';

  @override
  String get unreadChats => 'Ungelesene Chats';

  @override
  String get myTasks => 'Meine Aufgaben';

  @override
  String get search => 'Suchen';

  @override
  String get showMore => 'Mehr anzeigen';

  @override
  String get viewLabel => 'Ansicht';

  @override
  String get sortedAscending => 'Aufsteigend sortiert';

  @override
  String get sortedDescending => 'Absteigend sortiert';

  @override
  String sortBy(String column) {
    return 'Nach $column sortieren';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown von $total';
  }

  @override
  String get note => 'Notiz';

  @override
  String get rooms => 'Zimmer';

  @override
  String get tables => 'Tische';

  @override
  String get showDetails => 'Details anzeigen';

  @override
  String get hideDetails => 'Details verbergen';

  @override
  String get selectThread => 'Unterhaltung auswählen';

  @override
  String get keyboardShortcuts => 'Tastenkürzel';

  @override
  String get goToPage => 'Zu einer Seite gehen';

  @override
  String get shortcutSearch => 'Auf dieser Seite suchen';

  @override
  String get shortcutClose => 'Bereich oder Dialog schließen';

  @override
  String get shortcutHelp => 'Tastenkürzel anzeigen';

  @override
  String get shortcutSend => 'Nachricht senden (Umschalt+Enter: neue Zeile)';

  @override
  String get roomBoard => 'Zimmer heute';

  @override
  String get roomOccupied => 'Belegt';

  @override
  String get roomDeparting => 'Abreise heute';

  @override
  String get roomArriving => 'Anreise heute';

  @override
  String get roomReserved => 'Reserviert';

  @override
  String get roomBlocked => 'Gesperrt';

  @override
  String freeOf(String free, String total) {
    return '$free von $total frei';
  }

  @override
  String get todaysArrivals => 'Heutige Anreisen';

  @override
  String get todaysDepartures => 'Heutige Abreisen';

  @override
  String get guestList => 'Gästeliste';

  @override
  String get team => 'Team';

  @override
  String get lastStay => 'Letzter Aufenthalt';

  @override
  String get roleAdmin => 'Verwaltung';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get notifBooking => 'Neue Buchung';

  @override
  String get notifPending => 'Buchung muss bestätigt werden';

  @override
  String get notifCancelled => 'Buchung storniert';

  @override
  String get notifRequest => 'Neue Serviceanfrage';

  @override
  String get notifOrder => 'Neue Essensbestellung';

  @override
  String get notifMessage => 'Neue Nachricht';

  @override
  String staffCancelConfirm(String refund) {
    return 'Diese Buchung stornieren? Gemäß Stornobedingungen erhält der Gast $refund zurück.';
  }

  @override
  String get phone => 'Telefon';

  @override
  String get appearance => 'Darstellung';

  @override
  String get themeSystem => 'Wie Gerät';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get roomAvailable => 'Frei';

  @override
  String get availableOnly => 'Nur freie';

  @override
  String get floor => 'Etage';

  @override
  String get allRoomTypes => 'Alle Zimmertypen';

  @override
  String get guestLabel => 'Gast';

  @override
  String get rowNo => 'Nr.';

  @override
  String get employeeId => 'Personalnummer';

  @override
  String get photo => 'Foto';

  @override
  String get dateFrom => 'Von';

  @override
  String get dateTo => 'Bis';

  @override
  String get leaveType => 'Art des Urlaubs';

  @override
  String get leaveVacation => 'Urlaub';

  @override
  String get leaveSick => 'Krankheit';

  @override
  String get leaveEmergency => 'Notfall';

  @override
  String get leaveOther => 'Sonstiges';

  @override
  String get submit => 'Absenden';

  @override
  String get cash => 'Bar';

  @override
  String get card => 'Karte';

  @override
  String get arrival => 'Anreise';

  @override
  String get departure => 'Abreise';

  @override
  String get serviceRequests => 'Serviceanfragen';

  @override
  String get newRequest => 'Neue Anfrage';

  @override
  String get guestBooking => 'Buchung des Gastes';

  @override
  String bookRoom(String room) {
    return 'Zimmer $room buchen';
  }

  @override
  String get bookAndCheckIn => 'Buchen und einchecken';

  @override
  String get changeBooking => 'Buchung ändern';

  @override
  String get recordPayment => 'Zahlung erfassen';

  @override
  String get emailOrPhoneRequired =>
      'Geben Sie eine E-Mail oder Telefonnummer ein';

  @override
  String get emailLocked =>
      'Die Anmelde-E-Mail des Gastes kann hier nicht geändert werden.';

  @override
  String get onLeaveToday => 'Im Urlaub';

  @override
  String leaveUpcoming(String dates) {
    return 'Urlaub $dates';
  }

  @override
  String get collapseMenu => 'Menü einklappen';

  @override
  String get expandMenu => 'Menü ausklappen';

  @override
  String get roleRestaurant => 'Restaurantpersonal';

  @override
  String get next => 'Weiter';

  @override
  String get payAtDesk => 'Der Gast zahlt an der Rezeption.';

  @override
  String get notAvailableForDates =>
      'Dieser Zimmertyp ist an diesen Tagen ausgebucht. Versuchen Sie andere Daten oder ein anderes Zimmer.';

  @override
  String get byType => 'Nach Typ';

  @override
  String get byFloor => 'Nach Etage';

  @override
  String floorN(String floor) {
    return 'Etage $floor';
  }

  @override
  String get paymentPaid => 'Bezahlt';

  @override
  String get paymentDeposit => 'Anzahlung bezahlt';

  @override
  String get paymentPartial => 'Teilweise bezahlt';

  @override
  String get paymentUnpaid => 'Nicht bezahlt';

  @override
  String get moreLanguages => 'Weitere Sprachen';
}
