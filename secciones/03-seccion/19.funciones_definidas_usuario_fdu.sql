/*-- FUNCIONES DEFINIDAS POR EL USUARIO FDU --

Las Funciones definidas por el usuario son rutinas que aceptan par�metros de manera opcional,
realizan acciones y devuelven el resultado como un valor o como una tabla.
El valor devuelto puede ser un valor escalar �nico o un conjunto de resultados.

Las Funciones Definidas por el usuario explicadas en este art�culo son:
1. Las que retornan UN VALOR � InLine,se utilizan en otras instrucciones
2. Las que retornan UNA TABLA

Para crear las que devuelven un valor.

Create function Esquema.NombreFuncion([Par�metros]) 
Returns TipoDato
As
Begin
	Instrucciones�.
	Return ValorRetornado
End
go

Para crear las FDU que retornan UNA TABLA
Create function Esquema.NombreFuncion([Par�metros]) 
Returns Table
As
Return (Select�.)
go
*/

USE Northwind
GO

/*EJERCICIO 01. FDU que retorne los productos que tengan m�s unidades en Orden que Stock actual*/
CREATE FUNCTION fdu_producto_compra_urgente()
RETURNS TABLE
AS
	RETURN(
		SELECT *
		FROM Products AS P
		WHERE p.UnitsInStock < p.UnitsOnOrder
	)
GO

--Para usar la funci�n creada
SELECT * 
FROM fdu_producto_compra_urgente();
GO

/*EJERCICIO 02. Lista de pedidos de un cliente, escribir el nombre del cliente*/
SELECT CustomerID
FROM Customers 
WHERE CompanyName = 'Universidad SQL'
GO

--Se comprueba que no existe el cliente
--Para el cliente "Antonio Moreno Taquer�a"
SELECT CustomerID 
FROM Customers 
WHERE CompanyName = 'Antonio Moreno Taquer�a'
GO

--Para las �rdenes del cliente se puede usar una subconsulta
SELECT * 
FROM Orders
WHERE CustomerID = (SELECT CustomerID 
					FROM Customers 
					WHERE CompanyName = 'Antonio Moreno Taquer�a')
GO

--En una FDU
CREATE FUNCTION fdu_ordenes_por_cliente(@cliente VARCHAR(40))
RETURNS TABLE
AS
	RETURN(
	SELECT * 
		FROM Orders
		WHERE CustomerID = (SELECT CustomerID 
							FROM Customers 
							WHERE CompanyName = @cliente)
	
	)
GO

--Usando la FDU anterior, las �rdenes para �Antonio Moreno Taquer�a�
SELECT * 
FROM fdu_ordenes_por_cliente('Antonio Moreno Taquer�a')
GO

/*EJERCICIO 03. Productos con precio mayor a valor ingresado*/
CREATE FUNCTION fdu_productos_precio_hacia_arriba(@precio NUMERIC(9,2))
RETURNS TABLE
AS
	RETURN(
		SELECT * 
		FROM Products AS p
		WHERE p.UnitPrice > @precio
	)
GO

SELECT *
FROM fdu_productos_precio_hacia_arriba(80)
GO

/*EJERCICIO 04. Pedidos de un cliente en un rango de fechas*/
CREATE FUNCTION fdu_ordenes_por_cliente_rango_fechas(
	@cliente_id CHAR(10), @fecha_inicio DATE, @fecha_fin DATE
)
RETURNS TABLE
AS
	RETURN (
		SELECT *
		FROM Orders AS o
		WHERE o.CustomerID = @cliente_id AND
			  o.OrderDate BETWEEN @fecha_inicio AND @fecha_fin
	)
GO

SELECT * 
FROM fdu_ordenes_por_cliente_rango_fechas('ANTON', '1997-06-01', '1997-12-31')
GO


/*EJERCICIO 05. Listado de las categor�as y el valor del stock de cada una*/
--Valor del stock para la categor�a 1
SELECT SUM(p.UnitsInStock * p.UnitPrice) AS 'valor del stock'
FROM Products AS p
WHERE p.CategoryID = 1
GO

--La FDU para calcular el valor del stock
CREATE FUNCTION fdu_valor_stock_por_categoria(@categoria_id INT)
RETURNS NUMERIC(9,2)
AS 
	BEGIN
		DECLARE @valor NUMERIC(9,2)
		SELECT @valor = SUM(p.UnitsInStock * p.UnitPrice)
					  FROM Products AS p
					  WHERE p.CategoryID = @categoria_id
		RETURN @valor
	END
GO

--Usar la FDU fdu_valor_stock_por_categoria
SELECT c.CategoryID AS 'c�digo', c.CategoryName AS 'categor�a', 
	   dbo.fdu_valor_stock_por_categoria(c.CategoryID) AS 'valor stock'
FROM Categories AS c
ORDER BY [valor stock] DESC
GO


/*EJERCICIO 06. Eliminar una FDU*/
DROP FUNCTION fdu_ordenes_por_cliente
GO

/*IMPORTANTE: Importante: Se recomienda tener cuidado en la eliminaci�n de una FDU y en general de 
cualquier objeto, este puede estar referenciado en alg�n otro script y si se elimina cuasar� 
problema en el sistema.*/