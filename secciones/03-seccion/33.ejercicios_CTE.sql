/*-- CONSTRUYENDO CTE EN SQLSERVER --*/

USE Northwind
GO

/*EJERCICIO 01. Crear una CTE para las órdenes no atendidas en 1998, incluir el nombre del cliente y 
el empleado */
SELECT o.OrderID, o.OrderDate, CONCAT_WS(SPACE(1), e.LastName, e.FirstName) AS empleado,
	   c.CompanyName AS cliente
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
WHERE o.ShippedDate IS NULL AND YEAR(o.OrderDate) = 1998
GO

--Para crear una CTE se puede especificar un nombre para cada uno de los campos de la consulta
WITH ordenes_no_atendidas_1998([cod. orden], fecha, empleado, cliente)
AS
	(SELECT o.OrderID, o.OrderDate, CONCAT_WS(SPACE(1), e.LastName, e.FirstName) AS empleado,
	   c.CompanyName AS cliente
	FROM Orders AS o
		INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
		INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	WHERE o.ShippedDate IS NULL AND YEAR(o.OrderDate) = 1998)
SELECT * 
FROM ordenes_no_atendidas_1998
GO

/*EJERCICIO 03. Crear una CTE para los clientes, la cantidad de órdenes y el total de cada orden.
La cantidad de órdenes y el total de cada orden obtenerlas usando una FDU. */

--La función definida por el usaurio que devuelve la cantidad de órdenes
CREATE OR ALTER FUNCTION fdu_cantidad_ordenes_cliente(@codigo_cliente CHAR(5))
RETURNS INT
AS
	BEGIN	
		RETURN (SELECT COUNT(o.OrderID) 
				FROM Orders AS o
				WHERE o.CustomerID = @codigo_cliente)
	END
GO

--Función definida por el usaurio que devuelve el total de cada orden
CREATE OR ALTER FUNCTION fdu_total_orden(@cod_orden INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		RETURN (SELECT SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount))
				FROM [Order Details] AS od
				WHERE od.OrderID = @cod_orden)
	END
GO

--La CTE para este ejercicio es como sigue
WITH clientes_ventas([Cod. cliente], cliente, pais, [cantidad órdenes], [monto total])
AS
	(SELECT c.CustomerID, c.CompanyName, c.Country, 
			dbo.fdu_cantidad_ordenes_cliente(c.CustomerID) AS 'Cantidad órdenes',
			SUM(dbo.fdu_total_orden(o.OrderID)) AS 'Monto total en órdenes'
	 FROM Orders AS o 
		INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	 GROUP BY c.CustomerID, c.CompanyName, c.Country, dbo.fdu_cantidad_ordenes_cliente(c.CustomerID))
SELECT * 
FROM clientes_ventas
GO

/*EJERCICIO 04. Creando una CTE sin especificar el nombre de las columnas.
En este ejercicio se va a listar los productos y luego usando una CTE listar 
los productos con precios entre 20 y 50 ordenados por precio descendente.*/
WITH productos2050
AS
	(SELECT p.ProductID, p.ProductName, p.UnitPrice
	 FROM Products AS p)
SELECT * 
FROM productos2050 
WHERE UnitPrice BETWEEN 20 AND 50
ORDER BY UnitPrice DESC
GO

/*EJERCICIO 05. CTE para una relación recursiva. 
En este ejercicio se van a listar los empleados y sus subordinados*/
WITH reporte_jefe([cod. jefe], apellido, nombre)
AS
	(SELECT e.EmployeeID, e.LastName, e.FirstName
	FROM Employees AS e)
SELECT [cod. jefe], CONCAT_WS(SPACE(1), j.nombre, j.apellido) AS jefe,
		e.EmployeeID AS [cod. empleado], CONCAT_WS(SPACE(1), e.FirstName, e.LastName) AS empleado 
FROM reporte_jefe AS j 
	INNER JOIN Employees AS e ON(j.[cod. jefe] = e.ReportsTo)
GO


/*EJERCICIO 06. Listar los clientes y el total de compras por año. 
En este ejercicio vamos a usar una CTE para realizar un Pivot. 
Se van a usar la FDU del ejercicio 3 que calcula el total de la orden.*/
WITH clientes_ventas([cod. cliente], cliente, anio, [monto total])
AS
	(SELECT c.CustomerID, c.CompanyName, YEAR(o.OrderDate), SUM(dbo.fdu_total_orden(o.OrderID)) AS total
	 FROM Customers AS c
			INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
	 GROUP BY c.CustomerID, c.CompanyName, YEAR(o.OrderDate))
SELECT * 
FROM clientes_ventas AS cv
	PIVOT(SUM([monto total])
FOR anio IN([1996], [1997], [1998])) pvt
GO

/*EJERCICIO 07. Listar los clientes y la cantidad de órdenes por año.
En este ejercicio vmos a usar una CTE para realizar n PIVOT.
Se van a usar la FDU del ejercicio 3 que calcula la cantidad de órdenes*/
WITH clients_venta([cód cliente], cliente, anio, [cantidad órdenes])
AS
	(SELECT c.CustomerID, c.CompanyName, YEAR(o.OrderDate), COUNT(dbo.fdu_cantidad_ordenes_cliente(c.CustomerID))
	 FROM Customers AS c
		 INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
	 GROUP BY c.CustomerID, c.CompanyName, YEAR(o.OrderDate))
SELECT * 
FROM clients_venta AS cv
PIVOT(SUM([cantidad órdenes])
	  FOR anio IN([1996], [1997], [1998])) pvt
GO