with invoices as (
    select
        customer_id,
        total_amount
    from {{ source('Combined Source', 'bil_invoices') }}
    where invoice_date >= {{ var('start_date') }}
      and invoice_date < {{ var('end_date') }}
),

customers as (
    select
        customer_id
    from {{ source('Combined Source', 'crm_customers') }}
)

select
    sum(i.total_amount) / count(distinct c.customer_id) as customer_lifetime_value
from invoices i
join customers c on i.customer_id = c.customer_id
;