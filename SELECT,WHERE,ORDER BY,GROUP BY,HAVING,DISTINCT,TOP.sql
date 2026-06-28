-- Retrieve All the customer data
SELECT * 
FROM customers

-- Retrieve each customer name , country and score .
SELECT 
first_name,
score,
country
FROM customers
--------------------------------------------------------------------------------------------------------------------------
-- [WHERE CLAUSE]

-- Retrieve customers with a score not equals to zero 
SELECT 
first_name,
score
FROM customers
WHERE score > 0         -- WHERE CLAUSE  IS USED IN ORDER TO FILTER THE DATA 

-- Retrieve customers only from germany 
SELECT * 
FROM customers 
WHERE country = 'Germany'    -- for a value in sql you put it between single quotes 
---------------------------------------------------------------------------------------------------------------------------------
-- [ORDER BY]

/* -- Retrieve ALL customers and sort 
the result by the highest score first. */

SELECT *
FROM customers 
ORDER BY score DESC

/* -- Retrieve ALL customers and sort 
the result by the lowest score first. */
SELECT * 
FROM customers
ORDER BY score ASC

-- NESTED ORDER BY 
/* -- Retrieve ALL customers and sort 
the result by the country and then by the highest score. */

SELECT *
FROM customers
ORDER BY country ASC , score DESC
----------------------------------------------------------------------------------------------------------------------------
--[ GROUP BY ]

/*
GROUP BY RULE 
1- All columns in the "Select" must be either aggregated or included in the group by.
2- The result of the group by determined by the unique values of the grouped columns.
*/
-- find the total score for each country 
-- nothing is saved in the database it is all in this query only 

SELECT 
country ,
SUM(score) AS total_score               -- given alias otherwise no name is shown
FROM customers
GROUP BY country 

-- find the total score and total number of customers for each country

SELECT 
country,
SUM(score) AS total_score,
COUNT(id) AS total_customer
FROM customers
GROUP BY country
------------------------------------------------------------------------------------------------------------------------------
-- [HAVING CLAUSE]

-- having clause (to filter the data after aggregation)
-- always used after group by clause with certain condition (having "condition")
-- Where clause does the same filtering the work but it is mandatory to use it before aggregation(group by)

-- query 1
/* Find the avg score for each country considering only customers with a
 score not equals to 0 and return only those countries with an average score greater than
430
*/

SELECT 
country,
AVG(score) as AVG_SCORE
FROM customers
WHERE SCORE != 0
GROUP BY country
HAVING AVG(score)>430
---------------------------------------------------------------------------------------------------------------------------------
-- [DISTINCT CLAUSE]

-- Distinct - this removes the duplicates value ,each value appears only once 
--used after the SELECT clause

SELECT DISTINCT
country 
FROM customers
---------------------------------------------------------------------------------------------------------------------------------------
-- [TOP CLAUSE]

-- TOP ()CLAUSE -> filtering based on the number of the rows 

-- retrieve only 3 customers 
SELECT TOP 3 *
FROM customers 

-- RETIEVE THE TOP 3 customers with the highest score 
SELECT TOP (3) *
FROM customers 
ORDER BY score DESC

-- RETIEVE THE TOP 2 CUSTOMERS WITH THE LOWEST SCORE 
SELECT TOP 2 *
FROM customers 
ORDER BY score ASC
 
-- retrieve the two most recent orders 
SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC