-- This model calculates the Refund Rate KPI
with refund_orders as (
    select
        count(distinct orders_line_item_order_id) as refund_count
    from {{ ref('orders_line_item_refund') }}
),

total_orders as (
    select
        count(distinct id) as total_orders
    from {{ ref('order_history') }}
)

select
    (refund_count / nullif(total_orders, 0)) * 100 as refund_rate
from refund_orders, total_orders
;