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
 */
 --==============================================================================================================================
 
 /*
 Datetime = 2025-08-20 18:55:45
            year = yyyy
            month = MM
            day = dd
            hour = HH
            minutes = mm
            seconds = ss

WAYS OF PRESENTING DATES :- {sql server follows the international standard}
                          1.  INTERNATIONAL STANDARD (ISO 8601) -> yyyy-MM-dd
                          2.  USA STANDARD                      -> MM-dd-yyyy
                          3.  EUROPEAN STANDARD                 -> dd-MM-yyyy

 TYPE 2. [FORMATING & CASTING] = FORMAT
                             CAST
                             CONVERT
*/

----------------------------------------------------------------------------------------------------------------------------------------------

/*
[FORMATTING] - CHANGING THE FORMAT OF A VALUE FROM ONE TO ANOTHER
             - We are just changing the how the value looks like.

FOR DATE :-
  DATE -> FORMAT (dd-MM-yyyy) = resultant new format date 
FOR NUMBER :- 
     |--------------> (N) -> number seperated by comma eg- 1,234,567.89
  NUMBER -> FORMAT -> (C) -> $ number
     |--------------> (P) -> number % sign

SYNTAX = FORMAT(vlaue,format,culture(optional)) {culture eg - ja -JP}
by deafult it takes en-US culture .
*/

SELECT 
CreationTime ,
FORMAT(CreationTime,'dd') AS dd,
FORMAT(CreationTime,'MM') AS MM,
FORMAT(CreationTime,'yyyy') AS yyyy,
FORMAT(CreationTime,'HH') AS HH,
FORMAT(CreationTime,'mm') AS mm,
FORMAT(CreationTime,'ss') AS ss,
FORMAT(CreationTime,'dd-MM-yyyy') AS european_style,
FORMAT(CreationTime,'MM-dd-yyyy') AS Usa_style,
FORMAT(CreationTime,'yyyy-MM-dd') AS international_style
FROM Sales.Orders

-- getting  the abreviated day,month
SELECT 
CreationTime ,
FORMAT(CreationTime,'ddd') AS ab_day,
FORMAT(CreationTime,'dddd') AS full_day,
FORMAT(CreationTime,'MMM') AS ab_month,
FORMAT(CreationTime,'MMMM') AS full_month,
FORMAT(CreationTime,'yyyy') AS yyyy,
FORMAT(CreationTime,'dddd ')+ FORMAT(CreationTime,'MMMM ')+FORMAT(CreationTime,'yyyy') customized_date
FROM Sales.Orders

-- Show creationtime using the following format
-- Day Wed Jan Q1 2025 12:34:56 PM
SELECT 
CreationTime,
'DAY '+FORMAT(CreationTime,'ddd')+' '+FORMAT(CreationTime,'MMM ')+'Q'
+DATENAME(quarter,CreationTime)+' '+FORMAT(CreationTime,'yyyy ')+FORMAT(CreationTime,'HH:mm:ss')
+' '+FORMAT(CreationTime,'tt')  customized_date
FROM Sales.Orders

/*
USE CASE OF FORMATING - 
                     -> FORMATING THE DATE BEFORE DATA AGGREGATION
                     -> DATA STANDARDIZATION = WHEN DATA IS COLLECTED FROM DIFFERENT SOURCE 
                        DATES ARE NOT ALWAYS IN THE SAME STANDARD FORMAT SO YOU HAVE TO CLEAN IT MEANING BRING ALL THE 
                        DATES TO ONE FORMAT 
IT IS LIKE PART EXTRACTION BUT WE HAVE MORE CUSTOMIZATION OPTION ON HOW WE CHOOSE TO SHOW THE DATE 
*/

SELECT 
FORMAT(OrderDate,'MMM yy') AS ORDER_DATE,
COUNT(*)
FROM Sales.Orders
GROUP BY FORMAT(OrderDate,'MMM yy')

----------------------------------------------------------------------------------------------------------------------------------------------------------
/*
[CONVERT] - Converts a date or time value to a different data type & formats the value 

SYNTAX :- CONVERT(data_type,value,style(optional))   by default the style is 0

Example :- CONVERT (INT,'124') = CONVERT THE DATATYPE OF STRING '124' TO INTEGER 
           CONVERT (VARCHAR,OrderDate,'34') = CONVERT THE DATATYPE OF ORDERDATE TO VARCHAR USING STYLE 34
*/

SELECT 
CONVERT(INT,'123') AS [string to int],
CONVERT (DATE,'2025-02-01') AS [string to date],
CreationTime,
CONVERT(DATE , CreationTime) AS [datetime to date],
-- CHANGING IT INTO USA STYLE 
CONVERT(VARCHAR , CreationTime,32) AS [USA STD STYLE STYLE : 32],
CONVERT(VARCHAR, CreationTime,34) AS [EUROPEAN STD STYLE : 34]
FROM Sales.Orders

-----------------------------------------------------------------------------------------------------------------------------
/*
[CAST] - CONVERTS ONE DATATYPE TO ANOTHER 
SYNTAX = CAST(VALUES AS DATA_TYPE)

EXAMPLE - CAST('123' AS INT)
*/
SELECT 
CAST('123' AS INT) AS INT_VALUE,
CAST('2025-02-22' AS DATE) AS [string to date],
CAST('2025-02-22' AS DATETIME) AS [string to datetime]
,CreationTime,
CAST(CreationTime AS DATE) AS [datetime to date]
FROM Sales.Orders

-------------------------------------------------------------------------------------------------------------------
/*
              [CASTING]           |      [FORMATING]
----------------------------------------------------------------------|
CAST    | ANY TYPE TO ANYTYPE     |   NO FORMATING                    |
CONVERT | ANY TYPE TO ANYTYPE     |   FORMATES ONLY DATE AND TIME     |
FORMAT  | ANY TYPE TO ONLY STRING |   FORMATES DATE&TIME AND NUMBERS  | 
*/

--=====================================================================================================================================================

/*
TYPE 3. [DATE CALCULATION] = DATEADD()
                             DATEDIFF()
*/
-----------------------------------------------------------------------------------------------------------------------------------------------

/*
DATEADD() -> ADD OR SUBTRACT SPECIFIC TIME INTERVAL TO/FROM A DATE.

SYNTAX :- DATEADD(PART,INTERVAL,DATE)

FOR EXAMPLE :-

DATE (2025-08-20) => +3 YEAR => 2028-08-20
DATE (2025-08-20) => -3 YEAR => 2022-08-20
DATE (2025-08-20) => +3 MONTH => 2025-11-20
DATE (2025-08-20) => -3 MONTH => 2025-05-20
DATE (2025-08-20) => +3 DAY => 2025-08-23
DATE (2025-08-20) => -3 DAY => 2028-08-17
*/
SELECT 
OrderID,
OrderDate,
DATEADD(YEAR , 3 , OrderDate) AS ThreeYearsLater,
DATEADD(YEAR,-3,OrderDate) AS ThreeYearsBefore,
DATEADD(MONTH , 3 , OrderDate) AS ThreeMonthLater,
DATEADD(MONTH,-3,OrderDate) AS ThreeMonthBefore,
DATEADD(DAY , 3 , OrderDate) AS ThreeDaysLater,
DATEADD(DAY,-3,OrderDate) AS ThreeDaysBefore
FROM Sales.Orders
---------------------------------------------------------------------------------------------------------------------------------------
/*
DATEDIFF() -> FIND THE DIFFERENCE BETWEEN THE TWO DATES 

SYNTAX:- DATEFIFF(PART,START_DATE,END_DATE)

FOR EXAMPLE :
START_DATE(2025-08-12) -- DIFF(YEAR) ----END_DATE(2026-08-12)  ===> 1 YEAR
START_DATE(2025-08-12) -- DIFF(MONTH) ----END_DATE(2026-08-12)  ===> 12 MONTH
START_DATE(2025-08-12) -- DIFF(DAYS) ----END_DATE(2025-08-20)  ===> 8 DAYS

*/
SELECT 
'2025-08-12' AS START_DATE , 
'2026-09-14' AS END_DATE,
DATEDIFF(YEAR,'2025-08-12','2026-09-14') AS YEAR_DIFF,
DATEDIFF(MONTH,'2025-08-12','2026-09-14') AS MONTH_DIFF,
DATEDIFF(DAY,'2025-08-12','2026-09-14') AS DAY_DIFF
UNION 
SELECT 
'2026-09-20',
'2032-12-14' ,
DATEDIFF(YEAR,'2026-09-20','2032-12-14') ,
DATEDIFF(MONTH,'2026-09-20','2032-12-14') ,
DATEDIFF(DAY,'2026-09-20','2032-12-14') 
UNION
SELECT 
'2027-06-12' ,
'2030-09-25',
DATEDIFF(YEAR,'2027-06-12','2030-09-25') ,
DATEDIFF(MONTH,'2027-06-12','2030-09-25') ,
DATEDIFF(DAY,'2027-06-12','2030-09-25') 

-- CALCULATE THE AGE OF THE EMPLOYEE 
SELECT 
EmployeeID,
FirstName,
DATEDIFF(YEAR,BirthDate,GETDATE()) AS AGE
FROM Sales.Employees
 
 -- FIND THE AVERAGE SHIPPING DURATION IN DAYS FOR EACH MONTH 

 SELECT
 MONTH(OrderDate) AS OrderDate,
 AVG(DATEDIFF(DAY,OrderDate,ShipDate)) AS AVG_Order_Recieved_DURATION
 FROM Sales.Orders
 GROUP BY  MONTH(OrderDate)

 -- TIME GAP ANALYSIS 
 -- FIND THE NUMBER OF DAYS BETWEEN EACH ORDER AND THE PREVIOUS ORDER 
 -- LAG() = IS A WINDOW FUNCTION ACCESS A VALUE FROM THE PREVIOUS ROW ,
 -- SUPPOSE ROW 1(ORDER DATE) = 2025-01-01 BECOMES ROW 2(PREVIOUS DATE) = 2025-01-01

 SELECT 
 OrderID,
 OrderDate AS Current_Orderdate,
 LAG(OrderDate) OVER (ORDER BY OrderDate) AS PREVIOUS_DATE,
 --ORDER BY OrderDate, SQL rows ko date ke sequence me arrange karega aur phir har row ke liye uske pehle wali date nikal dega.
 DATEDIFF(DAY,LAG(OrderDate) OVER (ORDER BY OrderDate),OrderDate ) AS NumOfDays
 FROM Sales.Orders

--=====================================================================================================================================================

/*
TYPE 4. [VALIDATION] = ISDATE()

*/
-----------------------------------------------------------------------------------------------------------------------------------------------
/*
ISDATE() -> CHECK IF A VALUE IS A DATE 
            RETURN 1 IF THE STRING IS A VALID DATE 

SYNTAX:- ISDATE(VALUE)


*/
-------------------------------------------------------------------------------------------------------------------------------------------------

-- checking the date validity 

SELECT 
'123' AS date,
ISDATE('123')    AS date_check        -- ZERO BECAUSE IT IS NOT A DATE 
UNION
SELECT 
'2025-12-02',
ISDATE('2025-12-02')      -- ONE BECAUSE IT IS DATE 
UNION
SELECT 
'12-02-2025',
ISDATE('12-02-2025')
UNION
SELECT 
'2025',
ISDATE('2025')               -- it is a date to sql , considering how it could denote year then yes
UNION
SELECT 
'08',
ISDATE('08')                 -- doesn't recognise month as a date 

/* WE ARE CONVERTING STRING TO DATE , BUT SOME DATE CAN'T BE CONVERTED BECAUSE THEY AREN'T ACTUALLY DATE ,SO WE USE 
THE ISDATE() FUNCTION TO CHECK FOR THE VALID DATE AND USE THE CASE WHEN FUNCTION SO CASTING CAN ONLY BE DONE TO ONLY VALID DATES  */

SELECT
  -- CAST(OrderDate AS DATE) OrderDate
  OrderDate,
  ISDATE(OrderDate) AS DATE_CHECK,            -- WE GOT THAT 2025-08 IS NOT A VALID DATE 
  CASE WHEN ISDATE(OrderDate) = 1 THEN CAST(OrderDate AS DATE)
  END NEWOrderDate
FROM
(
   SELECT '2025-08-20' AS OrderDate UNION
   SELECT '2025-08-21' UNION
   SELECT '2025-08-23' UNION
   SELECT '2025-08' 
)t
-- use for data quality check 
-- seeing the corrupted data 
--WHERE ISDATE(OrderDate) = 0            UNCOMMENT IT TO USE 

/*
Yaha (SELECT ... UNION ...) ek derived table banata hai.
Us derived table ka naam tumne t rakha hai.
Matlab: t ek temporary table hai jisme tumhare UNION ke results store hote hain
*/

