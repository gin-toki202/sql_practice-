/*
ADVANCED SQL JOINS 
      1. LEFT ANTI JOIN 
*/

-----------------------------------------------------------------------------------------------------------------------------------
-- [ LEFT ANTI JOIN ]
/*
Returns rows from the left that has no match in right .
         table A [left side] -> Primary ,main source of data. (contains unmatching rows ).
         table B [right side] -> lookup (not for data just for filter )

SYNTAX ; SELECT * FROM
          A LEFT JOIN B 
          ON A.KEY = B.KEY
          WHERE B.KEY IS NULL

NOTE ;- THE ORDER IS IMPORTANT 
*/

-- Get all customers who haven't place and order 
SELECT * 
FROM customers as c
LEFT JOIN orders as o 
ON c.id = o.customer_id
WHERE o.customer_id IS NULL

-----------------------------------------------------------------------------------------------------------------------------------
-- [ RIGHT ANTI JOIN ]
/*
Returns rows from the RIGHT that has no match in left .
         table A [left side] -> lookup (not for data just for filter ).
         table B [right side] -> Primary ,main source of data. (contains unmatching rows )

SYNTAX ; SELECT * FROM
          A RIGHT JOIN B 
          ON A.KEY = B.KEY
          WHERE B.KEY IS NULL

NOTE ;- THE ORDER IS IMPORTANT 
*/

--Get all orders without any valid customers 
SELECT * 
FROM customers as c
RIGHT JOIN orders as o 
ON c.id = o.customer_id 
WHERE c.id IS NULL

-- [ALTERNATIVE TO RIGHT JOIN]
SELECT *
FROM orders as o
LEFT JOIN customers as c
ON c.id = o.customer_id
WHERE c.id IS NULL 

-----------------------------------------------------------------------------------------------------------------------------------
-- [ FULL ANTI JOIN ]
/*
Returns rows from the RIGHT that has no match in left .
         table A [left side] ->  Unmatching rows from B
         table B [right side] -> unmatching rows from A

SYNTAX ; SELECT * 
         FROM A
         FULL JOIN B 
         ON A.KEY = B.KEY
         WHERE B.KEY IS NULL 
         OR                               why OR ? because we want missing rows from B OR A also they can't have missing value simultaneously 
         A.KEY IS NULL

NOTE ;- THE ORDER IS not IMPORTANT 

*/

-- Find customers without orders and orders without customers 
SELECT *
FROM customers as c
FULL JOIN orders as o
ON c.id = o.customer_id
WHERE c.id IS NULL OR o.customer_id IS NULL

-----------------------------------------------------------------------------------------------------------------------------------
-- [ ADVANCED INNER JOIN ]

-- Get all customers along with their orders but only for customers who have placed an order without using inner join 
 SELECT * 
 FROM customers as c
 LEFT JOIN orders as o 
 ON c.id = o.customer_id
 WHERE o.customer_id IS NOT NULL
 
 -----------------------------------------------------------------------------------------------------------------------------------
-- [ CROSS  JOIN ]
/*
Combines every row from left with every row from right [CARTESIAN PRODUCT] .
         table A [left side] ->  everything 
         table B [right side] -> everything
         we don't care about data being matching 

SYNTAX ; SELECT * 
         FROM A
         CROSS JOIN B 

NOTE ;- THE ORDER IS not IMPORTANT 
USE CASE = Product combination (every color * every size )
           calender generation (day * shifts )
           Testing data 
*/

-- Generate all possible combination of customers and orders .
SElECT * 
FROM customers as c
CROSS JOIN orders as o


         
         