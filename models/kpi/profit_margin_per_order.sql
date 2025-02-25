-- Profit Margin per Order KPI Model
-- This model calculates the profit margin for each order by subtracting the fees and costs (cost of goods sold + shipping cost) from the total order value.

with order_profit as (
    select
        oh.ID as order_id,
        oh.TOTAL_VALUE as total_value,
        oh.FEE_VALUE as fee_value,
        oh.TOTAL_VALUE - oh.FEE_VALUE - COALESCE((
            select sum(li.cost_value + li.shipping_cost_value)
            from {{ ref('ORDERS_LINE_ITEM') }} li
            where li.order_id = oh.ID
        ), 0) as profit_margin
    from {{ ref('ORDER_HISTORY') }} oh
)

select
    order_id,
    total_value,
    fee_value,
    profit_margin
from order_profit
;