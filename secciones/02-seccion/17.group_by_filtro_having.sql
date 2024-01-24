/*-- AGRUPAMIENTOS SQL SERVER - GROUP BY - FILTROS HAVING --

Los agrupamientos en SQL Server se utilizan cuando en un listado existen funciones de agregado en algunos campos 
con campos que no las tienen.

Generalmente los agrupamientos se utilizan para mostrar resultados estadísticos con datos de varias tablas 
(Ver Listado con Joins). También en muchas ocasiones se puede hacer el listado usando Subconsultas 
(Ver Subconsultas). Puede usar el Plan de ejecución para analizar cual de las opciones es la mejor según 
el diseño de las tablas utilizadas.
*/

USE Northwind
GO

/*EJERCICIO 01. Listar las categorías y la cantidad de productos que tiene.*/

--Usando subconsultas
SELECT CategoryID, CategoryName, 
	   (SELECT COUNT(*) 
	    FROM Products AS p
		WHERE p.CategoryID = c.CategoryID) AS [ProductCount]
FROM Categories AS c
GO

--Usando agrupamientos
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID) AS [ProductCount]
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GROUP BY c.CategoryID, c.CategoryName
GO

--NOTE: que los campos que no tienen función de agregado deben incluirse en la cláusula GROUP BY

/*EJERCICIO 02. Listado de los empleados y la cantidad de órdenes generadas y el monto total de las
órdenes*/
SELECT e.EmployeeID, e.FirstName + SPACE(1) + e.LastName AS [empleado],
	   COUNT(o.OrderID) AS [OrderCount], 
	   SUM(o.Freight) AS [Total]
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY empleado
GO

/*EJERCICIO 03. Ordenar la orden anterior por cantidad de órdenes*/
SELECT e.EmployeeID, e.FirstName + SPACE(1) + e.LastName AS [empleado],
	   COUNT(o.OrderID) AS [OrderCount], 
	   SUM(o.Freight) AS [Total]
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY [OrderCount] DESC
GO

/*EJERCICIO 04. Para listar los que tienen más de 100 órdenes únicamente. Se utiliza en filtrado con HAVING*/
SELECT e.EmployeeID, e.FirstName + SPACE(1) + e.LastName AS [empleado],
	   COUNT(o.OrderID) AS [OrderCount], 
	   SUM(o.Freight) AS [Total]
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
HAVING COUNT(o.OrderID) > 100
ORDER BY [OrderCount] DESC
GO

/*EJERCICIO 05. Los productos de categorías 3, 5, 6 y 8 y la cantidad vendida de cada uno, incluir el código
y descripción de la categoría*/
SELECT P.ProductID, p.ProductName AS producto, c.CategoryID, c.CategoryName,
		SUM(od.Quantity) AS 'cantidad vendida'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
	INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
WHERE c.CategoryID IN(3, 5, 6, 8)
GROUP BY P.ProductID, p.ProductName, c.CategoryID, c.CategoryName
GO

/*EJERCICIO 06. Filtrar por la cantidad vendida, por ejemplo productos con más de 600 unidades vendidas*/
SELECT P.ProductID, p.ProductName AS producto, c.CategoryID, c.CategoryName,
		SUM(od.Quantity) AS 'cantidad vendida'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
	INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
WHERE c.CategoryID IN(3, 5, 6, 8)
GROUP BY P.ProductID, p.ProductName, c.CategoryID, c.CategoryName
HAVING SUM(od.Quantity) > 600
ORDER BY c.CategoryID ASC, [cantidad vendida] DESC
GO