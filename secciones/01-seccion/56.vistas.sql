/*-- VISTAS EN SQL SERVER --

- La vista es un objeto en la base de datos creado como resultado de una consulta.
- La vista se puede crear con datos de una o varias tablas de la base de datos.
- Las vistas pueden guardar listados en la base de datos con un conjunto de registros de consulta frecuente.
- Restringir la visualización de algunas columnas que están presente en tablas.
- Para mantener compatibilidad con versiones anteriores de SQL Server.

INSTRUCCIÓN PARA CREAR UNA VISTA
--------------------------------------------
CREATE VIEW [Esquema.]nombreVista
AS 
	INSTRUCCIÓN SELECT



INSTRUCCIÓN ALTER VIEW
--------------------------------------------
ALTER VIEW [Esquema.]nombreVista
AS
	INSTRUCCIÓN SELECT



INSTRUCCIÓN DROP VIEW
--------------------------------------------
DROP VIEW [Esquema.]nombreVista

*/
USE Northwind
GO

/*EJERCICIO 01. Vista con los productos discontinuados*/
CREATE VIEW v_productos_discontinuados
AS 
	SELECT p.ProductID AS 'codigo', p.ProductName AS 'descripcion', p.UnitPrice AS 'precio',
		   p.UnitsInStock AS 'stock', p.UnitsOnOrder AS 'en orden'
	FROM Products AS p
	WHERE p.Discontinued = 1
GO

--Viendo datos de la vista
SELECT * FROM v_productos_discontinuados
GO

/*EJERCICIO 02. Vista con los empleados*/
CREATE VIEW v_empleados
AS
	SELECT e.EmployeeID AS 'codigo', empleado = e.LastName + SPACE(1) + e.FirstName,
		   FORMAT(e.BirthDate, 'dd/MM/yyyy') AS 'fecha nac.'
	FROM Employees AS e
GO

--Listar los registros de la vista empleado
SELECT * 
FROM v_empleados
ORDER BY empleado ASC
GO

/*EJERCICIO 03. Vista de productos y categorías*/
CREATE VIEW v_productos_categorias
AS
	SELECT p.ProductID AS 'codigo', p.ProductName, p.UnitPrice AS 'precio', 
		   c.CategoryName
	FROM Products AS p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO

--Listar los registros de la vista v_productos_categorias
SELECT * FROM v_productos_categorias
GO


/*EJERCICIO 04. Cambiar la vista con más campos*/
ALTER VIEW v_productos_categorias
AS
	SELECT p.ProductID AS 'codigo', p.ProductName, p.UnitPrice AS 'precio', 
		   c.CategoryName, p.UnitsInStock AS 'stock', p.UnitsOnOrder AS 'en orden'
	FROM Products AS p
		INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO

--Listar los registros de la vista v_productos_categorias
SELECT * FROM v_productos_categorias
GO

/*EJERCICIO 05. Vista con los clientes que compraron más de 2000*/
CREATE VIEW v_clientes_top_compras_mas_2000
AS
	SELECT c.CustomerID AS 'código cliente', c.CompanyName AS 'cliente', 
		   c.Address AS 'dirección', c.Country AS 'país', SUM(o.Freight) AS 'Total comprado'
	FROM Customers AS c
		INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
	GROUP BY c.CustomerID, c.CompanyName, c.Address, c.Country
	HAVING SUM(o.Freight) > 2000
GO


--Listar los registros de la vista v_clientes_top_compras_mas_2000
SELECT * FROM v_clientes_top_compras_mas_2000
GO

/*IMPORTANTE
- En la definición de la consulta no se puede usar Order By salvo que se incluya top
- Todas las columnas de la definición de la vista deben tener nombre
- El select de la definición de la vista no puede tener la cláusula Into Tabla.
- La vista puede tener hasta 1,024 columnas.
*/

/*EJERCICIO 06. Vista con order by y top*/
CREATE VIEW v_clientes_top_3_compras_mas_2000
AS 
	SELECT TOP 3 c.CustomerID AS 'código cliente', c.CompanyName AS 'cliente', 
		   c.Address AS 'dirección', c.Country AS 'país', SUM(o.Freight) AS 'Total comprado'
	FROM Customers AS c
		INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
	GROUP BY c.CustomerID, c.CompanyName, c.Address, c.Country
	HAVING SUM(o.Freight) > 2000
	ORDER BY SUM(o.Freight) DESC
GO

--Listando registros
SELECT * FROM v_clientes_top_3_compras_mas_2000
GO