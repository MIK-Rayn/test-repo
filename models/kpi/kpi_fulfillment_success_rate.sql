-- kpi_fulfillment_success_rate Model

with fulfillment_data as (
    select
        oh.ID as order_id,
        oh.ORDER_FULFILLMENT_STATUS,
        fsi.order_id as fsi_order_id
    from {{ ref('order_history') }} oh
    join {{ ref('orders_fulfillment_start_instruction') }} fsi
      on oh.ID = fsi.order_id
)

select
    count(distinct case when ORDER_FULFILLMENT_STATUS = 'Completed' then order_id end) /
    nullif(count(distinct fsi_order_id), 0) as fulfillment_success_rate
from fulfillment_data
;