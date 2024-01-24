/*-- COMPARANDO JOINS, SUBCONSULTAS Y FDU --

Este artículo explica como se debe analizar el resultado en la extracción de datos desde varias
tablas, compararemos los valores del «Plan de ejecución estimado» de las siguientes tres maneras:

1. Usando JOINS y Agrupamientos
2. Usando subconsultas
3. Usando funciones definidas por el usuario
*/
USE Northwind
GO

/*EJERCICIO 01. Listado de categorías, la cantidad de producto y cantidad de items en stock.
El resultado para las tres opciones es el que se muestra en la figura*/

--SOLUCIÓN: Utilizando JOINS a agrupamientos
SELECT c.CategoryID AS 'Cód. Categoría', c.CategoryName AS 'Categoría',
	   COUNT(p.ProductID) AS 'Cantidad Productos',
	   SUM(p.UnitsInStock) AS 'Items en Stock'
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GROUP BY c.CategoryID, c.CategoryName
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.0207087

--SOLUCIÓN: Usando subconsultas
SELECT c.CategoryID AS 'Cód. Categoría', c.CategoryName AS 'Categoría',
	   (SELECT COUNT(p.ProductID) 
	    FROM Products AS p
		WHERE p.CategoryID = c.CategoryID) AS 'Cantidad Productos',
		(SELECT SUM(p.UnitsInStock)
	    FROM Products AS p
		WHERE p.CategoryID = c.CategoryID) AS 'Items en Stock'
FROM Categories AS c 
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.013485

--SOLUCIÓN: Usando una función definida por el usuario
/*
Las FDU que retornan la cantidad de productos y la cantidad de productos en stock para cada 
categoría son como se muestran a continuación
*/
--FDU para la cantidad de productos de una categoría
CREATE FUNCTION fdu_cantidadProductosPorCategoria(@categoriaId INT)
RETURNS INT
AS
	BEGIN
		DECLARE @cantidad INT

		SELECT @cantidad = COUNT(p.ProductID)
	    FROM Products AS p
		WHERE p.CategoryID = @categoriaId

		RETURN @cantidad
	END
GO

--FDU para la cantidad de items de cada producto de una categoría
CREATE FUNCTION fdu_cantidadProductosEnStockPorCategoria(@categoriaId INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		DECLARE @cantidad AS NUMERIC(9,2)
		SET @cantidad = (SELECT SUM(p.UnitsInStock)
						 FROM Products AS p
						 WHERE p.CategoryID = @categoriaId)
		RETURN @cantidad
	END
GO

--Resultado requerido usando las FDU
SELECT c.CategoryID AS 'Cód. Categoría', c.CategoryName AS 'Categoría',
	   dbo.fdu_cantidadProductosPorCategoria(c.CategoryID) AS 'Cantidad Productos',
	   dbo.fdu_cantidadProductosEnStockPorCategoria(c.CategoryID) AS 'Items en Stock'
FROM Categories AS c
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.0032916

/*
COMPARANDO LOS COSTOS
Usando Joins y Agrupamientos: 0.0207087
Usando Subconsultas : 0.013485
Usando FDU : 0.0032916
Definitivamente para esta consulta la mejor opción es el uso de FDU.
*/

/*EJERCICIO 02. Listado de los empleados y la cantidad de órdenes generadas.*/

--SOLUCIÓN: Usando JOINS a agrupamientos
SELECT e.EmployeeID AS 'Cód. empleado', CONCAT_WS(' ', e.LastName, e.LastName) AS 'empleado',
	   (COUNT(o.OrderID)) AS 'cantidad órdenes'
FROM Employees AS e
	INNER JOIN Orders AS o ON(e.EmployeeID = o.EmployeeID)
GROUP BY e.EmployeeID, e.LastName, e.FirstName
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.0132493

--SOLUCIÓN: Usando SUBCONSULTAS
SELECT e.EmployeeID AS 'Cód. empleado', CONCAT_WS(' ', e.LastName, e.LastName) AS 'empleado',
	   (SELECT COUNT(o.OrderID) 
	    FROM Orders AS o
		WHERE o.EmployeeID = e.EmployeeID) AS 'cantidad órdenes'
FROM Employees AS e
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.0114172

--SOLUCIÓN: Usando una FDU
--Las FDU que retornan la cantidad de órdenes
CREATE FUNCTION fdu_cantidadOrdenesPorEmpleado(@employeeId INT)
RETURNS INT
AS
	BEGIN
		DECLARE @cantidad AS INT
		SET @cantidad = (SELECT COUNT(o.OrderID) 
						 FROM Orders AS o
						 WHERE o.EmployeeID = @employeeId)
		RETURN @cantidad
	END
GO

--El resultado requerido usando FDU
SELECT e.EmployeeID AS 'Cód. empleado', CONCAT_WS(' ', e.LastName, e.LastName) AS 'empleado',
	   dbo.fdu_cantidadOrdenesPorEmpleado(e.EmployeeID) AS 'cantidad órdenes'
FROM Employees AS e
GO
--El plan de ejecución estimado (costo de subárbol estimado): 0.0032928
/*
COMPARANDO LOS COSTOS
Usando Joins y Agrupamientos: 0.0132493
Usando Subconsultas : 0.0114172
Usando FDU : 0.0032928
Definitivamente para esta consulta la mejor opción es el uso de FDU.
*/



/*RECOMENDACIÓN
Analizar siempre el resultado usando el Plan de ejecución estimado y seleccionar la que 
tenga el menor valor en el costo estimado de sub árbol.
*/