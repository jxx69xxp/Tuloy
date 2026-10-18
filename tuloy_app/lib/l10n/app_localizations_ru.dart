// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Tuloy';

  @override
  String get signIn => 'Войти';

  @override
  String get signUp => 'Создать аккаунт';

  @override
  String get signOut => 'Выйти';

  @override
  String get noAccount => 'Нет аккаунта?';

  @override
  String get haveAccount => 'Уже есть аккаунт?';

  @override
  String get emailOrPhone => 'Эл. почта или номер телефона';

  @override
  String get password => 'Пароль';

  @override
  String get passwordHint => 'Не менее 8 символов';

  @override
  String get fullName => 'Имя и фамилия';

  @override
  String get required => 'Обязательно';

  @override
  String get forgotPassword => 'Забыли пароль?';

  @override
  String get sendCode => 'Отправить код';

  @override
  String get codeSent => 'Если аккаунт существует, мы отправили 6-значный код.';

  @override
  String get code => '6-значный код';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get resetPassword => 'Сбросить пароль';

  @override
  String get passwordChanged => 'Пароль изменён. Войдите снова.';

  @override
  String get settings => 'Настройки';

  @override
  String get language => 'Язык';

  @override
  String get guestHome => 'Добро пожаловать';

  @override
  String get staffHome => 'Сотрудники';

  @override
  String get adminHome => 'Администрирование';

  @override
  String get comingSoon => 'Новые функции появятся в следующей версии.';

  @override
  String get errorGeneric =>
      'Не удаётся связаться с сервером. Проверьте подключение.';

  @override
  String get cannotReachServer =>
      'Не удаётся связаться с сервером. Проверьте подключение или попросите администратора разрешить этот сайт.';

  @override
  String hello(String name) {
    return 'Здравствуйте, $name';
  }

  @override
  String get retry => 'Повторить';

  @override
  String get howCanWeHelp => 'Чем можем помочь?';

  @override
  String get profile => 'Профиль';

  @override
  String get stays => 'Проживания';

  @override
  String get servicesUsed => 'Использованные услуги';

  @override
  String get paymentHistory => 'История платежей';

  @override
  String get cardOrEwallet => 'Карта / электронный кошелёк';

  @override
  String get testPayment => 'Тестовый платёж';

  @override
  String get noneYet => 'Пока ничего нет';

  @override
  String get gettingHere => 'Как добраться';

  @override
  String get openInMaps => 'Открыть в Картах';

  @override
  String get airportRoute => 'Маршрут до аэропорта';

  @override
  String get personalDetails => 'Личные данные';

  @override
  String get authTagline => 'Ваше проживание и все услуги — в одно касание';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get findRoom => 'Найти номер';

  @override
  String get adults => 'Взрослые';

  @override
  String get children => 'Дети';

  @override
  String get guests => 'Гости';

  @override
  String nightsCount(String count) {
    return 'Ночей: $count';
  }

  @override
  String get noRooms =>
      'На эти даты нет свободных номеров. Выберите другие даты.';

  @override
  String perNight(String price) {
    return '$price / ночь';
  }

  @override
  String roomsLeft(String count) {
    return 'Осталось $count';
  }

  @override
  String get totalLabel => 'Итого';

  @override
  String get amenities => 'Удобства';

  @override
  String get policies => 'Правила';

  @override
  String checkInTime(String time) {
    return 'Заезд с $time';
  }

  @override
  String checkOutTime(String time) {
    return 'Выезд до $time';
  }

  @override
  String get specialRequests => 'Особые пожелания (необязательно)';

  @override
  String get reserve => 'Забронировать';

  @override
  String get review => 'Проверить и оплатить';

  @override
  String holdTimer(String time) {
    return 'Мы держим этот номер для вас $time';
  }

  @override
  String get holdExpired => 'Время брони истекло. Выполните поиск снова.';

  @override
  String get serviceCharge => 'Сервисный сбор';

  @override
  String get vat => 'НДС';

  @override
  String payDeposit(String amount) {
    return 'Оплатить депозит $amount';
  }

  @override
  String payFull(String amount) {
    return 'Оплатить полностью $amount';
  }

  @override
  String payBalance(String amount) {
    return 'Оплатить остаток $amount';
  }

  @override
  String get waitingPayment => 'Ожидаем оплату…';

  @override
  String get waitingPaymentHint =>
      'Завершите оплату в браузере. Эта страница обновится сама.';

  @override
  String get openPaymentAgain => 'Снова открыть страницу оплаты';

  @override
  String get bookingConfirmed => 'Бронирование подтверждено!';

  @override
  String bookingCode(String code) {
    return 'Бронирование $code';
  }

  @override
  String roomNumber(String room) {
    return 'Номер $room';
  }

  @override
  String get viewBooking => 'Открыть бронирование';

  @override
  String get backHome => 'На главную';

  @override
  String get paymentFailed =>
      'Эта бронь больше не удерживается. Если деньги были списаны, их вернут.';

  @override
  String get myBookings => 'Мои бронирования';

  @override
  String get noBookings => 'Бронирований пока нет.';

  @override
  String get statusHold => 'Ожидает оплаты';

  @override
  String get statusPending => 'Ожидает';

  @override
  String get statusConfirmed => 'Подтверждено';

  @override
  String get statusCheckedIn => 'Заселён';

  @override
  String get statusCheckedOut => 'Выехал';

  @override
  String get statusCancelled => 'Отменено';

  @override
  String get statusNoShow => 'Неявка';

  @override
  String get statusDeclined => 'Отклонено';

  @override
  String get statusExpired => 'Истекло';

  @override
  String get cancelBooking => 'Отменить бронирование';

  @override
  String cancelConfirm(String refund) {
    return 'Отменить это бронирование? Вам вернут $refund.';
  }

  @override
  String get keepBooking => 'Оставить бронирование';

  @override
  String get cancelled => 'Бронирование отменено';

  @override
  String get invoice => 'Счёт';

  @override
  String get paid => 'Оплачено';

  @override
  String get balance => 'Остаток';

  @override
  String get charges => 'Начисления';

  @override
  String get myStay => 'Моё проживание';

  @override
  String get currentStay => 'Ваше проживание';

  @override
  String get hotelGuide => 'Путеводитель по отелю';

  @override
  String get feedback => 'Отзыв';

  @override
  String get rateStay => 'Как вам у нас понравилось?';

  @override
  String get comment => 'Комментарий (необязательно)';

  @override
  String get send => 'Отправить';

  @override
  String get thanksFeedback => 'Спасибо за отзыв!';

  @override
  String get accept => 'Принять';

  @override
  String acceptQuote(String amount) {
    return 'Принять смету $amount';
  }

  @override
  String get acceptance => 'Принятие';

  @override
  String get active => 'Активно';

  @override
  String get add => 'Добавить';

  @override
  String get addField => 'Добавить поле';

  @override
  String get addOption => 'Добавить вариант';

  @override
  String get addOutlet => 'Добавить точку';

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get addRoom => 'Добавить номер';

  @override
  String get addStaff => 'Добавить сотрудника';

  @override
  String get addTable => 'Добавить стол';

  @override
  String get adjustPoints => 'Изменить баллы';

  @override
  String get alerts => 'Оповещения';

  @override
  String get all => 'Все';

  @override
  String get allergens => 'Аллергены';

  @override
  String get allergyNotes => 'Аллергии или особые указания';

  @override
  String get amount => 'Сумма';

  @override
  String get applyLeave => 'Подать заявку на отпуск';

  @override
  String get approve => 'Одобрить';

  @override
  String get approved => 'Одобрено';

  @override
  String get arrivals => 'Заезды';

  @override
  String get asSoonAsPossible => 'Как можно скорее';

  @override
  String get auditLog => 'Журнал аудита';

  @override
  String get autoAccept => 'Принимать автоматически';

  @override
  String get basePrice => 'Базовая цена';

  @override
  String get blocks => 'Блокировки номеров';

  @override
  String get body => 'Текст';

  @override
  String get cancel => 'Отмена';

  @override
  String get cancelOrder => 'Отменить заказ';

  @override
  String get cancelRequest => 'Отменить заявку';

  @override
  String get cancellationPolicy => 'Условия отмены';

  @override
  String get category => 'Категория';

  @override
  String get chargeToRoom => 'Записать на счёт номера';

  @override
  String get chat => 'Чат';

  @override
  String get chatEmpty => 'Напишите на ресепшен.';

  @override
  String get chatWithHotel => 'Написать отелю';

  @override
  String get checkInAction => 'Заселить';

  @override
  String get checkOutAction => 'Выселить';

  @override
  String get choices => 'Варианты (через запятую)';

  @override
  String get closes => 'Закрытие';

  @override
  String get codeLabel => 'Код';

  @override
  String get collectedToday => 'Получено сегодня';

  @override
  String get content => 'Справка и акции';

  @override
  String get copied => 'Скопировано';

  @override
  String get copy => 'Копировать';

  @override
  String get copyCsv => 'Копировать как CSV';

  @override
  String get dates => 'Даты';

  @override
  String get decline => 'Отклонить';

  @override
  String get delete => 'Удалить';

  @override
  String get department => 'Отдел';

  @override
  String get departments => 'Отделы';

  @override
  String get departures => 'Выезды';

  @override
  String get depositPercent => 'Депозит %';

  @override
  String get description => 'Описание';

  @override
  String get draft => 'Черновик';

  @override
  String get earnPer100 => 'Баллов за ₱100';

  @override
  String earnRate(String points) {
    return 'Вы получаете $points балл(ов) за каждые ₱100.';
  }

  @override
  String get earnsPoints => 'Начисляет бонусные баллы';

  @override
  String get email => 'Эл. почта';

  @override
  String get emptyResets => 'пусто = базовая цена';

  @override
  String get enterCode => 'Введите код';

  @override
  String get escalate => 'Передать выше';

  @override
  String get etaMin => 'Готово через (минуты)';

  @override
  String etaMinutes(String minutes) {
    return 'Будет готово примерно через $minutes мин';
  }

  @override
  String get failedNotifications => 'Неотправленные уведомления';

  @override
  String get failedRefunds => 'Неудачные возвраты';

  @override
  String get fieldKey => 'Ключ поля';

  @override
  String get formFields => 'Поля формы для гостя';

  @override
  String get free => 'Свободен';

  @override
  String get freeCancelHours =>
      'Бесплатная отмена (за сколько часов до заезда)';

  @override
  String get frontDesk => 'Ресепшен';

  @override
  String get history => 'История';

  @override
  String get hotelName => 'Название отеля';

  @override
  String get hotelSettings => 'Настройки отеля';

  @override
  String get inHouse => 'Проживают';

  @override
  String get inactive => 'неактивно';

  @override
  String get internalNotes => 'Внутренние заметки';

  @override
  String get kind => 'Тип';

  @override
  String get label => 'Подпись';

  @override
  String get lateRefundPercent => 'Возврат после бесплатного периода %';

  @override
  String get leadTimeMin => 'Заказ заранее (минуты)';

  @override
  String get leaveRequests => 'Заявки на отпуск';

  @override
  String get loyalty => 'Бонусные баллы';

  @override
  String get markNoShow => 'Отметить неявку';

  @override
  String get maxGuests => 'Макс. гостей';

  @override
  String get members => 'Участники';

  @override
  String get menu => 'Меню';

  @override
  String get mine => 'Мои';

  @override
  String get missingToPublish => 'Не заполнено для публикации';

  @override
  String get myDepartment => 'Мой отдел';

  @override
  String get myLeave => 'Мой отпуск';

  @override
  String get myRequests => 'Мои заявки';

  @override
  String get name => 'Имя';

  @override
  String get netToday => 'Итого за сегодня';

  @override
  String get network => 'Сеть';

  @override
  String get newQr => 'Новый QR-код';

  @override
  String get newQrWarning => 'Старый код этого стола перестанет работать.';

  @override
  String nextTier(String points, String tier) {
    return 'Ещё $points баллов до уровня $tier';
  }

  @override
  String get nothingHere => 'Пока ничего нет.';

  @override
  String get notFound => 'Не найдено.';

  @override
  String get occupancyTonight => 'Загрузка сегодня ночью';

  @override
  String get ok => 'ОК';

  @override
  String get openTasks => 'Открытые задачи';

  @override
  String get opens => 'Открытие';

  @override
  String get options => 'Опции';

  @override
  String get orderStatus => 'Ваш заказ';

  @override
  String get pause => 'Приостановить';

  @override
  String get payAtOutlet => 'Оплатить за столом / в точке';

  @override
  String get payOnline => 'Оплатить онлайн';

  @override
  String get paymentMethod => 'Оплата';

  @override
  String get payments => 'Платежи и возвраты';

  @override
  String get pendingApproval => 'Ожидает';

  @override
  String get permissions => 'Права';

  @override
  String get photos => 'Фото';

  @override
  String get points => 'Баллы';

  @override
  String pointsBalance(String points) {
    return '$points баллов';
  }

  @override
  String pointsCost(String points) {
    return '$points баллов';
  }

  @override
  String get pointsPlusMinus => 'Баллы (+ начислить, − списать)';

  @override
  String get preferredTime => 'Удобное время';

  @override
  String get price => 'Цена';

  @override
  String get priceDelta => 'Доплата';

  @override
  String get priceModel => 'Модель цены';

  @override
  String get priceOnQuote => 'Цена по запросу';

  @override
  String pricePerItem(String price) {
    return '$price за шт.';
  }

  @override
  String pricePerNight2(String price) {
    return '$price за ночь';
  }

  @override
  String pricePerPerson(String price) {
    return '$price с человека';
  }

  @override
  String get publish => 'Опубликовать';

  @override
  String get published => 'Опубликовано';

  @override
  String get qrCode => 'QR-код';

  @override
  String get rates => 'Тарифы';

  @override
  String get reason => 'Причина';

  @override
  String get redeem => 'Использовать';

  @override
  String get redeemNeedsStay =>
      'Баллы можно использовать при подтверждённом или текущем проживании.';

  @override
  String get redeemed => 'Применено к проживанию';

  @override
  String get refund => 'Возврат';

  @override
  String get refunded => 'Возвращено';

  @override
  String get refundedToday => 'Возвращено сегодня';

  @override
  String get reissueWifi => 'Перевыпустить Wi-Fi';

  @override
  String get rejected => 'Отклонено';

  @override
  String get removeAccess => 'Убрать доступ сотрудника';

  @override
  String get reportOccupancy => 'Загрузка';

  @override
  String get reportRevenue => 'Выручка';

  @override
  String get reports => 'Отчёты';

  @override
  String get requestStatus => 'Статус заявки';

  @override
  String get requireApproval =>
      'Сотрудник подтверждает каждую оплаченную бронь';

  @override
  String get reservation => 'Бронирование';

  @override
  String get reservations => 'Бронирования';

  @override
  String get restaurant => 'Ресторан';

  @override
  String get restaurantOrders => 'Заказы ресторана';

  @override
  String reviewOrder(String count, String total) {
    return 'Проверить заказ ($count) · $total';
  }

  @override
  String get rewards => 'Награды';

  @override
  String get role => 'Роль';

  @override
  String get roomLabel => 'Номер';

  @override
  String get roomTypeLabel => 'Тип номера';

  @override
  String get roomsAndRates => 'Номера и тарифы';

  @override
  String get save => 'Сохранить';

  @override
  String get saveDraft => 'Сохранить черновик';

  @override
  String get saved => 'Сохранено';

  @override
  String get scanTable => 'Заказать еду (сканировать QR на столе)';

  @override
  String get scanTableHint => 'Наведите камеру на QR-код на вашем столе.';

  @override
  String get schedule => 'Расписание';

  @override
  String get searchGuest => 'Поиск по имени, почте, телефону или коду';

  @override
  String get sendQuote => 'Отправить смету';

  @override
  String get sendRequest => 'Отправить заявку';

  @override
  String get serviceBuilder => 'Конструктор услуг';

  @override
  String get services => 'Услуги';

  @override
  String get setRate => 'Задать цену на даты';

  @override
  String get staff => 'Сотрудники';

  @override
  String get staffAndLeave => 'Сотрудники и отпуска';

  @override
  String get staffApproval => 'Сотрудник принимает каждую заявку';

  @override
  String get status => 'Статус';

  @override
  String get statusSteps => 'Этапы статуса';

  @override
  String get submitOrder => 'Отправить заказ';

  @override
  String tableLabel(String table) {
    return 'Стол $table';
  }

  @override
  String get tasks => 'Задачи';

  @override
  String get taxIncluded => 'Цена с налогами';

  @override
  String get tempPassword => 'Временный пароль';

  @override
  String tier(String tier) {
    return 'Уровень: $tier';
  }

  @override
  String get title => 'Заголовок';

  @override
  String get typeMessage => 'Введите сообщение';

  @override
  String get unassigned => 'Не назначено';

  @override
  String get unblock => 'Разблокировать';

  @override
  String get upcoming => 'Предстоящие';

  @override
  String get username => 'Имя пользователя';

  @override
  String get validUntil => 'Действует до';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get wifiMode => 'Режим Wi-Fi (portal или psk)';

  @override
  String get wifiPortalHint =>
      'Подключитесь к сети — откроется страница входа. Введите имя пользователя и пароль выше.';

  @override
  String get wifiQrHint => 'Отсканируйте камерой, чтобы подключиться.';

  @override
  String get wifiSharedPassword => 'Общий пароль Wi-Fi (режим psk)';

  @override
  String get action => 'Действие';

  @override
  String get entity => 'Объект';

  @override
  String get dateLabel => 'Дата';

  @override
  String get actor => 'Исполнитель';

  @override
  String get navOverview => 'Обзор';

  @override
  String get navCatalog => 'Каталог';

  @override
  String get navFinance => 'Финансы';

  @override
  String get navPeople => 'Люди';

  @override
  String get navSystem => 'Система';

  @override
  String get details => 'Подробности';

  @override
  String get refresh => 'Обновить';

  @override
  String get needsAttention => 'Требует внимания';

  @override
  String get allClear => 'Всё в порядке';

  @override
  String get unreadChats => 'Непрочитанные чаты';

  @override
  String get myTasks => 'Мои задачи';

  @override
  String get search => 'Поиск';

  @override
  String get showMore => 'Показать ещё';

  @override
  String get viewLabel => 'Вид';

  @override
  String get sortedAscending => 'По возрастанию';

  @override
  String get sortedDescending => 'По убыванию';

  @override
  String sortBy(String column) {
    return 'Сортировать по: $column';
  }

  @override
  String rowsShown(int shown, int total) {
    return '$shown из $total';
  }

  @override
  String get note => 'Заметка';

  @override
  String get rooms => 'Номера';

  @override
  String get tables => 'Столы';

  @override
  String get showDetails => 'Показать подробности';

  @override
  String get hideDetails => 'Скрыть подробности';

  @override
  String get selectThread => 'Выберите переписку';

  @override
  String get keyboardShortcuts => 'Сочетания клавиш';

  @override
  String get goToPage => 'Перейти на страницу';

  @override
  String get shortcutSearch => 'Поиск на этой странице';

  @override
  String get shortcutClose => 'Закрыть панель или окно';

  @override
  String get shortcutHelp => 'Показать сочетания клавиш';

  @override
  String get shortcutSend => 'Отправить сообщение (Shift+Enter — новая строка)';

  @override
  String get roomBoard => 'Номера сегодня';

  @override
  String get roomOccupied => 'Занят';

  @override
  String get roomDeparting => 'Выезд сегодня';

  @override
  String get roomArriving => 'Заезд сегодня';

  @override
  String get roomReserved => 'Забронирован';

  @override
  String get roomBlocked => 'Заблокирован';

  @override
  String freeOf(String free, String total) {
    return 'Свободно $free из $total';
  }

  @override
  String get todaysArrivals => 'Заезды сегодня';

  @override
  String get todaysDepartures => 'Выезды сегодня';

  @override
  String get guestList => 'Список гостей';

  @override
  String get team => 'Команда';

  @override
  String get lastStay => 'Последнее проживание';

  @override
  String get roleAdmin => 'Администратор';

  @override
  String get notifications => 'Уведомления';

  @override
  String get notifBooking => 'Новое бронирование';

  @override
  String get notifPending => 'Бронирование ждёт одобрения';

  @override
  String get notifCancelled => 'Бронирование отменено';

  @override
  String get notifRequest => 'Новая заявка на услугу';

  @override
  String get notifOrder => 'Новый заказ еды';

  @override
  String get notifMessage => 'Новое сообщение';

  @override
  String staffCancelConfirm(String refund) {
    return 'Отменить это бронирование? По условиям отмены гость получит $refund.';
  }

  @override
  String get phone => 'Телефон';

  @override
  String get appearance => 'Оформление';

  @override
  String get themeSystem => 'Как на устройстве';

  @override
  String get themeLight => 'Светлое';

  @override
  String get themeDark => 'Тёмное';

  @override
  String get roomAvailable => 'Свободен';

  @override
  String get availableOnly => 'Только свободные';

  @override
  String get floor => 'Этаж';

  @override
  String get allRoomTypes => 'Все типы номеров';

  @override
  String get guestLabel => 'Гость';

  @override
  String get rowNo => '№';

  @override
  String get employeeId => 'Табельный номер';

  @override
  String get photo => 'Фото';

  @override
  String get dateFrom => 'С';

  @override
  String get dateTo => 'По';

  @override
  String get leaveType => 'Вид отпуска';

  @override
  String get leaveVacation => 'Отпуск';

  @override
  String get leaveSick => 'Больничный';

  @override
  String get leaveEmergency => 'Срочный';

  @override
  String get leaveOther => 'Другое';

  @override
  String get submit => 'Отправить';

  @override
  String get cash => 'Наличные';

  @override
  String get card => 'Карта';

  @override
  String get arrival => 'Заезд';

  @override
  String get departure => 'Выезд';

  @override
  String get serviceRequests => 'Заявки на услуги';

  @override
  String get newRequest => 'Новая заявка';

  @override
  String get guestBooking => 'Бронирование гостя';

  @override
  String bookRoom(String room) {
    return 'Забронировать номер $room';
  }

  @override
  String get bookAndCheckIn => 'Забронировать и заселить';

  @override
  String get changeBooking => 'Изменить бронирование';

  @override
  String get recordPayment => 'Записать оплату';

  @override
  String get emailOrPhoneRequired => 'Введите эл. почту или номер телефона';

  @override
  String get emailLocked => 'Эл. почту для входа гостя нельзя изменить здесь.';

  @override
  String get onLeaveToday => 'В отпуске';

  @override
  String leaveUpcoming(String dates) {
    return 'Отпуск $dates';
  }

  @override
  String get collapseMenu => 'Свернуть меню';

  @override
  String get expandMenu => 'Развернуть меню';

  @override
  String get roleRestaurant => 'Сотрудник ресторана';

  @override
  String get next => 'Далее';

  @override
  String get payAtDesk => 'Гость платит на ресепшене.';

  @override
  String get notAvailableForDates =>
      'На эти даты все номера этого типа заняты. Выберите другие даты или другой номер.';

  @override
  String get byType => 'По типу';

  @override
  String get byFloor => 'По этажам';

  @override
  String floorN(String floor) {
    return 'Этаж $floor';
  }

  @override
  String get paymentPaid => 'Оплачено';

  @override
  String get paymentDeposit => 'Депозит внесён';

  @override
  String get paymentPartial => 'Оплачено частично';

  @override
  String get paymentUnpaid => 'Не оплачено';

  @override
  String get moreLanguages => 'Другие языки';
}
