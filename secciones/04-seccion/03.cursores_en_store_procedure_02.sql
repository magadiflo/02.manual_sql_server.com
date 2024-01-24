/*-- CURSORES EN SOTRE PROCEDURE SQL SERVER --

En este ejercicio se va a crear un cursor el cual analizará el volumen de compras de un cliente, los clientes 
y su volumen de compras se van a guardar en tablas diferentes, separando a los clientes que han comprado por 
encima de la media de todos los pedidos y los que han comprado menos en otra tabla.

Para facilidad del trabajo y que todos puedan verificar los resultados se va a utilizar la información de la 
base de datos Northwind, se creará una nueva base de datos y copiará la información de Northwind.
*/
CREATE DATABASE bd_ventas
GO

USE bd_ventas
GO

CREATE TABLE clientes(
	codigo CHAR(5), 
	nombre VARCHAR(100),
	ciudad VARCHAR(100),
	CONSTRAINT pk_clientes PRIMARY KEY(codigo)
)
GO

--Insertar los clientes de la tabla Cursomters de Nortwind
INSERT INTO clientes
SELECT c.CustomerID, c.CompanyName, c.City
FROM Northwind.dbo.Customers AS c
GO

SELECT * 
FROM clientes
GO

CREATE TABLE pedidos(
	codigo CHAR(5),
	fecha DATE,
	cliente_codigo CHAR(5),
	CONSTRAINT pk_pedidos PRIMARY KEY(codigo),
	CONSTRAINT fk_clientes_pedidos FOREIGN KEY(cliente_codigo) REFERENCES clientes(codigo)
)
GO

--Insertar pedidos de la tabla orders de Nortwind
INSERT INTO pedidos
SELECT o.OrderID, o.OrderDate, o.CustomerID
FROM Northwind.dbo.Orders AS o
GO

SELECT * 
FROM pedidos
GO

CREATE TABLE productos(
	codigo INT, 
	descripcion VARCHAR(100),
	unidad VARCHAR(100),
	precio NUMERIC(9,2),
	stock NUMERIC(9,2),
	CONSTRAINT pk_productos PRIMARY KEY(codigo)
)
GO

--Insertar productos de la tabla Products de Nortwind
INSERT INTO productos
SELECT p.ProductID, p.ProductName, p.QuantityPerUnit, p.UnitPrice, p.UnitsInStock
FROM Northwind.dbo.Products AS p
GO

SELECT * 
FROM productos
GO

CREATE TABLE detalle_pedidos(
	pedido_codigo CHAR(5),
	producto_codigo INT,
	cantidad NUMERIC(9,2),
	precio NUMERIC(9,2),
	descuento NUMERIC(5,3),
	CONSTRAINT pk_detalle_pedidos PRIMARY KEY(pedido_codigo, producto_codigo),
	CONSTRAINT fk_pedidos_detalle_pedidos FOREIGN KEY(pedido_codigo) REFERENCES pedidos(codigo),
	CONSTRAINT fk_producto_detalle_pedidos FOREIGN KEY(producto_codigo) REFERENCES productos(codigo)
)
GO

--Insertar en la tabla detalle_pedidos de la tabla order details de nortwind
INSERT INTO detalle_pedidos
SELECT od.OrderID, od.ProductID, od.Quantity, od.UnitPrice, od.Discount 
FROM Northwind.dbo.[Order Details] AS od
GO

SELECT * 
FROM detalle_pedidos
GO

--Las tablas para el llenado del resultado son VIP y Normal.
CREATE TABLE vips(
	cliente_id CHAR(5),
	cliente VARCHAR(100),
	ciudad VARCHAR(100),
	total_gastado NUMERIC(9,2)
)
GO

CREATE TABLE normales(
	cliente_id CHAR(5),
	cliente VARCHAR(100),
	ciudad VARCHAR(100),
	total_gastado NUMERIC(9,2)
)
GO

--La instrucción SELECT del CURSOR es la siguiente
SELECT c.codigo, c.nombre, c.ciudad, SUM(dp.precio * dp.cantidad * (1 - dp.descuento)) AS total
FROM clientes AS c, detalle_pedidos AS dp, pedidos AS p
WHERE dp.pedido_codigo = p.codigo AND c.codigo = p.cliente_codigo
GROUP BY c.codigo, c.nombre, c.ciudad
GO

--Calculo de la media de las compras, total de ventas/total pedido
--TOTAL VENTA
SELECT SUM(dp.precio * dp.cantidad * (1 - dp.descuento)) AS suma
FROM detalle_pedidos AS dp, pedidos AS p
WHERE dp.pedido_codigo = p.codigo
GO

--TOTAL PEDIDOS
SELECT COUNT(p.codigo)
FROM pedidos AS p
GO

--MEDIDA DE LOS PEDIDOS
DECLARE @media NUMERIC(9,2)
SET @media = (SELECT SUM(dp.precio * dp.cantidad * (1 - dp.descuento)) AS suma
			  FROM detalle_pedidos AS dp, pedidos AS p
			  WHERE dp.pedido_codigo = p.codigo)/(SELECT COUNT(p.codigo)
												  FROM pedidos AS p)
SELECT @media
GO

--El procedimiento almacenado para llenar la tabla es como sigue
CREATE OR ALTER PROCEDURE sp_clientes_vip_normal
AS
	BEGIN
		SET NOCOUNT ON
		DECLARE c_ruta CURSOR 
		FOR SELECT c.codigo, c.nombre, c.ciudad, SUM(dp.precio * dp.cantidad * (1 - dp.descuento)) AS total
			FROM clientes AS c, detalle_pedidos AS dp, pedidos AS p
			WHERE dp.pedido_codigo = p.codigo AND c.codigo = p.cliente_codigo
			GROUP BY c.codigo, c.nombre, c.ciudad

		--Variables
		DECLARE @id CHAR(5)
		DECLARE @nombre VARCHAR(100)
		DECLARE @ciudad VARCHAR(100)
		DECLARE @total_gastado NUMERIC(9,2)

		--Abrir el cursor
		OPEN c_ruta
		--Calcular la media
		DECLARE @media NUMERIC(9,2)
		SET @media = (SELECT SUM(dp.precio * dp.cantidad * (1 - dp.descuento)) AS suma
					  FROM detalle_pedidos AS dp, pedidos AS p
					  WHERE dp.pedido_codigo = p.codigo)/(SELECT COUNT(p.codigo)
														  FROM pedidos AS p)
		--Leer los datos del primer registro del cursor
		FETCH c_ruta INTO @id, @nombre, @ciudad, @total_gastado

		--Eliminar el contenido de las tablas
		DELETE vips
		DELETE normales

		--Variables para los espacios del reporte
		DECLARE @nombre_mas_largo INT
		SET @nombre_mas_largo = (SELECT MAX(LEN(nombre)) FROM clientes) + 2
		DECLARE @ciudad_mas_larga INT
		SET @ciudad_mas_larga = (SELECT MAX(LEN(ciudad)) FROM clientes) + 2
		PRINT '============================ LISTADO ============================'
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @total_gastado >= @media
					BEGIN
						INSERT INTO vips
						VALUES(@id, @nombre, @ciudad, @total_gastado)
						PRINT @id + ' ' + @nombre + SPACE(@nombre_mas_largo - LEN(@nombre)) + 
								@ciudad + SPACE(@ciudad_mas_larga - LEN(@ciudad)) + 
								CAST(@total_gastado AS VARCHAR(10)) + SPACE(12) + 'VIP'
					END
				ELSE
					BEGIN
						INSERT INTO normales
						VALUES(@id, @nombre, @ciudad, @total_gastado)
						PRINT @id + ' ' + @nombre + SPACE(@nombre_mas_largo - LEN(@nombre)) + 
								@ciudad + SPACE(@ciudad_mas_larga - LEN(@ciudad)) + 
								CAST(@total_gastado AS VARCHAR(10)) + SPACE(10) + 'NORMAL'
					END
				--Leer el siguiente registro
				FETCH c_ruta INTO @id, @nombre, @ciudad, @total_gastado
			END
		CLOSE c_ruta
		DEALLOCATE c_ruta
	END
GO

--Ejecutar el procedimiento almacenado
EXECUTE sp_clientes_vip_normal
GO

/*
Es necesario resaltar que el reporte del procedimiento almacenado usando la sentencia 
Print no se debe incluir en un sistema en producción, además de las consideraciones y cuidados 
que se deben tener en incluir cursores en los sistemas.
*/

--La información de las tablas vips y normales
SELECT * 
FROM vips
GO

SELECT * 
FROM normales
GO