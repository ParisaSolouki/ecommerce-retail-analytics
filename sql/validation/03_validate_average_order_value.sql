-- ============================================================
-- Average Order Value Validation
-- ============================================================

-- Purpose:
-- Validate the Power BI [Average Order Value] measure against SQL.

-- Power BI measures:
-- Paid Orders = DISTINCTCOUNT(payments[order_id])
-- Average Order Value = DIVIDE([Total Revenue], [Paid Orders])


-- Validate distinct paid orders
SELECT
    COUNT(DISTINCT order_id) AS paid_orders
FROM payments;


-- Identify orders with no payment record
SELECT
    o.order_id
FROM orders AS o
LEFT JOIN payments AS p
    ON o.order_id = p.order_id
WHERE p.order_id IS NULL;


-- Validate Average Order Value
SELECT
    ROUND(
        SUM(payment_value) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM payments;


-- Validation result:
-- Power BI Paid Orders: 99,440
-- SQL Paid Orders: 99,440
-- Orders without payment: 1
-- Power BI Average Order Value: 160.99
-- SQL Average Order Value: 160.99
-- Status: PASS