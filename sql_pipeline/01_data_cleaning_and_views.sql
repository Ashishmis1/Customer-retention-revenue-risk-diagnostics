/* =========================================================================
   FILE: 01_data_cleaning_and_views.sql
   PROJECT: Telecom Customer Retention & Revenue Risk Data Pipeline
   PURPOSE: 
     1. Clean raw customer records (Bronze -> Silver Layer).
     2. Fix negative Monthly_Charge anomalies (e.g., -8, -5, -1) and NULLs.
     3. Create standardized SQL Views (vw_ChurnData & vw_JoinData) for 
        downstream Python ETL and Power BI consumption.
   ========================================================================= */

-- 1. Create Silver Layer Cleaned Table from Raw Telecom Staging Data
SELECT 
    Customer_ID,
    Gender,
    Age,
    ISNULL(Married, 'No') AS Married,
    State,
    Number_of_Referrals,
    Tenure_in_Months,
    ISNULL(Value_Deal, 'No Deal') AS Value_Deal,
    ISNULL(Phone_Service, 'No') AS Phone_Service,
    ISNULL(Multiple_Lines, 'No') AS Multiple_Lines,
    ISNULL(Internet_Service, 'No') AS Internet_Service,
    ISNULL(Internet_Type, 'None') AS Internet_Type,
    ISNULL(Online_Security, 'No') AS Online_Security,
    ISNULL(Online_Backup, 'No') AS Online_Backup,
    ISNULL(Device_Protection_Plan, 'No') AS Device_Protection_Plan,
    ISNULL(Premium_Support, 'No') AS Premium_Support,
    ISNULL(Streaming_TV, 'No') AS Streaming_TV,
    ISNULL(Streaming_Movies, 'No') AS Streaming_Movies,
    ISNULL(Streaming_Music, 'No') AS Streaming_Music,
    ISNULL(Unlimited_Data, 'No') AS Unlimited_Data,
    Contract,
    ISNULL(Paperless_Billing, 'No') AS Paperless_Billing,
    Payment_Method,
    -- Fix negative billing anomalies found in raw data (e.g., Customer 32586-UTT had -8)
    CASE 
        WHEN Monthly_Charge < 0 THEN ABS(Monthly_Charge)
        ELSE Monthly_Charge 
    END AS Monthly_Charge,
    Total_Charges,
    ISNULL(Total_Refunds, 0) AS Total_Refunds,
    ISNULL(Total_Extra_Data_Charges, 0) AS Total_Extra_Data_Charges,
    ISNULL(Total_Long_Distance_Charges, 0) AS Total_Long_Distance_Charges,
    Total_Revenue,
    Customer_Status,
    ISNULL(Churn_Category, 'Others') AS Churn_Category,
    ISNULL(Churn_Reason, 'Others') AS Churn_Reason
INTO stg_CleanedCustomerData
FROM raw_CustomerData;
GO

-- 2. Create View for Historical Diagnostics & Retention Analysis (Stayed vs. Churned)
CREATE VIEW vw_ChurnData AS
SELECT *
FROM stg_CleanedCustomerData
WHERE Customer_Status IN ('Stayed', 'Churned');
GO

-- 3. Create View for Newly Joined Customers Cohort (Joined)
CREATE VIEW vw_JoinData AS
SELECT *
FROM stg_CleanedCustomerData
WHERE Customer_Status = 'Joined';
GO
