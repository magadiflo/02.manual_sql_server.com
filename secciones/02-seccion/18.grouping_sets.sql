/*-- USO DE GROUPING SETS EN SQL SERVER --

Los agrupamiento en SQL Server permiten mostrar un conjunto de resultados donde una o mas columnas que se 
muestran es el resultado del uso de alguna de las funciones de agregado que calculan suma, promedio,
máximo, mínimo, etc.

Los agrupamiento en SQL Server permiten mostrar un conjunto de resultados donde una o mas columnas que se 
muestran es el resultado del uso de alguna de las funciones de agregado que calculan suma, promedio,
máximo, mínimo, etc.

Si se desea mostrar mas de un agrupamiento en el mismo conjunto de resultado se deberá usar los Grouping Sets,
estos son similares al uso del operador Union All. En este artículo se desea explicar como se usa la opción
Grouping Sets para mostrar múltiples resultados de agrupamientos en la misma instrucción. Adicionalmente se 
muestra como se usa la función Grouping.
*/
USE Northwind
GO

/*USANDO UNION ALL
El uso de UNION ALL permite unir varias consultas en una agrupando varios resultados en uno solo. Se va a crear
cuatro consultas, las que después usando UNION ALL se mostrarán en un solo conjunto de resultados.

CONSULTA 1. Unidades totales vendidas por categoría
*/
SELECT	c.CategoryName AS 'categoria', 
		SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od 
	INNER JOIN Products as p ON(od.ProductID = p.ProductID)
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GROUP BY c.CategoryName
GO

/*CONSULTA 2. Ventas totales en unidades por empleado*/
SELECT empleado = CONCAT_WS(' ', e.FirstName, e.LastName),
	   SUM(od.Quantity) AS 'total'       
FROM [Order Details] AS od
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY CONCAT_WS(' ', e.FirstName, e.LastName)
GO

/*CONSULTA 3. Las compras totales en unidades por cliente*/
SELECT c.CompanyName AS 'cliente',
	   SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
GROUP BY c.CompanyName
GO

/*CONSULTA 4. Ventas totales en unidad*/
SELECT SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od
GO

--USANDO UNION ALL
--Las instrucciones anteriores podemos mostrarlas en un sólo conjunto de resultados
SELECT	c.CategoryName AS 'categoria', 
		SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od 
	INNER JOIN Products as p ON(od.ProductID = p.ProductID)
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GROUP BY c.CategoryName

UNION ALL

SELECT empleado = CONCAT_WS(' ', e.FirstName, e.LastName),
	   SUM(od.Quantity) AS 'total'       
FROM [Order Details] AS od
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY CONCAT_WS(' ', e.FirstName, e.LastName)

UNION ALL

SELECT c.CompanyName AS 'cliente',
	   SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
GROUP BY c.CompanyName

UNION ALL

SELECT 'Total General' AS 'item', SUM(od.Quantity) AS 'total'
FROM [Order Details] AS od

/*Es importante anotar que posiblemente el resultado no sea adecuado para mostrarlo en un sólo conjunto de 
resultados. 

La idea del ejercicio es mostrar el uso de Union All para mostrar varios resultados en un sólo 
conjunto, lo que se va a explicar en el uso de Grouping Sets.

USANDO GROUPING SETS
---------------------
Para el uso de GROUPING SETS se va a crear una tabla con los datos necesarios. Por cada empleado y por
categorías, se a calcular el total de ventas por año.

Revise y considere la opción de generar una vista. Es importante el uso de la vista por que los datos
se actualizan a diferencia de la tabla creada que no se actualiza.
*/

--Generando la tabla llamada totales_ventas_empleados_anio_categorias
SELECT CONCAT_WS(' ', e.FirstName, e.LastName) AS 'empleado', c.CategoryName AS 'categoría',
	   YEAR(o.OrderDate) AS 'año', SUM(od.Quantity * od.UnitPrice) AS 'total'
INTO totales_ventas_empleados_anio_categorias
FROM [Order Details] AS od
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
	INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY CONCAT_WS(' ', e.FirstName, e.LastName), c.CategoryName, YEAR(o.OrderDate)
ORDER BY CONCAT_WS(' ', e.FirstName, e.LastName), c.CategoryName, YEAR(o.OrderDate)
GO

--Listado de los registros de la tabla creada
SELECT * 
FROM totales_ventas_empleados_anio_categorias
GO

/*Para mostrar el  uso de GROUPING SETS se vana construir cuatro diferentes consultas las que se 
mostrarán de manera individual primero, luego usando GROUPING SETS se mostrarán agrupadas*/

/*CONSULTA 01. Ventas totales por categoría*/
SELECT  categoría, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY categoría
GO

/*CONSULTA 02. Total de ventas por empleado*/
SELECT empleado, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado
GO

/*CONSULTA 03. Total de ventas por empleado y categoría*/
SELECT empleado, categoría, SUM(total)
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado, categoría
GO

/*CONSULTA 04. Total de ventas general*/
SELECT SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GO

/*Note que en las cuatro consultas anteriores se ha especificado agrupamientos. Estos cuatro agrupamientos
son: 
categoría
empleado
categoría, empleado
La última no tiene GROUP BY por que no existe campo en el listado sin función de agregado
*/

--USANDO EL OPERADOR UNION ALL
SELECT  categoría AS 'categoría', '' AS 'empleado',SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY categoría

UNION ALL

SELECT '' AS 'categoría', empleado, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado

UNION ALL

SELECT  categoría, empleado, SUM(total)
FROM totales_ventas_empleados_anio_categorias
GROUP BY categoría, empleado

UNION ALL

SELECT '' AS 'categoría', '' AS 'empleado', SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GO

--LA MISMA INSTRUCCIÓN USANDO GRUPING SETS
SELECT ISNULL(t.categoría, '') AS 'categoría',
	   ISNULL(t.empleado, '') AS 'empleado',
	   SUM(t.total) AS 'total'
FROM totales_ventas_empleados_anio_categorias AS t
GROUP BY GROUPING SETS((t.categoría), (t.empleado), (t.categoría, t.empleado), ())
ORDER BY t.categoría, t.empleado
GO

--USANDO LA FUNCIÓN GROUPING
--Se han incluido dos columnas donde se usa la función GROUPING
SELECT GROUPING(t.categoría) AS 'Agrupado por categoría',
	   GROUPING(t.empleado) AS 'Agrupado por empleado',
	   ISNULL(t.categoría, '') AS 'categoría',
	   ISNULL(t.empleado, '') AS 'empleado',
	   SUM(t.total) AS 'total'
FROM totales_ventas_empleados_anio_categorias AS t
GROUP BY GROUPING SETS((t.categoría), (t.empleado), (t.categoría, t.empleado), ())
ORDER BY t.categoría, t.empleado
GO

/*Explicación
Al usar la función Grouping en un campo muestra dos posibles valores, CERO y UNO. El valor de UNO (1) 
significa que se ha agrupado por el campo que se especifica como parámetro de la función, el valor 
de CERO (0) indica que no se ha agrupado por el campo dentro de los paréntesis de la función.

Note en la imagen anterior que el primer registro que muestra las ventas totales tanto por empleado y 
por categoría aparece en UNO en ambas columnas. De los registros 2 hasta el 10 se ha agrupado por categoría, 
mostrando las ventas totales de cada empleado. El registro 11 muestra el total de la categoría Beverage, 
significa la agrupación de las ventas de todos los empleados en esa categoría.

A partir del registro 12, muestra el total de las ventas tanto por Categoría como por Empleado, 
presenta CERO en ambas columnas porque el agrupamiento es por los dos campos y no por cada uno de ellos.*/