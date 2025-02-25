-- This dbt model calculates the Tax-to-Revenue Ratio KPI
-- Formula: (SUM(TAX_VALUE) / SUM(TOTAL_VALUE)) * 100

{{ config(materialized='table') }}

with order_totals as (
    select
        SUM(TAX_VALUE) as total_tax,
        SUM(TOTAL_VALUE) as total_revenue
    from {{ ref('order_history') }}
)

select
    total_tax,
    total_revenue,
    (total_tax / NULLIF(total_revenue, 0)) * 100 as tax_to_revenue_ratio
from order_totals
