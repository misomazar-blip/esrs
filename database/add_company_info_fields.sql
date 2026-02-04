-- =====================================================
-- Add company info fields
-- =====================================================

ALTER TABLE company
ADD COLUMN IF NOT EXISTS address TEXT,
ADD COLUMN IF NOT EXISTS city TEXT,
ADD COLUMN IF NOT EXISTS postal_code TEXT,
ADD COLUMN IF NOT EXISTS identification_number TEXT,
ADD COLUMN IF NOT EXISTS vat_number TEXT,
ADD COLUMN IF NOT EXISTS phone TEXT,
ADD COLUMN IF NOT EXISTS email TEXT,
ADD COLUMN IF NOT EXISTS website TEXT;

-- Add comment for documentation
COMMENT ON COLUMN company.address IS 'Street address';
COMMENT ON COLUMN company.city IS 'City';
COMMENT ON COLUMN company.postal_code IS 'Postal/ZIP code';
COMMENT ON COLUMN company.identification_number IS 'Company registration number (IČO)';
COMMENT ON COLUMN company.vat_number IS 'VAT number (DIČ)';
COMMENT ON COLUMN company.phone IS 'Company phone number';
COMMENT ON COLUMN company.email IS 'Company email address';
COMMENT ON COLUMN company.website IS 'Company website URL';
