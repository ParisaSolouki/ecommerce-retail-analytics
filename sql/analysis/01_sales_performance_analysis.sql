-- ============================================================
-- Q1. Sales Performance Analysis
-- Business Question:
-- How has sales performance changed over time?
--
-- This analysis evaluates:
-- 1. Dataset date coverage
-- 2. Completeness of the final months
-- 3. Monthly revenue and order trends
-- 4. Average order value over time
-- 5. Comparable Jan-Aug performance for 2017 vs 2018
-- ============================================================


-- ============================================================
-- Data Completeness Checks
-- ============================================================


-- ------------------------------------------------------------
-- 1. Check the available order date range
-- ------------------------------------------------------------

SELECT
    MIN(order_purchase_timestamp) AS first_order_date,
    MAX(order_purchase_timestamp) AS last_order_date
FROM orders;


-- ------------------------------------------------------------
-- 2. Inspect order volume in the final months of the dataset
-- ------------------------------------------------------------

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS purchase_year_month,
    COUNT(*) AS total_orders
FROM orders
WHERE order_purchase_timestamp >= '2018-07-01'
GROUP BY DATE_FORMAT(order_purchase_timestamp, '%Y-%m')
ORDER BY purchase_year_month;


-- ------------------------------------------------------------
-- 3. Inspect daily order activity after September 2018
-- ------------------------------------------------------------

SELECT
    DATE(order_purchase_timestamp) AS purchase_date,
    COUNT(*) AS total_orders
FROM orders
WHERE order_purchase_timestamp >= '2018-09-01'
GROUP BY DATE(order_purchase_timestamp)
ORDER BY purchase_date;


-- ------------------------------------------------------------
-- 4. Check order status in the final months
-- ------------------------------------------------------------

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_purchase_timestamp >= '2018-09-01'
GROUP BY order_status
ORDER BY total_orders DESC;


-- ------------------------------------------------------------
-- 5. Compare monthly order-status distribution
-- ------------------------------------------------------------

SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS purchase_year_month,
    order_status,
    COUNT(*) AS total_orders
FROM orders
WHERE order_purchase_timestamp >= '2018-07-01'
GROUP BY
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m'),
    order_status
ORDER BY
    purchase_year_month,
    total_orders DESC;


-- ============================================================
-- Sales Performance Analysis
-- ============================================================


-- ------------------------------------------------------------
-- 6. Monthly sales performance
-- Exclude Sep-Oct 2018 because the dataset is incomplete
-- during the final months.
-- ------------------------------------------------------------

SELECT
    DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m') AS purchase_year_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(
        SUM(p.payment_value) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id
WHERE o.order_purchase_timestamp < '2018-09-01'
GROUP BY DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m')
ORDER BY purchase_year_month;


-- ------------------------------------------------------------
-- 7. Compare equivalent Jan-Aug periods in 2017 and 2018
-- This avoids comparing a complete year with an incomplete one.
-- ------------------------------------------------------------

SELECT
    YEAR(o.order_purchase_timestamp) AS purchase_year,
    COUNT(DISTINCT o.order_id) AS total_orders,
    ROUND(SUM(p.payment_value), 2) AS total_revenue,
    ROUND(
        SUM(p.payment_value) / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders AS o
JOIN payments AS p
    ON o.order_id = p.order_id
WHERE MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(o.order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(o.order_purchase_timestamp)
ORDER BY purchase_year;


-- ============================================================
-- Key Findings
-- ============================================================

-- Comparable period: Jan-Aug 2017 vs Jan-Aug 2018
--
-- 2017:
-- Total Orders: 22,968
-- Total Revenue: 3,669,022.12
-- Average Order Value: 159.74
--
-- 2018:
-- Total Orders: 53,991
-- Total Revenue: 8,694,733.84
-- Average Order Value: 161.04
--
-- YoY change:
-- Revenue: +137%
-- Orders: +135%
-- Average Order Value: +1%
--
-- Revenue growth was primarily driven by a substantial increase
-- in order volume, while average order value remained relatively
-- stable.
--
-- September and October 2018 were excluded from the main trend
-- analysis because the dataset contains incomplete activity
-- during the final period.