{{ ref('create_training_model') }}

{{ config(materialized='table') }}

WITH forecast_data AS (
    SELECT
        *
    FROM
        ML.FORECAST(MODEL `{{ target.project }}.{{ target.schema }}.sales_forecast_model`,
                    STRUCT(30 AS horizon, 0.9 AS confidence_level))
)

SELECT
    CAST(forecast_timestamp AS DATE) as date_date,
    forecast_value as predicted_net_sales,
    prediction_interval_lower_bound as lower_bound,
    prediction_interval_upper_bound as upper_bound,
    'forecast' as type
FROM forecast_data

UNION ALL

-- Aquí aplicamos el CAST a DATE para que coincida con la parte superior
SELECT
    CAST(ds AS DATE) as date_date,
    total_sales as predicted_net_sales,
    total_sales as lower_bound,
    total_sales as upper_bound,
    'actual' as type
FROM {{ ref('stg_forecast_input') }}