-- Refund Rate KPI Model
-- Measures the percentage of orders that include a refund.

WITH order_counts AS (
    SELECT
        COUNT(DISTINCT ID) AS total_orders
    FROM {{ ref('order_history') }}
),
refund_counts AS (
    SELECT
        COUNT(DISTINCT orders_line_item_order_id) AS total_refunds
    FROM {{ ref('orders_line_item_refund') }}
)

SELECT
    CASE
        WHEN order_counts.total_orders = 0 THEN 0
        ELSE (refund_counts.total_refunds::numeric / order_counts.total_orders) * 100
    END AS refund_rate
FROM order_counts, refund_counts;
