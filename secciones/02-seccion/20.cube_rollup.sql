/*-- USO DE CUBE Y ROLLUP PARA SUBTOTALES --

AGRUPAMIENTO INCLUYENDO SUBTOTALES EN SELECTS

USO DE CUBE O ROLLUP
--------------------
Los operadores CUBE o ROLLUP son extensiones de la cláusula GROUP BY. Permiten calcular 
subtotales de acuerdo a las agrupaciones especificadas en la consulta.

IMPORTANTE
Para que las opciones funcionen, el nivel de compatibilidad debe ser al menos 100
correspondientes a SQL Server 2008

Usando Northwind
Cambiar la compatibilidad de la BD a 100

*/
USE Master
GO

/* No lo usé
ALTER DATABASE Northwind
SET COMPATIBILITY_LEVEL = 100
GO
*/

USE Northwind
GO

/*EJERCICIO 01. Listar los clientes, la cantidad de órdenes por año y el total de las órdenes
(Valores sumados). Incluir el total por año (use cube)*/

SELECT c.CompanyName AS 'cliente', YEAR(o.OrderDate) AS 'año', COUNT(o.OrderID) AS 'cant. órdenes',
	   SUM(o.Freight) AS 'monto total'    
FROM Customers AS c 
	INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
GROUP BY CUBE(c.CompanyName, YEAR(o.OrderDate))
GO

--Para poder visualizar los resultados, mostramos los clientes cuyo nombre inicia con A
SELECT c.CompanyName AS 'cliente', YEAR(o.OrderDate) AS 'año', COUNT(o.OrderID) AS 'cant. órdenes',
	   SUM(o.Freight) AS 'monto total'    
FROM Customers AS c 
	INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
WHERE c.CompanyName LIKE 'A%'
GROUP BY CUBE(c.CompanyName, YEAR(o.OrderDate))
GO
/*Los resultados se muestran en la siguiente imagen, note que después de cada año se incluye
un total y al final se incluye un total general
*/

/*EJERCICIO 02. Listar los empleados (nombre completo), el año y la cantidad de órdenes por año*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado', 
	   YEAR(o.OrderDate) AS 'año', 
	   COUNT(o.OrderID) AS 'cant. órdenes'
FROM Employees AS e 
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GROUP BY CUBE(CONCAT_WS(' ', e.LastName, e.FirstName),  YEAR(o.OrderDate))
GO

/*EJERCICIO 03. Listar la cantidad de órdenes por año e incluir el total general al finalizar*/
SELECT COUNT(OrderID) AS 'cant. órdenes', YEAR(OrderDate) AS 'año'
FROM Orders
GROUP BY YEAR(OrderDate)
WITH ROLLUP
GO

/*EJERCICIO 04. Listar los empleados y la cantidad de órdenes y monto total por año. Mostrar
los totales por empleado*/
SELECT CONCAT_WS(' ', e.LastName, e.FirstName) AS 'empleado', 
	   YEAR(o.OrderDate) AS 'año', 
	   COUNT(o.OrderID) AS 'cant. órdenes'
FROM Employees AS e 
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GROUP BY CONCAT_WS(' ', e.LastName, e.FirstName),  YEAR(o.OrderDate)
WITH ROLLUP
GO
