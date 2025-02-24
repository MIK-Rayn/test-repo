-- This dbt model calculates the Fulfillment Success Rate KPI
-- The KPI is defined as:
-- COUNT(DISTINCT CASE WHEN order_history.order_fulfillment_status = 'Completed' THEN order_history.id END) /
-- COUNT(DISTINCT orders_fulfillment_start_instruction.order_id)

with completed_orders as (
    select
        count(distinct case when oh.order_fulfillment_status = 'Completed' then oh.id end) as completed_count
    from {{ ref('order_history') }} oh
),

total_orders as (
    select
        count(distinct ofsi.order_id) as total_count
    from {{ ref('orders_fulfillment_start_instruction') }} ofsi
)

select
    case 
        when t.total_count = 0 then 0
        else 1.0 * c.completed_count / t.total_count
    end as fulfillment_success_rate
from completed_orders c
cross join total_orders t
;