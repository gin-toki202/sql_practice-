-- JOINING MULTIPLE TABLES 

/*
MULTI TABLE JOIN -> ADVANCED TABLE JOIN 
A good database has an entity relationship model ,that shows the relationship betweem tables 
using primary ansd foreign key .

SYNTAX :-  SELECT 
         FROM A 
         LEFT JOIN B ON .....
         LEFT JOIN C ON .....
         LEFT JOIN D ON .....
         WHERE <TO CONTROL THE RESULT>  

         [FOR INNER JOIN]
         SELECT 
         FROM A 
         INNER JOIN B ON .....
         INNER JOIN C ON .....
         INNER JOIN D ON .....
 */       
------------------------------------------------------------------------------------------------------------------------------------
-- Query 1
/*
USING SALESDB , RETIREVE A LIST OF ALL ORDERS ,ALONG WITH THE RELATED CUSTOMER,
PRODUCT AND EMPLOYEE DETAILS .

FOR EACH ORDER ,DISPLAY:
    - Order ID
    - Customer's name
    - Product name
    - Sales amount
    - Product price
    - Salesperson's name 
*/
SELECT 
o.OrderID,
o.Sales,
c.FirstName as Customerfirstname,
c.LastName as Customerlastname,
p.Product,
p.Price,
e.FirstName as Employeefirstname,
e.LastName as Employeelastname
FROM Sales.Orders as o 
LEFT JOIN Sales.Customers as c
ON o.CustomerID = c.CustomerID
LEFT JOIN Sales.Products as p
ON o.ProductID = p.ProductID
LEFT JOIN Sales.Employees as e
ON o.SalesPersonID = e.EmployeeID


