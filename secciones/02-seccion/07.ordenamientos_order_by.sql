/*-- ORDENAMIENTOS EN SQL SERVER - ORDER BY -- 

En muchas ocasiones se requiere listar los registros en un determinado orden, para esto se 
debe utilizar de manera correcta la cl�usula Order by de Select, se recomienda el uso de 
�ndices en los campos por los cuales se va a ordenar. 

ORDENAMIENTOS
- La Cl�usula ORDER BY, debe ir al final de la instrucci�n SELECT, salvo que se use Offset 
  y Fetch Next
- Se puede usar el nombre de campo, el al�as o el n�mero de orden del campo para especificar
  el orden.
- Se puede usar Desc y Asc (por defecto), se puede ordenar por varios campos
- No se puede ordenar por los campos ntext, text, image, geography, geometry, y xml.
- Es posible usar un campo de la tabla que no aparece en la lista de campos como el 
  campo de ordenamiento.
- Se sugiere mostrar los registros en las aplicaciones en controles que permitan el
  ordenamiento y no usar la cl�usula order by para extraerlos ordenados de la base de datos.
*/
USE Northwind
GO

/*EJERCICIO 01. Listar los empleados ordenados por apellidos*/
SELECT * 
FROM Employees
ORDER BY LastName
GO

/*EJERCICIO 02. Listar los clientes (Customers) ordenados por nombres*/
SELECT * 
FROM Customers
ORDER BY CompanyName
GO

/*EJERCICIO 03. Listar los productos ordneados por id de categor�a
y luego por precio unitario*/
SELECT * 
FROM Products
ORDER BY CategoryID DESC, UnitPrice ASC
GO

/*EJERCICIO 04. Listar los empleados ordenados por fecha de ingreso en orden
descendente*/
SELECT * 
FROM Employees
ORDER BY HireDate DESC
GO

/*EJERCICIO 05. Ordenar los productos de las categor�as 3, 5 y 8 que tienen stock
primero por categor�a en oden ascendente y el stock en orden descendente*/
SELECT * 
FROM Products
WHERE CategoryID IN(3, 5, 8) AND UnitsInStock > 0
ORDER BY CategoryID ASC, UnitsInStock DESC
GO

/*IMPORTANTE: Para el ordneamiento se puede usar el nombre del campo, el alias o
el n�mero de orden de aparici�n del campo despu�s de Orden By*/

/*EJERCICIO 06. Listado de los proveedores (Suppliers) ordenados por pa�s y por 
Nombre de compa��a*/

--Usando nombre de campo
SELECT * 
FROM Suppliers
ORDER BY Country, CompanyName
GO

--Usando el alias del campo
SELECT SupplierID AS id, Country AS pais, CompanyName AS empresa, ContactTitle AS contacto 
FROM Suppliers
ORDER BY pais, empresa
GO

--Usando el orden de aparici�n del campo
SELECT SupplierID AS id, Country AS pais, CompanyName AS compa��a, ContactTitle AS contacto 
FROM Suppliers
ORDER BY 2, 3
GO