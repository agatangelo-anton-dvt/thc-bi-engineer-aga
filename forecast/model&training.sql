CREATE OR REPLACE MODEL `agatangelo-anton-sandbox1.forecast_astrafy.sales_forecast_model`
OPTIONS(
  model_type='ARIMA_PLUS',
  time_series_timestamp_col='ds',
  time_series_data_col='total_sales',
  auto_arima=TRUE,
  data_frequency='DAILY',
  holiday_region='ES'
) AS
SELECT ds, total_sales FROM `agatangelo-anton-sandbox1.forecast_astrafy.stg_forecast_input`;
