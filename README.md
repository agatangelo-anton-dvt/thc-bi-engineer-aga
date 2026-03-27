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
The code is in the "forecast" folder in this repository:

1. **New table with correct format for forecasting**
2. **Model & Training**
3. **Prediction:** The `forecast` model generates a **182-day outlook** with confidence intervals, unioned with historical data for seamless visualization.

