-- models/kpi/aov.sql

with order_data as (
    select
        id,
        total_value
    from {{ ref('order_history') }}
)

select
    sum(total_value) as total_revenue,
    count(id) as total_orders,
    case
        when count(id) = 0 then 0
        else sum(total_value) / count(id)
    end as average_order_value
from order_data
;