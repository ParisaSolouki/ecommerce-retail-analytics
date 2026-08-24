-- ============================================================
-- Q3. Seller Performance - SQL Validation
-- ============================================================

-- The main seller performance analysis was developed in Power BI.
-- These SQL queries are used only to validate key dashboard metrics
-- for the same analysis period: Jan-Aug 2017 and Jan-Aug 2018.
-- ============================================================


-- ------------------------------------------------------------
-- 1. Validate Seller Revenue by Year
-- ------------------------------------------------------------

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    ROUND(SUM(oi.price), 2) AS seller_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    YEAR(o.order_purchase_timestamp)
ORDER BY
    analysis_year;


-- ------------------------------------------------------------
-- 2. Validate Seller Orders by Year
-- ------------------------------------------------------------

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    COUNT(DISTINCT o.order_id) AS seller_orders
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    YEAR(o.order_purchase_timestamp)
ORDER BY
    analysis_year;


-- ------------------------------------------------------------
-- 3. Validate Active Sellers by Year
-- ------------------------------------------------------------

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    COUNT(DISTINCT oi.seller_id) AS active_sellers
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    YEAR(o.order_purchase_timestamp)
ORDER BY
    analysis_year;


-- ------------------------------------------------------------
-- 4. Validate Top 10 Sellers by Revenue - 2017
-- ------------------------------------------------------------

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS seller_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) = 2017
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    oi.seller_id
ORDER BY
    seller_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 5. Validate Top 10 Sellers by Revenue - 2018
-- ------------------------------------------------------------

SELECT
    oi.seller_id,
    ROUND(SUM(oi.price), 2) AS seller_revenue
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) = 2018
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    oi.seller_id
ORDER BY
    seller_revenue DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 6. Validate Top 10 Sellers by Order Volume - 2017
-- ------------------------------------------------------------

SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS seller_orders
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) = 2017
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    oi.seller_id
ORDER BY
    seller_orders DESC
LIMIT 10;


-- ------------------------------------------------------------
-- 7. Validate Top 10 Sellers by Order Volume - 2018
-- ------------------------------------------------------------

SELECT
    oi.seller_id,
    COUNT(DISTINCT o.order_id) AS seller_orders
FROM orders AS o
JOIN order_items AS oi
    ON o.order_id = oi.order_id
WHERE
    YEAR(o.order_purchase_timestamp) = 2018
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
GROUP BY
    oi.seller_id
ORDER BY
    seller_orders DESC
LIMIT 10;