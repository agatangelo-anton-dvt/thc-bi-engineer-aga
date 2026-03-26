select
    count(distinct orders_id) as total_orders_2023
from {{ source('raw_data', 'stg_orders_reclutement') }}
where extract(year from date_date) = 2023