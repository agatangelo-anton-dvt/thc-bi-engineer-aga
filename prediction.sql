CREATE OR REPLACE TABLE `agatangelo-anton-sandbox1.forecast_astrafy.exercise_forecast` AS
WITH forecast_data AS (
    SELECT
        CAST(forecast_timestamp AS DATE) as date_date,
        forecast_value as net_sales,
        prediction_interval_lower_bound as lower_bound,
        prediction_interval_upper_bound as upper_bound,
        'forecast' as type
    FROM
        ML.FORECAST(MODEL `agatangelo-anton-sandbox1.forecast_astrafy.sales_forecast_model`,
                    STRUCT(182 AS horizon, 0.9 AS confidence_level))
),
actual_data AS (
    SELECT
        CAST(ds AS DATE) as date_date,
        total_sales as net_sales,
        total_sales as lower_bound,
        total_sales as upper_bound,
        'actual' as type
    FROM `agatangelo-anton-sandbox1.forecast_astrafy.stg_forecast_input`
)


SELECT * FROM actual_data
UNION ALL
SELECT * FROM forecast_data
ORDER BY date_date ASC;
