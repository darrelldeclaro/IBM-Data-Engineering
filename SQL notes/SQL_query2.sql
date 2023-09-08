USE AdventureWorks2019

SELECT *
FROM Person.Person


--LOGICAL OPERATOR
SELECT FirstName, MiddleName, LastName
FROM Person.Person
WHERE (MiddleName IS NULL) --single condition


SELECT FirstName, MiddleName, LastName,
	CONCAT(FirstName,' ',MiddleName,' ',LastName) AS FullName
	--CONCAT function is recommened as it ignore NULL values
FROM Person.Person

--AND OR OPERATOR
SELECT *
FROM HumanResources.Employee
--WHERE JobTitle='Design Engineer' OR JobTitle='Senior Tool Designer'
--WHERE MaritalStatus='S' AND Gender='F'
--WHERE JobTitle IN('Design Engineer','Senior Tool Designer') --used for multiple condition with string
--WHERE BusinessEntityID IN(1,5,10,15) --used for multiple condition with numeric
WHERE BusinessEntityID BETWEEN 1 AND 50 --query between range


SELECT *
FROM Person.StateProvince
--WHERE NAME LIKE 'Al_' --query by 3rd string
--WHERE NAME LIKE 'Al%' --query column with a wildcard condition "%" exampls is to search column starting with "Al"
WHERE NAME LIKE '%o' --search column ending with "o"
-- ILIKE function can search column cell "%word%"




--SORTING function WHERE, GROUP BY, HAVING, ORDER BY
SELECT SalesOrderId, 
	SUM(UnitPrice) AS TotalUnitPricePerSale --sum all distinct value
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID --query distinct value in column


--SEQUENCE OF EXECUTING
SELECT SalesOrderId, 
	SUM(UnitPrice) AS TotalUnitPricePerSale
FROM Sales.SalesOrderDetail
WHERE SalesOrderID > 50000 --where clause does not  execute aggregate function
GROUP BY SalesOrderID
HAVING SUM(UnitPrice) > 10000 --HAVING clause will execute aggregate function
ORDER BY SalesOrderID DESC;
--FROM > WHERE > GROUP BY > HAVING > SELECT > ORDER BY

SELECT SalesOrderId, 
	SUM(UnitPrice) AS TotalUnitPricePerSale
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
HAVING SUM(UnitPrice) > 10000 --HAVING clause will execute aggregate function
ORDER BY SalesOrderID DESC;
--FROM > HAVING > GROUP BY > SELECT > ORDER BY

SELECT SalesOrderId, 
	SUM(UnitPrice) AS TotalUnitPricePerSale
FROM Sales.SalesOrderDetail
GROUP BY SalesOrderID
ORDER BY SalesOrderID DESC;
--FROM > GROUP BY > SELECT > ORDER BY

SELECT SalesOrderId 
	--SUM(UnitPrice) AS TotalUnitPricePerSale
FROM Sales.SalesOrderDetail
ORDER BY SalesOrderID DESC;
--FROM > SELECT > ORDER BY




--COMMON AGGREGATION FUNCTION
SELECT SalesOrderId, 
	COUNT(UnitPrice) AS CountPerUnitPrice,
	MAX(UnitPrice) AS Max_UnitPrice,
	MIN(UnitPrice) AS Min_UnitPrice,
	AVG(UnitPrice) AS Avg_UnitPrice
FROM sales.SalesOrderDetail
GROUP BY SalesOrderID


SELECT FirstName, 
	LEFT(FirstName,3) AS ExtractLeft,
	RIGHT(FirstName,3) AS ExtractRight,
	SUBSTRING(FirstName,3,4) AS ExtractSubstring --extracting starting from 3rd character and extract 4 character.
FROM Person.Person


--date
SELECT SalesOrderId, OrderDate, 
	DAY(OrderDate) AS Day_,
	MONTH(OrderDate) AS Month_,
	YEAR(OrderDate) AS Year_
FROM sales.SalesOrderHeader


SELECT CURRENT_TIMESTAMP;
SELECT GETDATE();




--query specific condition from a subset
SELECT PurchaseOrderID, EmployeeID 
FROM Purchasing.PurchaseOrderHeader
WHERE PurchaseOrderID = 4 -- query condition based from the 1st WHERE clause and not 2nd subset
	--(
	SELECT PurchaseOrderID
	FROM Purchasing.PurchaseOrderDetail
	WHERE PurchaseOrderID >= 5
	ORDER BY PurchaseOrderID ASC--2nd subset condition
	--')

--IN() function is to query all from condition
SELECT PurchaseOrderID, EmployeeID 
FROM Purchasing.PurchaseOrderHeader
WHERE PurchaseOrderID IN
	(
	SELECT PurchaseOrderID 
	FROM Purchasing.PurchaseOrderDetail
	WHERE PurchaseOrderID >= 5 --query will be based from the subset condition
	)


--UNION / UNION ALL function is combining tables by rows
SELECT BusinessEntityID FROM HumanResources.Employee
	UNION
SELECT BusinessEntityID FROM Person.Person
	UNION
SELECT CustomerID FROM Sales.Customer



--JOIN function is combining tables by columns
SELECT pod.PurchaseOrderID, pod.PurchaseOrderDetailID, poh.OrderDate --selecting the output columns
FROM Purchasing.PurchaseOrderDetail pod --location of the fisrt table where to get the PurchaseOrderID and PurchaseOrderDetailID column
	INNER JOIN
	Purchasing.PurchaseOrderHeader poh --location of second the table where to get the OrderDate column
	ON pod.PurchaseOrderID = poh.PurchaseOrderID --relating tables where PurchaseOrderID is the primary key

--LEFT JOIN (matching the left with the right table, if no match found from the right table then it will assign NULL)
SELECT p.BusinessEntityID, p.FirstName, p.LastName, bea.BusinessEntityID, bea.AddressID 
FROM Person.Person p--Left table
	LEFT JOIN --same with LEFT OUTER JOIN
	Person.BusinessEntityAddress bea -- Right table
	ON p.BusinessEntityID = bea.BusinessEntityID --relating tables is the primary key

--RIGHT JOIN (matching the right with the left table, if no match from the left table then it will be disraged or not going to be displayed)
SELECT p.BusinessEntityID, p.FirstName, p.LastName, bea.BusinessEntityID, bea.AddressID 
FROM Person.Person p--Left table
	RIGHT JOIN --same with RIGHT OUTER JOIN
	Person.BusinessEntityAddress bea -- Right table
	ON p.BusinessEntityID = bea.BusinessEntityID --relating tables is the primary key

--FULL JOIN (the same result using LEFT JOIN)

SELECT p.BusinessEntityID, p.FirstName, p.LastName, bea.BusinessEntityID, bea.AddressID 
FROM Person.Person p--Left table
	FULL JOIN --same with FULL OUTER JOIN
	Person.BusinessEntityAddress bea -- Right table
	ON p.BusinessEntityID = bea.BusinessEntityID --relating tables is the primary key



--CASE / WHEN function for (IF ELSE THEN)
SELECT ProductID,
	SUM(UnitPrice), --output column will have no column name
	UnitPriceDiscount,
	CASE 
		WHEN  UnitPriceDiscount > 0 THEN 'DISCOUNTED'
		WHEN UnitPriceDiscount = 0 THEN 'FIX PRICE'
		--ELSE when condition is not TRUE
		END AS if_discounted
FROM Sales.SalesOrderDetail
GROUP BY ProductID



select *
from sales.SalesOrderDetail



--THE SAME SAMPLE USE subquery 
select *,
	CASE 
		WHEN  TotalUnitPrice > 0 THEN 'DISCOUNTED'
		WHEN TotalUnitPrice = 0 THEN 'FIX PRICE'
		--ELSE when condition is not TRUE
	END AS if_discounted
from 
	(	select ProductID,
		sum(UnitPrice) as TotalUnitPrice,
		sum(UnitPriceDiscount) as TotalUnitPrice_Discount
		from sales.SalesOrderDetail
		group by ProductID) as subquery



--THE SAME SAMPLE USE With view AS() clause
WITH new_view AS (
	select ProductID,
		sum(UnitPrice) as TotalUnitPrice,
		sum(UnitPriceDiscount) as TotalUnitPrice_Discount
	from sales.SalesOrderDetail
	group by ProductID
)
select *,
		CASE 
		WHEN  TotalUnitPrice > 0 THEN 'DISCOUNTED'
		WHEN TotalUnitPrice = 0 THEN 'FIX PRICE'
		--ELSE when condition is not TRUE
	END AS if_discounted
from new_view




--dataset in not available so will be in comment
--WITH new_view AS (
	--SELECT CONCAT_WS("separator", price, room_type, host_since, zipcode) AS hostID,
	--number_of_reviews,
	--price,
	--CASE
		--WHEN number_of_reviews = 0 THEN 'New'
		--WHEN number_of_reviews BETWEEN 1 AND 5 THEN 'Rising'
		--WHEN number_of_reviews BETWEEN 6 AND 15 THEN 'Trending Up'
		--WHEN number_of_reviews BETWEEN 16 AND 40 THEN 'Popular'
		--WHEN number_of_reviews > 40 THEN 'Hot'
	--END AS host_popularity
	--FROM airbnb_host_search
	--GROUP BY 1, 2, 3
--SELECT host_popularity AS host_popularity_rating,
	--MIN(price) AS MIN_Price,
	--MAX(price) AS MAX_Price,
	--AVG(price) AS AVG_Price
--FROM new_view
--GROUP BY host_popularity_rating