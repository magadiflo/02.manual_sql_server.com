/*-- SUBCONSULTAS COMO TABLA DERIVADA SQL SERVER --

Las subconsultas como tabla derivada son instrucciones select que sirven como conjunto de resultados 
desde donde se realiza una instrucci�n select externa. Esta instrucci�n Select se utiliza despu�s de 
la cl�usula From.

Para entender mejor debemos recordar que en una subconsulta podemos reconocer como m�nimo dos 
instrucciones Select, una consulta externa que dentro de ella tiene una o mas instrucciones select 
que son las consultas internas.

Las subconsultas se pueden agrupar de la siguiente forma

1. Subconsultas que devuelven un �nico valor.
2. Subconsultas que devuelven un conjunto de datos.
3. Subconsultas como tablas derivadas.

En este art�culo se ver� como usar las subconsultas como tablas derivadas.

La estructura de las subconsultas como tablas derivadas tienen una estructura similar a la 
siguiente instrucci�n

SELECT TablaDerivada.Campo1, TablaDerivada.Campo2, TablaDerivada.Campo3
FROM (SELECT * FROM Tabla) As TablaDerivada

Note que despu�s de la instrucci�n FROM se ha especificado una instrucci�n SELECT que es 
la que se considera una tabla derivada.

SUGERENCIA: el conjunto de resultados de subconsultas se pueden obtener tambi�n usando 
Joins (Ver Joins), se sugiere ver el plan de ejecuci�n para elegir la que tenga menor costo.
*/
USE Northwind
GO

/*EJERCICIO 01. Mostrar los c�digo y los nombres de los proveedores (suppliers)*/
SELECT p.SupplierID, p.CompanyName
FROM (SELECT * FROM Suppliers) AS p
GO

/*Note que primero se cre� una consulta con los proveedores a la que se le asign� el alias P, 
luego esa consultas sirvi� como tabla derivada para a partir de su conjunto de resultados s�lo 
se muestre los c�digos (SupplierID) y el nombre de la compa��a (CompanyName)
*/

/*EJERCICIO 02. Mostrar detalles de compras de los clientes. 
Primero se van a crear una instrucci�n que tenga el detalle de las ventas incluyendo los 
datos del cliente, el producto y la orden. 
A partir de esa instrucci�n obtener detalles de ventas.*/
SELECT co.[N� orden], co.producto, co.cantidad, co.[precio venta]
FROM (SELECT o.OrderID AS 'N� orden', c.CustomerID AS 'c�d. cliente', c.CompanyName AS 'cliente',
	  	   p.ProductName AS 'producto', od.Quantity AS 'cantidad', od.UnitPrice AS 'precio venta'
	  FROM [Order Details] AS od
	  	   INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
	  	   INNER JOIN Orders AS o ON(od.OrderID = o.OrderID)
	  	   INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)) AS co
WHERE co.[c�d. cliente] = 'ALFKI'
GO

/*EJERCICIO 03. Listar las compras de agosto de 1997*/
SELECT co.[c�d. cliente], co.cliente, co.[N� orden], co.producto, co.cantidad, co.[precio venta],
	   co.a�o, co.mes
FROM (SELECT c.CustomerID AS 'c�d. cliente', c.CompanyName AS 'cliente',
			 o.OrderID AS 'N� orden', p.ProductName AS 'producto',
			 od.Quantity AS 'cantidad', od.UnitPrice AS 'precio venta',
			 YEAR(o.OrderDate) AS 'a�o', MONTH(o.OrderDate) AS 'mes' 
	  FROM	Customers AS c
			INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Products AS p ON(od.ProductID = p.ProductID)) AS co
WHERE co.mes = 8 AND co.a�o = 1997
GO