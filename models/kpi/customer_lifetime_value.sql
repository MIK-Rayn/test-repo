-- This model calculates the Customer Lifetime Value (CLV) KPI.
-- CLV = SUM(ORDER_HISTORY.TOTAL_VALUE - (costs from line items) - (refunds from line items) - (refunds from payments))

with order_aggregates as (
    select
        oh.ID as order_id,
        oh.TOTAL_VALUE as total_value,
        (
            select coalesce(sum(li.cost_value * li.quantity), 0)
            from ORDERS_LINE_ITEM li
            where li.order_id = oh.ID
        ) as total_cost,
        (
            select coalesce(sum(lir.amount_value), 0)
            from ORDERS_LINE_ITEM_REFUND lir
            where lir.orders_line_item_order_id = oh.ID
        ) as total_line_item_refund,
        (
            select coalesce(sum(ppr.amount_value), 0)
            from ORDERS_PAYMENT_REFUND ppr
            where ppr.orders_payment_order_id = oh.ID
        ) as total_payment_refund
    from ORDER_HISTORY oh
)

select
    sum(total_value - total_cost - total_line_item_refund - total_payment_refund) as customer_lifetime_value
from order_aggregates;