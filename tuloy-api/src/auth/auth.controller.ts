import { Body, Controller, HttpCode, Post } from '@nestjs/common';
import { Public } from '../common/auth';
import { AuthService } from './auth.service';
import { LoginDto, OtpRequestDto, PasswordResetDto, RefreshDto, RegisterDto } from './dto';

@Public()
@Controller('auth')
export class AuthController {
  constructor(private readonly auth: AuthService) {}

  @Post('register')
  register(@Body() dto: RegisterDto) {
    return this.auth.register(dto);
  }

  @Post('login')
  @HttpCode(200)
  login(@Body() dto: LoginDto) {
    return this.auth.login(dto);
  }

  @Post('refresh')
  @HttpCode(200)
  refresh(@Body() dto: RefreshDto) {
    return this.auth.refresh(dto.refreshToken);
  }

  @Post('logout')
  @HttpCode(204)
  logout(@Body() dto: RefreshDto) {
    return this.auth.logout(dto.refreshToken);
  }

  @Post('otp/request')
  @HttpCode(204)
  otp(@Body() dto: OtpRequestDto) {
    return this.auth.requestOtp(dto.login);
  }

  @Post('password/reset')
  @HttpCode(204)
  reset(@Body() dto: PasswordResetDto) {
    return this.auth.resetPassword(dto);
  }
}
