--פרוייקט 2
--1
SELECT P.ProductID,P.Name,P.Color,P.ListPrice,P.Size
FROM Production.Product P 
WHERE P.ProductID not in (SELECT S.ProductID
							FROM Sales.SalesOrderDetail S)

update sales.customer set personid=customerid
 where customerid <=290
update sales.customer set personid=customerid+1700
 where customerid >= 300 and customerid<=350
update sales.customer set personid=customerid+1700
 where customerid >= 352 and customerid<=701
--2
SELECT C.CustomerID,P.LastName, P.FirstName
FROM Sales.Customer C LEFT JOIN Person.Person P
ON C.PersonID = P.BusinessEntityID
WHERE C.CustomerID not in (SELECT S.CustomerID
							FROM Sales.SalesOrderHeader S)
ORDER BY C.CustomerID

--3
SELECT C.CustomerID,P.LastName, P.FirstName, COUNT(O.SalesOrderID)
FROM Sales.Customer C LEFT JOIN Person.Person P
ON C.PersonID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader O
ON C.CustomerID = O.CustomerID
GROUP BY C.CustomerID,P.LastName, P.FirstName
ORDER BY COUNT(O.SalesOrderID) DESC
 OFFSET 0 ROWS  
    FETCH NEXT 10 ROWS ONLY

--4
SELECT P.LastName, P.FirstName, E.JobTitle, E.HireDate, COUNT(E.BusinessEntityID)over(partition by E.JobTitle) AS CountOfTitle
FROM Person.Person P JOIN HumanResources.Employee E
ON P.BusinessEntityID = E.BusinessEntityID

--5
CREATE VIEW OrdersLP
AS
SELECT  O.SalesOrderID,O.CustomerID,P.LastName, P.FirstName,MAX( O.OrderDate)OVER( partition by C.CustomerID) AS LastOrder
,LAG(O.OrderDate,0,0) over(partition by C.CustomerID order by O.OrderDate DESC) AS PreviousOrder
,ROW_NUMBER()OVER(PARTITION BY C.CustomerID ORDER BY O.OrderDate DESC) AS Row#
FROM Sales.Customer C LEFT JOIN Person.Person P
ON C.PersonID = P.BusinessEntityID
JOIN Sales.SalesOrderHeader O
ON C.CustomerID = O.CustomerID

SELECT O.SalesOrderID,O.CustomerID,O.LastName,O.FirstName,O.LastOrder,O.PreviousOrder
FROM OrdersLP O
WHERE Row# = 2
ORDER BY O.LastName, O.FirstName


--6
CREATE VIEW Sum_Order
AS
SELECT YEAR(O.OrderDate) AS Year,OD.SalesOrderID,P.LastName, P.FirstName
,SUM(OD.LineTotal) AS TOTAL
,ROW_NUMBER()OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY SUM(OD.LineTotal) DESC) AS Row#
FROM Sales.SalesOrderDetail OD JOIN Sales.SalesOrderHeader O
ON OD.SalesOrderID=o.SalesOrderID 
JOIN Sales.Customer C
ON O.CustomerID = C.CustomerID
JOIN Person.Person p
ON C.PersonID = P.BusinessEntityID
GROUP BY OD.SalesOrderID,P.LastName, P.FirstName,YEAR(O.OrderDate) 

SELECT Year,SalesOrderID,LastName,FirstName,TOTAL
FROM Sum_Order
WHERE Row# = 1

--7
SELECT MM,[2011],[2012],[2013],[2014]
FROM (SELECT YEAR(OrderDate) AS YY, MONTH(OrderDate) AS MM, SalesOrderID
		FROM Sales.SalesOrderHeader) o
PIVOT (COUNT(SalesOrderID) FOR YY IN ([2011],[2012],[2013],[2014]) ) pvt
ORDER BY MM

--8

SELECT 
    YEAR(o.OrderDate) AS Year, 
    CAST(MONTH(o.OrderDate)AS VARCHAR) AS Month, 
    SUM(od.LineTotal) AS Sum_price,
    SUM(SUM(od.LineTotal)) OVER (PARTITION BY YEAR(o.OrderDate) ORDER BY MONTH(o.OrderDate)) AS Money
FROM Sales.SalesOrderHeader o
JOIN Sales.SalesOrderDetail od ON o.SalesOrderID = od.SalesOrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)

UNION 

SELECT YEAR(H.OrderDate) AS Year,
'grand_total' AS Month,
NULL AS Sum_Price,
SUM(D.LineTotal) AS Money
FROM Sales.SalesOrderHeader H JOIN Sales.SalesOrderDetail D
ON H.SalesOrderID = D.SalesOrderID
GROUP BY YEAR(H.OrderDate)
ORDER BY Year,Money

--9
SELECT D.Name AS DepartmentName,ED.BusinessEntityID AS 'Employee''sId'
,P.FirstName + ' ' +P.LastName AS 'Employee''sFullName', ED.StartDate AS HireDate
,DATEDIFF(MM,ED.StartDate,GETDATE()) AS Seniority
,LEAD(P.FirstName + ' ' + P.LastName) OVER (PARTITION BY D.Name ORDER BY ED.StartDate DESC) AS PreviousEmpName
,LEAD(ED.StartDate) over(partition by D.Name ORDER BY ED.StartDate DESC) AS PreviousEmpHDate
,DATEDIFF(DD,LEAD(ED.StartDate) over(partition by D.Name ORDER BY ED.StartDate DESC),ED.StartDate) AS DiffDays
FROM HumanResources.Department D JOIN HumanResources.EmployeeDepartmentHistory ED
ON D.DepartmentID= ED.DepartmentID
JOIN Person.Person P
ON ED.BusinessEntityID = P.BusinessEntityID

--10
SELECT ED.StartDate, ED.DepartmentID,
    a = STUFF((
				 SELECT ',' + CAST(ED2.BusinessEntityID AS varchar) + ' ' + P.FirstName + ' ' + P.LastName
				 FROM HumanResources.EmployeeDepartmentHistory ED2 JOIN Person.Person P 
				 ON ED2.BusinessEntityID = P.BusinessEntityID
				 WHERE ED2.StartDate = ED.StartDate AND ED2.DepartmentID = ED.DepartmentID FOR XML PATH ('')), 1, 1, ''
               ) 
FROM HumanResources.EmployeeDepartmentHistory ED
GROUP BY ED.StartDate,ED.DepartmentID