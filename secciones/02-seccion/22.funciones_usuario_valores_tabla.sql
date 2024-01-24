/*-- FUNCIONES DEFINIDAS POR EL USUARIO CON VALORES DE TABLA --

- Las funciones definidas por el usuario con valores de tabla son las funciones que devuelven un 
  tipo de datos table.
- Estas funciones son una alternativa eficaz  a las vistas. 
- Las funciones definidas por el usuario con valores de tabla pueden ser utilizadas cuando se 
  permitan expresiones de vista o de tabla en las consultas Transact-SQL.
- Las funciones definidas por el usuario con valores de tabla pueden contener instrucciones 
  adicionales mejorando la l�gica de las vistas.
- Las vistas s�lo permiten a una �nica instrucci�n SELECT, las funciones definidas por el 
  usuario puede tener joins y agrupamientos.
- Una funci�n definida por el usuario con valores de tabla puede reemplazar tambi�n a 
  procedimientos almacenados que devuelven un solo conjunto de resultados.
- Al usar una funci�n definida por el usuario con valores de tabla, este se escribe en la 
  cl�usula FROM de una instrucci�n Transact-SQL, a la funci�n se le deben dar los valores 
  para cada par�metro especificado en la creaci�n.

COMPONENTES DE UNA FUNCI�N DEFINIDA POR EL USUARIO CON VALORES DE TABLA
1. La cl�usula RETURNS: 
	Especifica el nombre de una variable de retorno local para la tabla devuelta por la funci�n.
	En la cl�usula RETURNS se define la estructura de la tabla.
2. La instrucci�n TRANSACT-SQL:
	Del cuerpo de la funci�n generan e insertan filas en la variable de retorno definida por 
	la cl�usula RETURNS
3. La instrucci�n RETURN: 
	que devuelve las filas insertadas en la variable desde la funci�n en formato tabular.
	La instrucci�n RETURN no tiene argumentos.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una funci�n definida por el usuario con valores de tabla que muestre
los proveedores de un determinado pa�s. Para visualizar el resultado se incluir� el nombre
del pa�s*/

CREATE FUNCTION fdu_proveedor_pais(@pais VARCHAR(15))
RETURNS @proveedores TABLE(codigo INT, nombre VARCHAR(40), contacto VARCHAR(30), pais VARCHAR(15))
AS
	BEGIN
		INSERT INTO @proveedores
		SELECT s.SupplierID, s.CompanyName, s.ContactName, s.Country 
		FROM Suppliers AS s
		WHERE s.Country = @pais

		RETURN
	END
GO

/*Usando la funci�n definida por el usuario con valores de tabla.
Para los proveedores de Estados Unidos (USA)*/
SELECT * 
FROM dbo.fdu_proveedor_pais('USA')
GO

/*EJERCICIO 02. Crear una funci�n definida por el usuario con valores de tabla que permite
mostrar los productos de una determinada categor�a. Muestre el valor del stock para cada 
producto.*/
CREATE FUNCTION fdu_productos_categoria(@categoria_id INT)
RETURNS @productos TABLE(codigo INT, descripcion VARCHAR(40), 
						 precio NUMERIC(9,2), stock NUMERIC(9,2), valorStock NUMERIC(9,2))
AS
	BEGIN
		INSERT INTO @productos
		SELECT p.ProductID, p.ProductName, p.UnitPrice, p.UnitsInStock, 
			   p.UnitPrice * p.UnitsInStock
		FROM Categories AS c
			INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
		WHERE c.CategoryID = @categoria_id
		
		RETURN
	END
GO

--Utilizando la funci�n para los productos de la categor�a 2
SELECT * 
FROM dbo.fdu_productos_categoria(2)
GO

/*EJERCICIO 03. Crear una funci�n definida por el usuario con valores de una tabla que permita
mostrar los clientes que hicieron compras en un rango de fechas cualquiera. Las fechas ser�n
los par�metros de la funci�n. Se incluir� la cantidad de �rdenes y la carga total de todas
las �rdenes (Freight)*/
CREATE FUNCTION fdu_clientes_rango_fecha(@inicio AS DATE, @fin AS DATE)
RETURNS @clientes TABLE(codigo VARCHAR(10), nombre VARCHAR(100), fecha VARCHAR(10),
						cantidad NUMERIC(9,2), monto_comprado NUMERIC(9,2))
AS
	BEGIN
		INSERT INTO @clientes
		SELECT c.CustomerID, c.CompanyName, FORMAT(o.OrderDate, 'dd/MM/yyyy') AS fecha,
			   COUNT(o.OrderID) AS 'cantidad', SUM(o.Freight) AS 'monto comprado'
		FROM Orders AS o
			INNER JOIN Customers AS c ON(o.CustomerID = c.CustomerID)
		WHERE o.OrderDate BETWEEN @inicio AND @fin
		GROUP BY c.CustomerID, c.CompanyName, o.OrderDate

		RETURN
	END
GO

--Mostrar los clientes y la cantidad de �rdenes y el monto de la carga
--para el rango de fechas entre 1997-07-01 y 1997-07-15
SELECT * 
FROM dbo.fdu_clientes_rango_fecha('1997-07-01','1997-07-15')
GO


/*EJERCICIO 04. Funci�n normal. Retorna el total productos por una categor�a*/
CREATE FUNCTION fdu_total_productos(@categoria_id INT)
RETURNS INT
AS
	BEGIN
		DECLARE @total INT

		SELECT @total = COUNT(p.ProductID)
		FROM Products AS p
		WHERE p.CategoryID = @categoria_id

		RETURN @total
	END
GO

--Muestra la cantidad de productos que tiene la categor�a 1
SELECT dbo.fdu_total_productos(1) AS 'total'
GO