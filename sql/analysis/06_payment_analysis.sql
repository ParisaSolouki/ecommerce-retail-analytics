-- =========================================================
-- Q6. PAYMENT METHOD ANALYSIS
-- Business Question:
-- Which payment methods are most commonly used by customers?
--
-- Analysis Period:
-- January-August 2017 vs. January-August 2018
-- =========================================================


-- =========================================================
-- 1. Validate Paid Orders KPI
-- Purpose: Count distinct orders with payment information
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    COUNT(DISTINCT p.order_id) AS paid_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
GROUP BY
    YEAR(o.order_purchase_timestamp)
ORDER BY
    analysis_year;


-- =========================================================
-- 2. Validate Paid Orders by Payment Method
-- Purpose: Identify the most commonly used payment methods
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS paid_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    paid_orders DESC;


-- =========================================================
-- 3. Validate Total Paid Orders for Usage Rate
-- Purpose: Provide the denominator for usage-rate calculations
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    COUNT(DISTINCT p.order_id) AS total_paid_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
GROUP BY
    YEAR(o.order_purchase_timestamp)
ORDER BY
    analysis_year;


-- =========================================================
-- 4. Validate Orders by Payment Method for Usage Rate
-- Purpose: Provide the numerator for usage-rate calculations
--
-- Formula:
-- Payment Method Usage Rate =
-- Method Paid Orders / Total Paid Orders
--
-- Note:
-- Usage rates may total more than 100% because one order
-- can use more than one payment method.
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS method_paid_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    method_paid_orders DESC;


-- =========================================================
-- 5. Validate Monthly Paid Orders by Payment Method
-- Purpose: Analyze monthly payment-method trends
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    MONTH(o.order_purchase_timestamp) AS month_number,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,
    p.payment_type,
    COUNT(DISTINCT p.order_id) AS paid_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    month_number,
    p.payment_type;


-- =========================================================
-- 6. Validate Total Payment Value by Payment Method
-- Purpose: Calculate total payment value for each method
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_type,
    ROUND(SUM(p.payment_value), 2) AS total_payment_value
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    total_payment_value DESC;


-- =========================================================
-- 7. Validate Average Payment Value by Payment Method
-- Purpose: Calculate payment value per distinct paid order
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_type,
    ROUND(
        SUM(p.payment_value)
        / COUNT(DISTINCT p.order_id),
        2
    ) AS average_payment_value
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    average_payment_value DESC;


-- =========================================================
-- 8. Validate Average Installments by Payment Method
-- Purpose: Calculate average installment count for each method
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_type,
    ROUND(
        AVG(p.payment_installments),
        1
    ) AS average_installments
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type <> 'not_defined'
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_type
ORDER BY
    analysis_year,
    average_installments DESC;


-- =========================================================
-- 9. Validate Credit Card Orders by Installment Count
-- Purpose: Analyze preferred credit-card installment counts
-- =========================================================

SELECT
    YEAR(o.order_purchase_timestamp) AS analysis_year,
    p.payment_installments,
    COUNT(DISTINCT p.order_id) AS credit_card_orders
FROM payments AS p
JOIN orders AS o
    ON p.order_id = o.order_id
WHERE
    (
        (
            o.order_purchase_timestamp >= '2017-01-01'
            AND o.order_purchase_timestamp < '2017-09-01'
        )
        OR
        (
            o.order_purchase_timestamp >= '2018-01-01'
            AND o.order_purchase_timestamp < '2018-09-01'
        )
    )
    AND p.payment_type = 'credit_card'
    AND p.payment_installments > 0
GROUP BY
    YEAR(o.order_purchase_timestamp),
    p.payment_installments
ORDER BY
    analysis_year,
    p.payment_installments;