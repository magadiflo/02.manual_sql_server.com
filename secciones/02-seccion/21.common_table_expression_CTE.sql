/*-- COMMON TABLE EXPRESSIONS CTE SQL SERVER --

Una expresión de tabla común(CTE) es un conjunto de resultados temporal definido en la
ejecución de una instrucción SELECT, INSERT, UPDATE, DELETE o CREATE VIEW. Es como asignar
un nombre a una consulta pero sin almacenarla en la base de datos como el caso de las 
vistas.

Una CTE es similar a una tabla derivada en que no se almacena como un objeto y dura sólo
el tiempo que dura la consulta. A diferencia de una tabla derivada, una CTE puede hacer
referencia a sí misma y se puede hacer referencia a ella varias veces en la misma consulta.

Una CTE se puede usar para: 
- Crear una consulta recursiva
- Sustituir la creación de una vista cuando el uso de una vista no sea necesario. Es decir,
  cuando no se tenga que almacenar la definición de la vista en la base de datos
- Hacer referencia a la tabla resultante varias veces en la misma instrucción
- Las CTE tienen ventajas de legibilidad mejorada y facilidad de mantenimiento de consultas
  complejas.
- Las CTE se pueden definir en rutinas definidas por el usuario, como funciones, procedimientos
  almacenados, desencadenadores o vistas

ESTRUCTURA DE UNA CTE
Las CTE tienen un nombre de expresión que representa la CTE, una lista de columnas opcional
y una consulta que define la CTE. 
Después de definir una CTE, se puede hacer referencia a ella como una tabla o vista en una
instrucción SELECT, INSERT, UPDATE o DELETE

WITH NombreCTE [ ( NombreColumna [,…n] ) ]
AS
( Consulta compleja )
Select <column_list> FROM NombreCTE
*/
USE Northwind
GO

/*EJERCICIO 01. Mostrar los productos, su categoría y su proveedor. Mostrar los que no están
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

/*EJERCICIO 02. Mostrar los empleados y las órdenes generadas.
Es importante que la consulta tenga sus alias correctos*/ 

--La consulta sin CTE
SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
	   o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
FROM Employees AS e
	INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
GO

--Asignando la CTE
WITH ordenesEmpleados(codigo, apellido, nombre, orden, fecha)
AS(
	SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
		   o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
	FROM Employees AS e
		INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
)
SELECT codigo, apellido, nombre 
FROM ordenesEmpleados
GO

--Usando la CTE con una consulta diferente, incluye el total de órdenes.
WITH ordenesEmpleados(codigo, apellido, nombre, orden, fecha)
AS(
	SELECT e.EmployeeID AS 'codigo', e.LastName AS 'apellido', e.FirstName AS 'nombre',
		   o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha'
	FROM Employees AS e
		INNER JOIN Orders as o ON(e.EmployeeID = o.EmployeeID)
)
SELECT codigo, apellido, nombre, COUNT(orden) AS 'total órdenes'
FROM ordenesEmpleados
GROUP BY codigo, apellido, nombre
ORDER BY [total órdenes] DESC
GO

/*EJERCICIO 03. Mostrando los datos de una relación recursiva. En la tabla 
emleados (employees) existe en campo ReportsTo que indica que un empleado debe
reportar su trabajo al que se indica en ese campo*/
--Visualizando los datos
SELECT e.EmployeeID, e.FirstName, e.LastName, e.ReportsTo
FROM Employees AS e
GO

/*
En la imagen se puede mostrar que el empleado Nancy Davolio debe reportar al empleado
con código 2 que es Andrew Fuller.
*/
-- La consulta sin CTE
SELECT j.EmployeeID AS 'cód. jefe', CONCAT_WS(' ', j.LastName, j.FirstName) AS 'jefe',
	   e.EmployeeID AS 'cód. empleado', CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado'
FROM Employees AS e
	INNER JOIN Employees AS j ON(e.ReportsTo = j.EmployeeID)
GO

--Listado de los empleados y sus jefes utilizando CTE
WITH jefe
AS(
	SELECT EmployeeID, LastName, FirstName
	FROM Employees
)

SELECT j.EmployeeID AS 'cód. jefe', CONCAT_WS(' ', j.LastName, j.FirstName) AS 'jefe',
	   e.EmployeeID AS 'cód. empleado', CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado'
FROM Employees AS e
	INNER JOIN jefe AS j ON(e.ReportsTo = j.EmployeeID)
GO

