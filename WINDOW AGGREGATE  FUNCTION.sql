-- Window fucntion 
/*
A window function in SQL lets you perform a calculation across a 
group of related rows without collapsing those rows into one row.

level of detail - In WINDOW FUNCTION  you maintain that detail 
                  while in the GROUP BY you aggregate the rows this changes the level of detail 

-----------------------------------------------------------------------------------------------------------------
When do we use the window function (Aggregation) vs Aggregation function ?

Aggregation + group by => Use it when you want to summarize data and don't need the individual rows in the result.
                          LIMIT -> can't provide details and aggregate at the same time 

Window function =>  Use it when you want the calculation but also want to keep the individual rows.
*/

-- Find the total sales across all orders 
use SalesDB
SELECT 
SUM(Sales) TotalSales
FROM Sales.Orders

-- Find the total sales for each product 
SELECT 
ProductID,
SUM(Sales) AS TotalSales
FROM Sales.Orders
GROUP BY (ProductID)

-- Find the total sales for each product 
-- Additionally provide details such as order id , order date 
SELECT 
ProductID,
OrderID,
OrderDate,
SUM(Sales) TotalSales
FROM Sales.Orders
GROUP BY ProductID
/*
**ERROR**
the columns added in the select must be added in the group by as well 
even if you add the all the select column in the group by it will be a mess 

LIMIT -> can't provide details and aggregate at the same time*/

-- using the window function for the same task 
SELECT 
ProductID,
OrderID,
OrderDate,
SUM(Sales) OVER(partition by ProductID) TotalSales
FROM Sales.Orders
--===================================================================================================================================================================
/*
SYNTAX OF THE WINDOW FUNCTION 

WINDOW FUNCTION + OVER CLAUSE [ (PARTITION CLAUSE ) / (ORDER CLAUSE) / (FRAME CLAUSE)

EXAMPLE = AVG(Sales) OVER (PARTITION BY Category ORDER BY (DESC/ASC/OrderDate) ROWS UNBOUNDED PRECEDING )

AGGREGATE FUNCTION -> EXPRESSION :- {COUNT() accepts all data type agruments 
                                     ALL OTHER only accepts the numeric type }
                      PARTITON CLAUSE :- { OPTIONAL }
                      ORDER BY CLAUSE :- {OPTIONAL}

RANK FUNCTION -> EXPRESSION :- {NTILE() accepts numeric type 
                               ALL OTHER no need to put arguments / can stay empty }
                 PARTITON CLAUSE :- { OPTIONAL }
                 ORDER BY CLAUSE :- {REQUIRED}

VALUE (ANALYTICS ) FUNCTION -> EXPRESSION :- { ALL accepts all data types values }
                               PARTITON CLAUSE :- { OPTIONAL }
                               ORDER BY CLAUSE :- {REQUIRED}

---=============================================================================================================================================================

PARTITION BY divides your rows into groups/windows for the calculation,
               but unlike GROUP BY, it does NOT collapse the rows.

EMPTY :- gives you the total sales across all rows      ex- SUM(Sales) OVER{}

SINGLE COLUMN :- gives the total sales for each product   ex- SUM(Sales) OVER(PARTITION BY Product)

MULTIPLE COLUMN :- gives total sales for each combination of columns   ex- SUM(Sales) OVER(PARTITION BY Product, OrderStatus)
*/

-- Find the total sales across all orders 
-- find the total sales for each product 
-- find the total sales for each combination of product and order status
-- additionally provide details such order ID , order date 
SELECT 
ProductID,
OrderStatus,
Sales,
OrderDate,
OrderID,
SUM(Sales) OVER () TotalSales,
SUM(Sales) OVER( PARTITION BY ProductID) TotalSalesbyproduct ,
SUM(Sales) OVER(PARTITION BY ProductID , OrderStatus) TotalSalesbyproductandorderstatus 
FROM Sales.Orders

---=====================================================================================================================================================
/*
ORDER BY CLAUSE 
IN THE ORDER BY CLAUSE the windows either one or the whole window is sorted out in ascending or descingding order 
,each window will be sorted individually .

*/

-- EXAMPLE 
SELECT 
ProductID,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY Sales DESC) TOTALSALES
FROM Sales.Orders

-- ANOTHER EXAMPLE OF ORDER BY USING THE RANK FUCNTION 
SELECT 
OrderID,
OrderDate,
Sales,
RANK() OVER (ORDER BY Sales DESC) RANKSALES
FROM Sales.Orders

--==============================================================================================================================================================
/*
Frame Clause:- It defines which rows inside the current
               window should be included in the calculation 
               for the current row

NOTE :- THIS CLAUSE CAN ONLY BE USED WITH ORDER BY CLAUSE 
        LOWER BOUNDARY MUST BE BEFORE THE HIGHER BOUNDARY
        BY DEFAULT :- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 

FRAME TYPE :- ROWS / RANGE 

FRAME BOUNDARY :- LOWER VALUE AND HIGHER VALUE 

LOWER VALUE :- CURRENT ROW 
               N PRECEDING 
               UNBOUNDED PRECEDING

HIGHER VALUE :- CURRENT ROW 
                N FOLLOWING 
                UNBOUNDED FOLLOWING :- THE LAST POSSIBLE ROW WITHIN A WINDOW

EXAMPLE :- ROWS BETWEEN CURRENT ROW {LOWER} AND UNBOUNDED PRECEDING {HIGHER}

--------------------------------------------------------------------------------------------------------------------------------------------------------------

TYPE 1 :- ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING
INSIDE EACH WINDOW 
For the current row, include itself and the next 2 rows in the calculation
-> current row ka result like sum = current row ka sale + uske baad aane wale do sales ko mila ke total vo banega 
-> last current row ke liye jahan window end hoti h vo wahan dusri window pe shift nhi hoga 
*/

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY Sales DESC
ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING) SUMSALES
FROM Sales.Orders

--------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 2 :- ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING
Start from the current row and include every row after it until the last row of the window

-> current row se last row tak ka calculation of the window current row ka result banega 
*/

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER 
(PARTITION BY OrderStatus 
ORDER BY Sales DESC
ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) AS SUMSALES
FROM Sales.Orders

----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 3 :- ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
For the current row, include itself and the previous 1 row in the calculation
-> current row ka result like sum = current row ka sale + uske pehle aane wale ek sales ko mila ke
*/

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY Sales DESC
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) SUMSALES
FROM Sales.Orders

----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 4 :- ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
For the current row, include itself and the previous 1 row AND after 1 row in the calculation
-> current row ka result like sum = current row ka sale + uske pehle aane wale ek sale aur current row ke baad ka ek ko mila ke aayega
*/

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY Sales DESC
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) SUMSALES
FROM Sales.Orders

----------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 4 :- ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING

For every current row, use all rows in the entire window/partition for the calculation.
*/

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER(
                PARTITION BY OrderStatus
                ORDER BY Sales DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SALESSUM
FROM Sales.Orders

--====================================================================================================================================================================================
/*
RULE NO 1 :- window function are only used with select and order by clause and not used for filtering(where clause) the data.
 */

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER(
                PARTITION BY OrderStatus
                ORDER BY Sales DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SALESSUM
FROM Sales.Orders
ORDER BY SUM(Sales) OVER(
                PARTITION BY OrderStatus) DESC

/*
THESE 2 WILL THROW ERROR 

--> 1.
SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER(
                PARTITION BY OrderStatus
                ORDER BY Sales DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SALESSUM
FROM Sales.Orders
WHERE SUM(Sales) OVER(
                PARTITION BY OrderStatus) > 100

--> 2.
SELECT 
OrderID,
OrderStatus,
Sales,
SUM(Sales) OVER(
                PARTITION BY OrderStatus
                ORDER BY Sales DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS SALESSUM
FROM Sales.Orders
GROUP BY SUM(Sales) OVER(
                PARTITION BY OrderStatus) 
*/

/*
WHY THESE 2 WILL THROW AN ERROR ?
--> this is the execution flow of sql query 
1. FROM
2. WHERE
3. GROUP BY
4. HAVING
5. Window Functions
6. SELECT
7. ORDER BY

We are using the "SUM(Sales) OVER(
                PARTITION BY OrderStatus)"{window function} inside the WHERE clause , the sql will not filter the result because 
                window function calculation haven't been performed yet. this is why it will give error .
                */
--------------------------------------------------------------------------------------------------------------------------------------------------
/*
RULE NO 2 :- NESTING WINDOW FUNCTION IS NOT ALLOWED 
FOR EX :- 

SELECT 
OrderID,
OrderStatus,
Sales,
SUM(SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY Sales DESC)
ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) SUMSALES
FROM Sales.Orders
*/

-----------------------------------------------------------------------------------------------------------------------------------------------
/*
RULE NO 3 :- SQL EXECUTES THE WINDOW FUNTION AFTER THE WHERE CLAUSE
*/

-- FIND THE TOTAL SALES FOR EACH ORDER STATUS , ONLY FOR TWO PRODUCTS 101 AND 102

SELECT 
OrderID,
OrderDate,
OrderStatus,
ProductID,
Sales,
SUM(Sales) OVER (PARTITION BY OrderStatus) TotalSales
FROM Sales.Orders
WHERE ProductID IN (101 , 102 )

-----------------------------------------------------------------------------------------------------------------------------
/*
RULE NO 4:- WINDOW FUNCTION CAN BE USED TOGETHER WITH GROUP BY 
            IN THE SAME QUERY (ONLY IF THE SAME COLUMNS ARE USED )
*/

-- RANK THE CUSTOMER BASED ON THEIR TOTAL SALES 
SELECT
CustomerID,
SUM(Sales) AS TotalSales,
RANK() OVER (ORDER BY SUM(Sales) DESC ) RankCustomer
FROM Sales.Orders
GROUP BY CustomerID
-- here we can use the window function because SUM(Sales) is part of group by
-- so we have to use the same SUM(Sales)in the window function for it to work


