-- Refund Rate KPI Model
-- This model calculates the percentage of orders that include a refund.

with orders as (
    select
        count(distinct ID) as total_orders
    from {{ ref('order_history') }}
),
refunds as (
    select
        count(distinct orders_line_item_order_id) as total_refund_orders
    from {{ ref('orders_line_item_refund') }}
)

select
    r.total_refund_orders,
    o.total_orders,
    case
        when o.total_orders = 0 then 0
        else (r.total_refund_orders * 100.0 / o.total_orders)
    end as refund_rate
from orders o
cross join refunds r
;