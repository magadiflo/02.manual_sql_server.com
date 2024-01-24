/*-- CONSULTAS EN SQL SERVER - OPCIONES --

Las opciones de un listado con la instrucción select permiten modificar el conjunto 
de resultados, las opciones son cláusulas adicionales que nos permiten reducir la 
cantidad de registros en el listado, mostrar registros únicos, obligar al optimizar 
a usar un  índice, combinar dos instrucciones, entre otras opciones.

Las opciones son:
- Top: Limita las filas del conjunto de resultados. Se puede usar con un valor n o 
       especificar un porcentaje. Se usa junto a la cláusula Order By.
- With Ties: Permite mostrar registros que hayan sido limitados usando la opción Top 
       pero que tienen un valor igual al último registro que aparece.
- Distinct: Permite mostrar valores sin duplicados en una consulta
- With (index...): Obliga al optimizador a usar un índice específico
- Union: Permite unir diferentes consultas en un solo conjunto de resultados
- Into Tabla: Permite crear una tabla con el conjunto de resultados
- Offset y Fetch Next: Permite listar un grupo de resultados que aparecen ordenados
			pero sin incluir los primeros
*/
USE Northwind
GO

/*EJERCICIO 01. Listar los productos ordenados por precio, mostrar los 
10 más caros*/
SELECT TOP 10 * 
FROM Products
ORDER BY UnitPrice DESC
GO

/*EJERCICIO 02. Listar las órdenes con más monto, mostrar el 20% de estas.*/
SELECT TOP 20 PERCENT * 
FROM Orders
ORDER BY Freight DESC
GO

/*EJERCICIO 03. Listar los 5 empleados que generaron más órdenes, incluir los que
tengan la misma cantidad del quinto*/
SELECT TOP 5 WITH TIES e.EmployeeID, e.FirstName, COUNT(o.OrderID) AS 'Ordenes'
FROM Orders AS o
	INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
GROUP BY e.EmployeeID, e.FirstName
ORDER BY Ordenes DESC
GO

--OBLIGAR AL OPTIMIZADOR A USAR UN ÍNDICE

/*EJERCICIO 04. Listar los productos usando el índice ProductName cuyo campo
de indexación es el campo ProductName. Esta cláusula es similar a usar un 
ORDER BY*/
SELECT * 
FROM Products
WITH(INDEX(ProductName))
GO


USE AdventureWorks
GO

/*EJERCICIO 05. Listar los empleados ordenados por el N° ID. 
(índice AK_Employee_NationalIDNumber)*/
SELECT p.FirstName AS 'Nombre', p.LastName AS 'Apellidos', e.NationalIDNumber AS 'N° ID'
FROM HumanResources.Employee AS e
WITH(INDEX(AK_Employee_NationalIDNumber)) 
	INNER JOIN Person.Person AS p ON(e.BusinessEntityID = p.BusinessEntityID)
WHERE p.LastName = 'Johnson'
GO

/*EJERCICIO 06. Usando el índice 0(la clave primaria - índice agrupao)*/
SELECT p.FirstName AS 'Nombre', p.LastName AS 'Apellidos', e.NationalIDNumber AS 'N° ID'
FROM HumanResources.Employee AS e
WITH(0) 
	INNER JOIN Person.Person AS p ON(e.BusinessEntityID = p.BusinessEntityID)
WHERE p.LastName = 'Johnson'
GO

--USO DE DISTINCT 

/*EJERCICIO 07. Usando Northwind, listado de los clientes que compraron en 
el primer mes de 1998*/
USE Northwind
GO

SELECT DISTINCT c.CustomerID AS codigo, c.CompanyName AS cliente
FROM Orders AS o
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE MONTH(o.OrderDate) = 1 AND YEAR(o.OrderDate) = 1998
ORDER BY cliente
GO

--USO DE UNION SIMPLE

/*EJERCICIO 08. Listado de los productos de las categorías 3 y 5 unida con los
productos de las categorías 2, 6, 8*/
SELECT ProductID, ProductName, UnitPrice, CategoryID
FROM Products
WHERE CategoryID IN(3, 5)

UNION 

SELECT ProductID, ProductName, UnitPrice, CategoryID
FROM Products
WHERE CategoryID IN(2,6,8)
GO

/* -- USO DE OFFSET Y FETCH NEXT -- 
El uso de OFFSET N ROWS va a permitir obviar los N registros superiores y el uso de FETCH NEXT
va a limitar a una cantidad determinada de registros en el listado
*/

/*EJERCICO 09. Listar los 10 registros (Products) más caros exceptuando los 5 primeros*/
SELECT * 
FROM Products
ORDER BY UnitPrice DESC
OFFSET 5 ROWS
FETCH NEXT 10 ROWS ONLY
GO

--CREANDO TABLAS RESULTADO DE UN SELECT INTO TABLA
/*EJERCICIO 10. Crear una tabla ProductosCategoriaBebidas(id=1)*/
SELECT *
INTO ProductosCategoriaBebidas 
FROM Products
WHERE CategoryID = 1
GO

--Para visualizar los registros de la tabla generada
SELECT * 
FROM ProductosCategoriaBebidas 
GO

/*IMPORTANTE: La tabla creada con Into se crea sin restricciones.*/
SP_HELP ProductosCategoriaBebidas