/*-- CLÁUSULA UNIÓN EN SELECT --

- El operador UNION permite combinar resultados de varias consultas con SELECT en un único
  resultado.
- Todas las instrucciones SELECT deben tener la misma cantidad de campos y todos los campos
  deben ser datos compatibles.
- Los nombres de los campos del conjunto de resultados son iguales a los especificados
  en la primera consulta.
- Los resultados que se repiten son eliminados al hacer una combinación de SELECT usando
  UNION. 
- Tenga en cuenta la intercalación del servicor de la base de datos para que SQL Server
  decida cuándo dos datos de tipo caracter son iguales o diferentes.
- Se puede especificar la palabra ALL para que los resultados repetidos no se eliminen 
  del conjunto de resultados final.
- Se debe especificar solamente una cláusula ORDER BY y se escribe al final de la 
  instrucción. 
- No es posible hacer UNION con bases de datos que tienen diferente intercalación.
- No se puede incluir campos de tipo nText
*/

USE Northwind
GO

/*EJERCICIO 01. Listar los productos del a categoría 1 y los productos de la categoría 5*/
SELECT *
FROM Products
WHERE CategoryID = 1

UNION

SELECT *
FROM Products
WHERE CategoryID = 5
GO

/*EJERCICIO 02. Listar los clientes de France, Spain y Canada*/
SELECT CustomerID AS 'Código', CompanyName AS 'Cliente', Country AS 'País'
FROM Customers
WHERE Country = 'France'

UNION

SELECT CustomerID AS 'Código', CompanyName AS 'Cliente', Country AS 'País'
FROM Customers
WHERE Country = 'Spain'

UNION

SELECT CustomerID AS 'Código', CompanyName AS 'Cliente', Country AS 'País'
FROM Customers
WHERE Country = 'Canada'
ORDER BY Country, Cliente
GO

/*EJERCICIO 03. Listar los proveedores de que tienen más de 3 productos registrados o
los que tienen un producto. Ordenar por cantidad de productos descendentemente.*/
SELECT s.SupplierID, s.CompanyName, s.ContactName, COUNT(p.SupplierID) AS 'Cant. de productos'
FROM Products AS p 
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
GROUP BY s.SupplierID, s.CompanyName, s.ContactName
HAVING COUNT(s.SupplierID) > 3

UNION

SELECT s.SupplierID, s.CompanyName, s.ContactName, COUNT(p.SupplierID) AS 'Cant. de productos'
FROM Products AS p 
	INNER JOIN Suppliers AS s ON(p.SupplierID = s.SupplierID)
GROUP BY s.SupplierID, s.CompanyName, s.ContactName
HAVING COUNT(s.SupplierID) = 1

ORDER BY 'Cant. de productos' DESC
GO