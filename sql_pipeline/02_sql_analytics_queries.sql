-- QUERY 1: Contract & Tenure Vulnerability Analysis 
SELECT 
    Contract,
    CASE 
        WHEN Tenure_in_Months < 6 THEN '1. New (< 6 Months)'
        WHEN Tenure_in_Months BETWEEN 6 AND 12 THEN '2. Growing (6-12 Months)'
        ELSE '3. Loyal (> 12 Months)'
    END AS Tenure_Group,
    COUNT(Customer_ID) AS Total_Customers,
    SUM(CASE WHEN Customer_Status = 'Churned' THEN 1 ELSE 0 END) AS Churned_Customers,
    ROUND(
        SUM(CASE WHEN Customer_Status = 'Churned' THEN 1.0 ELSE 0 END) * 100.0 / COUNT(Customer_ID), 2
    ) AS Churn_Rate_Pct
FROM vw_ChurnData
GROUP BY 
    Contract,
    CASE 
        WHEN Tenure_in_Months < 6 THEN '1. New (< 6 Months)'
        WHEN Tenure_in_Months BETWEEN 6 AND 12 THEN '2. Growing (6-12 Months)'
        ELSE '3. Loyal (> 12 Months)'
    END
ORDER BY Churn_Rate_Pct DESC;
GO

-- QUERY 2: Top 3 Highest Revenue Lost per State
WITH RankedChurnedCustomers AS (
    SELECT 
        Customer_ID,
        State,
        Contract,
        Internet_Type,
        Monthly_Charge,
        Total_Revenue,
        DENSE_RANK() OVER (PARTITION BY State ORDER BY Total_Revenue DESC) AS Revenue_Rank
    FROM vw_ChurnData
    WHERE Customer_Status = 'Churned'
)
SELECT * 
FROM RankedChurnedCustomers
WHERE Revenue_Rank <= 3;
GO

-- QUERY 3: Stored Procedure for Call-Center Priority List by State
CREATE PROCEDURE sp_GetHighRiskCustomersByState
    @StateName VARCHAR(50)
AS
BEGIN
    SELECT 
        Customer_ID,
        State,
        Age,
        Tenure_in_Months,
        Internet_Type,
        Contract,
        Monthly_Charge,
        Total_Revenue,
        NTILE(3) OVER (ORDER BY Monthly_Charge DESC) AS Spending_Tier
    FROM vw_JoinData
    WHERE State = @StateName 
      AND Contract = 'Month-to-Month'
    ORDER BY Monthly_Charge DESC;
END;
GO
