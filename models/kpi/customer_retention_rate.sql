-- This model calculates the Customer Retention Rate KPI
{{ config(materialized='table') }}

SELECT
    (
        COUNT(DISTINCT CASE
            WHEN start_date <= {{ var('PeriodStart') }}
                 AND (end_date IS NULL OR end_date >= {{ var('PeriodEnd') }})
            THEN customer_id
        END) * 100.0
        /
        COUNT(DISTINCT CASE
            WHEN start_date <= {{ var('PeriodStart') }}
            THEN customer_id
        END)
    ) AS customer_retention_rate
FROM {{ source('Combined Source', 'PRV_SERVICE_ASSIGNMENTS') }};