-- ============================================================
-- Q2. PRODUCT PERFORMANCE ANALYSIS
-- ============================================================
--
-- Business Question:
-- Which product categories generate the highest sales volume
-- and revenue?
--
-- Analysis Period:
-- January-August 2017 and January-August 2018
--
-- Metrics:
-- - Product Orders
-- - Items Sold
-- - Product Revenue
-- - Average Item Price
--
-- ============================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    ct.product_category_name_english AS product_category,
    COUNT(DISTINCT o.order_id) AS product_orders,
    COUNT(oi.order_item_id) AS items_sold,
    ROUND(SUM(oi.price), 2) AS product_revenue,
    ROUND(AVG(oi.price), 2) AS average_item_price
FROM orders AS o
INNER JOIN order_items AS oi
    ON o.order_id = oi.order_id
INNER JOIN products AS p
    ON oi.product_id = p.product_id
INNER JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name
WHERE
    YEAR(o.order_purchase_timestamp) IN (2017, 2018)
    AND MONTH(o.order_purchase_timestamp) BETWEEN 1 AND 8
    AND ct.product_category_name_english IS NOT NULL
GROUP BY
    YEAR(o.order_purchase_timestamp),
    ct.product_category_name_english
ORDER BY
    analysis_year,
    product_revenue DESC;
    