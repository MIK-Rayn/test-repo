-- This model calculates the Fulfillment Success Rate KPI

with order_history_data as (
    select 
        ORDER_FULFILLMENT_STATUS
    from {{ ref('order_history') }}
)

select
    count(case when ORDER_FULFILLMENT_STATUS = 'Completed' then 1 end) * 1.0 / count(*) as fulfillment_success_rate
from order_history_data
;