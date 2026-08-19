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
--=============================================================================================================================
/*
SYNTAX OF THE WINDOW FUNCTION 

WINDOW FUNCTION + OVER CLAUDE [ (PARTITION CLAUSE ) / (ORDER CLAUSE) / (FRAME CLAUSE)

EXAMPLE = AVG(Sales) OVER (PARTITION BY Category ORDER BY (DESC/ASC/OrderDate) ROWS UNBOUNDED PRECEDING )

AGGREGATE FUNCTION -> EXPRESSION :- {COUNT() accepts all data type agruments 
                                     ALL OTHER only accepts the numeric type }
                      PARTITON CLAUSE :- { OPTIONAL }

RANK FUNCTION -> EXPRESSION :- {NTILE() accepts numeric type 
                               ALL OTHER no need to put arguments / can stay empty }
                 PARTITON CLAUSE :- { OPTIONAL }

VALUE (ANALYTICS ) FUNCTION -> EXPRESSION :- { ALL accepts all data types values }
                               PARTITON CLAUSE :- { OPTIONAL }

------------------------------------------------------------------------------------------------------------------------------

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