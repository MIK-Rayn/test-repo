-- overall_order_volume.sql

{{ config(materialized='table') }}

-- This model calculates the Overall Order Volume KPI by counting the total number of unique orders
-- from the ORDER_HISTORY table within a specified time period.

SELECT
    COUNT(DISTINCT ID) AS overall_order_volume
FROM {{ ref('ORDER_HISTORY') }}
WHERE CREATION_DATE BETWEEN '{{ var("start_date") }}' AND '{{ var("end_date") }}';