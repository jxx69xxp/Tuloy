import { INestApplication, Module, ValidationPipe } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { JwtModule } from '@nestjs/jwt';
import { AdminController } from './admin/admin.controller';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { BookingController } from './booking/booking.controller';
import { BookingService } from './booking/booking.service';
import { ChatController } from './chat/chat.controller';
import { AuthGuard } from './common/auth';
import { AppExceptionFilter } from './common/errors';
import { PrismaService } from './common/prisma.service';
import { FrontDeskController } from './frontdesk/frontdesk.controller';
import { FrontDeskService } from './frontdesk/frontdesk.service';
import { HotelsController } from './hotels/hotels.controller';
import { GuestExtrasController } from './loyalty/guest-extras.controller';
import { LoyaltyService } from './loyalty/loyalty.service';
import { MeController } from './me/me.controller';
import { NotificationsService } from './notifications/notifications.service';
import { PAYMENT_GATEWAY, gatewayFromEnv } from './payments/gateway';
import { PaymentsController } from './payments/payments.controller';
import { RestaurantController, RestaurantService } from './restaurant/restaurant.controller';
import { RoomsController } from './rooms/rooms.controller';
import { ServicesController } from './services/services.controller';
import { ServicesService } from './services/services.service';
import { TeamController } from './team/team.controller';
import { WifiService } from './wifi/wifi.service';

// ponytail: one module; split into feature modules when one needs its own imports/config.
@Module({
  imports: [
    JwtModule.registerAsync({
      useFactory: () => {
        const secret = process.env.JWT_SECRET;
        if (!secret || secret === 'change-me') throw new Error('Set JWT_SECRET (see .env.example)');
        return { secret, signOptions: { expiresIn: '15m' } };
      },
    }),
  ],
  controllers: [
    AuthController,
    MeController,
    HotelsController,
    BookingController,
    PaymentsController,
    FrontDeskController,
    ChatController,
    TeamController,
    RoomsController,
    AdminController,
    ServicesController,
    RestaurantController,
    GuestExtrasController,
  ],
  providers: [
    PrismaService,
    AuthService,
    BookingService,
    NotificationsService,
    FrontDeskService,
    LoyaltyService,
    WifiService,
    ServicesService,
    RestaurantService,
    { provide: PAYMENT_GATEWAY, useFactory: gatewayFromEnv },
    { provide: APP_GUARD, useClass: AuthGuard },
  ],
})
export class AppModule {}

/** Shared by main.ts and tests so both run the same pipeline. */
export function setupApp(app: INestApplication) {
  app.setGlobalPrefix('v1');
  app.useGlobalPipes(new ValidationPipe({ whitelist: true, forbidNonWhitelisted: true, transform: true }));
  app.useGlobalFilters(new AppExceptionFilter());
  app.enableShutdownHooks();
  return app;
}
