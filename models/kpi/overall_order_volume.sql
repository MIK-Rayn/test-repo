-- models/kpi/overall_order_volume.sql

{{ config(materialized='table') }}

with order_data as (
    select
        ID,
        CREATION_DATE
    from {{ ref('ORDER_HISTORY') }}
    where CREATION_DATE between '{{ var("start_date") }}' and '{{ var("end_date") }}'
)

select
    count(distinct ID) as overall_order_volume
from order_data;
