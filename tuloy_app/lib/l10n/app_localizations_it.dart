// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Accedi';

  @override
  String get signUp => 'Crea account';

  @override
  String get signOut => 'Esci';

  @override
  String get noAccount => 'Non hai un account?';

  @override
  String get haveAccount => 'Hai già un account?';

  @override
  String get emailOrPhone => 'Email o numero di telefono';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Almeno 8 caratteri';

  @override
  String get fullName => 'Nome e cognome';

  @override
  String get required => 'Obbligatorio';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get sendCode => 'Invia codice';

  @override
  String get codeSent =>
      'Se l\'account esiste, abbiamo inviato un codice di 6 cifre.';

  @override
  String get code => 'Codice di 6 cifre';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get resetPassword => 'Reimposta password';

  @override
  String get passwordChanged => 'Password modificata. Accedi di nuovo.';

  @override
  String get settings => 'Impostazioni';

  @override
  String get language => 'Lingua';

  @override
  String get guestHome => 'Benvenuto';

  @override
  String get staffHome => 'Personale';

  @override
  String get adminHome => 'Amministrazione';

  @override
  String get comingSoon =>
      'Altre funzioni arriveranno nella prossima versione.';

  @override
  String get errorGeneric =>
      'Impossibile raggiungere il server. Controlla la connessione.';

  @override
  String get cannotReachServer =>
      'Impossibile raggiungere il server. Controlla la connessione o chiedi all\'amministratore di consentire questo sito.';

  @override
  String hello(String name) {
    return 'Ciao, $name';
  }

  @override
  String get retry => 'Riprova';

  @override
  String get howCanWeHelp => 'Come possiamo aiutarti?';

  @override
  String get profile => 'Profilo';

  @override
  String get stays => 'Soggiorni';

  @override
  String get servicesUsed => 'Servizi usati';

  @override
  String get paymentHistory => 'Storico pagamenti';

  @override
  String get cardOrEwallet => 'Carta / portafoglio digitale';

  @override
  String get testPayment => 'Pagamento di prova';

  @override
  String get noneYet => 'Ancora niente';

  @override
  String get gettingHere => 'Come arrivare';

  @override
  String get openInMaps => 'Apri in Mappe';

  @override
  String get airportRoute => 'Percorso per l\'aeroporto';

  @override
  String get personalDetails => 'Dati personali';

  @override
  String get authTagline =>
      'Il tuo soggiorno e ogni servizio, a portata di tocco';

  @override
  String get showPassword => 'Mostra password';

  @override
  String get hidePassword => 'Nascondi password';

  @override
  String get findRoom => 'Cerca una camera';

  @override
  String get adults => 'Adulti';

  @override
  String get children => 'Bambini';

  @override
  String get guests => 'Ospiti';

  @override
  String nightsCount(String count) {
    return 'Notti: $count';
  }

  @override
  String get noRooms =>
      'Nessuna camera disponibile in queste date. Prova altre date.';

  @override
  String perNight(String price) {
    return '$price / notte';
  }

  @override
  String roomsLeft(String count) {
    return 'Solo $count rimaste';
  }

  @override
  String get totalLabel => 'Totale';

  @override
  String get amenities => 'Servizi in camera';

  @override
  String get policies => 'Regole';

  @override
  String checkInTime(String time) {
    return 'Check-in dalle $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Check-out entro le $time';
  }

  @override
  String get specialRequests => 'Richieste speciali (facoltativo)';

  @override
  String get reserve => 'Prenota';

  @override
  String get review => 'Controlla e paga';

  @override
  String holdTimer(String time) {
    return 'Ti teniamo questa camera per $time';
  }

  @override
  String get holdExpired =>
      'La prenotazione temporanea è scaduta. Cerca di nuovo.';

  @override
  String get serviceCharge => 'Costo del servizio';

  @override
  String get vat => 'IVA';

  @override
  String payDeposit(String amount) {
    return 'Paga l\'acconto $amount';
  }

  @override
  String payFull(String amount) {
    return 'Paga tutto $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Paga il saldo $amount';
  }

  @override
  String get waitingPayment => 'In attesa del pagamento…';

  @override
  String get waitingPaymentHint =>
      'Completa il pagamento nel browser. Questa pagina si aggiorna da sola.';

  @override
  String get openPaymentAgain => 'Riapri la pagina di pagamento';

  @override
  String get bookingConfirmed => 'Prenotazione confermata!';

  @override
  String bookingCode(String code) {
    return 'Prenotazione $code';
  }

  @override
  String roomNumber(String room) {
    return 'Camera $room';
  }

  @override
  String get viewBooking => 'Vedi prenotazione';

  @override
  String get backHome => 'Torna alla home';

  @override
  String get paymentFailed =>
      'Questa prenotazione non è più riservata. Se ti è stato addebitato, verrai rimborsato.';

  @override
  String get myBookings => 'Le mie prenotazioni';

  @override
  String get noBookings => 'Nessuna prenotazione.';

  @override
  String get statusHold => 'In attesa di pagamento';

  @override
  String get statusPending => 'In attesa';

  @override
  String get statusConfirmed => 'Confermata';

  @override
  String get statusCheckedIn => 'Check-in fatto';

  @override
  String get statusCheckedOut => 'Check-out fatto';

  @override
  String get statusCancelled => 'Annullata';

  @override
  String get statusNoShow => 'Mancata presentazione';

  @override
  String get statusDeclined => 'Rifiutata';

  @override
  String get statusExpired => 'Scaduta';

  @override
  String get cancelBooking => 'Annulla prenotazione';

  @override
  String cancelConfirm(String refund) {
    return 'Annullare questa prenotazione? Ti verranno rimborsati $refund.';
  }

  @override
  String get keepBooking => 'Mantieni prenotazione';

  @override
  String get cancelled => 'Prenotazione annullata';

  @override
  String get invoice => 'Fattura';

  @override
  String get paid => 'Pagato';

  @override
  String get balance => 'Saldo';

  @override
  String get charges => 'Addebiti';

  @override
  String get myStay => 'Il mio soggiorno';

  @override
  String get currentStay => 'Il tuo soggiorno';

  @override
  String get hotelGuide => 'Guida dell\'hotel';

  @override
  String get feedback => 'Recensione';

  @override
  String get rateStay => 'Com\'è andato il soggiorno?';

  @override
  String get comment => 'Commenti (facoltativo)';

  @override
  String get send => 'Invia';

  @override
  String get thanksFeedback => 'Grazie per il tuo parere!';

  @override
  String get accept => 'Accetta';

  @override
  String acceptQuote(String amount) {
    return 'Accetta preventivo $amount';
  }

  @override
  String get acceptance => 'Accettazione';

  @override
  String get active => 'Attivo';

  @override
  String get add => 'Aggiungi';

  @override
  String get addField => 'Aggiungi campo';

  @override
  String get addOption => 'Aggiungi opzione';

  @override
  String get addOutlet => 'Aggiungi punto vendita';

  @override
  String get addPhoto => 'Aggiungi foto';

  @override
  String get addRoom => 'Aggiungi camera';

  @override
  String get addStaff => 'Aggiungi personale';

  @override
  String get addTable => 'Aggiungi tavolo';

  @override
  String get adjustPoints => 'Modifica punti';

  @override
  String get alerts => 'Avvisi';

  @override
  String get all => 'Tutti';

  @override
  String get allergens => 'Allergeni';

  @override
  String get allergyNotes => 'Allergie o indicazioni particolari';

  @override
  String get amount => 'Importo';

  @override
  String get applyLeave => 'Richiedi permesso';

  @override
  String get approve => 'Approva';

  @override
  String get approved => 'Approvato';

  @override
  String get arrivals => 'Arrivi';

  @override
  String get asSoonAsPossible => 'Il prima possibile';

  @override
  String get auditLog => 'Registro attività';

  @override
  String get autoAccept => 'Accetta automaticamente';

  @override
  String get basePrice => 'Prezzo base';

  @override
  String get blocks => 'Blocchi camere';

  @override
  String get body => 'Testo';

  @override
  String get cancel => 'Annulla';

  @override
  String get cancelOrder => 'Annulla ordine';

  @override
  String get cancelRequest => 'Annulla richiesta';

  @override
  String get cancellationPolicy => 'Condizioni di cancellazione';

  @override
  String get category => 'Categoria';

  @override
  String get chargeToRoom => 'Addebita sulla mia camera';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Scrivi un messaggio alla reception.';

  @override
  String get chatWithHotel => 'Scrivi all\'hotel';

  @override
  String get checkInAction => 'Registra arrivo';

  @override
  String get checkOutAction => 'Registra partenza';

  @override
  String get choices => 'Scelte (separate da virgole)';

  @override
  String get closes => 'Chiude';

  @override
  String get codeLabel => 'Codice';

  @override
  String get collectedToday => 'Incassato oggi';

  @override
  String get content => 'Guide e promozioni';

  @override
  String get copied => 'Copiato';

  @override
  String get copy => 'Copia';

  @override
  String get copyCsv => 'Copia come CSV';

  @override
  String get dates => 'Date';

  @override
  String get decline => 'Rifiuta';

  @override
  String get delete => 'Elimina';

  @override
  String get department => 'Reparto';

  @override
  String get departments => 'Reparti';

  @override
  String get departures => 'Partenze';

  @override
  String get depositPercent => 'Acconto %';

  @override
  String get description => 'Descrizione';

  @override
  String get draft => 'Bozza';

  @override
  String get earnPer100 => 'Punti ogni ₱100';

  @override
  String earnRate(String points) {
    return 'Guadagni $points punto/i ogni ₱100.';
  }

  @override
  String get earnsPoints => 'Fa guadagnare punti fedeltà';

  @override
  String get email => 'Email';

  @override
  String get emptyResets => 'vuoto = prezzo base';

  @override
  String get enterCode => 'Inserisci il codice';

  @override
  String get escalate => 'Segnala';

  @override
  String get etaMin => 'Pronto in (minuti)';

  @override
  String etaMinutes(String minutes) {
    return 'Pronto in circa $minutes min';
  }

  @override
  String get failedNotifications => 'Notifiche non riuscite';

  @override
  String get failedRefunds => 'Rimborsi non riusciti';

  @override
  String get fieldKey => 'Chiave del campo';

  @override
  String get formFields => 'Campi del modulo ospite';

  @override
  String get free => 'Libera';

  @override
  String get freeCancelHours =>
      'Cancellazione gratuita (ore prima del check-in)';

  @override
  String get frontDesk => 'Reception';

  @override
  String get history => 'Cronologia';

  @override
  String get hotelName => 'Nome dell\'hotel';

  @override
  String get hotelSettings => 'Impostazioni hotel';

  @override
  String get inHouse => 'In hotel';

  @override
  String get inactive => 'inattivo';

  @override
  String get internalNotes => 'Note interne';

  @override
  String get kind => 'Tipo';

  @override
  String get label => 'Etichetta';

  @override
  String get lateRefundPercent => 'Rimborso dopo il periodo gratuito %';

  @override
  String get leadTimeMin => 'Ordine in anticipo (minuti)';

  @override
  String get leaveRequests => 'Richieste di permesso';

  @override
  String get loyalty => 'Punti fedeltà';

  @override
  String get markNoShow => 'Segna come non presentato';

  @override
  String get maxGuests => 'Ospiti max';

  @override
  String get members => 'Membri';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Mie';

  @override
  String get missingToPublish => 'Mancante prima della pubblicazione';

  @override
  String get myDepartment => 'Il mio reparto';

  @override
  String get myLeave => 'I miei permessi';

  @override
  String get myRequests => 'Le mie richieste';

  @override
  String get name => 'Nome';

  @override
  String get netToday => 'Netto di oggi';

  @override
  String get network => 'Rete';

  @override
  String get newQr => 'Nuovo codice QR';

  @override
  String get newQrWarning =>
      'Il vecchio codice di questo tavolo non funzionerà più.';

  @override
  String nextTier(String points, String tier) {
    return 'Ancora $points punti per $tier';
  }

  @override
  String get nothingHere => 'Ancora niente.';

  @override
  String get notFound => 'Non trovato.';

  @override
  String get occupancyTonight => 'Occupazione stanotte';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Attività aperte';

  @override
  String get opens => 'Apre';

  @override
  String get options => 'Opzioni';

  @override
  String get orderStatus => 'Il tuo ordine';

  @override
  String get pause => 'Sospendi';

  @override
  String get payAtOutlet => 'Paga al tavolo / al punto vendita';

  @override
  String get payOnline => 'Paga online';

  @override
  String get paymentMethod => 'Pagamento';

  @override
  String get payments => 'Pagamenti e rimborsi';

  @override
  String get pendingApproval => 'In attesa';

  @override
  String get permissions => 'Permessi';

  @override
  String get photos => 'Foto';

  @override
  String get points => 'Punti';

  @override
  String pointsBalance(String points) {
    return '$points punti';
  }

  @override
  String pointsCost(String points) {
    return '$points punti';
  }

  @override
  String get pointsPlusMinus => 'Punti (+ aggiungi, − togli)';

  @override
  String get preferredTime => 'Orario preferito';

  @override
  String get price => 'Prezzo';

  @override
  String get priceDelta => 'Supplemento';

  @override
  String get priceModel => 'Modello di prezzo';

  @override
  String get priceOnQuote => 'Prezzo su richiesta';

  @override
  String pricePerItem(String price) {
    return '$price cadauno';
  }

  @override
  String pricePerNight2(String price) {
    return '$price a notte';
  }

  @override
  String pricePerPerson(String price) {
    return '$price a persona';
  }

  @override
  String get publish => 'Pubblica';

  @override
  String get published => 'Pubblicato';

  @override
  String get qrCode => 'Codice QR';

  @override
  String get rates => 'Tariffe';

  @override
  String get reason => 'Motivo';

  @override
  String get redeem => 'Riscatta';

  @override
  String get redeemNeedsStay =>
      'I punti si usano su un soggiorno confermato o in corso.';

  @override
  String get redeemed => 'Applicato al tuo soggiorno';

  @override
  String get refund => 'Rimborso';

  @override
  String get refunded => 'Rimborsato';

  @override
  String get refundedToday => 'Rimborsato oggi';

  @override
  String get reissueWifi => 'Rigenera Wi-Fi';

  @override
  String get rejected => 'Rifiutato';

  @override
  String get removeAccess => 'Rimuovi accesso personale';

  @override
  String get reportOccupancy => 'Occupazione';

  @override
  String get reportRevenue => 'Ricavi';

  @override
  String get reports => 'Report';

  @override
  String get requestStatus => 'Stato della richiesta';

  @override
  String get requireApproval => 'Il personale approva ogni prenotazione pagata';

  @override
  String get reservation => 'Prenotazione';

  @override
  String get reservations => 'Prenotazioni';

  @override
  String get restaurant => 'Ristorante';

  @override
  String get restaurantOrders => 'Ordini del ristorante';

  @override
  String reviewOrder(String count, String total) {
    return 'Rivedi ordine ($count) · $total';
  }

  @override
  String get rewards => 'Premi';

  @override
  String get role => 'Ruolo';

  @override
  String get roomLabel => 'Camera';

  @override
  String get roomTypeLabel => 'Tipo di camera';

  @override
  String get roomsAndRates => 'Camere e tariffe';

  @override
  String get save => 'Salva';

  @override
  String get saveDraft => 'Salva bozza';

  @override
  String get saved => 'Salvato';

  @override
  String get scanTable => 'Ordina da mangiare (scansiona il QR del tavolo)';

  @override
  String get scanTableHint =>
      'Inquadra con la fotocamera il codice QR sul tavolo.';

  @override
  String get schedule => 'Orari';

  @override
  String get searchGuest => 'Cerca nome, email, telefono o codice';

  @override
  String get sendQuote => 'Invia preventivo';

  @override
  String get sendRequest => 'Invia richiesta';

  @override
  String get serviceBuilder => 'Editor servizi';

  @override
  String get services => 'Servizi';

  @override
  String get setRate => 'Imposta il prezzo per le date';

  @override
  String get staff => 'Personale';

  @override
  String get staffAndLeave => 'Personale e permessi';

  @override
  String get staffApproval => 'Il personale accetta ogni richiesta';

  @override
  String get status => 'Stato';

  @override
  String get statusSteps => 'Fasi di stato';

  @override
  String get submitOrder => 'Invia ordine';

  @override
  String tableLabel(String table) {
    return 'Tavolo $table';
  }

  @override
  String get tasks => 'Attività';

  @override
  String get taxIncluded => 'Prezzo tasse incluse';

  @override
  String get tempPassword => 'Password temporanea';

  @override
  String tier(String tier) {
    return 'Livello: $tier';
  }

  @override
  String get title => 'Titolo';

  @override
  String get typeMessage => 'Scrivi un messaggio';

  @override
  String get unassigned => 'Non assegnata';

  @override
  String get unblock => 'Sblocca';

  @override
  String get upcoming => 'In arrivo';

  @override
  String get username => 'Nome utente';

  @override
  String get validUntil => 'Valido fino al';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Modalità Wi-Fi (portal o psk)';

  @override
  String get wifiPortalHint =>
      'Collegati alla rete; si apre la pagina di accesso. Inserisci nome utente e password qui sopra.';

  @override
  String get wifiQrHint => 'Scansiona con la fotocamera per collegarti.';

  @override
  String get wifiSharedPassword => 'Password Wi-Fi condivisa (modalità psk)';

  @override
  String get action => 'Azione';

  @override
  String get entity => 'Elemento';

  @override
  String get dateLabel => 'Data';

  @override
  String get actor => 'Autore';

  @override
  String get navOverview => 'Panoramica';

  @override
  String get navCatalog => 'Catalogo';

  @override
  String get navFinance => 'Finanza';

  @override
  String get navPeople => 'Persone';

  @override
  String get navSystem => 'Sistema';

  @override
  String get details => 'Dettagli';

  @override
  String get refresh => 'Aggiorna';

  @override
  String get needsAttention => 'Da gestire';

  @override
  String get allClear => 'Niente da gestire';

  @override
  String get unreadChats => 'Chat non lette';

  @override
  String get myTasks => 'Le mie attività';

  @override
  String get search => 'Cerca';

  @override
  String get showMore => 'Mostra altro';

  @override
  String get viewLabel => 'Vista';

  @override
  String get sortedAscending => 'Ordine crescente';

  @override
  String get sortedDescending => 'Ordine decrescente';

  @override
  String sortBy(String column) {
    return 'Ordina per $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown di $total';
  }

  @override
  String get note => 'Nota';

  @override
  String get rooms => 'Camere';

  @override
  String get tables => 'Tavoli';

  @override
  String get showDetails => 'Mostra dettagli';

  @override
  String get hideDetails => 'Nascondi dettagli';

  @override
  String get selectThread => 'Scegli una conversazione';

  @override
  String get keyboardShortcuts => 'Scorciatoie da tastiera';

  @override
  String get goToPage => 'Vai a una pagina';

  @override
  String get shortcutSearch => 'Cerca in questa pagina';

  @override
  String get shortcutClose => 'Chiudi un pannello o una finestra';

  @override
  String get shortcutHelp => 'Mostra le scorciatoie da tastiera';

  @override
  String get shortcutSend => 'Invia un messaggio (Maiusc+Invio: a capo)';

  @override
  String get roomBoard => 'Camere oggi';

  @override
  String get roomOccupied => 'Occupata';

  @override
  String get roomDeparting => 'Partenza oggi';

  @override
  String get roomArriving => 'Arrivo oggi';

  @override
  String get roomReserved => 'Prenotata';

  @override
  String get roomBlocked => 'Bloccata';

  @override
  String freeOf(String free, String total) {
    return '$free di $total disponibili';
  }

  @override
  String get todaysArrivals => 'Arrivi di oggi';

  @override
  String get todaysDepartures => 'Partenze di oggi';

  @override
  String get guestList => 'Elenco ospiti';

  @override
  String get team => 'Team';

  @override
  String get lastStay => 'Ultimo soggiorno';

  @override
  String get roleAdmin => 'Amministrazione';

  @override
  String get notifications => 'Notifiche';

  @override
  String get notifBooking => 'Nuova prenotazione';

  @override
  String get notifPending => 'Prenotazione da approvare';

  @override
  String get notifCancelled => 'Prenotazione annullata';

  @override
  String get notifRequest => 'Nuova richiesta di servizio';

  @override
  String get notifOrder => 'Nuovo ordine di cibo';

  @override
  String get notifMessage => 'Nuovo messaggio';

  @override
  String staffCancelConfirm(String refund) {
    return 'Annullare questa prenotazione? In base alle condizioni di cancellazione, l\'ospite riceve $refund.';
  }

  @override
  String get phone => 'Telefono';

  @override
  String get appearance => 'Aspetto';

  @override
  String get themeSystem => 'Come il dispositivo';

  @override
  String get themeLight => 'Chiaro';

  @override
  String get themeDark => 'Scuro';

  @override
  String get roomAvailable => 'Disponibile';

  @override
  String get availableOnly => 'Solo disponibili';

  @override
  String get floor => 'Piano';

  @override
  String get allRoomTypes => 'Tutti i tipi di camera';

  @override
  String get guestLabel => 'Ospite';

  @override
  String get rowNo => 'N.';

  @override
  String get employeeId => 'Matricola';

  @override
  String get photo => 'Foto';

  @override
  String get dateFrom => 'Dal';

  @override
  String get dateTo => 'Al';

  @override
  String get leaveType => 'Tipo di permesso';

  @override
  String get leaveVacation => 'Ferie';

  @override
  String get leaveSick => 'Malattia';

  @override
  String get leaveEmergency => 'Emergenza';

  @override
  String get leaveOther => 'Altro';

  @override
  String get submit => 'Invia';

  @override
  String get cash => 'Contanti';

  @override
  String get card => 'Carta';

  @override
  String get arrival => 'Arrivo';

  @override
  String get departure => 'Partenza';

  @override
  String get serviceRequests => 'Richieste di servizio';

  @override
  String get newRequest => 'Nuova richiesta';

  @override
  String get guestBooking => 'Prenotazione dell\'ospite';

  @override
  String bookRoom(String room) {
    return 'Prenota la camera $room';
  }

  @override
  String get bookAndCheckIn => 'Prenota e registra l\'arrivo';

  @override
  String get changeBooking => 'Modifica prenotazione';

  @override
  String get recordPayment => 'Registra pagamento';

  @override
  String get emailOrPhoneRequired =>
      'Inserisci un\'email o un numero di telefono';

  @override
  String get emailLocked =>
      'L\'email di accesso dell\'ospite non si può modificare qui.';

  @override
  String get onLeaveToday => 'In permesso';

  @override
  String leaveUpcoming(String dates) {
    return 'Permesso $dates';
  }

  @override
  String get collapseMenu => 'Comprimi menu';

  @override
  String get expandMenu => 'Espandi menu';

  @override
  String get roleRestaurant => 'Personale del ristorante';

  @override
  String get next => 'Avanti';

  @override
  String get payAtDesk => 'L\'ospite paga alla reception.';

  @override
  String get notAvailableForDates =>
      'Questo tipo di camera è al completo in queste date. Prova altre date o un\'altra camera.';

  @override
  String get byType => 'Per tipo';

  @override
  String get byFloor => 'Per piano';

  @override
  String floorN(String floor) {
    return 'Piano $floor';
  }

  @override
  String get paymentPaid => 'Pagato';

  @override
  String get paymentDeposit => 'Acconto pagato';

  @override
  String get paymentPartial => 'Pagato in parte';

  @override
  String get paymentUnpaid => 'Non pagato';

  @override
  String get moreLanguages => 'Altre lingue';
}
