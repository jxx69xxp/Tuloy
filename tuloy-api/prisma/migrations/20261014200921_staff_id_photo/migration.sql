-- AlterTable
ALTER TABLE "Membership" ADD COLUMN     "employeeNo" TEXT,
ADD COLUMN     "photoKey" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "Membership_hotelId_employeeNo_key" ON "Membership"("hotelId", "employeeNo");

