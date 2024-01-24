/*-- SUBCONSULTAS EN SQL SERVER --

Una subconsulta es una consulta anidada en un SELECT, INSERT,  UPDATE o DELETE e inclusive en otra 
subconsulta.  Las subconsultas se pueden utilizar en cualquier parte en la que se permita una expresi�n. 
Las subconsultas deben seguir ciertas reglas que se mencionan al final del post. Es necesario conocer la 
estructura de la base de datos para poder relacionar las tablas correctamente y lograr los resultados 
esperados. Los resultados obtenidos con subconsultas se pueden tambi�n obtener con el uso de Joins.

Las subconsultas pueden utilizarse de dos formas:

1. Dentro de la Lista de campos de la instrucci�n Select, esta subconsulta es la que reporta un valor.  
   Se debe relacionar la tabla despu�s del From con la tabla de la Subconsulta.
	select ListaCampos, (Select �. subconsulta) from Tabla
2. En las cl�sulas Where
	Select ListadeCampos, OtroCampo, UltimoCampo from Tabla
	WHERE Campo [NOT] IN (subconsulta)
	WHERE Campo operador [ANY | ALL] (subconsulta)
	WHERE [Not] Exists (subconsulta)
*/

USE Northwind
GO

/*EJERCICIO 01. Listado de las categor�as y la cantidad de productos de cada una*/
SELECT c.CategoryName, 
	   (SELECT COUNT(p.ProductID)
	    FROM Products AS p
		WHERE p.CategoryID = c.CategoryID) AS 'cant. productos'
FROM Categories AS c
ORDER BY [cant. productos] DESC
GO

/*
Nota: la consulta para saber la cantidad de productos en la instrucci�n
anterior es la siguiente: (ej. Cat. 5)
SELECT COUNT(P.ProductID) FROM Products AS P WHERE P.CategoryID = 5
GO
Para poder especificar el c�digo de la categor�a se utiliza el campo CategoryID
de la tabla Categories.

La imagen muestra el resultado, note que la cantidad de productos en almac�n de una determinada categor�a 
se muestra con la consulta entre par�ntesis que es la subconsulta.
*/

/*EJERCICIO 02. Empleados y la cantidad de �rdenes del a�o 1997, orden descendente por
cantidad de �rdenes*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado,
	   (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'cant. �rdenes 1997'
FROM Employees AS e
ORDER BY [cant. �rdenes 1997] DESC
GO

/*EJERCICIO 03. Un listado de los empleados y el monto total generado en las �rdenes 
del a�o 1997 y la cantidad de �rdenes de cada uno*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado,
	   (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'cant. �rdenes',
	   (SELECT SUM(o.Freight)
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID AND YEAR(o.OrderDate) = 1997) AS 'monto total 1997'
FROM Employees AS e
ORDER BY [monto total 1997] DESC
GO

/*EJERCICIO 04. �rdenes que generaron los clientes de M�xico*/

--Primero determinar. �Cu�les son los clientes de M�xico?
SELECT c.CustomerID
FROM Customers AS c 
WHERE c.Country = 'Mexico'
GO

--Para las �rdenes
SELECT o.OrderID AS 'N� �rden', FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha,
	   o.CustomerID AS 'c�d. cliente', c.CompanyName AS 'cliente',
	   c.Country AS 'pais'
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE o.CustomerID IN (SELECT cu.CustomerID
					  FROM Customers AS cu 
					  WHERE cu.Country = 'Mexico')
GO

/*EJERCICIO 05. Las �rdenes donde se vendieron los productos del proveedor(suppliers) llamado
Tokyo Traders*/

--Primero el c�digo del proveedor Tokyo Traders
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

/*Los c�digos de los productos del proveedor Tokyo Traders son: 9, 10 y 74.*/

--Las �rdenes en los que se vendieron los productos del proveedor Tokyo Traders
SELECT o.OrderID AS 'N� orden', od.ProductID AS 'c�d. producto', p.ProductName AS 'descripci�n',
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
- Los campos de una subconsulta que se especifica con un operador de comparaci�n, s�lo puede incluir un 
  nombre de expresi�n o columna.
- Los campos que incluyen EXISTS e IN pueden reportar un conjunto de resultados.
- Si la cl�usula WHERE de una consulta externa incluye un nombre de columna, debe ser compatible con una 
  combinaci�n con la columna indicada en la lista de selecci�n de la subconsulta.
- La palabra clave DISTINCT no se puede usar con subconsultas que incluyan GROUP BY.
- No se pueden especificar las cl�usulas COMPUTE e INTO.
- Los tipos de datos ntext, text y image no est�n permitidos en subconsultas.
- Las subconsultas que se especifican con un operador de comparaci�n sin modificar (no seguido de la 
  palabra clave ANY o ALL) no pueden incluir las cl�usulas GROUP BY y HAVING.
- S�lo se puede especificar ORDER BY si se especifica tambi�n TOP.
- Una vista creada con una subconsulta no se puede actualizar.
- La lista de selecci�n de una subconsulta especificada con EXISTS,  por convenci�n, tiene un 
  asterisco (*) en lugar de un solo nombre de columna.  Las reglas de una subconsulta especificada con 
  EXISTS son id�nticas a las de una lista de selecci�n est�ndar, porque este tipo de subconsulta crea 
  una prueba de existencia y devuelve TRUE o FALSE en lugar de datos.
*/