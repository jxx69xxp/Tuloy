// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get signUp => 'Crear cuenta';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get haveAccount => '¿Ya tienes cuenta?';

  @override
  String get emailOrPhone => 'Correo o número de teléfono';

  @override
  String get password => 'Contraseña';

  @override
  String get passwordHint => 'Al menos 8 caracteres';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get required => 'Obligatorio';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get sendCode => 'Enviar código';

  @override
  String get codeSent =>
      'Si la cuenta existe, enviamos un código de 6 dígitos.';

  @override
  String get code => 'Código de 6 dígitos';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get passwordChanged => 'Contraseña cambiada. Inicia sesión.';

  @override
  String get settings => 'Ajustes';

  @override
  String get language => 'Idioma';

  @override
  String get guestHome => 'Bienvenido';

  @override
  String get staffHome => 'Personal';

  @override
  String get adminHome => 'Administración';

  @override
  String get comingSoon => 'Habrá más funciones en la próxima versión.';

  @override
  String get errorGeneric =>
      'No se puede conectar con el servidor. Revisa tu conexión.';

  @override
  String get cannotReachServer =>
      'No se puede conectar con el servidor. Revisa tu conexión o pide al administrador que permita este sitio.';

  @override
  String hello(String name) {
    return 'Hola, $name';
  }

  @override
  String get retry => 'Reintentar';

  @override
  String get howCanWeHelp => '¿En qué podemos ayudarte?';

  @override
  String get profile => 'Perfil';

  @override
  String get stays => 'Estancias';

  @override
  String get servicesUsed => 'Servicios usados';

  @override
  String get paymentHistory => 'Historial de pagos';

  @override
  String get cardOrEwallet => 'Tarjeta / billetera digital';

  @override
  String get testPayment => 'Pago de prueba';

  @override
  String get noneYet => 'Aún no hay nada';

  @override
  String get gettingHere => 'Cómo llegar';

  @override
  String get openInMaps => 'Abrir en Mapas';

  @override
  String get airportRoute => 'Ruta al aeropuerto';

  @override
  String get personalDetails => 'Datos personales';

  @override
  String get authTagline => 'Tu estancia y todos los servicios, a un toque';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get findRoom => 'Buscar habitación';

  @override
  String get adults => 'Adultos';

  @override
  String get children => 'Niños';

  @override
  String get guests => 'Huéspedes';

  @override
  String nightsCount(String count) {
    return 'Noches: $count';
  }

  @override
  String get noRooms =>
      'No hay habitaciones disponibles en estas fechas. Prueba otras fechas.';

  @override
  String perNight(String price) {
    return '$price / noche';
  }

  @override
  String roomsLeft(String count) {
    return 'Solo quedan $count';
  }

  @override
  String get totalLabel => 'Total';

  @override
  String get amenities => 'Servicios';

  @override
  String get policies => 'Políticas';

  @override
  String checkInTime(String time) {
    return 'Entrada desde las $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Salida antes de las $time';
  }

  @override
  String get specialRequests => 'Peticiones especiales (opcional)';

  @override
  String get reserve => 'Reservar';

  @override
  String get review => 'Revisar y pagar';

  @override
  String holdTimer(String time) {
    return 'Te guardamos esta habitación durante $time';
  }

  @override
  String get holdExpired => 'Tu reserva temporal caducó. Busca de nuevo.';

  @override
  String get serviceCharge => 'Cargo por servicio';

  @override
  String get vat => 'IVA';

  @override
  String payDeposit(String amount) {
    return 'Pagar depósito $amount';
  }

  @override
  String payFull(String amount) {
    return 'Pagar el total $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Pagar saldo $amount';
  }

  @override
  String get waitingPayment => 'Esperando el pago…';

  @override
  String get waitingPaymentHint =>
      'Termina el pago en el navegador. Esta página se actualiza sola.';

  @override
  String get openPaymentAgain => 'Abrir la página de pago otra vez';

  @override
  String get bookingConfirmed => '¡Reserva confirmada!';

  @override
  String bookingCode(String code) {
    return 'Reserva $code';
  }

  @override
  String roomNumber(String room) {
    return 'Habitación $room';
  }

  @override
  String get viewBooking => 'Ver reserva';

  @override
  String get backHome => 'Volver al inicio';

  @override
  String get paymentFailed =>
      'Esta reserva ya no está guardada. Si se te cobró, se te devolverá.';

  @override
  String get myBookings => 'Mis reservas';

  @override
  String get noBookings => 'Aún no tienes reservas.';

  @override
  String get statusHold => 'Pendiente de pago';

  @override
  String get statusPending => 'Pendiente';

  @override
  String get statusConfirmed => 'Confirmada';

  @override
  String get statusCheckedIn => 'Registrado';

  @override
  String get statusCheckedOut => 'Salida registrada';

  @override
  String get statusCancelled => 'Cancelada';

  @override
  String get statusNoShow => 'No se presentó';

  @override
  String get statusDeclined => 'Rechazada';

  @override
  String get statusExpired => 'Caducada';

  @override
  String get cancelBooking => 'Cancelar reserva';

  @override
  String cancelConfirm(String refund) {
    return '¿Cancelar esta reserva? Se te devolverán $refund.';
  }

  @override
  String get keepBooking => 'Mantener reserva';

  @override
  String get cancelled => 'Reserva cancelada';

  @override
  String get invoice => 'Factura';

  @override
  String get paid => 'Pagado';

  @override
  String get balance => 'Saldo';

  @override
  String get charges => 'Cargos';

  @override
  String get myStay => 'Mi estancia';

  @override
  String get currentStay => 'Tu estancia';

  @override
  String get hotelGuide => 'Guía del hotel';

  @override
  String get feedback => 'Opinión';

  @override
  String get rateStay => '¿Qué tal tu estancia?';

  @override
  String get comment => 'Comentarios (opcional)';

  @override
  String get send => 'Enviar';

  @override
  String get thanksFeedback => '¡Gracias por tu opinión!';

  @override
  String get accept => 'Aceptar';

  @override
  String acceptQuote(String amount) {
    return 'Aceptar presupuesto $amount';
  }

  @override
  String get acceptance => 'Aceptación';

  @override
  String get active => 'Activo';

  @override
  String get add => 'Añadir';

  @override
  String get addField => 'Añadir campo';

  @override
  String get addOption => 'Añadir opción';

  @override
  String get addOutlet => 'Añadir local';

  @override
  String get addPhoto => 'Añadir foto';

  @override
  String get addRoom => 'Añadir habitación';

  @override
  String get addStaff => 'Añadir personal';

  @override
  String get addTable => 'Añadir mesa';

  @override
  String get adjustPoints => 'Ajustar puntos';

  @override
  String get alerts => 'Alertas';

  @override
  String get all => 'Todo';

  @override
  String get allergens => 'Alérgenos';

  @override
  String get allergyNotes => 'Alergias o instrucciones especiales';

  @override
  String get amount => 'Importe';

  @override
  String get applyLeave => 'Pedir permiso';

  @override
  String get approve => 'Aprobar';

  @override
  String get approved => 'Aprobado';

  @override
  String get arrivals => 'Llegadas';

  @override
  String get asSoonAsPossible => 'Lo antes posible';

  @override
  String get auditLog => 'Registro de auditoría';

  @override
  String get autoAccept => 'Aceptar automáticamente';

  @override
  String get basePrice => 'Precio base';

  @override
  String get blocks => 'Bloqueos de habitaciones';

  @override
  String get body => 'Texto';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancelOrder => 'Cancelar pedido';

  @override
  String get cancelRequest => 'Cancelar solicitud';

  @override
  String get cancellationPolicy => 'Política de cancelación';

  @override
  String get category => 'Categoría';

  @override
  String get chargeToRoom => 'Cargar a mi habitación';

  @override
  String get chat => 'Chat';

  @override
  String get chatEmpty => 'Envía un mensaje a recepción.';

  @override
  String get chatWithHotel => 'Chatear con el hotel';

  @override
  String get checkInAction => 'Registrar entrada';

  @override
  String get checkOutAction => 'Registrar salida';

  @override
  String get choices => 'Opciones (separadas por comas)';

  @override
  String get closes => 'Cierra';

  @override
  String get codeLabel => 'Código';

  @override
  String get collectedToday => 'Cobrado hoy';

  @override
  String get content => 'Guías y promociones';

  @override
  String get copied => 'Copiado';

  @override
  String get copy => 'Copiar';

  @override
  String get copyCsv => 'Copiar como CSV';

  @override
  String get dates => 'Fechas';

  @override
  String get decline => 'Rechazar';

  @override
  String get delete => 'Eliminar';

  @override
  String get department => 'Departamento';

  @override
  String get departments => 'Departamentos';

  @override
  String get departures => 'Salidas';

  @override
  String get depositPercent => 'Depósito %';

  @override
  String get description => 'Descripción';

  @override
  String get draft => 'Borrador';

  @override
  String get earnPer100 => 'Puntos por cada ₱100';

  @override
  String earnRate(String points) {
    return 'Ganas $points punto(s) por cada ₱100.';
  }

  @override
  String get earnsPoints => 'Suma puntos de fidelidad';

  @override
  String get email => 'Correo';

  @override
  String get emptyResets => 'vacío = precio base';

  @override
  String get enterCode => 'Introduce el código';

  @override
  String get escalate => 'Escalar';

  @override
  String get etaMin => 'Listo en (minutos)';

  @override
  String etaMinutes(String minutes) {
    return 'Listo en unos $minutes min';
  }

  @override
  String get failedNotifications => 'Notificaciones fallidas';

  @override
  String get failedRefunds => 'Reembolsos fallidos';

  @override
  String get fieldKey => 'Clave del campo';

  @override
  String get formFields => 'Campos del formulario';

  @override
  String get free => 'Libre';

  @override
  String get freeCancelHours =>
      'Cancelación gratis (horas antes de la entrada)';

  @override
  String get frontDesk => 'Recepción';

  @override
  String get history => 'Historial';

  @override
  String get hotelName => 'Nombre del hotel';

  @override
  String get hotelSettings => 'Ajustes del hotel';

  @override
  String get inHouse => 'Alojados';

  @override
  String get inactive => 'inactivo';

  @override
  String get internalNotes => 'Notas internas';

  @override
  String get kind => 'Tipo';

  @override
  String get label => 'Etiqueta';

  @override
  String get lateRefundPercent => 'Reembolso tras el periodo gratis %';

  @override
  String get leadTimeMin => 'Pedir con antelación (minutos)';

  @override
  String get leaveRequests => 'Solicitudes de permiso';

  @override
  String get loyalty => 'Puntos de fidelidad';

  @override
  String get markNoShow => 'Marcar como no presentado';

  @override
  String get maxGuests => 'Máx. huéspedes';

  @override
  String get members => 'Miembros';

  @override
  String get menu => 'Menú';

  @override
  String get mine => 'Míos';

  @override
  String get missingToPublish => 'Falta antes de publicar';

  @override
  String get myDepartment => 'Mi departamento';

  @override
  String get myLeave => 'Mis permisos';

  @override
  String get myRequests => 'Mis solicitudes';

  @override
  String get name => 'Nombre';

  @override
  String get netToday => 'Neto de hoy';

  @override
  String get network => 'Red';

  @override
  String get newQr => 'Nuevo código QR';

  @override
  String get newQrWarning =>
      'El código anterior de esta mesa dejará de funcionar.';

  @override
  String nextTier(String points, String tier) {
    return '$points puntos más para $tier';
  }

  @override
  String get nothingHere => 'Aún no hay nada.';

  @override
  String get notFound => 'No encontrado.';

  @override
  String get occupancyTonight => 'Ocupación esta noche';

  @override
  String get ok => 'Aceptar';

  @override
  String get openTasks => 'Tareas abiertas';

  @override
  String get opens => 'Abre';

  @override
  String get options => 'Opciones';

  @override
  String get orderStatus => 'Tu pedido';

  @override
  String get pause => 'Pausar';

  @override
  String get payAtOutlet => 'Pagar en la mesa / el local';

  @override
  String get payOnline => 'Pagar en línea';

  @override
  String get paymentMethod => 'Pago';

  @override
  String get payments => 'Pagos y reembolsos';

  @override
  String get pendingApproval => 'Pendiente';

  @override
  String get permissions => 'Permisos';

  @override
  String get photos => 'Fotos';

  @override
  String get points => 'Puntos';

  @override
  String pointsBalance(String points) {
    return '$points puntos';
  }

  @override
  String pointsCost(String points) {
    return '$points puntos';
  }

  @override
  String get pointsPlusMinus => 'Puntos (+ añadir, − quitar)';

  @override
  String get preferredTime => 'Hora preferida';

  @override
  String get price => 'Precio';

  @override
  String get priceDelta => 'Precio extra';

  @override
  String get priceModel => 'Modelo de precio';

  @override
  String get priceOnQuote => 'Precio a consultar';

  @override
  String pricePerItem(String price) {
    return '$price cada uno';
  }

  @override
  String pricePerNight2(String price) {
    return '$price por noche';
  }

  @override
  String pricePerPerson(String price) {
    return '$price por persona';
  }

  @override
  String get publish => 'Publicar';

  @override
  String get published => 'Publicado';

  @override
  String get qrCode => 'Código QR';

  @override
  String get rates => 'Tarifas';

  @override
  String get reason => 'Motivo';

  @override
  String get redeem => 'Canjear';

  @override
  String get redeemNeedsStay =>
      'Los puntos se pueden usar en una estancia confirmada o actual.';

  @override
  String get redeemed => 'Aplicado a tu estancia';

  @override
  String get refund => 'Reembolso';

  @override
  String get refunded => 'Reembolsado';

  @override
  String get refundedToday => 'Reembolsado hoy';

  @override
  String get reissueWifi => 'Volver a emitir Wi-Fi';

  @override
  String get rejected => 'Rechazado';

  @override
  String get removeAccess => 'Quitar acceso de personal';

  @override
  String get reportOccupancy => 'Ocupación';

  @override
  String get reportRevenue => 'Ingresos';

  @override
  String get reports => 'Informes';

  @override
  String get requestStatus => 'Estado de la solicitud';

  @override
  String get requireApproval => 'El personal aprueba cada reserva pagada';

  @override
  String get reservation => 'Reserva';

  @override
  String get reservations => 'Reservas';

  @override
  String get restaurant => 'Restaurante';

  @override
  String get restaurantOrders => 'Pedidos del restaurante';

  @override
  String reviewOrder(String count, String total) {
    return 'Revisar pedido ($count) · $total';
  }

  @override
  String get rewards => 'Recompensas';

  @override
  String get role => 'Rol';

  @override
  String get roomLabel => 'Habitación';

  @override
  String get roomTypeLabel => 'Tipo de habitación';

  @override
  String get roomsAndRates => 'Habitaciones y tarifas';

  @override
  String get save => 'Guardar';

  @override
  String get saveDraft => 'Guardar borrador';

  @override
  String get saved => 'Guardado';

  @override
  String get scanTable => 'Pedir comida (escanear QR de la mesa)';

  @override
  String get scanTableHint => 'Apunta la cámara al código QR de tu mesa.';

  @override
  String get schedule => 'Horario';

  @override
  String get searchGuest => 'Buscar nombre, correo, teléfono o código';

  @override
  String get sendQuote => 'Enviar presupuesto';

  @override
  String get sendRequest => 'Enviar solicitud';

  @override
  String get serviceBuilder => 'Editor de servicios';

  @override
  String get services => 'Servicios';

  @override
  String get setRate => 'Fijar precio para fechas';

  @override
  String get staff => 'Personal';

  @override
  String get staffAndLeave => 'Personal y permisos';

  @override
  String get staffApproval => 'El personal acepta cada solicitud';

  @override
  String get status => 'Estado';

  @override
  String get statusSteps => 'Pasos de estado';

  @override
  String get submitOrder => 'Enviar pedido';

  @override
  String tableLabel(String table) {
    return 'Mesa $table';
  }

  @override
  String get tasks => 'Tareas';

  @override
  String get taxIncluded => 'Precio con impuestos';

  @override
  String get tempPassword => 'Contraseña temporal';

  @override
  String tier(String tier) {
    return 'Nivel: $tier';
  }

  @override
  String get title => 'Título';

  @override
  String get typeMessage => 'Escribe un mensaje';

  @override
  String get unassigned => 'Sin asignar';

  @override
  String get unblock => 'Desbloquear';

  @override
  String get upcoming => 'Próximas';

  @override
  String get username => 'Usuario';

  @override
  String get validUntil => 'Válido hasta';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Modo Wi-Fi (portal o psk)';

  @override
  String get wifiPortalHint =>
      'Conéctate a la red; se abrirá la página de acceso. Introduce el usuario y la contraseña de arriba.';

  @override
  String get wifiQrHint => 'Escanéalo con la cámara para conectarte.';

  @override
  String get wifiSharedPassword => 'Contraseña de Wi-Fi compartida (modo psk)';

  @override
  String get action => 'Acción';

  @override
  String get entity => 'Elemento';

  @override
  String get dateLabel => 'Fecha';

  @override
  String get actor => 'Autor';

  @override
  String get navOverview => 'Resumen';

  @override
  String get navCatalog => 'Catálogo';

  @override
  String get navFinance => 'Finanzas';

  @override
  String get navPeople => 'Personas';

  @override
  String get navSystem => 'Sistema';

  @override
  String get details => 'Detalles';

  @override
  String get refresh => 'Actualizar';

  @override
  String get needsAttention => 'Requiere atención';

  @override
  String get allClear => 'Nada requiere atención';

  @override
  String get unreadChats => 'Chats sin leer';

  @override
  String get myTasks => 'Mis tareas';

  @override
  String get search => 'Buscar';

  @override
  String get showMore => 'Ver más';

  @override
  String get viewLabel => 'Vista';

  @override
  String get sortedAscending => 'Orden ascendente';

  @override
  String get sortedDescending => 'Orden descendente';

  @override
  String sortBy(String column) {
    return 'Ordenar por $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown de $total';
  }

  @override
  String get note => 'Nota';

  @override
  String get rooms => 'Habitaciones';

  @override
  String get tables => 'Mesas';

  @override
  String get showDetails => 'Ver detalles';

  @override
  String get hideDetails => 'Ocultar detalles';

  @override
  String get selectThread => 'Elige una conversación';

  @override
  String get keyboardShortcuts => 'Atajos de teclado';

  @override
  String get goToPage => 'Ir a una página';

  @override
  String get shortcutSearch => 'Buscar en esta página';

  @override
  String get shortcutClose => 'Cerrar un panel o diálogo';

  @override
  String get shortcutHelp => 'Mostrar atajos de teclado';

  @override
  String get shortcutSend => 'Enviar mensaje (Mayús+Intro: nueva línea)';

  @override
  String get roomBoard => 'Habitaciones hoy';

  @override
  String get roomOccupied => 'Ocupada';

  @override
  String get roomDeparting => 'Sale hoy';

  @override
  String get roomArriving => 'Llega hoy';

  @override
  String get roomReserved => 'Reservada';

  @override
  String get roomBlocked => 'Bloqueada';

  @override
  String freeOf(String free, String total) {
    return '$free de $total disponibles';
  }

  @override
  String get todaysArrivals => 'Llegadas de hoy';

  @override
  String get todaysDepartures => 'Salidas de hoy';

  @override
  String get guestList => 'Lista de huéspedes';

  @override
  String get team => 'Equipo';

  @override
  String get lastStay => 'Última estancia';

  @override
  String get roleAdmin => 'Administración';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get notifBooking => 'Nueva reserva';

  @override
  String get notifPending => 'Reserva por aprobar';

  @override
  String get notifCancelled => 'Reserva cancelada';

  @override
  String get notifRequest => 'Nueva solicitud de servicio';

  @override
  String get notifOrder => 'Nuevo pedido de comida';

  @override
  String get notifMessage => 'Nuevo mensaje';

  @override
  String staffCancelConfirm(String refund) {
    return '¿Cancelar esta reserva? Según la política de cancelación, el huésped recibe $refund.';
  }

  @override
  String get phone => 'Teléfono';

  @override
  String get appearance => 'Apariencia';

  @override
  String get themeSystem => 'Según el dispositivo';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get roomAvailable => 'Disponible';

  @override
  String get availableOnly => 'Solo disponibles';

  @override
  String get floor => 'Planta';

  @override
  String get allRoomTypes => 'Todos los tipos';

  @override
  String get guestLabel => 'Huésped';

  @override
  String get rowNo => 'N.º';

  @override
  String get employeeId => 'N.º de empleado';

  @override
  String get photo => 'Foto';

  @override
  String get dateFrom => 'Desde';

  @override
  String get dateTo => 'Hasta';

  @override
  String get leaveType => 'Tipo de permiso';

  @override
  String get leaveVacation => 'Vacaciones';

  @override
  String get leaveSick => 'Enfermedad';

  @override
  String get leaveEmergency => 'Emergencia';

  @override
  String get leaveOther => 'Otro';

  @override
  String get submit => 'Enviar';

  @override
  String get cash => 'Efectivo';

  @override
  String get card => 'Tarjeta';

  @override
  String get arrival => 'Llegada';

  @override
  String get departure => 'Salida';

  @override
  String get serviceRequests => 'Solicitudes de servicio';

  @override
  String get newRequest => 'Nueva solicitud';

  @override
  String get guestBooking => 'Reserva del huésped';

  @override
  String bookRoom(String room) {
    return 'Reservar habitación $room';
  }

  @override
  String get bookAndCheckIn => 'Reservar y registrar entrada';

  @override
  String get changeBooking => 'Cambiar reserva';

  @override
  String get recordPayment => 'Registrar pago';

  @override
  String get emailOrPhoneRequired => 'Introduce un correo o un teléfono';

  @override
  String get emailLocked =>
      'El correo de acceso del huésped no se puede cambiar aquí.';

  @override
  String get onLeaveToday => 'De permiso';

  @override
  String leaveUpcoming(String dates) {
    return 'Permiso $dates';
  }

  @override
  String get collapseMenu => 'Contraer menú';

  @override
  String get expandMenu => 'Expandir menú';

  @override
  String get roleRestaurant => 'Personal del restaurante';

  @override
  String get next => 'Siguiente';

  @override
  String get payAtDesk => 'El huésped paga en recepción.';

  @override
  String get notAvailableForDates =>
      'Este tipo de habitación está completo en esas fechas. Prueba otras fechas u otra habitación.';

  @override
  String get byType => 'Por tipo';

  @override
  String get byFloor => 'Por planta';

  @override
  String floorN(String floor) {
    return 'Planta $floor';
  }

  @override
  String get paymentPaid => 'Pagado';

  @override
  String get paymentDeposit => 'Depósito pagado';

  @override
  String get paymentPartial => 'Pago parcial';

  @override
  String get paymentUnpaid => 'Sin pagar';

  @override
  String get moreLanguages => 'Más idiomas';
}
