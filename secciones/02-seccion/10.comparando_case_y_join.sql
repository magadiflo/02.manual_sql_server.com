/*-- ESTRUCTURA CASE COMPARADA CON JOIN --

La estructura CASE evalua una expresión condicional y retorna uno de múltiples resultados.

- La estructura CASE tiene dos formas: 
* La expresión CASE simple compara una expresión con un conjunto de expresiones simples para 
  determinar el resultado.
* La expresión CASE buscada evalúa un conjunto de expresiones booleanas para determinar el
  resultado.

Ambos formatos admiten un argumento ELSE opcional

IMPORTANTE
- CASE se puede usar en cualquier declaración o cláusula que permita una expresión válida
- La estructura CASE se puede usar en SELECT, UPDATE, DELETE y SET
- También se puede usar en la lista de campos de la instrucción SELECT y en las expresiones
  con el operador IN y las cláusulas WHERE, ORDER BY y HAVING.

En este artículo vamos a comparar el uso de Case con un Join, es necesario resaltar que si 
las opciones posibles del Case cambian, es necesario reescribir la consulta.
*/
USE Northwind
GO

/*EJERCICIO 01.*/
--a. Usando CASE para la lista de productos y los nombres de las categorías
SELECT ProductID AS 'Código', ProductName AS 'Descripción',
	    CASE CategoryID
			WHEN 1 THEN 'Bebidas'
			WHEN 2 THEN 'Condimentos'
			WHEN 3 THEN 'Confecciones'
			WHEN 4 THEN 'Productos Diarios'
			WHEN 5 THEN 'Cereales'
			WHEN 6 THEN 'Carnes'
			WHEN 7 THEN 'Conservas'
			WHEN 8 THEN 'Productos marinos'
	    END AS 'Categoría'
FROM Products
GO
--COSTO: 0.0048571

--b. Usando JOIN para listar los productos y sus categorías
SELECT p.ProductID, p.ProductName, c.CategoryName
FROM Products AS p
	INNER JOIN Categories AS c ON(p.CategoryID = c.CategoryID)
GO
--COSTO: 0.0206321

/*RESULTADOS:
Si comparamos los valores, Case en este caso es es mas rápido, al usar Join la consulta tiene un 
costo de 5,63 veces mayor, es necesario anotar nuevamente que si las categorías cambian, la consulta 
usando Case es necesario reescribirla.
*/

/*EJERCICIO 02.*/
--a. Usando las tablas Region y Territories con CASE
SELECT t.TerritoryID AS 'Código', t.TerritoryDescription AS 'Territorio', 
		CASE t.RegionID
			WHEN 1 THEN 'Este'
			WHEN 2 THEN 'Oeste'
			WHEN 3 THEN 'Norte'
			WHEN 4 THEN 'SUR'
		END AS 'Región'
FROM Territories AS t
GO
--COSTO: 0.0033456

--b.Usando JOIN para listar los territorios y las regiones a las que pertenecen
SELECT t.TerritoryID AS 'Código', t.TerritoryDescription AS 'Territorio', 
	   r.RegionDescription AS 'Región'
FROM Territories AS t
	INNER JOIN Region AS r ON(t.RegionID = r.RegionID)
GO
--COSTO: 0.0248898
