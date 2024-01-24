/*--COMMON TABLE EXPRESSIONS CTE SQLSERVER--

Una expresión de tabla común (CTE) es un conjunto de resultados temporal definido en la 
ejecución de una instrucción SELECT, INSERT, UPDATE,  DELETE o CREATE VIEW. 
Es como asignar un nombre a una consulta pero sin almacenarla en la base de datos como el 
caso de las vistas. (Ver Vistas)

Una CTE es similar a una tabla derivada (Ver Subconsultas como tablas derivadas) en que no 
se almacena como un objeto y dura sólo el tiempo que dura la consulta. A diferencia de una 
abla derivada, una CTE puede hacer referencia a sí misma y se puede hacer referencia a ella 
varias veces en la misma consulta.

Una CTE se puede usar para:

- Crear una consulta recursiva.
- Sustituir la creación de una vista cuando el uso de una vista no sea necesario; 
  es decir, cuando no se tenga que almacenar la definición de la vista en la base de datos.
- Hacer referencia a la tabla resultante varias veces en la misma instrucción.
- Las CTE tiene ventajas de legibilidad mejorada y facilidad de mantenimiento de consultas complejas.
- Las CTE se pueden definir en rutinas definidas por el usuario, como funciones, 
  procedimientos almacenados, desencadenadores o vistas.

Estructura de una CTE
Las CTE tienen un nombre de expresión que representa la CTE, una lista de columnas opcional y 
una consulta que define la CTE.
Después de definir una CTE, se puede hacer referencia a ella como una tabla o vista en una 
instrucción SELECT, INSERT, UPDATE o DELETE.

La estructura de las CTE es:
WITH NombreCTE [ ( NombreColumna [,…n] ) ]
AS
( Consulta compleja )
Select <column_list> FROM NombreCTE
*/
USE Northwind
GO

/*EJERCICIO 01. Mostrar los productos, su categoría y su proveedor. Mostrar los que no están 
escontinuados ordenados por precio descendentemente. Para entender las relaciones entre las 
tablas Ver Joins en SQL*/

--La consulta sin CTE es como sigue:
SELECT p.ProductName, c.CategoryName, s.CompanyName, p.UnitPrice
FROM Products AS p
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
WHERE p.Discontinued = 0
ORDER BY p.UnitPrice DESC
GO

--Consulta usando CTE:
WITH lista_productos(producto, categoria, proveedor, precio)
AS
	(SELECT p.ProductName, c.CategoryName, s.CompanyName, p.UnitPrice
	 FROM Products AS p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
	 WHERE p.Discontinued = 0)
SELECT * 
FROM lista_productos
ORDER BY precio
GO

-- En la consulta siguiente presentamos solamente algunos campos
WITH lista_productos(producto, categoria, proveedor, precio)
AS
	(SELECT p.ProductName, c.CategoryName, s.CompanyName, p.UnitPrice
	 FROM Products AS p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
		INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
	 WHERE p.Discontinued = 0)
SELECT producto, categoria
FROM lista_productos
ORDER BY precio
GO

/*EJERCICIO 02. Mostrar los empleados y las órdenes generadas*/
--La consulta sin CTE
SELECT e.EmployeeID AS codigo, e.LastName AS apellido, e.FirstName  AS 'nombre',
	o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GO

--Asignando la CTE
WITH ordenes_empleados
AS
	(SELECT e.EmployeeID AS codigo, e.LastName AS apellido, e.FirstName  AS 'nombre',
			o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha
	 FROM Orders AS o
		 INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID))
SELECT * 
FROM ordenes_empleados
GO

--Usando la CTE con una consulta diferente, incluye el total de órdenes.
WITH ordenes_empleados
AS
	(SELECT e.EmployeeID AS codigo, e.LastName AS apellido, e.FirstName  AS 'nombre',
			o.OrderID AS 'N° orden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha
	 FROM Orders AS o
		 INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID))
SELECT codigo, apellido, nombre, COUNT([N° orden]) AS [total órdenes]
FROM ordenes_empleados
GROUP BY codigo, apellido, nombre
GO

/*EJERCICIO 03. Mostrando los datos de una relación recursiva. En la tabla empleados
existe en campo ReportsTo que indica que un empleado debe reportar su trabajo al
que se indica en ese campo*/
SELECT CONCAT_WS(' ', j.FirstName, j.LastName) AS 'jefe',
	   e.EmployeeID AS 'cod empleado', CONCAT_WS(' ', e.FirstName, e.LastName) AS 'empleado'	   
FROM Employees AS e 
	INNER JOIN Employees AS j ON(e.ReportsTo = j.EmployeeID)
GO

--Usando CTE para listado de los empleados y sus jefes
WITH jefe 
AS
	(SELECT e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS empleado  
	 FROM Employees AS e)
SELECT j.EmployeeID AS 'cod jefe', [jefe] = j.empleado, 
	   em.EmployeeID AS 'cod empleado', [empleado] = CONCAT_WS(' ', em.FirstName, em.LastName)
FROM jefe AS j
	INNER JOIN Employees AS em ON(j.EmployeeID = em.ReportsTo)
GO