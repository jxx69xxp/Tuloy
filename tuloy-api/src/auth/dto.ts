import { IsIn, IsObject, IsOptional, IsString, IsUUID, Length, MaxLength, MinLength } from 'class-validator';
import { LOCALES, Locale } from '../common/i18n';

/** `login` is an email (contains @) or a phone number. */
export class RegisterDto {
  @IsString() @Length(1, 120) fullName: string;
  @IsString() @Length(3, 254) login: string;
  @IsString() @MinLength(8) @MaxLength(200) password: string;
  @IsOptional() @IsIn(LOCALES) locale?: Locale;
  @IsUUID() hotelId: string;
}

export class LoginDto {
  @IsString() @Length(3, 254) login: string;
  @IsString() @MaxLength(200) password: string;
}

export class RefreshDto {
  @IsString() @Length(10, 200) refreshToken: string;
}

export class OtpRequestDto {
  @IsString() @Length(3, 254) login: string;
}

export class PasswordResetDto {
  @IsString() @Length(3, 254) login: string;
  @IsString() @Length(6, 6) code: string;
  @IsString() @MinLength(8) @MaxLength(200) newPassword: string;
}

export class UpdateMeDto {
  @IsOptional() @IsString() @Length(1, 120) fullName?: string;
  @IsOptional() @IsIn(LOCALES) locale?: Locale;
  @IsOptional() @IsObject() notifyPrefs?: Record<string, boolean>;
}

export class PushTokenDto {
  @IsString() @Length(10, 4096) token: string;
  @IsIn(['ios', 'android']) platform: 'ios' | 'android';
}
