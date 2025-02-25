-- This model calculates the Profit Margin per Order
-- The profit margin is defined as:
-- (order_history.total_value - (sum(orders_line_item.cost_value * orders_line_item.quantity) + sum(orders_line_item.shipping_cost_value) + order_history.fee_value)) / order_history.total_value

with line_item_costs as (
    select
        order_id,
        sum(cost_value * quantity) as total_items_cost,
        sum(shipping_cost_value) as total_shipping_cost
    from {{ ref('orders_line_item') }}
    group by order_id
)

select
    oh.id as order_id,
    oh.total_value,
    oh.fee_value,
    li.total_items_cost,
    li.total_shipping_cost,
    case 
      when oh.total_value != 0 then (oh.total_value - (li.total_items_cost + li.total_shipping_cost + oh.fee_value)) / oh.total_value
      else null
    end as profit_margin_per_order
from {{ ref('order_history') }} oh
left join line_item_costs li on oh.id = li.order_id
