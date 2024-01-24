/*-- SUBCONSULTAS EN SQL SERVER --

Una subconsulta es una consulta anidada en un SELECT, INSERT,  UPDATE o DELETE e inclusive en otra 
subconsulta.  Las subconsultas se pueden utilizar en cualquier parte en la que se permita una expresión. 
Las subconsultas deben seguir ciertas reglas que se mencionan al final del post. Es necesario conocer la 
estructura de la base de datos para poder relacionar las tablas correctamente y lograr los resultados 
esperados. Los resultados obtenidos con subconsultas se pueden también obtener con el uso de Joins.

Las subconsultas pueden utilizarse de dos formas:

1. Dentro de la Lista de campos de la instrucción Select, esta subconsulta es la que reporta un valor.  
   Se debe relacionar la tabla después del From con la tabla de la Subconsulta.
	select ListaCampos, (Select …. subconsulta) from Tabla
2. En las clásulas Where
	Select ListadeCampos, OtroCampo, UltimoCampo from Tabla
	WHERE Campo [NOT] IN (subconsulta)
	WHERE Campo operador [ANY | ALL] (subconsulta)
	WHERE [Not] Exists (subconsulta)
*/

USE Northwind
GO

/*EJERCICIO 01. Listado de las categorías y la cantidad de productos de cada una*/
SELECT c.CategoryName, 
	   (SELECT COUNT(p.ProductID)
	    FROM Products AS p
		WHERE p.CategoryID = c.CategoryID) AS 'cant. productos'
FROM Categories AS c
ORDER BY [cant. productos] DESC
GO

/*
Nota: la consulta para saber la cantidad de productos en la instrucción
anterior es la siguiente: (ej. Cat. 5)
SELECT COUNT(P.ProductID) FROM Products AS P WHERE P.CategoryID = 5
GO
Para poder especificar el código de la categoría se utiliza el campo CategoryID
de la tabla Categories.

La imagen muestra el resultado, note que la cantidad de productos en almacén de una determinada categoría 
se muestra con la consulta entre paréntesis que es la subconsulta.
*/

/*EJERCICIO 02. Empleados y la cantidad de órdenes del año 1997, orden descendente por
cantidad de órdenes*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado,
	   (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'cant. órdenes 1997'
FROM Employees AS e
ORDER BY [cant. órdenes 1997] DESC
GO

/*EJERCICIO 03. Un listado de los empleados y el monto total generado en las órdenes 
del año 1997 y la cantidad de órdenes de cada uno*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado,
	   (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'cant. órdenes',
	   (SELECT SUM(o.Freight)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'monto total 1997'
FROM Employees AS e
ORDER BY [monto total 1997] DESC
GO

/*EJERCICIO 04. Órdenes que generaron los clientes de México*/

--Primero determinar. ¿Cuáles son los clientes de Mëxico?
SELECT c.CustomerID
FROM Customers AS c 
WHERE c.Country = 'Mexico'
GO

--Para las órdenes
SELECT o.OrderID AS 'N° órden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha,
	   o.CustomerID AS 'cód. cliente', c.CompanyName AS 'cliente',
	   c.Country AS 'pais'
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE o.CustomerID IN (SELECT cu.CustomerID
					  FROM Customers AS cu 
					  WHERE cu.Country = 'Mexico')
GO

/*EJERCICIO 05. Las órdenes donde se vendieron los productos del proveedor(suppliers) llamado
Tokyo Traders*/

--Primero el código del proveedor Tokyo Traders
SELECT s.SupplierID
FROM Suppliers AS s
WHERE s.CompanyName = 'Tokyo Traders'
GO

--Los productos de ese proveedor
SELECT p.ProductID 
FROM Products AS p
WHERE p.SupplierID = (SELECT s.SupplierID
					  FROM Suppliers AS s
					  WHERE s.CompanyName = 'Tokyo Traders')
GO

/*Los códigos de los productos del proveedor Tokyo Traders son: 9, 10 y 74.*/

--Las órdenes en los que se vendieron los productos del proveedor Tokyo Traders
SELECT o.OrderID AS 'N° orden', od.ProductID AS 'cód. producto', p.ProductName AS 'descripción',
	   p.UnitPrice AS 'precio lista', od.UnitPrice AS 'precio venta', od.Quantity AS 'cantidad', 
	   FORMAT(o.OrderDate, 'dd/MM/yyyy') AS 'fecha orden'
FROM Orders AS o
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE p.ProductID IN(SELECT pp.ProductID 
					FROM Products AS pp
					WHERE pp.SupplierID = (SELECT ss.SupplierID
											FROM Suppliers AS ss
											WHERE ss.CompanyName = 'Tokyo Traders'))
GO

/*EJERCICIO 06. Los clientes y la cantidad comprada por cada uno*/
SELECT c.CustomerID, c.CompanyName, c.Address, c.Country, 
	   (SELECT SUM(o.freight) 
	    FROM Orders AS o
		WHERE o.CustomerID = c.CustomerID) AS 'total comprado'
FROM Customers AS c
WHERE (SELECT SUM(o.freight) 
       FROM Orders AS o
	   WHERE o.CustomerID = c.CustomerID) > 0
GO

/*RESTRICCIONES: 
- Los campos de una subconsulta que se especifica con un operador de comparación, sólo puede incluir un 
  nombre de expresión o columna.
- Los campos que incluyen EXISTS e IN pueden reportar un conjunto de resultados.
- Si la cláusula WHERE de una consulta externa incluye un nombre de columna, debe ser compatible con una 
  combinación con la columna indicada en la lista de selección de la subconsulta.
- La palabra clave DISTINCT no se puede usar con subconsultas que incluyan GROUP BY.
- No se pueden especificar las cláusulas COMPUTE e INTO.
- Los tipos de datos ntext, text y image no están permitidos en subconsultas.
- Las subconsultas que se especifican con un operador de comparación sin modificar (no seguido de la 
  palabra clave ANY o ALL) no pueden incluir las cláusulas GROUP BY y HAVING.
- Sólo se puede especificar ORDER BY si se especifica también TOP.
- Una vista creada con una subconsulta no se puede actualizar.
- La lista de selección de una subconsulta especificada con EXISTS,  por convención, tiene un 
  asterisco (*) en lugar de un solo nombre de columna.  Las reglas de una subconsulta especificada con 
  EXISTS son idénticas a las de una lista de selección estándar, porque este tipo de subconsulta crea 
  una prueba de existencia y devuelve TRUE o FALSE en lugar de datos.
*/