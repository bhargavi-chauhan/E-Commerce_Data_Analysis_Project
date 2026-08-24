USE revenue_leakage;

-- 1. Revenue Leakage Summary
CREATE OR REPLACE VIEW vw_revenue_leakage_summary AS
SELECT
    order_status,
    COUNT(*) AS orders,
    SUM(total_order_value) AS total_order_value,
    SUM(revenue_loss_amount) AS revenue_loss,
    SUM(net_revenue) AS net_revenue,
    ROUND(
        SUM(revenue_loss_amount) /
        SUM(total_order_value) * 100,
        2
    ) AS leakage_rate_pct
FROM orders
GROUP BY order_status;

-- 2. Failure & Logistics Analysis
CREATE OR REPLACE VIEW vw_failure_logistics AS
SELECT
    s.delivery_status,
    s.failure_reason,
    s.courier_partner,
    COUNT(*) AS shipments,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        AVG(s.delay_days_clean),
        2
    ) AS avg_delay_days
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
GROUP BY
    s.delivery_status,
    s.failure_reason,
    s.courier_partner;
    
-- 3. Returns & Refunds Analysis
CREATE OR REPLACE VIEW vw_returns_refunds AS

SELECT
    return_reason,
    refund_status,

    COUNT(*) AS return_cases,

    SUM(refund_amount) AS refund_amount,

    SUM(reverse_logistics_cost) AS reverse_logistics_cost,

    SUM(restocking_cost) AS restocking_cost,

    SUM(
        reverse_logistics_cost
        + restocking_cost
    ) AS total_operational_cost

FROM returns_refunds

GROUP BY
    return_reason,
    refund_status;
    
-- 4. Product Leakage Analysis
USE revenue_leakage;

CREATE OR REPLACE VIEW vw_product_leakage AS

WITH item_counts AS (
    SELECT
        order_id,
        COUNT(*) AS n_items
    FROM order_items
    GROUP BY order_id
)

SELECT
    p.category,
    p.subcategory,
    p.product_id,
    p.product_name,

    COUNT(DISTINCT o.order_id) AS orders,

    SUM(oi.item_revenue) AS item_revenue,

    SUM(
        CASE
            WHEN o.revenue_leakage_flag = 'Yes'
            THEN o.revenue_loss_amount / ic.n_items
            ELSE 0
        END
    ) AS associated_revenue_loss

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

JOIN orders o
    ON oi.order_id = o.order_id

JOIN item_counts ic
    ON o.order_id = ic.order_id

GROUP BY
    p.category,
    p.subcategory,
    p.product_id,
    p.product_name;
    
-- 5. Customer Risk Analysis
CREATE OR REPLACE VIEW vw_customer_risk AS
SELECT
    c.customer_segment,
    c.churn_risk,
    c.is_repeat_customer,
    COUNT(DISTINCT c.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    SUM(o.total_order_value) AS order_value,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(o.revenue_loss_amount) /
        NULLIF(COUNT(o.order_id), 0),
        2
    ) AS avg_loss_per_order
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_segment,
    c.churn_risk,
    c.is_repeat_customer;
    
SHOW FULL TABLES
WHERE TABLE_TYPE = 'VIEW';

SELECT * FROM vw_revenue_leakage_summary;
SELECT * FROM vw_failure_logistics LIMIT 10;


