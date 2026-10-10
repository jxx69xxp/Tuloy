import { Type } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, IsUUID, Matches, Max, MaxLength, Min } from 'class-validator';

const DATE = /^\d{4}-\d{2}-\d{2}$/;

export class StayQueryDto {
  @Matches(DATE) checkIn: string;
  @Matches(DATE) checkOut: string;
  @Type(() => Number) @IsInt() @Min(1) @Max(20) adults: number;
  @IsOptional() @Type(() => Number) @IsInt() @Min(0) @Max(20) children?: number;
}

export class HoldDto extends StayQueryDto {
  @IsUUID() hotelId: string;
  @IsUUID() roomTypeId: string;
  @IsOptional() @IsString() @MaxLength(500) specialRequests?: string;
}

export class PayDto {
  /** DEPOSIT or FULL while on hold; ignored afterwards (pays the balance). */
  @IsIn(['DEPOSIT', 'FULL']) type: 'DEPOSIT' | 'FULL';
}

export class CancelDto {
  @IsOptional() @IsString() @MaxLength(300) reason?: string;
}

export class FeedbackDto {
  @IsUUID() reservationId: string;
  @IsInt() @Min(1) @Max(5) rating: number;
  @IsOptional() @IsString() @MaxLength(2000) comment?: string;
}
