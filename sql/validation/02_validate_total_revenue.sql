-- ============================================================
-- Total Revenue Validation
-- ============================================================

-- Purpose:
-- Validate the Power BI [Total Revenue] measure against SQL.

-- Power BI measure:
-- Total Revenue = SUM(payments[payment_value])


-- Validate total row count in the payments table
SELECT
    COUNT(*) AS total_rows
FROM payments;


-- Check for missing payment values
SELECT
    COUNT(*) AS null_payment_values
FROM payments
WHERE payment_value IS NULL;


-- Validate Total Revenue with two-decimal precision
SELECT
    ROUND(SUM(payment_value), 2) AS total_revenue
FROM payments;


-- Validation result:
-- Power BI Total Revenue: 16,008,872.12
-- SQL Total Revenue:      16,008,872.12
-- Total rows:             103,886
-- Null payment values:    0
-- Status: PASS