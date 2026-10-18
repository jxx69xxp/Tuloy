-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "Locale" ADD VALUE 'zh';
ALTER TYPE "Locale" ADD VALUE 'ja';
ALTER TYPE "Locale" ADD VALUE 'ko';
ALTER TYPE "Locale" ADD VALUE 'es';
ALTER TYPE "Locale" ADD VALUE 'fr';
ALTER TYPE "Locale" ADD VALUE 'de';
ALTER TYPE "Locale" ADD VALUE 'it';
ALTER TYPE "Locale" ADD VALUE 'ru';
ALTER TYPE "Locale" ADD VALUE 'ar';
ALTER TYPE "Locale" ADD VALUE 'hi';
ALTER TYPE "Locale" ADD VALUE 'id';
ALTER TYPE "Locale" ADD VALUE 'vi';
ALTER TYPE "Locale" ADD VALUE 'th';
ALTER TYPE "Locale" ADD VALUE 'ms';

