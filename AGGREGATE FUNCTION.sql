-- AGGREGATE FUNCTION 
/*
COUNT(*) :- COUNTS THE NUMBER OF THE ROWS 

SUM() :- SUMMARIZE THE SALES AND BRING OUT THE TOTAL SALES

AVG() :- CALCULATES THE AVERAGE OF THE GIVEN DATA

MAX () :- IT FINDS THE HIGHEST SCORE IN THE GIVEN DATA VALUES 

MIN() :- IT FINDS THE LOWEST SCORE IN THE GIEN DATA VALUES 

*/
---------------------------------------------------------------------------------------------------------------------------
 USE SalesDB
 
-- COUNTING THE TOTAL NUMBER OF ROWS
SELECT 
COUNT(*) AS TOTAL_NUM_OF_SALES
FROM Sales.Orders


----------------------------------------------------------------------------------------------------------------------------

-- FIND THE SCORE TOTAL SALES OF ALL ORDERS 
SELECT 
SUM(Sales) AS tOtal_scores
FROM Sales.Orders

---------------------------------------------------------------------------------------------------------------------------

-- FIND THE AVERAGE SALES OF ALL ORDERS 

SELECT 
Sales,
AVG(Sales) OVER() AS AVG_SALES
FROM Sales.Orders

----------------------------------------------------------------------------------------------------------------------------

-- FIND THE HIGHEST SALES OF ALL ORDERS 

SELECT 
MAX(Sales) AS HIGHEST_SALE
FROM Sales.Orders

----------------------------------------------------------------------------------------------------------------------------

-- FIND THE LOWEST SALES OF ALL ORDERS

SELECT 
MIN(Sales) AS LOWEST_SALE
FROM Sales.Orders

-----------------------------------------------------------------------------------------

/*
when you use the "group by" along with agg function 
you are breaking these big number into smaller numbers 
basically har group mein ye function apply karke result return karte hain 
*/

SELECT 
CustomerID,
COUNT(*) AS Row_count,
SUM(Sales) AS Total_sales,
AVG(Sales) AS Average_sales,
MAX(Sales) AS Highest_sale,
MIN(Sales) AS Lowest_sale
FROM Sales.Orders
GROUP BY CustomerID