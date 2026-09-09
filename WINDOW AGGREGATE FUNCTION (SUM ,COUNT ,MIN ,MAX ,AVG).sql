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

-- Find the total sales across all orders 
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

--------------------------------------------------------------------------------------------------------------------------------

/*
3. AVG () = Returns the AVERAGE of values within a window.

   NOTE :- If the window has a null row during the average computation it will e ignored.
           Each window will have a seperate average .

*/
-- USE CASE -> Group wise analysis 
-- Find the average sales across all orders 
-- And find the average sales for each product 
-- Additionally provide details such orderID, order date 

SELECT 
ProductID,
OrderID,
OrderDate,
AVG(Sales) OVER () AvgSales,
AVG(Sales) OVER (PARTITION BY ProductID) AvgProductSales
FROM Sales.Orders


-- Hndling the NULL before and after average 
-- Find the average score of customers.
-- Additionally , provide details such as customer ID and Last Name

SELECT 
CustomerID,
LastName,
Score,
COALESCE (Score,0) CustomerScore,
AVG(Score) OVER() AvgScoreWithNULL,
AVG(COALESCE(Score,0))OVER() AvgScore
FROM Sales.Customers

-- COMPARE TO AVERAGE :- Helps to eveluate whether a value is above or below average 
-- Find all orders where sales are higher than the average sales across all orders 
SELECT *
FROM (
SELECT
ProductID,
OrderID,
OrderDate,
Sales,
AVG(Sales) OVER () AvgSales
FROM Sales.Orders) t
WHERE Sales > AvgSales

---------------------------------------------------------------------------------------------------------------------
/*
MIN) and MAX :- find the highest and lowest sales for each product.

   NOTE :- If the window has a null row during the average computation it will e ignored.
           Each window will have a seperate average
*/

--Find the highest and lowest sales of all orders 
-- find the highest and lowest sales of each product 
-- additionaly provide details such as order id ,orderdate 

SELECT 
ProductID,
OrderID,
OrderDate,
MAX(Sales) OVER() HighestSales,
MIN(Sales) OVER() LowestSales,
MAX(Sales) OVER(PARTITION BY ProductID) MaximumByProduct,
MIN(Sales) OVER(PARTITION BY ProductID) MinimumByProduct
FROM Sales.Orders


-- Show the employee who have the highest salaries
SELECT *
FROM (
SELECT 
*,
MAX(Salary) OVER() HighestSalary
FROM Sales.Employees) t
WHERE Salary = HighestSalary

-- USE CASE :- Compare to extremes { Help to evaluate how well a value is performing relative to the extremes} 
--Find the deviation of each sales from the minimum and maximum sales amount.
SELECT 
OrderID,
OrderDate,
ProductID,
Sales,
MAX(Sales) OVER() HighestSales,
MIN(Sales) OVER() LowestSales,
Sales - MIN(Sales) OVER() DeviationFromMin,   -- Lower the deviation , the closer the data point is to the extreme.
MAX(Sales)  OVER()- sales DeviationFromMax    -- 
FROM Sales.Orders

------------------------------------------------------------------------------------------------------------------------------
/*
RUNNING TOTAL & ROLLING TOTAL :- window function concepts 

A. RUNNING TOTAL :- when you define the frame ,keep adding values from the beginning to the current row 
b. ROLLING TOTAL :- Similary with the frames , calculate the total using a fixed number of nearby rows that moves along with the current row {generally 2 PRECEDING AND CURRENT ROW } 

Suppose you're analyzing monthly sales.

Running total question:
"How much total revenue have we generated so far this year?"
Use a running total.
Rolling total question:
"What were the total sales during the last 3 months?"
Use a rolling total.

MAIN USE CASE IS :- 
1. -> TRACKING :- Tracking current sales with target sales 
2. -> Trend Analysis :- Providing insights into historical patterns 
*/

-- Calculate the moving average of sales for each product over time
-- OVER TIME analysis means sorting dates in ascending order 
SELECT 
OrderID,
ProductID,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg
FROM Sales.Orders

-- Calculate the moving average of sales for each product over time,including only the next order 
-- OVER TIME analysis means sorting dates in ascending order 
SELECT 
OrderID,
ProductID,
OrderDate,
Sales,
AVG(Sales) OVER(PARTITION BY ProductID) AvgByProduct,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate) MovingAvg,
AVG(Sales) OVER(PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) RollingAvg
FROM Sales.Orders