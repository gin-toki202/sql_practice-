/*
CASE STATEMENT :- EVALUATES A LIST OF CONDITIONS AND RETURN A VALUE  WHEN THE FIRST CONDITION IS MET 

SYNTAX :

CASE [ START OF LOGIC ]

     WHEN condition [CONDITION TO BE EVALUATED]  THEN result [ RESULT IF THE CONDITION IS TRUE ]
     WHEN condition [CONDITION TO BE EVALUATED]  THEN result [ RESULT IF THE CONDITION IS TRUE ]
     WHEN condition [CONDITION TO BE EVALUATED]  THEN result [ RESULT IF THE CONDITION IS TRUE ]

     ELSE result [ DEFAULT VALUE (OPTIONAL) USE IT OR SKIP IT 

END [ THE END OF THE LOGIC ] 

NOTE :

IF THE ELSE IS NOT PROVIDED AND THE CONDITION ISN'T SATISFIED THEN WE GET THE RESULT AS NULL.

*/
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE CASE -> 1 -> GROUP THE DATE INTO DIFFERENT CATEGORIES BASED ON CERTAIN CONDITONS 
-- [ classifying and grouping data is fundamental in data analyzing and reporting because it makes the data easier to understand and as well to track ]

-- QUERY 1
/* GENERATE A REPORT SHOWING THE TOTAL SALES OF EACH CATEGORY :
        - HIGH IF THE SALES HIGHER THAN 50
        - MEDIUM IF THE SALES BETWEEN 20 AND 50
        - LOW IF THE SALES EQUAL OR LOWER THAN 20
  AND SORT THE CATEGORY FROM HIGHEST TO LOWEST 

sabse pehle mapping (value replace by high,medium and low) then grouping and then sorting
using the sub-query to aggregate and grouping the data .
 */

SELECT
Category,
SUM(Sales) AS TotalSales
FROM (SELECT 
OrderID,
Sales,
CASE 
    WHEN Sales > 50 THEN 'High' 
    WHEN Sales >20 THEN 'Medium'
    WHEN SALES <= 20 THEN 'Low'
END AS Category
FROM Sales.Orders)t                                        --  Every table in the FROM clause must have a name. the inner query creates a temporay table without a name so we give it one (t)
GROUP BY Category
ORDER BY TotalSales DESC

/*
RULES :
 THE DATATYPES OF THE RESULT MUST BE MATCHING 
 CASE STATEMENT CAN BE USED ANYWHERE IN THE QUERY
*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE CASE -> 2 -> MAPPING , TRANSFORM THE VALUES FROM ONE FORM TO ANOTHER
--[ Mapping means assigning or converting one value into another according to a defined rule ]

-- QUERY -2
-- RETRIEVE EMPLOYEE DETAILS WITH GENDER DISPLAYED AS FULL TEXT 

SELECT
EmployeeID,
FirstName,
LastName,
Gender,
CASE 
    WHEN Gender = 'M' THEN 'Male'
    WHEN Gender = 'F' THEN 'Female'
    ELSE 'Not Available'
END AS Fulltxtgender
FROM Sales.Employees

--QUERY 3
-- RETIREVE CUSTOMER DETAILS WITH ABBREVIATED COUNTRY CODE 

SELECT 
CustomerID,
FirstName,
LastName,
Country  ,
CASE 
    WHEN Country = 'Germany' THEN 'DE'
    WHEN Country = 'USA' THEN 'US'
    ELSE 'Not Available'
END AS AbbCountryname     
FROM  Sales.Customers

-- for checking the unique country names   
SELECT DISTINCT Country FROM 
Sales.Customers

/*
QUICK FORM FOR THE SAME COLUMN 

CASE Country
    WHEN 'Germany' THEN 'DE'
    WHEN 'USA' THEN 'US'
    WHEN 'INDIA'  THEN 'IN'
    WHEN 'FRANCE' THEN 'FR'
    ELSE 'Not Available'
END AS AbbCountryname

*/

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE CASE -> 3 -> HANDLING THE NULLS , REPLACE NULLs WITH A SPECIFIC VALUE 
--[ because sometimes nulls can lead to inaccurate result which can lead to wrong decision making ]

-- QUERY 4 
/*
FIND THE AVG SCORES OF CUSTOMERS AND TREAT NULLs AS 0
AND ADDITIONAL PROVIDE DETAILS SUCH CustomerID & LastName
*/

SELECT 
CustomerID,
LastName,
CASE 
    WHEN Score IS NULL THEN 0
    ELSE Score
END AS CLEANSCORE,
AVG(
    CASE 
        WHEN Score IS NULL THEN 0
        ELSE Score
    END ) OVER() AS avg_score1,                            -- giving alias inside the AVG will show u error
AVG (Score) OVER() AvgCustomer
FROM Sales.Customers

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- USE CASE -> 4 -> CONDITONAL AGGREGATION , APPLY AGGREGATE FUNCTION ONLY ON SUBSETS OF DATA THAT FULFILL CERTAIN CONDITIONS
-- QUERY 5 
/*
COUNT HOW MANY TIMES EACH CUSTOMER HAS MADE AN ORDER WITH SALES GREATER THAN 30
*/
SELECT
CustomerID,
SUM(CASE                                   -- This is a trick to count rows that satisfy a condition.
    WHEN  Sales > 30 THEN 1
    ELSE 0
END) AS SalesFlag,
COUNT(*) AS TotalScore                    -- SQL counts how many rows are in each group
FROM Sales.Orders
-- ORDER BY CustomerID
GROUP BY CustomerID

-------------------------------------------------------------------------------------------------------------------------------------------------------
/*
RECAP 

- IF THE ELSE IS NOT PROVIDED AND THE CONDITION ISN'T SATISFIED THEN WE GET THE RESULT AS NULL
- Every table in the FROM clause must have a name. the inner query creates a temporay table without a name so we give it one (t)
- THE DATATYPES OF THE RESULT MUST BE MATCHING 
- CASE STATEMENT CAN BE USED ANYWHERE IN THE QUERY
-  giving alias inside the AVG will show u error