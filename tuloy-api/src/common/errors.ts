import { ArgumentsHost, Catch, ExceptionFilter, HttpException } from '@nestjs/common';
import type { Request, Response } from 'express';
import { Locale, pickLocale } from './i18n';

/** Throw this from anywhere. `code` is stable for the app; the message is localized. */
export class AppError extends HttpException {
  constructor(public readonly code: string, status = 400, public readonly details?: unknown) {
    super(code, status);
  }
}

// Translations need review by the hotel's approver (open decision #13).
const MESSAGES: Record<string, Record<Locale, string>> = {
  UNAUTHENTICATED: {
    en: 'Please sign in again.',
    fil: 'Mag-sign in muli.',
    ceb: 'Palihug sign in pag-usab.',
  },
  FORBIDDEN: {
    en: 'You do not have access to this.',
    fil: 'Wala kang pahintulot dito.',
    ceb: 'Wala kay pagtugot niini.',
  },
  INVALID_CREDENTIALS: {
    en: 'Wrong email/phone or password.',
    fil: 'Mali ang email/phone o password.',
    ceb: 'Sayop ang email/phone o password.',
  },
  EMPLOYEE_NO_TAKEN: {
    en: 'Another staff member already has this employee ID.',
    fil: 'May ibang staff na may ganitong employee ID.',
    ceb: 'Naa nay laing staff nga adunay ingon ani nga employee ID.',
  },
  ACCOUNT_EXISTS: {
    en: 'An account already exists for this email or phone.',
    fil: 'May account na para sa email o phone na ito.',
    ceb: 'Naa nay account para niining email o phone.',
  },
  LOGIN_REQUIRED: {
    en: 'Enter an email address or phone number.',
    fil: 'Maglagay ng email o numero ng telepono.',
    ceb: 'Ibutang ang email o numero sa telepono.',
  },
  INVALID_OTP: {
    en: 'The code is wrong or has expired.',
    fil: 'Mali o expired na ang code.',
    ceb: 'Sayop o expired na ang code.',
  },
  HOTEL_REQUIRED: { en: 'Hotel is missing.', fil: 'Walang napiling hotel.', ceb: 'Walay hotel nga napili.' },
  VALIDATION: {
    en: 'Please check the highlighted fields.',
    fil: 'Pakisuri ang mga field.',
    ceb: 'Palihug susiha ang mga field.',
  },
  NOT_FOUND: { en: 'Not found.', fil: 'Hindi nahanap.', ceb: 'Wala makit-i.' },
  INVALID_DATES: {
    en: 'Check the dates: check-in must be today or later and before check-out.',
    fil: 'Suriin ang petsa: ang check-in ay ngayon o mamaya, at bago ang check-out.',
    ceb: 'Susiha ang petsa: ang check-in kinahanglan karon o sunod, ug una sa check-out.',
  },
  STAY_TOO_LONG: {
    en: 'Stays are limited to 30 nights. Contact the hotel for longer stays.',
    fil: 'Hanggang 30 gabi lang ang booking. Kontakin ang hotel para sa mas mahaba.',
    ceb: 'Hangtod 30 ka gabii lang ang booking. Kontaka ang hotel para sa mas taas.',
  },
  TOO_MANY_GUESTS: {
    en: 'This room does not fit that many guests.',
    fil: 'Hindi kasya ang ganoong dami ng bisita sa kuwartong ito.',
    ceb: 'Dili kasarang ang ingon kadaghan nga bisita niining kwartoha.',
  },
  ROOM_UNAVAILABLE: {
    en: 'Sorry, this room was just booked. Please choose another.',
    fil: 'Paumanhin, kaka-book lang ng kuwartong ito. Pumili ng iba.',
    ceb: 'Pasayloa, bag-o lang na-book kini nga kwarto. Pagpili og lain.',
  },
  HOLD_EXPIRED: {
    en: 'Your hold has expired. Please search again.',
    fil: 'Nag-expire na ang iyong hold. Maghanap muli.',
    ceb: 'Na-expire na ang imong hold. Pangita pag-usab.',
  },
  NOTHING_TO_PAY: { en: 'Nothing left to pay.', fil: 'Wala nang babayaran.', ceb: 'Wala nay bayranan.' },
  PAYMENT_UNAVAILABLE: {
    en: 'Payments are unavailable right now. Please try again shortly.',
    fil: 'Hindi available ang pagbabayad ngayon. Subukan muli mamaya.',
    ceb: 'Dili magamit ang pagbayad karon. Sulayi pag-usab unya.',
  },
  CANNOT_CANCEL: {
    en: 'This booking can no longer be cancelled.',
    fil: 'Hindi na maaaring kanselahin ang booking na ito.',
    ceb: 'Dili na makansela kini nga booking.',
  },
  CANNOT_REVIEW: {
    en: 'You can leave feedback once your booking is confirmed.',
    fil: 'Makakapagbigay ka ng feedback kapag kumpirmado na ang booking.',
    ceb: 'Makahatag ka og feedback kung kumpirmado na ang booking.',
  },
  IDEMPOTENCY_KEY_REQUIRED: { en: 'Missing request key.', fil: 'Kulang ang request key.', ceb: 'Kulang ang request key.' },
  IDEMPOTENCY_CONFLICT: {
    en: 'This request was already used.',
    fil: 'Nagamit na ang request na ito.',
    ceb: 'Nagamit na kini nga request.',
  },
  INVALID_SIGNATURE: { en: 'Invalid signature.', fil: 'Invalid signature.', ceb: 'Invalid signature.' },
  INVALID_TRANSITION: {
    en: "This action isn't possible for the current status.",
    fil: "Hindi ito maaari sa kasalukuyang status.",
    ceb: "Dili kini mahimo sa karon nga status.",
  },
  TOO_EARLY: {
    en: "It's too early to check this guest in.",
    fil: "Masyado pang maaga para i-check in ang bisita.",
    ceb: "Sayo pa kaayo aron i-check in ang bisita.",
  },
  CONVERSATION_CLOSED: {
    en: "This conversation is closed.",
    fil: "Sarado na ang usapang ito.",
    ceb: "Sirado na kini nga panag-istorya.",
  },
  CANNOT_DEMOTE_SELF: {
    en: "You can't remove your own admin access.",
    fil: "Hindi mo maaaring alisin ang sarili mong admin access.",
    ceb: "Dili nimo makuha ang imong kaugalingong admin access.",
  },
  ROOM_NUMBER_TAKEN: {
    en: "That room number is already used.",
    fil: "Nagamit na ang numerong ito ng kuwarto.",
    ceb: "Nagamit na kini nga numero sa kwarto.",
  },
  REFUND_TOO_LARGE: {
    en: "The refund is more than what's left on this payment.",
    fil: "Mas malaki ang refund kaysa natitira sa bayad.",
    ceb: "Mas dako ang refund kaysa nabilin sa bayad.",
  },
  REFUND_FAILED: {
    en: "The payment provider didn't accept the refund. It is logged for retry.",
    fil: "Hindi tinanggap ng payment provider ang refund. Naka-log ito para subukan muli.",
    ceb: "Wala gidawat sa payment provider ang refund. Na-log kini aron sulayan pag-usab.",
  },
  SERVICE_INCOMPLETE: {
    en: "Fill in all required details before publishing.",
    fil: "Kumpletuhin ang mga kailangang detalye bago i-publish.",
    ceb: "Kompletoha ang gikinahanglan nga detalye sa dili pa i-publish.",
  },
  SERVICE_UNAVAILABLE: {
    en: "This service isn't available right now.",
    fil: "Hindi available ang serbisyong ito ngayon.",
    ceb: "Dili magamit kini nga serbisyo karon.",
  },
  PAYMENT_METHOD_NOT_ALLOWED: {
    en: "That payment method isn't accepted for this.",
    fil: "Hindi tinatanggap ang paraan ng pagbabayad na iyan.",
    ceb: "Dili gidawat kana nga paagi sa pagbayad.",
  },
  ROOM_CHARGE_NOT_ALLOWED: {
    en: "Charge to room is only for checked-in guests.",
    fil: "Para lang sa naka-check-in na bisita ang charge to room.",
    ceb: "Para lang sa naka-check-in nga bisita ang charge to room.",
  },
  TOO_SOON: {
    en: "Please choose a later time.",
    fil: "Pumili ng mas huling oras.",
    ceb: "Pagpili og mas ulahi nga oras.",
  },
  OUTSIDE_HOURS: {
    en: "That time is outside service hours.",
    fil: "Labas sa oras ng serbisyo ang oras na iyan.",
    ceb: "Gawas sa oras sa serbisyo kana nga oras.",
  },
  SLOT_FULL: {
    en: "That time slot is full. Please pick another.",
    fil: "Puno na ang oras na iyan. Pumili ng iba.",
    ceb: "Puno na kana nga oras. Pagpili og lain.",
  },
  QR_INVALID: {
    en: "This QR code is not valid. Ask the staff for help.",
    fil: "Hindi valid ang QR code na ito. Humingi ng tulong sa staff.",
    ceb: "Dili valid kini nga QR code. Pangayo og tabang sa staff.",
  },
  ITEM_UNAVAILABLE: {
    en: "An item in your cart is no longer available.",
    fil: "May item sa cart na hindi na available.",
    ceb: "Naay item sa cart nga dili na magamit.",
  },
  CANNOT_REDEEM: {
    en: "Points can be used on confirmed or current stays.",
    fil: "Magagamit ang points sa kumpirmado o kasalukuyang pananatili.",
    ceb: "Magamit ang points sa kumpirmado o karon nga pagpuyo.",
  },
  REDEEM_LIMIT: {
    en: "That's more than this booking allows in points.",
    fil: "Lampas na ito sa pinapayagang points para sa booking.",
    ceb: "Labaw na kini sa gitugot nga points para sa booking.",
  },
  INSUFFICIENT_POINTS: {
    en: "Not enough points.",
    fil: "Kulang ang points.",
    ceb: "Kulang ang points.",
  },
  WIFI_NOT_READY: {
    en: "Wi-Fi access is ready after check-in.",
    fil: "Magagamit ang Wi-Fi pagkatapos mag-check-in.",
    ceb: "Magamit ang Wi-Fi human sa check-in.",
  },
  INTERNAL: {
    en: 'Something went wrong. Please try again.',
    fil: 'May nangyaring mali. Pakisubukan muli.',
    ceb: 'Naay sayop. Palihug sulayi pag-usab.',
  },
};

/** Every error leaves the API as { error: { code, message, details } }. */
@Catch()
export class AppExceptionFilter implements ExceptionFilter {
  catch(e: unknown, host: ArgumentsHost) {
    const req = host.switchToHttp().getRequest<Request>();
    const res = host.switchToHttp().getResponse<Response>();
    let status = 500;
    let code = 'INTERNAL';
    let details: unknown;
    if (e instanceof AppError) {
      status = e.getStatus();
      code = e.code;
      details = e.details;
    } else if (e instanceof HttpException) {
      status = e.getStatus();
      code = status === 400 ? 'VALIDATION' : status === 404 ? 'NOT_FOUND' : `HTTP_${status}`;
      const body = e.getResponse();
      details = typeof body === 'object' ? (body as { message?: unknown }).message : undefined;
    } else {
      console.error(e);
    }
    const locale = pickLocale(req.headers['accept-language']);
    res.status(status).json({ error: { code, message: MESSAGES[code]?.[locale] ?? code, details } });
  }
}
