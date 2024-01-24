/*-- CURSORES EN STORE PROCEDURE SQL SERVER --

Los cursores en SQL Server permiten almacenar en memoria un conjunto de registros resultado de una 
instrucción Select, el objetivo principal del uso de los cursores es recorrer los registros del 
conjunto de resultados y realizar algún proceso con cada uno.

En este artículo se muestran ejercicios usando cursores que pueden dar al lector una idea para 
llenar o crear algún reporte necesario, además de como usarlos cuando la instrucción select del 
cursor es dinámica. Para esto se han incluído cursores en procedimientos almacenados.
*/
USE Northwind
GO

/*EJERCICIO 01. En este ejercicio se muestran sólo dos productos por categoría, seleccionando los
que tienen mayor Stock*/
DECLARE c_categorias CURSOR
FOR SELECT c.CategoryID, c.CategoryName
	FROM Categories AS c

OPEN c_categorias

DECLARE @cod_categoria INT, @categoria VARCHAR(15)

FETCH c_categorias INTO @cod_categoria, @categoria

DECLARE @productos TABLE(codigo INT, descripcion VARCHAR(40), precio NUMERIC(9,2), categoria VARCHAR(15))

WHILE @@FETCH_STATUS = 0
	BEGIN
		DECLARE c_productos CURSOR
		FOR SELECT TOP 2 p.ProductID, p.ProductName, p.UnitPrice
			FROM Products AS p
			WHERE p.CategoryID = @cod_categoria 
			ORDER BY p.UnitsInStock DESC

		OPEN c_productos

		DECLARE @cod_producto INT, @producto VARCHAR(40), @precio DECIMAL
		FETCH c_productos INTO @cod_producto, @producto, @precio

		WHILE  @@FETCH_STATUS = 0
			BEGIN
				INSERT INTO @productos(codigo, descripcion, precio, categoria)
				VALUES(@cod_producto, @producto, @precio, @categoria)

				FETCH c_productos INTO @cod_producto, @producto, @precio
			END
			
			CLOSE c_productos
			DEALLOCATE c_productos

		FETCH c_categorias INTO @cod_categoria, @categoria
	END

CLOSE c_categorias
DEALLOCATE c_categorias

SELECT categoria, codigo, descripcion, precio
FROM @productos
GO

/*EJERCICIO 02. Mostrar N productos por categoría. El valor será un parámetro en 
un SP, este ejercicio va amostrar los productos con mayor precio. Note que la 
instrucción select del cursor se deben construir y luego usar el procedimiento 
almacenado SP_EXECUTESQL para llenar el cursor.*/
CREATE OR ALTER PROCEDURE sp_n_productos_mas_caros_por_categoria(@cantidad INT)
AS
	BEGIN
		DECLARE c_categorias CURSOR
		FOR SELECT c.CategoryID, c.CategoryName
			FROM Categories AS c
		
		OPEN c_categorias
		
		DECLARE @cod_categoria INT, @categoria VARCHAR(15)
		DECLARE @dos_productos_por_categoria TABLE(codigo INT, descripcion VARCHAR(40), precio NUMERIC(9,2), categoria VARCHAR(15))
		
		FETCH c_categorias INTO @cod_categoria, @categoria

		WHILE @@FETCH_STATUS = 0
			BEGIN
				DECLARE @instruccion_select NVARCHAR(500)
				SET @instruccion_select = 
				'DECLARE c_productos_por_categoria CURSOR ' +
				'FOR SELECT TOP ' + TRIM(STR(@cantidad)) + ' p.productId, p.productName, p.unitPrice' +
			    '	 FROM Products AS p ' +
				'    WHERE p.CategoryID = ' + TRIM(STR(@cod_categoria)) + 
				'    ORDER BY p.UnitPrice DESC'

				EXECUTE SP_EXECUTESQL @instruccion_select

				OPEN c_productos_por_categoria
				DECLARE @cod_producto INT, @producto VARCHAR(40), @precio DECIMAL

				FETCH c_productos_por_categoria INTO @cod_producto, @producto, @precio
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO @dos_productos_por_categoria
						VALUES(@cod_producto, @producto, @precio, @categoria)
						
						FETCH c_productos_por_categoria INTO @cod_producto, @producto, @precio
					END

				CLOSE c_productos_por_categoria
				DEALLOCATE c_productos_por_categoria

				FETCH c_categorias INTO @cod_categoria, @categoria
			END

			CLOSE c_categorias
			DEALLOCATE c_categorias

			SELECT * 
			FROM @dos_productos_por_categoria
	END
GO

--Ejecutando el SP con 4 productos por cada categoría
EXEC sp_n_productos_mas_caros_por_categoria 5
GO

/*EJERCICIO 03. Crear un cursor que muestre las n órdenes con mayor valor de los clientes. 
Para el calculo del total de la orden crear una Función definida por el usuario.*/

--Creando una FDU para calcular el total de una orden
CREATE OR ALTER FUNCTION fdu_calcula_total_orden(@num_orden INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		DECLARE @total NUMERIC(9,2)

		SELECT @total = ROUND(SUM((od.UnitPrice * od.Quantity)*(1 - od.Discount)), 2)
		FROM [Order Details] AS od
		WHERE od.OrderID = @num_orden

		RETURN @total
	END
GO

/*
Para mostrar el reporte requerido para un cliente. Órdenes para un cliente y sus totales, 
por ejemplo el cliente con código ALFKI.
*/
SELECT c.CustomerID, c.CompanyName, o.OrderID, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha,
	   dbo.fdu_calcula_total_orden(o.OrderID) AS total
FROM Orders AS o 
	INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
WHERE c.CustomerID = 'ALFKI'
ORDER BY total DESC
GO

--Ahora el procedimiento almacenado que permite mostrar las N órdenes con mayor valor de los clientes
CREATE OR ALTER PROCEDURE sp_ordenes_mas_valor_por_cliente(@cantidad SMALLINT)
AS
	BEGIN
		DECLARE c_clientes CURSOR
		FOR SELECT c.CustomerID, c.CompanyName
			FROM Customers AS c

		OPEN c_clientes
		DECLARE @cod_cliente CHAR(5), @cliente VARCHAR(40)
		FETCH c_clientes INTO @cod_cliente, @cliente

		DECLARE @ordenes_por_cliente TABLE(Codigo CHAR(5), cliente VARCHAR(40), orden INT, 
		fecha DATE, total NUMERIC(9,2))

		WHILE  @@FETCH_STATUS = 0
			BEGIN
				DECLARE @instruccion_select NVARCHAR(500)
				SET @instruccion_select = 
					('DECLARE c_top_ordenes_por_cliente_mas_valor CURSOR 
					  FOR SELECT TOP ' + TRIM(STR(@cantidad)) + ' o.OrderID, o.OrderDate, dbo.fdu_calcula_total_orden(o.OrderID) AS total ' +
					  'FROM Orders AS o ' +
					  'WHERE o.CustomerID = ' + CHAR(39) + TRIM(@cod_cliente) + CHAR(39) + ' ' +
					  'ORDER BY total DESC')

				EXECUTE SP_EXECUTESQL @instruccion_select

				OPEN c_top_ordenes_por_cliente_mas_valor

				DECLARE @orden_numero INT, @fecha DATE, @importe NUMERIC(9,2)

				FETCH c_top_ordenes_por_cliente_mas_valor INTO @orden_numero, @fecha, @importe
				WHILE @@FETCH_STATUS = 0
					BEGIN
						INSERT INTO @ordenes_por_cliente
						VALUES(@cod_cliente, @cliente, @orden_numero, @fecha, @importe)

						FETCH c_top_ordenes_por_cliente_mas_valor INTO @orden_numero, @fecha, @importe
					END
					
					CLOSE c_top_ordenes_por_cliente_mas_valor
					DEALLOCATE c_top_ordenes_por_cliente_mas_valor
			
				FETCH c_clientes INTO @cod_cliente, @cliente
			END

		CLOSE c_clientes
		DEALLOCATE c_clientes

		SELECT * 
		FROM @ordenes_por_cliente
	END
GO


--Ejecutar el procedimiento para mostrar cuatro órdenes con mayor valor
EXECUTE sp_ordenes_mas_valor_por_cliente 2
GO

/*PROCEDIMIENTO ALMACENADO SP_EXECUTESQL

Permite ejecutar una instrucción SQL la que puede reusarse o que haya sido creada dinámicamente. 
Esta instrucción SQL puede contener parámetros.
*/

/*EJERCICIO 04. En este ejercicio se crea un instrucción sencilla para listar los registros
de la tabla products*/
USE Northwind
GO

DECLARE @instruccion NVARCHAR(200)
SET @instruccion = 'SELECT * FROM Products'
EXECUTE SP_EXECUTESQL @instruccion
GO