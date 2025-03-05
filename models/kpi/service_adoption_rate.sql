with multi_service_customers as (
    select customer_id
    from { source('Combined Source', 'prv_service_assignments') }
    where status = { var('active_status') }
    group by customer_id
    having count(service_id) >= { var('multi_service_threshold') }
), total_customers as (
    select count(*) as total_count
    from { source('Combined Source', 'crm_customers') }
)

select 
    ( (select count(*) from multi_service_customers) / (select total_count from total_customers) ) * 100 as service_adoption_rate
