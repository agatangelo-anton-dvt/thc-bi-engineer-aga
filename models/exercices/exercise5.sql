{{ config(
    materialized='view'
) }}

WITH history AS (
    SELECT
        orders_id,
        customers_id,
        date_date,
        -- Calculamos cuántos pedidos hizo el cliente en los 365 días anteriores
        COUNT(orders_id) OVER (
            PARTITION BY customers_id 
            ORDER BY UNIX_DATE(date_date) 
            RANGE BETWEEN 365 PRECEDING AND 1 PRECEDING
        ) as orders_last_12_months
    FROM {{ source('raw_data', 'orders_reclutement') }}
),

orders_segmented AS (
    SELECT
        h.orders_id,
        h.customers_id,
        h.date_date,
        CASE 
            WHEN h.orders_last_12_months = 0 THEN 'New'
            WHEN h.orders_last_12_months BETWEEN 1 AND 3 THEN 'Returning'
            WHEN h.orders_last_12_months >= 4 THEN 'VIP'
        END as segment
    FROM history h
    WHERE EXTRACT(YEAR FROM h.date_date) = 2023
)

SELECT 
    os.orders_id,
    os.customers_id,
    os.date_date,
    os.segment
FROM orders_segmented os