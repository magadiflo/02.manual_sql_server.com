/*-- SUBCONSULTAS - CASOS PRÁCTICOS 3 --*/

USE Northwind
GO

/*EJERCICI0 01. Listar los empleados y la cantidad de órdenes generadas*/

--Usando Subconsulta:
--Costo de subárbol: 0.0114163
SELECT e.EmployeeID, e.LastName, e.FirstName, 
       (SELECT COUNT(o.OrderID)
	   FROM Orders AS o
	   WHERE o.EmployeeID = e.EmployeeID) AS 'cantidad de órdenes' 
FROM Employees AS e
GO

--Usando Join
--Costo de subárbol: 0.0132484
SELECT e.EmployeeID, e.LastName, e.FirstName,COUNT(o.OrderID) AS 'cantidad de órdenes' 
FROM Employees AS e
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GROUP BY e.EmployeeID, e.LastName, e.FirstName
GO

/*EJERCICIO 02. Listar órdenes de los clientes de méxico y francia*/
SELECT o.OrderID, o.OrderDate, 
	  (SELECT e.LastName + ' ' + e.FirstName 
	   FROM Employees AS e
	   WHERE e.EmployeeID = o.EmployeeID) AS 'empleado',
	  (SELECT cu.CompanyName 
	   FROM Customers AS cu
	   WHERE cu.CustomerID = o.CustomerID) AS 'cliente',
	  (SELECT cu.Country
	   FROM Customers AS cu
	   WHERE cu.CustomerID = o.CustomerID) AS 'país'
FROM Orders AS o
WHERE o.CustomerID IN (SELECT c.CustomerID 
					   FROM Customers AS c
					   WHERE c.Country IN('Mexico', 'France'))

GO