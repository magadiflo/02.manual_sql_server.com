/*-- FUNCIONES DEFINIDAS POR EL USUARIO FDU --

Las funciones definidas por el usuario permiten obtener resultados que las funciones propias de SQL Server 
no pueden mostrarnos, son de mucha utilidad para optimizar el trabajo de consultas con par�metros. 
Para mejor informaci�n ver Funciones definidas por el usuario.

Se pueden usar en ocasiones para obtener el mismo resultado Joins y Subconsultas.

Las Funciones Definidas por el usuario son de DOS TIPOS:

1. Las que retornan UN VALOR � InLine, se utilizan en otras instrucciones
2. Las que retornan UNA TABLA

Para crear las que devuelven un valor:
	Create function Esquema.NombreFuncion([Par�metros]) 
	Returns TipoDato
	As
	Begin
		Instrucciones�.
		Return ValorRetornado
	End
	go

Para crear las FDU que retornan UNA TABLA: 
	Create function Esquema.NombreFuncion([Par�metros]) 
	Returns Table
	As
		Return (Select�.)
	go
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una funci�n para retornar el total de categor�as*/
CREATE FUNCTION fdu_total_categorias()
RETURNS INT
AS
	BEGIN
		DECLARE @total INT
		SET @total = (SELECT COUNT(*) FROM Categories)
		RETURN @total
	END
GO

SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_categorias())) + ' categor�as'
GO

/*EJERCICIO 02. Crear una funci�n que reporte el total de art�culos en Stock de cualquier categor�a*/
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


SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_articulos_stock_por_categoria(5))) + ' art�culos'
GO

--Implementar la funci�n anterior pero asignando el nombre de la categor�a
--Cu�ntos art�culos hay de Confections
DECLARE @categoria_id INT
SET @categoria_id = (SELECT CategoryID FROM Categories WHERE CategoryName = 'Confections')
SELECT 'Existen' + SPACE(1) + LTRIM(STR(dbo.fdu_total_articulos_stock_por_categoria(@categoria_id))) + ' art�culos'
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
				PRINT 'No existe la categor�a ' + @nombre_categoria
			END
	END
GO

EXECUTE sp_ver_cantidad_articulos_x_categoria 'Huesos'
GO
EXECUTE sp_ver_cantidad_articulos_x_categoria 'Beverages'
GO

/*Ejercicio 03. Funci�n que permita mostrar los clientes y el monto comprado de una determinada ciudad.*/
CREATE FUNCTION fdu_cantidad_cliente_pais(@pais VARCHAR(15))
RETURNS TABLE
AS
	RETURN(
		SELECT c.CustomerID AS 'c�digo cliente', c.CompanyName AS 'empresa',
			   c.Country AS 'pa�s',  SUM(o.Freight) AS 'monto'
		FROM Customers AS c
			INNER JOIN Orders AS o ON(c.CustomerID = o.CustomerID)
		WHERE c.Country = @pais
		GROUP BY c.CustomerID, c.CompanyName, c.Country
	)
GO

--Ver los clientes de Per�
SELECT * 
FROM fdu_cantidad_cliente_pais('Per�')
GO

--Ver los clientes de France
SELECT * 
FROM fdu_cantidad_cliente_pais('France')
GO

/*EJERCICIO 04. Crea un procedimiento almacenado que llame a la funci�n anterior
fdu_cantidad_cliente_pais(country) y verifique si existe el pa�s buscado, caso contrario
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
				SELECT 'No existe el pa�s especificado'
			END
	END
GO

--Prueba
EXECUTE sp_cantidad_cliente_pais 'Per�'
GO

EXECUTE sp_cantidad_cliente_pais 'France'
GO