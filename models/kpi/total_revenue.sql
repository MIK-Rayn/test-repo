-- total_revenue.sql

with order_data as (
    select
        total_value
    from {{ ref('order_history') }}
)

select
    sum(total_value) as total_revenue
from order_data;
