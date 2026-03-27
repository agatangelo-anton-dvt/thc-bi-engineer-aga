CREATE OR REPLACE TABLE `agatangelo-anton-sandbox1.forecast_astrafy.stg_forecast_input` AS
SELECT
    CAST(date_date AS TIMESTAMP) as ds,
    SUM(net_sales) as total_sales
FROM `agatangelo-anton-sandbox1.raw_data.sales_reclutement`
GROUP BY 1;
