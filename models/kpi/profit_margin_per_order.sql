-- profit_margin_per_order.sql

WITH order_line_item_cost AS (
    SELECT
        order_id,
        SUM(cost_value * quantity) AS total_cost,
        SUM(shipping_cost_value) AS total_shipping_cost
    FROM {{ ref('orders_line_item') }}
    GROUP BY order_id
)

SELECT
    OH.ID AS order_id,
    (
        OH.TOTAL_VALUE - COALESCE(ol.total_cost, 0) - COALESCE(ol.total_shipping_cost, 0) - OH.FEE_VALUE
    ) / OH.TOTAL_VALUE AS profit_margin_per_order
FROM {{ ref('order_history') }} OH
LEFT JOIN order_line_item_cost ol ON OH.ID = ol.order_id
WHERE OH.TOTAL_VALUE <> 0
