--  SQL FUNCTIONS 
/*
TYPES OF SQL FUNCTIONS 

TYPE 1- [SINGLE ROW FUCNTION] -> Used for row level calculation. {DATA ENGINEER}
SUB-CATEGORY - 1. STRING FUNCTION 
               2. NUMERIC FUNCTION 
               3. DATE & TIME FUNCTIONS
               4. NULL FUNCTIONS 

USE CASE :- THEY ARE FUNCTIONS IN ORDER TO MANIPULATE,CLEAN UP,TRANSFORM ,PREPARE THE DATA FOR THE TYPE 2
----------------------------------------------------------------------------------------------------------------------------------

TYPE 2- [MULTI ROW FUCNTION] -> Used for AGRREGATIONS. {DATA ANALYSIT}
SUB-CATEGORY - 1. - AGGREGATE FUNCTIONS (basics) 
               2. - WINDOW FUNCTIONS (advanced)
USE CASE :- USED IT FOR DATA ANALYSING USING AGGREGATES FUNCTIONS 
               
-----------------------------------------------------------------------------------------------------------------------------------

 EXECUTION ORDER OF NESTED FUNCTION  

 EXAMPLE :- LEN(LOWER(LEFT(MARIA)))
            ORDER 1 - LEFT(MARIA) -> ORDER 2 - LOWER(OUTPUT OF LEFT(MARIA)) -> ORDER 3 - LEN(OUTPUT OF LOWER(LEFT(MARIA)))

-----------------------------------------------------------------------------------------------------------------------------------

TOPIC - 1 STRING FUNCTION

TYPES - 1.MANIPULATION -> [CONCAT] , [UPPER] , [LOWER] , [TRIM] , [REPLACE] 
        2.CALCULATION -> [LEN]
        3.STRING EXTRACTION -> [LEFT] , [RIGHT] , [SUBSTRING]
*/
------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 1 - MANIPULATION [CONCAT] = IT IS A FUNCTION USED TO COMBINE TWO OF MORE WORDS TOGETHER .

EXAMPLE :- [MARIA] + [SWELL] BECOMES [MARIA SWELL] AFTER CONCATINATION .
*/

-- SHOW A LIST OF CUSTOMER FIRST_NAME TOGETHER WITH THEIR COUNTRY IN ONE COLUMN 
SELECT 
first_name,
country,
CONCAT (first_name ,' ',country) AS Name_Country
FROM customers;

------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 1 - MANIPULATION [Upper/LOWER] = IT IS A FUNCTION USED TO CONVERT ALL CHARACTER TO UPPERCASE/LOWERCASE  .

EXAMPLE :- [Maria]/[MARIA] = [MARIA]/[maria].
*/
-- TRANSFORM THE CHARaCTER FIRST NAME TO UPPERCASE AND LOWERCASE
SELECT
first_name,
country,
CONCAT(first_name,' ',country) AS name_country,
LOWER(first_name) AS lower_name,
UPPER(country) AS upper_name
FROM customers;

------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 1 - MANIPULATION [TRIM] = IT IS A FUNCTION USED TO REMOVE THE UNNECCESARY SPACES BEFORE/AFTER/BETWEEN THE WORD  .

EXAMPLE :- [ MARIA] = [MARIA]
           [MARIA ] = [MARIA]
           [ MARIA ] = [MARIA]
           [MARIA    ] = [MARIA]
           [   MARIA] = [MARIA]
*/

-- TECHNIQUE - 1 TO CHECK FOR SPACES
SELECT 
first_name 
from 
customers
WHERE first_name != TRIM(first_name);

-- TECHNIQUE - 2 TO CHECK FOR SPACES   
SELECT 
 first_name,
 LEN(first_name) AS len_name,
 LEN(TRIM(first_name)) AS len_after_trim,
 LEN(first_name) - LEN(TRIM(first_name)) as White_space_count
FROM customers
WHERE LEN(first_name) != LEN(TRIM(first_name)); 

------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 1 - MANIPULATION [REPLACE] = IT IS A FUNCTION USED TO REPLACE SPECIFIC CHARACTER WITH A NEW CHARACTER.
                                  we need to specify two values , old value = '-' and new value = '/'

EXAMPLE :- [ MARI--ANA] = [MARIANA]         
*/
-- PHONE NUMBER 
SELECT 
'123-9999-1800' AS Phone_num,                                  -- using the static value
REPLACE ('123-9999-1800' , '-',' ') AS new_num

-- FILE NAME 
SELECT 
'HELLO.PY' AS file_name,
REPLACE('HELLO.PY','.PY','.csv') AS newfile_name
------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 2 - CALCULATION [LEN] = IT IS A FUNCTION USED TO COUNT THE NUMBER OF THE CHARACTER.
                                  GIVEN ANY DATATYPE AS INPUT IT WILL ALWAYS GIVE A OUTPUT AS A NUMBER 

EXAMPLE :- [MARIANA] = 7
           [123-9999-1800] = 13
*/

--CALCULATE THE LENGTH OF EACH CHARACTER IN FIRST_NAME
SELECT 
first_name,
LEN(first_name) AS names_length
FROM customers

------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE 3 - STRING EXTRACTION [LEFT] = EXTRACT SPECIFIC NUMBER OF CHARACTER FROM THE START.
                          -> LEFT(VALUE , NO OF CHAR)
                          [RIGHT] = EXTRACT SPECIFIC NUMBER OF CHARACTER FROM THE END.
                          -> RIGHT(VALUE , NO OF CHAR)

EXAMPLE :- [MARIANA] = MA        ,  LEFT = 2
           [123-9999-1800] = 800 ,  RIGHT = 3
*/

-- RETRIEVE THE FIRST AND LAST TWO CHARACTER FROM NAMES
SELECT 
first_name,
LEFT(TRIM(first_name),2) as first_2_char,
RIGHT(TRIM(first_name),2) as last_2_char
FROM customers;

------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE  - STRING EXTRACTION [SUBSTRING] = EXTRACTS A PART OF STRING AT A SPECIFIED POSITION .
                          -> SUBSTRING(VALUE , START,NUMBER OF CHAR)    - STATIC
                          -> SUBSTRING(VALUE , START,LEN(VALUE))    - DYNAMIC (WHEN WE DOESN'T KNOW THE NUMBER OF CHARACTER FOR EACH WORD IN THE COLUMN) 
                          
                          

EXAMPLE :- SUBSTRING('MARIANA',START = 3, NO OF CHAR = 4)  = RIAN              STATIC - GIVES YOU DEFINED NUMBER OF VALUES FROM THE START
           SUBSTRING('MARIANA',START = 3, LEN(MARIANA))  = RIANA               DYNAMIC - GIVES YOU ALL VALUES FROM THE START 
           
*/

-- RETRIEVE 2 CHARACTER AFTER THE FIRST CHARACTER FROM frist_name
SELECT 
first_name ,
SUBSTRING(TRIM(first_name),2,2) AS character
FROM customers;

-- RETRIEVE ALL CHARACTER AFTER THE FIRST CHARACTER FROM frist_name
SELECT 
first_name,
SUBSTRING(TRIM(first_name),2,LEN(first_name)) AS all_char
FROM customers;

--===================================================================================================================================================
/*
TYPE 1- [SINGLE ROW FUCNTION] -> Used for row level calculation. {DATA ENGINEER}
SUB-CATEGORY - 1. STRING FUNCTION 
               2. NUMERIC FUNCTION   ✅
*/
--------------------------------------------------------------------------------------------------------------------------
/*
TYPE NUMERIC FUNCTION [ROUND] - a built-in tool used to round a number to a specific number of decimal places.

EXAMPLE - (3.516,2) = 3.520   [round based on number '6']
          (3.516,1) = 3.500   [round based on number '1']
          (3.516,2) = 4.000   [Round based on number '5']
*/

SELECT 
92.826,
ROUND(92.826,2) AS round_2,
ROUND(92.826,1) AS rOUND_1,
ROUND(92.826,0) AS round_0

------------------------------------------------------------------------------------------------------------------------------------------------
/*
TYPE NUMERIC FUNCTION [abs] - Returns the absolute positive value of a number ,removing any negative sign 
*/
SELECT 
-10,
ABS(-10) AS abs_value,
ABS(12) AS abs_value_1