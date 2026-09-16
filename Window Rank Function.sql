/*
Window Rank Function 

1. The first step of ranking the data is sorting it in proper order , either ascending or descending.
2. Two Method of Ranking 
   A. --> Integer based Ranking {Discrete Values}
          Used for Top/Bottom N analysis like ( Find Top 3 Products )
          < Gives a person/item a whole-number position compared with others.
          Common SQL functions:
            RANK()
            DENSE_RANK()
            ROW_NUMBER()
            NTILE()>

   B. --> Percentage based Ranking {Continous Values}
          Normally used for distribution analysis like ( Find Top 20% products )
         < Tells you how you perform relative to the rest of the data as a percentage
         If you're at the 90th percentile, it roughly means:
         You performed better than about 90% of the people/items in the dataset.
         Common SQL function:
           PERCENT_RANK()
           CUME_DIST()

------------------------------------------------------------------------------------------------------------------------------------------

SYNTAX 

FUNCTION () OVER ( PARTITION BY CATEGORY ORDER BY CATEGORY )

NOTE : 
     1. Funtion () -> must stay empty .
     2. Partition by -> Optional 
     3. Order by -> Required , it is a must .
     4. Frame -> it is not allowed 


-------------------------------------------------------------------------------------------------------------------------------------------

Funtion - 1
ROW_NUMBER() :- Assign a unique number to each row 
                It does not handle ties 
                There are no gaps/ no skipping of ranks
                Same value don't have the same rank
*/

--Rank the order based on their sale from highest to lowest 
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row
FROM Sales.Orders

-----------------------------------------------------
/*
USE CASE OF ROW_NUMBER() FUNCTION 

FIRST 1 :- TOP N ANALYSIS 
*/
-- Find the top  highest sales for each product 
SELECT *
FROM (
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) RankByProduct
FROM  Sales.Orders)t
WHERE RankByProduct = 1

--------------------------------------------------------
/*
USE CASE OF ROW_NUMBER() FUNCTION 

SECOND 2 :- BOTTOM N ANALYSIS 
It helps identify the worst-performing items so we can manage risks and improve performance
*/

-- Find the lowest 2 customers based on their total sales 
SELECT *
FROM (
SELECT 
CustomerID,
SUM(Sales) TotalSales,
ROW_NUMBER() OVER(ORDER BY SUM(Sales)) RankCustomers        --  COLUMNS USED IN GROUP BY MUST ALSO BE USED IN THE WINDOW FUNCTION FOR IT TO PROPERLY WORK
FROM Sales.Orders
GROUP BY CustomerID
)t WHERE RankCustomers <=2


---------------------------------------------------------
/*
USE CASE OF ROW_NUMBER() FUNCTION 

THIRD 3 :- 
Generate Unique IDs
It assigns a unique number to each row, making it easier 
to divide the data into pages and joining tables.
*/
-- Assign unique ID to the rows of the orders archieve table
SELECT 
ROW_NUMBER() OVER(ORDER BY OrderID,OrderDate) UniqueID,
*
FROM Sales.OrdersArchive

---------------------------------------------------------
/*
USE CASE OF ROW_NUMBER() FUNCTION 

Fourth 4 :- 
Identify Duplicates 
Identify and remove duplicate rows to improve data quality
*/
-- Identify duplicates rows in the table Orders Archieve
-- and return a clean result without any duplicates 

SELECT * 
FROM (
SELECT 
ROW_NUMBER() OVER( PARTITION  BY OrderID ORDER BY CreationTime DESC) rn,
*
FROM Sales.OrdersArchive     -- jahan order id repeat ho rhi hai uska creation time bhi repeat ho rha hoga 
)t WHERE rn = 1                             -- ek id ke agar do creation time hai to hum most recent wale ko rank 1 and dusre wale ko rank 2 denge and so on 
                             -- phir filter use karke keval rank 1 walon ko nikal lenge /ISSE duplicate ids hat jayegi 



------------------------------------------------------------------------------------------------------------------------
/*
Funtion - 2 
RANK() :- Assign a rank to each row.
          It handles ties.
          It leaves gaps in ranking.
*/

--Rank the order based on their sale from highest to lowest 
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row,
RANK() OVER ( ORDER BY Sales DESC) SalesRank_Rank
FROM Sales.Orders

------------------------------------------------------------------------------------------------------------------------
/*
Funtion - 3
DENSE_RANK() :- Assign a rank to each row.
          It handles ties.
          It does not leaves gaps in ranking.
*/

--Rank the order based on their sale from highest to lowest 
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row,
RANK()       OVER (ORDER BY Sales DESC) SalesRank_Rank,
DENSE_RANK() OVER (ORDER BY Sales DESC) SalesRank_Dense
FROM Sales.Orders

-----------------------------------------------------------------------------------------------------------------------------------
/*
Function - 4 
NTILE () :- Divides the rows in a table into equal number of buckets 
            Bucket size = No of Rows / No of buckets(mentioned in NTILE())
            In case of odd number of bucket size the top bucket has the highest bucket size 
            Also R/N = quotient (minimum no of rows in each bucket) and remainder (number of bucket that gets extra rows)
            Ex :- 13/5 = 2 remainder 3 
            3,3,3,2,2
            Every bucket has atleast 2 rows and 3 buckets have one extra rows 
*/

-- General Example 
SELECT 
OrderID,
Sales,
NTILE(1) OVER(ORDER BY Sales DESC) OneBucket,
NTILE(2) OVER(ORDER BY Sales DESC) TwoBucket,
NTILE(3) OVER(ORDER BY Sales DESC) ThreeBucket,     -- As seen the top bucket has 4 rows and the rest buckets has 3 rows 
NTILE(6) OVER(ORDER BY Sales DESC) SixBucket        -- 10/6 = 1 remainder 4 , meaning 4 buckets will hav 2 rows and 2 buckets will have  rows 
FROM Sales.Orders

-------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE 1 {FROM Data Analyst POV}
Data Segmentation :- Data segmentation means dividing a large set of data into meaningful groups 
                     based on a specific characteristic.

                     Spending	Segment
A	                 ₹90,000	High Value
B	                 ₹75,000	High Value
C	                 ₹30,000	Medium Value
D	                 ₹5,000	Low Value
*/

--Segment all orders into 3 categories : high medium and low sales 
SELECT 
*,
CASE WHEN Buckets = 1 THEN 'High'
     WHEN Buckets = 2 THEN 'Medium'
     WHEN Buckets = 3 THEN 'Low'
END SalesEngagement 
FROM 
(
SELECT 
OrderID ,
Sales,
NTILE(3) OVER (ORDER BY Sales DESC) Buckets 
FROM Sales.Orders
)t

--------------------------------------------------------------------------------------------
/*
USE CASE 2 {From Data Engineer POV}
EQUALIZING LOADS :- When data is too big to send from one database to another in one go ,it is divided into 
                    buckets so that even if one buckets is lost we don't have to resend the whole data just that bucket .

*/

-- In order to export the date ,  divide the order into 2 groups 
SELECT 
NTILE(2) OVER(ORDER BY  OrderID) Buckets,     --
*
FROM Sales.Orders

--------------------------------------------------------------------------------------------------------------------------------------------------------
/*
Function - 5
PERCENT_RANK() :- Ye dataset mein kisi row ki relative rank batata hai , basically ye batata hai ki 
                   koi specific row poore dataset ke scale par yaani 0 se 1 ke beech percentile position mein kahan stand karegi

Formula :- percent_rank = Rank - 1/Total Rows - 1
Ties :- jo pehle row tie wala hoga usi ke rank use karna baar baar for every similar tie position to get the same rank 

USE CASE :
PERCENT_RANK() → Find relative position

Use it when you want to know where a particular row stands compared with the other rows.

Example:
“This customer is at roughly what position in terms of spending?”
If a customer has PERCENT_RANK = 0.75, they are relatively high in the ranking.

Typical use cases:   Customer performance ranking
                     Employee salary comparison
                     Product performance
                     Finding relative position in a dataset
*/

-- Find the products that falls within the highest 40% of the prices 
SELECT 
*,
CONCAT(DistRank * 100 , '%' ) DistRankPerc
FROM(
SELECT 
Product,
Price,
PERCENT_RANK() OVER (ORDER BY Price DESC ) DistRank
FROM Sales.Products)t
WHERE DistRank <= 0.4

/*
Yeh query basically aapko top 40% sabse mehnge 
products (highest price wale products) nikal kar 
deti hai, sath hi unki relative percentage position 
bhi calculate karke deti hai.
*/


-------------------------------------------------------------------------------------------------------------------------------------------
/*
Function - 6 
CUME_DIST() :- SQL ka ek window function hai jo yeh batata hai ki ek specific row ki value ke equal ya usse kam/pehle kitna data cover 
                ho chuka hai.Yeh dataset ke andar ek particular value ki cumulative position percentage mein nikalta hai.

Formula = Number of rows with value <= current row's  value / total number of rows in result or partition set

EXAMPLE :- ROW 1 = 20k   {Current value ya usse kam kitni rows hain = 1 that is 20k wali row}                  1/3 = 0.33
           ROW 2 = 40k   {Current value ya usse kam kitni rows hain = 2 that is 20K wali row + 40k wali row}   2/3 = 0.66
           ROW 3 = 60K   {Current value ya usse kam kitni rows hain = 3 that is 20k + 40k + 60k}               3/3 = 1

USE CASE :
CUME_DIST() → Find percentage of data reached

Use it when you want to know what percentage of rows have reached or are below/above a particular value, depending on the sort direction.
Example:
“What percentage of customers spend ₹50,000 or less?”

If the answer is CUME_DIST = 0.70, it means 70% of the rows are at or below that point when ordered ascending.
Typical use cases: Understanding data distribution
                   Finding how a value compares with the population
                   Customer spending distribution
                   Salary distribution
                   Identifying percentile-like thresholds
*/

-- Find the products that falls within the highest 40% of the prices 
-- ALSO ADDING THE PERCENTAGE SIGN 

SELECT 
*,
CONCAT(DistRank * 100 , '%' ) DistRankPerc
FROM(
SELECT 
Product,
Price,
CUME_DIST() OVER (ORDER BY Price DESC ) DistRank
FROM Sales.Products)t
WHERE DistRank <= 0.4