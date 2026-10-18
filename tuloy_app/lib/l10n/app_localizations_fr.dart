// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get haveAccount => 'Vous avez déjà un compte ?';

  @override
  String get emailOrPhone => 'E-mail ou numéro de téléphone';

  @override
  String get password => 'Mot de passe';

  @override
  String get passwordHint => 'Au moins 8 caractères';

  @override
  String get fullName => 'Nom complet';

  @override
  String get required => 'Obligatoire';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get sendCode => 'Envoyer le code';

  @override
  String get codeSent =>
      'Si le compte existe, nous avons envoyé un code à 6 chiffres.';

  @override
  String get code => 'Code à 6 chiffres';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get passwordChanged =>
      'Mot de passe modifié. Veuillez vous connecter.';

  @override
  String get settings => 'Paramètres';

  @override
  String get language => 'Langue';

  @override
  String get guestHome => 'Bienvenue';

  @override
  String get staffHome => 'Personnel';

  @override
  String get adminHome => 'Administration';

  @override
  String get comingSoon =>
      'D\'autres fonctions arrivent dans la prochaine version.';

  @override
  String get errorGeneric =>
      'Impossible de joindre le serveur. Vérifiez votre connexion.';

  @override
  String get cannotReachServer =>
      'Impossible de joindre le serveur. Vérifiez votre connexion ou demandez à l\'administrateur d\'autoriser ce site.';

  @override
  String hello(String name) {
    return 'Bonjour, $name';
  }

  @override
  String get retry => 'Réessayer';

  @override
  String get howCanWeHelp => 'Comment pouvons-nous vous aider ?';

  @override
  String get profile => 'Profil';

  @override
  String get stays => 'Séjours';

  @override
  String get servicesUsed => 'Services utilisés';

  @override
  String get paymentHistory => 'Historique des paiements';

  @override
  String get cardOrEwallet => 'Carte / portefeuille électronique';

  @override
  String get testPayment => 'Paiement test';

  @override
  String get noneYet => 'Rien pour l\'instant';

  @override
  String get gettingHere => 'Accès';

  @override
  String get openInMaps => 'Ouvrir dans Plans';

  @override
  String get airportRoute => 'Itinéraire vers l\'aéroport';

  @override
  String get personalDetails => 'Informations personnelles';

  @override
  String get authTagline => 'Votre séjour et tous les services, en un geste';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get findRoom => 'Trouver une chambre';

  @override
  String get adults => 'Adultes';

  @override
  String get children => 'Enfants';

  @override
  String get guests => 'Personnes';

  @override
  String nightsCount(String count) {
    return 'Nuits : $count';
  }

  @override
  String get noRooms =>
      'Aucune chambre disponible à ces dates. Essayez d\'autres dates.';

  @override
  String perNight(String price) {
    return '$price / nuit';
  }

  @override
  String roomsLeft(String count) {
    return 'Plus que $count';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get amenities => 'Équipements';

  @override
  String get policies => 'Conditions';

  @override
  String checkInTime(String time) {
    return 'Arrivée à partir de $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Départ avant $time';
  }

  @override
  String get specialRequests => 'Demandes particulières (facultatif)';

  @override
  String get reserve => 'Réserver';

  @override
  String get review => 'Vérifier et payer';

  @override
  String holdTimer(String time) {
    return 'Nous vous gardons cette chambre pendant $time';
  }

  @override
  String get holdExpired =>
      'Votre réservation provisoire a expiré. Relancez la recherche.';

  @override
  String get serviceCharge => 'Frais de service';

  @override
  String get vat => 'TVA';

  @override
  String payDeposit(String amount) {
    return 'Payer l\'acompte $amount';
  }

  @override
  String payFull(String amount) {
    return 'Tout payer $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Payer le solde $amount';
  }

  @override
  String get waitingPayment => 'En attente du paiement…';

  @override
  String get waitingPaymentHint =>
      'Terminez le paiement dans le navigateur. Cette page se met à jour toute seule.';

  @override
  String get openPaymentAgain => 'Rouvrir la page de paiement';

  @override
  String get bookingConfirmed => 'Réservation confirmée !';

  @override
  String bookingCode(String code) {
    return 'Réservation $code';
  }

  @override
  String roomNumber(String room) {
    return 'Chambre $room';
  }

  @override
  String get viewBooking => 'Voir la réservation';

  @override
  String get backHome => 'Retour à l\'accueil';

  @override
  String get paymentFailed =>
      'Cette réservation n\'est plus retenue. Si vous avez été débité, vous serez remboursé.';

  @override
  String get myBookings => 'Mes réservations';

  @override
  String get noBookings => 'Aucune réservation pour l\'instant.';

  @override
  String get statusHold => 'En attente de paiement';

  @override
  String get statusPending => 'En attente';

  @override
  String get statusConfirmed => 'Confirmée';

  @override
  String get statusCheckedIn => 'Arrivé';

  @override
  String get statusCheckedOut => 'Parti';

  @override
  String get statusCancelled => 'Annulée';

  @override
  String get statusNoShow => 'Non présenté';

  @override
  String get statusDeclined => 'Refusée';

  @override
  String get statusExpired => 'Expirée';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String cancelConfirm(String refund) {
    return 'Annuler cette réservation ? Vous serez remboursé de $refund.';
  }

  @override
  String get keepBooking => 'Garder la réservation';

  @override
  String get cancelled => 'Réservation annulée';

  @override
  String get invoice => 'Facture';

  @override
  String get paid => 'Payé';

  @override
  String get balance => 'Solde';

  @override
  String get charges => 'Frais';

  @override
  String get myStay => 'Mon séjour';

  @override
  String get currentStay => 'Votre séjour';

  @override
  String get hotelGuide => 'Guide de l\'hôtel';

  @override
  String get feedback => 'Avis';

  @override
  String get rateStay => 'Comment s\'est passé votre séjour ?';

  @override
  String get comment => 'Commentaires (facultatif)';

  @override
  String get send => 'Envoyer';

  @override
  String get thanksFeedback => 'Merci pour votre avis !';

  @override
  String get accept => 'Accepter';

  @override
  String acceptQuote(String amount) {
    return 'Accepter le devis $amount';
  }

  @override
  String get acceptance => 'Validation';

  @override
  String get active => 'Actif';

  @override
  String get add => 'Ajouter';

  @override
  String get addField => 'Ajouter un champ';

  @override
  String get addOption => 'Ajouter une option';

  @override
  String get addOutlet => 'Ajouter un point de vente';

  @override
  String get addPhoto => 'Ajouter une photo';

  @override
  String get addRoom => 'Ajouter une chambre';

  @override
  String get addStaff => 'Ajouter un employé';

  @override
  String get addTable => 'Ajouter une table';

  @override
  String get adjustPoints => 'Ajuster les points';

  @override
  String get alerts => 'Alertes';

  @override
  String get all => 'Tout';

  @override
  String get allergens => 'Allergènes';

  @override
  String get allergyNotes => 'Allergies ou instructions particulières';

  @override
  String get amount => 'Montant';

  @override
  String get applyLeave => 'Demander un congé';

  @override
  String get approve => 'Approuver';

  @override
  String get approved => 'Approuvé';

  @override
  String get arrivals => 'Arrivées';

  @override
  String get asSoonAsPossible => 'Dès que possible';

  @override
  String get auditLog => 'Journal d\'audit';

  @override
  String get autoAccept => 'Accepter automatiquement';

  @override
  String get basePrice => 'Prix de base';

  @override
  String get blocks => 'Blocages de chambres';

  @override
  String get body => 'Texte';

  @override
  String get cancel => 'Annuler';

  @override
  String get cancelOrder => 'Annuler la commande';

  @override
  String get cancelRequest => 'Annuler la demande';

  @override
  String get cancellationPolicy => 'Conditions d\'annulation';

  @override
  String get category => 'Catégorie';

  @override
  String get chargeToRoom => 'Débiter sur ma chambre';

  @override
  String get chat => 'Messagerie';

  @override
  String get chatEmpty => 'Envoyez un message à la réception.';

  @override
  String get chatWithHotel => 'Écrire à l\'hôtel';

  @override
  String get checkInAction => 'Enregistrer l\'arrivée';

  @override
  String get checkOutAction => 'Enregistrer le départ';

  @override
  String get choices => 'Choix (séparés par des virgules)';

  @override
  String get closes => 'Fermeture';

  @override
  String get codeLabel => 'Code';

  @override
  String get collectedToday => 'Encaissé aujourd\'hui';

  @override
  String get content => 'Guides et promotions';

  @override
  String get copied => 'Copié';

  @override
  String get copy => 'Copier';

  @override
  String get copyCsv => 'Copier en CSV';

  @override
  String get dates => 'Dates';

  @override
  String get decline => 'Refuser';

  @override
  String get delete => 'Supprimer';

  @override
  String get department => 'Service';

  @override
  String get departments => 'Services';

  @override
  String get departures => 'Départs';

  @override
  String get depositPercent => 'Acompte %';

  @override
  String get description => 'Description';

  @override
  String get draft => 'Brouillon';

  @override
  String get earnPer100 => 'Points par tranche de ₱100';

  @override
  String earnRate(String points) {
    return 'Vous gagnez $points point(s) par tranche de ₱100.';
  }

  @override
  String get earnsPoints => 'Rapporte des points de fidélité';

  @override
  String get email => 'E-mail';

  @override
  String get emptyResets => 'vide = prix de base';

  @override
  String get enterCode => 'Saisissez le code';

  @override
  String get escalate => 'Faire remonter';

  @override
  String get etaMin => 'Prêt en (minutes)';

  @override
  String etaMinutes(String minutes) {
    return 'Prêt dans environ $minutes min';
  }

  @override
  String get failedNotifications => 'Notifications échouées';

  @override
  String get failedRefunds => 'Remboursements échoués';

  @override
  String get fieldKey => 'Clé du champ';

  @override
  String get formFields => 'Champs du formulaire client';

  @override
  String get free => 'Libre';

  @override
  String get freeCancelHours => 'Annulation gratuite (heures avant l\'arrivée)';

  @override
  String get frontDesk => 'Réception';

  @override
  String get history => 'Historique';

  @override
  String get hotelName => 'Nom de l\'hôtel';

  @override
  String get hotelSettings => 'Paramètres de l\'hôtel';

  @override
  String get inHouse => 'Présents';

  @override
  String get inactive => 'inactif';

  @override
  String get internalNotes => 'Notes internes';

  @override
  String get kind => 'Type';

  @override
  String get label => 'Libellé';

  @override
  String get lateRefundPercent => 'Remboursement après la période gratuite %';

  @override
  String get leadTimeMin => 'Commander à l\'avance (minutes)';

  @override
  String get leaveRequests => 'Demandes de congé';

  @override
  String get loyalty => 'Points de fidélité';

  @override
  String get markNoShow => 'Marquer non présenté';

  @override
  String get maxGuests => 'Personnes max.';

  @override
  String get members => 'Membres';

  @override
  String get menu => 'Menu';

  @override
  String get mine => 'Les miennes';

  @override
  String get missingToPublish => 'Manquant avant publication';

  @override
  String get myDepartment => 'Mon service';

  @override
  String get myLeave => 'Mes congés';

  @override
  String get myRequests => 'Mes demandes';

  @override
  String get name => 'Nom';

  @override
  String get netToday => 'Net du jour';

  @override
  String get network => 'Réseau';

  @override
  String get newQr => 'Nouveau QR code';

  @override
  String get newQrWarning =>
      'L\'ancien code de cette table ne fonctionnera plus.';

  @override
  String nextTier(String points, String tier) {
    return 'Encore $points points pour $tier';
  }

  @override
  String get nothingHere => 'Rien pour l\'instant.';

  @override
  String get notFound => 'Introuvable.';

  @override
  String get occupancyTonight => 'Occupation ce soir';

  @override
  String get ok => 'OK';

  @override
  String get openTasks => 'Tâches en cours';

  @override
  String get opens => 'Ouverture';

  @override
  String get options => 'Options';

  @override
  String get orderStatus => 'Votre commande';

  @override
  String get pause => 'Suspendre';

  @override
  String get payAtOutlet => 'Payer à table / au point de vente';

  @override
  String get payOnline => 'Payer en ligne';

  @override
  String get paymentMethod => 'Paiement';

  @override
  String get payments => 'Paiements et remboursements';

  @override
  String get pendingApproval => 'En attente';

  @override
  String get permissions => 'Autorisations';

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
  String get pointsPlusMinus => 'Points (+ ajouter, − retirer)';

  @override
  String get preferredTime => 'Heure souhaitée';

  @override
  String get price => 'Prix';

  @override
  String get priceDelta => 'Supplément';

  @override
  String get priceModel => 'Mode de tarification';

  @override
  String get priceOnQuote => 'Prix sur demande';

  @override
  String pricePerItem(String price) {
    return '$price l\'unité';
  }

  @override
  String pricePerNight2(String price) {
    return '$price par nuit';
  }

  @override
  String pricePerPerson(String price) {
    return '$price par personne';
  }

  @override
  String get publish => 'Publier';

  @override
  String get published => 'Publié';

  @override
  String get qrCode => 'QR code';

  @override
  String get rates => 'Tarifs';

  @override
  String get reason => 'Motif';

  @override
  String get redeem => 'Utiliser';

  @override
  String get redeemNeedsStay =>
      'Les points s\'utilisent sur un séjour confirmé ou en cours.';

  @override
  String get redeemed => 'Appliqué à votre séjour';

  @override
  String get refund => 'Remboursement';

  @override
  String get refunded => 'Remboursé';

  @override
  String get refundedToday => 'Remboursé aujourd\'hui';

  @override
  String get reissueWifi => 'Réémettre le Wi-Fi';

  @override
  String get rejected => 'Refusé';

  @override
  String get removeAccess => 'Retirer l\'accès employé';

  @override
  String get reportOccupancy => 'Occupation';

  @override
  String get reportRevenue => 'Chiffre d\'affaires';

  @override
  String get reports => 'Rapports';

  @override
  String get requestStatus => 'Suivi de la demande';

  @override
  String get requireApproval =>
      'Le personnel approuve chaque réservation payée';

  @override
  String get reservation => 'Réservation';

  @override
  String get reservations => 'Réservations';

  @override
  String get restaurant => 'Restaurant';

  @override
  String get restaurantOrders => 'Commandes du restaurant';

  @override
  String reviewOrder(String count, String total) {
    return 'Voir la commande ($count) · $total';
  }

  @override
  String get rewards => 'Récompenses';

  @override
  String get role => 'Rôle';

  @override
  String get roomLabel => 'Chambre';

  @override
  String get roomTypeLabel => 'Type de chambre';

  @override
  String get roomsAndRates => 'Chambres et tarifs';

  @override
  String get save => 'Enregistrer';

  @override
  String get saveDraft => 'Enregistrer le brouillon';

  @override
  String get saved => 'Enregistré';

  @override
  String get scanTable => 'Commander à manger (scanner le QR de la table)';

  @override
  String get scanTableHint =>
      'Pointez l\'appareil photo vers le QR code de votre table.';

  @override
  String get schedule => 'Horaires';

  @override
  String get searchGuest => 'Rechercher nom, e-mail, téléphone ou code';

  @override
  String get sendQuote => 'Envoyer le devis';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String get serviceBuilder => 'Éditeur de services';

  @override
  String get services => 'Services';

  @override
  String get setRate => 'Fixer le prix pour des dates';

  @override
  String get staff => 'Personnel';

  @override
  String get staffAndLeave => 'Personnel et congés';

  @override
  String get staffApproval => 'Le personnel valide chaque demande';

  @override
  String get status => 'Statut';

  @override
  String get statusSteps => 'Étapes de statut';

  @override
  String get submitOrder => 'Envoyer la commande';

  @override
  String tableLabel(String table) {
    return 'Table $table';
  }

  @override
  String get tasks => 'Tâches';

  @override
  String get taxIncluded => 'Prix TTC';

  @override
  String get tempPassword => 'Mot de passe temporaire';

  @override
  String tier(String tier) {
    return 'Niveau : $tier';
  }

  @override
  String get title => 'Titre';

  @override
  String get typeMessage => 'Écrire un message';

  @override
  String get unassigned => 'Non attribué';

  @override
  String get unblock => 'Débloquer';

  @override
  String get upcoming => 'À venir';

  @override
  String get username => 'Identifiant';

  @override
  String get validUntil => 'Valable jusqu\'au';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Mode Wi-Fi (portal ou psk)';

  @override
  String get wifiPortalHint =>
      'Connectez-vous au réseau ; la page de connexion s\'ouvre. Saisissez l\'identifiant et le mot de passe ci-dessus.';

  @override
  String get wifiQrHint =>
      'Scannez avec l\'appareil photo pour vous connecter.';

  @override
  String get wifiSharedPassword => 'Mot de passe Wi-Fi partagé (mode psk)';

  @override
  String get action => 'Action';

  @override
  String get entity => 'Élément';

  @override
  String get dateLabel => 'Date';

  @override
  String get actor => 'Auteur';

  @override
  String get navOverview => 'Vue d\'ensemble';

  @override
  String get navCatalog => 'Catalogue';

  @override
  String get navFinance => 'Finances';

  @override
  String get navPeople => 'Personnes';

  @override
  String get navSystem => 'Système';

  @override
  String get details => 'Détails';

  @override
  String get refresh => 'Actualiser';

  @override
  String get needsAttention => 'À traiter';

  @override
  String get allClear => 'Rien à traiter';

  @override
  String get unreadChats => 'Messages non lus';

  @override
  String get myTasks => 'Mes tâches';

  @override
  String get search => 'Rechercher';

  @override
  String get showMore => 'Afficher plus';

  @override
  String get viewLabel => 'Vue';

  @override
  String get sortedAscending => 'Tri croissant';

  @override
  String get sortedDescending => 'Tri décroissant';

  @override
  String sortBy(String column) {
    return 'Trier par $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown sur $total';
  }

  @override
  String get note => 'Note';

  @override
  String get rooms => 'Chambres';

  @override
  String get tables => 'Tables';

  @override
  String get showDetails => 'Afficher les détails';

  @override
  String get hideDetails => 'Masquer les détails';

  @override
  String get selectThread => 'Choisissez une conversation';

  @override
  String get keyboardShortcuts => 'Raccourcis clavier';

  @override
  String get goToPage => 'Aller à une page';

  @override
  String get shortcutSearch => 'Rechercher dans cette page';

  @override
  String get shortcutClose => 'Fermer un panneau ou une fenêtre';

  @override
  String get shortcutHelp => 'Afficher les raccourcis clavier';

  @override
  String get shortcutSend => 'Envoyer un message (Maj+Entrée : nouvelle ligne)';

  @override
  String get roomBoard => 'Chambres du jour';

  @override
  String get roomOccupied => 'Occupée';

  @override
  String get roomDeparting => 'Départ aujourd\'hui';

  @override
  String get roomArriving => 'Arrivée aujourd\'hui';

  @override
  String get roomReserved => 'Réservée';

  @override
  String get roomBlocked => 'Bloquée';

  @override
  String freeOf(String free, String total) {
    return '$free sur $total disponibles';
  }

  @override
  String get todaysArrivals => 'Arrivées du jour';

  @override
  String get todaysDepartures => 'Départs du jour';

  @override
  String get guestList => 'Liste des clients';

  @override
  String get team => 'Équipe';

  @override
  String get lastStay => 'Dernier séjour';

  @override
  String get roleAdmin => 'Administration';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifBooking => 'Nouvelle réservation';

  @override
  String get notifPending => 'Réservation à approuver';

  @override
  String get notifCancelled => 'Réservation annulée';

  @override
  String get notifRequest => 'Nouvelle demande de service';

  @override
  String get notifOrder => 'Nouvelle commande de repas';

  @override
  String get notifMessage => 'Nouveau message';

  @override
  String staffCancelConfirm(String refund) {
    return 'Annuler cette réservation ? Selon les conditions d\'annulation, le client est remboursé de $refund.';
  }

  @override
  String get phone => 'Téléphone';

  @override
  String get appearance => 'Apparence';

  @override
  String get themeSystem => 'Comme l\'appareil';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get roomAvailable => 'Disponible';

  @override
  String get availableOnly => 'Disponibles uniquement';

  @override
  String get floor => 'Étage';

  @override
  String get allRoomTypes => 'Tous les types de chambre';

  @override
  String get guestLabel => 'Client';

  @override
  String get rowNo => 'N°';

  @override
  String get employeeId => 'Matricule';

  @override
  String get photo => 'Photo';

  @override
  String get dateFrom => 'Du';

  @override
  String get dateTo => 'Au';

  @override
  String get leaveType => 'Type de congé';

  @override
  String get leaveVacation => 'Congés';

  @override
  String get leaveSick => 'Maladie';

  @override
  String get leaveEmergency => 'Urgence';

  @override
  String get leaveOther => 'Autre';

  @override
  String get submit => 'Envoyer';

  @override
  String get cash => 'Espèces';

  @override
  String get card => 'Carte';

  @override
  String get arrival => 'Arrivée';

  @override
  String get departure => 'Départ';

  @override
  String get serviceRequests => 'Demandes de service';

  @override
  String get newRequest => 'Nouvelle demande';

  @override
  String get guestBooking => 'Réservation du client';

  @override
  String bookRoom(String room) {
    return 'Réserver la chambre $room';
  }

  @override
  String get bookAndCheckIn => 'Réserver et enregistrer l\'arrivée';

  @override
  String get changeBooking => 'Modifier la réservation';

  @override
  String get recordPayment => 'Enregistrer un paiement';

  @override
  String get emailOrPhoneRequired =>
      'Saisissez un e-mail ou un numéro de téléphone';

  @override
  String get emailLocked =>
      'L\'e-mail de connexion du client ne peut pas être modifié ici.';

  @override
  String get onLeaveToday => 'En congé';

  @override
  String leaveUpcoming(String dates) {
    return 'Congé $dates';
  }

  @override
  String get collapseMenu => 'Réduire le menu';

  @override
  String get expandMenu => 'Développer le menu';

  @override
  String get roleRestaurant => 'Personnel du restaurant';

  @override
  String get next => 'Suivant';

  @override
  String get payAtDesk => 'Le client paie à la réception.';

  @override
  String get notAvailableForDates =>
      'Ce type de chambre est complet à ces dates. Essayez d\'autres dates ou une autre chambre.';

  @override
  String get byType => 'Par type';

  @override
  String get byFloor => 'Par étage';

  @override
  String floorN(String floor) {
    return 'Étage $floor';
  }

  @override
  String get paymentPaid => 'Payé';

  @override
  String get paymentDeposit => 'Acompte payé';

  @override
  String get paymentPartial => 'Payé en partie';

  @override
  String get paymentUnpaid => 'Non payé';

  @override
  String get moreLanguages => 'Autres langues';
}
