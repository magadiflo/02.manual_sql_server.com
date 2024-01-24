/*-- CONSULTAS - FILTRADO DE REGISTROS CON WHERE --

Filtrar un conjunto de resultados permite listar los registros que cumplan con 
una o mas condiciones. Los Filtros pueden ser especificados en campos de la tabla 
dentro de la cláusula Where, y en listados con campos que tienen funciones de 
agregado en la cláusula Having.

Para las expresiones lógicas se utilizan los operadores de comparación y 
los operadores propios de SQL. 

*/
USE Northwind
GO

--Listar los productos con stock igual a cero (0)
SELECT * 
FROM Products
WHERE UnitsInStock = 0
GO

--Listar los clientes que son de las ciudades de Madrid, Barcelona y Sao Paulo
SELECT * 
FROM Customers
WHERE City IN('Madrid', 'Barcelona', 'Sao Paulo')
GO

--Listar los productos con precios entre 20 y 40
SELECT * 
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
GO

--Listar los empleados con 25 años o más en el trabajo
SELECT DATEDIFF(YEAR, HireDate, GETDATE()) AS [Años de trabajo], *
FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) >= 25
GO

--Listar los productos descontinuados con unidades en stock
SELECT * 
FROM Products
WHERE Discontinued = 1 AND UnitsInStock > 0
GO

--Listar los productos cuya ProductName inicia con la letra C
SELECT * 
FROM Products
WHERE ProductName LIKE 'C%'
GO

--Listar los clientes cuyo título de contacto sea el Manager
SELECT * 
FROM Customers
WHERE ContactTitle LIKE '%Manager%'
GO

--Listar las órdenes (Orders) que fueron atendidas después de 5 días
SELECT DATEDIFF(DAY, OrderDate, ShippedDate) AS [Días de espera], * 
FROM Orders
WHERE DATEDIFF(DAY, OrderDate, ShippedDate) > 5
GO

--Listar los empleados de la ciudad de Seattle en el país USA
SELECT * 
FROM Employees
WHERE Country = 'USA' AND City = 'Seattle'
GO

--Listar los proveedores (Suppliers) de France que no tienen 
--asignada una Región (Null)
SELECT * 
FROM Suppliers
WHERE Country = 'France' AND Region IS NULL
GO