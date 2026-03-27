WITH products_per_order AS (
    SELECT
        order_id,
        extract(MONTH FROM date_date) as order_month,
        sum(qty) as total_products
    FROM {{ source('raw_data', 'sales_reclutement') }}
    WHERE extract(YEAR FROM date_date) = 2023
    GROUP BY 1, 2
)

SELECT
    order_month,
    avg(total_products) as avg_products_per_order
FROM products_per_order
GROUP BY 1
ORDER BY 1