with cac_calculation as (
    select
        sum(c.BUDGET) as total_budget,
        count(distinct case when t.RESPONSE_FLAG = TRUE then t.CUSTOMER_ID end) as responders_count
    from {{ source('Combined Source', 'MKT_CAMPAIGNS') }} as c
    left join {{ source('Combined Source', 'MKT_CAMPAIGN_TARGETS') }} as t
        on c.CAMPAIGN_ID = t.CAMPAIGN_ID
)

select
    case
        when responders_count = 0 then 0
        else total_budget / responders_count
    end as customer_acquisition_cost
from cac_calculation