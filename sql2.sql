USE marketing_db;

-- =====================================================
-- 1. BASIC DATA CHECK
-- =====================================================

SELECT * FROM Campaigns LIMIT 10;

SELECT * FROM Customers LIMIT 10;

SELECT * FROM Transactions LIMIT 10;


-- =====================================================
-- 2. TABLE STRUCTURE
-- =====================================================

DESCRIBE Campaigns;

DESCRIBE Customers;

DESCRIBE Transactions;


-- =====================================================
-- 3. BASIC COUNTS
-- =====================================================

SELECT COUNT(*) AS Total_Campaigns
FROM Campaigns;

SELECT COUNT(*) AS Total_Customers
FROM Customers;

SELECT COUNT(*) AS Total_Transactions
FROM Transactions;


-- =====================================================
-- 4. TOTAL REVENUE
-- =====================================================

SELECT
    SUM(revenue) AS Total_Revenue
FROM Transactions;


-- =====================================================
-- 5. AVERAGE TRANSACTION REVENUE
-- =====================================================

SELECT
    AVG(revenue) AS Average_Transaction_Revenue
FROM Transactions;


-- =====================================================
-- 6. CUSTOMER ACQUISITION COST BY CHANNEL
-- =====================================================

SELECT
    acquisition_channel,
    COUNT(*) AS Customer_Count,
    AVG(acquisition_cost) AS Average_Acquisition_Cost,
    SUM(acquisition_cost) AS Total_Acquisition_Cost
FROM Customers
GROUP BY acquisition_channel
ORDER BY Average_Acquisition_Cost ASC;


-- =====================================================
-- 7. REVENUE BY ACQUISITION CHANNEL
-- =====================================================

SELECT
    C.acquisition_channel,
    COUNT(DISTINCT C.customer_id) AS Customer_Count,
    COUNT(T.transaction_id) AS Transaction_Count,
    SUM(T.revenue) AS Total_Revenue,
    AVG(T.revenue) AS Average_Revenue
FROM Customers C
JOIN Transactions T
    ON C.customer_id = T.customer_id
GROUP BY C.acquisition_channel
ORDER BY Total_Revenue DESC;


-- =====================================================
-- 8. CHANNEL-WISE PROFIT AND ROI
-- =====================================================
-- Acquisition cost is calculated separately so that
-- customer acquisition cost is not counted multiple times
-- when a customer has multiple transactions.

WITH Channel_Cost AS (
    SELECT
        acquisition_channel,
        SUM(acquisition_cost) AS Total_Cost
    FROM Customers
    GROUP BY acquisition_channel
),

Channel_Revenue AS (
    SELECT
        C.acquisition_channel,
        SUM(T.revenue) AS Total_Revenue
    FROM Customers C
    JOIN Transactions T
        ON C.customer_id = T.customer_id
    GROUP BY C.acquisition_channel
)

SELECT
    R.acquisition_channel,
    R.Total_Revenue,
    C.Total_Cost,
    R.Total_Revenue - C.Total_Cost AS Profit,
    (
        (R.Total_Revenue - C.Total_Cost)
        / C.Total_Cost
    ) * 100 AS ROI_Percentage
FROM Channel_Revenue R
JOIN Channel_Cost C
    ON R.acquisition_channel = C.acquisition_channel
ORDER BY ROI_Percentage DESC;


-- =====================================================
-- 9. CUSTOMER CONVERSION RATE BY CHANNEL
-- =====================================================

SELECT
    C.acquisition_channel,
    COUNT(DISTINCT C.customer_id) AS Total_Customers,
    COUNT(DISTINCT T.customer_id) AS Converted_Customers,
    (
        COUNT(DISTINCT T.customer_id) /
        COUNT(DISTINCT C.customer_id)
    ) * 100 AS Conversion_Rate
FROM Customers C
LEFT JOIN Transactions T
    ON C.customer_id = T.customer_id
GROUP BY C.acquisition_channel
ORDER BY Conversion_Rate DESC;


-- =====================================================
-- 10. TOP 20 CUSTOMERS BY REVENUE
-- =====================================================

SELECT
    C.customer_id,
    C.acquisition_channel,
    C.acquisition_cost,
    COUNT(T.transaction_id) AS Transaction_Count,
    SUM(T.revenue) AS Total_Revenue
FROM Customers C
JOIN Transactions T
    ON C.customer_id = T.customer_id
GROUP BY
    C.customer_id,
    C.acquisition_channel,
    C.acquisition_cost
ORDER BY Total_Revenue DESC
LIMIT 20;


-- =====================================================
-- 11. CUSTOMER-LEVEL PROFIT AND ROI
-- =====================================================

SELECT
    C.customer_id,
    C.acquisition_channel,
    C.acquisition_cost,
    COUNT(T.transaction_id) AS Transaction_Count,
    SUM(T.revenue) AS Total_Revenue,
    SUM(T.revenue) - C.acquisition_cost AS Profit,
    (
        (SUM(T.revenue) - C.acquisition_cost)
        / C.acquisition_cost
    ) * 100 AS ROI_Percentage
FROM Customers C
JOIN Transactions T
    ON C.customer_id = T.customer_id
GROUP BY
    C.customer_id,
    C.acquisition_channel,
    C.acquisition_cost
ORDER BY ROI_Percentage DESC
LIMIT 20;


-- =====================================================
-- 12. CUSTOMERS WITH NO TRANSACTIONS
-- =====================================================

SELECT
    C.customer_id,
    C.acquisition_channel,
    C.acquisition_cost
FROM Customers C
LEFT JOIN Transactions T
    ON C.customer_id = T.customer_id
WHERE T.customer_id IS NULL
ORDER BY C.acquisition_cost DESC;