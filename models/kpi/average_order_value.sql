-- This model calculates the Average Order Value (AOV)
-- AOV = SUM(ORDER_HISTORY.TOTAL_VALUE) / COUNT(ORDER_HISTORY.ID)

with order_values as (
    select
        id,
        total_value
    from {{ ref('order_history') }}
)

select
    sum(total_value) / nullif(count(id), 0) as aov
from order_values
;