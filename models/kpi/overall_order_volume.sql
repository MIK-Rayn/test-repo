-- overall_order_volume.sql

{{ config(materialized='table') }}

with order_data as (
    select
        ID,
        CREATION_DATE
    from {{ ref('order_history') }}
)

select
    count(ID) as overall_order_volume
from order_data
where CREATION_DATE between '{{ var("start_date", "2023-01-01") }}' and '{{ var("end_date", "2023-12-31") }}'
;