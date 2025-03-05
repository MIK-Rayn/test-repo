WITH retention AS (
    SELECT
        COUNT(DISTINCT CASE WHEN start_date <= {{ var('PeriodStart') }} AND (end_date IS NULL OR end_date > {{ var('PeriodEnd') }}) THEN customer_id END) AS retained_customers,
        COUNT(DISTINCT CASE WHEN start_date <= {{ var('PeriodStart') }} AND (end_date IS NULL OR end_date > {{ var('PeriodStart') }}) THEN customer_id END) AS total_customers
    FROM {{ source('Combined Source', 'prv_service_assignments') }}
)

SELECT
    retained_customers,
    total_customers,
    CASE
        WHEN total_customers > 0 THEN (retained_customers * 100.0) / total_customers
        ELSE NULL
    END AS customer_retention_rate
FROM retention;