/*-- SUBCONSULTAS CORRELACIONADAS Y NO CORRELACIONADAS EN SQL SERVER --

En este art�culo se va a explicar el uso de las subconsultas correlacionadas
y las subconsultas no correlacionadas. Dependiendo del dise�o de la base de datos siempre es 
conveniente probar diferentes formas de como hacer consultas complejas que impliquen varias tablas 
o an�lisis recursivo sobre la misma tabla. Para informaci�n b�sica Ver subconsultas.

Subconsultas correlacionadas
Las subconsultas correlacionadas son aquellas que ejecutan fila a fila en una consulta principal 
con el resultado de una consulta interna. Para cada fila de la consulta principal se evalua la 
consulta interna, si el resultado es verdadero la fila de la consulta principal es incluida en 
el conjunto de resultados.

Select para consultas correlacionadas

Sintaxis
Select Campo1, Campo2, Campo3, � 
from Tabla1 Alias
Where Expresi�n Operador
(select Expresi�nN1 
from Tabla2 
where Expresi�n = Alias.Expresi�n)

Note que hay una consulta principal y al filtrar usando la cl�usula Where se utiliza otra 
consulta (subconsulta interna).

Subconsultas no correlacionadas
Las subconsultas no correlacionadas se ejecutan una sola vez y reportan un conjunto
de resultados en base a una consulta principal
*/
USE Northwind
GO

/*EJERCICIO 01. Listar los productos cuyo precio de venta se encuentra por encima del precio
promedio de los productos de su categor�a*/

--Primero calcular el precio promedio de los productos de categor�a 1
SELECT AVG(p.UnitPrice)
FROM Products AS p
WHERE p.CategoryID = 1
GO

/*El resultado es: 37.9791, este valor puede variar si los precios son diferentes, la base de 
datos Northwind ha sido utilizada en ejercicios que pueden variar los valores, compruebe los 
resultados.
*/

--Los productos de la categor�a 1 ordenados por precio son  los siguientes
SELECT p.ProductID, p.ProductName, p.UnitPrice 
FROM Products AS p
WHERE p.CategoryID = 1
ORDER BY p.UnitPrice DESC
GO

/*
Ahora listar los productos de esa categor�a cuyo precio se encuentra por encima del promedio se 
incluir� la consulta para el promedio de precios en la cl�usula where de la consulta principal, 
note que se est� tomando como ejemplo los productos de la categor�a 1.
*/
SELECT p.ProductID, p.ProductName, p.UnitPrice 
FROM Products AS p
WHERE p.UnitPrice > (SELECT AVG(pp.UnitPrice)
					 FROM Products AS pp
					 WHERE pp.CategoryID = 1) AND 
	  p.CategoryID = 1
GO

--Ahora el resultado para todas las categorias, se incluir� el c�digo de la categor�a.
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.CategoryID
FROM Products AS p
WHERE p.UnitPrice > (SELECT AVG(pp.UnitPrice)
					 FROM Products AS pp
					 WHERE pp.CategoryID = p.CategoryID) 
ORDER BY p.CategoryID, p.UnitPrice DESC
GO

--Convertir la subconsulta correlacionada a una consulta JOIN
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.CategoryID
FROM Products AS p
	INNER JOIN (SELECT pp.CategoryID,AVG(pp.UnitPrice) AS promedio 
				FROM Products AS pp
				GROUP BY pp.CategoryID) AS prom ON(p.CategoryID = prom.CategoryID)
WHERE p.UnitPrice > prom.promedio
ORDER BY p.CategoryID, p.UnitPrice DESC
GO

/*EJERCICIO 02. Listar los productos que tengan stock inferior al promedio de stocks por categor�a.
Incluir el nombre del proveedor (suppliers) y la descripci�n de la categor�a, la descripci�n de la
categor�a se ha incluido con una subconsulta regular*/
SELECT p.ProductID AS 'c�digo' ,
	   p.ProductName AS 'descripci�n',
	   p.UnitPrice AS 'precio',
	   p.UnitsInStock AS 'stock',
	   (SELECT s.CompanyName 
	    FROM Suppliers AS s
		WHERE s.SupplierID = p.SupplierID) AS 'proveedor',
	   p.CategoryID AS 'c�d. categor�a',
	   (SELECT c.CategoryName
	    FROM Categories AS c
		WHERE c.CategoryID = p.CategoryID) AS 'categor�a'
FROM Products AS p
WHERE p.UnitsInStock < (SELECT AVG(pp.UnitsInStock) 
						FROM Products AS pp
						WHERE pp.CategoryID = p.CategoryID)
ORDER BY p.CategoryID, p.UnitsInStock DESC
GO


--Convirtiendo la misma consulta con JOINS
SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, 
		s.CompanyName, c.CategoryID, c.CategoryName
FROM Products AS p
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
WHERE p.UnitsInStock < (SELECT AVG(pp.UnitsInStock) 
						FROM Products AS pp
						WHERE pp.CategoryID = p.CategoryID)
ORDER BY p.CategoryID, p.UnitsInStock DESC
GO


/*EJERCICIO 03. Listar los clientes que tienen registrada por lo menos tres �rdenes*/
SELECT c.CustomerID AS 'c�d. cliente', c.CompanyName AS 'cliente',
	   (SELECT COUNT(o.OrderID) 
	   FROM Orders AS o
	   WHERE o.CustomerID = c.CustomerID) AS 'cantidad de �rdenes'
FROM Customers AS c
WHERE EXISTS (SELECT DISTINCT oo.CustomerID 
			  FROM Orders AS oo
			  WHERE oo.CustomerID = c.CustomerID)
			  AND
			  (SELECT COUNT(oor.CustomerID) 
			  FROM Orders AS oor
			  WHERE oor.CustomerID = c.CustomerID) >= 3
ORDER BY [cantidad de �rdenes]
GO

/*
En este ejercicio se ha incluido una subconsulta regular para la cantidad de �rdenes y la misma 
se ha utilizado para el filtro que indica que sean como m�nimo 3 �rdenes.
La subconsulta correlacionada es la que se usa para listar los Id de los clientes que tienen 
�rdenes registradas en el filtro usando el operador exists. (Select distinct O.CustomerId from 
Orders As O
where O.CustomerID = C.CustomerID)
*/