-- DML lesson 1 
-- insert :- adding a new rows to the existing table 
/* METHODS  
   MANUAL ENTRY VALUES  

   * SYNTAX
   INSERT INTO TABLE_NAME(COL_1,COL_2......)    specifying column is optional ,sql expects vlaues for all columns 
   VLAUES(VALUE_1,VALUE_2........)

   * RULES
    -> match the number of columns and values
    -> columns and vlaues must be in the same order.
    */
    
/* query 1 
INSERT INTO customers (id,first_name,country,score)
VALUES (11,'AKASH','INDIA',900),
*/

-- query 2
INSERT INTO customers (id,first_name)
VALUES (13,'PRITHVI')

SELECT * FROM customers

------------------------------------------------------------------------------------------------------------------------------------------------------
-- DML lesson 2 
-- insert :- adding a new rows to the existing table 
/* METHODS  
   insert using select :- copying data from one table and pasting it to the target  table
    
    * RULES 
     AS long as the result of the source table matches with the target  table 
     it will insert it , it will never compare there the col names .
   
    */

-- Insert data from customers into persons 
INSERT INTO persons (id,person_name, birth_date,phone)
SELECT 
id ,
first_name,
NULL,                       -- if the target column can accept null(it has bdate and source table doesn't)
'Unknown'                  -- static value in case col can't accept null
FROM customers


SELECT * FROM persons

-------------------------------------------------------------------------------------------------------------------------------------------------

-- DML 3
/* 
Update - will change the existing data .

*SYNTAX
UPDATE tablr_name 
    SET column1 = value1,
        column2 = value2
WHERE <condition>

*RULES 
-> ALways use where to avoid updating all rows unintentionally 
-> check with select before running update to avoid updating the wrong data
*/

-- Query 1
-- change the score of customers with id 6 to 0
UPDATE customers 
SET score = 0
WHERE  id = 5

SELECT * FROM customers 

-- Query 2
-- Change the score of customers with ID 10 to 0 and update the country to 'UK'
UPDATE customers 
SET score = 0,
country = 'UK'
WHERE id = 10

SELECT * FROM customers

-- Query 3
-- Update all customers with a null score by setting their score to 0
UPDATE customers 
set score  = 0
WHERE score is NULL 

SELECT * FROM customers 

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- DML - 4
/*
DELETE - SQL will delet the already existing rows from your table 

*SYNTAX 
DELETE FROM table_name
WHERE <conditon>

*RULES 
-> Always use WHERE to avoid deleting all rowss unintentionally 
-> check with select before running delete to avoid deleting the wrong data
*/

-- Query 1
-- Delete all customers with an id greater than 5
DELETE  FROM customers 
WHERE id > 5

SELECT * FROM customers 

-- Query 2
-- Delete all data from table persons 
DELETE FROM persons 

SELECT * FROM persons

-- another method of deleting table 
-- TRUNCATE -> Clears the whole table at once without checking or logging 
TRUNCATE TABLE persons 