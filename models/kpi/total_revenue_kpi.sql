-- total_revenue_kpi.sql
-- This model calculates the Total Revenue KPI by summing the order totals from the order history table.

with base as (
    select
        total_value
    from {{ ref('order_history') }}
)

select
    sum(total_value) as total_revenue
from base;
