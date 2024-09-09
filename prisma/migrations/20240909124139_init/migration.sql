-- CreateEnum
CREATE TYPE "CatalystType" AS ENUM ('EARNINGS', 'DIVIDEND', 'PRODUCT', 'MERGER');

-- CreateEnum
CREATE TYPE "Impact" AS ENUM ('STRONG_POSITIVE', 'POSITIVE', 'NEGATIVE', 'STRONG_NEGATIVE', 'NEUTRAL');

-- CreateEnum
CREATE TYPE "Industry" AS ENUM ('ENTERTAINMENT');

-- CreateTable
CREATE TABLE "User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Company" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "isin" TEXT NOT NULL,
    "industry" "Industry" NOT NULL,
    "parentId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Company_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Brand" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Brand_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CompanyBrand" (
    "companyId" INTEGER NOT NULL,
    "brandId" INTEGER NOT NULL,

    CONSTRAINT "CompanyBrand_pkey" PRIMARY KEY ("companyId","brandId")
);

-- CreateTable
CREATE TABLE "Catalyst" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "companyId" INTEGER NOT NULL,
    "anticipatedAt" TIMESTAMP(3) NOT NULL,
    "type" "CatalystType" NOT NULL DEFAULT 'PRODUCT',
    "actualImpact" "Impact",
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "brandId" INTEGER,

    CONSTRAINT "Catalyst_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Forecast" (
    "id" SERIAL NOT NULL,
    "catalystId" INTEGER NOT NULL,
    "impact" "Impact" NOT NULL DEFAULT 'NEUTRAL',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Forecast_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Company_parentId_key" ON "Company"("parentId");

-- AddForeignKey
ALTER TABLE "Company" ADD CONSTRAINT "Company_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Company"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyBrand" ADD CONSTRAINT "CompanyBrand_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CompanyBrand" ADD CONSTRAINT "CompanyBrand_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "Brand"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Catalyst" ADD CONSTRAINT "Catalyst_companyId_fkey" FOREIGN KEY ("companyId") REFERENCES "Company"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Catalyst" ADD CONSTRAINT "Catalyst_brandId_fkey" FOREIGN KEY ("brandId") REFERENCES "Brand"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Forecast" ADD CONSTRAINT "Forecast_catalystId_fkey" FOREIGN KEY ("catalystId") REFERENCES "Catalyst"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
