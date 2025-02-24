-- This model calculates the Cancellation Rate KPI
WITH order_stats AS (
    SELECT
        SUM(CASE WHEN CANCEL_REQUEST = true THEN 1 ELSE 0 END) AS cancelled_orders,
        COUNT(*) AS total_orders
    FROM {{ ref('order_history') }}
)

SELECT
    100.0 * cancelled_orders / total_orders AS cancellation_rate
FROM order_stats;
