/*-- INSERCIÓN DE FUNCIONES DEFINIDAS POR EL USUARIO ESCALARES --

La Inserción de UDF escalar (Función definida por el usuario escalar), es una característica nueva de SQL Server 2019 
incluída dentro del procesamiento de consultas inteligentes. La inserción de UDF escalar mejora el rendimiento de las 
consultas que llaman a UDF escalares en SQL Server.

Las UDF escalares en SQL Server son los tipos de funciones definidas por el usuario que devuelven un único valor. 
El objetivo de usar las UDF es de la reutilización y modularidad del código en todas las consultas en SQL Server.

Rendimiento de las UDF escalares en SQL Server
Las UDF escalares pueden tener un rendimiento deficiente por lo siguiente:

1. Invocación iterativa: la UDF escalar se invocan en cada registro, lo que supone costos adicionales en cada cambio 
   de contexto.
2. Falta de costos: durante la optimización, solo se calcula el costo de los operadores relacionales, mientras que el de
   los operadores escalares no.
3. Ejecución interpretada: las UDF se evalúan como un lote de instrucciones, y se ejecutan instrucción por instrucción.
4. La ejecución en serie, debido a que SQL Server no admite el paralelismo entre consultas en las consultas que invocan las UDF.

Inserción automática de UDF escalares
La característica de Inserción de UDF escalar permite mejorar el rendimiento de las consultas que consumen funciones definidas
por el usuario escalares de SQL Server, donde el uso de una UDF puede causar lentitud.

Esta nueva característica transforman automáticamente las UDF escalares en subconsultas escalares que se sustituyen en la consulta 
que realiza la llamada a la UDF. El plan de ejecución de la consulta permite ver como al UDF escalar se incluye en la consulta.
*/
USE Northwind
GO

/*EJERCICIO 01. Mostrar las categorías y la cantidad de productos en Sock de cada una de estas*/
--Consulta con Join y agrupamientos
SELECT c.CategoryID, c.CategoryName, COUNT(p.ProductID) AS cantidad
FROM Categories AS c
	INNER JOIN Products AS p ON(c.CategoryID = p.CategoryID)
GROUP BY c.CategoryID, c.CategoryName
GO

--La UDF para la cantidad de productos es como sigue
CREATE FUNCTION fdu_cantidad_productos_cateogira(@categoria_codigo INT)
RETURNS INT
AS
	BEGIN
		DECLARE @cantidad INT
		SET @cantidad = (SELECT COUNT(p.ProductID)
						FROM Products AS p
						WHERE p.CategoryID = @categoria_codigo)

		RETURN @cantidad
	END
GO

--Ejecutando la consulta
SELECT c.CategoryID, c.CategoryName, dbo.fdu_cantidad_productos_cateogira(c.CategoryID) AS 'cantidad'
FROM Categories AS c
GO

/*EJERCICIO 02. UDF Escalar con varias instrucciones
En este ejercicio se va a crear una UDF que permita calificar al empleado de acuerdo a un volumen de ventas.
Para calcular el total de ventas de un empleado se debe calcular la suma del total de las órdenes, el diagrama
mostrado nos ayuda a entender el conjunto de resultados.*/

--Para calcular el total de una orden se van a crear una UDF escalar
CREATE FUNCTION fdu_total_por_orden(@numero_orden INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		DECLARE @total_orden NUMERIC(9,2)
		SET @total_orden = (SELECT SUM((od.UnitPrice * od.Quantity) * (1-od.Discount))
							FROM [Order Details] AS od
							WHERE od.OrderID = @numero_orden)

		RETURN @total_orden
	END
GO

--Para calcular el tota de la orden N° 10248
SELECT dbo.fdu_total_por_orden(10248)
GO

--Para calcular el total de ventas de un empleado se deben sumar todos los totales de las órdenes 
CREATE FUNCTION fdu_total_ventas_por_empleado(@empleado_codigo INT)
RETURNS NUMERIC(9,2)
AS
	BEGIN
		DECLARE @total_ventas_empleado NUMERIC(9,2)
		SET @total_ventas_empleado = (SELECT SUM(dbo.fdu_total_por_orden(o.OrderID))	
										FROM Orders AS o
										WHERE o.EmployeeID = @empleado_codigo)

		RETURN @total_ventas_empleado
	END
GO

--Las ventas de los empleados se muestran en la siguiente consulta
SELECT e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS empleado, 
	   dbo.fdu_total_ventas_por_empleado(e.EmployeeID) AS total
FROM Employees AS e
ORDER BY total DESC
GO

/*Para calificar al empleado de acuerdo a las ventas se usarán los siguientes rangos: 
Menor a 100000: Regular
Hasta 200000: Gold
Más de 200000: Platiniums*/

--La fdu para la calificación es como sigue
CREATE OR ALTER FUNCTION fdu_califica_empleado_volumen_venta(@codigo_empleado INT)
RETURNS VARCHAR(9)
AS
	BEGIN
		DECLARE @total_ventas NUMERIC(9,2)
		DECLARE @calificacion VARCHAR(9)
		SET @total_ventas = (SELECT dbo.fdu_total_ventas_por_empleado(@codigo_empleado)
							 FROM Employees AS e
							 WHERE e.EmployeeID = @codigo_empleado)
		IF @total_ventas < 100000 
			BEGIN
				SET @calificacion = 'Regular'
			END
		ELSE IF @total_ventas < 200000
			BEGIN
				SET @calificacion = 'Gold'
			END
		ELSE
			BEGIN
				SET @calificacion = 'Platinium'
			END
		RETURN @calificacion
	END
GO

--Listado de los empleados y su calificación
SELECT e.EmployeeID, CONCAT_WS(' ', e.FirstName, e.LastName) AS empleado, 
	   dbo.fdu_total_ventas_por_empleado(e.EmployeeID) AS total,
	   dbo.fdu_califica_empleado_volumen_venta(e.EmployeeID) AS 'calificativo'
FROM Employees AS e
ORDER BY total DESC
GO

/*
Para que se pueda insertar una UDF escalar se debe cumplir las siguientes condiciones.

La UDF se escribe usando DECLARE y SET, SELECT, IF/ELSE, RETURN, UDF anidadas o usando EXISTS o ISNULL.
La UDF no invoca ninguna función intrínseca que dependa de la hora.
La UDF usa la cláusula Execute As Caller
La UDF no hace referencia a variables de tabla.
La consulta que invoca una UDF escalar no agrupa usando Group by.
La consulta que invoca una UDF escalar usando DISTINCT no contiene ORDER BY.
La UDF no se utiliza en la cláusula ORDER BY.
La UDF no se usa en una columna calculada
La UDF no se una en una definición de restricción CHECK.
La UDF no hace referencia a tipos definidos por el usuario.
La UDF no es una función de partición.
La UDF no contiene referencias a expresiones de tabla comunes (CTE).

Comprobación de si una UDF se puede insertar o no
Para todas las UDF escalares de SQL Server, la vista de catálogo sys.sql_modules incluye una propiedad denominada is_inlineable,
que indica si una UDF se puede insertar o no.
*/
--El listado de las fdu utilizadas en este artículo
SELECT *
FROM SYS.SQL_MODULES
WHERE definition LIKE 'Create function%'