/*-- SELECT - USO DE ALIAS --

Los alias para los campos o para la tabla son nombres asignados que aparecen en la ejecuci�n de la 
consulta. Los nombres de la tabla o de los campos en la base de datos no cambian. Los alias pueden 
ser usados en el ordenamiento de los registros que forman el grupo de resultado de la consulta.
En consultas donde se extrae la informaci�n desde varias tablas es necesario usar alias para las 
tablas y los campos para evitar ambig�edades las que posiblemente causen que la consulta reporte error.

*/
USE Northwind
GO

--Todos los campos de una tabla
SELECT * FROM Suppliers
GO

--De preferencia escribir todos los campos
SELECT SupplierID, CompanyName, ContactName, ContactTitle, Address, City, Region, PostalCode, 
	   Country, Phone, Fax, HomePage
FROM Suppliers
GO

--Algunos campos
SELECT SupplierID, CompanyName, ContactName, City, Country, Phone
FROM Suppliers
GO

--Incluir Alias a los campos y a la tabla
SELECT s.SupplierID AS 'C�digo', s.CompanyName AS 'Proveedor', s.ContactName AS 'Contacto',
	   s.City AS 'Ciudad'
FROM Suppliers AS s
GO

/*La imagen muestra los nombres asignados a cada campo en la ejecuci�n de la consulta, estos
alias no cambian los nombres de los campos en la tabla.
En la tabla Suppliers se ha incluido el Alias s, el que se puede utilizar antes del nombre del campo.
Para incluir un alis al campo se escribe el nombre de campo, luego la palabra AS y luego el 
alias entre ap�strofes.
El formato del campo con alias de su tabla ser�a: 
AliasTabla.nombreCampo AS 'Alias del campo'

Se puede obviar la palabra AS al especificar el alias

Si el alias es una sola palabra se pueden obviar los ap�strofes.
*/
--La orden anterior puede ser
SELECT S.SupplierID C�digo, S.CompanyName As 'Proveedor',
S.ContactName 'Contacto', City As Ciudad
FROM Suppliers S
go

/*
Note que el campo City no tiene el alias de la tabla, el campo SupplierID no tiene la palabra As ni 
los ap�strofes, el campo ContactName no tiene la palabra As y el alias de City no tiene ap�strofes.

Se recomienda para la mejor visualizaci�n usar As y los ap�strofes.
Los campos en la instrucci�n pueden incluirse en cualquier orden.

Es conveniente usar el alias de la tabla para que al seleccionar los campos a incluir el 
Intellisense muestre la lista de estos y sea mas f�cil la construcci�n del Select.

En la imagen se muestra como construir de manera mas sencilla el select, escribir el nombre 
de la tabla y su alias, para el ejemplo la tabla es Categories y su alias es la letra C, 
luego regresar a la lista de campos, al escribir el alias y poner el Punto, el Intellisense
muestra los campos de la tabla.

Si no se asigna un alias a la tabla, el alias es el nombre de �sta (tabla)
*/

--Campos en cualquier orden
SELECT e.lastName AS 'Apellido', e.firstName AS 'Nombre', e.address AS 'Direcci�n', 
       e.employeeID AS 'C�digo'
FROM Employees AS e
GO

--Los alias pueden incluir m�s de una palabra, en este caso no se pueden obviar los ap�strofes
SELECT p.productName AS 'Descripci�n del producto', 
	   p.UnitPrice AS 'Precio unitario',
	   p.UnitsInStock AS 'Stock Actual',
	   p.ProductID AS 'C�digo'
FROM Products AS p
GO

--Los alias se puede usar en el ordenamiento

--Listar los productos ordenador por el precio unitario descendentemente
SELECT p.ProductName AS 'Descripci�n del producto', 
	   p.UnitPrice AS 'Precio unitario',
	   p.UnitsInStock AS 'Stock Actual',
	   p.ProductID AS 'C�digo'
FROM Products AS p
ORDER BY [Precio unitario] DESC
GO

-- El alias de la tabla no es necesario que siempre sea una letra, pero resulta mas sencillo 
-- para construir la consulta.
SELECT cli.CompanyName AS 'Cliente', cli.Country AS 'Pa�s'
FROM customers AS cli
GO