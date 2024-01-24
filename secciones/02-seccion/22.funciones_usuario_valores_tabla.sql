/*-- FUNCIONES DEFINIDAS POR EL USUARIO CON VALORES DE TABLA --

- Las funciones definidas por el usuario con valores de tabla son las funciones que devuelven un 
  tipo de datos table.
- Estas funciones son una alternativa eficaz  a las vistas. 
- Las funciones definidas por el usuario con valores de tabla pueden ser utilizadas cuando se 
  permitan expresiones de vista o de tabla en las consultas Transact-SQL.
- Las funciones definidas por el usuario con valores de tabla pueden contener instrucciones 
  adicionales mejorando la lógica de las vistas.
- Las vistas sólo permiten a una única instrucción SELECT, las funciones definidas por el 
  usuario puede tener joins y agrupamientos.
- Una función definida por el usuario con valores de tabla puede reemplazar también a 
  procedimientos almacenados que devuelven un solo conjunto de resultados.
- Al usar una función definida por el usuario con valores de tabla, este se escribe en la 
  cláusula FROM de una instrucción Transact-SQL, a la función se le deben dar los valores 
  para cada parámetro especificado en la creación.

COMPONENTES DE UNA FUNCIÓN DEFINIDA POR EL USUARIO CON VALORES DE TABLA
1. La cláusula RETURNS: 
	Especifica el nombre de una variable de retorno local para la tabla devuelta por la función.
	En la cláusula RETURNS se define la estructura de la tabla.
2. La instrucción TRANSACT-SQL:
	Del cuerpo de la función generan e insertan filas en la variable de retorno definida por 
	la cláusula RETURNS
3. La instrucción RETURN: 
	que devuelve las filas insertadas en la variable desde la función en formato tabular.
	La instrucción RETURN no tiene argumentos.
*/
USE Northwind
GO

/*EJERCICIO 01. Crear una función definida por el usuario con valores de tabla que muestre
los proveedores de un determinado país. Para visualizar el resultado se incluirá el nombre
del país*/

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

/*Usando la función definida por el usuario con valores de tabla.
Para los proveedores de Estados Unidos (USA)*/
SELECT * 
FROM dbo.fdu_proveedor_pais('USA')
GO

/*EJERCICIO 02. Crear una función definida por el usuario con valores de tabla que permite
mostrar los productos de una determinada categoría. Muestre el valor del stock para cada 
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

--Utilizando la función para los productos de la categoría 2
SELECT * 
FROM dbo.fdu_productos_categoria(2)
GO

/*EJERCICIO 03. Crear una función definida por el usuario con valores de una tabla que permita
mostrar los clientes que hicieron compras en un rango de fechas cualquiera. Las fechas serán
los parámetros de la función. Se incluirá la cantidad de órdenes y la carga total de todas
las órdenes (Freight)*/
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

--Mostrar los clientes y la cantidad de órdenes y el monto de la carga
--para el rango de fechas entre 1997-07-01 y 1997-07-15
SELECT * 
FROM dbo.fdu_clientes_rango_fecha('1997-07-01','1997-07-15')
GO


/*EJERCICIO 04. Función normal. Retorna el total productos por una categoría*/
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

--Muestra la cantidad de productos que tiene la categoría 1
SELECT dbo.fdu_total_productos(1) AS 'total'
GO