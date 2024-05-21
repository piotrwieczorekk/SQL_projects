USE AdventureWorks2022



--- Get the count of female and male workers for each JobTitle
--- Then get the sum of all workers for each JobTitle
--- Calculate the GenderShare (percentage of female and male workers) for each JobTitle
--- Store it as a View

CREATE VIEW [GenderShareView] AS 
SELECT 
	t2.*,
	CAST(t2.JobTitleCount AS DECIMAL(8,2)) / CAST(t2.JobTitleSum AS DECIMAL(8,2)) AS GenderShare
FROM (
SELECT 
	t1.*,
	SUM(t1.JobTitleCount) OVER(PARTITION BY JobTitle) AS JobTitleSum
FROM (
SELECT 
	JobTitle,
	Gender,
	COUNT(JobTitle) AS JobTitleCount
FROM 
	[HumanResources].[Employee]
GROUP BY 
	JobTitle, Gender) t1 ) t2

--- Create a Stored Procedure based on the View to filter JobTitle given by the user

CREATE OR ALTER PROCEDURE [GenderShareProcedure] @Job VARCHAR(50)
AS
SELECT * FROM [GenderShareView]
WHERE JobTitle = @Job

--- Get the result for female and male Accountants

EXEC [GenderShareProcedure] @Job = 'Accountant'


--- Get Sum of OrderQty and LineTotal by TerritoryID and ProductID

SELECT
	t4.*,
	t5.[Name],
	t5.CountryRegionCode,
	t5.[Group]
FROM (
SELECT 
	t3.TerritoryID,
	t3.ProductID,
	SUM(t3.OrderQty) AS OrderQtySumByProduct,
	CAST(SUM(t3.LineTotal) AS DECIMAL(8,2)) AS SumLineTotalByProduct
FROM (
SELECT 
	t1.SalesOrderID,
	t1.OrderDate,
	t1.CustomerID,
	t1.TerritoryID,
	t1.TotalDue,
	YEAR(t1.OrderDate) AS OrderDateYear,
	MONTH(t1.OrderDate) AS OrderDateMonth,
	t2.ProductID,
	t2.OrderQty,
	t2.LineTotal
FROM
	[Sales].[SalesOrderHeader] t1
RIGHT JOIN 
(SELECT 
	SalesOrderID,
	ProductID,
	OrderQty,
	LineTotal
FROM
	[Sales].[SalesOrderDetail]) t2
ON 
	t1.SalesOrderID = t2.SalesOrderID) t3
GROUP BY 
	t3.TerritoryID, t3.ProductID ) t4
INNER JOIN 
	[Sales].[SalesTerritory] t5
ON 
	t4.TerritoryID = t5.TerritoryID
ORDER BY 
	TerritoryID, ProductID


-- This time the goal was to picture average hourly salary by job title, gender and city.
-- In order to do that, I created a view that would obtain information regarding current workers' salaries
-- with help of window functions
-- In the second query, previously created view was used in an inner join clause and the data was aggregated to show
-- average hourly salary grouped by several variables

CREATE VIEW[LastSalary] AS
SELECT
	t1.*
FROM (
SELECT
	*,
	FIRST_VALUE(Rate) OVER(PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC) AS LastRate,
	ROW_NUMBER() OVER(PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC) AS RankRate
FROM 
	[HumanResources].[EmployeePayHistory] ) t1
WHERE
	t1.RankRate = 1


SELECT * FROM LastSalary

SELECT
	t4.JobTitle,
	t4.Gender,
	t4.City,
	AVG(SalaryHourlyRate) AS AvgSalaryHourlyRate
FROM (
SELECT
	t1.BusinessEntityID,
	t1.City,
	t1.JobTitle,
	t2.Gender,
	t3.LastRate AS SalaryHourlyRate
FROM 
	[HumanResources].[vEmployee] t1
INNER JOIN
	[HumanResources].[Employee] t2
ON
	t1.BusinessEntityID = t2.BusinessEntityID
INNER JOIN
	[LastSalary] t3
ON 
	t1.BusinessEntityID = t3.BusinessEntityID) t4
GROUP BY
	t4.JobTitle, t4.City, t4.Gender