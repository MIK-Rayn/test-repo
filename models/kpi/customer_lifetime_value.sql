with line_item_refunds as (
    select orders_line_item_order_id,
           sum(amount_value) as total_line_item_refund
    from ORDERS_LINE_ITEM_REFUND
    group by orders_line_item_order_id
),
payment_refunds as (
    select orders_payment_order_id,
           sum(amount_value) as total_payment_refund
    from ORDERS_PAYMENT_REFUND
    group by orders_payment_order_id
),
promotions as (
    select orders_line_item_order_id,
           sum(amount_value) as total_promotion
    from ORDERS_LINE_ITEM_PROMOTION
    group by orders_line_item_order_id
)

select 
    oh.BUYER_EMAIL as customer_email,
    sum(
        oh.TOTAL_VALUE 
        - oh.FEE_VALUE 
        - coalesce(lir.total_line_item_refund, 0)
        - coalesce(pr.total_payment_refund, 0)
        - coalesce(p.total_promotion, 0)
    ) as customer_lifetime_value
from ORDER_HISTORY oh
left join line_item_refunds lir
    on oh.ID = lir.orders_line_item_order_id
left join payment_refunds pr
    on oh.ID = pr.orders_payment_order_id
left join promotions p
    on oh.ID = p.orders_line_item_order_id
group by oh.BUYER_EMAIL