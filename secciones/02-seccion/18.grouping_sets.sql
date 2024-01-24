/*-- USO DE GROUPING SETS EN SQL SERVER --

Los agrupamiento en SQL Server permiten mostrar un conjunto de resultados donde una o mas columnas que se 
muestran es el resultado del uso de alguna de las funciones de agregado que calculan suma, promedio,
m�ximo, m�nimo, etc.

Los agrupamiento en SQL Server permiten mostrar un conjunto de resultados donde una o mas columnas que se 
muestran es el resultado del uso de alguna de las funciones de agregado que calculan suma, promedio,
m�ximo, m�nimo, etc.

Si se desea mostrar mas de un agrupamiento en el mismo conjunto de resultado se deber� usar los Grouping Sets,
estos son similares al uso del operador Union All. En este art�culo se desea explicar como se usa la opci�n
Grouping Sets para mostrar m�ltiples resultados de agrupamientos en la misma instrucci�n. Adicionalmente se 
muestra como se usa la funci�n Grouping.
*/
USE Northwind
GO

/*USANDO UNION ALL
El uso de UNION ALL permite unir varias consultas en una agrupando varios resultados en uno solo. Se va a crear
cuatro consultas, las que despu�s usando UNION ALL se mostrar�n en un solo conjunto de resultados.

CONSULTA 1. Unidades totales vendidas por categor�a
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
--Las instrucciones anteriores podemos mostrarlas en un s�lo conjunto de resultados
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

/*Es importante anotar que posiblemente el resultado no sea adecuado para mostrarlo en un s�lo conjunto de 
resultados. 

La idea del ejercicio es mostrar el uso de Union All para mostrar varios resultados en un s�lo 
conjunto, lo que se va a explicar en el uso de Grouping Sets.

USANDO GROUPING SETS
---------------------
Para el uso de GROUPING SETS se va a crear una tabla con los datos necesarios. Por cada empleado y por
categor�as, se a calcular el total de ventas por a�o.

Revise y considere la opci�n de generar una vista. Es importante el uso de la vista por que los datos
se actualizan a diferencia de la tabla creada que no se actualiza.
*/

--Generando la tabla llamada totales_ventas_empleados_anio_categorias
SELECT CONCAT_WS(' ', e.FirstName, e.LastName) AS 'empleado', c.CategoryName AS 'categor�a',
	   YEAR(o.OrderDate) AS 'a�o', SUM(od.Quantity * od.UnitPrice) AS 'total'
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
mostrar�n de manera individual primero, luego usando GROUPING SETS se mostrar�n agrupadas*/

/*CONSULTA 01. Ventas totales por categor�a*/
SELECT  categor�a, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY categor�a
GO

/*CONSULTA 02. Total de ventas por empleado*/
SELECT empleado, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado
GO

/*CONSULTA 03. Total de ventas por empleado y categor�a*/
SELECT empleado, categor�a, SUM(total)
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado, categor�a
GO

/*CONSULTA 04. Total de ventas general*/
SELECT SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GO

/*Note que en las cuatro consultas anteriores se ha especificado agrupamientos. Estos cuatro agrupamientos
son: 
categor�a
empleado
categor�a, empleado
La �ltima no tiene GROUP BY por que no existe campo en el listado sin funci�n de agregado
*/

--USANDO EL OPERADOR UNION ALL
SELECT  categor�a AS 'categor�a', '' AS 'empleado',SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY categor�a

UNION ALL

SELECT '' AS 'categor�a', empleado, SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GROUP BY empleado

UNION ALL

SELECT  categor�a, empleado, SUM(total)
FROM totales_ventas_empleados_anio_categorias
GROUP BY categor�a, empleado

UNION ALL

SELECT '' AS 'categor�a', '' AS 'empleado', SUM(total) AS 'total'
FROM totales_ventas_empleados_anio_categorias
GO

--LA MISMA INSTRUCCI�N USANDO GRUPING SETS
SELECT ISNULL(t.categor�a, '') AS 'categor�a',
	   ISNULL(t.empleado, '') AS 'empleado',
	   SUM(t.total) AS 'total'
FROM totales_ventas_empleados_anio_categorias AS t
GROUP BY GROUPING SETS((t.categor�a), (t.empleado), (t.categor�a, t.empleado), ())
ORDER BY t.categor�a, t.empleado
GO

--USANDO LA FUNCI�N GROUPING
--Se han incluido dos columnas donde se usa la funci�n GROUPING
SELECT GROUPING(t.categor�a) AS 'Agrupado por categor�a',
	   GROUPING(t.empleado) AS 'Agrupado por empleado',
	   ISNULL(t.categor�a, '') AS 'categor�a',
	   ISNULL(t.empleado, '') AS 'empleado',
	   SUM(t.total) AS 'total'
FROM totales_ventas_empleados_anio_categorias AS t
GROUP BY GROUPING SETS((t.categor�a), (t.empleado), (t.categor�a, t.empleado), ())
ORDER BY t.categor�a, t.empleado
GO

/*Explicaci�n
Al usar la funci�n Grouping en un campo muestra dos posibles valores, CERO y UNO. El valor de UNO (1) 
significa que se ha agrupado por el campo que se especifica como par�metro de la funci�n, el valor 
de CERO (0) indica que no se ha agrupado por el campo dentro de los par�ntesis de la funci�n.

Note en la imagen anterior que el primer registro que muestra las ventas totales tanto por empleado y 
por categor�a aparece en UNO en ambas columnas. De los registros 2 hasta el 10 se ha agrupado por categor�a, 
mostrando las ventas totales de cada empleado. El registro 11 muestra el total de la categor�a Beverage, 
significa la agrupaci�n de las ventas de todos los empleados en esa categor�a.

A partir del registro 12, muestra el total de las ventas tanto por Categor�a como por Empleado, 
presenta CERO en ambas columnas porque el agrupamiento es por los dos campos y no por cada uno de ellos.*/