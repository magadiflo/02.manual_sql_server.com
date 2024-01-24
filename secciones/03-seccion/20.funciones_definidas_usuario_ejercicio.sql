/*-- FUNCIONES DEFINIDAS POR EL USUARIO FDU --

Las funciones definidas por el usuario permiten obtener resultados que las funciones propias de SQL Server 
no pueden mostrarnos, son de mucha utilidad para optimizar el trabajo de consultas con parámetros. 
Para mejor información ver Funciones definidas por el usuario.

Se pueden usar en ocasiones para obtener el mismo resultado Joins y Subconsultas.

Las Funciones Definidas por el usuario son de DOS TIPOS:

1. Las que retornan UN VALOR – InLine, se utilizan en otras instrucciones
2. Las que retornan UNA TABLA

Para crear las que devuelven un valor:
	Create function Esquema.NombreFuncion([Parámetros]) 
	Returns TipoDato
	As
	Begin
		Instrucciones….
		Return ValorRetornado
	End
	go

Para crear las FDU que retornan UNA TABLA: 
	Create function Esquema.NombreFuncion([Parámetros]) 
	Returns Table
	As
		Return (Select….)
	go
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una función para retornar el total de categorías*/
CREATE FUNCTION fdu_total_categorias()
RETURNS INT
AS
	BEGIN
		DECLARE @total INT
		SET @total = (SELECT COUNT(*) FROM Categories)
		RETURN @total
	END
GO

SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_categorias())) + ' categorías'
GO

/*EJERCICIO 02. Crear una función que reporte el total de artículos en Stock de cualquier categoría*/
CREATE FUNCTION fdu_total_articulos_stock_por_categoria(@categoria_id INT)
RETURNS INT
AS 
	BEGIN
		DECLARE @total_articulos INT
		SELECT @total_articulos = SUM(p.UnitsInStock)
		FROM Products AS p
		WHERE p.CategoryID = @categoria_id
		RETURN @total_articulos
	END
GO


SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_articulos_stock_por_categoria(5))) + ' artículos'
GO

--Implementar la función anterior pero asignando el nombre de la categoría
--Cuántos artículos hay de Confections
DECLARE @categoria_id INT
SET @categoria_id = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Confections')
SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_articulos_stock_por_categoria(@categoria_id))) + ' artículos'
GO

--Incluir la FDU anterior en un sp
CREATE PROCEDURE sp_ver_cantidad_articulos_x_categoria(@nombre_categoria VARCHAR(15))
AS
	BEGIN
		IF EXISTS(SELECT * FROM Categories WHERE CategoryName = @nombre_categoria)
			BEGIN
				DECLARE @categoria_id INT
				SET @categoria_id = (SELECT CategoryID FROM Categories WHERE CategoryName = @nombre_categoria)
				SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_articulos_stock_por_categoria(@categoria_id))) + ' productos'
			END
		ELSE 
			BEGIN
				PRINT 'No existe la categoría ' + @nombre_categoria
			END
	END
GO

EXECUTE sp_ver_cantidad_articulos_x_categoria 'Huesos'
GO
EXECUTE sp_ver_cantidad_articulos_x_categoria 'Beverages'
GO

/*Ejercicio 03. Función que permita mostrar los clientes y el monto comprado de una determinada ciudad.*/
CREATE FUNCTION fdu_cantidad_cliente_pais(@pais VARCHAR(15))
RETURNS TABLE
AS
	RETURN(
		SELECT c.CustomerID AS 'código cliente', c.CompanyName AS 'empresa',
			   c.Country AS 'país',  SUM(o.Freight) AS 'monto'
		FROM Customers AS c
			INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
		WHERE c.Country = @pais
		GROUP BY c.CustomerID, c.CompanyName, c.Country
	)
GO

--Ver los clientes de Perú
SELECT * 
FROM fdu_cantidad_cliente_pais('Perú')
GO

--Ver los clientes de France
SELECT * 
FROM fdu_cantidad_cliente_pais('France')
GO

/*EJERCICIO 04. Crea un procedimiento almacenado que llame a la función anterior
fdu_cantidad_cliente_pais(country) y verifique si existe el país buscado, caso contrario
retorne un mensaje*/
CREATE PROCEDURE sp_cantidad_cliente_pais(@pais VARCHAR(15))
AS
	BEGIN
		IF EXISTS(SELECT Country FROM Customers WHERE Country = @pais)
			BEGIN
				SELECT * 
				FROM fdu_cantidad_cliente_pais(@pais)
			END
		ELSE
			BEGIN
				SELECT 'No existe el país especificado'
			END
	END
GO

--Prueba
EXECUTE sp_cantidad_cliente_pais 'Perú'
GO

EXECUTE sp_cantidad_cliente_pais 'France'
GO