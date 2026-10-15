# 📊 Telecom Customer Retention & Revenue Risk Data Pipeline
**End-to-End Data Engineering & Retention Analytics Pipeline using MS SQL Server (T-SQL), Python (Pandas), and Power BI**

## 🏢 Business Overview
Customer churn is a critical revenue leak for telecommunication providers. This project implements an end-to-end data pipeline and diagnostic dashboard designed to clean raw customer billing records, segment vulnerable cohorts using SQL and Python, quantify revenue at risk, and prioritize call-center retention workflows.

## 🛠️ Tech Stack & Pipeline Architecture
* **SQL Data Engineering (`sql_pipeline/`):** 
  * Built T-SQL data cleaning scripts to resolve `NULL` values and negative `Monthly_Charge` billing anomalies, creating standardized database views (`vw_ChurnData` and `vw_JoinData`).
  * Wrote analytical queries utilizing **CTEs**, **`CASE WHEN` cohort logic**, **Window Functions (`DENSE_RANK`, `NTILE`)**, and a parameterized **Stored Procedure (`sp_GetHighRiskCustomersByState`)** for state-level call-center reporting.
* **Python ETL & Risk Scoring (`python_etl/`):** 
  * Used **Pandas** and **NumPy** to run automated data quality checks (duplicate ID validation, anomaly handling) and assign customer value tiers (`High`, `Mid`, `Low`).
  * Flagged **382 high-flight-risk accounts** from the new joiner cohort and exported the processed dataset (`Predictions.csv`) for BI reporting.
* **BI & Data Visualization (`churn analysis.pbix`):** 
  * Designed a 3-page interactive Power BI dashboard using custom **DAX** measures to track historical churn drivers and isolate **₹16,215** in monthly revenue at risk.

---

## 📊 Dashboard Previews

### 1. Historical Diagnostics
<img src="BI%20page%201.png" width="800">

### 2. At-Risk Cohort & Call-Center Priority List
<img src="BI%20page%202.png" width="800">

### 3. Executive Action Plan & Value Tiering
<img src="BI%20page%203.png" width="800">

---

## 📈 Key Business Insights
1. **Root Cause Identification:** Out of **6,418** total customers (**1,732** historical churners; **26.99%** churn rate representing **₹3M** in lost revenue), the primary drivers of departure were competitor device/data offerings and poor support staff attitude.
2. **Contract Vulnerability:** Over **75%** of churned customers were on **Month-to-Month** contracts, and **Fiber Optic** users showed the highest service-level churn rate.
3. **Revenue at Risk:** The pipeline isolated **382** current accounts at high risk of churning, representing **₹16,215.45** in monthly recurring charges and **₹43,192.54** in cumulative total revenue.

## 💡 Recommended Retention Strategy
Using DAX and Python segmentation, the 382 flagged accounts were grouped into **Value Tiers** (`Low <₹40`, `Mid ₹40–₹79`, `High ₹80+`):
* **High-Value Accounts (₹8,364.37 in cumulative revenue at risk):** Prioritize for direct call-center outreach with customized loyalty discounts.
* **Month-to-Month Cohort:** Trigger automated 10% discount offers after 3 months of tenure to transition users onto 1-Year lock-in contracts.
* **Fiber Optic Users:** Provide proactive tech-support check-ins and speed audits to counter competitor offerings.
