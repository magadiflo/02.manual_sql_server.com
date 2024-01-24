/*-- ORDENAMIENTOS EN SQL SERVER - ORDER BY -- 

En muchas ocasiones se requiere listar los registros en un determinado orden, para esto se 
debe utilizar de manera correcta la cláusula Order by de Select, se recomienda el uso de 
índices en los campos por los cuales se va a ordenar. 

ORDENAMIENTOS
- La Cláusula ORDER BY, debe ir al final de la instrucción SELECT, salvo que se use Offset 
  y Fetch Next
- Se puede usar el nombre de campo, el alías o el número de orden del campo para especificar
  el orden.
- Se puede usar Desc y Asc (por defecto), se puede ordenar por varios campos
- No se puede ordenar por los campos ntext, text, image, geography, geometry, y xml.
- Es posible usar un campo de la tabla que no aparece en la lista de campos como el 
  campo de ordenamiento.
- Se sugiere mostrar los registros en las aplicaciones en controles que permitan el
  ordenamiento y no usar la cláusula order by para extraerlos ordenados de la base de datos.
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

/*EJERCICIO 03. Listar los productos ordneados por id de categoría
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

/*EJERCICIO 05. Ordenar los productos de las categorías 3, 5 y 8 que tienen stock
primero por categoría en oden ascendente y el stock en orden descendente*/
SELECT * 
FROM Products
WHERE CategoryID IN(3, 5, 8) AND UnitsInStock > 0
ORDER BY CategoryID ASC, UnitsInStock DESC
GO

/*IMPORTANTE: Para el ordneamiento se puede usar el nombre del campo, el alias o
el número de orden de aparición del campo después de Orden By*/

/*EJERCICIO 06. Listado de los proveedores (Suppliers) ordenados por país y por 
Nombre de compañía*/

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

--Usando el orden de aparición del campo
SELECT SupplierID AS id, Country AS pais, CompanyName AS compañía, ContactTitle AS contacto 
FROM Suppliers
ORDER BY 2, 3
GO