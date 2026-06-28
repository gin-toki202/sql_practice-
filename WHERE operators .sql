-- WHERE OPERATORS 
/*
COMPARISON OPERATOR -> =,<> =!,>,>=,<,<=
LOGICAL OPERATOR -> AND , OR , NOT 
RANGE OPERATOR -> BETWEEN
MEMBERSHIP OPERATOR -> IN , NOT IN
SEARCH OPERATOR -> LIKE 
*/

-- [COMPARISON OPERATOR]
/*
Compare two things!
Condition -> [expression] [operator] [expression]
like this :-
col1 = col2           (first_name = last_name)
col1 = value          (first_name = 'john')
func = value          (UPPER(first_name) = 1000)
expression = value    (price*quantity = 1000)
subquery = value      ( (select avg(sales) from orders) = 1000)
*/

-- [=] Retrieve all customer from germany
SELECT * FROM customers 
WHERE country = 'Germany'
--[=! <>] Retrieve all customer who are not from germany 
SELECT * FROM customers 
WHERE country <> 'Germany'
-- [>] Retieve all customer with score greater than 500
SELECT * FROM customers 
WHERE score > 500
-- [>=] Retieve all customer with score  500 or more 
SELECT * FROM customers 
WHERE score >= 500
-- [<] Retieve all customer with score less than 500
SELECT * FROM customers 
WHERE score < 500
-- [<=] Retieve all customer with score  500  or less
SELECT * FROM customers 
WHERE score <= 500

-- [LOGICAL OPERATOR]
/*
Compare two condition!
Condition -> [condition_1] [operator] [condition_2]
NOT - will exclude every row that fullfills the required condtion 
*/

-- [AND] Retrieve all customers who are from USA and have a score greater than 500
SELECT *
FROM customers
WHERE country = 'USA' AND score > 500

-- [OR] Retrieve all customers who are either from USA or have a score greater than 500
SELECT * 
FROM customers
WHERE country = 'USA' OR score > 500

-- [NOT] Retrieve all customers with score not less than 500
SELECT *
FROM customers 
WHERE NOT score <= 500

-- [RANGE OPERATOR]
/*
There is upper boundary and lower boundary we must ensure that the value 
lies between them using BETWEEN operator ,
the alternation to between operator is comparion and logical operator combined 
and they give you inclusive boundries .
 */

 --[BETWEEN] Retrieve all customer whose score falls in the range between 100 and 500
 SELECT *	
 FROM customers 
 WHERE score BETWEEN 100 AND 500           -- Also you can use NOT BETWEEN
 --[ALTERNATIVE WAY]
 SELECT *
 FROM customers 
 WHERE score >= 100 AND score <= 900

 -- [MEMBERSHIP OPERATOR]
/*
The IN operator checks for a value existense in the list .
-> use IN instead of OR  for multiple vlaues in the  same column to simplify SQL 
*/

--[IN] Retrieve all customers from either Germany OR USA .

--[METHOD 1]
SELECt *
FROM customers 
WHERE country = 'USA' OR country = 'Germany'

--[METHOD 2]
SELECT * 
FROM customers 
WHERE country IN ('Germany','USA')

--[SEARCH OPERATOR] 
/* 
It is normally used to find the pattern in text.

Pattern -> [%,_]
% = any number of character after or before 0,1,many 
_ = Excatly one character  
M% = Maria ,M,Mae, Emma(wrong)
%in = Martin , Vin ,In ,Jasmine (wrong)
%r% = Rae ,R ,Mir , Maria ,Alice (wrong)
__b% = Albert , Rob ,Abel(wrong) ,An (wrong)
*/

-- [LIKE] Find all customers whose first name starts with 'M'
SELECT * 
FROM customers 
WHERE first_name LIKE 'M%'

-- [LIKE] Find all customers whose first name ends with 'N'
 SELECT *
 FROM customers 
 WHERE first_name LIKE '%n'

 -- [LIKE] Find all customers whose first name contains 'r'
 SELECT * 
 FROM customers 
 WHERE first_name LIKE '%r%'

 -- [LIKE] Find all customers whose first name has 'r' in the 3rd position 
 SELECT *
 FROM customers 
 WHERE first_name LIKE '__R%'