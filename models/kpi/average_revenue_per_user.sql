-- Average Revenue Per User (ARPU) KPI Model

WITH invoice_data AS (
    SELECT
        customer_id,
        total_amount,
        invoice_date
    FROM {{ source('Combined Source', 'bil_invoices') }}
    WHERE invoice_date BETWEEN {{ var('start_of_month') }} AND {{ var('end_of_month') }}
)

SELECT
    SUM(total_amount) / COUNT(DISTINCT customer_id) AS ARPU
FROM invoice_data;
