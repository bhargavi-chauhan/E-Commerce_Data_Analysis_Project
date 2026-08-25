USE revenue_leakage;

-- Q1: How many orders are in the dataset, and what is the total order value?
SELECT
    COUNT(*) AS total_orders,
    SUM(total_order_value) AS total_order_value
FROM orders;

-- Q2: Actual Net Revenue
SELECT
    SUM(total_order_value) AS total_order_value,
    SUM(revenue_loss_amount) AS total_revenue_loss,
    SUM(net_revenue) AS total_net_revenue
FROM orders;

-- Q5: Compare revenue metrics by leakage flag
SELECT
    revenue_leakage_flag,
    COUNT(*) AS orders,
    SUM(total_order_value) AS total_order_value,
    SUM(revenue_loss_amount) AS revenue_loss,
    SUM(net_revenue) AS net_revenue
FROM orders
GROUP BY revenue_leakage_flag
ORDER BY revenue_loss DESC;


-- Q6: Compare revenue metrics by order status
SELECT
    order_status,
    COUNT(*) AS orders,
    SUM(total_order_value) AS total_order_value,
    SUM(revenue_loss_amount) AS revenue_loss,
    SUM(net_revenue) AS net_revenue
FROM orders
GROUP BY order_status
ORDER BY revenue_loss DESC;


-- Q11 — Understand the failed-order leakage
SELECT
    is_failed_order,
    COUNT(*) AS orders,
    SUM(total_order_value) AS order_value,
    SUM(refund_amount) AS refunds,
    SUM(revenue_loss_amount) AS revenue_loss,
    SUM(net_revenue) AS net_revenue
FROM orders
GROUP BY is_failed_order;

-- Q12 — Calculate the headline leakage rate
SELECT
    SUM(revenue_loss_amount) AS total_revenue_loss,
    SUM(total_order_value) AS total_order_value,
    ROUND(
        SUM(revenue_loss_amount)
        / SUM(total_order_value) * 100,
        2
    ) AS revenue_leakage_rate
FROM orders;

-- Q13 — Leakage contribution by order status
SELECT
    order_status,
    COUNT(*) AS orders,
    SUM(revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(revenue_loss_amount)
        / SUM(SUM(revenue_loss_amount)) OVER () * 100,
        2
    ) AS leakage_contribution_pct
FROM orders
GROUP BY order_status
ORDER BY revenue_loss DESC;

-- Q14 — Failure rate
SELECT
    COUNT(*) AS total_orders,
    SUM(is_failed_order = 'Yes') AS failed_orders,
    ROUND(
        SUM(is_failed_order = 'Yes')
        / COUNT(*) * 100,
        2
    ) AS failure_rate_pct
FROM orders;

-- Q15 — Revenue loss per failed order
SELECT
    COUNT(*) AS failed_orders,
    SUM(revenue_loss_amount) AS total_revenue_loss,
    ROUND(
        SUM(revenue_loss_amount)
        / COUNT(*),
        2
    ) AS avg_loss_per_failed_order
FROM orders
WHERE is_failed_order = 'Yes';

-- Q16 — Failure by payment method
SELECT
    payment_method,
    COUNT(*) AS total_orders,
    SUM(is_failed_order = 'Yes') AS failed_orders,
    ROUND(
        SUM(is_failed_order = 'Yes')
        / COUNT(*) * 100,
        2
    ) AS failure_rate_pct,
    SUM(revenue_loss_amount) AS revenue_loss
FROM orders
GROUP BY payment_method
ORDER BY failure_rate_pct DESC;

-- Q17 — Failure by delivery state
SELECT
    delivery_state,
    COUNT(*) AS total_orders,
    SUM(is_failed_order = 'Yes') AS failed_orders,
    ROUND(
        SUM(is_failed_order = 'Yes')
        / COUNT(*) * 100,
        2
    ) AS failure_rate_pct,
    SUM(revenue_loss_amount) AS revenue_loss
FROM orders
GROUP BY delivery_state
ORDER BY revenue_loss DESC;

-- Q18 — Overall shipment status
SELECT
    delivery_status,
    COUNT(*) AS shipments,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM shipments) * 100,
        2
    ) AS percentage
FROM shipments
GROUP BY delivery_status
ORDER BY shipments DESC;

-- Q19 — Failure reasons
SELECT
    failure_reason,
    COUNT(*) AS shipments
FROM shipments
WHERE failure_reason <> 'No Failure'
GROUP BY failure_reason
ORDER BY shipments DESC;

-- Q20 — Failure reason + order financial impact
SELECT
    s.failure_reason,
    COUNT(*) AS failed_shipments,
    SUM(o.total_order_value) AS order_value,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(o.revenue_loss_amount) / COUNT(*),
        2
    ) AS avg_loss_per_failure
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
WHERE s.failure_reason <> 'No Failure'
GROUP BY s.failure_reason
ORDER BY revenue_loss DESC;

-- Q21 — Delivery status vs revenue leakage
SELECT
    s.delivery_status,
    COUNT(*) AS shipments,
    SUM(o.revenue_loss_amount) AS revenue_loss
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
GROUP BY s.delivery_status
ORDER BY revenue_loss DESC;

-- Q22 — Courier performance
SELECT
    courier_partner,
    COUNT(*) AS shipments,
    SUM(delivery_status = 'Failed') AS failed_shipments,
    ROUND(
        SUM(delivery_status = 'Failed')
        / COUNT(*) * 100,
        2
    ) AS failure_rate_pct,
    SUM(o.revenue_loss_amount) AS revenue_loss
FROM shipments s
JOIN orders o
    ON s.order_id = o.order_id
GROUP BY courier_partner
ORDER BY failure_rate_pct DESC;


-- Q29 — Refund performance
SELECT
    refund_status,
    COUNT(*) AS refund_cases,
    SUM(refund_amount) AS total_refund_amount,
    ROUND(
        SUM(refund_amount) / COUNT(*),
        2
    ) AS avg_refund_amount
FROM returns_refunds
GROUP BY refund_status
ORDER BY total_refund_amount DESC;

-- Q30 — Return reasons
SELECT
    return_reason,
    COUNT(*) AS return_cases,
    SUM(refund_amount) AS refund_amount,
    ROUND(
        SUM(refund_amount) / COUNT(*),
        2
    ) AS avg_refund
FROM returns_refunds
GROUP BY return_reason
ORDER BY return_cases DESC;

-- Q31 — Total return/refund cost
SELECT
    COUNT(*) AS total_return_cases,
    SUM(refund_amount) AS total_refund_amount,
    SUM(reverse_logistics_cost) AS reverse_logistics_cost,
    SUM(restocking_cost) AS restocking_cost,
    SUM(
        refund_amount
        + reverse_logistics_cost
        + restocking_cost
    ) AS total_return_cost
FROM returns_refunds;

-- Q32 — Average delay by courier
SELECT
    courier_partner,
    COUNT(*) AS shipments,
    ROUND(AVG(delay_days_clean), 2) AS avg_delay_days,
    SUM(is_late_delivery = 'Yes') AS late_shipments,
    ROUND(
        SUM(is_late_delivery = 'Yes') / COUNT(*) * 100,
        2
    ) AS late_rate_pct
FROM shipments
GROUP BY courier_partner
ORDER BY late_rate_pct DESC;

-- Q33 — Delivery performance by courier
SELECT
    courier_partner,
    COUNT(*) AS shipments,
    SUM(delivery_status = 'Delivered') AS delivered,
    SUM(delivery_status = 'RTO') AS rto,
    SUM(delivery_status = 'Failed') AS failed,
    ROUND(
        SUM(delivery_status = 'Delivered') / COUNT(*) * 100,
        2
    ) AS delivery_success_rate
FROM shipments
GROUP BY courier_partner
ORDER BY delivery_success_rate DESC;



-- Q35 — Leakage by product category
SELECT
    p.category,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(oi.item_revenue) AS item_revenue,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(o.revenue_loss_amount) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS avg_loss_per_order
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.revenue_leakage_flag = 'Yes'
GROUP BY p.category
ORDER BY revenue_loss DESC;

-- Q36 — Leakage by product subcategory
SELECT
    p.subcategory,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(o.revenue_loss_amount) /
        NULLIF(COUNT(DISTINCT o.order_id), 0),
        2
    ) AS avg_loss_per_order
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.revenue_leakage_flag = 'Yes'
GROUP BY p.subcategory
ORDER BY revenue_loss DESC
LIMIT 10;

-- Q37 — Product-level leakage
SELECT
    p.product_id,
    p.product_name,
    p.category,
    COUNT(DISTINCT o.order_id) AS orders,
    SUM(o.revenue_loss_amount) AS revenue_loss
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
WHERE o.revenue_leakage_flag = 'Yes'
GROUP BY
    p.product_id,
    p.product_name,
    p.category
ORDER BY revenue_loss DESC
LIMIT 10;

-- Q38 — Leakage by customer segment
SELECT
    c.customer_segment,
    COUNT(DISTINCT o.customer_id) AS customers,
    COUNT(o.order_id) AS orders,
    SUM(o.revenue_loss_amount) AS revenue_loss,
    ROUND(
        SUM(o.revenue_loss_amount) /
        NULLIF(COUNT(o.order_id), 0),
        2
    ) AS avg_loss_per_order
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_segment
ORDER BY revenue_loss DESC;


