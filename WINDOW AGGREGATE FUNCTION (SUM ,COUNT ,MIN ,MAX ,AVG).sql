/*
WINDOW AGGREGATE FUNCTION 

1. COUNT () = Returns the number of rows within a window.
              Regardless of their datatypes .
*/
-----------------------------------------------------------------------------------------------------------------------------
-- USE CASE 1 --> OVERALL ANALYSIS :- Quick summary or snappchsot of the entire dataset.

-- Find the total number of Orders 
use SalesDB
SELECT 
COUNT(*) TotalOrders
FROM Sales.Orders
---------------------------------------------------------------------------------------------------------------------------------
-- USE CASE 2 :- TOTAL PER GROUPS :- Group-wise analysis to understand patterns within
-- different categories 

-- Find the total number of Orders
-- Find the total number of orders for each customers
-- additionally provide details such order ID , order date

SELECT 
CustomerID,
OrderID,
OrderDate,
COUNT(*) OVER () TotalOrders,
COUNT(*) OVER (PARTITION BY CustomerID) OrderByCustomers
FROM Sales.Orders
-------------------------------------------------------------------------------------------------------------
-- USE CASE 3 :- DATA QUALITY CHECK :- Detecting number of nulls by comparing to total number of rows .
-- Find the total number of customers 
-- Find the toal number of scores for the customer 
-- Additionally provide all customer details 

SELECT 
*,
COUNT(*) OVER() TotalCustomers,           -- COUNT(1) WILL DO THE SAME THING 
COUNT(Score) OVER() TotalScores           -- THIS STATEMENT WILL IGNORE THE NULL 
FROM Sales.Customers

------------------------------------------------------------------------------------------------------------------------
-- USE CASE 3 :- DATA QUALITY ISSUE :- Duplicates leads to inaccuracies in analysis.
--                                     COUNT() can be used to identify duplicates .
--                                     We can use the primary key to check for the duplicates 

--EXAMPLE 1
-- Check whether the table 'orders' contains any duplicate rows 
SELECT 
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.Orders

-- Each primary key window has one row thus it can be concluded that no duplicates exist .

-- EXAMPLE 2
-- Check whether the table 'orders' contains any duplicate rows 

SELECT 
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive

-- Here is the primary key orderid have duplicates ,now lets print only the duplicates 
-- Using the sub-query 

SELECT *
FROM (SELECT 
OrderID,
COUNT(*) OVER (PARTITION BY OrderID) CheckPK
FROM Sales.OrdersArchive)t                     -- inner query se ek derived table produce hogi ,ye temporary hogi aur sql mein ise ek naam dena hota hai  to hum ise 't' bolte hain
WHERE CheckPK > 1

-------------------------------------------------------------------------------------------------------------------------------------
/*
2. SUM () = Returns the sum values within a window  .
*/

-- Find the total slaes across all orders 
-- and the total sales for each product 
-- additionally provide details such as order id and order date 

SELECT 
ProductID,
OrderID,
OrderDate,
Sales,
SUM(Sales) OVER () TotalSales,
SUM(Sales) OVER (PARTITION BY ProductID) ByProduct
FROM Sales.Orders
---------------------------------------------------------------------------------------------------------------------
/*
USE CASE :- COMPARISON :- Compare the current value and aggregated value of window funstions
 
TYPE 1 :- PART TO WHOLE :- Shows the contribution of each datapoints to the overall dataset 
*/

-- Find the percentage contribution of each product's sales to the total sales 

SELECT 
OrderID,
ProductID,
Sales,
SUM(Sales) OVER () TotalSales,
Sales / SUM(Sales) OVER () * 100 Percentagecontri    -- there will be zeros because of the datatypes you divide integer you won't get float
FROM Sales.Orders

-- Corrected version 

SELECT 
OrderID,
ProductID,
Sales,
SUM(Sales) OVER () TotalSales,
ROUND(CAST(Sales AS FLOAT) / SUM(Sales) OVER () * 100,2) PercentageTotal   
FROM Sales.Orders

-- Order 8 is the highest contributer to the total