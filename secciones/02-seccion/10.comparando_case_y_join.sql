/*-- ESTRUCTURA CASE COMPARADA CON JOIN --

La estructura CASE evalua una expresi�n condicional y retorna uno de m�ltiples resultados.

- La estructura CASE tiene dos formas: 
* La expresi�n CASE simple compara una expresi�n con un conjunto de expresiones simples para 
  determinar el resultado.
* La expresi�n CASE buscada eval�a un conjunto de expresiones booleanas para determinar el
  resultado.

Ambos formatos admiten un argumento ELSE opcional

IMPORTANTE
- CASE se puede usar en cualquier declaraci�n o cl�usula que permita una expresi�n v�lida
- La estructura CASE se puede usar en SELECT, UPDATE, DELETE y SET
- Tambi�n se puede usar en la lista de campos de la instrucci�n SELECT y en las expresiones
  con el operador IN y las cl�usulas WHERE, ORDER BY y HAVING.

En este art�culo vamos a comparar el uso de Case con un Join, es necesario resaltar que si 
las opciones posibles del Case cambian, es necesario reescribir la consulta.
*/
USE Northwind
GO

/*EJERCICIO 01.*/
--a. Usando CASE para la lista de productos y los nombres de las categor�as
SELECT ProductID AS 'C�digo', ProductName AS 'Descripci�n',
	    CASE CategoryID
			WHEN 1 THEN 'Bebidas'
			WHEN 2 THEN 'Condimentos'
			WHEN 3 THEN 'Confecciones'
			WHEN 4 THEN 'Productos Diarios'
			WHEN 5 THEN 'Cereales'
			WHEN 6 THEN 'Carnes'
			WHEN 7 THEN 'Conservas'
			WHEN 8 THEN 'Productos marinos'
	    END AS 'Categor�a'
FROM Products
GO
--COSTO: 0.0048571

--b. Usando JOIN para listar los productos y sus categor�as
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products AS p
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO
--COSTO: 0.0206321

/*RESULTADOS:
Si comparamos los valores, Case en este caso es es mas r�pido, al usar Join la consulta tiene un 
costo de 5,63 veces mayor, es necesario anotar nuevamente que si las categor�as cambian, la consulta 
usando Case es necesario reescribirla.
*/

/*EJERCICIO 02.*/
--a. Usando las tablas Region y Territories con CASE
SELECT t.TerritoryID AS 'C�digo', t.TerritoryDescription AS 'Territorio', 
		CASE t.RegionID
			WHEN 1 THEN 'Este'
			WHEN 2 THEN 'Oeste'
			WHEN 3 THEN 'Norte'
			WHEN 4 THEN 'SUR'
		END AS 'Regi�n'
FROM Territories AS t
GO
--COSTO: 0.0033456

--b.Usando JOIN para listar los territorios y las regiones a las que pertenecen
SELECT t.TerritoryID AS 'C�digo', t.TerritoryDescription AS 'Territorio', 
	   r.RegionDescription AS 'Regi�n'
FROM Territories AS t
	INNER JOIN Region AS r ON(t.RegionID = r.RegionID)
GO
--COSTO: 0.0248898
