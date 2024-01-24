/*-- USANDO UNION EN STORED PROCEDURES SQL SERVER --

En este art�culo se muestran procedimientos almacenados en los que se han utilizado la cl�usula Union 
del Select para mostrar un reporte que incluye totales de un campo mostrado.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear un procedimiento almacenado que dado un a�o permita genera un informe de los
pedidos realizados por un empleado ese a�o, totalizando el monto de sus operaciones ese a�o.*/
CREATE OR ALTER PROCEDURE sp_pedidos_por_anio_empleado(@empleado_codigo INT, @anio INT)
WITH ENCRYPTION
AS
	BEGIN
		SELECT STR(o.OrderID) AS 'N� orden',
			   STR(YEAR(o.OrderDate)) AS 'A�o',
			   FORMAT(SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount)), '###,##0.00') AS 'Monto orden'
		FROM Orders AS o
			INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		WHERE YEAR(o.OrderDate) = @anio AND o.ShippedDate IS NOT NULL AND e.EmployeeID = @empleado_codigo
		GROUP BY o.OrderID, YEAR(o.OrderDate)

		UNION

		SELECT 'Total anual', '',
			   FORMAT(SUM((od.Quantity * od.UnitPrice)*(1 - od.Discount)), '###,##0.00') AS 'Monto orden'
		FROM Orders AS o
			INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		WHERE YEAR(o.OrderDate) = @anio AND o.ShippedDate IS NOT NULL AND e.EmployeeID = @empleado_codigo
		GROUP BY YEAR(o.OrderDate) 
		ORDER BY a�o DESC
	END
GO
--Mostrar el empleado con c�digo 1 en el a�o 1996
EXECUTE sp_pedidos_por_anio_empleado 1, 1996
GO

/*EJERCICIO 02. Teniendo un empleado, crear un procedimiento donde se genere un informe de todos los
pedidos realizados con el total de cada uno, totalizando el monto al final de las ventas de cada a�o.*/
CREATE OR ALTER PROCEDURE sp_pedidos_por_anio_empleado_total(@empleado_codigo INT)
WITH ENCRYPTION
AS
	BEGIN
		SELECT STR(o.OrderID) AS 'n� orden', YEAR(o.OrderDate) AS 'a�o',
			   FORMAT(SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)), '###,##0.00') AS 'monto orden'
		FROM Orders AS o
			INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		WHERE o.ShippedDate IS NOT NULL AND e.EmployeeID = @empleado_codigo
		GROUP BY o.OrderID, YEAR(o.OrderDate)

		UNION

		SELECT 'total anual', YEAR(o.OrderDate),
			   FORMAT(SUM((od.Quantity * od.UnitPrice) * (1 - od.Discount)), '###,##0.00') AS 'monto orden'
		FROM Orders AS o
			INNER JOIN Employees AS e ON(o.EmployeeID = e.EmployeeID)
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
		WHERE o.ShippedDate IS NOT NULL AND e.EmployeeID = @empleado_codigo
		GROUP BY YEAR(o.OrderDate)
		ORDER BY a�o
	END
GO

--Mostrar los resultados para el empleado con c�digo 2
EXEC sp_pedidos_por_anio_empleado_total 2
GO

/*EJERCICIO 03. Mostrar el detalle y total de una orden espec�fica*/
CREATE OR ALTER PROCEDURE sp_detalle_orden_con_total(@numero_orden INT)
WITH ENCRYPTION
AS
	BEGIN
		SELECT  STR(o.OrderID) AS 'n� orden', 
				STR(od.ProductID) AS 'cod. producto', 
				p.ProductName AS 'descripci�n',
				STR(od.Quantity) AS 'cantidad', 
				STR(od.UnitPrice) AS 'precio', 
				od.Quantity * od.UnitPrice AS 'importe'
		FROM Orders AS o 
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
		WHERE o.OrderID = @numero_orden

		UNION

		SELECT 'TOTAL ORDEN', '', '','', '', FORMAT(SUM(od.Quantity * od.UnitPrice), '###,##0.00') AS 'importe'
		FROM Orders AS o 
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
		WHERE o.OrderID = @numero_orden
		GROUP BY o.OrderID
	END
GO

--Para mostrar el detalle de la orden 10248
EXECUTE sp_detalle_orden_con_total 10248
GO