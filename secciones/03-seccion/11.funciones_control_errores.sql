/*-- FUNCIONES PARA CONTROL DE ERRORES EN SQL SERVER --

Las funciones para el manejo de errores permiten conocer los par�metros que reporta un error, 
las funciones son las siguientes:

Funci�n				Descripci�n
-------------------------------------------------
ERROR_NUMBER()		Devuelve el n�mero de error.
ERROR_SEVERITY()	Devuelve la severidad del error.
ERROR_STATE()		Devuelve el estado del error.
ERROR_PROCEDURE()	Devuelve el nombre del procedimiento almacenado que ha provocado el error.
ERROR_LINE()		Devuelve el n�mero de l�nea en el que se ha producido el error.
ERROR_MESSAGE()		Devuelve el mensaje de error.
*/

/*EJERCICIO 01. El siguiente ejemplo muestra una divisi�n entre CERO, lo que arroja un error. Luego,
se muestran los valores de cada funci�n. Se utiliza la estructura tryCatch cuya explicaci�n est� al final 
de este art�culo */ 
BEGIN TRY
	DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
	SET @valor1 = 100
	SET @valor2 = 0
	SET @division = @valor1 / @valor2
	PRINT CONVERT(VARCHAR, @valor1) + '/' + CONVERT(VARCHAR, @valor2) + ' = ' + CONVERT(VARCHAR, @division)
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS 'N� de error', 
		   ERROR_SEVERITY() AS 'Severidad',
		   ERROR_STATE() AS 'estado', 
		   ERROR_PROCEDURE() AS 'procedimiento',
		   ERROR_LINE() AS 'N� l�nea',
		   ERROR_MESSAGE() AS 'mensaje'
END CATCH
GO

/*LA FUNCI�N @@ERROR
La funci�n @@ERROR almacena el n�mero de error producido por la �ltima sentencia TRANSACTSQL ejecutada, 
si no se ha producido ning�n error el valor de la funci�n es CERO. Se puede usar esta funci�n para
controlaro los errores usando una estructura IF
*/
/*EJERCICIO 02. El siguiente ejemplo muestra una divisi�n entre CERO, lo que arroja error, luego se da
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
--Probamos el mismo c�digo con el valor igual a 2. Se observa que muestra la divisi�n correcta, sin error