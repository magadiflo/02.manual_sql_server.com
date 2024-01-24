/*-- CURSORES Y PIVOT EN SQL SERVER --

En este artículo se utiliza un cursor para mostrar las ventas de los productos en un año determinado, 
siempre se recomienda usar con cuidado los cursores, estos consumen recursos importantes en el servidor, 
siempre que use un cursor evalúe usar si es posible otras opciones, además de que la instrucción 
Select del cursor tenga solamente los campos necesarios y los filtros adecuados.

En este artículo usamos una CTE (Common Table Expression) y usamos Pivot para mostrar las compras por
mes y totalizarlas en una última columna durante el año 1997, puede usar procedimientos almacenados 
para poder dinamizar el resultado del cursor para cualquier año.
*/

/*EJERCICIO 01. El ejercicio muestra los productos y la cantidad de unidades vendidas en 1997, mostrando
el detalle de cada mes.*/
USE Northwind
GO

DECLARE c_ventas_anuales CURSOR
FOR WITH total_ventas
	AS (SELECT p.ProductName AS producto, MONTH(o.OrderDate) AS mes, SUM(od.Quantity) AS unidades
		FROM Orders AS o
			INNER JOIN [Order Details] AS od ON(o.OrderID = od.OrderID)
			INNER JOIN Products AS p ON(od.ProductID = p.ProductID)
		WHERE o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
		GROUP BY p.ProductName, MONTH(o.OrderDate))
	SELECT	producto,
			ISNULL([1], 0) AS 'Ene', ISNULL([2], 0) AS 'Feb', ISNULL([3], 0) AS 'Mar',  
			ISNULL([4], 0) AS 'Abr', ISNULL([5], 0) AS 'May', ISNULL([6], 0) AS 'Jun', 
			ISNULL([7], 0) AS 'Jul', ISNULL([8], 0) AS 'Ago', ISNULL([9], 0) AS 'Sep',
			ISNULL([10], 0) AS 'Oct', ISNULL([11], 0) AS 'Nov', ISNULL([12], 0) AS 'Dic'
	FROM total_ventas
	PIVOT(SUM(unidades) FOR mes IN([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12])) AS tabla_pivot

OPEN c_ventas_anuales

DECLARE @ventas_anuales_producto TABLE(nombre VARCHAR(50), enero NUMERIC(9,2), febrero NUMERIC(9,2),
marzo NUMERIC(9,2), abril NUMERIC(9,2), mayo NUMERIC(9,2), junio NUMERIC(9,2), julio NUMERIC(9,2),
agosto NUMERIC(9,2), setiembre NUMERIC(9,2), octubre NUMERIC(9,2), noviembre NUMERIC(9,2),
diciembre NUMERIC(9,2), total NUMERIC(9,2))

DECLARE @nombre VARCHAR(50), @enero NUMERIC(9,2), @febrero NUMERIC(9,2),
@marzo NUMERIC(9,2), @abril NUMERIC(9,2), @mayo NUMERIC(9,2), @junio NUMERIC(9,2), @julio NUMERIC(9,2),
@agosto NUMERIC(9,2), @setiembre NUMERIC(9,2), @octubre NUMERIC(9,2), @noviembre NUMERIC(9,2),
@diciembre NUMERIC(9,2), @total NUMERIC(9,2)

FETCH c_ventas_anuales INTO @nombre, @enero, @febrero, @marzo, @abril, @mayo, @junio, @julio,
@agosto, @setiembre, @octubre, @noviembre, @diciembre

WHILE  @@FETCH_STATUS = 0
	BEGIN
		SET @total = @enero + @febrero + @marzo + @abril + @mayo + @junio + @julio +
				@agosto + @setiembre + @octubre + @noviembre + @diciembre
		INSERT INTO @ventas_anuales_producto
		VALUES(@nombre, @enero, @febrero, @marzo, @abril, @mayo, @junio, @julio,
				@agosto, @setiembre, @octubre, @noviembre, @diciembre, @total)
		
		FETCH c_ventas_anuales INTO @nombre, @enero, @febrero, @marzo, @abril, @mayo, @junio, @julio,
		@agosto, @setiembre, @octubre, @noviembre, @diciembre
	END

CLOSE c_ventas_anuales
DEALLOCATE c_ventas_anuales
SELECT * 
FROM @ventas_anuales_producto
GO
