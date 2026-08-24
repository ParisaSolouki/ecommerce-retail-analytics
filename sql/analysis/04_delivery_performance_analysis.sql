-- ============================================================
-- Q4. Delivery Performance Analysis
-- ============================================================

-- Business Question:
-- How efficient is the order fulfillment and delivery process?

-- The Power BI dashboard was used for the main analysis.
-- The following SQL queries were used to validate the main
-- delivery KPIs shown in the dashboard for Jan-Aug 2017
-- and Jan-Aug 2018.


-- ============================================================
-- 1. Average Delivery Time
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS analysis_year,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_purchase_timestamp,
                order_delivered_customer_date
            ) / 86400.0
        ),
        1
    ) AS avg_delivery_days
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
  AND MONTH(order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY analysis_year;


-- ============================================================
-- 2. Average Fulfillment Time
-- Purchase -> Carrier
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS analysis_year,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_purchase_timestamp,
                order_delivered_carrier_date
            ) / 86400.0
        ),
        1
    ) AS avg_fulfillment_days
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date <> ''
  AND MONTH(order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY analysis_year;


-- ============================================================
-- 3. Average Shipping Time
-- Carrier -> Customer
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS analysis_year,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_delivered_carrier_date,
                order_delivered_customer_date
            ) / 86400.0
        ),
        1
    ) AS avg_shipping_days
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_carrier_date <> ''
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
  AND MONTH(order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY analysis_year;


-- ============================================================
-- 4. On-Time Delivery Rate
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS analysis_year,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN order_delivered_customer_date <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        1
    ) AS on_time_delivery_rate
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
  AND order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date <> ''
  AND MONTH(order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY analysis_year;


-- ============================================================
-- 5. Average Delay Days for Late Orders
-- ============================================================

SELECT
    YEAR(order_purchase_timestamp) AS analysis_year,
    ROUND(
        AVG(
            TIMESTAMPDIFF(
                SECOND,
                order_estimated_delivery_date,
                order_delivered_customer_date
            ) / 86400.0
        ),
        1
    ) AS avg_delay_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_delivered_customer_date <> ''
  AND order_estimated_delivery_date IS NOT NULL
  AND order_estimated_delivery_date <> ''
  AND order_delivered_customer_date > order_estimated_delivery_date
  AND MONTH(order_purchase_timestamp) BETWEEN 1 AND 8
  AND YEAR(order_purchase_timestamp) IN (2017, 2018)
GROUP BY YEAR(order_purchase_timestamp)
ORDER BY analysis_year;