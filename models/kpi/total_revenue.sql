-- total_revenue.sql

with order_history_data as (
    select
        TOTAL_VALUE
    from {{ ref('order_history') }}
)

select
    sum(TOTAL_VALUE) as total_revenue
from order_history_data
;