/*
Window Value Function :- it is used for accessing the value either from the next or the previous row ,especially for comparison 

Funtions :- LAG()
            LEAD()
            LAST_VALUE()
            FIRST_VALUE()

*/
------------------------------------------------------------------------------------------------------------------------------------------------------
/*
LEAD / LAG FUNCTION 

LAG() :- looks at the previous row 

LEAD() :- looks at the next row

SYNTAX :- 
LEAD/LAG (Sales , OFFSET VALUE{OPTIONAL} , DEFAULT VALUE{OPTIONAL}) OVER(PARTITION BY ProductID ORDER BY OrderDate)

OFFSET VALUE :- Kitna aange ya peeche ke value access karna hai, by default it is one 
DEAFULT VALUE :- In case pehle koi value nhi h to by deafult NULL return karne ke sevaye koi value return karega 
PARTITION BY :- OPTIONAL 
ORDER BY :- Required
-------------------------------------------------------------------------------------------------------------------------------------------------------

USE CASE 1 :- MONTH OVER MONTH ANALYSIS / YEAR OVER YEAR ANALYSIS

Meaning :- Ek month/year ki performance ko previous month/year ki performance se compare karna

Formula = (current month - previous month / previous month )*100
Confusion  :- hum previous month se iseliye divide karte hain taaki dekh sanke uski growth kitni hue h previous wale month ke relative 
              EX :- 0.20 itna times previous month ki sales se jayda hua h
*/

-- Analyze the month over month performance by finding the percentage change in sales between the current and previous month

SELECT 
*,
CurrentMonth_Sales - PreviousMonth_Sales AS MoM_Change,
ROUND(CAST((CurrentMonth_Sales - PreviousMonth_Sales) AS FLOAT)/PreviousMonth_Sales*100,2) AS MoM_ChangePercentage
FROM (
SELECT 
MONTH(OrderDate) AS Month_num ,
SUM(Sales) AS CurrentMonth_Sales,
LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) PreviousMonth_Sales             -- LAG() ye function group by ke result par kaam kar rhe hai 
FROM Sales.Orders
GROUP BY (MONTH(OrderDate)))t

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE 1 :- Customer retention ka matlab hai:

Customers kitne time tak company ke saath bane rehte hain aur kitne customers dobara purchase karte hain.

Customer Retention Analysis mein hum data analyze karke ye samajhte hain:

Customers dobara purchase kar rahe hain ya nahi?
Kitne customers company ke saath continue kar rahe hain?
Kitne customers chhod rahe hain (churn)?
Customers usually kitne time baad wapas aate hain?
Kaunse customers long-term hain?
*/

-- In order to analyze customer loyalty 
-- Rank customers based on the average days bewteen their orders 
SELECT
CustomerID,
AVG(GapsBetweenPurchase) AverageGapsBetweenPurchase,
RANK() OVER(ORDER BY COALESCE(AVG(GapsBetweenPurchase),999) ) Ranking
FROM(
SELECT 
OrderID,
CustomerID,
OrderDate CurrentDate,
LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) NextDate,
DATEDIFF(DAY , OrderDate ,LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) GapsBetweenPurchase
FROM Sales.Orders)t
GROUP BY (CustomerID)

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Funtion 

FIRST_VALUE :- Access a value from the first row within a window 
LAST_VALUE :- Access a value from the last row within  a window 

By deafult the frame is :- RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW 
*/

-- USE CASE :- FIND THE EXTREMES VALUES 
-- Find the lowest and highest sales for each product 
SELECT
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales0,
LAST_VALUE (Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales1,
FIRST_VALUE (Sales) OVER (PARTITION BY ProductID ORDER BY Sales DESC) HighestSales2,
LAST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC 
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING ) LowestValue1, 
MAX(Sales) OVER (PARTITION BY ProductID ) MaxSales,       -- or use the min max function
MIN(Sales) OVER (PARTITION BY ProductID ORDER BY Sales) MinSales
FROM Sales.Orders

/*
iseliye with MAX() order by ASC use nhi kiya 
Running maximum:

10 → 10
20 → 20
90 → 90
Yahan maximum har step par badh raha hai, isliye har row mein overall maximum 90 nahi aa raha.
*/


-- USE CASE :- Comparison Analysis
-- Find the differences in sales between the current and the lowest sales 
SELECT
OrderID,
ProductID,
Sales,
FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales) LowestSales0,
LAST_VALUE (Sales) OVER(PARTITION BY ProductID ORDER BY Sales 
RANGE BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) HighestSales1,
Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales)  SalesDiff
FROM Sales.Orders