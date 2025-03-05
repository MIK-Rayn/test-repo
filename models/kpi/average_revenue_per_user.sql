with payments as (
    select
        bp.invoice_id,
        bp.amount,
        bp.payment_date
    from {{ source('Combined Source', 'BIL_PAYMENTS') }} bp
),

invoices as (
    select
        bi.invoice_id,
        bi.customer_id,
        bi.invoice_date
    from {{ source('Combined Source', 'BIL_INVOICES') }} bi
),

aggregated as (
    select
        sum(case when date_trunc('month', p.payment_date) = {{ var('target_month') }} then p.amount else 0 end) as total_payments,
        count(distinct case when date_trunc('month', i.invoice_date) = {{ var('target_month') }} then i.customer_id end) as customer_count
    from payments p
    left join invoices i on p.invoice_id = i.invoice_id
)

select
    case
        when customer_count = 0 then 0
        else total_payments / customer_count
    end as arpu,
    {{ var('target_month') }} as target_month
from aggregated;