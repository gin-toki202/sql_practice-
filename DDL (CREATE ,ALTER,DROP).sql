-- [CREATE]
-- create a new table called person 
-- with columns ; id ,person_name, birth_date abd phone 
 

CREATE TABLE persons(
id INT NOT NULL,
person_name VARCHAR(50) NOT NULL,
birth_date DATE,
phone VARCHAR(15) NOT NULL,
CONSTRAINT pk_persons PRIMARY KEY (id)
)

-------------------------------------------------------------------------------------------------------------------------------
-- [ALTER]

--  add a new column called email to the person  table 
ALTER TABLE persons 
ADD email VARCHAR(50) NOT NULL

-- DROP a column from the table  phone 
ALTER TABLE persons
DROP COLUMN phone 

-----------------------------------------------------------------------------------------------------------------------------------
-- [DROP]

-- removing the whole table from the database 
DROP TABLE persons 