/*-- FUNCIONES PARA CONTROL DE ERRORES EN SQL SERVER --

Las funciones para el manejo de errores permiten conocer los parámetros que reporta un error, 
las funciones son las siguientes:

Función				Descripción
-------------------------------------------------
ERROR_NUMBER()		Devuelve el número de error.
ERROR_SEVERITY()	Devuelve la severidad del error.
ERROR_STATE()		Devuelve el estado del error.
ERROR_PROCEDURE()	Devuelve el nombre del procedimiento almacenado que ha provocado el error.
ERROR_LINE()		Devuelve el número de línea en el que se ha producido el error.
ERROR_MESSAGE()		Devuelve el mensaje de error.
*/

/*EJERCICIO 01. El siguiente ejemplo muestra una división entre CERO, lo que arroja un error. Luego,
se muestran los valores de cada función. Se utiliza la estructura tryCatch cuya explicación está al final 
de este artículo */ 
BEGIN TRY
	DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
	SET @valor1 = 100
	SET @valor2 = 0
	SET @division = @valor1 / @valor2
	PRINT CONVERT(VARCHAR, @valor1) + '/' + CONVERT(VARCHAR, @valor2) + ' = ' + CONVERT(VARCHAR, @division)
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS 'N° de error', 
		   ERROR_SEVERITY() AS 'Severidad',
		   ERROR_STATE() AS 'estado', 
		   ERROR_PROCEDURE() AS 'procedimiento',
		   ERROR_LINE() AS 'N° línea',
		   ERROR_MESSAGE() AS 'mensaje'
END CATCH
GO

/*LA FUNCIÓN @@ERROR
La función @@ERROR almacena el número de error producido por la última sentencia TRANSACTSQL ejecutada, 
si no se ha producido ningún error el valor de la función es CERO. Se puede usar esta función para
controlaro los errores usando una estructura IF
*/
/*EJERCICIO 02. El siguiente ejemplo muestra una división entre CERO, lo que arroja error, luego se da
consistencia al error con una estructura if*/
DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
SET @valor1 = 100
SET @valor2 = 0
SET @division = @valor1 / @valor2

IF @@ERROR = 0 --Sin error
	BEGIN
		PRINT CONVERT(VARCHAR, @valor1) + '/' + CONVERT(VARCHAR, @valor2) + ' = ' + CONVERT(VARCHAR, @division)
	END
ELSE
	BEGIN
		PRINT 'Error al dividir entre cero'
	END
GO
--Probamos el mismo código con el valor igual a 2. Se observa que muestra la división correcta, sin error