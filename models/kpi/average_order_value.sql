-- This model calculates the Average Order Value (AOV)
-- AOV = SUM(ORDER_HISTORY.TOTAL_VALUE) / COUNT(ORDER_HISTORY.ID)

WITH order_metrics AS (
    SELECT
        SUM(TOTAL_VALUE) AS total_revenue,
        COUNT(ID) AS total_orders
    FROM {{ ref('order_history') }}
)

SELECT
    total_revenue,
    total_orders,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_revenue / total_orders
    END AS average_order_value
FROM order_metrics;