/*-- PROCEDIMIENTOS ALMACENADOS CON PAR�METROS DE SALIDA --
Los procedimientos almacenados son bloques de c�digo reutilizable guardados en la base de datos que tienen 
un prop�sito. (Ver Procedimientos Almacenados)

Existen procedimientos almacenados que no tienen par�metros, es decir, no necesitan de ning�n valor para que 
se ejecuten, las tareas que realizan estos generalmente son sencillas.

PAR�METROS
- Los par�metros se usan para intercambiar datos entre las aplicaciones y los procedimientos almacenados o la 
  herramienta que ejecut� el procedimiento almacenado.
- Los par�metros de entrada permiten pasar un valor de datos al procedimiento almacenado.
- Los par�metros de salida permiten al procedimiento almacenado devolver un valor
- Los procedimientos almacenados devuelven un c�digo de retorno de tipo entero.
- El valor de retorno por defecto es CERO si no se establece expl�citamente un valor diferente
*/

USE Northwind
GO

/*EJERCICIO 01. Procedimiento almacenado que reporta el n�mero de productos de una determinada categor�a*/
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
devuelto por el par�metro de salida del procedimiento. Tomaremos como ejemlo la categor�a 3*/
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
valor devuelto por el par�metro de salida del procedimiento*/
DECLARE @cantidadPorComprar INT
EXECUTE sp_cantidad_productos_comprar_urgente @cantidadPorComprar OUTPUT
SELECT @cantidadPorComprar
GO
