with budgets as (
    select sum(budget) as total_budget
    from { source('Combined Source', 'mkt_campaigns') }
),

targets as (
    select count(distinct customer_id) as total_customers
    from { source('Combined Source', 'mkt_campaign_targets') }
)

select 
    case 
        when t.total_customers = 0 then 0 
        else b.total_budget / t.total_customers 
    end as customer_acquisition_cost
from budgets b, targets t;