/*-- USO DE OFFSET Y FETCH NEXT EN SQL SERVER --

La instrucción Select tiene varias opciones que se pueden incluir según las 
necesidades de la presentación de la información extraída de una o más tablas.

En ocasiones es necesario mostrar los registros en un determinado orden, para 
ello podemos usar la cláusula Order by, lo que permitirá 
mostrar el resultado obtenido con un orden especificado, y de acuerdo a uno o 
más campos.

CÓMO USAR OFFSET EN SQL SERVER

Offset n Rows permite en un listado que se muestra de manera ordenada no tener 
en cuenta los n registros que se muestran al inicio del listado, Offset n Rows 
se utiliza después de la cláusula Order by donde el valor n especifica la cantidad 
de registros a no tener en cuenta.
*/
USE Northwind
GO

/*EJERCICIO 01. Listar los productos ordenados por stock en orden descendente*/
SELECT * 
FROM Products
ORDER BY UnitsInStock DESC
GO
/*Se puede notar que aparecen todos los productos ordenados por unidades en stock. 
En la imagen se han marcado los 5 primeros registros que no se tendrán en cuenta
en la siguiente instrucción usando OFFSET. 

Para no presentar en el listado los cinco primeros productos con mayor stock podemos
usar la cláusula OFFSET especificando 5 registros (OFFSET 5 ROWS). Note que el sexto
registro es el que tiene código 33
*/
SELECT * 
FROM Products
ORDER BY UnitsInStock DESC
OFFSET 5 ROWS
GO

/*EJERCICIO 02. Listar los productos que se vendieron más en 1997, no tenga en cuenta
los 10 primeros*/

--Primero mostramos todos los productos
SELECT	od.ProductID AS  Código, 
		p.ProductName AS descripción, 
		SUM(od.Quantity) AS [Total vendido]
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY od.ProductID, p.ProductName
ORDER BY [Total vendido] DESC
GO

--Ahora se incluye la opción OFFSET 10 ROWS para que los 10
--primeros sean tomados en cuenta
SELECT	od.ProductID AS  Código, 
		p.ProductName AS descripción, 
		SUM(od.Quantity) AS [Total vendido]
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY od.ProductID, p.ProductName
ORDER BY [Total vendido] DESC
OFFSET 10 ROWS
GO

--Los productos que no se presetan son los 10 que tienen más venta.
--Para mostrarlos podemos usar la cláusula TOP
SELECT	TOP 10 od.ProductID AS  Código, 
		p.ProductName AS descripción, 
		SUM(od.Quantity) AS [Total vendido]
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE YEAR(o.OrderDate) = 1997
GROUP BY od.ProductID, p.ProductName
ORDER BY [Total vendido] DESC
GO

/*CÓMO USAR FETCH NEXT N ROWS ONLY

Para listar los registros teniendo en cuenta un orden específico e incluir una cantidad
determinada de estos se puede usar la cláusula FETCH NEXT N ROWS ONLY, lo que permitirá
especificar cuántos registros se desea mostrar, exceptuando los primeros que no se 
presentan usando OFFSET N ROWS

EJERCICIO 03. Listar los empleados y la cantidad de órdenes generadas, no mostrar los 4
primeros e incluir solamente tres registros en el listado. 
*/
--Primero vamos a ver el listado completo de los empleados y la cantidad de órdenes
SELECT	e.EmployeeID AS [Cód. Empleado],
		(e.FirstName + SPACE(1) + e.LastName) AS Empleado,
		COUNT(o.OrderID) AS [Cantidad de Órdenes]
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY [Cantidad de Órdenes] DESC
GO

--Ahora el listado no tendrá en cuenta los 4 primeros y se va a listar
--únicamente los siguientes 3 registros
SELECT	e.EmployeeID AS [Cód. Empleado],
		(e.FirstName + SPACE(1) + e.LastName) AS Empleado,
		COUNT(o.OrderID) AS [Cantidad de Órdenes]
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY [Cantidad de Órdenes] DESC
OFFSET 4 ROWS
FETCH NEXT 3 ROWS ONLY
GO

/*Compare las dos imágenes anteriores y puede notar que no se muestran los 4 primeros y 
luego se muestran los siguientes 3 registros
*/
