-- ============================================================
-- Total Orders Validation
-- ============================================================

-- Purpose:
-- Validate the Power BI [Total Orders] measure against SQL.

-- Power BI measure:
-- Total Orders = DISTINCTCOUNT(orders[order_id])

-- Validate total row count in the orders table
SELECT
    COUNT(*) AS total_rows
FROM orders;

-- Validate distinct order count used in Power BI
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM orders;

-- Check for missing order IDs
SELECT
    COUNT(*) AS null_order_ids
FROM orders
WHERE order_id IS NULL;

-- Validation result:
-- Power BI Total Orders: 99,441
-- SQL Total Orders: 99,441
-- Total rows: 99,441
-- Null order IDs: 0
-- Status: PASS