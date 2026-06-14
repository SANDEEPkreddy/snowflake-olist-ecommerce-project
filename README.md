# Olist Brazilian E-Commerce Data Engineering Project

An end-to-end Data Engineering pipeline engineered inside **Snowflake** utilizing the Olist Brazilian E-Commerce dataset. This project demonstrates the implementation of a **Medallion Architecture (Bronze -> Silver -> Gold)** to clean raw, transactional data and transform it into analytics-ready data assets.

---

## 🏗️ Architecture & Data Pipeline Workflow

The data moves through three distinct layers within Snowflake to ensure high data quality and separation of concerns:

1. **Staging Layer (`OLIST_STAGE`):** Raw CSV files were uploaded directly from a local machine into an internal Snowflake stage using Snowflake's web UI "Add Data" feature. A customized CSV File Format was implemented to handle string wrapping, header skipping, and proper `NULL` string conversions.
2. **Bronze Layer (`BRONZE` Schema):** Ingestion tables that mirror the exact structure of the source files to capture raw data points immediately (`SELECT *`).
3. **Silver Layer (`SLIVER` Schema):** The operational cleaning zone. Here, duplicate records are stripped out using `DISTINCT`, whitespace is removed via `TRIM()`, and bad data is removed via strict multi-column `DELETE` operations where critical keys (like `order_id` or timestamps) are missing.
4. **Gold Layer (`GOLD` Schema):** The business-intelligence-ready layer. Optimized analytical views and tables constructed for rapid querying, reporting, and high-performance indexing.

---

## 📊 Key Business & Operational Insights Answered

The pipeline includes a comprehensive analytics suite of **50 business questions** executed on the final data layers. Some of the core analytical capabilities implemented include:

* **Financial Revenue Trends:** Aggregated revenue tracking showing historical e-commerce velocity, including isolating the highest and lowest revenue-generating months.
* **Customer Behavioral Cohorts:** Segmented analysis tracking unique customer counts, identifying geographic customer concentrations by state/city, and separating one-time buyers from high-value repeat purchase groups.
* **Sales Micro-Economics:** Ranking the top 20 best-selling products, calculating category revenue shares using percentages, and evaluating average order values (AOV).
* **Vendor Economics & Performance:** Tracking vendor locations by state and utilizing windowed analytical calculations (`DENSE_RANK() OVER (PARTITION BY state ORDER BY revenue DESC)`) to isolate and identify the top 5 sellers per region.
* **Logistics & Payment Performance:** Analyzing credit risk and consumer preference by tracking installment distributions and identifying revenue variance across different payment methods (Credit Card, Boleto, etc.).

---

## 🛠️ Tech Stack & Key SQL Concepts Used

* **Platform:** Snowflake Cloud Data Warehouse
* **Compute Optimization:** Custom Virtual Warehouse Configuration (`WAREHOUSE_SIZE = 'SMALL'`, `AUTO_SUSPEND = 300`, `AUTO_RESUME = TRUE`) for cloud cost management.
* **Data Ingestion:** Snowflake Data Loading UI, Internal Stages, Custom File Formats (`TYPE = 'CSV'`).
* **Advanced SQL:** Analytical Window Functions (`DENSE_RANK()`, `PARTITION BY`), Complex Multi-Table Joins (`LEFT`/`RIGHT JOIN`), Aggregations (`COUNT_IF()`, `DATE_TRUNC()`), and Conditional Data Cleansing.

---

## 📂 Project Structure

* `olist_pipeline.sql` — Contains the full end-to-end SQL script including environment setup, database/schema creation, Medallion data transformations, pipeline cleansing rules, and the 50 analytical business queries.
* `README.md` — Project overview, architecture description, and capabilities summary.

---

