/*-- UNPIVOT EN SQLSERVER --

Los operadores PIVOT y UNPIVOT de la instrucción Select permiten cambiar una expresión con valores 
de tabla en otra tabla donde las columnas de la tabla origen se transponen en la tabla destino.

PIVOT gira una expresión con valores de tabla al convertir los valores únicos de una columna en 
la expresión en varias columnas en la salida. PIVOT ejecuta agregaciones donde se requieren en 
los valores de columna restantes que se desean en la salida final.

UNPIVOT realiza la operación opuesta a PIVOT girando las columnas de una expresión con valores de 
tabla en valores de columna.

Sintaxis Select incluyendo Unpivot
SELECT …
FROM …
UNPIVOT (
FOR IN ( ) )
*/
USE Northwind
GO

/*EJERCICIO 01. Presentar los empleados y la cantidad de productos vendidos por categoría*/
SELECT CONCAT_WS(SPACE(1), e.FirstName, e.LastName) AS empleado,
	   c.CategoryName AS categoria, SUM(od.Quantity) AS cantidad, YEAR(o.OrderDate) AS anio
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY CONCAT_WS(SPACE(1), e.FirstName, e.LastName), c.CategoryName, YEAR(o.OrderDate)
ORDER BY empleado, cantidad DESC
GO

--Generar para facilidad una tabla con las ventas anteriores. Puede usar CTE
--Luego muestre las ventas de cada empleado por año usando PIVOT
WITH ventas_empleados_anio_categoria
AS(SELECT CONCAT_WS(SPACE(1), e.FirstName, e.LastName) AS empleado,
	   c.CategoryName AS categoria, SUM(od.Quantity) AS cantidad, YEAR(o.OrderDate) AS anio
	FROM Orders AS o
		INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	GROUP BY CONCAT_WS(SPACE(1), e.FirstName, e.LastName), c.CategoryName, YEAR(o.OrderDate))
SELECT * 
FROM ventas_empleados_anio_categoria
PIVOT(SUM(cantidad) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
GO

--Mostrar ahora de las categorías Beverages, Condiments y Confections
WITH ventas_empleados_anio_categoria
AS(SELECT CONCAT_WS(SPACE(1), e.FirstName, e.LastName) AS empleado,
	   c.CategoryName AS categoria, SUM(od.Quantity) AS cantidad, YEAR(o.OrderDate) AS anio
	FROM Orders AS o
		INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	GROUP BY CONCAT_WS(SPACE(1), e.FirstName, e.LastName), c.CategoryName, YEAR(o.OrderDate))
SELECT * 
FROM ventas_empleados_anio_categoria
PIVOT(SUM(cantidad) FOR categoria IN([Beverages], [Condiments], [Confections])) AS tabla_pivot
GO

--USANDO EL OPERADOR UNPIVOT

/*EJERCICIO 02. Listado de clientes y sus compras por año. Para las compras se va a usar
una FDU, puede ser también una subconsulta*/

-- La FDU para el cálculo de las compras de cada cliente por Año. 
CREATE OR ALTER FUNCTION fdu_compra_cliente_por_anio(@cod_cliente NCHAR(5), @anio INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		RETURN (SELECT SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount))
				FROM Orders AS o
					INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
					INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
				WHERE YEAR(o.OrderDate) = @anio AND c.CustomerID = @cod_cliente)
	END
GO

SELECT dbo.fdu_compra_cliente_por_anio('ANATR', 1996)
GO

--La instrucción del total de compras por cliente por año
SELECT c.CompanyName AS cliente, 
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1996), 0) AS [1996],
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1997), 0) AS [1997],
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1998), 0) AS [1998]
FROM Customers AS c
GO

--Generando una tabla (no es necesario, pero es más sencillo)
DROP TABLE IF EXISTS compras_por_cliente_anio
SELECT c.CompanyName AS cliente, 
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1996), 0) AS [1996],
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1997), 0) AS [1997],
		ISNULL(dbo.fdu_compra_cliente_por_anio(c.CustomerID, 1998), 0) AS [1998]
INTO compras_por_cliente_anio
FROM Customers AS c
GO

SELECT * 
FROM compras_por_cliente_anio
GO

--Ahora usando UNPIVOT
--Se va a mostrar los clientes y luego los años y las cantidades
SELECT cliente, anio, totales 
FROM compras_por_cliente_anio AS c
UNPIVOT(totales FOR anio IN([1996], [1997], [1998])) AS tabla_unpivot
GO

/*EJERCICIO 04. Listado de empleados y sus ventas por año.
Para las ventas se va a usar una subconsulta, generando la tabla compras_por_empleado_anio*/

SELECT CONCAT_WS(' ', e.FirstName, e.LastName) AS empleado,
	   FORMAT(ISNULL((SELECT SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount))
		FROM Orders AS o
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Employees AS emp ON(o.EmployeeID = emp.EmployeeID)
		WHERE emp.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1996), 0), '###,##.00') AS '1996',
		FORMAT(ISNULL((SELECT SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount))
		FROM Orders AS o
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Employees AS emp ON(o.EmployeeID = emp.EmployeeID)
		WHERE emp.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997), 0), '###,##.00') AS '1997',
		FORMAT(ISNULL((SELECT SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount))
		FROM Orders AS o
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Employees AS emp ON(o.EmployeeID = emp.EmployeeID)
		WHERE emp.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1998), 0), '###,##.00') AS '1998'
INTO compras_empleado_por_anio
FROM Employees AS e
GO

SELECT * 
FROM compras_empleado_por_anio
GO

--Ahora, usando UNPIVOT presentar los clientes y de cada cliente los años y sus totales.
SELECT empleado, anio, totales 
FROM compras_empleado_por_anio
UNPIVOT(totales FOR anio IN([1996], [1997], [1998])) AS tabla_unpivot
GO