-- SET OPERATOR 
/*
DEFINITION :- Set operation are used to combine the result(rows) of two or more select queries  into a single result .
              unlike the join where we needed the key col here we just need to have the same column .

--=================================================================================================================================================================================================

*//*
RULES :- 1.Set operator can be used almost in all clauses WHEER | JOIN | GROUP BY | HAVING 
           ORDER BY is allowed only once at the end of query
*/

SELECT 
FirstName,
LastName 
FROM Sales.Customers                           -- QUERY 1        
--JOIN CLAUSE 
--WHERE CLAUSE
--GROUP BY CLAUSE 
UNION                                         -- SET OPERATOR 
SELECT                                             
FirstName,
LastName                      
FROM Sales.Employees                           -- QUERY 2          
--JOIN CLAUSE                       
--WHERE CLAUSE                       
--GROUP BY CLAUSE                     
--ORDER BY COL_NAME                            ORDER BY clause at the end    

--=================================================================================================================================================================================================
/*
         
RULES 2:-  The number of column in each query must be the same 
*/
SELECT 
FirstName,                                  --[2 col in query 1]                                    
LastName 
FROM Sales.Customers                                    
UNION                                           
SELECT 
FirstName,                                  -- [2 col in query 1]
LastName 
FROM Sales.Employees              

--=================================================================================================================================================================================================
/*
          
RULES :- 3. The datatype of columns in eacH query must be compatible .
            If the first col in the first query is a int and first col in the second query is varchar it will throw an error 
*/
SELECT 
FirstName,                                    --[varchar]
LastName                                     --[varchar]
FROM Sales.Customers                                    
UNION                                           
SELECT 
FirstName,                                   --[varchar]
LastName                                     --[varchar]
FROM Sales.Employees 
           .
--=================================================================================================================================================================================================
/*
RULES:-  4. The order of the columns in each query must be the same 
            This will throw error as last_name will try to convert datatype of Employee_id (int) to (varchar) and fails to do it . 
*/
SELECT 
CustomerID,                                    -- [ COL - INT]
LastName                                       --[COL - VARCHAR]
FROM Sales.Customers                                    
UNION                                           
SELECT 
FirstName,                                     -- [COL - VARCHAR]
EmployeeID                                     -- [COL -INT]
FROM Sales.Employees                         

--=================================================================================================================================================================================================     
/*             
RULES :- 5. The column names in the result set are determined by the column names specified in the first query .
*/
SELECT
CustomerID as ID ,                         -- [THIS WILL DECIDE THE COL NAME IN THE RESULT TABLE ]
LastName                                    
FROM Sales.Customers                                    
UNION                                           
SELECT 
EmployeeID,                                 
LastName                                     
FROM Sales.Employees                                  

--=================================================================================================================================================================================================
   
-- TYPES OF SET OPERATOR 
/*
UNION  :- RETURN ALL DISTINCT ROWS FROM BOTH QUERIES
          REMOVES DUPLICATES ROWS FROM THE RESULT 
*/

-- COMBINE THE DATA FROM THE EMPLOYEES AND CUSTOMERS INTO ONE TABLE 
SELECT 
FirstName,
LastName 
FROM Sales.Customers                                
UNION                                          
SELECT                                             
FirstName,
LastName                      
FROM Sales.Employees

--=================================================================================================================================================================================================

/*
UNION ALL  :- RETURN ALL ROWS FROM BOTH QUERIES ,INCLUDING DUPLICATES (ONLY SET OPERATOR THAT DOESN'T REMOVE DUPLICATES ]
              IT IS MUCH FASTER THAN UNION BECAUSE IT DOES NOT WASTE TIME REMOVING DUPLICATES SO WHEN YOU ARE SURE YOUR DATA DOESN'T HAVE DUPLICATE 
              YOU CAN USE UNION ALL.
*/

-- COMBINE THE DATA FROM THE EMPLOYEES AND CUSTOMERS INTO ONE TABLE , INCLUDING DUPLICATES 
SELECT 
FirstName,
LastName 
FROM Sales.Customers                                
UNION ALL                                         
SELECT                                             
FirstName,
LastName                      
FROM Sales.Employees

--=================================================================================================================================================================================================

/*
EXCEPT  :- RETURNS UNIQUE ROWS FROM 1ST TABLE THAT ARE NOT IN THE 2ND TABLE .
           ORDER OF THE TBALE MATTERS QUERY 1 - 1ST TBALE {PRIORITY}
           MATCHING ROWS AND 2ND TABLE ROWS WILL BE REMOVED FROM THE RESULT
*/

-- FIND THE EMPLOYEES WHO ARE NOT CUSTOMER AT THE SAME TIME 
SELECT 
FirstName,
LastName 
FROM Sales.Employees                                
EXCEPT                                         
SELECT                                             
FirstName,
LastName                      
FROM Sales.Customers

--=================================================================================================================================================================================================

/*
INTERSCT :- RETURNS ONLY THE ROWS THAT ARE COMMON IN BOTH QUERIES .

*/

-- FIND THE EMPLOYEES WHO ARE ALSO CUSTOMER AT THE SAME TIME 
SELECT 
FirstName,
LastName 
FROM Sales.Employees                                
INTERSECT                                        
SELECT                                             
FirstName,
LastName                      
FROM Sales.Customers

--=================================================================================================================================================================================================

-- USE CASE OF THE SET OPERATOR 
/*
COMBINE INFORMATION : - Combine a lot of small tables like Employee , customer , suppliers , students using [union] 
                        into one table called person before performing analysis using SQL queries and showcasing 
                        the result in the report .

                        Database developers often split data across multiple tables to improve query performance and 
                        manage storage efficiently. Current data is kept in active tables for faster access, while 
                        older records are archived into separate tables to reduce load and maintain system speed."
                              - This way, the meaning is sharper:
                                     * Optimize performance → faster queries on smaller active tables.
                                     * Archive old data → keeps history safe without slowing down the main database.

                        EXAMPLE :- like order 2025 ,order 2024 ,order 2023 ,order 2022 combined into one order table .

[BEST PRACTICE] :- NEVER USE (*) TO COMBINE TABLES : LIST NEEDED COLUMNS INSTEAD .
*/

-- Orders are stored in seperate tables (orders and ordersarchieve) combine all orders into one report without duplicate 

SELECT 
'Orders' as  SourceTable                    -- You are creating a new column called SourceTable in the result set.For every row coming from the Sales.Orders table, this column will contain the text 'Orders'
,[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.Orders
UNION
SELECT 
'OrdersArchieve' as  SourceTable           -- You are creating a new column called SourceTable in the result set.For every row coming from the Sales.OrdersArchieve table, this column will contain the text 'OrdersArchieve'
,[OrderID]
,[OrderID]
,[ProductID]
,[CustomerID]
,[SalesPersonID]
,[OrderDate]
,[ShipDate]
,[OrderStatus]
,[ShipAddress]
,[BillAddress]
,[Quantity]
,[Sales]
,[CreationTime]
FROM Sales.OrdersArchive
ORDER BY OrderID
 

--=================================================================================================================================================================================================

-- USE CASE OF THE SET OPERATOR EXCEPT 

/*
1. Data Validation After ETL :- Suppose data is being loaded from source system to data warehouse ,
   you can use the except operator to check for missing customer that hasn't been loaded to warehouse yet from source system 
   
2. Data Quality Checks:- EXCEPT operator can be used to comapare tables to detect disprepancies (data completeness) between databases 
   
   [TABLE A](SOURCE) EXCEPT [TABLE B](TARGET) => EMPTY RESULT      
   MEANING ALL THE ROWS FROM TABLE A EXIST IN TABLE B DATA IS FULLY LOADED .
               