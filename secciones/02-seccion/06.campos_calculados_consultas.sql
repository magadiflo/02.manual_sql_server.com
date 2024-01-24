/*-- CAMPOS CALCULADOS EN CONSULTAS -- 

Los campos calculados en una consulta son campos que se construyen en base a los existentes en 
la tabla.

Los campos calculados siguen cualquiera de los formatos siguientes:
NombreCampoCalculado = Expresión que lo calcula		O 
Expresión que lo calcula As 'Nombre de campo calculado'

Si el nombre del campo calculado incluye espacios se debe encerrar entre corchetes.

*/
USE Northwind
GO

/*EJERCICIO 01. El código del empleado y su nombre completo (el nombre completo no existe
en la tabla)
*/
SELECT EmployeeID, FirstName + Space(1) + LastName AS 'empleado'
FROM Employees
GO
--Otra forma
SELECT EmployeeID, empleado = FirstName + Space(1) + LastName
FROM Employees
GO

/*EJERCICIO 02. Empleado y su edad (en la tabla hay fecha de nacimiento)*/
SELECT EmployeeID, FirstName + Space(1) + LastName AS 'empleado', 
	   FORMAT(BirthDate, 'dd/MM/yyyy') AS nacimiento,
	   FORMAT(GETDATE(), 'dd/MM/yyyy') AS [Fecha actual],
	   DATEDIFF(YEAR, BirthDate, GETDATE()) AS [Edad en este año],
	   CAST(DATEDIFF(DAY, BirthDate, GETDATE())/365.25 AS INT) AS [Edad según el mes actual del año]
FROM Employees
GO

/*EJERCICIO 03. Los productos y el valor del Stock(Precio * Stock)*/
SELECT ProductName AS 'Producto', UnitsInStock AS 'Stock', UnitPrice AS 'Precio',
	   (UnitPrice * UnitsInStock) AS 'Valor del stock'
FROM Products
GO

/*EJERCICIO 04. Productos y las uniddes de compra urgente. Existen unidades para
comprar urgente cuando el stock es menor a las unidades en orden*/
SELECT ProductName, UnitsInStock, UnitsOnOrder, 
       IIF(UnitsInStock < UnitsOnOrder, UnitsOnOrder - UnitsInStock, 0) AS 'Por comprar'
FROM Products
GO

/*EJERCICIO 05. Las órdenes, el monto total de la misma y el impuesto, suponiendo
que se trate de un 12%*/
SELECT OrderID, FORMAT(OrderDate, 'dd/MM/yyyy') AS 'Fecha de orden',
	   Freight AS 'Monto', 
	   impuesto = Freight * 0.12
FROM Orders
GO

/*
- Puede incluirse la cantidad de campos calculados que se necesite, estos siempre se 
  calculan en base a los campos existentes en la tabla.
- Es recomendable para optimizar el trabajo de las consultas, incluir en las tablas 
  los campos calculados que se usan con frecuencia.
*/