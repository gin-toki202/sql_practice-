/*
SQL DATE & TIME FUNCTION 
 
DATE = 2025-08-20 , YEAR-MONTH-DAY
TIME = 18:55:45   , HOURS : MINUTES : SECONDS

--> WHEN YOU PLACE THEM SIDE BY SIDE WE GET A NEW STRUCTURE CALLED TIMESTAMP
--> AND IN SQL SERVER IT IS CALLED DATETIME

TIMESTAMP = 2025-08-20 18:55:45
*/

SELECT 
OrderID,                             -- dtype - date
OrderDate,                           -- dtype - date
ShipDate,                            -- dtype - date
CreationTime                         -- dtype - datetime
FROM Sales.Orders
---------------------------------------------------------------------------------------------------------------------------------
/*
SQL CAN OBTAIN THE CURRENT DATE AND TIME FROM THREE DIFFERENT PLACES
   1. DATES THAT STORED IN THE TABLE .
   2. HARDCODED CONSTANT STRING VALUE  .
   3. GETDATE() FUNCTION - RETURNS THE CURRENT DATE AND TIME WHEN THE QUERY IS EXECUTED .
   */

-- HARCODED DATE 
SELECT 
OrderID,                             
CreationTime ,
'2026-04-07' HARCODED_DATE
FROM Sales.Orders

-- GETDATE() FUCNTION DATE 
SELECT 
OrderID,                             
CreationTime ,
'2026-04-07' HARCODED_DATE,
GETDATE() TODAY
FROM Sales.Orders

--===========================================================================================================================================
/*
--> DATETIME MANIPUATION (DATE & TIME FUCNTION )
--> TYPE 1. [PART EXTRACTION] = DAY
                                MONTH
                                YEAR
                                DATEPART
                                DATENAME
                                DATATRUNC
                                EOMONTH
*/

-- DAY() - RETURNS THE DAY FROM THE TABLE.
-- MONTH() - RETURNS THE MONTH FROM A TABLE 
-- YEAR() - RETURNS THE YEAR FROM A DATE 
SELECT 
OrderID, 
CreationTime,
DAY(CreationTime) AS day,
MONTH (CreationTime) AS month,
YEAR(CreationTime) AS year
FROM Sales.Orders
------------------------------------------------------------------------------------------------------------------------------------------

-- DATEPART() - RETURNS THE SPECIFIC PART(DAY,MONTH,YEAR,WEEK,QUARTER,etc) OF THE AS A NUMBER ALL HAVE INT VLAUE .
-- SYNTAX = DATEPART(PART,DATE)   

SELECT 
OrderID, 
CreationTime,
DATEPART(day,CreationTime) AS day_DP,
DATEPART(month,CreationTime) AS month_DP,
DATEPART(year,CreationTime) AS year_DP,
DATEPART(hour,CreationTime) AS hour_DP,
DATEPART(minute,CreationTime) AS minute_DP,
DATEPART(second,CreationTime) AS second_DP,
DATEPART(week,CreationTime) AS week_DP,
DATEPART(QUARTER,CreationTime) AS quarter_DP
FROM Sales.Orders

------------------------------------------------------------------------------------------------------------------------------------------

-- DATENAME() - RETURNS THE NAME OF A SPECIFIC PART(DAY,MONTH,YEAR,WEEK,QUARTER,etc) OF A DATE ALL WILL BE STRING  .
-- SYNTAX = DATENAME(PART,DATE)  
-- FOR THE YEAR , HOUR , MINUTE ,SECONDS PART YOU WILL GET NUMBER BUT IN STRING DTYPE FORMAT 

SELECT 
OrderID,
CreationTime,
DATENAME(YEAR,CreationTime) YEAR_DN,
DATENAME(MONTH,CreationTime) MONTH_DN,
DATENAME(weekday,CreationTime) WEEKDAY_DN
FROM Sales.Orders

------------------------------------------------------------------------------------------------------------------------------------------

-- DATETRUNC() - TRUNCATES/RESET THE DATE TO THE SPECIFIC PART 
-- SYNTAX = DATENAME(PART,DATE)
/*
original datetime = 2025-08-20 18:55:45

DATETRUNC(minutes,date) = 2025-08-20 18:55:00          -- reset the seconds 
DATETRUNC(hour,date) = 2025-08-20 18:00:00          -- reset the minutes
DATETRUNC(day,date) = 2025-08-20 00:00:00          -- reset the hours
DATETRUNC(month,date) = 2025-08-01 18:00:00          -- reset the day to day 1 not zero 
DATETRUNC(year,date) = 2025-01-20 18:55:00          -- reset the month to month 1 not zero 
*/

SELECT 
OrderID,
CreationTime,
DATETRUNC(minute,CreationTime) MINUTE_DT,
DATETRUNC(hour,CreationTime) HOUR_DN,
DATETRUNC(day,CreationTime) day_DN,
DATETRUNC(MONTH,CreationTime) MONTH_DN,
DATETRUNC(year,CreationTime) YEAR_DN
FROM Sales.Orders

-- BENEFIT OF DATATRUNC

-- COUNTING THE NUMBER OF ORDER PER MONTH USING DATETRUNC
SELECT 
DATETRUNC(MONTH,CreationTime),
COUNT(*) ORDER_PLACED
FROM Sales.Orders
GROUP BY DATETRUNC(MONTH,CreationTime)

-- COUNTING THE NUMBER OF ORDER PER YEAR USING DATETRUNC
SELECT 
DATETRUNC(YEAR,CreationTime),
COUNT(*) ORDER_PLACED
FROM Sales.Orders
GROUP BY DATETRUNC(YEAR,CreationTime)

------------------------------------------------------------------------------------------------------------------------------------------

-- EOMONTH() - RETURNS THE LAST DAY OF THE MONTH.
-- FOR FIRST DAY OF THE MONTH USE DATATRUNC(MONTH,DATE)
-- SYNTAX = EOMONTH(DATE)
SELECT 
'2025-08-09' AS DATE ,
EOMONTH('2025-08-09') AS END_MONTH_DATE

SELECT 
CreationTime,
EOMONTH(CreationTime) AS END_MONTH_DATE,
CAST(DATETRUNC(MONTH,CreationTime) AS DATE) AS START_MONTH_DATE         -- CAST TO CHANGE THE DTYPE AND ONLY SEEING THE DATE NOT HOUR/MINUTE/SECONDS
FROM Sales.Orders

------------------------------------------------------------------------------------------------------------------------------------------
 /*
-- USE CASE 
-- WHY DO WE NEED TO EXTRACT THOSE PARTS FROM THE DATES ?
   -- > USE CASE 1. = DATA AGGREGATION AND REPORTING (REPORT SHOWING SALES BY MONTH/YEAR AND SO ON)
   -- > USE CASE 2. = DATE FILTERING ( always use integer for filtering the data)
   -- > USE CASE 3. = FUNCTION COMPARISON  DAY MONTH YEAR DATEPART -> INT
                                           DATENAME                -> STRING
                                           DATETRUNC               -> DATETIME
                                           EOMONTH                 -> DATE
   */

-- HOW MANY ORDERS WERE PLACED EACH MONTH (USE CASE - 1)
SELECT 
MONTH(OrderDate) ORDERED_MONTH,               -- use datename() for month name
COUNT(*) NUMBER_OF_ORDERS
FROM Sales.Orders
GROUP BY MONTH(OrderDate)

-- SHOW ALL ORDER THAT WERE PLACED DURING THE MONTH OF FEBURARY
SELECT *
FROM Sales.Orders
WHERE MONTH(OrderDate) = 2

--------------------------------------------------------------------------------------------------------------------------------

-- WHEN TO USE THESE PART EXTRACTER ?
 /*
 PART --> DAY,MONTH? --> NUMERIC? --> DAY() , MONTH()
 | |            |
 | |            ------> FULL NAME --> DATENAME()       
 | |
 | YEAR? --> YEAR()
 |
 |----------OTHER PARTS? --> DATEPART()