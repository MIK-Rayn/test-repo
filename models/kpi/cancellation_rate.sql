-- cancellation_rate.sql
-- This model calculates the Cancellation Rate KPI

WITH order_data AS (
    SELECT
        ID,
        CANCEL_REQUEST
    FROM {{ ref('ORDER_HISTORY') }}
)

SELECT
    (SUM(CASE WHEN CANCEL_REQUEST = TRUE THEN 1 ELSE 0 END) / COUNT(ID)) * 100 AS cancellation_rate
FROM order_data;
