with multi_service_customers as (
    select
        customer_id
    from {{ source('Combined Source', 'PRV_SERVICE_ASSIGNMENTS') }}
    group by customer_id
    having count(distinct service_id) > 1
),

total_customers as (
    select count(distinct customer_id) as total_count
    from {{ source('Combined Source', 'PRV_SERVICE_ASSIGNMENTS') }}
),

multi_count as (
    select count(*) as multi_count
    from multi_service_customers
)

select
    case
        when t.total_count = 0 then 0
        else (m.multi_count::numeric / t.total_count) * 100
    end as service_adoption_rate
from multi_count m
cross join total_customers t
