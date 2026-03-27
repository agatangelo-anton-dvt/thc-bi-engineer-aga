{{ config(
    materialized='table',
    post_hook=[
        "CREATE OR REPLACE MODEL `{{ target.project }}.{{ target.schema }}.sales_forecast_model`
         OPTIONS(
           model_type='ARIMA_PLUS',
           time_series_timestamp_col='ds',
           time_series_data_col='total_sales',
           auto_arima=TRUE,
           data_frequency='DAILY',
           holiday_region='ES'
         ) AS
         SELECT ds, total_sales FROM {{ ref('stg_forecast_input') }}"
    ]
) }}

-- Esta tabla solo guarda un registro de auditoría de cuándo se entrenó
SELECT CURRENT_TIMESTAMP() as model_trained_at