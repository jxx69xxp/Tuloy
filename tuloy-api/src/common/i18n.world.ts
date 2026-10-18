// Generated: error messages and notification wording for the world languages.
// Merged into MESSAGES (errors.ts) and DEFAULTS (templates.ts); anything missing falls back to English.
export const WORLD: Record<string, { e: Record<string, string>; n: Record<string, (string | null)[]> }> = {
  "zh": {
    "e": {
      "UNAUTHENTICATED": "请重新登录。",
      "FORBIDDEN": "您无权访问此内容。",
      "INVALID_CREDENTIALS": "邮箱/手机号或密码错误。",
      "EMPLOYEE_NO_TAKEN": "已有其他员工使用此员工编号。",
      "CANNOT_CHANGE": "此预订已无法更改。",
      "ACCOUNT_EXISTS": "此邮箱或手机号已注册账户。",
      "LOGIN_REQUIRED": "请输入邮箱或手机号。",
      "INVALID_OTP": "验证码错误或已过期。",
      "HOTEL_REQUIRED": "缺少酒店信息。",
      "VALIDATION": "请检查标出的字段。",
      "NOT_FOUND": "未找到。",
      "INVALID_DATES": "请检查日期：入住日期须为今天或之后，且早于退房日期。",
      "STAY_TOO_LONG": "每次入住最多 30 晚。更长入住请联系酒店。",
      "TOO_MANY_GUESTS": "此房间容纳不了这么多客人。",
      "ROOM_UNAVAILABLE": "抱歉，此房间刚被预订。请选择其他房间。",
      "HOLD_EXPIRED": "保留时间已过。请重新搜索。",
      "NOTHING_TO_PAY": "没有待付款项。",
      "PAYMENT_UNAVAILABLE": "暂时无法付款。请稍后再试。",
      "CANNOT_CANCEL": "此预订已无法取消。",
      "CANNOT_REVIEW": "预订确认后即可留下评价。",
      "INVALID_TRANSITION": "当前状态下无法执行此操作。",
      "TOO_EARLY": "现在为此客人办理入住还太早。",
      "CONVERSATION_CLOSED": "此对话已关闭。",
      "CANNOT_DEMOTE_SELF": "您不能移除自己的管理员权限。",
      "ROOM_NUMBER_TAKEN": "该房间号已被使用。",
      "REFUND_TOO_LARGE": "退款金额超过此笔付款的剩余金额。",
      "REFUND_FAILED": "支付服务商未接受退款。已记录并将重试。",
      "SERVICE_INCOMPLETE": "发布前请填写所有必填信息。",
      "SERVICE_UNAVAILABLE": "此服务暂不可用。",
      "PAYMENT_METHOD_NOT_ALLOWED": "此项不接受该付款方式。",
      "ROOM_CHARGE_NOT_ALLOWED": "仅已入住的客人可记入房账。",
      "TOO_SOON": "请选择更晚的时间。",
      "OUTSIDE_HOURS": "该时间不在服务时间内。",
      "SLOT_FULL": "该时段已满。请选择其他时间。",
      "QR_INVALID": "此二维码无效。请向工作人员求助。",
      "ITEM_UNAVAILABLE": "购物车中有商品已不可用。",
      "CANNOT_REDEEM": "积分可用于已确认或当前的入住。",
      "REDEEM_LIMIT": "超出此预订可使用的积分上限。",
      "INSUFFICIENT_POINTS": "积分不足。",
      "WIFI_NOT_READY": "入住后即可使用 Wi-Fi。",
      "INTERNAL": "出了点问题。请重试。"
    },
    "n": {
      "auth.otp": [
        "您的 Tuloy 验证码",
        "您的验证码是 {{otp}}，10 分钟内有效。请勿泄露。"
      ],
      "booking.confirmed": [
        "预订已确认",
        "{{hotel}}：预订 {{code}} 已确认，{{checkIn}} 至 {{checkOut}}。"
      ],
      "booking.cancelled": [
        "预订已取消",
        "{{hotel}}：预订 {{code}}（{{checkIn}} 至 {{checkOut}}）已取消。{{reason}}"
      ],
      "payment.receipt": [
        "已收到付款",
        "我们已收到预订 {{code}} 的 {{amount}}。谢谢！"
      ],
      "refund.issued": [
        "退款处理中",
        "预订 {{code}} 的 {{amount}} 正在退回您的原付款方式。"
      ],
      "booking.received": [
        "已收到预订",
        "{{hotel}} 已收到预订 {{code}}，将尽快确认。"
      ],
      "service.updated": [
        null,
        "您的请求状态：{{status}}"
      ],
      "order.updated": [
        "订单 {{code}}",
        "您的订单状态：{{status}}"
      ],
      "task.new": [
        "新任务",
        null
      ]
    }
  },
  "ja": {
    "e": {
      "UNAUTHENTICATED": "もう一度ログインしてください。",
      "FORBIDDEN": "このページへのアクセス権がありません。",
      "INVALID_CREDENTIALS": "メール/電話番号またはパスワードが違います。",
      "EMPLOYEE_NO_TAKEN": "この社員番号は別のスタッフが使用しています。",
      "CANNOT_CHANGE": "この予約は変更できなくなりました。",
      "ACCOUNT_EXISTS": "このメールまたは電話番号のアカウントは既に存在します。",
      "LOGIN_REQUIRED": "メールアドレスまたは電話番号を入力してください。",
      "INVALID_OTP": "コードが間違っているか、期限切れです。",
      "HOTEL_REQUIRED": "ホテルが指定されていません。",
      "VALIDATION": "強調表示された項目を確認してください。",
      "NOT_FOUND": "見つかりません。",
      "INVALID_DATES": "日付を確認してください。チェックインは今日以降、かつチェックアウトより前である必要があります。",
      "STAY_TOO_LONG": "宿泊は最大 30 泊までです。長期滞在はホテルにお問い合わせください。",
      "TOO_MANY_GUESTS": "この部屋はその人数に対応していません。",
      "ROOM_UNAVAILABLE": "申し訳ありません。この部屋はたった今予約されました。別の部屋をお選びください。",
      "HOLD_EXPIRED": "確保時間が過ぎました。もう一度検索してください。",
      "NOTHING_TO_PAY": "お支払い残高はありません。",
      "PAYMENT_UNAVAILABLE": "現在お支払いができません。しばらくしてからお試しください。",
      "CANNOT_CANCEL": "この予約はキャンセルできなくなりました。",
      "CANNOT_REVIEW": "予約確定後にフィードバックを送信できます。",
      "INVALID_TRANSITION": "現在のステータスではこの操作はできません。",
      "TOO_EARLY": "このお客様のチェックインにはまだ早すぎます。",
      "CONVERSATION_CLOSED": "この会話は終了しています。",
      "CANNOT_DEMOTE_SELF": "自分の管理者権限は削除できません。",
      "ROOM_NUMBER_TAKEN": "この部屋番号は既に使われています。",
      "REFUND_TOO_LARGE": "返金額がこの支払いの残額を超えています。",
      "REFUND_FAILED": "決済事業者が返金を受け付けませんでした。再試行のため記録しました。",
      "SERVICE_INCOMPLETE": "公開する前に必須項目をすべて入力してください。",
      "SERVICE_UNAVAILABLE": "このサービスは現在ご利用いただけません。",
      "PAYMENT_METHOD_NOT_ALLOWED": "この支払い方法はご利用いただけません。",
      "ROOM_CHARGE_NOT_ALLOWED": "部屋付けはチェックイン済みのお客様のみ可能です。",
      "TOO_SOON": "もう少し後の時間を選んでください。",
      "OUTSIDE_HOURS": "その時間は営業時間外です。",
      "SLOT_FULL": "その時間帯は満席です。別の時間をお選びください。",
      "QR_INVALID": "この QR コードは無効です。スタッフにお尋ねください。",
      "ITEM_UNAVAILABLE": "カート内の商品が利用できなくなりました。",
      "CANNOT_REDEEM": "ポイントは確定済みまたは滞在中の予約に使えます。",
      "REDEEM_LIMIT": "この予約で使えるポイントの上限を超えています。",
      "INSUFFICIENT_POINTS": "ポイントが足りません。",
      "WIFI_NOT_READY": "Wi-Fi はチェックイン後に利用できます。",
      "INTERNAL": "問題が発生しました。もう一度お試しください。"
    },
    "n": {
      "auth.otp": [
        "Tuloy の認証コード",
        "認証コードは {{otp}} です。10 分間有効です。他人に教えないでください。"
      ],
      "booking.confirmed": [
        "予約確定",
        "{{hotel}}：予約 {{code}}（{{checkIn}}〜{{checkOut}}）が確定しました。"
      ],
      "booking.cancelled": [
        "予約キャンセル",
        "{{hotel}}：予約 {{code}}（{{checkIn}}〜{{checkOut}}）はキャンセルされました。{{reason}}"
      ],
      "payment.receipt": [
        "お支払いを受け付けました",
        "予約 {{code}} の {{amount}} を受け取りました。ありがとうございます！"
      ],
      "refund.issued": [
        "返金手続き中",
        "予約 {{code}} の {{amount}} を元のお支払い方法に返金しています。"
      ],
      "booking.received": [
        "予約を受け付けました",
        "{{hotel}} が予約 {{code}} を受け付けました。まもなく確定します。"
      ],
      "service.updated": [
        null,
        "リクエストの状況：{{status}}"
      ],
      "order.updated": [
        "注文 {{code}}",
        "ご注文の状況：{{status}}"
      ],
      "task.new": [
        "新しいタスク",
        null
      ]
    }
  },
  "ko": {
    "e": {
      "UNAUTHENTICATED": "다시 로그인해 주세요.",
      "FORBIDDEN": "접근 권한이 없습니다.",
      "INVALID_CREDENTIALS": "이메일/전화번호 또는 비밀번호가 올바르지 않습니다.",
      "EMPLOYEE_NO_TAKEN": "다른 직원이 이미 이 사번을 사용 중입니다.",
      "CANNOT_CHANGE": "이 예약은 더 이상 변경할 수 없습니다.",
      "ACCOUNT_EXISTS": "이 이메일 또는 전화번호로 된 계정이 이미 있습니다.",
      "LOGIN_REQUIRED": "이메일 주소나 전화번호를 입력하세요.",
      "INVALID_OTP": "코드가 틀렸거나 만료되었습니다.",
      "HOTEL_REQUIRED": "호텔 정보가 없습니다.",
      "VALIDATION": "표시된 항목을 확인해 주세요.",
      "NOT_FOUND": "찾을 수 없습니다.",
      "INVALID_DATES": "날짜를 확인하세요. 체크인은 오늘 이후이고 체크아웃보다 앞서야 합니다.",
      "STAY_TOO_LONG": "숙박은 최대 30박까지 가능합니다. 장기 숙박은 호텔에 문의하세요.",
      "TOO_MANY_GUESTS": "이 객실은 그 인원을 수용할 수 없습니다.",
      "ROOM_UNAVAILABLE": "죄송합니다. 이 객실은 방금 예약되었습니다. 다른 객실을 선택하세요.",
      "HOLD_EXPIRED": "객실 보류 시간이 만료되었습니다. 다시 검색하세요.",
      "NOTHING_TO_PAY": "결제할 금액이 없습니다.",
      "PAYMENT_UNAVAILABLE": "지금은 결제할 수 없습니다. 잠시 후 다시 시도하세요.",
      "CANNOT_CANCEL": "이 예약은 더 이상 취소할 수 없습니다.",
      "CANNOT_REVIEW": "예약이 확정되면 의견을 남길 수 있습니다.",
      "INVALID_TRANSITION": "현재 상태에서는 이 작업을 할 수 없습니다.",
      "TOO_EARLY": "이 고객을 체크인하기에는 아직 이릅니다.",
      "CONVERSATION_CLOSED": "이 대화는 종료되었습니다.",
      "CANNOT_DEMOTE_SELF": "자신의 관리자 권한은 제거할 수 없습니다.",
      "ROOM_NUMBER_TAKEN": "이미 사용 중인 객실 번호입니다.",
      "REFUND_TOO_LARGE": "환불액이 이 결제의 잔액보다 많습니다.",
      "REFUND_FAILED": "결제 대행사가 환불을 거절했습니다. 재시도를 위해 기록되었습니다.",
      "SERVICE_INCOMPLETE": "게시하기 전에 필수 정보를 모두 입력하세요.",
      "SERVICE_UNAVAILABLE": "지금은 이 서비스를 이용할 수 없습니다.",
      "PAYMENT_METHOD_NOT_ALLOWED": "이 결제 수단은 사용할 수 없습니다.",
      "ROOM_CHARGE_NOT_ALLOWED": "객실 청구는 체크인한 고객만 가능합니다.",
      "TOO_SOON": "더 늦은 시간을 선택하세요.",
      "OUTSIDE_HOURS": "서비스 운영 시간이 아닙니다.",
      "SLOT_FULL": "해당 시간대가 꽉 찼습니다. 다른 시간을 선택하세요.",
      "QR_INVALID": "유효하지 않은 QR 코드입니다. 직원에게 문의하세요.",
      "ITEM_UNAVAILABLE": "장바구니의 상품 중 더 이상 주문할 수 없는 것이 있습니다.",
      "CANNOT_REDEEM": "포인트는 확정되었거나 진행 중인 숙박에 사용할 수 있습니다.",
      "REDEEM_LIMIT": "이 예약에 사용할 수 있는 포인트 한도를 넘었습니다.",
      "INSUFFICIENT_POINTS": "포인트가 부족합니다.",
      "WIFI_NOT_READY": "Wi-Fi는 체크인 후 이용할 수 있습니다.",
      "INTERNAL": "문제가 발생했습니다. 다시 시도하세요."
    },
    "n": {
      "auth.otp": [
        "Tuloy 인증 코드",
        "인증 코드는 {{otp}}입니다. 10분 후 만료됩니다. 다른 사람과 공유하지 마세요."
      ],
      "booking.confirmed": [
        "예약 확정",
        "{{hotel}}: 예약 {{code}}({{checkIn}}~{{checkOut}})이 확정되었습니다."
      ],
      "booking.cancelled": [
        "예약 취소",
        "{{hotel}}: 예약 {{code}}({{checkIn}}~{{checkOut}})이 취소되었습니다. {{reason}}"
      ],
      "payment.receipt": [
        "결제 완료",
        "예약 {{code}}에 대한 {{amount}}을 받았습니다. 감사합니다!"
      ],
      "refund.issued": [
        "환불 진행 중",
        "예약 {{code}}의 {{amount}}이 원래 결제 수단으로 환불되고 있습니다."
      ],
      "booking.received": [
        "예약 접수",
        "{{hotel}}에서 예약 {{code}}을 접수했으며 곧 확정해 드립니다."
      ],
      "service.updated": [
        null,
        "요청 상태: {{status}}"
      ],
      "order.updated": [
        "주문 {{code}}",
        "주문 상태: {{status}}"
      ],
      "task.new": [
        "새 작업",
        null
      ]
    }
  },
  "es": {
    "e": {
      "UNAUTHENTICATED": "Vuelve a iniciar sesión.",
      "FORBIDDEN": "No tienes acceso a esto.",
      "INVALID_CREDENTIALS": "Correo/teléfono o contraseña incorrectos.",
      "EMPLOYEE_NO_TAKEN": "Otro miembro del personal ya tiene este ID de empleado.",
      "CANNOT_CHANGE": "Esta reserva ya no se puede modificar.",
      "ACCOUNT_EXISTS": "Ya existe una cuenta con este correo o teléfono.",
      "LOGIN_REQUIRED": "Introduce un correo o un número de teléfono.",
      "INVALID_OTP": "El código es incorrecto o ha caducado.",
      "HOTEL_REQUIRED": "Falta el hotel.",
      "VALIDATION": "Revisa los campos marcados.",
      "NOT_FOUND": "No encontrado.",
      "INVALID_DATES": "Revisa las fechas: la entrada debe ser hoy o después y antes de la salida.",
      "STAY_TOO_LONG": "Las estancias tienen un máximo de 30 noches. Para más, contacta con el hotel.",
      "TOO_MANY_GUESTS": "Esta habitación no admite tantos huéspedes.",
      "ROOM_UNAVAILABLE": "Lo sentimos, esta habitación acaba de reservarse. Elige otra.",
      "HOLD_EXPIRED": "Tu reserva temporal ha caducado. Busca de nuevo.",
      "NOTHING_TO_PAY": "No queda nada por pagar.",
      "PAYMENT_UNAVAILABLE": "Los pagos no están disponibles ahora. Inténtalo de nuevo en breve.",
      "CANNOT_CANCEL": "Esta reserva ya no se puede cancelar.",
      "CANNOT_REVIEW": "Podrás dejar tu opinión cuando se confirme la reserva.",
      "INVALID_TRANSITION": "Esta acción no es posible en el estado actual.",
      "TOO_EARLY": "Aún es pronto para registrar la entrada de este huésped.",
      "CONVERSATION_CLOSED": "Esta conversación está cerrada.",
      "CANNOT_DEMOTE_SELF": "No puedes quitarte tu propio acceso de administrador.",
      "ROOM_NUMBER_TAKEN": "Ese número de habitación ya está en uso.",
      "REFUND_TOO_LARGE": "El reembolso supera lo que queda de este pago.",
      "REFUND_FAILED": "El proveedor de pagos no aceptó el reembolso. Se ha registrado para reintentarlo.",
      "SERVICE_INCOMPLETE": "Completa todos los datos obligatorios antes de publicar.",
      "SERVICE_UNAVAILABLE": "Este servicio no está disponible ahora.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Ese método de pago no se acepta aquí.",
      "ROOM_CHARGE_NOT_ALLOWED": "El cargo a la habitación es solo para huéspedes registrados.",
      "TOO_SOON": "Elige una hora más tarde.",
      "OUTSIDE_HOURS": "Esa hora está fuera del horario del servicio.",
      "SLOT_FULL": "Ese horario está completo. Elige otro.",
      "QR_INVALID": "Este código QR no es válido. Pide ayuda al personal.",
      "ITEM_UNAVAILABLE": "Un artículo de tu carrito ya no está disponible.",
      "CANNOT_REDEEM": "Los puntos se pueden usar en estancias confirmadas o en curso.",
      "REDEEM_LIMIT": "Supera los puntos permitidos para esta reserva.",
      "INSUFFICIENT_POINTS": "No tienes suficientes puntos.",
      "WIFI_NOT_READY": "El Wi-Fi estará disponible tras el check-in.",
      "INTERNAL": "Algo salió mal. Inténtalo de nuevo."
    },
    "n": {
      "auth.otp": [
        "Tu código de Tuloy",
        "Tu código es {{otp}}. Caduca en 10 minutos. No lo compartas."
      ],
      "booking.confirmed": [
        "Reserva confirmada",
        "{{hotel}}: la reserva {{code}} está confirmada del {{checkIn}} al {{checkOut}}."
      ],
      "booking.cancelled": [
        "Reserva cancelada",
        "{{hotel}}: la reserva {{code}} ({{checkIn}} al {{checkOut}}) está cancelada. {{reason}}"
      ],
      "payment.receipt": [
        "Pago recibido",
        "Hemos recibido {{amount}} para la reserva {{code}}. ¡Gracias!"
      ],
      "refund.issued": [
        "Reembolso en camino",
        "Estamos reembolsando {{amount}} de la reserva {{code}} a tu método de pago original."
      ],
      "booking.received": [
        "Reserva recibida",
        "{{hotel}} ha recibido la reserva {{code}} y la confirmará en breve."
      ],
      "service.updated": [
        null,
        "Tu solicitud ahora está: {{status}}"
      ],
      "order.updated": [
        "Pedido {{code}}",
        "Tu pedido ahora está: {{status}}"
      ],
      "task.new": [
        "Nueva tarea",
        null
      ]
    }
  },
  "fr": {
    "e": {
      "UNAUTHENTICATED": "Veuillez vous reconnecter.",
      "FORBIDDEN": "Vous n'avez pas accès à ceci.",
      "INVALID_CREDENTIALS": "E-mail/téléphone ou mot de passe incorrect.",
      "EMPLOYEE_NO_TAKEN": "Un autre membre du personnel a déjà ce matricule.",
      "CANNOT_CHANGE": "Cette réservation ne peut plus être modifiée.",
      "ACCOUNT_EXISTS": "Un compte existe déjà pour cet e-mail ou ce téléphone.",
      "LOGIN_REQUIRED": "Saisissez une adresse e-mail ou un numéro de téléphone.",
      "INVALID_OTP": "Le code est incorrect ou a expiré.",
      "HOTEL_REQUIRED": "L'hôtel est manquant.",
      "VALIDATION": "Vérifiez les champs signalés.",
      "NOT_FOUND": "Introuvable.",
      "INVALID_DATES": "Vérifiez les dates : l'arrivée doit être aujourd'hui ou plus tard, et avant le départ.",
      "STAY_TOO_LONG": "Les séjours sont limités à 30 nuits. Contactez l'hôtel pour un séjour plus long.",
      "TOO_MANY_GUESTS": "Cette chambre ne peut pas accueillir autant de personnes.",
      "ROOM_UNAVAILABLE": "Désolé, cette chambre vient d'être réservée. Choisissez-en une autre.",
      "HOLD_EXPIRED": "Votre réservation temporaire a expiré. Relancez la recherche.",
      "NOTHING_TO_PAY": "Il ne reste rien à payer.",
      "PAYMENT_UNAVAILABLE": "Les paiements sont indisponibles pour le moment. Réessayez bientôt.",
      "CANNOT_CANCEL": "Cette réservation ne peut plus être annulée.",
      "CANNOT_REVIEW": "Vous pourrez laisser un avis une fois la réservation confirmée.",
      "INVALID_TRANSITION": "Cette action n'est pas possible dans l'état actuel.",
      "TOO_EARLY": "Il est trop tôt pour enregistrer l'arrivée de ce client.",
      "CONVERSATION_CLOSED": "Cette conversation est fermée.",
      "CANNOT_DEMOTE_SELF": "Vous ne pouvez pas retirer votre propre accès administrateur.",
      "ROOM_NUMBER_TAKEN": "Ce numéro de chambre est déjà utilisé.",
      "REFUND_TOO_LARGE": "Le remboursement dépasse le reste de ce paiement.",
      "REFUND_FAILED": "Le prestataire de paiement a refusé le remboursement. Il est enregistré pour une nouvelle tentative.",
      "SERVICE_INCOMPLETE": "Remplissez toutes les informations requises avant de publier.",
      "SERVICE_UNAVAILABLE": "Ce service n'est pas disponible pour le moment.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Ce moyen de paiement n'est pas accepté ici.",
      "ROOM_CHARGE_NOT_ALLOWED": "La facturation sur la chambre est réservée aux clients enregistrés.",
      "TOO_SOON": "Choisissez une heure plus tardive.",
      "OUTSIDE_HOURS": "Cette heure est en dehors des horaires du service.",
      "SLOT_FULL": "Ce créneau est complet. Choisissez-en un autre.",
      "QR_INVALID": "Ce code QR n'est pas valide. Demandez de l'aide au personnel.",
      "ITEM_UNAVAILABLE": "Un article de votre panier n'est plus disponible.",
      "CANNOT_REDEEM": "Les points s'utilisent sur un séjour confirmé ou en cours.",
      "REDEEM_LIMIT": "Cela dépasse les points autorisés pour cette réservation.",
      "INSUFFICIENT_POINTS": "Points insuffisants.",
      "WIFI_NOT_READY": "Le Wi-Fi est disponible après l'enregistrement.",
      "INTERNAL": "Une erreur s'est produite. Veuillez réessayer."
    },
    "n": {
      "auth.otp": [
        "Votre code Tuloy",
        "Votre code est {{otp}}. Il expire dans 10 minutes. Ne le partagez pas."
      ],
      "booking.confirmed": [
        "Réservation confirmée",
        "{{hotel}} : la réservation {{code}} est confirmée du {{checkIn}} au {{checkOut}}."
      ],
      "booking.cancelled": [
        "Réservation annulée",
        "{{hotel}} : la réservation {{code}} ({{checkIn}} au {{checkOut}}) est annulée. {{reason}}"
      ],
      "payment.receipt": [
        "Paiement reçu",
        "Nous avons reçu {{amount}} pour la réservation {{code}}. Merci !"
      ],
      "refund.issued": [
        "Remboursement en cours",
        "{{amount}} pour la réservation {{code}} est remboursé sur votre moyen de paiement d'origine."
      ],
      "booking.received": [
        "Réservation reçue",
        "{{hotel}} a reçu la réservation {{code}} et la confirmera sous peu."
      ],
      "service.updated": [
        null,
        "Votre demande est maintenant : {{status}}"
      ],
      "order.updated": [
        "Commande {{code}}",
        "Votre commande est maintenant : {{status}}"
      ],
      "task.new": [
        "Nouvelle tâche",
        null
      ]
    }
  },
  "de": {
    "e": {
      "UNAUTHENTICATED": "Bitte melden Sie sich erneut an.",
      "FORBIDDEN": "Sie haben hierauf keinen Zugriff.",
      "INVALID_CREDENTIALS": "E-Mail/Telefon oder Passwort falsch.",
      "EMPLOYEE_NO_TAKEN": "Ein anderer Mitarbeiter hat bereits diese Personalnummer.",
      "CANNOT_CHANGE": "Diese Buchung kann nicht mehr geändert werden.",
      "ACCOUNT_EXISTS": "Für diese E-Mail oder Telefonnummer gibt es bereits ein Konto.",
      "LOGIN_REQUIRED": "Geben Sie eine E-Mail-Adresse oder Telefonnummer ein.",
      "INVALID_OTP": "Der Code ist falsch oder abgelaufen.",
      "HOTEL_REQUIRED": "Hotel fehlt.",
      "VALIDATION": "Bitte prüfen Sie die markierten Felder.",
      "NOT_FOUND": "Nicht gefunden.",
      "INVALID_DATES": "Prüfen Sie die Daten: Die Anreise muss heute oder später und vor der Abreise liegen.",
      "STAY_TOO_LONG": "Aufenthalte sind auf 30 Nächte begrenzt. Für längere Aufenthalte kontaktieren Sie das Hotel.",
      "TOO_MANY_GUESTS": "Dieses Zimmer bietet nicht für so viele Gäste Platz.",
      "ROOM_UNAVAILABLE": "Leider wurde dieses Zimmer gerade gebucht. Bitte wählen Sie ein anderes.",
      "HOLD_EXPIRED": "Ihre Reservierung ist abgelaufen. Bitte suchen Sie erneut.",
      "NOTHING_TO_PAY": "Es ist nichts mehr zu zahlen.",
      "PAYMENT_UNAVAILABLE": "Zahlungen sind gerade nicht möglich. Bitte versuchen Sie es gleich noch einmal.",
      "CANNOT_CANCEL": "Diese Buchung kann nicht mehr storniert werden.",
      "CANNOT_REVIEW": "Sie können Feedback geben, sobald die Buchung bestätigt ist.",
      "INVALID_TRANSITION": "Diese Aktion ist im aktuellen Status nicht möglich.",
      "TOO_EARLY": "Für den Check-in dieses Gastes ist es noch zu früh.",
      "CONVERSATION_CLOSED": "Diese Unterhaltung ist geschlossen.",
      "CANNOT_DEMOTE_SELF": "Sie können Ihren eigenen Admin-Zugang nicht entfernen.",
      "ROOM_NUMBER_TAKEN": "Diese Zimmernummer ist bereits vergeben.",
      "REFUND_TOO_LARGE": "Die Erstattung übersteigt den Restbetrag dieser Zahlung.",
      "REFUND_FAILED": "Der Zahlungsanbieter hat die Erstattung abgelehnt. Sie wurde für einen erneuten Versuch protokolliert.",
      "SERVICE_INCOMPLETE": "Füllen Sie vor dem Veröffentlichen alle Pflichtangaben aus.",
      "SERVICE_UNAVAILABLE": "Dieser Service ist gerade nicht verfügbar.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Diese Zahlungsart wird hier nicht akzeptiert.",
      "ROOM_CHARGE_NOT_ALLOWED": "Auf das Zimmer buchen ist nur für eingecheckte Gäste möglich.",
      "TOO_SOON": "Bitte wählen Sie eine spätere Uhrzeit.",
      "OUTSIDE_HOURS": "Diese Uhrzeit liegt außerhalb der Servicezeiten.",
      "SLOT_FULL": "Dieses Zeitfenster ist ausgebucht. Bitte wählen Sie ein anderes.",
      "QR_INVALID": "Dieser QR-Code ist ungültig. Bitten Sie das Personal um Hilfe.",
      "ITEM_UNAVAILABLE": "Ein Artikel in Ihrem Warenkorb ist nicht mehr verfügbar.",
      "CANNOT_REDEEM": "Punkte können für bestätigte oder laufende Aufenthalte genutzt werden.",
      "REDEEM_LIMIT": "Das übersteigt die für diese Buchung erlaubten Punkte.",
      "INSUFFICIENT_POINTS": "Nicht genügend Punkte.",
      "WIFI_NOT_READY": "WLAN ist nach dem Check-in verfügbar.",
      "INTERNAL": "Etwas ist schiefgelaufen. Bitte versuchen Sie es erneut."
    },
    "n": {
      "auth.otp": [
        "Ihr Tuloy-Code",
        "Ihr Code lautet {{otp}}. Er läuft in 10 Minuten ab. Geben Sie ihn nicht weiter."
      ],
      "booking.confirmed": [
        "Buchung bestätigt",
        "{{hotel}}: Buchung {{code}} ist bestätigt vom {{checkIn}} bis {{checkOut}}."
      ],
      "booking.cancelled": [
        "Buchung storniert",
        "{{hotel}}: Buchung {{code}} ({{checkIn}} bis {{checkOut}}) wurde storniert. {{reason}}"
      ],
      "payment.receipt": [
        "Zahlung erhalten",
        "Wir haben {{amount}} für Buchung {{code}} erhalten. Vielen Dank!"
      ],
      "refund.issued": [
        "Erstattung unterwegs",
        "{{amount}} für Buchung {{code}} wird auf Ihre ursprüngliche Zahlungsart erstattet."
      ],
      "booking.received": [
        "Buchung eingegangen",
        "{{hotel}} hat Buchung {{code}} erhalten und bestätigt sie in Kürze."
      ],
      "service.updated": [
        null,
        "Status Ihrer Anfrage: {{status}}"
      ],
      "order.updated": [
        "Bestellung {{code}}",
        "Status Ihrer Bestellung: {{status}}"
      ],
      "task.new": [
        "Neue Aufgabe",
        null
      ]
    }
  },
  "it": {
    "e": {
      "UNAUTHENTICATED": "Accedi di nuovo.",
      "FORBIDDEN": "Non hai accesso a questa sezione.",
      "INVALID_CREDENTIALS": "Email/telefono o password errati.",
      "EMPLOYEE_NO_TAKEN": "Un altro membro dello staff ha già questa matricola.",
      "CANNOT_CHANGE": "Questa prenotazione non può più essere modificata.",
      "ACCOUNT_EXISTS": "Esiste già un account con questa email o questo telefono.",
      "LOGIN_REQUIRED": "Inserisci un indirizzo email o un numero di telefono.",
      "INVALID_OTP": "Il codice è errato o scaduto.",
      "HOTEL_REQUIRED": "Hotel mancante.",
      "VALIDATION": "Controlla i campi evidenziati.",
      "NOT_FOUND": "Non trovato.",
      "INVALID_DATES": "Controlla le date: il check-in deve essere oggi o dopo, e prima del check-out.",
      "STAY_TOO_LONG": "I soggiorni sono limitati a 30 notti. Per soggiorni più lunghi contatta l'hotel.",
      "TOO_MANY_GUESTS": "Questa camera non può ospitare così tante persone.",
      "ROOM_UNAVAILABLE": "Spiacenti, questa camera è appena stata prenotata. Scegline un'altra.",
      "HOLD_EXPIRED": "Il blocco della camera è scaduto. Cerca di nuovo.",
      "NOTHING_TO_PAY": "Non c'è più nulla da pagare.",
      "PAYMENT_UNAVAILABLE": "I pagamenti non sono disponibili ora. Riprova tra poco.",
      "CANNOT_CANCEL": "Questa prenotazione non può più essere cancellata.",
      "CANNOT_REVIEW": "Potrai lasciare un feedback quando la prenotazione sarà confermata.",
      "INVALID_TRANSITION": "Questa azione non è possibile nello stato attuale.",
      "TOO_EARLY": "È troppo presto per il check-in di questo ospite.",
      "CONVERSATION_CLOSED": "Questa conversazione è chiusa.",
      "CANNOT_DEMOTE_SELF": "Non puoi rimuovere il tuo accesso da amministratore.",
      "ROOM_NUMBER_TAKEN": "Questo numero di camera è già in uso.",
      "REFUND_TOO_LARGE": "Il rimborso supera l'importo residuo di questo pagamento.",
      "REFUND_FAILED": "Il fornitore di pagamenti non ha accettato il rimborso. È stato registrato per un nuovo tentativo.",
      "SERVICE_INCOMPLETE": "Compila tutti i dati obbligatori prima di pubblicare.",
      "SERVICE_UNAVAILABLE": "Questo servizio non è disponibile ora.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Questo metodo di pagamento non è accettato qui.",
      "ROOM_CHARGE_NOT_ALLOWED": "L'addebito in camera è solo per gli ospiti registrati.",
      "TOO_SOON": "Scegli un orario più tardi.",
      "OUTSIDE_HOURS": "Quell'orario è fuori dall'orario del servizio.",
      "SLOT_FULL": "Quella fascia oraria è piena. Scegline un'altra.",
      "QR_INVALID": "Questo codice QR non è valido. Chiedi aiuto al personale.",
      "ITEM_UNAVAILABLE": "Un articolo nel carrello non è più disponibile.",
      "CANNOT_REDEEM": "I punti si possono usare su soggiorni confermati o in corso.",
      "REDEEM_LIMIT": "Supera i punti consentiti per questa prenotazione.",
      "INSUFFICIENT_POINTS": "Punti insufficienti.",
      "WIFI_NOT_READY": "Il Wi-Fi è disponibile dopo il check-in.",
      "INTERNAL": "Qualcosa è andato storto. Riprova."
    },
    "n": {
      "auth.otp": [
        "Il tuo codice Tuloy",
        "Il tuo codice è {{otp}}. Scade tra 10 minuti. Non condividerlo."
      ],
      "booking.confirmed": [
        "Prenotazione confermata",
        "{{hotel}}: la prenotazione {{code}} è confermata dal {{checkIn}} al {{checkOut}}."
      ],
      "booking.cancelled": [
        "Prenotazione cancellata",
        "{{hotel}}: la prenotazione {{code}} ({{checkIn}} – {{checkOut}}) è cancellata. {{reason}}"
      ],
      "payment.receipt": [
        "Pagamento ricevuto",
        "Abbiamo ricevuto {{amount}} per la prenotazione {{code}}. Grazie!"
      ],
      "refund.issued": [
        "Rimborso in arrivo",
        "{{amount}} della prenotazione {{code}} viene rimborsato sul metodo di pagamento originale."
      ],
      "booking.received": [
        "Prenotazione ricevuta",
        "{{hotel}} ha ricevuto la prenotazione {{code}} e la confermerà a breve."
      ],
      "service.updated": [
        null,
        "La tua richiesta ora è: {{status}}"
      ],
      "order.updated": [
        "Ordine {{code}}",
        "Il tuo ordine ora è: {{status}}"
      ],
      "task.new": [
        "Nuova attività",
        null
      ]
    }
  },
  "ru": {
    "e": {
      "UNAUTHENTICATED": "Войдите снова.",
      "FORBIDDEN": "У вас нет доступа к этому разделу.",
      "INVALID_CREDENTIALS": "Неверный email/телефон или пароль.",
      "EMPLOYEE_NO_TAKEN": "Этот табельный номер уже есть у другого сотрудника.",
      "CANNOT_CHANGE": "Это бронирование больше нельзя изменить.",
      "ACCOUNT_EXISTS": "Аккаунт с этим email или телефоном уже существует.",
      "LOGIN_REQUIRED": "Введите email или номер телефона.",
      "INVALID_OTP": "Код неверный или истёк.",
      "HOTEL_REQUIRED": "Не указан отель.",
      "VALIDATION": "Проверьте выделенные поля.",
      "NOT_FOUND": "Не найдено.",
      "INVALID_DATES": "Проверьте даты: заезд — сегодня или позже и раньше выезда.",
      "STAY_TOO_LONG": "Проживание ограничено 30 ночами. Для более долгого срока свяжитесь с отелем.",
      "TOO_MANY_GUESTS": "Этот номер не вмещает столько гостей.",
      "ROOM_UNAVAILABLE": "Извините, этот номер только что забронировали. Выберите другой.",
      "HOLD_EXPIRED": "Время удержания номера истекло. Повторите поиск.",
      "NOTHING_TO_PAY": "Оплачивать больше нечего.",
      "PAYMENT_UNAVAILABLE": "Оплата сейчас недоступна. Попробуйте чуть позже.",
      "CANNOT_CANCEL": "Это бронирование больше нельзя отменить.",
      "CANNOT_REVIEW": "Оставить отзыв можно после подтверждения бронирования.",
      "INVALID_TRANSITION": "Это действие невозможно в текущем статусе.",
      "TOO_EARLY": "Заселять этого гостя ещё рано.",
      "CONVERSATION_CLOSED": "Этот диалог закрыт.",
      "CANNOT_DEMOTE_SELF": "Нельзя снять с себя права администратора.",
      "ROOM_NUMBER_TAKEN": "Этот номер комнаты уже используется.",
      "REFUND_TOO_LARGE": "Сумма возврата больше остатка по этому платежу.",
      "REFUND_FAILED": "Платёжный провайдер не принял возврат. Он записан для повторной попытки.",
      "SERVICE_INCOMPLETE": "Перед публикацией заполните все обязательные поля.",
      "SERVICE_UNAVAILABLE": "Эта услуга сейчас недоступна.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Этот способ оплаты здесь не принимается.",
      "ROOM_CHARGE_NOT_ALLOWED": "Списание на номер доступно только заселённым гостям.",
      "TOO_SOON": "Выберите более позднее время.",
      "OUTSIDE_HOURS": "Это время вне часов работы услуги.",
      "SLOT_FULL": "Это время уже занято. Выберите другое.",
      "QR_INVALID": "Этот QR-код недействителен. Обратитесь к персоналу.",
      "ITEM_UNAVAILABLE": "Один из товаров в корзине больше недоступен.",
      "CANNOT_REDEEM": "Баллы можно использовать для подтверждённого или текущего проживания.",
      "REDEEM_LIMIT": "Это больше баллов, чем допускает это бронирование.",
      "INSUFFICIENT_POINTS": "Недостаточно баллов.",
      "WIFI_NOT_READY": "Wi-Fi доступен после заселения.",
      "INTERNAL": "Что-то пошло не так. Попробуйте снова."
    },
    "n": {
      "auth.otp": [
        "Ваш код Tuloy",
        "Ваш код: {{otp}}. Он действует 10 минут. Никому его не сообщайте."
      ],
      "booking.confirmed": [
        "Бронирование подтверждено",
        "{{hotel}}: бронирование {{code}} подтверждено с {{checkIn}} по {{checkOut}}."
      ],
      "booking.cancelled": [
        "Бронирование отменено",
        "{{hotel}}: бронирование {{code}} ({{checkIn}} – {{checkOut}}) отменено. {{reason}}"
      ],
      "payment.receipt": [
        "Оплата получена",
        "Мы получили {{amount}} за бронирование {{code}}. Спасибо!"
      ],
      "refund.issued": [
        "Возврат в пути",
        "{{amount}} по бронированию {{code}} возвращается на исходный способ оплаты."
      ],
      "booking.received": [
        "Бронирование получено",
        "{{hotel}} получил бронирование {{code}} и скоро его подтвердит."
      ],
      "service.updated": [
        null,
        "Статус вашего запроса: {{status}}"
      ],
      "order.updated": [
        "Заказ {{code}}",
        "Статус вашего заказа: {{status}}"
      ],
      "task.new": [
        "Новая задача",
        null
      ]
    }
  },
  "ar": {
    "e": {
      "UNAUTHENTICATED": "يرجى تسجيل الدخول مرة أخرى.",
      "FORBIDDEN": "ليس لديك صلاحية الوصول إلى هذا.",
      "INVALID_CREDENTIALS": "البريد الإلكتروني/الهاتف أو كلمة المرور غير صحيحة.",
      "EMPLOYEE_NO_TAKEN": "رقم الموظف هذا مستخدم لدى موظف آخر.",
      "CANNOT_CHANGE": "لم يعد بالإمكان تعديل هذا الحجز.",
      "ACCOUNT_EXISTS": "يوجد حساب بالفعل لهذا البريد الإلكتروني أو الهاتف.",
      "LOGIN_REQUIRED": "أدخل بريدًا إلكترونيًا أو رقم هاتف.",
      "INVALID_OTP": "الرمز غير صحيح أو منتهي الصلاحية.",
      "HOTEL_REQUIRED": "الفندق غير محدد.",
      "VALIDATION": "يرجى مراجعة الحقول المميزة.",
      "NOT_FOUND": "غير موجود.",
      "INVALID_DATES": "راجع التواريخ: يجب أن يكون تسجيل الوصول اليوم أو بعده وقبل المغادرة.",
      "STAY_TOO_LONG": "الحد الأقصى للإقامة 30 ليلة. تواصل مع الفندق لإقامة أطول.",
      "TOO_MANY_GUESTS": "هذه الغرفة لا تتسع لهذا العدد من الضيوف.",
      "ROOM_UNAVAILABLE": "عذرًا، تم حجز هذه الغرفة للتو. يرجى اختيار غرفة أخرى.",
      "HOLD_EXPIRED": "انتهت مدة حجز الغرفة المؤقت. يرجى البحث مجددًا.",
      "NOTHING_TO_PAY": "لا يوجد مبلغ متبقٍ للدفع.",
      "PAYMENT_UNAVAILABLE": "الدفع غير متاح الآن. يرجى المحاولة بعد قليل.",
      "CANNOT_CANCEL": "لم يعد بالإمكان إلغاء هذا الحجز.",
      "CANNOT_REVIEW": "يمكنك ترك تقييم بعد تأكيد الحجز.",
      "INVALID_TRANSITION": "لا يمكن تنفيذ هذا الإجراء في الحالة الحالية.",
      "TOO_EARLY": "لا يزال الوقت مبكرًا لتسجيل وصول هذا الضيف.",
      "CONVERSATION_CLOSED": "هذه المحادثة مغلقة.",
      "CANNOT_DEMOTE_SELF": "لا يمكنك إزالة صلاحية المسؤول الخاصة بك.",
      "ROOM_NUMBER_TAKEN": "رقم الغرفة هذا مستخدم بالفعل.",
      "REFUND_TOO_LARGE": "مبلغ الاسترداد أكبر من المتبقي من هذه الدفعة.",
      "REFUND_FAILED": "لم يقبل مزود الدفع الاسترداد. تم تسجيله لإعادة المحاولة.",
      "SERVICE_INCOMPLETE": "املأ جميع البيانات المطلوبة قبل النشر.",
      "SERVICE_UNAVAILABLE": "هذه الخدمة غير متاحة الآن.",
      "PAYMENT_METHOD_NOT_ALLOWED": "طريقة الدفع هذه غير مقبولة هنا.",
      "ROOM_CHARGE_NOT_ALLOWED": "الإضافة إلى حساب الغرفة متاحة للضيوف المسجلين فقط.",
      "TOO_SOON": "يرجى اختيار وقت لاحق.",
      "OUTSIDE_HOURS": "هذا الوقت خارج ساعات الخدمة.",
      "SLOT_FULL": "هذا الموعد ممتلئ. يرجى اختيار موعد آخر.",
      "QR_INVALID": "رمز QR هذا غير صالح. اطلب المساعدة من الموظفين.",
      "ITEM_UNAVAILABLE": "أحد العناصر في سلتك لم يعد متاحًا.",
      "CANNOT_REDEEM": "يمكن استخدام النقاط في الإقامات المؤكدة أو الحالية.",
      "REDEEM_LIMIT": "هذا أكثر من النقاط المسموح بها لهذا الحجز.",
      "INSUFFICIENT_POINTS": "النقاط غير كافية.",
      "WIFI_NOT_READY": "يتوفر Wi-Fi بعد تسجيل الوصول.",
      "INTERNAL": "حدث خطأ ما. يرجى المحاولة مرة أخرى."
    },
    "n": {
      "auth.otp": [
        "رمز Tuloy الخاص بك",
        "رمزك هو {{otp}}. تنتهي صلاحيته خلال 10 دقائق. لا تشاركه مع أحد."
      ],
      "booking.confirmed": [
        "تم تأكيد الحجز",
        "{{hotel}}: تم تأكيد الحجز {{code}} من {{checkIn}} إلى {{checkOut}}."
      ],
      "booking.cancelled": [
        "تم إلغاء الحجز",
        "{{hotel}}: تم إلغاء الحجز {{code}} ({{checkIn}} إلى {{checkOut}}). {{reason}}"
      ],
      "payment.receipt": [
        "تم استلام الدفعة",
        "استلمنا {{amount}} للحجز {{code}}. شكرًا لك!"
      ],
      "refund.issued": [
        "الاسترداد قيد التنفيذ",
        "يجري استرداد {{amount}} للحجز {{code}} إلى طريقة الدفع الأصلية."
      ],
      "booking.received": [
        "تم استلام الحجز",
        "استلم {{hotel}} الحجز {{code}} وسيؤكده قريبًا."
      ],
      "service.updated": [
        null,
        "حالة طلبك الآن: {{status}}"
      ],
      "order.updated": [
        "الطلب {{code}}",
        "حالة طلبك الآن: {{status}}"
      ],
      "task.new": [
        "مهمة جديدة",
        null
      ]
    }
  },
  "hi": {
    "e": {
      "UNAUTHENTICATED": "कृपया फिर से साइन इन करें।",
      "FORBIDDEN": "आपको इसकी अनुमति नहीं है।",
      "INVALID_CREDENTIALS": "ईमेल/फ़ोन या पासवर्ड गलत है।",
      "EMPLOYEE_NO_TAKEN": "यह कर्मचारी आईडी किसी और स्टाफ़ के पास पहले से है।",
      "CANNOT_CHANGE": "यह बुकिंग अब बदली नहीं जा सकती।",
      "ACCOUNT_EXISTS": "इस ईमेल या फ़ोन से एक खाता पहले से है।",
      "LOGIN_REQUIRED": "ईमेल पता या फ़ोन नंबर डालें।",
      "INVALID_OTP": "कोड गलत है या उसकी अवधि समाप्त हो गई है।",
      "HOTEL_REQUIRED": "होटल नहीं चुना गया।",
      "VALIDATION": "कृपया चिह्नित फ़ील्ड जाँचें।",
      "NOT_FOUND": "नहीं मिला।",
      "INVALID_DATES": "तारीखें जाँचें: चेक-इन आज या बाद में और चेक-आउट से पहले होना चाहिए।",
      "STAY_TOO_LONG": "ठहराव अधिकतम 30 रातों का हो सकता है। लंबे ठहराव के लिए होटल से संपर्क करें।",
      "TOO_MANY_GUESTS": "इस कमरे में इतने मेहमान नहीं ठहर सकते।",
      "ROOM_UNAVAILABLE": "क्षमा करें, यह कमरा अभी बुक हो गया। कृपया दूसरा चुनें।",
      "HOLD_EXPIRED": "कमरा रोकने का समय समाप्त हो गया। फिर से खोजें।",
      "NOTHING_TO_PAY": "भुगतान के लिए कुछ बाकी नहीं है।",
      "PAYMENT_UNAVAILABLE": "अभी भुगतान उपलब्ध नहीं है। थोड़ी देर में फिर कोशिश करें।",
      "CANNOT_CANCEL": "यह बुकिंग अब रद्द नहीं की जा सकती।",
      "CANNOT_REVIEW": "बुकिंग की पुष्टि होने के बाद आप फ़ीडबैक दे सकते हैं।",
      "INVALID_TRANSITION": "मौजूदा स्थिति में यह कार्रवाई संभव नहीं है।",
      "TOO_EARLY": "इस मेहमान का चेक-इन करने के लिए अभी बहुत जल्दी है।",
      "CONVERSATION_CLOSED": "यह बातचीत बंद हो चुकी है।",
      "CANNOT_DEMOTE_SELF": "आप अपना एडमिन एक्सेस नहीं हटा सकते।",
      "ROOM_NUMBER_TAKEN": "यह कमरा नंबर पहले से इस्तेमाल में है।",
      "REFUND_TOO_LARGE": "रिफ़ंड इस भुगतान की बची राशि से अधिक है।",
      "REFUND_FAILED": "भुगतान प्रदाता ने रिफ़ंड स्वीकार नहीं किया। दोबारा प्रयास के लिए दर्ज कर लिया गया है।",
      "SERVICE_INCOMPLETE": "प्रकाशित करने से पहले सभी ज़रूरी जानकारी भरें।",
      "SERVICE_UNAVAILABLE": "यह सेवा अभी उपलब्ध नहीं है।",
      "PAYMENT_METHOD_NOT_ALLOWED": "यहाँ यह भुगतान तरीका स्वीकार नहीं है।",
      "ROOM_CHARGE_NOT_ALLOWED": "कमरे के बिल में जोड़ना केवल चेक-इन किए मेहमानों के लिए है।",
      "TOO_SOON": "कृपया बाद का समय चुनें।",
      "OUTSIDE_HOURS": "यह समय सेवा के घंटों से बाहर है।",
      "SLOT_FULL": "यह समय स्लॉट भर गया है। दूसरा चुनें।",
      "QR_INVALID": "यह QR कोड मान्य नहीं है। स्टाफ़ से मदद लें।",
      "ITEM_UNAVAILABLE": "आपकी कार्ट का एक आइटम अब उपलब्ध नहीं है।",
      "CANNOT_REDEEM": "पॉइंट पुष्टि हुए या चल रहे ठहराव पर इस्तेमाल हो सकते हैं।",
      "REDEEM_LIMIT": "यह इस बुकिंग की पॉइंट सीमा से अधिक है।",
      "INSUFFICIENT_POINTS": "पर्याप्त पॉइंट नहीं हैं।",
      "WIFI_NOT_READY": "Wi-Fi चेक-इन के बाद उपलब्ध होगा।",
      "INTERNAL": "कुछ गलत हो गया। कृपया फिर कोशिश करें।"
    },
    "n": {
      "auth.otp": [
        "आपका Tuloy कोड",
        "आपका कोड {{otp}} है। यह 10 मिनट में समाप्त हो जाएगा। इसे किसी से साझा न करें।"
      ],
      "booking.confirmed": [
        "बुकिंग की पुष्टि हुई",
        "{{hotel}}: बुकिंग {{code}} की पुष्टि {{checkIn}} से {{checkOut}} तक हो गई है।"
      ],
      "booking.cancelled": [
        "बुकिंग रद्द",
        "{{hotel}}: बुकिंग {{code}} ({{checkIn}} से {{checkOut}}) रद्द कर दी गई है। {{reason}}"
      ],
      "payment.receipt": [
        "भुगतान प्राप्त हुआ",
        "हमें बुकिंग {{code}} के लिए {{amount}} मिल गए हैं। धन्यवाद!"
      ],
      "refund.issued": [
        "रिफ़ंड प्रक्रिया में",
        "बुकिंग {{code}} के {{amount}} आपके मूल भुगतान तरीके पर लौटाए जा रहे हैं।"
      ],
      "booking.received": [
        "बुकिंग प्राप्त हुई",
        "{{hotel}} को बुकिंग {{code}} मिल गई है और जल्द ही पुष्टि होगी।"
      ],
      "service.updated": [
        null,
        "आपके अनुरोध की स्थिति: {{status}}"
      ],
      "order.updated": [
        "ऑर्डर {{code}}",
        "आपके ऑर्डर की स्थिति: {{status}}"
      ],
      "task.new": [
        "नया काम",
        null
      ]
    }
  },
  "id": {
    "e": {
      "UNAUTHENTICATED": "Silakan masuk lagi.",
      "FORBIDDEN": "Anda tidak punya akses ke sini.",
      "INVALID_CREDENTIALS": "Email/telepon atau kata sandi salah.",
      "EMPLOYEE_NO_TAKEN": "ID karyawan ini sudah dipakai staf lain.",
      "CANNOT_CHANGE": "Pemesanan ini tidak dapat diubah lagi.",
      "ACCOUNT_EXISTS": "Sudah ada akun untuk email atau telepon ini.",
      "LOGIN_REQUIRED": "Masukkan alamat email atau nomor telepon.",
      "INVALID_OTP": "Kode salah atau sudah kedaluwarsa.",
      "HOTEL_REQUIRED": "Hotel belum dipilih.",
      "VALIDATION": "Periksa kolom yang ditandai.",
      "NOT_FOUND": "Tidak ditemukan.",
      "INVALID_DATES": "Periksa tanggal: check-in harus hari ini atau setelahnya, dan sebelum check-out.",
      "STAY_TOO_LONG": "Menginap maksimal 30 malam. Hubungi hotel untuk menginap lebih lama.",
      "TOO_MANY_GUESTS": "Kamar ini tidak muat untuk tamu sebanyak itu.",
      "ROOM_UNAVAILABLE": "Maaf, kamar ini baru saja dipesan. Silakan pilih yang lain.",
      "HOLD_EXPIRED": "Waktu penahanan habis. Silakan cari lagi.",
      "NOTHING_TO_PAY": "Tidak ada yang perlu dibayar.",
      "PAYMENT_UNAVAILABLE": "Pembayaran sedang tidak tersedia. Coba lagi sebentar lagi.",
      "CANNOT_CANCEL": "Pemesanan ini tidak dapat dibatalkan lagi.",
      "CANNOT_REVIEW": "Anda dapat memberi ulasan setelah pemesanan dikonfirmasi.",
      "INVALID_TRANSITION": "Tindakan ini tidak bisa dilakukan pada status saat ini.",
      "TOO_EARLY": "Masih terlalu awal untuk check-in tamu ini.",
      "CONVERSATION_CLOSED": "Percakapan ini sudah ditutup.",
      "CANNOT_DEMOTE_SELF": "Anda tidak dapat menghapus akses admin Anda sendiri.",
      "ROOM_NUMBER_TAKEN": "Nomor kamar itu sudah dipakai.",
      "REFUND_TOO_LARGE": "Pengembalian dana melebihi sisa pembayaran ini.",
      "REFUND_FAILED": "Penyedia pembayaran menolak pengembalian dana. Sudah dicatat untuk dicoba lagi.",
      "SERVICE_INCOMPLETE": "Lengkapi semua data wajib sebelum menerbitkan.",
      "SERVICE_UNAVAILABLE": "Layanan ini sedang tidak tersedia.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Metode pembayaran itu tidak diterima di sini.",
      "ROOM_CHARGE_NOT_ALLOWED": "Tagihan ke kamar hanya untuk tamu yang sudah check-in.",
      "TOO_SOON": "Pilih waktu yang lebih lambat.",
      "OUTSIDE_HOURS": "Waktu itu di luar jam layanan.",
      "SLOT_FULL": "Slot waktu itu penuh. Pilih yang lain.",
      "QR_INVALID": "Kode QR ini tidak valid. Minta bantuan staf.",
      "ITEM_UNAVAILABLE": "Ada item di keranjang yang tidak tersedia lagi.",
      "CANNOT_REDEEM": "Poin dapat dipakai pada menginap yang dikonfirmasi atau sedang berlangsung.",
      "REDEEM_LIMIT": "Melebihi batas poin untuk pemesanan ini.",
      "INSUFFICIENT_POINTS": "Poin tidak cukup.",
      "WIFI_NOT_READY": "Wi-Fi tersedia setelah check-in.",
      "INTERNAL": "Terjadi kesalahan. Silakan coba lagi."
    },
    "n": {
      "auth.otp": [
        "Kode Tuloy Anda",
        "Kode Anda {{otp}}. Berlaku 10 menit. Jangan bagikan ke siapa pun."
      ],
      "booking.confirmed": [
        "Pemesanan dikonfirmasi",
        "{{hotel}}: pemesanan {{code}} dikonfirmasi untuk {{checkIn}} sampai {{checkOut}}."
      ],
      "booking.cancelled": [
        "Pemesanan dibatalkan",
        "{{hotel}}: pemesanan {{code}} ({{checkIn}} sampai {{checkOut}}) dibatalkan. {{reason}}"
      ],
      "payment.receipt": [
        "Pembayaran diterima",
        "Kami menerima {{amount}} untuk pemesanan {{code}}. Terima kasih!"
      ],
      "refund.issued": [
        "Pengembalian dana diproses",
        "{{amount}} untuk pemesanan {{code}} sedang dikembalikan ke metode pembayaran asal."
      ],
      "booking.received": [
        "Pemesanan diterima",
        "{{hotel}} menerima pemesanan {{code}} dan akan segera mengonfirmasinya."
      ],
      "service.updated": [
        null,
        "Status permintaan Anda: {{status}}"
      ],
      "order.updated": [
        "Pesanan {{code}}",
        "Status pesanan Anda: {{status}}"
      ],
      "task.new": [
        "Tugas baru",
        null
      ]
    }
  },
  "vi": {
    "e": {
      "UNAUTHENTICATED": "Vui lòng đăng nhập lại.",
      "FORBIDDEN": "Bạn không có quyền truy cập.",
      "INVALID_CREDENTIALS": "Email/số điện thoại hoặc mật khẩu không đúng.",
      "EMPLOYEE_NO_TAKEN": "Mã nhân viên này đã thuộc về nhân viên khác.",
      "CANNOT_CHANGE": "Không thể thay đổi đặt phòng này nữa.",
      "ACCOUNT_EXISTS": "Đã có tài khoản với email hoặc số điện thoại này.",
      "LOGIN_REQUIRED": "Nhập email hoặc số điện thoại.",
      "INVALID_OTP": "Mã không đúng hoặc đã hết hạn.",
      "HOTEL_REQUIRED": "Thiếu thông tin khách sạn.",
      "VALIDATION": "Vui lòng kiểm tra các trường được đánh dấu.",
      "NOT_FOUND": "Không tìm thấy.",
      "INVALID_DATES": "Kiểm tra ngày: nhận phòng phải từ hôm nay trở đi và trước ngày trả phòng.",
      "STAY_TOO_LONG": "Mỗi lần lưu trú tối đa 30 đêm. Liên hệ khách sạn nếu ở lâu hơn.",
      "TOO_MANY_GUESTS": "Phòng này không đủ chỗ cho số khách đó.",
      "ROOM_UNAVAILABLE": "Rất tiếc, phòng này vừa được đặt. Vui lòng chọn phòng khác.",
      "HOLD_EXPIRED": "Hết thời gian giữ phòng. Vui lòng tìm lại.",
      "NOTHING_TO_PAY": "Không còn khoản nào cần thanh toán.",
      "PAYMENT_UNAVAILABLE": "Hiện không thể thanh toán. Vui lòng thử lại sau ít phút.",
      "CANNOT_CANCEL": "Không thể hủy đặt phòng này nữa.",
      "CANNOT_REVIEW": "Bạn có thể góp ý sau khi đặt phòng được xác nhận.",
      "INVALID_TRANSITION": "Không thể thực hiện thao tác này ở trạng thái hiện tại.",
      "TOO_EARLY": "Còn quá sớm để nhận phòng cho khách này.",
      "CONVERSATION_CLOSED": "Cuộc trò chuyện này đã đóng.",
      "CANNOT_DEMOTE_SELF": "Bạn không thể tự gỡ quyền quản trị của mình.",
      "ROOM_NUMBER_TAKEN": "Số phòng này đã được dùng.",
      "REFUND_TOO_LARGE": "Số tiền hoàn vượt quá phần còn lại của khoản thanh toán.",
      "REFUND_FAILED": "Nhà cung cấp thanh toán không chấp nhận hoàn tiền. Đã ghi lại để thử lại.",
      "SERVICE_INCOMPLETE": "Điền đủ thông tin bắt buộc trước khi xuất bản.",
      "SERVICE_UNAVAILABLE": "Dịch vụ này hiện không khả dụng.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Phương thức thanh toán này không được chấp nhận ở đây.",
      "ROOM_CHARGE_NOT_ALLOWED": "Chỉ khách đã nhận phòng mới được tính vào phòng.",
      "TOO_SOON": "Vui lòng chọn thời gian muộn hơn.",
      "OUTSIDE_HOURS": "Thời gian đó ngoài giờ phục vụ.",
      "SLOT_FULL": "Khung giờ đó đã kín. Vui lòng chọn giờ khác.",
      "QR_INVALID": "Mã QR này không hợp lệ. Hãy nhờ nhân viên hỗ trợ.",
      "ITEM_UNAVAILABLE": "Một món trong giỏ hàng không còn nữa.",
      "CANNOT_REDEEM": "Điểm dùng được cho kỳ lưu trú đã xác nhận hoặc đang diễn ra.",
      "REDEEM_LIMIT": "Vượt quá số điểm cho phép của đặt phòng này.",
      "INSUFFICIENT_POINTS": "Không đủ điểm.",
      "WIFI_NOT_READY": "Wi-Fi có sau khi nhận phòng.",
      "INTERNAL": "Đã xảy ra lỗi. Vui lòng thử lại."
    },
    "n": {
      "auth.otp": [
        "Mã Tuloy của bạn",
        "Mã của bạn là {{otp}}. Mã hết hạn sau 10 phút. Không chia sẻ mã này."
      ],
      "booking.confirmed": [
        "Đã xác nhận đặt phòng",
        "{{hotel}}: đặt phòng {{code}} đã được xác nhận từ {{checkIn}} đến {{checkOut}}."
      ],
      "booking.cancelled": [
        "Đã hủy đặt phòng",
        "{{hotel}}: đặt phòng {{code}} ({{checkIn}} đến {{checkOut}}) đã bị hủy. {{reason}}"
      ],
      "payment.receipt": [
        "Đã nhận thanh toán",
        "Chúng tôi đã nhận {{amount}} cho đặt phòng {{code}}. Cảm ơn bạn!"
      ],
      "refund.issued": [
        "Đang hoàn tiền",
        "{{amount}} của đặt phòng {{code}} đang được hoàn về phương thức thanh toán ban đầu."
      ],
      "booking.received": [
        "Đã nhận đặt phòng",
        "{{hotel}} đã nhận đặt phòng {{code}} và sẽ sớm xác nhận."
      ],
      "service.updated": [
        null,
        "Trạng thái yêu cầu: {{status}}"
      ],
      "order.updated": [
        "Đơn {{code}}",
        "Trạng thái đơn: {{status}}"
      ],
      "task.new": [
        "Công việc mới",
        null
      ]
    }
  },
  "th": {
    "e": {
      "UNAUTHENTICATED": "กรุณาเข้าสู่ระบบอีกครั้ง",
      "FORBIDDEN": "คุณไม่มีสิทธิ์เข้าถึงส่วนนี้",
      "INVALID_CREDENTIALS": "อีเมล/โทรศัพท์หรือรหัสผ่านไม่ถูกต้อง",
      "EMPLOYEE_NO_TAKEN": "รหัสพนักงานนี้มีพนักงานคนอื่นใช้อยู่แล้ว",
      "CANNOT_CHANGE": "ไม่สามารถเปลี่ยนการจองนี้ได้แล้ว",
      "ACCOUNT_EXISTS": "มีบัญชีของอีเมลหรือโทรศัพท์นี้อยู่แล้ว",
      "LOGIN_REQUIRED": "ใส่อีเมลหรือหมายเลขโทรศัพท์",
      "INVALID_OTP": "รหัสไม่ถูกต้องหรือหมดอายุแล้ว",
      "HOTEL_REQUIRED": "ไม่ได้ระบุโรงแรม",
      "VALIDATION": "กรุณาตรวจสอบช่องที่ไฮไลต์",
      "NOT_FOUND": "ไม่พบ",
      "INVALID_DATES": "ตรวจสอบวันที่: เช็กอินต้องเป็นวันนี้หรือหลังจากนี้ และก่อนวันเช็กเอาต์",
      "STAY_TOO_LONG": "เข้าพักได้สูงสุด 30 คืน หากต้องการพักนานกว่านี้โปรดติดต่อโรงแรม",
      "TOO_MANY_GUESTS": "ห้องนี้รองรับผู้เข้าพักจำนวนนั้นไม่ได้",
      "ROOM_UNAVAILABLE": "ขออภัย ห้องนี้เพิ่งถูกจองไป กรุณาเลือกห้องอื่น",
      "HOLD_EXPIRED": "หมดเวลากันห้องแล้ว กรุณาค้นหาอีกครั้ง",
      "NOTHING_TO_PAY": "ไม่มียอดค้างชำระ",
      "PAYMENT_UNAVAILABLE": "ขณะนี้ชำระเงินไม่ได้ กรุณาลองใหม่อีกสักครู่",
      "CANNOT_CANCEL": "ไม่สามารถยกเลิกการจองนี้ได้แล้ว",
      "CANNOT_REVIEW": "คุณให้ความคิดเห็นได้เมื่อการจองได้รับการยืนยันแล้ว",
      "INVALID_TRANSITION": "ทำรายการนี้ไม่ได้ในสถานะปัจจุบัน",
      "TOO_EARLY": "ยังเร็วเกินไปที่จะเช็กอินให้ผู้เข้าพักรายนี้",
      "CONVERSATION_CLOSED": "การสนทนานี้ปิดแล้ว",
      "CANNOT_DEMOTE_SELF": "คุณไม่สามารถลบสิทธิ์ผู้ดูแลของตัวเองได้",
      "ROOM_NUMBER_TAKEN": "หมายเลขห้องนี้ถูกใช้แล้ว",
      "REFUND_TOO_LARGE": "ยอดคืนเงินมากกว่ายอดคงเหลือของการชำระนี้",
      "REFUND_FAILED": "ผู้ให้บริการชำระเงินไม่รับการคืนเงิน บันทึกไว้เพื่อลองใหม่แล้ว",
      "SERVICE_INCOMPLETE": "กรอกข้อมูลที่จำเป็นให้ครบก่อนเผยแพร่",
      "SERVICE_UNAVAILABLE": "บริการนี้ไม่พร้อมให้บริการในขณะนี้",
      "PAYMENT_METHOD_NOT_ALLOWED": "ไม่รับวิธีชำระเงินนี้สำหรับรายการนี้",
      "ROOM_CHARGE_NOT_ALLOWED": "เรียกเก็บเข้าห้องได้เฉพาะผู้เข้าพักที่เช็กอินแล้ว",
      "TOO_SOON": "กรุณาเลือกเวลาที่ช้ากว่านี้",
      "OUTSIDE_HOURS": "เวลานั้นอยู่นอกเวลาให้บริการ",
      "SLOT_FULL": "ช่วงเวลานั้นเต็มแล้ว กรุณาเลือกเวลาอื่น",
      "QR_INVALID": "QR โค้ดนี้ไม่ถูกต้อง กรุณาขอความช่วยเหลือจากพนักงาน",
      "ITEM_UNAVAILABLE": "สินค้าในตะกร้าบางรายการไม่มีแล้ว",
      "CANNOT_REDEEM": "ใช้คะแนนได้กับการเข้าพักที่ยืนยันแล้วหรือกำลังเข้าพัก",
      "REDEEM_LIMIT": "เกินจำนวนคะแนนที่การจองนี้อนุญาต",
      "INSUFFICIENT_POINTS": "คะแนนไม่พอ",
      "WIFI_NOT_READY": "ใช้ Wi-Fi ได้หลังเช็กอิน",
      "INTERNAL": "เกิดข้อผิดพลาด กรุณาลองอีกครั้ง"
    },
    "n": {
      "auth.otp": [
        "รหัส Tuloy ของคุณ",
        "รหัสของคุณคือ {{otp}} หมดอายุใน 10 นาที ห้ามแชร์รหัสนี้"
      ],
      "booking.confirmed": [
        "ยืนยันการจองแล้ว",
        "{{hotel}}: การจอง {{code}} ได้รับการยืนยันแล้ว {{checkIn}} ถึง {{checkOut}}"
      ],
      "booking.cancelled": [
        "ยกเลิกการจองแล้ว",
        "{{hotel}}: การจอง {{code}} ({{checkIn}} ถึง {{checkOut}}) ถูกยกเลิกแล้ว {{reason}}"
      ],
      "payment.receipt": [
        "ได้รับการชำระเงินแล้ว",
        "เราได้รับ {{amount}} สำหรับการจอง {{code}} แล้ว ขอบคุณ!"
      ],
      "refund.issued": [
        "กำลังคืนเงิน",
        "กำลังคืนเงิน {{amount}} ของการจอง {{code}} ไปยังวิธีชำระเงินเดิม"
      ],
      "booking.received": [
        "ได้รับการจองแล้ว",
        "{{hotel}} ได้รับการจอง {{code}} แล้ว และจะยืนยันในไม่ช้า"
      ],
      "service.updated": [
        null,
        "สถานะคำขอของคุณ: {{status}}"
      ],
      "order.updated": [
        "ออร์เดอร์ {{code}}",
        "สถานะออร์เดอร์ของคุณ: {{status}}"
      ],
      "task.new": [
        "งานใหม่",
        null
      ]
    }
  },
  "ms": {
    "e": {
      "UNAUTHENTICATED": "Sila log masuk semula.",
      "FORBIDDEN": "Anda tiada akses ke sini.",
      "INVALID_CREDENTIALS": "E-mel/telefon atau kata laluan salah.",
      "EMPLOYEE_NO_TAKEN": "ID pekerja ini sudah digunakan oleh kakitangan lain.",
      "CANNOT_CHANGE": "Tempahan ini tidak boleh ditukar lagi.",
      "ACCOUNT_EXISTS": "Akaun untuk e-mel atau telefon ini sudah wujud.",
      "LOGIN_REQUIRED": "Masukkan alamat e-mel atau nombor telefon.",
      "INVALID_OTP": "Kod salah atau telah tamat tempoh.",
      "HOTEL_REQUIRED": "Hotel tidak dinyatakan.",
      "VALIDATION": "Sila semak medan yang ditanda.",
      "NOT_FOUND": "Tidak dijumpai.",
      "INVALID_DATES": "Semak tarikh: daftar masuk mesti hari ini atau selepasnya, dan sebelum daftar keluar.",
      "STAY_TOO_LONG": "Penginapan terhad kepada 30 malam. Hubungi hotel untuk penginapan lebih lama.",
      "TOO_MANY_GUESTS": "Bilik ini tidak muat untuk seramai itu.",
      "ROOM_UNAVAILABLE": "Maaf, bilik ini baru sahaja ditempah. Sila pilih bilik lain.",
      "HOLD_EXPIRED": "Masa tahanan tamat. Sila cari semula.",
      "NOTHING_TO_PAY": "Tiada baki untuk dibayar.",
      "PAYMENT_UNAVAILABLE": "Pembayaran tidak tersedia sekarang. Sila cuba sebentar lagi.",
      "CANNOT_CANCEL": "Tempahan ini tidak boleh dibatalkan lagi.",
      "CANNOT_REVIEW": "Anda boleh memberi maklum balas selepas tempahan disahkan.",
      "INVALID_TRANSITION": "Tindakan ini tidak boleh dibuat pada status semasa.",
      "TOO_EARLY": "Masih terlalu awal untuk mendaftar masuk tetamu ini.",
      "CONVERSATION_CLOSED": "Perbualan ini telah ditutup.",
      "CANNOT_DEMOTE_SELF": "Anda tidak boleh membuang akses pentadbir anda sendiri.",
      "ROOM_NUMBER_TAKEN": "Nombor bilik itu sudah digunakan.",
      "REFUND_TOO_LARGE": "Bayaran balik melebihi baki pembayaran ini.",
      "REFUND_FAILED": "Penyedia pembayaran menolak bayaran balik. Ia telah dilog untuk dicuba semula.",
      "SERVICE_INCOMPLETE": "Lengkapkan semua butiran wajib sebelum menerbitkan.",
      "SERVICE_UNAVAILABLE": "Perkhidmatan ini tidak tersedia sekarang.",
      "PAYMENT_METHOD_NOT_ALLOWED": "Kaedah pembayaran itu tidak diterima di sini.",
      "ROOM_CHARGE_NOT_ALLOWED": "Caj ke bilik hanya untuk tetamu yang telah daftar masuk.",
      "TOO_SOON": "Sila pilih masa yang lebih lewat.",
      "OUTSIDE_HOURS": "Masa itu di luar waktu perkhidmatan.",
      "SLOT_FULL": "Slot masa itu penuh. Sila pilih yang lain.",
      "QR_INVALID": "Kod QR ini tidak sah. Minta bantuan kakitangan.",
      "ITEM_UNAVAILABLE": "Satu item dalam troli anda tidak lagi tersedia.",
      "CANNOT_REDEEM": "Mata boleh digunakan pada penginapan yang disahkan atau sedang berlangsung.",
      "REDEEM_LIMIT": "Melebihi had mata untuk tempahan ini.",
      "INSUFFICIENT_POINTS": "Mata tidak mencukupi.",
      "WIFI_NOT_READY": "Wi-Fi tersedia selepas daftar masuk.",
      "INTERNAL": "Berlaku ralat. Sila cuba lagi."
    },
    "n": {
      "auth.otp": [
        "Kod Tuloy anda",
        "Kod anda ialah {{otp}}. Ia tamat dalam 10 minit. Jangan kongsikan."
      ],
      "booking.confirmed": [
        "Tempahan disahkan",
        "{{hotel}}: tempahan {{code}} disahkan dari {{checkIn}} hingga {{checkOut}}."
      ],
      "booking.cancelled": [
        "Tempahan dibatalkan",
        "{{hotel}}: tempahan {{code}} ({{checkIn}} hingga {{checkOut}}) dibatalkan. {{reason}}"
      ],
      "payment.receipt": [
        "Pembayaran diterima",
        "Kami telah menerima {{amount}} untuk tempahan {{code}}. Terima kasih!"
      ],
      "refund.issued": [
        "Bayaran balik sedang diproses",
        "{{amount}} untuk tempahan {{code}} sedang dikembalikan ke kaedah pembayaran asal anda."
      ],
      "booking.received": [
        "Tempahan diterima",
        "{{hotel}} telah menerima tempahan {{code}} dan akan mengesahkannya tidak lama lagi."
      ],
      "service.updated": [
        null,
        "Status permintaan anda: {{status}}"
      ],
      "order.updated": [
        "Pesanan {{code}}",
        "Status pesanan anda: {{status}}"
      ],
      "task.new": [
        "Tugas baharu",
        null
      ]
    }
  }
};
