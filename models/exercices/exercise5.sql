WITH history AS (
    SELECT
        orders_id,
        customers_id,
        date_date,
        count(orders_id) OVER (
            PARTITION BY customers_id 
            ORDER BY unix_date(date_date) 
            RANGE BETWEEN 365 PRECEDING AND 1 PRECEDING
        ) as orders_last_12_months
    FROM {{ source('raw_data', 'stg_orders_reclutement') }}
)

SELECT
    orders_id,
    customers_id,
    date_date,
    CASE 
        WHEN orders_last_12_months = 0 THEN 'New'
        WHEN orders_last_12_months BETWEEN 1 AND 3 THEN 'Returning'
        WHEN orders_last_12_months >= 4 THEN 'VIP'
    END as segment
FROM history
WHERE extract(YEAR FROM date_date) = 2023