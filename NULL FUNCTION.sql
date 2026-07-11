-- NULL FUNCTIONS
/*
NULL = NULL MEANS NOTHING ,UNKNOWN
       NULL IS NOT EQUAL TO ANYTHING 
               - NULL IS NOT ZERO
               - NULL IS NOT EMPTY STRING
               - NULL IS NOT BLANK SPACE 

[REPLACE VALUE FUNCTION] - ISNULL
                         - COALESCE
                         - NULLIF

[CHECKING FOR NULL] - IS NULL
                    - IS NOT NULL
*/
--==============================================================================================================================
/*
[REPLACE VALUE FUNCTION] - ISNULL --> REPLACE 'NULL'  WITH A SPECIFIC VALUE 

SYNTAX :- ISNULL(VALUE, REPLACEMENT_VALUE)

EXAMPLE :- ISNULL(CURRENT_ADDRESS, 'UNKNOWN')    //REPLACE WITH A STATIC VALUE
           ISNULL(CURRENT_ADDRESS, PREVIOUS_ADDRESS)      // REPLACE WITH A DYNAMIC VALUE

*/
-- using the static to handle the null value 
SELECT 
ShipAddress,
ISNULL(ShipAddress , 'unknown') shipping_ads
FROM Sales.Orders

-- using the other column to handle the null value 
SELECT 
ShipAddress,
BillAddress,
ISNULL(ShipAddress,BillAddress) NULLHANDLER        -- IF BOTH THE COL HAVE NULL THEN THE RESULT WILL BE NULL AS WELL
FROM Sales.Orders

--==============================================================================================================================
/*
[REPLACE VALUE FUNCTION] - COALESCE --> REPLACE 'NULL'  WITH A SPECIFIC VALUES

SYNTAX :- ISNULL(VALUE, VALUE2,VALUE3....)

EXAMPLE :- ISNULL(CURRENT_ADDRESS,PREVIOUS_ADD, 'UNKNOWN')    
 if the previous add is also null sql will use the static value .
           
 */

 -- using the other column to handle the null value 
SELECT 
ShipAddress,
BillAddress,
COALESCE(ShipAddress,BillAddress,'unknown') NULLHANDLER        -- IF BOTH THE COL HAVE NULL THEN SQL USE THE UNKNOWN
FROM Sales.Orders

-----------------------------------------------------------------------------------------------------------------------------------
/*
DIFFERENCE BETWEEN ISNULL AND COALESE 

ISNULL -> 1. LIMITED TO TWO VALUES    |     COALESCE --> 1. UNLIMITED 
          2. FAST                     |                  2. SLOW
          3. SQL SERVER - ISNULL      |                  3. AVALIABLE IN ALL DATABASES
             ORACLE     - NVL         |
             MySQL      - IFNULL      |

COALESCE IS THE RECOMMENDED ONE BECAUSE IF YOU ARE MIGRATING FROM ONE DATABASE 
TO ANOTHER YOU DON'T HAVE TO MAKE CHANGES TO YOUR FUNCTION .

--------------------------------------------------------------------------------------------------------------------------------------------------

USE CASE OF ISNULL/COALESCE -> 1. HANDLING NULLS 
                                  HANDLING THE NULLS BEFORE DOING DATA AGGREGATION 
                                  FOR EXAMPLE :- 15
                                                 20
                                                 null 
                                                 when you take the average sql will ignore 
                                                 null (15+20)/2,this could affect the buisness 
                                                 result.

EXCEPTION :- COUNT(*)  WILL NOT IGNORE NULL UNLIKE OTHER SQL AGGREGATION FUNCTIONS 
*/

-- FIND THE AVERAGE SCORE OF THE CUSTOMERS 
SELECT 
Score,
COALESCE(Score,0) AS Score2,      -- null value is replaced by 0 and then avg is calculated and displayed for every row
AVG(Score) OVER () Avg_score,     -- poore table ka average calculate karo aur har row ke saath repeat karo.
AVG(COALESCE(Score,0)) OVER() incl_null_avg       -- average after replacing the null with 0
FROM Sales.Customers

--------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE OF ISNULL/COALESCE -> 2. HANDLE THE NULLS BEFORE DOING MATHEMATICAL OPERATION .
                                
                                FOR EXAMPLE :- NULL + 5 = NULL
                                               NULL + 'B' = NULL
*/

-- DISPLAY THE FULL NAME OF CUSTOMERS IN A SINGLE FIELD BY MERGING THEIR FIRST AND LAST NAMES 
--   , AND ADD 10 BONUS POINTS TO EACH CUSTOMERS SCORE 
SELECT 
CustomerID,
FirstName,
LastName,
(FirstName +' '+ COALESCE(LastName,' ')) AS FullNames,
score,
COALESCE(Score,0)+10 AS Bonus_score
FROM Sales.Customers

--------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE OF ISNULL/COALESCE -> 3. HANDLE THE NULL BEFORE JOINING THE TABLES 

                                FOR EXAMPLE :- SUPPOSE YOU HAVE TWO TABLES 
                                TABLE A - YEAR , TYPE , ORDERS
                                AND TABLE B  -YEAR ,TYPE ,SALES 
                                YOU HAVE JOIN THEM BASED ON THE TWO KEYS PRESENT IN EACH TABLES 
                                NOW IMAGINE IF SOME OF THE KEYS CONTAIN NULL VALUES ,THE TABLES WILL
                                NOT BE JOINED PROPERLY .
*/

--CREATING AND INSERTING THE VALUES INTO TABLE A
USE MyDatabase
CREATE TABLE Table_A (
Year INT NOT NULL,
Type VARCHAR(20),
Orders INT NOT NULL
CONSTRAINT PK_Table_A PRIMARY KEY (Year)   -- AGAR TYPE PRIMARY KEY KA PART HO TO USME NULL NAHI DAAL SAKTE 
)

INSERT INTO Table_A(Year,Type,Orders)
VALUES (2024,'a',30),
(2025,NULL,40),
(2026,'b',50),
(2027,NULL,60)

--CREATING AND INSERTING THE VALUES INTO TABLE B
CREATE TABLE Table_B (
Year INT NOT NULL,
Type VARCHAR(20),
Sales INT NOT NULL
CONSTRAINT PK_Table_B PRIMARY KEY (Year)   -- AGAR TYPE PRIMARY KEY KA PART HO TO USME NULL NAHI DAAL SAKTE 
)

INSERT INTO Table_B(Year,Type,Sales)
VALUES (2024,'a',100),
(2025,NULL,200),
(2026,'b',300),
(2027,NULL,200)


-- JOINING THE TWO TABLES 
-- THE NULL VALUES MATCH WILL BE REMOVED RESULTING IN ONLY TWO ROWS (NULL CAN'T BE COMPARED IN SQL)
SELECT 
a.Year,
a.Type,
a.Orders,
b.Sales
FROM Table_A AS a
JOIN Table_B as b
ON a.Year = b.Year 
AND a.Type = b.Type 

-- JOINING THE TWO TABLES (AFTER DEALING THE NULLS)

SELECT 
a.Year,
a.Type,
a.Orders,
b.Sales
FROM Table_A AS a
JOIN Table_B as b
ON a.Year = b.Year 
AND ISNULL(a.Type,'') = ISNULL(b.Type,'')   
/*
NULL WILL STILL BE THERE BECAUSE WE ARE HANDLING
NULL IN THE JOIN AND NOT IN THE SELECT THERE IT 
WILL REMAIN NULL
*/

--------------------------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE OF ISNULL/COALESCE -> 3. HANDLE THE NULL BEFORE SORTING DATA

                                  FOR EXAMPLE : 25
                                                15
                                                NULL 

                                            SQL WILL SHOW IN AT THE TOP FOR ASCENDING AND LOWEST IN DESCENDING 
                                            ,BECAUSE SQL CONSIDER NULL TO BE THE LOWEST OR HAVE NO VALUE AT ALL
*/

-- SORT THE CUSTOMERS FROM LOWEST TO HIGHEST SCORES WITH NULLS APPEARING LAST
-- METHOD ONE - REPLACE IT WITH A BIG NUMBER 
SELECT 
CustomerID,
Score,
COALESCE(Score,99999)
FROM Sales.Customers
ORDER BY COALESCE(Score,99999)

-- METHOD TWO 
SELECT 
CustomerID,
Score
FROM Sales.Customers
ORDER BY CASE WHEN Score IS NULL THEN 1 ELSE 0 END , Score

/*
GROUP A                         WHEN YOU USE SCORE AS A SECOND SORTING KEY ,IT DOES NOT MIX UP THESE GROUPS INSTEAD IT SORTS THE DATA WITHIN THESE 
90 - 0                          GROUPS LIKE 35 < 56 < 90.
56 - 0
35 - 0

GROUP B
NULL - 1
NULL - 1

*/
--==============================================================================================================================
/*
[REPLACE VALUE FUNCTION] - IFNULL --> COMPARES TWO EXPRESSION AND RETURNS 
                                 NULL ,IF THEY ARE EQUAL 
                                 FIRST VALUE ,IF THEY ARE NOT EQUAL 

SYNTAX :- NULLIF(VALUE1 ,VALUE2 )
                             
FOR EXAMPLE :- NULLIF(Original_Price,Discount_Price)
               IF DISCOUNTED PRICE IS SAME AS ORIGINAL IT WILL THROW NULL,
               IT IS USED TO HIGHLIGHT OR FLAG SPECIAL CASE IN OUR DATA 

---------------------------------------------------------------------------------------------------------------------------------

USE CASE OF NULLIF --> PREVENTING THE ERROR OF DIVIDING BY ZERO 
*/

-- FIND THE SALES PRICE FOR EACH ORDER BY DIVIDING THE SALES BY THE QUANTITY
SELECT OrderID,
Sales,
Quantity,
--Sales/Quantity AS Price              -- THIS WILL THROW ERROR BECAUSE ONE OF THE QUANTITY IS ZERO 
Sales/NULLIF(Quantity,0) AS Price       -- REPLACING THE ZERO IN THE QUANTITY WITH NULL , AND ANY MATHEMATICALLY OPERATION WITH NULL RESULTS IN NULL.
FROM Sales.Orders

--==============================================================================================================================
/*
[CHECKING FOR NULL] - IS NULL --> RETUNRS TRUE IF THE VALUE IS NULL
                       IS NOT NULL --> RETURNS TRUE IF THE VALUE IS NOT NULL

SYNTAX :- VALUE IS NULL / VALUE IS NOT NULL 
*/

--------------------------------------------------------------------------------------------------------------------------------
/*
USE CASE - SEARCHING FOR MISSING INFORMATION 
*/

-- IDENTIFY THE CUSTOMERS WHO HAVE NO SCORE 
SELECT 
*
FROM Sales.Customers
WHERE Score IS NULL

-- LIST OF ALL CUSTOMERS WHO HAVE SCORES 
SELECT *
FROM Sales.Customers
WHERE Score IS NOT NULL