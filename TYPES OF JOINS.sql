/*
TYPES OF JOINS (COLUMN JOINING )
   -> NO JOINS 
   -> INNER JOINS 
   -> LEFT JOIN 
   -> RIGHT JOIN 
   -> FULL JOIN 
*/

   
/* When joins are used ?
      1. To recombine data [INNER ,LEFT ,FULL] :- (when data is spread into multiple table you use joins to combine
      the needed columns across different tables into one).
      EXAMPLE - [CUSTOMERS + ORDER + REVIEWS + ADDRESS] = [COMBINED TABLE RESULT]
      
      2. Data Enrichment [LEFT] :- ( When you needed a little bit of information from a reference table .
       then you use the join it to the master table .
       [MASTER TABLE + REFERENCE TABLE] = [COMBINED TABLE RESULT]

       3. Checking for existence ( filtering )[INNER ,LEFT +WHERE, FULL+WHERE] :- using the look up table to filter the data from the main table .
       EXAMPLE - Using attendance table to check the how many employee were present and put the names of the in the result (filtering) 
*/
--===========================================================================================================================================================

-- [ NO JOIN ] - returns data from tbales without combining them

/* SYNTAX 
            SELECT * FROM A ;
            SELECT * FROM B ;
*/

-- Retrieve all data from customers and orders in two different results
SELECT * FROM customers
SELECT * FROM orders

--===========================================================================================================================================================

-- [INNER JOIN] -> Returns only the matching rows from both tables .

/* SYNTAX 
         SELECT * FROM A [TYPE] JOIN B  
         ON <CONDITION> 
         
         * DEFAULT TYPE IS INNER JOIN 
         * ORDER DOESN'T MATTER
*/

-- get all customers aling with their order , but only for customers who have placed an order 
SELECT 
c.id,
c.first_name,
c.country,
o.order_id,
o.order_date
FROM customers as c
INNER JOIN orders as o
ON c.id = o.customer_id 

--===========================================================================================================================================================

-- [LEFT JOIN] -> Returns  all rows from left and only matching from right.

/* SYNTAX 
         SELECT * FROM A LEFT JOIN B  
         ON <CONDITION> 
         
         * ORDER MATTER   (LEFT TABLE AT THE FROM CLAUSE AND IN THE JOIN IS THE RIGHT TABLE )
*/

-- Get all customers along with their orders ,including those without orders 
SELECT 
c.id,
c.first_name,
c.country,
o.order_id,
o.order_date
FROM customers as c
LEFT JOIN orders as o 
ON c.id = o.customer_id

--===========================================================================================================================================================

-- [RIGHT JOIN] -> Returns  all rows from right and only matching from left.

/* SYNTAX 
         SELECT * FROM A RIGHT JOIN B  
         ON <CONDITION> 
         
         * ORDER MATTER   
*/

-- Get all customers along with their orders, including orders without matching customers 
SELECT 
c.id,
c.first_name,
c.country,
o.order_id,
o.order_date
FROM customers as c
RIGHT JOIN orders as o
ON c.id = o.customer_id

--[ ALTERNATIVE TO RIGHT JOIN USING LEFT JOIN ]
SELECT 
c.id,
c.first_name,
c.country,
o.order_id,
o.order_date
FROM orders as o                    -- CHANGE THE ORDER OF THE TABLES AND THE TYPE TO THE SAME RESULT 
LEFT JOIN customers as c
ON c.id = o.customer_id

--===========================================================================================================================================================

-- [FULL JOIN] -> Returns  all rows from both tables .

/* SYNTAX 
         SELECT * FROM A FULL JOIN B  
         ON <CONDITION> 
         
         * ORDER is not MATTER   
*/

-- Get all customer and all orders , even if there is no match 
SELECT
c.id,
c.first_name,
c.country,
o.order_id,
o.order_date
FROM  customers as c                 
FULL JOIN orders as o
ON c.id = o.customer_id