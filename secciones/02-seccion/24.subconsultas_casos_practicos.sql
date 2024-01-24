/*-- SUBCONSULTAS - CASOS PR�CTICOS --

Las subconsultas permiten extraer informaci�n que incluyen varias tablas, estas generalmente reportan 
un solo dato a un conjunto de resultados con una columna. 

En este art�culo veremos como desarrollar ejemplos analizando los datos y armando por pasos 
la subconsulta

Pueden utilizarse de dos formas:

1. Dentro de la Lista de campos de la instrucci�n Select

select ListaCampos, (Select Campo from TablaSubconsulta where�)  from TablaPrincipal

2. En la cl�sula Where

Select ListadeCampos, OtroCampo, UltimoCampo from Tabla
Where Campo =( Select� )

*/
USE Northwind
GO

/*EJERCICIO 01. Listado de clientes que compraron en Agosto de 1997*/
SELECT * 
FROM Customers AS c
WHERE c.CustomerID IN (SELECT DISTINCT o.CustomerID
					  FROM Orders AS o
					  WHERE MONTH(o.OrderDate) = 7 AND YEAR(o.OrderDate) = 1997)
GO

--Note la subconsulta despu�s del IN (....esta es la subconsulta....)

/*EJERCICIO 02. Listado con las cantidades vendidas de los productos discontinuados (1).
Incluir solamente los que tienen Stock*/

SELECT p.ProductID, p.ProductName, p.UnitPrice,
       (SELECT SUM(od.Quantity) 
	    FROM [Order Details] AS od
		WHERE od.ProductID = p.ProductID) AS 'cantidad vendida'
FROM Products AS p
WHERE p.Discontinued = 1 AND p.UnitsInStock > 0
GO

/*EJERCICIO 03. Empleados y la cantidad de �rdenes generadas y no atendidas*/
SELECT e.EmployeeID, CONCAT_WS(' ', e.LastName, e.FirstName) AS empleado,
       (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.ShippedDate IS NULL AND
		      o.EmployeeID = e.EmployeeID) AS '�rdenes no atendidas'
FROM Employees AS e
WHERE (SELECT COUNT(o.OrderID)
	    FROM Orders AS o
		WHERE o.ShippedDate IS NULL AND
		      o.EmployeeID = e.EmployeeID) > 0
ORDER BY [�rdenes no atendidas] DESC
GO