/*-- CONTROLANDO ERRORES EN SQLSERVER --

Al usar el lenguage Transact-SQL debemos tener en cuenta, como en cualquier lenguaje de programaci�n, 
que algunas instrucciones nos pueden dar errores debido a los valores de par�metros de entrada 
incorrectos o faltantes, ingresos de datos con tipos incorrectos, falta de datos en un procedimiento 
o funci�n definida por el usuario o de manera general en una transacci�n no finalizada de manera 
correcta.

Funciones para el manejo de errores

Las funciones para el manejo de errores permiten conocer los par�metros que reporta un error, 
las funciones son las siguientes:

ERROR_NUMBER()		Devuelve el n�mero de error.
ERROR_SEVERITY()	Devuelve la severidad del error.
ERROR_STATE()		Devuelve el estado del error.
ERROR_PROCEDURE()	Devuelve el nombre del procedimiento almacenado que ha provocado el error.
ERROR_LINE()		Devuelve el n�mero de l�nea en el que se ha producido el error.
ERROR_MESSAGE()		Devuelve el mensaje de error.
*/

/*EJERCICIO 01. El siguiente ejemplo muestra una divisi�n entre CERO, lo que arroja error, 
luego se muestran los valores de cada funci�n. Se utiliza la estructura Try Catch cuya explicaci�n 
est� al final de este art�culo.*/
BEGIN TRY
	DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
	SET @valor1 = 100
	SET @valor2 = 0
	SET @division = @valor1/@valor2
	PRINT 'La divisi�n no reporta error'
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS 'N� de error', ERROR_SEVERITY() AS 'severidad',
		   ERROR_STATE() AS 'estado', ERROR_PROCEDURE() AS 'procedimiento',
		   ERROR_LINE() AS 'N� l�nea', ERROR_MESSAGE() AS 'mensaje'
END CATCH
GO
/*
LA FUNCI�N @@ERROR
La funci�n @@ERROR almacena el n�mero de error producido por la �ltima sentencia Transact SQL ejecutada,
Si no se ha producido ning�n error el valor de la funci�n es CERO.
Se puede usar esta funci�n para controlar los errores usando una estructura If
*/

/*EJERCICIO 02. El siguiente ejemplo muestra una divisi�n entre CERO, lo que arroja error, 
luego se da consistencia al error con una estructura If*/
DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
SET @valor1 = 100
SET @valor2 = 0
SET @division = @valor1/@valor2
IF @@ERROR = 0 
	BEGIN
		PRINT 'El resultado es: ' + STR(@division)
		PRINT 'No hubo error'
	END
ELSE
	BEGIN
		PRINT 'Error al divir entre cero'
	END
GO
--Probamos el mismo c�digo con el valor2 igual a 2
DECLARE @valor1 NUMERIC(9,2), @valor2 NUMERIC(9,2), @division NUMERIC(9,2)
SET @valor1 = 100
SET @valor2 = 2
SET @division = @valor1/@valor2
IF @@ERROR = 0 
	BEGIN
		PRINT 'El resultado es: ' + STR(@division)
		PRINT 'No hubo error'
	END
ELSE
	BEGIN
		PRINT 'Error al divir entre cero'
	END
GO

/*
NIVELES DE SEVERIDAD DEL ERROR
Al cometer alg�n error en SQL Server se presentan mensajes dentro de los cuales aparece el nivel de 
severidad del mismo, en esta tabla se presentan los 25 diferentes niveles de gravedad del error.

0-9		Mensajes informativos que devuelven informaci�n de estado o informan sobre errores que no 
		son graves. El Motor de base de datos no muestra errores del sistema con gravedades de 0 a 9.

10		Mensajes informativos que devuelven informaci�n de estado o informan sobre errores que no 
		son graves. Por razones de compatibilidad, el Motor de base de datos convierte la gravedad 
		10 en gravedad 0 antes de devolver la informaci�n de errores a la aplicaci�n que hace la llamada.

11-16	Indica errores que pueden ser corregidos por el usuario.

11		Indica que un objeto o una entidad determinados no existen.

12		Una gravedad especial para consultas que no utilizan bloqueo debido a sugerencias de consulta 
		especiales. En algunos casos, las operaciones de lectura realizadas por estas instrucciones 
		podr�an producir datos incoherentes, ya que no se adoptan bloqueos para garantizar la 
		coherencia.

13		Indica errores de interbloqueo de transacciones.

14		Indica errores relacionados con la seguridad, como es el caso de permisos denegados.

15		Indica errores de sintaxis en el comando Transact-SQL .

16		Indica errores generales que pueden ser corregidos por el usuario.

17-19	Indica errores de software que no pueden ser corregidos por el usuario. Informe al administrador 
		del sistema sobre el problema.

17		Indica que la instrucci�n ha hecho que SQL Server se quede sin recursos (como, por ejemplo, 
		memoria, bloqueos o espacio en disco para la base de datos) o ha superado alguno de los 
		l�mites establecidos por el administrador del sistema.

18		Indica un problema en el software de Motor de base de datos pero la instrucci�n completa su 
		ejecuci�n y la conexi�n con la instancia del Motor de base de datos se mantiene. 
		El administrador del sistema debe ser informado cada vez que se produce un mensaje con un 
		nivel de gravedad 18.

19		Indica que se ha superado un l�mite de Motor de base de datos no configurable y el proceso por 
		lotes actual ha finalizado. Los mensajes de error con nivel de gravedad 19 o superior detienen 
		la ejecuci�n del lote actual. Los errores de nivel de gravedad 19 son poco frecuentes y deben 
		ser corregidos por el administrador del sistema o por el proveedor principal de asistencia 
		t�cnica. P�ngase en contacto con el administrador del sistema cuando se produzca un mensaje 
		con nivel de gravedad 19. Los mensajes de error con nivel de gravedad entre 19 y 25 se escriben 
		en el registro de errores.

20-24	Indica problemas del sistema y son errores irrecuperables, lo que significa que ya no est� en 
		ejecuci�n la tarea de Motor de base de datos que est� ejecutando una instrucci�n o lote. 
		La tarea registra informaci�n sobre lo acontecido y, a continuaci�n, finaliza. En la mayor�a 
		de los casos, puede que tambi�n finalice la conexi�n de la aplicaci�n a la instancia del Motor 
		de base de datos . Si esto ocurre, dependiendo del problema, la aplicaci�n podr�a no conseguir 
		volver a conectarse.

		Los mensajes de error incluidos en este intervalo pueden afectar a todos los procesos que tienen 
		acceso a los datos de la misma base de datos y pueden indicar que una base de datos u objeto 
		est� da�ado. Los mensajes de error con nivel de gravedad entre 19 y 24 se escriben en el 
		registro de errores.

20		Indica que una instrucci�n ha encontrado un problema. Puesto que el problema ha afectado solo a 
		la tarea actual, no es probable que la propia base de datos haya sido da�ada.

21		Indica que una instrucci�n ha encontrado un problema. Puesto que el problema ha afectado solo
		a la tarea actual, no es probable que la propia base de datos haya sido da�ada.

22		Indica que la tabla o �ndice especificado en el mensaje ha sido da�ado por un problema de software 
		o hardware.

		Los errores de nivel de gravedad 22 se producen en raras ocasiones. Si se produce uno de ellos, 
		ejecute DBCC CHECKDB para determinar si hay otros objetos de la base de datos da�ados. 
		Es posible que el problema se encuentre solo en la cach� del b�fer y no en el propio disco. 
		Si es as�, al reiniciar la instancia del Motor de base de datos se corregir� el problema. 
		Para seguir trabajando, deber� volver a conectarse a la instancia del Motor de base de datos; 
		en caso contrario, utilice DBCC para solucionar el problema. En algunas ocasiones, puede que 
		tenga que restaurar la base de datos.

		Los errores de nivel de gravedad 22 se producen en raras ocasiones. Si se produce uno de ellos, 
		ejecute DBCC CHECKDB para determinar si hay otros objetos de la base de datos da�ados. 
		Es posible que el problema se encuentre solo en la cach� del b�fer y no en el propio disco. 
		Si es as�, al reiniciar la instancia del Motor de base de datos se corregir� el problema. 
		Para seguir trabajando, deber� volver a conectarse a la instancia del Motor de base de datos; 
		en caso contrario, utilice DBCC para solucionar el problema. En algunas ocasiones, puede que 
		tenga que restaurar la base de datos.

		Si al reiniciar la instancia del Motor de base de datos no se corrige el problema, el problema 
		estar� en el disco. Algunas veces se puede resolver si se destruye el objeto especificado en 
		el mensaje de error. Por ejemplo, si el mensaje le indica que la instancia del Motor de base 
		de datos ha encontrado una fila con longitud 0 en un �ndice no cl�ster, elimine el �ndice y 
		vuelva a generarlo.

23		Indica que se sospecha de la integridad de toda la base de datos debido al da�o causado por 
		un problema de hardware o software.

		Los errores de nivel de gravedad 23 se producen en raras ocasiones. Si se produce alguno, 
		ejecute DBCC CHECKDB para determinar la magnitud de los da�os. Es posible que el problema 
		se encuentre solo en la cach� y no en el propio disco. Si es as�, al reiniciar la instancia 
		del Motor de base de datos se corregir� el problema. Para seguir trabajando, deber� volver 
		a conectarse a la instancia del Motor de base de datos; en caso contrario, utilice DBCC para 
		solucionar el problema. En algunas ocasiones, puede que tenga que restaurar la base de datos.

24		Indica un error en los medios. Puede que el administrador del sistema tenga que restaurar 
		a base de datos. Puede que tambi�n tenga que llamar al distribuidor de hardware.


MENSAJES DE ERROR
SQL Server tienen una vista de cat�logo con los mensajes definidos por defecto, la vista es sys.messages,
a la cual se le pueden a�adir mensajes de error con sus par�metros respectivos usando el procedimiento 
almacenado sp_addmessage.

El procedimiento almacenado sp_addmessage permite agregar a la vista de cat�logo sys.messages mensajes 
de error definidos por el usuario con niveles de gravedad de 1 a 25. Use Raiserror para utilizar los 
mensajes de error definidos por el usuario.

RAISERROR puede hacer referencia a un mensaje de error definidos por el usuario almacenados en la 
vista de cat�logo sys.messages o puede generar un mensaje din�micamente. Si se usa el mensaje de error 
definido por el usuario de sys.messages mientras se genera un error, la gravedad especificada por 
RAISERROR reemplazar� a la gravedad especificada en sys.messages.

Para visualizar los mensajes de la vista de cat�logo Sys.messages puede ejecutar la siguiente instrucci�n.
*/
SELECT * 
FROM SYS.MESSAGES
GO

/*
EL PROCEDIMIENTO SP_ADDMESSAGE
Permite agregar un mensaje de error definido por el usuario a la vista de cat�logo sys.messages

Sintaxis:
sp_addmessage [ @msgnum= ] msg_id , [ @severity= ] severidad , [ @msgtext= ] �mensaje�
[ , [ @lang= ] �languaje� ]

Donde:
[ @msgnum= ] msg_id Especifica el Id del mensaje, se pueden iniciar en 50001, el valor m�ximo 
es 2,147,483,647.
[ @severity= ] severidad Indica el nivel de gravedad del error, puede ser un valor entre 1 y 25.
[ @msgtext= ] �mensaje� Especifica el mensaje definido por el usuario.
[ @lang= ] �languaje� Especifica el lenguaje.
*/

/*EJERCICIO 03. Agregar el mensaje para indicar que un porcentaje de descuento puede ser entre 0 y 25%.
Note que es necesario insertar el mensaje para el idioma ingl�s y as� poder agregar el mensaje para espa�ol.*/
USE MASTER
GO

EXECUTE SP_ADDMESSAGE 50001, 16, 'The discount percentage should be between 0 and 25%', 'us_english', false, replace
GO

EXECUTE SP_ADDMESSAGE 50001, 16, 'El porcentaje de descuento debe ser entre 0 y 25%', 'Spanish', false, replace
GO

/*EJERCICIO 04. Agregar el mensaje para indicar que un precio debe ser CERO o mayor.
Note que es necesario insertar el mensaje para el idioma ingl�s y as� poder agregar el 
mensaje para espa�ol*/
USE MASTER
GO

EXECUTE SP_ADDMESSAGE 50002, 16, 'The price should be 0 or greater', 'us_english', false, replace
GO

EXECUTE SP_ADDMESSAGE 50002, 16, 'El precio debe ser 0 o mayor�', 'Spanish', false, replace
GO

/*
Procedimientos almacenados para los mensajes de error definidos por el usuario

Procedimiento almacenado sp_altermessage

Modifica el estado de los mensajes definidos por el usuario o del sistema en una instancia del motor de base de datos de SQL Server.
Sintaxis:

sp_altermessage [ @message_id = ] message_number ,[ @parameter = ]�write_to_log�
,[ @parameter_value = ]�value�

Donde:
[ @message_id = ] message_number Especifica el Id del mensaje
[ @parameter = ]�write_to_log� Especifica si se va a escribir en el log de Windows
[ @parameter_value = ]�value� Se utiliza con @parameter para indicar que el error debe escribirse en el 
registro de aplicaci�n de Microsoft Windows
*/

/*EJERCICIO 05. El siguiente ejemplo permite especificar que el mensaje de error creado se escriba
en el log de windows*/
SP_ALTERMESSAGE 50001, 'with_log', 'true'
GO

/*
Procedimiento almacenado sp_dropmessage

Elimina un mensaje de error definido por el usuario
Sintaxis:

sp_dropmessage [ @msgnum = ] message_number [ , [ @lang = ] �language� ]

Donde:
[ @msgnum = ] message_number Especifica el Id del mensaje
[ @lang = ] �language� Especifica el lenguaje.
*/

/*EJERCICIO 06. El siguiente c�digo elimina el mensaje creado con id 50001*/
SP_DROPMESSAGE 50001, 'Spanish'
GO

/*
CONTROLANDO LOS ERRORES

USANDO TRY CATCH
- Permite implementar el manejo de errores para Transact-SQL, esta estructura es similar a la de los 
  lenguajes de programaci�n.
- La sentencias Transact-SQL que pueden dar error se incluyen en el bloque TRY. Si se produce un error 
  en el bloque TRY,  el control se pasa a otro grupo de sentencias incluidas en un bloque CATCH.

Sintaxis:

BEGIN TRY
	Instrucciones Transact � SQL que pueden dar error
END TRY
BEGIN CATCH
	Instrucciones Transact � SQL para manejar el error
END CATCH
*/
/*EJERCICIO 07. Usando la base de datos Northwind, listar los registros de la tabla Ventas, tenga en 
cuenta que la tabla no existe.
El select se incluir� en un procedimiento almacenado.*/
USE Northwind
GO

--El procedimiento almacenado
CREATE PROCEDURE sp_lista_ventas
AS
	SELECT * FROM ventas
GO

--Ahora ejecutamos el procedimiento almacenado
BEGIN TRY
	EXECUTE sp_lista_ventas
END TRY
BEGIN CATCH
	SELECT ERROR_NUMBER() AS [N� error], ERROR_MESSAGE() AS [Mensaje]
END CATCH