WITH segmented_orders AS (
    SELECT * FROM {{ ref('exercice_5') }}
)

SELECT
    o.orders_id,
    o.customers_id,
    o.date_date,
    o.net_sales,
    s.segment as order_segmentation
FROM {{ source('raw_data', 'stg_orders_reclutement') }} o
INNER JOIN segmented_orders s 
    ON o.orders_id = s.orders_id
WHERE extract(YEAR FROM o.date_date) = 2023