/*-- COMMON TABLE EXPRESSIONS CTE SQL SERVER --

Una expresi�n de tabla com�n(CTE) es un conjunto de resultados temporal definido en la
ejecuci�n de una instrucci�n SELECT, INSERT, UPDATE, DELETE o CREATE VIEW. Es como asignar
un nombre a una consulta pero sin almacenarla en la base de datos como el caso de las 
vistas.

Una CTE es similar a una tabla derivada en que no se almacena como un objeto y dura s�lo
el tiempo que dura la consulta. A diferencia de una tabla derivada, una CTE puede hacer
referencia a s� misma y se puede hacer referencia a ella varias veces en la misma consulta.

Una CTE se puede usar para: 
- Crear una consulta recursiva
- Sustituir la creaci�n de una vista cuando el uso de una vista no sea necesario. Es decir,
  cuando no se tenga que almacenar la definici�n de la vista en la base de datos
- Hacer referencia a la tabla resultante varias veces en la misma instrucci�n
- Las CTE tienen ventajas de legibilidad mejorada y facilidad de mantenimiento de consultas
  complejas.
- Las CTE se pueden definir en rutinas definidas por el usuario, como funciones, procedimientos
  almacenados, desencadenadores o vistas

ESTRUCTURA DE UNA CTE
Las CTE tienen un nombre de expresi�n que representa la CTE, una lista de columnas opcional
y una consulta que define la CTE. 
Despu�s de definir una CTE, se puede hacer referencia a ella como una tabla o vista en una
instrucci�n SELECT, INSERT, UPDATE o DELETE

WITH NombreCTE [ ( NombreColumna [,�n] ) ]
AS
( Consulta compleja )
Select <column_list> FROM NombreCTE
*/
USE Northwind
GO

/*EJERCICIO 01. Mostrar los productos, su categor�a y su proveedor. Mostrar los que no est�n
discontinuados ordenarlos por precio descendentemente.*/

--La consulta sin CTE es como sigue:
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, c.CategoryName, s.CompanyName
FROM Products AS p 
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
WHERE p.Discontinued = 0
ORDER BY p.UnitPrice DESC
GO

--Usando CTE
WITH listaProductos(codigo, descripcion, precio, stock, categoria, proveedor) 
AS(
	SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, c.CategoryName, s.CompanyName
	FROM Products AS p 
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
	WHERE p.Discontinued = 0
)
SELECT * FROM listaProductos
ORDER BY precio
GO

--En la orden anterior se pueden presentar solamente algunos campos
WITH listaProductos(codigo, descripcion, precio, stock, categoria, proveedor) 
AS(
	SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, c.CategoryName, s.CompanyName
	FROM Products AS p 
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
	WHERE p.Discontinued = 0
)
SELECT codigo, descripcion, categoria FROM listaProductos
ORDER BY precio
GO

/*EJERCICIO 02. Mostrar los empleados y las �rdenes generadas.
Es importante que la consulta tenga sus alias correctos*/ 

--La consulta sin CTE
SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
	   o.OrderID AS 'N� orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
FROM Employees AS e
	INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
GO

--Asignando la CTE
WITH ordenesEmpleados(codigo, apellido, nombre, orden, fecha)
AS(
	SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
		   o.OrderID AS 'N� orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
	FROM Employees AS e
		INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
)
SELECT codigo, apellido, nombre 
FROM ordenesEmpleados
GO

--Usando la CTE con una consulta diferente, incluye el total de �rdenes.
WITH ordenesEmpleados(codigo, apellido, nombre, orden, fecha)
AS(
	SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
		   o.OrderID AS 'N� orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
	FROM Employees AS e
		INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
)
SELECT codigo, apellido, nombre, COUNT(orden) AS 'total �rdenes'
FROM ordenesEmpleados
GROUP BY codigo, apellido, nombre
ORDER BY [total �rdenes] DESC
GO

/*EJERCICIO 03. Mostrando los datos de una relaci�n recursiva. En la tabla 
emleados (employees) existe en campo ReportsTo que indica que un empleado debe
reportar su trabajo al que se indica en ese campo*/
--Visualizando los datos
SELECT e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
FROM Employees AS e
GO

/*
En la imagen se puede mostrar que el empleado Nancy Davolio debe reportar al empleado
con c�digo 2 que es Andrew Fuller.
*/
-- La consulta sin CTE
SELECT j.EmployeeID AS 'c�d. jefe', CONCAT_WS(' ', j.LastName, j.FirstName) AS 'jefe',
	   e.EmployeeID AS 'c�d. empleado', CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado'
FROM Employees AS e
	INNER JOIN Employees AS j ON(e.ReportsTo = j.EmployeeID)
GO

--Listado de los empleados y sus jefes utilizando CTE
WITH jefe
AS(
	SELECT EmployeeID, LastName, FirstName
	FROM Employees
)

SELECT j.EmployeeID AS 'c�d. jefe', CONCAT_WS(' ', j.LastName, j.FirstName) AS 'jefe',
	   e.EmployeeID AS 'c�d. empleado', CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado'
FROM Employees AS e
	INNER JOIN jefe AS j ON(e.ReportsTo = j.EmployeeID)
GO

