SELECT
    extract(MONTH FROM date_date) as order_month,
    count(DISTINCT orders_id) as number_of_orders
FROM {{ source('raw_data', 'orders_reclutement') }}
WHERE extract(YEAR FROM date_date) = 2023
GROUP BY 1
ORDER BY 1