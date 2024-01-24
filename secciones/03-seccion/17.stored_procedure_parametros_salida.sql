/*-- PROCEDIMIENTOS ALMACENADOS CON PARÁMETROS DE SALIDA --
Los procedimientos almacenados son bloques de código reutilizable guardados en la base de datos que tienen 
un propósito. (Ver Procedimientos Almacenados)

Existen procedimientos almacenados que no tienen parámetros, es decir, no necesitan de ningún valor para que 
se ejecuten, las tareas que realizan estos generalmente son sencillas.

PARÁMETROS
- Los parámetros se usan para intercambiar datos entre las aplicaciones y los procedimientos almacenados o la 
  herramienta que ejecutó el procedimiento almacenado.
- Los parámetros de entrada permiten pasar un valor de datos al procedimiento almacenado.
- Los parámetros de salida permiten al procedimiento almacenado devolver un valor
- Los procedimientos almacenados devuelven un código de retorno de tipo entero.
- El valor de retorno por defecto es CERO si no se establece explícitamente un valor diferente
*/

USE Northwind
GO

/*EJERCICIO 01. Procedimiento almacenado que reporta el número de productos de una determinada categoría*/
CREATE PROCEDURE sp_categorias_cantidad_productos(
	@categoria_codigo INT,
	@cantidad_productos NUMERIC(9,2) OUTPUT
)
AS
	BEGIN
		SELECT * 
		FROM Products 
		WHERE CategoryID = @categoria_codigo

		SET @cantidad_productos = @@ROWCOUNT
	END
GO

/*Para ejecutar el procedimiento debemos crear antes una variable que permita capturar el valor
devuelto por el parámetro de salida del procedimiento. Tomaremos como ejemlo la categoría 3*/
DECLARE @cantidad INT
EXECUTE sp_categorias_cantidad_productos 3, @cantidad OUTPUT
SELECT @cantidad
GO

/*EJERCICIO 02. Procedimiento almacenado que reporta la cantidad de productos que es necesario comprar
con urgencia. (Productos cuyas unidades en stock es menor a las unidades en orden)*/
CREATE PROCEDURE sp_cantidad_productos_comprar_urgente(@cantidad_productos NUMERIC(9,2) OUTPUT)
AS
	BEGIN
		SELECT * 
		FROM Products 
		WHERE UnitsInStock < UnitsOnOrder

		SET @cantidad_productos = @@ROWCOUNT
	END
GO

/*Para ejecutar el procedimiento debemos crear antes una variable que permita capturar el 
valor devuelto por el parámetro de salida del procedimiento*/
DECLARE @cantidadPorComprar INT
EXECUTE sp_cantidad_productos_comprar_urgente @cantidadPorComprar OUTPUT
SELECT @cantidadPorComprar
GO
