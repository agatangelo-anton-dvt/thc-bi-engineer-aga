# BI Engineering Assessment - dbt & BigQuery

This README provides an overview of the dbt project implemented for the technical assessment, including the business logic for each exercise and the integration with BigQuery.

The goal of this project is to transform raw sales and order data into actionable business insights using **dbt (data build tool)** and **Google BigQuery**.

---

## 📂 Project Structure

The project is organized into logical layers to ensure modularity and clean data transformations:

* **`models/staging/`**: Initial cleaning, schema definition, and casting of raw data from the `raw_data` source.
* **`models/exercises/`**: SQL models corresponding to the requested business logic (Exercises 1-6).
* **`models/forecast/`**: Implementation of a sales forecasting model using **BigQuery ML (ARIMA_PLUS)**.

---

## 🛠 Exercises Implementation

### Exercise 1: Orders in 2023
Calculates the total number of unique orders placed during the year 2023.
* **Model:** `exercise1.sql`

### Exercise 2: Monthly Orders (2023)
Provides a monthly breakdown of the number of orders for the year 2023.
* **Model:** `exercise2.sql`

### Exercise 3: Average Products per Order
Calculates the average quantity of products per order for each month in 2023 by aggregating sales data.
* **Model:** `exercise3.sql`

### Exercise 4: Orders with Product Quantities
Creates a comprehensive table for all orders in 2022 and 2023, enriched with a `qty_product` column showing the total items per order.
* **Model:** `exercise4.sql`

### Exercise 5: Customer Segmentation Logic
Implements a rolling 12-month window to segment orders based on customer loyalty:
* **New:** 0 orders in the previous 12 months.
* **Returning:** 1 to 3 orders in the previous 12 months.
* **VIP:** 4 or more orders in the previous 12 months.
* **Model:** `exercise5.sql`

### Exercise 6: 2023 Order Segmentation Table
A final table for 2023 orders that includes the specific segmentation (**New**, **Returning**, or **VIP**) for every transaction.
* **Model:** `exercise6.sql`

---

## 🚀 Advanced Feature: Sales Forecasting

I had some trouble implementing the forecast with dbt and did it directly in BigQuery to avoid errors since I don't have much experience with dbt.

1.  **New table with correct format for forecasting:**
CREATE OR REPLACE TABLE `agatangelo-anton-sandbox1.forecast_astrafy.stg_forecast_input` AS
SELECT
    CAST(date_date AS TIMESTAMP) as ds,
    SUM(net_sales) as total_sales
FROM `agatangelo-anton-sandbox1.raw_data.sales_reclutement`
GROUP BY 1;


3.  **Model & Training:**
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


4.  **Prediction:** The `forecast` model generates a **182-day outlook** with confidence intervals, unioned with historical data for seamless visualization.
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

