/*
Window Rank Function 

1. The first step of ranking the data is sorting it in proper order , either ascending or descending.
2. Two Method of Ranking 
   A. --> Integer based Ranking {Discrete Values}
          Used for Top/Bottom N analysis like ( Find Top 3 Products )
          < Gives a person/item a whole-number position compared with others.
          Common SQL functions:
            RANK()
            DENSE_RANK()
            ROW_NUMBER()
            NTILE()>

   B. --> Percentage based Ranking {Continous Values}
          Normally used for distribution analysis like ( Find Top 20% products )
         < Tells you how you perform relative to the rest of the data as a percentage
         If you're at the 90th percentile, it roughly means:
         You performed better than about 90% of the people/items in the dataset.
         Common SQL function:
           PERCENT_RANK()
           CUME_DIST()
*/
------------------------------------------------------------------------------------------------------------------------------------------
/*
SYNTAX 

FUNCTION () OVER ( PARTITION BY CATEGORY ORDER BY CATEGORY )

NOTE : 
     1. Funtion () -> must stay empty .
     2. Partition by -> Optional 
     3. Order by -> Required , it is a must .
     4. Frame -> it is not allowed 
*/

-------------------------------------------------------------------------------------------------------------------------------------------
/*
Funtion - 1
ROW_NUMBER() :- Assign a unique number to each row 
                It does not handle ties 
                There are no gaps/ no skipping of ranks
                Same value don't have the same rank
*/

--Rank the order based on their sale from highest to lowest 
SELECT 
OrderID,
ProductID,
Sales,
ROW_NUMBER() OVER (ORDER BY Sales DESC) SalesRank_Row
FROM Sales.Orders