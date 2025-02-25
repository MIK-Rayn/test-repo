-- cancellation_rate.sql

with total_orders as (
    select count(*) as total
    from {{ ref('order_history') }}
),
cancelled_orders as (
    select count(*) as cancelled
    from {{ ref('order_history') }}
    where cancel_request = true
)

select
    cancelled,
    total,
    case when total = 0 then 0 else (cancelled * 100.0 / total) end as cancellation_rate
from cancelled_orders, total_orders;