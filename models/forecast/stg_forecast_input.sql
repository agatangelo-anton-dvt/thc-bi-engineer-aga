{{ config(materialized='view') }}

SELECT
    -- Agrupamos ventas por día en el formato adecuado para BQML
    CAST(date_date AS TIMESTAMP) as ds,
    SUM(net_sales) as total_sales
from {{ source('raw_data', 'sales_reclutement') }}
GROUP BY 1