/*-- PIVOT SQL SERVER --

Las operaciones con Pivot nos permitirá convertir los resultados de una consulta que se presentan en 
filas y mostrarlos en columnas.
Pivot utiliza las funciones de agregado para presentar los datos en columnas. Para información de 
las funciones de agregado Ver Funciones de agregado.
*/

/*EJERCICIO 01. En el siguiente ejemplo se va a crear una base de datos, en ella una tabla Ventas, 
insertar registros con los datos de tres clientes de los cuales se han registrado varias ventas. 
Luego se mostrará los resultados en columnas de acuerdo al artículo vendido.*/

CREATE DATABASE bd_prueba_pivot
GO

USE bd_prueba_pivot
GO

CREATE TABLE ventas(
	cliente VARCHAR(50),
	producto VARCHAR(50),
	cantidad NUMERIC(9,2)
)
GO

INSERT INTO ventas(cliente, producto, cantidad)
VALUES('Carla', 'Teclado', 10),
('Pedro', 'Monitor', 12),
('Carla', 'Monitor', 6),
('Carla', 'Mouse', 24),
('Pedro', 'Teclado', 16),
('José', 'Monitor', 22),
('José', 'Teclado', 3),
('Carla', 'Teclado', 42),
('Pedro', 'Mouse', 34),
('José', 'Mouse', 10),
('Pedro', 'Teclado', 10)
GO

--Haciendo la consulta de los datos de venta, se presenta ordenado por cliente para mejor rendimiento
SELECT *
FROM ventas
ORDER BY cliente
GO

/*
Note que Carla ha comprado diferentes productos, así como también José y Pedro. En la imagen se 
resalta la cantidad total comprada de Teclados por Carla. Esta es la suma de el registro 1 y el 
registro 4.
*/

--PIVOT permitirá mostrar por cada cliente, cuántos teclados, monitores y mouses compraron
SELECT * 
FROM ventas
PIVOT(SUM(cantidad) FOR producto IN([Monitor], [Mouse], [Teclado])) AS tabla_pivot
GO

/*EJERCICIO 02. Presentar los clientes y las compras por año*/
USE Northwind
GO

/*La ejecución de la siguiente consulta muestra el resultado, muestra dentro del
conjunto de resultados el del cliente «Ana Trujillo Emparedados y helados» para 
luego mostrar los resultados usando el operador Pivot.*/
SELECT c.CompanyName AS cliente, YEAR(o.OrderDate) AS anio, 
	   ISNULL(SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount)), 0) AS importe
FROM Customers AS c
	INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
GROUP BY c.CompanyName, YEAR(o.OrderDate)
ORDER BY cliente, anio

/*Para hacer más sencilla la lectura de la consulta, se utilizará una expresión
de tabla común Common Table Expression (CTE), recuerd de que se utiliza en el mismo lote.*/
WITH ventas(cliente, anio, importe) 
AS (SELECT c.CompanyName, 
		   YEAR(o.OrderDate), 
		   ISNULL(SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount)), 0)
	FROM Customers AS c
		INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
		INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	GROUP BY c.CompanyName, YEAR(o.OrderDate))
SELECT * 
FROM ventas
PIVOT(SUM(importe) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
GO


/*EJERCICIO 03. Empleados y las órdenes generadas por año.*/
WITH total_ordenes(empleado, anio, cant_ordenes)
AS (SELECT CONCAT_WS(SPACE(1), e.LastName, e.FirstName),
		   DATEPART(YEAR, o.OrderDate),
		   COUNT(o.OrderID)
	FROM Orders AS o
		INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	GROUP BY CONCAT_WS(SPACE(1), e.LastName, e.FirstName), DATEPART(YEAR, o.OrderDate))
SELECT * 
FROM total_ordenes
PIVOT(SUM(cant_ordenes) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
GO