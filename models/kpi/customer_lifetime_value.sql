-- This model calculates the Customer Lifetime Value (CLV) based on the Order History
-- by subtracting the associated costs and refunds from the total order value.

with order_calculations as (
    select
        o.ID as order_id,
        o.TOTAL_VALUE as total_order_value,
        (
            select coalesce(sum(li.cost_value * li.quantity), 0)
            from {{ ref('orders_line_item') }} li
            where li.order_id = o.ID
        ) as total_cost,
        (
            select coalesce(sum(lir.amount_value), 0)
            from {{ ref('orders_line_item_refund') }} lir
            where lir.orders_line_item_order_id = o.ID
        ) as total_line_item_refund,
        (
            select coalesce(sum(pr.amount_value), 0)
            from {{ ref('orders_payment_refund') }} pr
            where pr.orders_payment_order_id = o.ID
        ) as total_payment_refund
    from {{ ref('order_history') }} o
)

select
    sum(total_order_value - total_cost - total_line_item_refund - total_payment_refund) as customer_lifetime_value
from order_calculations
;