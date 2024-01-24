/*-- PIVOT Y PROCEDIMIENTOS ALMACENADOS --

Las operaciones con Pivot nos permitirá convertir los resultados de una consulta que se presentan en 
filas y mostrarlos en columnas. Pivot utiliza las funciones de agregado para presentar los datos en 
columnas. 
En este artículo se presentan varios ejercicios usando el operador Pivot usando procedimientos 
almacenados para hacer las consultas dinámicas.

Los operadores relacionales PIVOT y UNPIVOT cambian una expresión con valores de tabla en otra tabla. 

PIVOT rota una expresión con valores de tabla convirtiendo los valores únicos de una columna en 
la expresión en varias columnas en la salida.

UNPIVOT realiza la operación opuesta a PIVOT al rotar columnas de una expresión con valores de 
tabla en valores de columna.
*/

USE Northwind
GO

/*EJERCICIO 01. Mostrar las ventas de los productos por cada mes en un año determinado. 
El procedimiento almacenado recibe el año como parámetro.*/
CREATE OR ALTER PROCEDURE sp_total_ventas_por_mes_anio(@anio INT)
AS
	BEGIN
		WITH ventas(producto, mes, cantidad)
		AS(SELECT p.ProductName, MONTH(o.OrderDate), SUM(od.Quantity)
		   FROM Products AS p
				INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
				INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
		   WHERE YEAR(o.OrderDate) = @anio
		   GROUP BY p.ProductName, MONTH(o.OrderDate))
		SELECT producto, ISNULL([1], 0) Ene, ISNULL([2], 0) Feb, ISNULL([3], 0) Mar, ISNULL([4], 0) Abr, 
						 ISNULL([5], 0) May, ISNULL([6], 0) Jun, ISNULL([7], 0) Jul, ISNULL([8], 0) Ago, 
						 ISNULL([9], 0) Sep, ISNULL([10], 0) Oct, ISNULL([11], 0) Nov, ISNULL([12], 0) Dic
		FROM ventas
		PIVOT(SUM(cantidad) FOR mes IN([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])) AS tabla_pivot
	END
GO

EXECUTE sp_total_ventas_por_mes_anio 1996
GO

/*EJERCICIO 02. Listado de las ventas en unidades monetarias por categoría y por año*/
CREATE OR ALTER PROCEDURE sp_ventas_totales_categoria_anio
AS
	BEGIN
		WITH ventas_totales_categoria(codigo, categoria, anio, total)
		AS(SELECT c.CategoryID, c.CategoryName, YEAR(o.OrderDate), SUM(od.Quantity*od.UnitPrice)
			FROM Orders AS o
				INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
				INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
				INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
			GROUP BY c.CategoryID, c.CategoryName, YEAR(o.OrderDate))
		SELECT * 
		FROM ventas_totales_categoria
		PIVOT(SUM(total) FOR anio IN([1996],[1997],[1998])) AS tabla_pivot
	END
GO

EXECUTE sp_ventas_totales_categoria_anio
GO

/*EJERCICIO 03. Total de ventas monetaria de un producto por año.*/
CREATE OR ALTER PROCEDURE sp_ventas_por_producto(@cod_producto INT)
AS
	BEGIN
		WITH ventas_por_producto([cód. categoria], categoria, producto, anio, total)
		AS(SELECT c.CategoryID, c.CategoryName, p.ProductName, YEAR(o.OrderDate), SUM(od.Quantity * od.UnitPrice)
			FROM Orders AS o
				INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
				INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
				INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
			WHERE p.ProductID = @cod_producto
			GROUP BY  c.CategoryID, c.CategoryName, p.ProductName, YEAR(o.OrderDate))
		SELECT * 
		FROM ventas_por_producto
		PIVOT(SUM(total) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
	END
GO

EXECUTE sp_ventas_por_producto 5
GO

/*EJERCICIO 04. Total vendido por empleado por mes en un determinado año*/
CREATE OR ALTER PROCEDURE sp_total_ventas_por_empleado_mes_anio(@anio INT)
AS
	BEGIN
		WITH total_ventas_empleado
		AS(SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado, 
				DATEPART(MONTH, o.OrderDate) AS mes,
				SUM(od.Quantity * od.UnitPrice) AS total
			FROM Orders AS o
				INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
				INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
			WHERE YEAR(o.OrderDate) = @anio 
			GROUP BY CONCAT_WS(' ', e.LastName, e.FirstName), DATEPART(MONTH, o.OrderDate))
		SELECT empleado, 
				ISNULL([1], 0) AS 'Ene', ISNULL([2], 0) AS 'Feb', ISNULL([3], 0) AS 'Mar', 
				ISNULL([4], 0) AS 'Abr', ISNULL([5], 0) AS 'May', ISNULL([6], 0) AS 'Jun', 
				ISNULL([7], 0) AS 'Jul', ISNULL([8], 0) AS 'Aag', ISNULL([9], 0) AS 'Sep', 
				ISNULL([10], 0) AS 'Oct', ISNULL([11], 0) AS 'Nov', ISNULL([12], 0) AS 'Dic'
		FROM total_ventas_empleado
		PIVOT(SUM(total) FOR mes IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS tabla_pivot
	END
GO

EXECUTE sp_total_ventas_por_empleado_mes_anio 1997
GO

/*
Obtener los valores de un campo encerrados entre corchetes
Para obtener los valores de un campo encerrados entre corchetes se va a crear una variable 
para almacenar en esta los valores.
*/

/*EJERCICIO 05. Obtener las descripciones de las categorías en una variable tipo cadena. 
Esta cadena de caracteres se usará junto con el operador PIVOT para realizar la comparación usando 
el operador IN.*/
DECLARE @categorias VARCHAR(MAX) = ''
SELECT @categorias += QUOTENAME(CategoryName) + ','
FROM Categories
ORDER BY CategoryName
SET @categorias = LEFT(@categorias, LEN(@categorias) - 1)
SELECT @categorias
GO

/*EJERCICIO 06. Obtener las descripciones de los productos de la categoría 6*/
DECLARE @productos VARCHAR(MAX) = ''
SELECT @productos += QUOTENAME(p.ProductName) + ','
FROM Products AS p
WHERE p.CategoryID = 6
ORDER BY p.ProductName
SET @productos = LEFT(@productos, LEN(@productos) - 1)
PRINT @productos
GO

/*EJERCICIO 07. Las ventas de los productos (cantidad) de una categoría en cada año.
Para el ejemplo se va a usar los datos de la categoría 6*/
WITH ventas_producto_anio
AS(SELECT p.ProductName AS producto, YEAR(o.OrderDate) AS anio, SUM(od.Quantity) AS cantidad
	FROM Products AS p
		INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
		INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	WHERE p.CategoryID = 6
	GROUP BY p.ProductName, YEAR(o.OrderDate))
SELECT * 
FROM ventas_producto_anio
PIVOT(SUM(cantidad) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
GO

--El procedimiento al macenado para cualquier categoría
CREATE OR ALTER PROCEDURE sp_ventas_productos_categoria_anio(@cod_categoria INT)
AS
	BEGIN
		WITH ventas_producto_anio
		AS(SELECT p.ProductName AS producto, YEAR(o.OrderDate) AS anio, SUM(od.Quantity) AS cantidad
			FROM Products AS p
				INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
				INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
			WHERE p.CategoryID = @cod_categoria
			GROUP BY p.ProductName, YEAR(o.OrderDate))
		SELECT * 
		FROM ventas_producto_anio
		PIVOT(SUM(cantidad) FOR anio IN([1996], [1997], [1998])) AS tabla_pivot
	END
GO

EXECUTE sp_ventas_productos_categoria_anio 6
GO

--Ahora se va a mostrar los productos como encabezados de columna
--Para generar la cadena con los productos solo de la categoría 6 (como ejemplo) se usa
--el siguiente código
DECLARE @productos VARCHAR(MAX) = ''
SELECT @productos += QUOTENAME(p.ProductName) + ','
FROM Products AS p
WHERE p.CategoryID = 6
ORDER BY p.ProductName
SET @productos = LEFT(@productos, LEN(@productos) - 1)
SELECT @productos
GO

/*El código anterior genera esta cadena.
[Alice Mutton],[Mishi Kobe Niku],[Pâté chinois],[Perth Pasties],[Thüringer Rostbratwurst],[Tourtière]
*/
--Si se reemplaza la cadena en el operador PIVOT
SELECT * 
FROM (SELECT p.ProductName AS producto, YEAR(o.OrderDate) AS anio, SUM(od.Quantity) AS cantidad
		FROM Products AS p
			INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
			INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
		WHERE p.CategoryID = 6
		GROUP BY p.ProductName, YEAR(o.OrderDate)) AS tabla
PIVOT(SUM(cantidad) FOR producto IN([Alice Mutton],[Mishi Kobe Niku],[Pâté chinois],[Perth Pasties],[Thüringer Rostbratwurst],[Tourtière])) AS tabla_pivot
GO

--Ahora, usando la cadena generada en una instrucción SQL
DECLARE @instruccion VARCHAR(MAX)
DECLARE @productos VARCHAR(MAX) = ''
SELECT @productos += QUOTENAME(p.ProductName) + ','
FROM Products AS p
WHERE p.CategoryID = 6
ORDER BY p.ProductName
SET @productos = LEFT(@productos, LEN(@productos) - 1)
SET @instruccion = 
'SELECT * 
FROM (SELECT p.ProductName AS producto, YEAR(o.OrderDate) AS anio, SUM(od.Quantity) AS cantidad
		FROM Products AS p
			INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
			INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
		WHERE p.CategoryID = 6
		GROUP BY p.ProductName, YEAR(o.OrderDate)) AS tabla
PIVOT(SUM(cantidad) FOR producto IN(' + @productos + ')) AS tabla_pivot';
EXECUTE(@instruccion)
GO

--Creando un SP para hacerlo dinámico, para los productos de cualquier categoría
CREATE OR ALTER PROCEDURE sp_ventas_productos_categoria_anio(@cod_categoria INT)
AS
	BEGIN
		DECLARE @instruccion VARCHAR(MAX)
		DECLARE @productos VARCHAR(MAX) = ''
		SELECT @productos += QUOTENAME(p.ProductName) + ','
		FROM Products AS p
		WHERE p.CategoryID = @cod_categoria
		ORDER BY p.ProductName
		SET @productos = LEFT(@productos, LEN(@productos) - 1)
		SET @instruccion = 
		'SELECT * 
		FROM (SELECT p.ProductName AS producto, YEAR(o.OrderDate) AS anio, SUM(od.Quantity) AS cantidad
				FROM Products AS p
					INNER JOIN [Order Details] AS od ON(p.ProductID = od.ProductID)
					INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
				WHERE p.CategoryID = ' + STR(@cod_categoria) + '
				GROUP BY p.ProductName, YEAR(o.OrderDate)) AS tabla
		PIVOT(SUM(cantidad) FOR producto IN(' + @productos + ')) AS tabla_pivot';
		EXECUTE(@instruccion)
	END
GO

EXECUTE sp_ventas_productos_categoria_anio 4
GO

