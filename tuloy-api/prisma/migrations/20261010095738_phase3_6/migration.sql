-- AlterTable
ALTER TABLE "Conversation" ADD COLUMN     "lastMessageAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "LoyaltyAccount" ADD COLUMN     "lifetime" INTEGER NOT NULL DEFAULT 0;

-- AlterTable
ALTER TABLE "ServiceRequest" ADD COLUMN     "paidAt" TIMESTAMP(3);

-- CreateIndex
CREATE INDEX "WifiCredential_reservationId_idx" ON "WifiCredential"("reservationId");
