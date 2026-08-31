-- =========================================================
-- Q5: CUSTOMER SATISFACTION ANALYSIS
-- Analysis period: January to August 2018
-- =========================================================


-- ---------------------------------------------------------
-- 1. Overall customer satisfaction KPIs
-- ---------------------------------------------------------

SELECT
    ROUND(AVG(r.review_score), 2) AS average_review_score,
    COUNT(DISTINCT r.order_id) AS reviewed_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score >= 4 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS positive_review_rate,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score <= 2 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS negative_review_rate

FROM reviews AS r
JOIN orders AS o
    ON r.order_id = o.order_id

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01';


-- ---------------------------------------------------------
-- 2. Review score distribution
-- ---------------------------------------------------------

SELECT
    r.review_score,
    COUNT(*) AS review_count

FROM reviews AS r
JOIN orders AS o
    ON r.order_id = o.order_id

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'

GROUP BY r.review_score
ORDER BY r.review_score;


-- ---------------------------------------------------------
-- 3. Average review score by delivery status
-- ---------------------------------------------------------

SELECT
    CASE
        WHEN o.order_delivered_customer_date
             <= o.order_estimated_delivery_date
        THEN 'On-Time'
        ELSE 'Late'
    END AS delivery_status,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score

FROM orders AS o
JOIN reviews AS r
    ON o.order_id = r.order_id

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'
  AND o.order_delivered_customer_date IS NOT NULL
  AND o.order_estimated_delivery_date IS NOT NULL

GROUP BY delivery_status;


-- ---------------------------------------------------------
-- 4. Monthly average review score
-- ---------------------------------------------------------

SELECT
    MONTH(o.order_purchase_timestamp) AS month_number,
    MONTHNAME(o.order_purchase_timestamp) AS month_name,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score

FROM orders AS o
JOIN reviews AS r
    ON o.order_id = r.order_id

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'

GROUP BY
    MONTH(o.order_purchase_timestamp),
    MONTHNAME(o.order_purchase_timestamp)

ORDER BY month_number;


-- ---------------------------------------------------------
-- 5. Customer satisfaction by product category
-- ---------------------------------------------------------

SELECT
    oc.product_category,

    ROUND(
        AVG(r.review_score),
        2
    ) AS average_review_score,

    COUNT(DISTINCT r.order_id) AS reviewed_orders,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score >= 4 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS positive_review_rate,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN r.review_score <= 2 THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS negative_review_rate

FROM (
    SELECT DISTINCT
        oi.order_id,
        ct.product_category_name_english AS product_category

    FROM order_items AS oi
    JOIN products AS p
        ON oi.product_id = p.product_id
    JOIN category_translation AS ct
        ON p.product_category_name = ct.product_category_name
) AS oc

JOIN reviews AS r
    ON oc.order_id = r.order_id
JOIN orders AS o
    ON oc.order_id = o.order_id

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'

GROUP BY oc.product_category

HAVING COUNT(DISTINCT r.order_id) >= 30

ORDER BY average_review_score;


-- ---------------------------------------------------------
-- 6. Top 10 product categories by revenue
-- ---------------------------------------------------------

SELECT
    ct.product_category_name_english AS product_category,

    ROUND(
        SUM(oi.price),
        2
    ) AS product_revenue

FROM order_items AS oi
JOIN orders AS o
    ON oi.order_id = o.order_id
JOIN products AS p
    ON oi.product_id = p.product_id
JOIN category_translation AS ct
    ON p.product_category_name = ct.product_category_name

WHERE o.order_purchase_timestamp >= '2018-01-01'
  AND o.order_purchase_timestamp <  '2018-09-01'

GROUP BY ct.product_category_name_english

ORDER BY product_revenue DESC

LIMIT 10;
