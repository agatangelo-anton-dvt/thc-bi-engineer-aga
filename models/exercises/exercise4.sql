WITH sales_aggregation AS (
    SELECT
        order_id,
        sum(qty) as qty_product
    FROM {{ source('raw_data', 'sales_reclutement') }}
    GROUP BY 1
)

SELECT
    o.*,
    coalesce(s.qty_product, 0) as qty_product
FROM {{ source('raw_data', 'orders_reclutement') }} o
LEFT JOIN sales_aggregation s 
    ON o.orders_id = s.order_id
WHERE extract(YEAR FROM o.date_date) IN (2022, 2023)