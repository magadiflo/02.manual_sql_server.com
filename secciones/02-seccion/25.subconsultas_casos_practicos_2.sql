/*-- SUBCONSULTAS SQL SERVER - CASOS PRÁCTICOS 2 --*/
USE Northwind
GO

/*EJERCICIO 01. Listar los proveedores que no tienen asignado una región, incluir la cantidad
de productos que provee*/

--Costo estimado de subárbol:  0.0097808
SELECT s.SupplierID AS 'código proveedor', s.CompanyName AS 'nombre',
	   (SELECT COUNT(p.ProductID) 
	    FROM Products AS p
		WHERE p.SupplierID = s.SupplierID) AS 'cantidad de productos'
FROM Suppliers AS s
WHERE s.Region IS NULL
GO

--Usando JOINS
--Costo estimado de subárbol: 0.0100537
SELECT s.SupplierID, s.CompanyName, COUNT(p.ProductID) AS 'cantidad de productos'
FROM Suppliers AS s
	INNER JOIN Products AS p ON(s.SupplierID = p.SupplierID)
WHERE s.Region IS NULL
GROUP BY s.SupplierID, s.CompanyName
GO
--Note que con el uso de JOINS el costo es mayor

/*EJERCICIO 02. Clientes de MÉxico, incluyan la cantidad de órdenes, el monto total de 
las órdenes*/

--Costo estimado de subárbol:  0.0411628
SELECT c.customerID, c.CompanyName, 
	   (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
	    WHERE o.CustomerID = c.CustomerID) AS 'cantidad de órdenes',
		(SELECT SUM(o.Freight)
	    FROM Orders AS o
	    WHERE o.CustomerID = c.CustomerID) AS 'monto total'
FROM Customers AS c
WHERE c.Country = 'Mexico'
GO

--Usando JOINS
--Costo estimado de subárbol: 0.0532825
SELECT c.customerID, c.CompanyName, COUNT(o.OrderID) AS 'cantidad de órdenes',
		SUM(o.Freight) AS 'monto total'
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE c.Country = 'Mexico'
GROUP BY c.customerID, c.CompanyName
GO

/*EJERCICIO 03. Productos vendidos en agosto de 1997, incluir la cantidad ventidad y el monto total*/
SELECT DISTINCT od.ProductID, 
	   (SELECT p.ProductName 
	    FROM Products AS p
		WHERE p.ProductID = od.ProductID) AS 'producto',
	   (SELECT SUM(ods.Quantity)
	    FROM [Order Details] AS ods
		WHERE ods.ProductID = od.ProductID AND
			  ods.OrderID IN(SELECT o.OrderID
					FROM Orders AS o
					WHERE MONTH(o.OrderDate) = 8 AND YEAR(o.OrderDate) = 1997)) AS 'cantidad',
		(SELECT SUM(ods.Quantity * ods.UnitPrice)
	    FROM [Order Details] AS ods
		WHERE ods.ProductID = od.ProductID AND
			  ods.OrderID IN(SELECT o.OrderID
					FROM Orders AS o
					WHERE MONTH(o.OrderDate) = 8 AND YEAR(o.OrderDate) = 1997)) AS 'monto total'
FROM [Order Details] AS od
WHERE od.OrderID IN(SELECT o.OrderID
					FROM Orders AS o
					WHERE MONTH(o.OrderDate) = 8 AND YEAR(o.OrderDate) = 1997)
ORDER BY od.ProductID
GO