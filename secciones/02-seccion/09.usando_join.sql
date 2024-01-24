/*-- CONSULTAS DE VARIAS TABLAS - USANDO JOIN --

Para escribir consultas cuyos datos que se desea mostrar se encuentran en varias tablas 
es necesario que estas est�n CORRECTAMENTE relacionadas, antes de hacer las consultas 
desde varias tablas se deben evitar y corregir los valores Null en la base de datos. 
Es convenientes que las relaciones entre tablas cumplan con la integridad de datos.

Para optimizar las consultas desde varias tablas se recomienda usar Join de la manera 
como se muestran en los ejercicios. Siempre hay una tabla desde donde se va a listar los 
registros y otras desde donde se van a extraer valores para completar el listado con 
datos que la hacen mas detallada.

Para usar un Join existen varias formas, en este art�culo se explica el uso del join de 
la manera m�s simple, la cl�usula Join se escribe despu�s de la cl�usula From, es 
conveniente definir de manera correcta las dos tablas que se relacionan, existe un campo 
com�n entre las dos tablas, en la tabla principal es la PK y en la tabla con la que se 
relacionar� es la FK.

Se recomienda usar alias adecuados para las tablas y los campos en el listado desde 
varias tablas.
*/

USE Northwind
GO

/*EJERCICIO 01. Listado de las �rdenes y el nombre del cliente*/
SELECT o.OrderID AS Orden, o.Freight AS Monto, c.CompanyName AS Cliente
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
GO

/*EJERCICIO 02. Listado de las �rdenes y el nombre del empleado que las gener�*/
SELECT o.OrderID AS Orden, o.Freight AS Monto, 
	   e.FirstName + SPACE(1) + e.LastName AS Empleado
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GO

/*EJERCICIO 03. Listado de las �rdenes y los nombres del cliente y del empleado
que las gener�*/
SELECT o.OrderID AS Orden, o.Freight AS Monto, c.CompanyName AS Cliente,
       e.FirstName + SPACE(1) + e.LastName AS Empleado
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GO

/*EJERCICIO 04. Producto y su categor�a*/
SELECT p.ProductID AS c�digo, p.ProductName, p.UnitPrice, c.CategoryName
FROM Products AS p
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO

/*EJERCICIO 05. El detalle de la orden 10275, incluyendo el nombre del producto*/
SELECT	o.OrderID AS [N� Orden], 
		od.ProductID AS [C�d. Producto], 
		p.ProductName AS descipci�n,
		od.UnitPrice AS Precio, 
		od.Quantity AS Cantidad
FROM Orders AS o 
	INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
	INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
WHERE o.OrderID = '10275'
GO

/*EJERCICIO 06. Listado de productos y el proveedor*/
SELECT p.ProductName, s.CompanyName
FROM Products AS p
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
GO

/*EJERCICIO 07. Listado de �rdenes y las compa��as que la envi�*/
SELECT o.OrderID, o.Freight AS 'Monto', s.CompanyName AS 'Courier'
FROM Orders AS o
	INNER JOIN Shippers AS s ON(o.ShipVia = s.ShipperID)
GO

/*EJERCICIO 08. Incluir en la orden anterior el nombre del empleado que gener�
la orden y el cliente*/
SELECT o.OrderID, o.Freight AS 'Monto', s.CompanyName AS 'Courier',
	   e.FirstName + SPACE(1) + e.LastName AS Empleado,
	   c.CompanyName AS Cliente
FROM Orders AS o
	INNER JOIN Shippers AS s ON(o.ShipVia = s.ShipperID)
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
GO

/*RECOMENDACIONES:
- Al usar Join, antes de realizar listados, deben eliminarse los valores Null de la 
  base de datos.
- En el dise�o de su base de datos debe estar correctamente definidas las claves primarias 
  de las tablas y las claves for�neas de las mismas para que los datos ingresados tengan 
  consistencias e integridad.
- Al utilizar Join, despu�s de la palabra ON la primera tabla de la igualdad es la 
  principal, la que se encuentra despu�s de la cl�usula From, en la parte derecha de la 
  igualdad va la tabla referenciada despu�s de la palabra join.
*/